data = [
  {
    :name	=> "btoa-admin",
    :email	=> "f.ishihara@btoa-company.com",
    :password	=> "btoa1006"
  },
  {
    :name	=> "btoa-info",
    :email	=> "info@btoa-company.com",
    :password	=> "qwe"
  },
  {
    :name	=> "btoa-test",
    :email	=> "s.karakama@btoa-company.com",
    :password	=> "qwe"
  }
]

data.each do | d |
  admin = Admin.new
  admin.save_record(d)
end
