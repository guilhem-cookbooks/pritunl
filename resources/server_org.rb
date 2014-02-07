actions :attach
default_action :attach

attribute :server, :kind_of => String, :name_attribute => true
attribute :organization, :kind_of => String, :required => true

attribute :response, :kind_of => String

attr_accessor :exists
