actions :create, :delete
default_action :create

attribute :user, :kind_of => String, :name_attribute => true
attribute :organization, :kind_of => String, :required => true

attribute :path, :kind_of => String, :required => true

attr_accessor :exists, :organization_id
