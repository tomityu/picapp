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
            res = client.get_message_content(message[:id])
            p '@@@@@@@@@@@@@@@@@'
            p res.each_header.to_h
            save_picture(uid, message[:id], res.body)
            client.reply_message(reply_token, { type: :text, text: '画像を受信！' })
        end
    end

    def save_picture(uid, image_id, file)
        user = User.find_by(uid: uid)
        return if user.nil?

        user.pictures.new.file.attach(io: StringIO.new(file), filename: image_id, content_type: 'image/jpg').save!
    end

    def line_client
        Line::Bot::Client.new { |config|
            config.channel_secret = ENV['MESSAGING_CHANNEL_SECRET']
            config.channel_token = ENV['MESSAGING_CHANNEL_TOKEN']
        }
    end
end
