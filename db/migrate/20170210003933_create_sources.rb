class CreateSources < ActiveRecord::Migration[5.0]
  def change
    create_table :sources do |t|
      t.string :name,       default: "", null: false
      t.string :url,        default: "", null: false
      t.string :rss_feed,   default: "", null: false
      t.text :description,  default: "", null: false

      t.timestamps
    end
  end
end
