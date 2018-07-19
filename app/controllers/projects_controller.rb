class ProjectsController < ApplicationController
  before_action :log_impression, :only=> [:show]
  before_action :set_project, only: [:show, :edit, :update, :destroy, :create_comment]

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.all
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def create_comment
    @comment = ProjectComment.create(project_id: @project.id, comment_contents: params[:comment_contents])
  end
  
  def update_comment
    @comment = ProjectComment.find(params[:projectComment_id])
    @comment.update(comment_contents: params[:comment_contents])
  end
  
  def destroy_comment
    @comment = ProjectComment.find(params[:projectComment_id]).destroy
  end
  
  def upload_image
    @image = Image.create(image_path: params[:upload][:image])
    render json: @image
  end
  
  def search_skills
    respond_to do |format|
      if params[:tech].strip.empty?
        format.js {render 'empty'} 
      else
        @skills = Skill.where("skill_contents Like ?","#{params[:tech]}%")
        format.js {render 'search_skill'}
      end
    end
  end
  
  def log_impression
      @hit_post = Project.find(params[:id])
      # this assumes you have a current_user method in your authentication system
      @hit_post.impressions.create(ip_address: request.remote_ip, user_id: 4)
  end
  
  def index
    @projects = Project.order("impressions_count DESC")
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:project_title, :project_contents, :project_people, :project_start, :project_end, :image_path)
    end
end