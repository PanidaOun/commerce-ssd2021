class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.text :title
      t.text :description
      t.integer :stock

      t.timestamps
    end
  end
end
