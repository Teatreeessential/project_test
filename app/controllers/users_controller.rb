class UsersController < ApplicationController
  # before_action :set_user, only: [:show, :edit, :update, :destroy]
    helper_method :search_user_skill
  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end
  
  #모든 유저 리스트
  #유저 검색
  def list
   @users = User.all
     unless params[:skill].nil? and params[:category].nil?
      skills = params[:skill].split(",")  
      categories = params[:category].split(",")
      skill_users = Skill.where(skill_contents: skills).collect {|skill| skill.users}.flatten
      category_users = Category.where(category_contents: categories).collect {|cate| cate.users}.flatten
      @users = skill_users.concat(category_users).uniq 
      p @users
    end
  end
  
 
  
  #깃헙에서 받아온 자료 핸들링
  def github
    i=0
    result_skill= Hash.new
    start = []
    # start.push({"css"=>5000,"java"=>3245,"javascript"=>3858,"sql" =>8485})
    # start.push({"css"=>5000,"java"=>3245,"javascript"=>3858,"sql" =>349})
    # start.push({"css"=>5000,"java"=>3245,"javascript"=>3858,"sql" =>3004})
    if session[:github_language].nil?
        puts "세션에 값이 없습니다 현재는"
        response=RestClient.get('https://api.github.com/users/Teatreeessential/repos',
                                headers={Authorization:'깃헙 인증 코드를 올려주세요'});
        ##git hub으로 부터 값을 가져온다.
        JSON.parse(response).each do |response| 
          languages = RestClient.get(response['languages_url'],
                                  headers={Authorization:'깃헙 인증 코드를 올려주세요'});
          start.push(JSON.parse(languages))
        end
        
        start.each do |hash|
          hash.each{|key,value| 
            if result_skill[key].nil?
               result_skill[key] = value
            else
               result_skill[key] = result_skill[key] + value
            end
          }
        end
    
      #언어 랭킹 매기는 로직
      rank_skill=result_skill.sort_by { |name, age| age }
      #1,2,3위 저장
      User.find(1).update(git_skill_1: rank_skill[-1][0], git_skill_2: rank_skill[-2][0], git_skill_3: rank_skill[-3][0] )  
      #언어 바이트를 세션에 저장한다
      session[:github_language] = result_skill
    end
   
    #만일 기존에 한번 요청이 되었을 경우에는 두번 요청 x session에 있는 값을 보내준다
    @github_language = session[:github_language]
    @github_language
    #js파일에서 해당 부분을 보여준다.
  end
 
    
  
  #프로필 상세보기
  def profile
    @user=User.find(params[:id])
  end

     
  

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  #current_user로 나중에 만들어줘야함
  def new
    @user = User.find(1)
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  

  

  
  
  ##실시간 검색기능
  def search
    respond_to do |format|
      if params[:tech].strip.empty?
        format.js {render 'empty'} 
      else
        @skills = Skill.where("skill_contents Like ?","#{params[:tech]}%")
        format.js {render 'search_skill'}
      end
    end
  end
  
# def find_partner
  
#     ##받아온 파라미터의 형식은 배열
#     ##스킬 검색하고 프로필 리스트
#     skills=params[:find_skill]
#     categories = params[:find_category]
#     @users = []
#     @dummy_users = []
    
