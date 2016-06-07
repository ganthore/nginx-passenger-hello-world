exec { 'apt-update':
  command => 'apt-get update',
  path    => '/bin:/usr/bin',
  timeout => 0
}

apt::ppa { 'ppa:brightbox/ruby-ng-experimental':
  before => Exec['apt-update']
}

package { [
  'curl',
  'libsqlite3-dev',
  'build-essential',
  'ruby2.1-dev',
]:
  ensure	=> present,
  require        => Exec['apt-update'],
}

class { 'ruby':
  version            => '2.1.0',
  set_system_default => 'true',
  require             => Exec['apt-update'],
}

class { 'nginx':
  package_name	  => 'nginx-extras',
  daemon_user     => 'vagrant',
  root_group      => 'vagrant',
  package_source  => 'passenger',
  require          => Exec['apt-update'],
  http_cfg_append => {
    'passenger_root' => '/usr/lib/ruby/vendor_ruby/phusion_passenger/locations.ini',
  }
}

nginx::resource::vhost { 'localhost':
  ensure           => present,
  require          => [
    Package[nginx],
    Exec['apt-update'],
  ],
  notify           => Service[nginx],
  server_name      => ['localhost'],
  listen_port      => 80,
  www_root         => '/opt/www/public',
  vhost_cfg_append => {
    'passenger_enabled' => 'on',
    'passenger_ruby'    => '/usr/bin/ruby'
  }
}

bundler::install { '/opt/www':
  user       => 'vagrant',
  group      => 'vagrant',
  deployment => true,
  without    => 'test doc'
}