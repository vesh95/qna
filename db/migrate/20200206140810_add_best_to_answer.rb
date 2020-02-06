class AddBestToAnswer < ActiveRecord::Migration[6.0]
  def change
    add_column :answers, :best, :boolean, default: false, null: false
  end
end
