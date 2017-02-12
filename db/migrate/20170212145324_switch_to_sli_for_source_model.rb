class SwitchToSliForSourceModel < ActiveRecord::Migration[5.0]

  def change
    add_column :sources, :type, :string, null: false, default: ''
  end

end
