class CreateSpudMedia < ActiveRecord::Migration
  def change
    create_table :spud_media do |t|
      t.string :attachment_content_type
      t.integer :attachment_file_size
      t.string :attachment_file_name

      t.timestamps
    end
  end
end
