define :setup_home_dir do
  username = params[:name]
  home_dir = "/home/#{username}"

  directory home_dir do
    owner username
    group username
    mode 0755
    action :create
  end

  %w[ bin home tmp .ssh .vim ].each do |source_dir|
    local_dir = source_dir.to_s.gsub(".", "")

    remote_directory "#{home_dir}/#{source_dir}" do
      source  local_dir
      owner   username
      group   username
      mode    0700
      files_owner username
      files_group username
      files_mode  local_dir == "bin" ? 0700 : 0600
    end
  end

  if (keys = (node[:accounts][username] || {})[:keys])
    template "#{home_dir}/.ssh/authorized_keys" do
      source  "authorized_keys.erb"
      mode    "0600"
      owner   username
      group   username
      variables(:keys => keys)
    end
  end

  %w[ bashrc gemrc irbrc profile rdebugrc rvmrc screenrc ].each do |dotfile|
    cookbook_file "#{home_dir}/.#{dotfile}" do
      source  dotfile
      owner   username
      group   username
      mode    0644
      action  :create_if_missing
    end
  end

  path = "#{home_dir}/bin"
  execute "Add #{path} to path" do
    command %Q{echo '[[ \$PATH != *#{path}* ]] && export PATH="#{path}:\$PATH"' >> /home/#{username}/home/path.sh}
    not_if "grep -q '#{path}' /home/#{username}/home/path.sh"
  end
end
