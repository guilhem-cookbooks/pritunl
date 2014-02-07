include ::Pritunl::Helper

include Chef::DSL::IncludeRecipe

use_inline_resources

# Support whyrun
def whyrun_supported?
  true
end

action :create do
  remote_file "key" do
    source URI.join(node['pritunl']['url'], JSON.parse(user_key(new_resource.user, new_resource.organization).get)['key_url']).to_s
    path new_resource.path
  end
end


def load_current_resource
  include_recipe "pritunl::_common"
end
