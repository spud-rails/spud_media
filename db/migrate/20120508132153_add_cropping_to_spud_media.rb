class AddCroppingToSpudMedia < ActiveRecord::Migration
  def change
    add_column :spud_media, :crop_x, :int, :default => 0
    add_column :spud_media, :crop_y, :int, :default => 0
    add_column :spud_media, :crop_w, :int
    add_column :spud_media, :crop_h, :int
    add_column :spud_media, :crop_s, :int, :default => 100
  end
end
