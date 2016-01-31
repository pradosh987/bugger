class BuggerJobResult < ActiveRecord::Base
  belongs_to :bugger_job
  has_one :photo, :as => :row
  has_many :data_errors

  validates_presence_of :product_ref, :message => " cannot be blank"

  ERROR_TYPE_MISSING = "missing"
  ERROR_TYPE_MISMATCH = "mismatch"
  
  # Example Hash 
  # {
  #   key: "Some key",
  #   type: "mismatch",
  #   expected_value: "abc",
  #   actual_value: "xyz"
  # }
  def push_error(key:, type:, expected_value: nil, actual_value: nil)
    err_hash = {
      key: key,
      type: type,
      expected_value: expected_value,
      actual_value: actual_value
    }
    
    self.data_errors.new(err_hash, {:without_protection => true})
  end
end