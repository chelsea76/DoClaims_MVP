class Task < ApplicationRecord
  belongs_to :user
  belongs_to :claim
  belongs_to :task_type
  belongs_to :asigned_user, class_name: 'User', foreign_key: 'user_id'
  has_many :task_hours_logs

  validates_presence_of :title

  STATUS_OPTIONS = [['Open', 'open'], ['In Progress', 'in_progress'], ['Completed', 'completed']].freeze

  def self.type_options
    TaskType.all.inject([]) {|res, type| res << [type.name, type.id]; res}
  end
end
