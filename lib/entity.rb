# encoding: utf-8

module Entity
  extend ActiveSupport::Concern
  include HasPhoto
  included do
    attr_protected
    acts_as_paranoid

    validates :company_id, :presence => true
    validates :name, :presence => true, :length => {:minimum => 1, :maximum => 128}, :uniqueness => { :scope => :company_id }
    validates :translit, :presence => true, :uniqueness => true, :format => { :with => /^[\w\d\-_]+$/, :message => 'должен содержать только цифры, буквы, тире и подчёркивания' }
    
    has_many :characteristics, :as => :entity
    belongs_to :company
    belongs_to :category
    belongs_to :campaign
    has_many :likes, :as => :entity, :dependent => :destroy
    has_many :feedbacks, :as => :entity, :dependent => :destroy
    has_many :comments, :as => :entity, :dependent => :destroy
    has_many :favorites, :as => :entity, :dependent => :destroy
    has_many :visits, :as => :entity

    default_scope where(:published => true)
    scope :with_unpublished, where(:published => [false, true])
    scope :for_user, (lambda do |user|
      # user ignores
      if user
        where("#{self.to_s.tableize}.id NOT IN (#{user.send("ignored_#{self.to_s.tableize}".to_sym)})")
      else
        scoped
      end
    end)
    scope :created_after, lambda { |time| where('created_at > ?', time) }

    before_validation lambda { self.translit = [company_id, Utils.url_translit(self.name)].join('_') if self.translit.blank? }
    before_save lambda { self.description = self.description.gsub(/(<a.+?href.+?>)|(<\/a>)/, '') }
    after_create lambda { self.update_attribute(:article, self.id) if self.article.blank? }
  end

  def characteristics_str
    characteristics.map { |c| "#{c.key}:#{c.value}" }.join(',')
  end

  def article_name
    "#{article}/#{name}"
  end

  # TODO
  def plus_count
    0
  end

  def minus_count
    0
  end

  def similars
    res = self.class.where(:company_id => company_id, :category_id => category_id).where('id != ?', id)
    res = self.class.where(:company_id => company_id).where('id != ?', id) if res.empty?
    res
  end

  def comments_count
    self[:comments_count] || comments.count
  end

  def to_param
    translit
  end

  def image
    main_photo
  end

  [:like, :favorite].each do |m|
    define_method "#{m}d_by_user?" do |user|
      !! m.to_s.classify.constantize.find_by_user_id_and_entity_id_and_entity_type(user.id, id, self.class.to_s)
    end
  end
end
