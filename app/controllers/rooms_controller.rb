class RoomsController < ApplicationController
  before_action :set_room, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :authorized_user, only: [:edit, :update, :destroy, :create]


  # GET /rooms or /rooms.json
  def index
    @rooms = Room.all
  end

  # GET /rooms/1 or /rooms/1.json
  def show
  end

  # GET /rooms/new
  def new
    @room = current_user.rooms.build
  end

  # GET /rooms/1/edit
  def edit
  end

  # POST /rooms or /rooms.json
  def create
    @room = current_user.rooms.build(room_params)

    respond_to do |format|
      if @room.save
        format.html { redirect_to room_url(@room), notice: "Thread was successfully created." }
        format.json { render :show, status: :created, location: @room }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rooms/1 or /rooms/1.json
  def update
    respond_to do |format|
      if @room.update(room_params)
        format.html { redirect_to room_url(@room), notice: "Thread was successfully updated." }
        format.json { render :show, status: :ok, location: @room }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rooms/1 or /rooms/1.json
  def destroy
    @room.destroy

    respond_to do |format|
      format.html { redirect_to rooms_url, notice: "Thread was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def authorized_user

    if current_user.admin == true
      @k = true
    else
      @k = false
    end
    redirect_to rooms_path, alert: "NOT AUTHORIZED!! Only an admin can create a thread" if @k == false
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def room_params
      params.require(:room).permit(:name, :user_id)
    end
end
