class CreateVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :votes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :votable, polymorphic: true
      t.integer :rate, null: false

      t.timestamps

    end
    add_index :votes, [:user_id, :votable_id, :votable_type], unique: true
  end
end
