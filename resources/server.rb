actions :create, :stop, :start, :restart
default_action :create

attribute :name, :kind_of => String, :name_attribute => true
attribute :network, :kind_of => String
attribute :interface, :kind_of => String
attribute :port, :kind_of => Integer
attribute :protocol, :kind_of => String
attribute :local_networks, :kind_of => Array, :default => nil
attribute :public_address, :kind_of => String
attribute :otp_auth, :kind_of => [TrueClass, FalseClass]
attribute :lzo_compression, :kind_of => [TrueClass, FalseClass]
attribute :debug, :kind_of => [TrueClass, FalseClass]

attribute :organization, :kind_of => String

attribute :response, :kind_of => String

attr_accessor :exists
