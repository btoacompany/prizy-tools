class AdminController < ApplicationController

  def index
    @company_lists = Company.all

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
    @users = User.all
    @company_lists = Company.all
  end

  def analytics
    @company_lists = Company.all
    @users = User.order("company_id")

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

end
