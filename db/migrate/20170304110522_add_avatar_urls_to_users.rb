class AddAvatarUrlsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :avatar_url, :string
    add_column :users, :avatar_thumb_url, :string
    add_column :users, :avatar_small_url, :string
    add_column :users, :avatar_medium_url, :string
  end
end
