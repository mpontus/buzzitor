# -*- mode: ruby -*-
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty32"
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "2048"]
  end
  config.vm.network :forwarded_port, guest: 3000, host: 3000
  # config.vm.network :private_network, type: "dhcp"
  # config.vm.synced_folder ".", "/vagrant", type: "nfs",
  #   mount_options: %w{nolock,vers=3,udp,noatime,actimeo=1}

  config.vm.provision "chef_solo" do |chef|
    chef.add_recipe "apt"
    chef.add_recipe "nodejs"
    chef.add_recipe "ruby_build"
    chef.add_recipe "ruby_rbenv::system"
    chef.add_recipe "redisio"
    chef.add_recipe "redisio::enable"
    chef.json = {
      rbenv: {
        rubies: [ '2.3.1' ],
        global: '2.3.1',
        gems: { '2.3.1' => [{ 'name' => 'bundler' },
                            { 'name' => 'foreman' }]}
      }
    }
  end

  # config.vm.provision "ansible_local" do |ansible|
  #   ansible.playbook = "playbook.yml"
  # end
end
