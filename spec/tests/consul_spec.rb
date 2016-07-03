require "serverspec"
require "docker"

set :backend, :docker

describe "Dockerfile" do
  before(:all) do
    @container = Docker::Container.create(
      :Image => ENV['DOCKER_IMAGE_NAME'] + ':' + ENV['DOCKER_IMAGE_TAG'],
      :Tty => true,
      :Cmd => 'bash'
    )
    @container.start
    set :docker_container, @container.id
  end

  describe command('consul version') do
    its(:stdout) { should match "Consul v0.6.4" }
  end

  after(:all) do
    if !@container.nil?
      @container.delete(:force => true)
    end
  end
end
