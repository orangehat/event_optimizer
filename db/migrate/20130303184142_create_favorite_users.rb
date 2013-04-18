class CreateFavoriteUsers < ActiveRecord::Migration
  def change
    create_table :favorite_users do |t|
      t.string :name
      t.integer :fb_id
      t.string :fb_name
      t.string :tw_id
      t.string :tw_name

      t.timestamps
    end
  end
end
