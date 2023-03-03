class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :title, null: false
      t.integer :price_cents, null: false
      t.string :image_filename, null: false
    end
  end
end