#     if !skills.nil?&&!categories.nil? ##스킬 카테고리 모두 
#       skills.each do |skill|
#         skill_users = Skill.find_by(skill_contents: skill).users
#           skill_users.each do |skill_user|
#             if @dummy_users.include?(skill_user)
#             else 
#               @dummy_users.push(skill_user);
#             end
#           end
#       end
#       @dummy_users.each do |user|
#           categories.each do |category|
#             if user.categories.include?(Category.find(category))
#                 @users.push(user)
#                 break
#             end
#           end
#       end
#       @users
#     elsif !skills.nil? #스킬만 검색
#         skills.each do |skill|
#           skill_users = Skill.find_by(skill_contents: skill).users
#             skill_users.each do |skill_user|
#               if @users.include?(skill_user)
#               else 
#                 @users.push(skill_user);
#               end
#             end
#         end
#         @users
#     else
#       User.all.each do |user| #카테고리만 검색
#         categories.each do |category|
#             if user.categories.include?(category)
#                 @users.push(user)
#                 break
#             end
#         end
#       end
#       @users
#     end
# end
  
   #포트폴리오 등록 페이지
  def portfolio
  end
  
  #포트폴리오 상세 페이지
  def portfolio_show
    @portfolio = Portfolio.find(params[:id])
  end
  def portfolio_delete
     PortfolioCategory.where(portfolio_id:params[:id]).destroy_all
     PortfolioSkill.where(portfolio_id:params[:id]).destroy_all
     Portfolio.destroy(params[:id])
     redirect_to "/users/1/profile"
     #current_user로 변경 필요 
  end
  #포트폴리오 등록 로직
  def register_portfolio
    #나중에 current_user를 만들어 줘야함
      
      portfolio=Portfolio.create(
         portfolio_title: params[:portfolio_title],
         portfolio_contents:  params[:portfolio_introduce],
         portfolio_file: params[:file_path],
         portfolio_start: params[:start_portfolio],
         portfolio_end: params[:end_portfolio],
         user_id: 1
      )
      skills = params[:skill].split(',');
      categories = params[:category].split(',');
      
      categories.each do |category|
        category_id=Category.find_by_category_contents(category).id
        PortfolioCategory.create(portfolio_id: portfolio.id,category_id: category_id)
      end
      
      skills.each do |skill|
        skill_id=Skill.find_by_skill_contents(skill).id
        PortfolioSkill.create(portfolio_id: portfolio.id,skill_id: skill_id)
      end
      
      redirect_to "/users/1/profile"
  end
  
  #포트폴리오 수정 로직
  def portfolio_update
    skills = params[:skill].split(',');
    categories = params[:category].split(',');
     Portfolio.find(params[:id]).update(
         portfolio_title: params[:portfolio_title],
         portfolio_contents:  params[:portfolio_introduce],
         portfolio_file: params[:file_path],
         portfolio_start: params[:start_portfolio],
         portfolio_end: params[:end_portfolio],
         user_id: 1
    )
      PortfolioCategory.where(portfolio_id: params[:id]).destroy_all
      PortfolioSkill.where(portfolio_id: params[:id]).destroy_all
    
      
      p "스킬"
      p skills
      p "카테고리"
      p categories
      categories.each do |category|
        category_id=Category.find_by(category_contents: category)
       @p = PortfolioCategory.create(portfolio_id: params[:id],category_id: category_id.id)
        p @p.errors
      end
      
      skills.each do |skill|
        skill_id=Skill.find_by(skill_contents: skill)
        PortfolioSkill.create(portfolio_id: params[:id],skill_id: skill_id.id)
      end
      redirect_to "/users/#{params[:id]}/portfolio_show"
  end
  
  #포트폴리오 수정 페이지
  def portfolio_edit
    @portfolio = Portfolio.find(params[:id])
  end
   
    
 
  
  
   #등록하기
  def register
    ##향후 user_id는 current_user.id로 교체
    skills = params[:skill].split(",")   ##받아 온 스킬들을 저장
    categories = params[:category].split(",") ##받아 온 카테고리들을 저장
    introduce = params[:introduce] ##받아 온 자기소개를 저장
    tel = params[:tel] ##받아 온 전화번호를 저장
    file_path = params[:file_path] ##회원 이미지 저장
    road_address = params[:road_address].split(" ") ##회원 주소 저장 구 까지만
    unless road_address.empty?
      address = road_address[0]+road_address[1]  
    end
    if !User.find(1).user_contents.nil?
       SkillUser.where(user_id:1).destroy_all
       UserCategory.where(user_id:1).destroy_all
       User.find(1).update(user_contents: introduce,tel: tel,user_image: file_path,address: address)
    else
       User.find(1).update(user_contents: introduce,tel: tel,user_image: file_path,address: address) 
    end 
     skills.each do |skill|
       #ex) skill은 'javascript'
       #current_user 로 바꿔줘야함
        skill_id = Skill.find_by(skill_contents: skill)
        SkillUser.create(user_id:1,skill_id: skill_id.id)
     end
     categories.each do |category|
          category_id = Category.find_by(category_contents: category)
          UserCategory.create(user_id:1,category_id: category_id.id)
     end
     ##받아 온 자기소개를 저장
     redirect_to "/users/1/profile"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_user
    #   @user = User.find(params[:id])
    # end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.fetch(:user, {})
    end
    
end
