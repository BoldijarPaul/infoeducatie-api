class Project < ActiveRecord::Base
  scope :active, -> { where(finished: true).where(approved: true) }

  belongs_to :category
  has_many :colaborators, inverse_of: :project, dependent: :destroy
  has_many :contestants, through: :colaborators, inverse_of: :projects
  has_many :screenshots, inverse_of: :project, dependent: :destroy

  accepts_nested_attributes_for :category
  accepts_nested_attributes_for :colaborators,
    :reject_if => :all_blank
  accepts_nested_attributes_for :contestants,
    :reject_if => :all_blank
  accepts_nested_attributes_for :screenshots

  validates :category, presence: true
  validates :contestants, presence: true

  validates :title, presence: true
  validates :description, presence: true
  validates :technical_description, presence: true
  validates :system_requirements, presence: true

  validates :source_url, presence: true, if: Proc.new {
    self.open_source == true
  }

  validates :closed_source_reason, presence: true, if: Proc.new {
    self.open_source == false
  }

  validates :github_username, presence: true, if: Proc.new {
    self.open_source == false
  }

  validates :homepage, presence: true, if: Proc.new { |project|
    !self.category.nil? && self.category.name == "web"
  }

  before_validation :initialize_colaborators, on: :create
  def initialize_colaborators
    colaborators.each { |c| c.project = self }
  end

  def edition
    contestants.first.edition
  end

  def county
    contestants.first.county
  end

  def authors
    contestants.map(&:name).join(", ")
  end

  def category_name
    category.name
  end

  def screenshots_count
    screenshots.count
  end

  def discourse_url
    "#{Settings.ui.community_url}/t/#{discourse_topic_id}" if discourse_topic_id
  end

  def has_source_url
    not source_url.blank?
  end
end
