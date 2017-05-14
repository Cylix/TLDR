class AddPinnedToContents < ActiveRecord::Migration[5.0]

  def change
    add_column :contents, :pinned, :boolean, default: false, null: false
  end

end
