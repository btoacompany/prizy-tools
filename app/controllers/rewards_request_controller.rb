class RewardsRequestController < ApplicationController
  before_filter :authenticate_user, :init_url

  def index 
    @request_rewards = RequestReward.all
  end
end
