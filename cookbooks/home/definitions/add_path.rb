define :add_path do
  node[:accounts].each do |username, options|
    execute "Add #{params[:name]} to path" do
      command %Q{echo '[[ \$PATH != *#{params[:name]}* ]] && export PATH="#{params[:name]}:\$PATH"' >> /home/#{username}/home/path.sh}
      not_if "grep -q '#{params[:name]}' /home/#{username}/home/path.sh"
    end
  end
end
