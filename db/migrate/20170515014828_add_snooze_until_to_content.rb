class AddSnoozeUntilToContent < ActiveRecord::Migration[5.0]

  def change
    rename_column :contents, :pinned, :is_pinned
    # category is an enum { :inbox, :done, :snoozed, :trashed }
    add_column :contents, :category, :integer, default: 'inbox', null: false
  end

end
