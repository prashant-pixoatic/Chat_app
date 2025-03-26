class GroupsController < ApplicationController

    def new
        @group = Group.new
    end
    def create
        @group = Group.new(group_params)
        if @group.save
            @group.users << current_user
            redirect_to root_path
        else
            render :new
        end
    end

    def add_user
        @group = Group.find(params[:id])
        @user = User.find(params[:group][:user_id])
        @group.users << @user unless @group.users.include?(@user)
        redirect_to root_path
    end

    def show
        @group = Group.find(params[:id])
        @user_id = current_user.id
        @group_messages = @group.group_messages.order(:created_at)
        @voice_messages = VoiceMessage.where(group: @group).order(:created_at)
        @messages = (@group_messages + @voice_messages).sort_by(&:created_at)
    end

    private
    def group_params
        params.require(:group).permit(:name)
    end
end
