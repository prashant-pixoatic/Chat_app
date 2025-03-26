class GroupMessagesController < ApplicationController
    
    def new
        @message = GroupMessage.new
    end
    # def create
    #     @group = Group.find(params[:group_id])
    #     @message = @group.group_messages.new(content: params[:content], user: current_user)
    #     if @message.save
    #         ActionCable.server.broadcast("group_chat_#{@group.id}", {message: render_message(@message)})
    #         redirect_to group_group_message_path(@group)
    #     else
    #         render :new
    #     end
    # end
    # private

    # def render_message(message)
    #   ApplicationController.renderer.render(partial: "home/message", locals: { message: message })
    # end
end

