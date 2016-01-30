class BuggerJobResult < ActiveRecord::Base
  belongs_to :bugger_job
  has_one :photo, :as => :row

  validates_presence_of :product_id, :message => " cannot be blank"
end