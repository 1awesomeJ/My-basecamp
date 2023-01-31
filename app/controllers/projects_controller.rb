class ProjectsController < ApplicationController
  before_action :set_project, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :authorized_user, only: [:edit, :update, :destroy]
  # GET /projects or /projects.json
  def index
    @projects = Project.all
  end

  def mine
    @projects = Project.all
  end

  # GET /projects/1 or /projects/1.json
  def show
      @project = Project.find(params[:id])
  end

  # GET /projects/new
  def new
    #project = Project.new
    @project = current_user.projects.build
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects or /projects.json
  def create
    #project = Project.new(project_params)
    @project = current_user.projects.build(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to project_url(@project), notice: "Project was successfully created." }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1 or /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params.reject { |k| k["uploads"] })
        if project_params[:uploads].present?
        project_params[:uploads].each do |attachment|
            @project.uploads.attach(attachment)
          end
        end
        format.html { redirect_to project_url(@project), notice: "Project was successfully updated." }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1 or /projects/1.json
  def destroy
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url, notice: "Project was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def delete_attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
    @attachment.purge
    redirect_back fallback_location: projects_path, notice: "file removed successfully"
  end


  def authorized_user

    if current_user == @project.user || current_user.admin == true
      @k = true
    else
      @k = false
    end
    #friend = current_user.projects.find_by(id: params[:id])
    redirect_to projects_path, alert: "NOT AUTHORIZED!! You can only modify projects you created" if @k == false
  end


  private
    # Use callbacks to share common setup or constraints between actions.

    def set_project
      @project = Project.find(params[:id])
      end

    # Only allow a list of trusted parameters through.
    def project_params
      params.require(:project).permit(:Name, :Description, :user_id, uploads: [])
    end
end
