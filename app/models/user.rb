class User < ApplicationRecord
    mount_uploader :user_image, ProfilePictureUploader
    #한명의 유저는 여러개의 스킬을 가질 수 있다.
    has_many :skill_users
    has_many :skills ,through: :skill_users
    
    #한명의 유저는 여러개의 카테고리를 가질 수 있다.
    has_many :user_categories
    has_many :categories ,through: :user_categories
    
    #한명의 유저는 여러개의 코맨트평을 남길 수 있다.
    has_many :user_comments
    #한명의 유저는 여러개의 포트폴리오를 가진다.
    has_many :portfolios
    #한명의 유저는 여러개의 메세지를 보낼 수 있다.
    has_many :messages
    #한명의 유저는 여러개의 프로젝트에 가입할 수 있다.
    has_many :user_projects
    has_many :projects, through: :user_projects
    
   
    
    
end
