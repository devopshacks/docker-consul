require "serverspec"
require "docker"

set :backend, :docker

describe "Dockerfile" do
  before(:all) do
    @server1 = Docker::Container.create(
      'name' => 'consul-server-1',
      'Image' => ENV['DOCKER_IMAGE_NAME'] + ':' + ENV['DOCKER_IMAGE_TAG'],
      'Env' => [
        'CONSUL_SERVER=1',
        'CONSUL_NODENAME=consul-server-1',
        'CONSUL_ACLMASTERTOKEN=token',
        'CONSUL_RETRYJOIN=[]'
      ],
      'HostConfig' => {
        'Links' => [
        ]
      }
    )
    @server1.start

    @server2 = Docker::Container.create(
      'name' => 'consul-server-2',
      'Image' => ENV['DOCKER_IMAGE_NAME'] + ':' + ENV['DOCKER_IMAGE_TAG'],
      'Env' => [
        'CONSUL_SERVER=1',
        'CONSUL_NODENAME=consul-server-2',
        'CONSUL_ACLMASTERTOKEN=token',
        'CONSUL_RETRYJOIN=["consul-server-1"]'
      ],
      'HostConfig' => {
        'Links' => [
          'consul-server-1'
        ]
      }
    )
    @server2.start

    @server3 = Docker::Container.create(
      'name' => 'consul-server-3',
      'Image' => ENV['DOCKER_IMAGE_NAME'] + ':' + ENV['DOCKER_IMAGE_TAG'],
      'Env' => [
        'CONSUL_SERVER=1',
        'CONSUL_NODENAME=consul-server-3',
        'CONSUL_ACLMASTERTOKEN=token',
        'CONSUL_RETRYJOIN=["consul-server-1"]'
      ],
      'HostConfig' => {
        'Links' => [
          'consul-server-1'
        ]
      }
    )
    @server3.start

    @client = Docker::Container.create(
      'name' => 'consul-client',
      'Image' => ENV['DOCKER_IMAGE_NAME'] + ':' + ENV['DOCKER_IMAGE_TAG'],
      'Env' => [
        'CONSUL_NODENAME=consul-client',
        'CONSUL_ACLMASTERTOKEN=token',
        'CONSUL_RETRYJOIN=["consul-server-1"]'
      ],
      'HostConfig' => {
        'Links' => [
          'consul-server-1'
        ]
      }
    )
    @client.start

    set :docker_container, @client.id
  end

  describe command('consul members') do
    its(:stdout) { should match "consul-client    .*:8301  alive   client  0.6.4  2         dc1" }
    its(:stdout) { should match "consul-server-1  .*:8301  alive   server  0.6.4  2         dc1" }
    its(:stdout) { should match "consul-server-2  .*:8301  alive   server  0.6.4  2         dc1" }
    its(:stdout) { should match "consul-server-3  .*:8301  alive   server  0.6.4  2         dc1" }
  end

  after(:all) do
    if !@server1.nil?
      @server1.delete('force' => true)
    end
    if !@server2.nil?
      @server2.delete('force' => true)
    end
    if !@server3.nil?
      @server3.delete('force' => true)
    end
    if !@client.nil?
      @client.delete('force' => true)
    end
  end
end
