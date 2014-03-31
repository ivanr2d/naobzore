class FillArticleForJobsAndCampaigns < ActiveRecord::Migration
  def up
    ActiveRecord::Base.connection.execute("UPDATE jobs SET article = id WHERE article IS NULL")
    ActiveRecord::Base.connection.execute("UPDATE campaigns SET article = id WHERE article IS NULL")
  end

  def down
  end
end
