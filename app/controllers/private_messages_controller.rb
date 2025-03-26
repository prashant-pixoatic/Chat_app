class PrivateMessagesController < ApplicationController

    def show
        @receiver = User.find(params[:id])
        @user_id = current_user.id
        @private_messages = PrivateMessage.where(sender: @user_id, receiver: @receiver).or(PrivateMessage.where(sender: @receiver, receiver: current_user)).order(:created_at)
        @voice_messages = VoiceMessage.where(sender: @user_id, receiver: @receiver).or(VoiceMessage.where(sender: @receiver, receiver: current_user)).order(:created_at)
        @messages = (@private_messages + @voice_messages).sort_by(&:created_at)
    end
    def new
        @message = PrivateMessage.new
    end
    # def create
    #     @receiver = User.find(params[:receiver_id])
    #     @message = PrivateMessage.new(content: params[:content], sender: current_user, receiver: @receiver)
    #     if @message.save
    #         ActionCable.server.broadcast("private_chat_#{current_user.id}_#{@receiver.id}", {message: render_message(@message)})
    #         redirect_to private_message_path(@receiver)
    #     else
    #         render :new
    #     end
    # end
    # private

    # def render_message(message)
    #   ApplicationController.renderer.render(partial: "home/message", locals: { message: message })
    # end
end
