class CreateAwards < ActiveRecord::Migration[6.0]
  def change
    create_table :awards do |t|
      t.references :user, foreign_key: true
      t.string :title
      t.references :question, null: false, foreign_key: true

      t.timestamps
    end
  end
end
