apt_repository 'pritunl' do
  uri          'http://ppa.launchpad.net/pritunl/ppa/ubuntu'
  distribution node['lsb']['codename']
  components   ['main']
  keyserver    'keyserver.ubuntu.com'
  key          'C5B39158'
end
