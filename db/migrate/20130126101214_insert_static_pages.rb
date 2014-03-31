class InsertStaticPages < ActiveRecord::Migration
  def up
      Page.create! do |r|
        r.title      = 'Page 1'
      end
      Page.create! do |r|
        r.title      = 'Page 2'
      end
      Page.create! do |r|
        r.title      = 'Page 3'
      end
      Page.create! do |r|
        r.title      = 'Page 4'
      end
      Page.create! do |r|
        r.title      = 'Page 5'
      end
      Page.create! do |r|
        r.title      = 'Page 6'
      end
      Page.create! do |r|
        r.title      = 'Page 7'
      end
      Page.create! do |r|
        r.title      = 'Page 8'
      end
      
      Settings.create! do |r|
        r.key   = 'Left block'
        r.value = 'lef block content'
      end
      Settings.create! do |r|
        r.key   = 'Right block'
        r.value = 'right block content'
      end
  end

  def down
  end
end
