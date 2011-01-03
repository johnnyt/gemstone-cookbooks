require_recipe "apt"

%w[ libpcre3 libpcre3-dev libssl-dev libcurl4-openssl-dev ].each{ |pkg| package pkg }

nginx_version = node[:nginx][:version]
configure_flags = node[:nginx][:configure_flags].join(" ")
node.set[:nginx][:daemon_disable] = true

remote_file "/tmp/nginx-#{nginx_version}.tar.gz" do
  source "http://sysoev.ru/nginx/nginx-#{nginx_version}.tar.gz"
  action :create_if_missing
  not_if "[ -e #{node[:nginx][:src_binary]} ]"
end

bash "compile_nginx_source" do
  cwd "/tmp"
  code <<-EOH
    tar zxf nginx-#{nginx_version}.tar.gz
    cd nginx-#{nginx_version} && ./configure #{configure_flags}
    make && make install
  EOH
  creates node[:nginx][:src_binary]
end

directory node[:nginx][:log_dir] do
  mode 0755
  owner node[:nginx][:user]
end

%w[ sites-available sites-enabled conf.d ].each do |dir|
  directory "#{node[:nginx][:dir]}/#{dir}" do
    owner "root"
    group "root"
    mode "0755"
  end
end

%w[ nxensite nxdissite ].each do |nxscript|
  template "/usr/sbin/#{nxscript}" do
    source "#{nxscript}.erb"
    mode "0755"
    owner "root"
    group "root"
    action :create_if_missing
  end
end

template "nginx.conf" do
  path "#{node[:nginx][:dir]}/nginx.conf"
  source "nginx.conf.erb"
  owner "root"
  group "root"
  mode 0644
end

template "nginx.init" do
  path "/etc/init.d/nginx"
  source "nginx.init.erb"
  owner "root"
  group "root"
  mode "0755"
end

# # Default Site
# template "#{node[:nginx][:dir]}/sites-available/#{sitename}" do
#   source "#{sitename}.erb"
#   owner "root"
#   group "root"
#   mode 0644
#   action :create_if_missing
# end
# 
# remote_directory "/var/www/nginx-default" do
#   source  "nginx_default_site"
#   owner   "root"
#   mode    0755
#   files_owner "root"
#   files_mode  0644
# end
# 
# execute "enable_default_site" do
#   command "nxensite default"
#   not_if "[ -e /etc/nginx/sites-enabled/default ]"
# end

# SeaSide site
template "#{node[:nginx][:dir]}/sites-available/seaside" do
  source "seaside-site.erb"
  owner "root"
  group "root"
  mode 0644
  action :create_if_missing
end

execute "Enable SeaSide NGINX site" do
  command "nxensite seaside"
  not_if "[ -e #{node[:nginx][:dir]}/sites-enabled/seaside ]"
end


service "nginx" do
  supports :status => true, :restart => true, :reload => true
  action :enable
  # action [ :enable, :start ]
end
