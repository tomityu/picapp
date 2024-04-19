class Api::LineMessagingController < ApplicationController
    require 'line/bot'

    def create
        client = line_client
        params[:events].each do |event|
            case event[:type]
            when 'follow'
                reply_follow_message(client, event[:replyToken], event[:source][:userId])
            when 'message'
                reply_message(client, event[:replyToken], event[:message], event[:source][:userId])
            end
        end
        head :ok
    end

    private

    def reply_follow_message(client, reply_token, uid)
        res = JSON.parse(client.get_profile(uid).body)
        user = User.find_or_initialize_by(uid: uid)
        user.name = res['displayName']
        user.image_url = res['pictureUrl']
        user.email = "#{uid}@example.com"
        user.password = SecureRandom.base64(10)
        user.save!
        client.reply_message(reply_token, { type: :text, text: build_welcome_message })
    end

    def reply_message(client, reply_token, message, uid)
        case message[:type]
        when 'text'
            client.reply_message(reply_token, { type: :text, text: build_text_response })
        when 'image'
            user = User.find_by(uid: uid)
            return if user.nil?

            picture = save_picture(client, user, message[:id])
            if picture.present?
                broadcast_picture(user, picture)
                client.reply_message(reply_token, { type: :text, text: build_image_response })
            end
        end
    end

    def save_picture(client, user, image_id)
        file = client.get_message_content(image_id).body
        preview = client.get(
            'https://api-data.line.me/v2',
            "/bot/message/#{image_id}/content/preview",
            { Authorization: "Bearer #{ENV['MESSAGING_CHANNEL_TOKEN']}" }
        ).body
        picture = user.pictures.new
        picture.file.attach(io: StringIO.new(file), filename: image_id, content_type: 'image/jpg').save!
        picture.preview.attach(io: StringIO.new(preview), filename: image_id, content_type: 'image/jpg').save!
        picture
    end

    def broadcast_picture(user, picture)
        path = Rails.application.routes.url_helpers.rails_representation_url(picture.file.variant({}), only_path: true)
        ActionCable.server.broadcast('picture_channel', { user_name: user.name, user_image: user.image_url, file_path: url_for(picture.file) })
    end

    def line_client
        Line::Bot::Client.new { |config|
            config.channel_secret = ENV['MESSAGING_CHANNEL_SECRET']
            config.channel_token = ENV['MESSAGING_CHANNEL_TOKEN']
        }
    end

    def build_welcome_message
        <<~message.chomp
            友達に追加してくれてありがとう🐾
            ココちゃんだよ
            今日は富田家 今井家の結婚披露宴に遊びに来てるんだ
            なにか手伝わされそうな予感…
            詳しくは新郎からの説明をまっててね
        message
    end

    def build_image_response
        messages = [
            '写真を受け取ったよ！ありがとう🐾',
            'いい写真だね〜 もっとちょうだい🔥',
            '👍',
            '写真撮るの じょうず📸'
        ]
        messages.sample
    end

    def build_text_response
        messages = [
            'うん',
            'そうなんだ🐾',
            'なるほどね💡',
            'にゃ〜',
            "ERROR status:418\nI am a teapot, so I cannot answer that request. If you would like a refill of a drink, please ask the staff at the venue."
        ]
        messages.sample
    end
end
