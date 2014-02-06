require 'digest/sha2'

salt = "2511cebca93d028393735637bbc8029207731fcf"

conf = {
  "log_path"  => "/var/log/pritunl.log",
  "data_path" => node['pritunl']['data_path'],
  "ssl" => node['pritunl']['ssl'] ? "true" : "false",
  "log_debug" => "true",
  "port" => node['pritunl']['port'],
  "bind_addr" => node['pritunl']['bind'],
  "password" => Digest::SHA512.hexdigest(node['pritunl']['password'] + salt),
  "debug" => "true",
  "db_path" => ::File.join(node['pritunl']['data_path'], "pritunl.db"),
}


template "Pritunl configuration" do
  path "/etc/pritunl.conf"
  source "pritunl.conf.erb"
  variables :conf => conf
  notifies :restart, "service[pritunl]", :immediately
end.run_action_now
