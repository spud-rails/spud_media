class AddProtectedToSpudMedia < ActiveRecord::Migration
  def change
    add_column :spud_media, :is_protected, :boolean, :default => false
    add_column :spud_media, :attachment_updated_at, :datetime
  end
end
