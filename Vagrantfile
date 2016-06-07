Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = 'nginx'
  config.vm.box_check_update = false
  config.vm.network "forwarded_port", guest: 80, host: 9090
  config.vm.synced_folder "app/", "/opt/www"
  
  config.vm.provision "puppet" do |puppet|
   puppet.manifests_path    = 'etc/puppet/manifests'
   puppet.module_path       = 'etc/puppet/modules'
   puppet.manifest_file     = "default.pp"
   puppet.hiera_config_path = "etc/puppet/hiera.yaml"
   puppet.working_directory = "/tmp/vagrant-puppet"
   puppet.options           = '--verbose'
  end
end