Rails.application.routes.draw do
  root :to => 'admin#company'

  get 'admin/users' => 'admin#users'
  post 'admin/users' => 'admin#users'
  get 'admin/analytics/overall' => 'admin#overall'
  get 'admin/analytics/company' => 'admin#company'
  post 'admin/analytics/company' => 'admin#company'
  get 'admin/analytics/user' => 'admin#each_user'
  post 'admin/analytics/user' => 'admin#each_user'
  post 'export_first_csv' => 'admin#first_csv'
  post 'export_second_csv' => 'admin#second_csv'
  post 'export_third_csv' => 'admin#third_csv'
  get 'admin/reward' => 'admin#reward'
  post 'admin/reward' => 'admin#reward'
  get 'admin/:id' => 'admin#index'
end
