class CreateAuthorizations < ActiveRecord::Migration[6.0]
  def change
    create_table :authorizations do |t|
      t.string :uid, null: false
      t.string :provider, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :authorizations, [:provider, :uid]
  end
end
