class FileAttachment < ActiveRecord::Base
  has_attached_file :file
  belongs_to :row, :polymorphic => true
  
end