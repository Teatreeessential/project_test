class Skill < ApplicationRecord
    #하나의 스킬은 여러명의 유저에게 속할 수 있다.
    has_many :skill_users
    has_many :users ,through: :skill_users
    #하나의 스킬은 여러개의 프로젝트에 속할 수 있다.
    has_many :project_skills
    has_many :projects , through: :project_skills
    #하나의 스킬은 여러개의 포트폴리오에 속할 수 있다.
    has_many :portfolio_skills
    has_many :portfolios ,through: :portfolio_skills
end
