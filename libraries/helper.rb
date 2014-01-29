require 'rest-client'
require 'json'

module Pritunl
  module Helper

    @@token

    def site(address = node['pritunl']['url'])
      RestClient::Resource.new(address, :headers => {:content_type => :json, :accept => :json} )
    end

    def pritunl_site(address = node['pritunl']['url'])
      site.instance_variable_set(:@options, Chef::Mixin::DeepMerge.merge(site.options, {:headers => pritunl_auth }))
    end

    def pritunl_auth(user = node['pritunl']['user'], password = node['pritunl']['password'])
      @@token ||= JSON.parse(site['/auth/token'].post "#{{ 'username' => user, "password" => password}.to_json}")
      header = "Auth-Token"
      return { header => @@token }
    end 
  end
end
