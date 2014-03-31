class AddSubscribeLkEmailSmsToUsers < ActiveRecord::Migration
  def up
    change_table :users do |t|
      [:lk, :email, :sms].each do |field|
        t.boolean "subscribe_#{field}".to_sym, :default => false
        t.index "subscribe_#{field}".to_sym
      end
    end
  end

  def down
    [:lk, :email, :sms].each do |field|
      remove_column :users, "subscribe_#{field}".to_sym
    end
  end
end
