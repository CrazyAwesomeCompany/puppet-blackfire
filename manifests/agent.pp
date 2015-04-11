class blackfire::agent (
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
    case $operatingsystem {
      'RedHat', 'CentOS': { $repository = "redhat" }
      /^(Debian|Ubuntu)$/:{ $repository = "debian" }
    }

    class { "blackfire::repo::$repository":
        before => Package["blackfire-agent"]
    }

    package { "blackfire-agent":
        ensure => present,
    }

    service { "blackfire-agent":
        ensure => running,
        binary => "/etc/init.d/blackfire-agent",
        require => Package["blackfire-agent"],
    }

    file { "/etc/blackfire/agent":
        content => template('blackfire/agent.erb'),
        require => [Package["blackfire-agent"], Exec["blackfire-stop"]],
        notify => Service["blackfire-agent"]
    }

    exec { "blackfire-stop":
        command => "/etc/init.d/blackfire-agent stop",
        refreshonly => true
    }
}
