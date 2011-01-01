%w[ .bashrc .profile ].each do |filename|
  file "/home/vagrant/#{filename}" do
    action :delete
    not_if "[ -e /home/vagrant/home ]"
  end
end

setup_home_dir "vagrant"
