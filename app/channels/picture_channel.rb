class PictureChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'picture_channel'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
