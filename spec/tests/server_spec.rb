require "serverspec"
require "docker"

set :backend, :docker

describe "Dockerfile" do
  before(:all) do
    @container = Docker::Container.create(
      'Image' => ENV['DOCKER_IMAGE_NAME'] + ':' + ENV['DOCKER_IMAGE_TAG'],
      'Env' => [
        'CONSUL_SERVER=1',
        'CONSUL_NODENAME=consul-server',
        'CONSUL_ACLMASTERTOKEN=token',
        'CONSUL_RETRYJOIN=[]',
        'CONSUL_BOOTSTRAPEXPECT=1'
      ]
    )
    @container.start
    @container.exec(['install-dev-tools'])

    set :docker_container, @container.id
  end

  describe command('consul members') do
    its(:stdout) { should match "consul-server  .*:8301  alive   server  0.6.4  2         dc1" }
  end

  describe command('curl -sSLI http://127.0.0.1:8500/ui/') do
    its(:stdout) { should match "HTTP/1.1 200 OK" }
  end

  after(:all) do
    if !@container.nil?
      @container.delete('force' => true)
    end
  end
end
