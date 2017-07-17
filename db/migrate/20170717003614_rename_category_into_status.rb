class RenameCategoryIntoStatus < ActiveRecord::Migration[5.0]

  def change
    rename_column :contents, :category, :status
  end

end
