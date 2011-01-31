# Installs GemStone on the server
# Most of this stuff came from one of the following:
#
# http://programminggems.wordpress.com/2010/01/12/slicehost-2/
# http://onsmalltalk.com/2010-10-30-installing-a-gemstone-seaside-server-on-ubuntu-10.10
# http://onsmalltalk.com/2010-10-23-faster-remote-gemstone

# Packages
# %w[ htop iftop tree psmisc w3m screen curl git-core subversion vim-nox zip ].each{ |pkg| package pkg }
%w[ vim-nox htop iftop tree psmisc w3m screen curl git-core zip ].each{ |pkg| package pkg }

require_recipe "sudoers"

username = node[:gemstone][:user][:name] 
home_dir = "/home/#{username}"

user username do
  home home_dir
  shell "/bin/bash"
end

group "sudo" do
  members username
  append true
end

%w[ bin env .ssh .vim ].each do |source_dir|
  local_dir = source_dir.to_s.gsub(".", "")

  remote_directory "#{home_dir}/#{source_dir}" do
    source  local_dir
    owner   username
    group   username
    mode    0700
    files_owner username
    files_group username
    files_mode  local_dir =~ /bin/ ? 0700 : 0600
  end
end

# You can setup your key in roles/gemstone.json
if (keys = (node[:accounts][username] || {})[:keys])
  template "#{home_dir}/.ssh/authorized_keys" do
    source  "authorized_keys.erb"
    mode    "0600"
    owner   username
    group   username
    variables(:keys => keys)
  end
end

# Copy over dotfiles
%w[ bashrc profile screenrc topazini ].each do |dotfile|
  cookbook_file "#{home_dir}/.#{dotfile}" do
    source  dotfile
    owner   username
    group   username
    mode    0644
    action  :create_if_missing
  end
end


# glass home dir is owned by root???
bash "chown home dir" do
  code "chown #{username}:#{username} #{home_dir}"
  not_if "[ ! -O #{home_dir} ]"
end

#-----[ Main GemStone setup

# Use the setupSharedMemory script?
bash "Configure kernel for more shared memory" do
  user "root"
  code "echo 'kernel.shmmax = 786146304 # for GemStone' >> /etc/sysctl.conf"
  # code "echo 'kernel.shmmax = 209715200 # 200 MB for GemStone' >> /etc/sysctl.conf"
  not_if "grep -q 'GemStone' /etc/sysctl.conf"
end

bash "Set up timezone" do
  code <<-CMD
    mv /etc/localtime /etc/localtime.bak
    ln -sf /usr/share/zoneinfo/#{node[:gemstone][:timezone]} /etc/localtime
  CMD
  not_if "[ -e /etc/localtime.bak ]"
end

bash "Set the language and locale" do
  code <<-CMD
    locale-gen #{node[:gemstone][:locale]}
    /usr/sbin/update-locale LANG=#{node[:gemstone][:locale]}
  CMD
  not_if "echo $(locale) | grep -q 'LANG=#{node[:gemstone][:locale]}'"
end

bash "Setup a well-known port for GemStone client access" do
  user "root"
  code "echo 'gs64ldi 50377/tcp # GemStone/S 64 Bit' >> /etc/services"
  not_if "grep -q 'GemStone' /etc/services"
end

bash "Alias localhost to the glass appliance" do
  user "root"
  code "echo '127.0.0.1  glass' >> /etc/hosts"
  not_if "grep -q 'glass' /etc/hosts"
end

remote_directory "/opt/gemstone" do
  source        "gemstone"
  owner         username
  files_owner   username
end

zip_filename = "GemStone64Bit#{node[:gemstone][:version]}-#{node[:gemstone][:platform]}"

bash "Download GemStone" do
  cwd "/opt/gemstone"
  code "wget ftp://ftp.gemstone.com/pub/GemStone64/#{node[:gemstone][:version]}/#{zip_filename}.zip"
  not_if "[ -e /opt/gemstone/#{zip_filename}.zip ]"
end

# Download extent that has Seaside30 loaded
bash "Download Seaside30 extent" do
  extent_name = "extent0.dbf"
  # Hosted on JohnnyT's rackspace account - has Seaside30 loaded
  remote_file = "http://c0084442.cdn2.cloudfiles.rackspacecloud.com/#{extent_name}"

  cwd "/opt/gemstone"
  code <<-CODE
    wget #{remote_file}
  CODE
    # cp seaside.dbf data/extent0.dbf
  not_if "[ -e /opt/gemstone/#{extent_name} ]"
end


bash "Install GemStone" do
  cwd "/opt/gemstone"
  code <<-EOH
    unzip #{zip_filename}.zip
    ln -s #{zip_filename} product
    mkdir -p data etc locks log www/glass1 www/glass2 www/glass3
    cp product/data/system.conf etc/
    cp product/seaside/etc/gemstone.key etc/
    cp product/seaside/etc/gemstone.key sys/
    cp extent0.dbf data/extent0.dbf
    touch log/seaside.log
    chmod ug+rw log/*
    chmod 600 data/extent0.dbf
    chown -R #{username}:#{username} .
  EOH
    # cp product/bin/extent0.seaside.dbf data/extent0.dbf

  not_if "[ -e /opt/gemstone/data/extent0.dbf ]"
end


# These get runSeasideGems30 working
%w[ runSeasideGems30 startSeaside30_Adaptor ].each do |filename|
  cookbook_file "/opt/gemstone/product/seaside/bin/#{filename}" do
    source  "gemstone/#{filename}"
    owner   username
    group   username
    mode    0755
    # action  :create_if_missing
  end
end

template "/opt/gemstone/product/seaside/defSeaside" do
  source  "defSeaside.erb"
  mode    "0444"
  owner   username
  group   username
end

# # NOTE: the server needs to be rebooted before running this
# bash "Load lastest FastCGI" do
#   code <<-CMD
# topaz << EOF
# run
# 
# Gofer new
#     squeaksource: 'MetacelloRepository';
#     package: 'ConfigurationOfSeaside30';
#     load.
# (Smalltalk at: #ConfigurationOfSeaside30) load.
# 
# 
# %
# commit
# logout
# exit
# EOF
#   CMD
# end
