# encoding: utf-8

class Category < ActiveRecord::Base
  before_save :default_values
  
  # TODO удалить parent_id
  attr_accessible :parent_id, :parents_ids, :chilren_ids, :description, :image, :title, :cat_type, :alias, :position, :meta_description, :meta_keywords, :meta_title

  belongs_to :parent, :class_name => 'Category', :foreign_key => 'parent_id'
  #has_many :children, :class_name => 'Category', :foreign_key => 'parent_id', :order => 'position ASC'
  has_many :company
  has_many :goods
  has_many :subscribes
  has_many :subscribers, :through => :subscribes, :source => :user

  def self.cat_types
    %w(Good Service Job News Help)
  end

  cat_types.each do |type|
    eval("scope :#{type.downcase}_type, where(:cat_type => '#{type}')")
  end
  scope :main, where(:parent_id => 0)
  default_scope order(:title)
  
  #validates :parent_id, :presence => true
  validates :title, :presence => true, :length => {:minimum => 1, :maximum => 128}
  validates :alias, :presence => true, :uniqueness => true, :length => {:minimum => 1, :maximum => 48}
  validates :cat_type, :presence => true, :inclusion => cat_types

  before_validation lambda { self.alias = Utils.url_translit(self.title) if self.alias.blank? }
  
  mount_uploader :image, ImageUploader
  attr_accessor :image_file_name

  # set children_ids
  def add_to_children_ids parents_ids
    ActiveRecord::Base.connection.execute("UPDATE categories SET children_ids = IF(children_ids = '0', #{id}, CONCAT(children_ids, ',#{id}')) WHERE id IN (#{parents_ids.join(',')})")
  end

  def remove_from_children_ids parents_ids
    Category.where(:id => parents_ids).each do |c|
      ids = c.children_ids.delete_if { |child_id| child_id == id }
      ids = [0] if ids.empty?
      c.update_attribute(:children_ids, ids.join(','))
    end
  end

  after_create do
    add_to_children_ids parents_ids
  end

  after_destroy do
    remove_from_children_ids parents_ids
  end

  after_save do
    if parents_ids_changed?
      if (new_parents_ids = parents_ids - parents_ids_was.split(',').map(&:to_i)).any?
        add_to_children_ids new_parents_ids
      end
      if (old_parents_ids = parents_ids_was.split(',').map(&:to_i) - parents_ids).any?
        remove_from_children_ids old_parents_ids
      end
    end
  end
      

  [:parents, :children].each do |m|
    define_method "#{m}_ids".to_sym do
      self["#{m}_ids".to_sym].to_s.split(',').map(&:to_i)
    end

    define_method m.to_sym do
      Category.where(:id => send("#{m}_ids".to_sym))
    end
  end

  def top?
    self[:parents_ids] == '0'
  end

  def self.top
    scoped.where(:parents_ids => '0')
  end

  def top_parent
    if parent_id == 0
      return self
    else
      parent.top_parent
    end
  end

  def deep_children
    children.map { |c| [c, c.children_ids == [0] ? [] : c.deep_children] }.flatten
  end

  # result example [[c1, c21, c3], [c1, c22, c23]]
  def hierarhies res = [[self]]
    res.count.times do
      h = res.shift
      if (parents = h.first.parents).any?
        # Если несколько родителей увеличиваем кол-во иерархий
        parents.each { |parent| res.push([parent] + h) }
        hierarhies res
      else
        res.push h
      end
    end
    res
  end
  
  #-------------------------------------------------------
  #Значения по умолчанию при сохранении
  #-------------------------------------------------------
  def default_values
    if !self.parent_id
      self.parent_id = 0
    end
    if !self.cat_type
      self.cat_type = 0
    end
  end
  
  #-------------------------------------------------------
  # Получение всех дочерних id категорий
  # integer parent - ID родителя
  #-------------------------------------------------------
  def self.get_child_id(parent)
    result = ''
    if parent != nil
      category = Category.find(parent)
      categories = []
      
      if(category.children.count > 0)
        i = 0
        category.children.each do |child|
          categories[i] = child.id
          if child.children.count > 0
            child.children.each do |subchild|
              categories[i] = subchild.id
              i+=1;
            end
          end
          i+=1;
        end
      else
        categories[0] = parent
      end
      result = {
          :category_id => categories
      }
    end
    return result
  end
  
  #---------------------------------------------
  # Получение всех дочерних id категорий
  # string alias - Псевдоним родителя
  #---------------------------------------------
  def self.get_child_id_by_alias(c_alias)
    result = ''
    if c_alias != nil
      category = Category.find_by_alias(c_alias)
      categories = []
      
      if(category.children.count > 0)
        i = 0
        category.children.each do |child|
          categories[i] = child.id
          if child.children.count > 0
            child.children.each do |subchild|
              categories[i] = subchild.id
              i+=1;
            end
          end
          i+=1;
        end
      else
        categories[0] = category.id
      end
      result = {
          :category_id => categories
      }
    end
    return result
  end
  
  #-------------------------------------------------------
  # Получение количества сущностей указанной категории
  #-------------------------------------------------------
  def self.get_count_entity(controller, category)
    result = 0
    if controller == 'goods'
      result = Good.where(self.get_child_id(category)).count
    end
    if controller == 'services'
      result = Service.where(self.get_child_id(category)).count
    end
    if controller == 'jobs'
      result = Job.where(self.get_child_id(category)).count
    end
    if controller == 'resume'
      result = Resume.where(self.get_child_id(category)).count
    end
    if controller == 'feedbacks'
      result = Feedback.where(self.get_child_id(category)).count
    end
    if controller == 'campaigns'
      result = Campaign.where(self.get_child_id(category)).count
    end
    if controller == 'help'
      result = Help.where(self.get_child_id(category)).count
    end
    if controller == 'news'
      result = News.where(self.get_child_id(category)).count
    end
    return result
  end
  
  #----------------------------------------------------------
  # Получение родителей, или родителя категории
  #----------------------------------------------------------
  def self.get_parents(category)
    result = [
      0, # level - 0
      0, # level - 1
      0
    ]
    
    if category != nil
      curent = Category.find(category)
      
      if curent.parent
        result[0] = curent.parent.id
        if curent.parent.parent
          result[0] = curent.parent.parent.id
          result[1] = curent.parent.id
        end
      end
    end
    
    return result
  end
  
  #-----------------------------------------------------------
  # Получение родителей, или родителя категории
  # И получаем псевдонимы
  #-----------------------------------------------------------
  def self.get_parents_aliases(category)
    result = [
      0, # level - 0
      0, # level - 1
      0, # level - 2
      0, # level - 3
    ]
    
    if category != nil
      curent = Category.find_by_alias(category)
      
      if curent != nil
        #result[0] = curent.alias
        
        if curent.parent != nil
          result[0] = curent.parent.alias
          #result[1] = curent.alias
          
          if curent.parent.parent != nil
            result[0] = curent.parent.parent.alias
            result[1] = curent.parent.alias
            #result[2] = curent.alias
            
            if curent.parent.parent.parent != nil
              result[0] = curent.parent.parent.parent.alias
              result[1] = curent.parent.parent.alias
              result[2] = curent.parent.alias
              #result[3] = curent.alias
            end
          end
        end
      end
    end
    
    return result
  end
  
end

