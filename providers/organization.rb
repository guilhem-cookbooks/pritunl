include ::Pritunl::Helper

include Chef::DSL::IncludeRecipe

# Support whyrun
def whyrun_supported?
  true
end


action :create do
  if current_resource.exists
    Chef::Log.info "#{ @new_resource } already exists - nothing to do."
  else
    converge_by("Create #{ @new_resource }") do
      create_org
    end
  end
end


def load_current_resource
  include_recipe "pritunl::_common"
  @current_resource = Chef::Resource::PritunlOrganization.new(@new_resource.name)
  @current_resource.name(@new_resource.name)

  @current_resource.exists = true if organization_exists?(current_resource.name)
end

def organization_exists?(name)
  JSON.parse(org_site.get).one? {|org| org['name'] == name}
end

def create_org
  ruby_block "Create #{@new_resource}" do
    block do
      org_site.post "#{{ 'name' => current_resource.name }.to_json}"
    end
  end
end

def org_site
  pritunl_site['/organization']
end
