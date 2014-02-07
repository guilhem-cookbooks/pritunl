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
      create_user
    end
  end
end


def load_current_resource
  include_recipe "pritunl::_common"
  @current_resource = Chef::Resource::PritunlUser.new(@new_resource.name)
  @current_resource.name(@new_resource.name)
  @current_resource.organization(@new_resource.organization)

  @current_resource.exists = true unless user(current_resource.name, current_resource.organization).empty?
end

def create_user
  ruby_block "Create #{@new_resource}" do
    block do
      users_site(current_resource.organization).post "#{{ 'name' => current_resource.name }.to_json}"
    end
  end
end
