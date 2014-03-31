class AddIgnoredFieldsToUsers < ActiveRecord::Migration
  def initialize
    @fields = [:good, :service, :job, :campaign, :new, :feedback]
  end

  def up
    @fields.each do |field|
      add_column :users, "ignored_#{field}s".to_sym, :string
    end
  end

  def down
    @fields.each do |field|
      remove_column :users, "ignored_#{field}s".to_sym
    end
  end
end
