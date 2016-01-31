class FileAttachment < ActiveRecord::Base
  has_attached_file :file
  belongs_to :row, :polymorphic => true

  do_not_validate_attachment_file_type :file  
end