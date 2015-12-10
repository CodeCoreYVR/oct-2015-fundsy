class CreatePledges < ActiveRecord::Migration
  def change
    create_table :pledges do |t|
      t.money :amount
      t.string :stripe_txn_id
      t.string :aasm_state
      t.references :user, index: true, foreign_key: true
      t.references :campaign, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
