class blackfire (
    $relversion = 'stable',
    $arch = 'x86_64',
    $ca_cert = '',
    $collector = 'https://blackfire.io',
    $log_file = 'stderr',
    $log_level = 4,
    $socket = 'unix:///var/run/blackfire/agent.sock',
    $server_id = '',
    $server_token = '',
    $spec = ''
) {
    yumrepo { "blackfire":
        baseurl => "http://packages.blackfire.io/fedora/$relversion/$arch",
        descr => "Blackfire",
        enabled => 1,
        gpgcheck => 0,
    }

    package { ["blackfire-agent", "blackfire-php"]:
        ensure => present,
        require => YumRepo["blackfire"]
    }

    service { "blackfire-agent":
        ensure => running,
        binary => "/etc/init.d/blackfire-agent",
        require => Package["blackfire-agent"],
    }

    file { "/etc/blackfire/agent":
        content => template('blackfire/agent.erb'),
        require => Exec["blackfire-stop"],
        notify => Service["blackfire-agent"]
    }

    exec { "blackfire-stop":
        command => "/etc/init.d/blackfire-agent stop",
        refreshonly => true
    }

    file { "/etc/php.d/zz-blackfire.ini":
        content => template('blackfire/blackfire.ini.erb')
    }

    if defined(Service["php-fpm"]) {
         File["/etc/php.d/zz-blackfire.ini"] ~> Service["php-fpm"]
    }
}
