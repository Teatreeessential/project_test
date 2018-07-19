class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :user_name
      t.string :user_access_token
      t.string :user_password
      t.string :user_image
      t.string :user_contents
      t.string :git_skill_1
      t.string :git_skill_2
      t.string :git_skill_3
      t.string :birth
      t.string :address
      t.string :tel
      
      t.integer :user_point
      t.timestamps
    end
  end
end
