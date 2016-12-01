class CompanyController < ApplicationController
  before_filter :authenticate_user, :init_url

  def index
    @company = Company.where(delete_flag: 0)
  end

  def edit
    @company = Company.find(params[:id])
  end

  def edit_complete
    company = Company.find(params[:id])
    company.save_record(params)
    redirect_to_index 
  end

  def delete
    company = Company.find(params[:id])
    company.delete_record
    redirect_to_index
  end

  def posts 
    @company = Company.find(params[:id])
    posts = Post.where(:company_id => @company.id, :delete_flag => 0).order("update_time desc")

    limit = 5
    page = params[:page] || 1
    @total_items = posts.count
    @total_pages = (@total_items/limit.to_f).ceil

    if page.to_i <= 1
      page = 1
      offset = 0
    else
      offset = (page.to_i * limit) - limit
    end
    posts = posts.offset(offset).limit(limit)

    @page_now = params[:page].to_i
    if @page_now == 0
      @page_now = 1
    end
    @previous_page = @page_now - 1
    @next_page = @page_now + 1

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
  end

  def redirect_to_index
    redirect_page("company", "index")
  end
end
