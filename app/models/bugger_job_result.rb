class BuggerJobResult < ActiveRecord::Base
  belongs_to :bugger_job
  has_one :photo, :as => :row

  validates_presence_of :product_ref, :message => " cannot be blank"

  ERROR_TYPE_MISSING = "missing"
  ERROR_TYPE_MISMATCH = "mismatch"

  # {
  #   key: "Some key",
  #   type: "mismatch",
  #   expected_value: "abc",
  #   actual_value: "xyz"
  # }
  def errs
    @errs || []
  end

  def push_error(key:, type:, expected_value: nil, actual_value: nil)
    @errs ||= []
    err_hash = {
      key: key,
      type: type,
      expected_value: expected_value,
      actual_value: actual_value
    }

    @errs.push(err_hash)
  end
end