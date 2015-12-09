class AddApiKeyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :api_key, :string

    # We will likely be doing many `SELECT` statements finding users by thier
    # api keys so it's a good idea to have an index on the field
    add_index :users, :api_key
  end
end
