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
        "password" => node['pritunl']['password'] }.to_json,
        :content_type => :json,
        :accept => :json)['auth_token']
    end

    def pritunl_auth(user = node['pritunl']['user'], password = node['pritunl']['password'])
      site = RestClient::Resource.new(node['pritunl']['url'], :headers => { :content_type => :json, :accept => :json })
      @token ||= JSON.parse(site['/auth/token'].post "#{{ 'username' => user, "password" => password }.to_json}")['auth_token']
      ret = { "Auth-Token" => @token }
      Chef::Log.debug "auth = #{ret}"
      ret
    end

    # Organization stuff

    def organization(name)
      JSON.parse(organizations_site.get).find { |org| org['name'] == name } || {}
    end

    def organizations_site
      pritunl_site["/organization"]
    end

    # User stuff

    def user(name, org)
      JSON.parse(users_site(org).get).find { |u| u['name'] == name } || {}
    end

    def users_site(org)
      org_id = organization(org)['id']
      pritunl_site["/user/#{org_id}"]
    end

    # Server stuff
    def server(name)
      JSON.parse(servers_site.get).find { |u| u['name'] == name } || {}
    end

    def servers_site
      pritunl_site["/server"]
    end

    def server_org(server, org)
      JSON.parse(server_org_site(server).get).find { |u| u['name'] == org } || {}
    end

    def server_site(server)
      server_id = server(server)['id']
      pritunl_site["/server/#{server_id}"]
    end

    def server_org_site(server)
      server_id = server(server)['id']
      pritunl_site["/server/#{server_id}/organization"]
    end

    def add_server_org_site(server, org)
      server_id = server(server)['id']
      org_id = organization(org)['id']
      pritunl_site["/server/#{server_id}/organization/#{org_id}"]
    end

    def server_operation_site(server, action)
      server_id = server(server)['id']
      pritunl_site["/server/#{server_id}/#{action}"]
    end

    # key
    def user_key(username, org)
      user_id = user(username, org)['id']
      org_id = user(username, org)['organization']
      pritunl_site["/key/#{org_id}/#{user_id}"]
    end
  end
end
