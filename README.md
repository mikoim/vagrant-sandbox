# vagrant-sandbox
A PHP application development environment with Vagrant.

 * Apache HTTP Server 2.4.x
 * PHP 5.6.x from ppa:ondrej/php5-5.6
 * MySQL Community Server 5.7.x from Oracle repository

## Getting Started
```bash
git clone git@github.com:dit-rohm/vagrant-sandbox.git
cd vagrant-sandbox
vagrant up
```

* /public_html : [http://localhost:8080/](http://localhost:8080/)
* phpMyAdmin : [http://localhost:8080/phpmyadmin](http://localhost:8080/phpmyadmin)

## Requirements
 * Vagrant : [https://www.vagrantup.com/](https://www.vagrantup.com/)
 * VirtualBox : [https://www.virtualbox.org/](https://www.virtualbox.org/)

## Directory structure
```
.
├── LICENSE
├── README.md
├── Vagrantfile
├── cache : For caching something
│   └── apt
│       ├── apache2-bin_2.4.7-1ubuntu4.6_amd64.deb
│       ├── ...
│       └── ssl-cert_1.0.33_all.deb
├── conf
│   └── virtualhost.conf : Configuration file for Apache2 Web Server
├── install.sh : Provisioning script
└── public_html : Document root
    └── index.php : Sample PHP script
```

## License
[![WTFPL](http://www.wtfpl.net/wp-content/uploads/2012/12/wtfpl-badge-4.png)](http://www.wtfpl.net/)
