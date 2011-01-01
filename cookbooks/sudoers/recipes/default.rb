template "/etc/sudoers" do
  source "sudoers.erb"
  mode "440"
  owner "root"
  group "root"
end
