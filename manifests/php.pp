class blackfire::php {
    case $operatingsystem {
      'RedHat', 'CentOS': { $ini_path = "/etc/php.d/zz-blackfire.ini" }
      /^(Debian|Ubuntu)$/:{ $ini_path = "/etc/php5/mods-available/blackfire.ini" }
    }

    package { "blackfire-php":
        ensure => present,
    }

    file { "$ini_path":
        content => template('blackfire/blackfire.ini.erb')
    }

    if defined(Service["php-fpm"]) {
         File["$ini_path"] ~> Service["php-fpm"]
    }
}
