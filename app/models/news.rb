# encoding: utf-8

class News < ActiveRecord::Base
  attr_protected
  attr_reader :article
  include ModelSociality
  include HasPhoto
  
  validates :category_id, :presence => true
  validates :name, :presence => true, :uniqueness => { :scope => :company_id }, :length => {:minimum => 1, :maximum => 128}, :uniqueness => { :scope => :company_id }
  validates :translit, :presence => true, :uniqueness => { :scope => :company_id }, :format => { :with => /^[\w\d\-_]+$/, :message => 'должен содержать только цифры, буквы, тире и подчёркивания' }
  
  belongs_to :category
  belongs_to :company
  has_many :likes, :as => :entity, :dependent => :destroy
  has_many :favorites, :as => :entity, :dependent => :destroy
  has_many :comments, :as => :entity

  before_save do
     self.translit = Russian.translit(self.name).strip.downcase.gsub(" ","S").gsub(/\W/,'').gsub("S","-").gsub(/-{2,}/,'-')
  end
  
  scope :for_user, (lambda do |user|
    # user ignores
    if user
      where("#{self.to_s.tableize}.id NOT IN (#{user.send("ignored_#{self.to_s.tableize}".to_sym)})")
    else
      scoped
    end
  end)

  default_scope order('id desc')

  before_validation lambda { self.translit = Utils.url_translit(self.name) if self.translit.blank? }
  # XXX переименовать content в description для единообразия
  before_save lambda { self.content = self.description.gsub(/(<a.+?href.+?>)|(<\/a>)/, '') }

  def as_json
    super.merge({ :description => description, :article => article })
  end

  # XXX выпилить использование метода title для новости и сам метод
  def title
    name
  end

  # NOTE used for social sharing
  def description
    content
  end

  # XXX выпилить
  def anonce
    content
  end

  def to_param
    translit
  end

  [:like, :favorite].each do |m|
    define_method "#{m}d_by_user?" do |user|
      !! m.to_s.classify.constantize.find_by_user_id_and_entity_id_and_entity_type(user.id, id, self.class.to_s)
    end
  end

  def article
    id
  end

  def article_name
    "#{article}/#{name}"
  end
end
