%w[ xauth libgl1-mesa-dev ia32-libs ].each{ |pkg| package pkg }

# bash "Enable X11 forwarding" do
#   user "root"
#   code "echo 'kernel.shmmax = 209715200 # 200 MB for GemStone' >> /etc/sysctl.conf"
#   not_if "grep -q 'GemStone' /etc/sysctl.conf"
# end

username = node[:gemstone][:user][:name] 

bash "Download GemTools" do
  cwd "/opt/gemstone"
  code "wget http://seaside.gemstone.com/squeak/#{node[:gemstone][:gemtools]}.zip"
  not_if "[ -e /opt/gemstone/#{node[:gemstone][:gemtools]}.zip ]"
end

bash "Install GemTools" do
  cwd "/opt/gemstone"
  code <<-EOH
    unzip #{node[:gemstone][:gemtools]}.zip
    ln -s #{node[:gemstone][:gemtools]} gemtools
    chmod -R o-w #{node[:gemstone][:gemtools]}
    chown -R #{username}:#{username} #{node[:gemstone][:gemtools]}
  EOH

  not_if "[ -e /opt/gemstone/gemtools ]"
end
