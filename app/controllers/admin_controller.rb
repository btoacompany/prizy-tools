require 'csv'

class AdminController < ApplicationController

  before_action :time_definition, only:[:overall, :company, :each_user, :first_csv, :second_csv, :third_csv, :csv_header]
  before_action :company_lists, only:[:index, :users, :company, :each_user, :second_csv]
  before_action :user, only:[:users, :each_user, :third_csv]
  #allcsv_header
  before_action :csv_header, only:[:first_csv, :second_csv, :third_csv]
  #first_csv
  before_action :overall, only:[:first_csv]
  #second_csv

  def index
    @company_posts = {}
    @company_lists.each do |company|
      posts = Post.where(:company_id => company.id, :delete_flag => 0).order("update_time desc")
      
      @posts = []
      data = {}

      posts.each do |post|
        comments = Comment.where(:post_id => post.id, :delete_flag => 0)
        kudos = Kudos.where(:post_id => post.id, :delete_flag => 0)

        data ={
          id: post.id,
          user_id: post.user_id,
          user_name: post.user.name,
          receiver_name: post.receiver.id,
          user_img: post.user.img_src,
          receiver_img: post.receiver.img_src,
          points: post.points,
          description: post.description,
          comments: comments,
          kudos: kudos,
        }
        @posts << data
      end
      @company_posts[company.id] = @posts
    end
  end

  def users
    #nothing_inside
  end

  def overall
    @company_lists = Company.all.count
    @users = User.order("company_id").count
    @total_posts = Post.all.count
    @total_points = Post.sum(:points)
    @total_kudos = Kudos.all.count
    @total_comments = Comment.all.count
    @total_actions = @total_posts + @total_kudos + @total_comments
  end

  def compamy
    @company_kudos = 0
  end

  def each_user
    #nothing_inside
  end

  def first_csv
    contents = []
    contents = [@company_lists, @users, @total_posts, @total_actions, @total_points]
    @weeks.each do |week|
      @a = Company.where(create_time: week).count
      @b = User.where(create_time: week).count
      @c = Post.where(create_time: week).count
      @d = Kudos.where(create_time: week).count
      @e = Comment.where(create_time: week).count
      @f = Post.where(create_time: week).sum(:points)
      contents << @a << @b << @c << @c + @d + @e << @f
    end

    data = CSV.generate do |csv|
      csv << @first_header_overall 
      csv << @second_header_overall 
      csv << contents
    end
    send_data(data, type: 'text/csv', filename: "report_#{Time.now.strftime('%Y%m%d%H%M%S')}.csv")
  end

  def second_csv
    contents = []
    @company_kudos = 0
    @company_lists.each do |item|
      hash = []
      hash << item.name + "."
      @employees = User.where(company_id: item.id)
      hash << @employees.count
      hash << item[:create_time].strftime("%Y-%m-%d")
      hash << Reward.where(company_id: item.id).count
      @weeks.each do |week|
        # @a
        @a = Post.where(create_time: week).group("company_id").count
        if @a[item.id].blank?
          @a[item.id] = 0
        end
        @kudos = Kudos.where(create_time: week).group("user_id").count
        @employees.each do |employee|
          if @kudos[employee.id].blank?
            @kudos[employee.id] = 0
          end
        @company_kudos =+ @kudos[employee.id]
        end
        # @c
        @c = Comment.where(create_time: week).group("company_id").count
        if @c[item.id].blank?
          @c[item.id] = 0
        end
        # @d
        @d = @a[item.id] + @company_kudos + @c[item.id]
        # @e
        if @employees.count > 0
          @e = @d / @employees.count
        else
          @e = 0
        end
        hash << @a[item.id] << @company_kudos << @c[item.id] << @d << @e
      end
      contents << hash
    end

    data = CSV.generate do |csv|
      csv << @first_header_others 
      csv << @second_header_company
      contents.each do |value|
        csv << value
      end
    end
    send_data(data, type: 'text/csv', filename: "report_#{Time.now.strftime('%Y%m%d%H%M%S')}.csv")
  end

  def third_csv
    contents = []
    @users.each do |item|
      hash = []
      hash << item.company.name + "."
      hash << item.name
      hash << item.create_time
      if item[:verified] == 0
        hash << "Registered"
      else
        hash << "not_yet"
      end
      @weeks.each do |week|
        @a = Post.where(create_time: week).group("user_id").count
        if @a[item.id].blank?
          @a[item.id] = 0
          hash << 0
        else
          hash << @a[item.id]
        end
        @b = Kudos.where(create_time: week).group("user_id").count
        if @b[item.id].blank?
          @b[item.id] = 0
          hash << 0
        else
           hash << @b[item.id]
        end
        @c = Comment.where(create_time: week).group("user_id").count
        if @c[item.id].blank?
          @c[item.id] = 0
          hash << 0
        else
          hash << @c[item.id]
        end
        hash << @a[item.id] + @b[item.id] + @c[item.id]
      end
      contents << hash
    end

    data = CSV.generate do |csv|
      csv << @first_header_user 
      csv << @third_header_company
      contents.each do |value|
        csv << value
      end
    end
    send_data(data, type: 'text/csv', filename: "report_#{Time.now.strftime('%Y%m%d%H%M%S')}.csv")
  end

  def reward
    @request_rewards = RequestReward.all
  end



  def time_definition
    @weeks=[]
    @big_this_week = Date.today.beginning_of_week
    @end_this_week = Date.today.end_of_week
    @big_last_week = 1.weeks.ago.beginning_of_week
    @end_last_week = 1.weeks.ago.end_of_week
    @big_second_last_week = 2.weeks.ago.beginning_of_week
    @end_second_last_week = 2.weeks.ago.end_of_week
    @big_third_last_week = 3.weeks.ago.beginning_of_week
    @end_third_last_week = 3.weeks.ago.end_of_week

    @this_week = @big_this_week..@end_this_week
    @this_week_custom = @big_this_week.strftime("%m/%d")..@end_this_week.strftime("%m/%d")
    @last_week = @big_last_week..@end_last_week
    @last_week_custom = @big_last_week.strftime("%m/%d")..@end_last_week.strftime("%m/%d")
    @second_last_week = @big_second_last_week..@end_second_last_week
    @second_last_week_custom = @big_second_last_week.strftime("%m/%d")..@end_second_last_week.strftime("%m/%d")
    @third_last_week = @big_third_last_week..@end_third_last_week
    @third_last_week_custom = @big_third_last_week.strftime("%m/%d")..@end_third_last_week.strftime("%m/%d")
    
    @weeks << @this_week << @last_week << @second_last_week << @third_last_week
  end

  def user
    @users = User.all
  end

  def company_lists
    @company_lists = Company.all
  end

  def csv_header
    @first_header_overall = ["Info", "Info", "Info", "Info", "Info", @this_week_custom, @this_week_custom, @this_week_custom, @this_week_custom, @this_week_custom, @last_week_custom, @last_week_custom, @last_week_custom, @last_week_custom, @last_week_custom, @second_last_week_custom ,@second_last_week_custom ,@second_last_week_custom ,@second_last_week_custom ,@second_last_week_custom ,@third_last_week_custom, @third_last_week_custom, @third_last_week_custom, @third_last_week_custom, @third_last_week_custom  ]
    @first_header_others = ["Info", "Info", "Info", "Info", @this_week_custom, @this_week_custom, @this_week_custom, @this_week_custom, @this_week_custom, @last_week_custom, @last_week_custom, @last_week_custom, @last_week_custom, @last_week_custom, @second_last_week_custom ,@second_last_week_custom ,@second_last_week_custom ,@second_last_week_custom ,@second_last_week_custom ,@third_last_week_custom, @third_last_week_custom, @third_last_week_custom, @third_last_week_custom, @third_last_week_custom]
    @first_header_user = ["Info", "Info", "Info","Info", @this_week_custom, @this_week_custom, @this_week_custom, @this_week_custom, @last_week_custom, @last_week_custom, @last_week_custom, @last_week_custom, @second_last_week_custom ,@second_last_week_custom ,@second_last_week_custom ,@second_last_week_custom ,@third_last_week_custom, @third_last_week_custom, @third_last_week_custom, @third_last_week_custom]
    @second_header_overall = ["Companies", "Users", "Posts", "Actions", "Points", "New-Companies", "New-users", "New-posts", "New-actions", "New-points", "New-Companies", "New-users", "New-posts", "New-actions", "New-points","New-Companies", "New-users", "New-posts", "New-actions", "New-points", "New-Companies", "New-users", "New-posts", "New-actions", "New-points"]
    @second_header_company = ["Companies", "Users", "Register_date", "Gifts", "Posts", "Goods", "Comments", "Actions", "Acctions.ave", "Posts", "Goods", "Comments", "Actions", "Acctions.ave", "Posts", "Goods", "Comments", "Actions", "Acctions.ave", "Posts", "Goods", "Comments", "Actions", "Acctions.ave",]
    @third_header_company = [
      "Companies", "Users", "Register_date", "Status", "Posts", "Goods", "Comments", "Actions", "Posts", "Goods", "Comments", "Actions", "Posts", "Goods", "Comments", "Actions", "Posts", "Goods", "Comments", "Actions"]
  end

end
