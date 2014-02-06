require 'rest-client'
require 'json'

module Pritunl
  module Helper

    @@token 

    def pritunl_site
      define_token unless defined? @@token
        
      RestClient::Resource.new(node['pritunl']['url'], :headers => { :content_type => :json, :accept => :json, "Auth-Token" => @@token })
    end

    def define_token
      @@token = JSON.parse(RestClient.post "#{node['pritunl']['url']}/auth/token", {
        'username' => node['pritunl']['user'],
        "password" => node['pritunl']['password']}.to_json,
        :content_type => :json,
        :accept => :json)['auth_token']
    end

    def pritunl_auth(user = node['pritunl']['user'], password = node['pritunl']['password'])
      site = RestClient::Resource.new(node['pritunl']['url'], :headers => { :content_type => :json, :accept => :json })
      @token ||= JSON.parse(site['/auth/token'].post "#{{ 'username' => user, "password" => password }.to_json}")['auth_token']
      ret = { "Auth-Token" => @token }
      Chef::Log.debug "auth = #{ret}"
      return ret
    end 
  end
end
