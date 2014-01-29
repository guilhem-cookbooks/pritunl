
include_recipe "pritunl::repo" if node['pritunl']['use_repo']
include_recipe "pritunl::install_#{node['pritunl']['install_method']}"
