class Photo < ActiveRecord::Base
  has_attached_file :image
  belongs_to :row, :polymorphic => true
end