class blackfire::repo::debian {
    if ! defined(Package['curl']) {
        package { 'curl': ensure => installed, }
    }

    exec { 'import-key':
        path    => '/bin:/usr/bin',
        command => 'curl https://packagecloud.io/gpg.key | apt-key add -',
        unless  => 'apt-key list | grep packagecloud',
        require => Package['curl'],
    }


    file { 'blackfire.repo':
        path    => '/etc/apt/sources.list.d/blackfire.list',
        ensure  => present,
        content => 'deb http://packages.blackfire.io/debian any main',
        require => Exec['import-key'],
    }

    exec { 'apt-get-update':
        command => 'apt-get update',
        path    => ['/bin', '/usr/bin'],
        require => File['blackfire.repo'],
    }
}
