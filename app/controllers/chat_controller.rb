class ChatController < ApplicationController
  def create
    channel_id = params[:channel_id]
    message = params[:message]
    username = params[:username]
    ActionCable.server.broadcast("chat_channel_#{channel_id}", { username: username, message: message })
    head :ok
  end
end
