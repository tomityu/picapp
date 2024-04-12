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
        user.save!
        client.reply_message(reply_token, { type: :text, text: '友だち追加ありがとう！プロフィール取得したよ' })
    end

    def reply_message(client, reply_token, message, uid)
        case message[:type]
        when 'text'
            client.reply_message(reply_token, { type: :text, text: 'テキストを受診！' })
        when 'image'
            picture = save_picture(client, uid, message[:id])
            broadcast_picture(picture) if picture.present?
            client.reply_message(reply_token, { type: :text, text: '画像を受信！' })
        end
    end

    def save_picture(client, uid, image_id)
        user = User.find_by(uid: uid)
        return if user.nil?

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

    def broadcast_picture(picture)
        path = Rails.application.routes.url_helpers.rails_representation_url(picture.file.variant({}), only_path: true)
        ActionCable.server.broadcast('picture_channel', { file_path: url_for(picture.preview) })
    end

    def line_client
        Line::Bot::Client.new { |config|
            config.channel_secret = ENV['MESSAGING_CHANNEL_SECRET']
            config.channel_token = ENV['MESSAGING_CHANNEL_TOKEN']
        }
    end
end
