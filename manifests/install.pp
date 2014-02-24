class graphite::install {

  if $graphite::manage_python {

    ensure_packages([
      'libldap2-dev',
      'libsasl2-dev',
      'libsqlite3-dev',
      'libcairo2-dev',
    ])

    class { 'python':
      version    => 'system',
      pip        => true,
      gunicorn   => true,
      virtualenv => true,
      dev        => true,
    }

    file { '/tmp/graphite-requirements.txt':
      ensure => present,
      source => 'puppet:///modules/graphite/requirements.txt',
    }

    python::virtualenv { '/opt/graphite':
      ensure       => present,
      requirements => '/tmp/graphite-requirements.txt',
      require    => [
                      File['/tmp/graphite-requirements.txt'],
                      Package['libldap2-dev'],
                      Package['libsasl2-dev'],
                      Package['libsqlite3-dev'],
                      Package['libcairo2-dev'],
                    ],
    }
  } 

  file { '/var/log/carbon':
    ensure => directory,
    owner  => www-data,
    group  => www-data,
  }

  file {'/var/lib/graphite':
    ensure => directory,
    owner  => www-data,
    group  => www-data,
  }

  file {'/var/lib/graphite/db.sqlite3':
    ensure => present,
    owner  => www-data,
    group  => www-data,
  }

}
