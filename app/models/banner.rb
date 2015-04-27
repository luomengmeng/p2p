class Banner < ActiveRecord::Base
#  attr_accessible :inner_html, :status, :title, :pic, :weight

  default_scope {order("weight")}
  scope :display, -> {where(status: true)}
  mount_uploader :pic, BannerPicUploader

end
