class RewardsPrizyController < ApplicationController
  before_filter :authenticate_user, :init_url
  def index
    @rewards = RewardsPrizy.where(:delete_flag => 0)
  end

  def add
  end

  def add_complete
    params[:company_id] = @id

    @rewards = RewardsPrizy.new
    @rewards.save_record(params)
    redirect_to_index
  end

  def edit
    @reward = RewardsPrizy.find(params[:id])
  end

  def edit_complete
    result = RewardsPrizy.find(params[:id])
    result.save_record(params)
    redirect_to_index
  end

  def delete
    result =  RewardsPrizy.find(params[:id])
    result.delete_record
    redirect_to_index
  end

  def redirect_to_index
    redirect_to '/admin/rewards_prizy'
  end
end
