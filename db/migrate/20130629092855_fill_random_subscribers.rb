class FillRandomSubscribers < ActiveRecord::Migration
  def up
    Company.all.each do |company|
      if category = company.category
        User.all.shuffle.first(2).each do |user|
          Subscribe.create(:user_id => user.id, :category_id => category.id)
        end
      end
    end
  end

  def down
    ActiveRecord::Base.connection.execute('delete from subscribes')
  end
end
