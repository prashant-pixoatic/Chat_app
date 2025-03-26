class ChatChannel < ApplicationCable::Channel
  include Rails.application.routes.url_helpers

  def subscribed
    if params[:group_id].present?
      stream_from "group_chat_#{params[:group_id]}"
    elsif params[:receiver_id]
      stream_from "private_chat_#{params[:user_id]}_#{params[:receiver_id]}"
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    sender_id = params[:user_id].to_i

    if data["data"].present? && data["data"]["audio_file"].present?
      data_payload = data["data"]
      voice_message = VoiceMessage.new(sender_id: sender_id, group_id: data_payload["group_id"], receiver_id: data_payload["receiver_id"])
      audio_data = Base64.decode64(data_payload["audio_file"])
      voice_message.audio_file.attach(io: StringIO.new(audio_data), filename: "voice_message_#{Time.now.to_i}.wav", content_type: "audio/wav")

      if voice_message.save
        if voice_message.group_id.present?
          broadcast_message("group_chat_#{voice_message.group.id}", voice_message)
        elsif voice_message.receiver_id.present?
          broadcast_message("private_chat_#{voice_message.sender_id}_#{voice_message.receiver_id}", voice_message)
          broadcast_message("private_chat_#{voice_message.receiver_id}_#{voice_message.sender_id}", voice_message)
        end
      end
    else
      if data["receiver_id"].present?
        message = PrivateMessage.create(sender_id: sender_id, receiver_id: data["receiver_id"], content: data["message"])
        broadcast_message("private_chat_#{sender_id}_#{data['receiver_id']}", message)
        broadcast_message("private_chat_#{data['receiver_id']}_#{sender_id}", message)
      elsif data["group_id"].present?
        message = GroupMessage.create(user_id: sender_id, group_id: data["group_id"], content: data["message"])
        broadcast_message("group_chat_#{data['group_id']}", message)
      end
    end
  end

  private

  def broadcast_message(channel, message)
    ActionCable.server.broadcast(channel, { message: render_message(message) })
  end

  def render_message(message)
    if message.is_a?(GroupMessage)
      ApplicationController.renderer.render(partial: "home/group", locals: { message: message })
    else
      ApplicationController.renderer.render(partial: "home/message", locals: { message: message })
    end
  end
end
