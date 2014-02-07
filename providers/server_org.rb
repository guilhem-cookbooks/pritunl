include ::Pritunl::Helper

include Chef::DSL::IncludeRecipe

# Support whyrun
def whyrun_supported?
  true
end


action :attach do
  if current_resource.exists
    Chef::Log.info "#{ @new_resource } already exists - nothing to do."
  else
    converge_by("Attach #{ @new_resource }") do
      attach_org
    end
  end
end


def load_current_resource
  include_recipe "pritunl::_common"
  @current_resource = Chef::Resource::PritunlServerOrg.new(@new_resource.name)
  @current_resource.server(@new_resource.server)
  @current_resource.organization(@new_resource.organization)
  @current_resource.exists = true unless server_org(current_resource.server, current_resource.organization).empty?
end

def attach_org
  ruby_block "Attach #{new_resource.organization} to #{new_resource.server}" do
    block do
      add_server_org_site(new_resource.server, new_resource.organization).put ''
    end
  end
end
