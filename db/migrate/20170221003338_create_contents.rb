class CreateContents < ActiveRecord::Migration[5.0]
  def change
    create_table :contents do |t|
      t.string  :title,       default: "", null: false
      t.string  :url,         default: "", null: false
      t.text    :description, default: "", null: false
      t.integer :user_id,     default: 0,  null: false
      t.integer :source_id,   default: 0,  null: false

      t.timestamps
    end
  end
end
