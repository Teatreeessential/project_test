Rails.application.routes.draw do

  
  get 'login/github'

  resources :users do
    member do
      
      #유저한명당 프로필 보여주는곳
      get '/profile' => 'users#profile'
      get '/portfolio_delete' => 'users#portfolio_delete'
      #포트폴리오 수정 페이지(특정해줘야하기 때문에 이곳에)
      get '/portfolio_edit' => 'users#portfolio_edit'
      #포트폴리오 상세보기(특정해줘야하기 때문에 이곳에)
      get '/portfolio_show' => 'users#portfolio_show'
      #포트폴리오 수정로직 (특정해줘야하기때문에)
      post '/portfolio_update' =>'users#portfolio_update'
    end
    collection do
      #포트폴리오 작성페이지
      get '/test' => 'users#test'
      get '/portfolio' => 'users#portfolio'

      #포트폴리오 등록로직
      post '/register_portfolio' => 'users#register_portfolio'
      get '/repos' => 'users#repos'
      get '/show' => 'users#show'
      #실시간 검색
      post '/search' => 'users#search'
      #검색버튼을 눌렸을 때 
      post '/find_partner' => 'users#find_partner'
      #github랭킹 만들기위한 라우팅
      post '/github' => 'users#github'
      #유저의 리스트를 보는 곳
      get '/list' => 'users#list'
      #유저 프로필 등록 및 수정
      post '/register' => 'users#register'
      
      
      
    end
  end
  
   resources :projects do
      member do
        post '/comments' => 'projects#create_comment'
      end
      collection do
        delete '/comments/:projectComment_id' => 'projects#destroy_comment'
        patch  '/comments/:projectComment_id' => 'projects#update_comment'
        post '/search' => 'projects#search_skills'
        # post '/find_skill' => 'projects#find_skill'
      end
  end
  
  post '/uploads' => 'projects#upload_image'
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
