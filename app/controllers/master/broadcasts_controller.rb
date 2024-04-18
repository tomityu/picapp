class Master::BroadcastsController < ApplicationController
    before_action :authenticate_master_user!

    def new
    end

    def create
        client = line_client
        client.multicast(User.all.map(&:uid), { type: :text, text: params[:message] })
        redirect_to master_dashboard_path
    end

    private

    def line_client
        Line::Bot::Client.new { |config|
            config.channel_secret = ENV['MESSAGING_CHANNEL_SECRET']
            config.channel_token = ENV['MESSAGING_CHANNEL_TOKEN']
        }
    end
end
