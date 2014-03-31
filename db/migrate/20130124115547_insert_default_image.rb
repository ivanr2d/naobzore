class InsertDefaultImage < ActiveRecord::Migration
  def up
    execute <<-SQL
        INSERT INTO `images` (`category_id`, `created_at`, `entity_id`, `entity_type`, `updated_at`, `url`) 
        VALUES 
        (0, '2013-01-24 11:39:29', 0, 0, '2013-01-24 11:39:29', 'default.png')
    SQL
  end

  def down
    execute <<-SQL
        DELETE FROM images WHERE url='default.png'
    SQL
  end
end
