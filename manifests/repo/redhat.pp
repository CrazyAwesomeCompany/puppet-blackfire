class blackfire::repo::redhat {
    yumrepo { "blackfire":
        baseurl => "http://packages.blackfire.io/fedora/$relversion/$arch",
        descr => "Blackfire",
        enabled => 1,
        gpgcheck => 0,
    }
}
