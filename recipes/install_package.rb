
package "pritunl"

service "pritunl" do
  provider Chef::Provider::Service::Upstart
  supports :status => true, :restart => true
end
