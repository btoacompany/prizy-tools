#coding:utf-8

class RewardsPrizy < ActiveRecord::Base
  self.table_name = "rewards_prizy"

  before_create :set_create_time
  before_update :set_update_time

  belongs_to :company

  def save_record(params)
    self.title		= params[:title]
    self.img_src	= params[:img_src]
    self.description	= params[:description]
    self.points		= params[:points]
    self.save
  end
  
  def delete_record
    self.delete_flag = 1
    self.save
  end

  def set_create_time 
    t = set_time
    self.create_time = t
    self.update_time = t
  end

  def set_update_time 
    t = set_time
    self.update_time = t
  end

  def set_time
    return Time.now.strftime("%Y-%m-%d %H:%M:%S")
  end
end
