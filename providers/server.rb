include ::Pritunl::Helper

include Chef::DSL::IncludeRecipe

use_inline_resources

# Support whyrun
def whyrun_supported?
  true
end

action :create do
  if current_resource.exists
    Chef::Log.info "#{ @new_resource } already exists - nothing to do."
  else
    converge_by("Create #{ @new_resource }") do
      create_server
    end
  end

  pritunl_server_org "Create organization for #{new_resource.name}" do
    organization new_resource.organization
    only_if { new_resource.organization }
  end
end

action :stop do
  if !current_resource.exists
    Chef::Log.info "#{ @new_resource } don't exists - nothing to do."
  else
    ruby_block "Stop #{new_resource.name}" do
      block do
        server_operation_site(new_resource.name, 'stop').put ''
      end
    end
  end
end

action :start do
  if !current_resource.exists
    Chef::Log.info "#{ @new_resource } don't exists - nothing to do."
  else
    ruby_block "Start #{new_resource.name}" do
      block do
        server_operation_site(new_resource.name, 'start').put ''
      end
    end
  end
end

action :restart do
  if !current_resource.exists
    Chef::Log.info "#{ @new_resource } don't exists - nothing to do."
  else
    ruby_block "Restart #{new_resource.name}" do
      block do
        server_operation_site(new_resource.name, 'restart').put ''
      end
    end
  end
end

def load_current_resource
  include_recipe "pritunl::_common"
  @current_resource = Chef::Resource::PritunlServer.new(@new_resource.name)
  @current_resource.name(@new_resource.name)

  @current_resource.exists = true unless server(current_resource.name).empty?
end

def create_server
  ruby_block "Create #{new_resource}" do
    block do
      options = {
        'name' => new_resource.name,
        'network' => new_resource.network,
        'interface' => new_resource.interface,
        'port' => new_resource.port,
        'protocol' => new_resource.protocol,
        'local_networks' => new_resource.local_networks,
        'public_address' => new_resource.public_address,
        'otp_auth' => new_resource.otp_auth,
        'lzo_compression' => new_resource.lzo_compression,
        'debug' => new_resource.debug
      }.delete_if { |k, v| v.nil? }

      servers_site.post "#{options.to_json}"
    end
  end
end
