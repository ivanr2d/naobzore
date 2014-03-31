class Email < ActiveRecord::Base
  attr_accessible :body, :from, :sended, :subject, :to
end
