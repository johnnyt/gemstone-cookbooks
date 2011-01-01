# Packages
%w[ htop iftop tree psmisc w3m libshadow-ruby1.8 screen curl libcurl4-openssl-dev libreadline-dev libxml2-dev git-core subversion vim-nox ].each{ |pkg| package pkg }

# users
include_recipe "sudoers"

node[:accounts].each do |username, options|
  group username do
    gid options[:uid] if options[:uid]
    action :create
  end

  user username do
    home "/home/#{username}"
    shell "/bin/bash"
    uid options[:uid] if options[:uid]
    gid username
    password options[:password].crypt(options[:password]) if options[:password]
  end

  # Split out to a definition so vagrant can be setup
  setup_home_dir(username)
end

group "sudo" do
  members node[:accounts].keys
end

group "www-data" do
  members node[:accounts].keys
end

# Gems
node[:global_gems].each{ |pkg| gem_package pkg }

# These all take a while to run
# %w[ man-db emacs ].each{ |pkg| package pkg }
