class BuggerJob < ActiveRecord::Base
  has_many :bugger_job_results
  has_one :file_attachment, :as => :row

  state_machine :initial => :processing do 
    event :complete do 
      transition :processing => :completed
    end

    before_transition :to => :completed, :do => :assign_completed_timestamp
  end

  def assign_completed_timestamp
    self.completed_at = Time.zone.now
  end
end