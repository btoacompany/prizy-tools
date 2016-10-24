Rails.application.routes.draw do
  root :to => 'analytics#company'

  get	'/admin/login'		  => "top#login"
  post	'/admin/login/complete'   => "top#login_complete"
  get	'/admin/logout'		  => "top#logout"

  get	'/admin/company/:id'	  => 'company#index'
  get	'/admin/rewards'	  => 'rewards#index'
  post	'/admin/rewards'	  => 'rewards#index'

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
