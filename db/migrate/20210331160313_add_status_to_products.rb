class AddStatusToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :status, :integer, null: false, default: 0
  end
end
