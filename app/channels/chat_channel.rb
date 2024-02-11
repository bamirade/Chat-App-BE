class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_channel_#{params[:channel_id]}"
  end

  def receive(data)
    ActionCable.server.broadcast("chat_channel_#{params[:channel_id]}", data)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
