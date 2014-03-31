class Message < ActiveRecord::Base
  # TODO readed field because gem unread is used
  attr_accessible :from_id, :subject, :text, :mtype, :receiver_ids
  acts_as_readable :on => :created_at

  validates :from_id, :text, :presence => true

  belongs_to :from, :class_name => 'User'
  alias :sender :from
  has_and_belongs_to_many :receivers, :class_name => 'User'

  scope :readed, where(:readed => true)
  scope :unreaded, where(:readed => false)
  columns_hash['mtype'].limit.each do |t|
    scope t, where(:mtype => t)
  end
  
  search_methods :mtype_eq
  scope :mtype_eq, lambda { |mtype| send(mtype) }

  attr_writer :receiver_ids
  def receiver_ids=(ids)
    self.receivers = ids.map { |id| User.find_by_id(id) }.compact
  end
end
