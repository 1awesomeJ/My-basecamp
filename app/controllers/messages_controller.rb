class MessagesController < ApplicationController
  before_action :set_message, only: %i[ show edit update destroy ]
  before_action :authorized_user, only: [:destroy]
  before_action :right_user, only: [:edit]
  # GET /messages or /messages.json
  def index
    @messages = Message.all
  end

  # GET /messages/1 or /messages/1.json
  def show
  end

  # GET /messages/new
  def new
    @room = Room.find(params[:room_id])
    #@message = Message.new(message_params)
    @message = @room.messages.new
  end

  # GET /messages/1/edit
  def edit
    @room = Room.find(params[:room_id])
    @message = Message.find(params[:id])
  end

  # POST /messages or /messages.json
  def create
    @room = Room.find(params[:room_id])
    #@message = Message.new(message_params)
    @message = @room.messages.new(message_params)
    #@message.user = current_user
    if @message.save
        redirect_to @room, notice:"Message has been successfully posted"
    else
      render :new
  end

#    respond_to do |format|
 #     if @message.save
  #      format.html { redirect_to message_url(@message), notice: "Message was successfully created." }
   #     format.json { render :show, status: :created, location: @message }
    #  else
     #   format.html { render :new, status: :unprocessable_entity }
      #  format.json { render json: @message.errors, status: :unprocessable_entity }
     # end
    #end
  end

  # PATCH/PUT /messages/1 or /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to message_url(@message), notice: "Message was successfully updated." }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1 or /messages/1.json
  def destroy

    @message.destroy

    respond_to do |format|
      format.html { redirect_to rooms_path, notice: "Message was successfully destroyed." }
      format.json { head :no_content }
    end
  end

def authorized_user

    if current_user == @message.user || current_user.admin == true
      @k = true
    else
      @k = false
    end
    redirect_to rooms_path, alert: "NOT AUTHORIZED!! Only admin or OP can delete a message" if @k == false
  end

def right_user

    if current_user == @message.user
      @k = true
    else
      @k = false
    end
    #friend = current_user.projects.find_by(id: params[:id])
    redirect_to rooms_path, alert: "NOT AUTHORIZED!! You can only edit messages you created" if @k == false
  end



  private
    # Use callbacks to share common setup or constraints between actions.
   def set_message
     @message = Message.find(params[:id])
   end
    # Only allow a list of trusted parameters through.
    def message_params
      params.require(:message).permit(:content, :user_id)
    end
end
