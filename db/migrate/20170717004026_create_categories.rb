class CreateCategories < ActiveRecord::Migration[5.0]

  def change
    create_table :categories do |t|
      t.string :name,     default: '', null: false
      t.integer :user_id, default: 0,  null: false

      t.timestamps
    end

    add_column :contents, :category_id, :integer, default: nil, null: true
  end

end
