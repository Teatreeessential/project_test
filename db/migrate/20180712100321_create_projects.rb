class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      
      t.string            :project_title
      t.string            :image_path
      
      t.integer           :user_id
      t.integer           :project_people
      t.integer           :project_views
      t.integer           :project_complete
      
      t.datetime          :project_start
      t.datetime          :project_end
      
      t.text              :project_contents
      t.integer :skill_id
      t.integer :category_id

      t.timestamps
    end
  end
end
