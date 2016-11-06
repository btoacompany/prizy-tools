Rails.application.routes.draw do
  root :to => 'analytics#company'

  get	'/admin/login'		  => "top#login"
  post	'/admin/login/complete'   => "top#login_complete"
  get	'/admin/logout'		  => "top#logout"

  get	'/admin/company'		=> 'company#index'
  get	'/admin/company/:id'		=> 'company#posts'
  get	'/admin/company/edit/:id'	=> 'company#edit'
  post	'/admin/company/edit/complete'	=> 'company#edit_complete'
  post	'/admin/company/delete'		=> 'company#delete'

  get	'/admin/rewards_request'	  => 'rewards_request#index'
  post	'/admin/rewards_request'	  => 'rewards_request#index'

  get	'/admin/rewards_prizy'			=> 'rewards_prizy#index'
  get	'/admin/rewards_prizy/add'		=> 'rewards_prizy#add'
  post	'/admin/rewards_prizy/add/complete'	=> 'rewards_prizy#add_complete'
  get	'/admin/rewards_prizy/edit/:id'		=> 'rewards_prizy#edit'
  post	'/admin/rewards_prizy/edit/complete'	=> 'rewards_prizy#edit_complete'
  post	'/admin/rewards_prizy/delete'		=> 'rewards_prizy#delete'

  # analytics or statistics
  get	'/admin/analytics/users'      => 'analytics#users'
  post	'/admin/analytics/users'      => 'analytics#users'
  get	'/admin/analytics/overall'    => 'analytics#overall'
  get	'/admin/analytics/company'    => 'analytics#company'
  post	'/admin/analytics/company'    => 'analytics#company'
  get	'/admin/analytics/user'	      => 'analytics#each_user'
  post	'/admin/analytics/user'	      => 'analytics#each_user'

  # csv
  post	'export_first_csv'  => 'analytics#first_csv'
  post	'export_second_csv' => 'analytics#second_csv'
  post	'export_third_csv'  => 'analytics#third_csv'
end
