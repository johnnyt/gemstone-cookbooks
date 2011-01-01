# Setup the init.d services
# gs_fastcgi - not working yet
%w[ gemstone netldi ].each do |service_name|
  cookbook_file "/etc/init.d/#{service_name}" do
    source  "initd/#{service_name}"
    owner   "glass"
    group   "glass"
    mode    0755
    action  :create_if_missing
  end
  
  service service_name do
    supports :status => true, :restart => true, :reload => true
    action :enable
  end
end
