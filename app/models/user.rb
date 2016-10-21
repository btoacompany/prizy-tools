#coding:utf-8
require 'bcrypt'

class User < ActiveRecord::Base
  include BCrypt

  self.table_name = "users"

  belongs_to :company
  has_many :posts
  has_many :comments
  has_many :kudos
  has_many :hashtags

=begin
  before_create :set_create_time
  before_update :set_update_time
  
  def save_record(params)
    self.name	      = params[:name]	      if params[:name].present?
    self.email	      = params[:email]	      if params[:email].present?
    self.company_id   = params[:company_id]   if params[:company_id].present?
    self.firstname    = params[:firstname]    if params[:firstname].present?
    self.img_src      = params[:img_src]      if params[:img_src].present?
    self.lastname     = params[:lastname]     if params[:lastname].present?
    self.birthday     = params[:birthday]     if params[:birthday].present?
    self.job_title    = params[:job_title]    if params[:job_title].present?
    self.gender	      = params[:gender]	      if params[:gender].present?
    self.in_points    = params[:in_points]    if params[:in_points].present?
    self.out_points   = params[:out_points]   if params[:out_points].present?
    self.verified     = params[:verified]     if params[:verified].present?
    self.admin	      = params[:admin]	      if params[:admin].present?
    self.deliver_invite_mail = params[:deliver_invite_mail]  if params[:deliver_invite_mail].present?
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
=end  
end
