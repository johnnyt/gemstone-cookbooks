default[:nginx][:version]      = "0.8.53"
default[:nginx][:install_path] = "/opt/nginx-#{nginx[:version]}"
default[:nginx][:src_binary]   = "#{nginx[:install_path]}/sbin/nginx"
default[:nginx][:default_site] = "/var/www/nginx-default"
default[:nginx][:pid_file]     = "/var/run/nginx.pid"
default[:nginx][:dir]     = "/etc/nginx"
default[:nginx][:log_dir] = "/var/log/nginx"
default[:nginx][:user]    = "www-data"
default[:nginx][:conf_path] = "#{nginx[:dir]}/nginx.conf"

default[:nginx][:configure_flags] = [
  "--prefix=#{nginx[:install_path]}",
  "--conf-path=#{nginx[:conf_path]}",
  "--with-http_ssl_module",
  "--with-http_gzip_static_module"
]

default[:nginx][:keepalive]          = "on"
default[:nginx][:keepalive_timeout]  = 65
default[:nginx][:worker_processes]   = 4
default[:nginx][:worker_connections] = 1024
default[:nginx][:server_names_hash_bucket_size] = 64
