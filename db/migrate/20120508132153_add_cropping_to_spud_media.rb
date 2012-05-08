class AddCroppingToSpudMedia < ActiveRecord::Migration
  def change
    add_column :spud_media, :crop_x, :int
    add_column :spud_media, :crop_y, :int
    add_column :spud_media, :crop_w, :int
    add_column :spud_media, :crop_h, :int
    add_column :spud_media, :crop_s, :decimal, :precision => 5, :scale => 2, :default => 100
  end
end
