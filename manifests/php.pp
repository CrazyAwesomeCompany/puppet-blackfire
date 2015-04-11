class blackfire::php {
    package { "blackfire-php":
        ensure => present,
    }

    #file { "/etc/php.d/zz-blackfire.ini":
    #    content => template('blackfire/blackfire.ini.erb')
    #}

    if defined(Service["php-fpm"]) {
         File["/etc/php.d/zz-blackfire.ini"] ~> Service["php-fpm"]
    }
}
