# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include mailplatform::configure
class mailplatform::configure {
  $hstname = "allinone-mh.localhost"
  
  exec { "change hostname":
    command  => "/usr/bin/hostnamectl set-hostname $hstname",
  }
  define php_conf (
  ) {
    $str =
  "
  <?php
  
  /* Local configuration for Roundcube Webmail */
  
  // ----------------------------------
  // SQL DATABASE
  // ----------------------------------
  // Database connection string (DSN) for read+write operations
  // Format (compatible with PEAR MDB2): db_provider://user:password@host/database
  // Currently supported db_providers: mysql, pgsql, sqlite, mssql, sqlsrv, oracle
  // For examples see http://pear.php.net/manual/en/package.database.mdb2.intro-dsn.php
  // Note: for SQLite use absolute path (Linux): 'sqlite:////full/path/to/sqlite.db?mode=0646'
  //       or (Windows): 'sqlite:///C:/full/path/to/sqlite.db'
  // Note: Various drivers support various additional arguments for connection,
  //       for Mysql: key, cipher, cert, capath, ca, verify_server_cert,
  //       for Postgres: application_name, sslmode, sslcert, sslkey, sslrootcert, sslcrl, sslcompression, service.
  //       e.g. 'mysql://roundcube:@localhost/roundcubemail?verify_server_cert=false'
  \$config['db_dsnw'] = 'mysql://roundcubeuser:password@localhost/roundcube';
  
  // ----------------------------------
  // IMAP
  // ----------------------------------
  // The IMAP host chosen to perform the log-in.
  // Leave blank to show a textbox at login, give a list of hosts
  // to display a pulldown menu or set one host as string.
  // Enter hostname with prefix ssl:// to use Implicit TLS, or use
  // prefix tls:// to use STARTTLS.
  // Supported replacement variables:
  // %n - hostname (\$_SERVER['SERVER_NAME'])
  // %t - hostname without the first part
  // %d - domain (http hostname \$_SERVER['HTTP_HOST'] without the first part)
  // %s - domain name after the '@' from e-mail address provided at login screen
  // For example %n = mail.domain.tld, %t = domain.tld
  // WARNING: After hostname change update of mail_host column in users table is
  //          required to match old user data records with the new host.
  \$config['default_host'] = 'localhost';
  
  // SMTP port. Use 25 for cleartext, 465 for Implicit TLS, or 587 for STARTTLS (default)
  \$config['smtp_port'] = 25;
  
  // provide an URL where a user can get support for this Roundcube installation
  // PLEASE DO NOT LINK TO THE ROUNDCUBE.NET WEBSITE HERE!
  \$config['support_url'] = '';
  
  // This key is used for encrypting purposes, like storing of imap password
  // in the session. For historical reasons it's called DES_key, but it's used
  // with any configured cipher_method (see below).
  \$config['des_key'] = 'bmvFmezqIpUEbO4NOGnyVC08';
  
  // Name your service. This is displayed on the login screen and in the window title
  \$config['product_name'] = 'Roundcube MH';
  
  // ----------------------------------
  // PLUGINS
  // ----------------------------------
  // List of active plugins (in plugins/ directory)
  \$config['plugins'] = array();
  \$config['enable_installer'] = false;
  ?>
  
  "
  
    file { '/var/www/roundcube/config/config.inc.php':
      content => $str,
      notify  => Service['httpd'],
    }
    
    service {'httpd':
      ensure => running,
      enable => true,
    }
  }

  php_conf {"creates config file for php":}

  define roundcube_conf (
    String $virtualhost = '*:80',
    String $servername  = '127.0.0.1'
  ) {
      $str =
  "
  <VirtualHost ${virtualhost}>
    ServerName ${servername}
    DocumentRoot /var/www/roundcube/
  
    ErrorLog /var/log/httpd/roundcube_error.log
    CustomLog /var/log/httpd/roundcube_access.log combined
  
    <Directory />
      Options FollowSymLinks
      AllowOverride All
    </Directory>
  
    <Directory /var/www/roundcube/>
      allow from all
    </Directory>
  
  </VirtualHost>
  "
  
    file { '/etc/httpd/conf.d/roundcube.conf':
      content => $str,
      notify  => Service['httpd'],
    }
  
    service {'httpd':
      ensure => running,
      enable => true,
    }
  }
  
  $virtualhost=undef
  $servername=undef
  roundcube_conf {"creates config for roundcube":
      virtualhost => $virtualhost,
      servername  => $servername,
  }

  # mysql -u root --execute="CREATE DATABASE roundcube DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"
  # mysql -u root --execute="CREATE USER roundcubeuser@localhost IDENTIFIED BY 'password';"
  # mysql -u root --execute="GRANT ALL PRIVILEGES ON roundcube.* TO roundcubeuser@localhost;"
  # mysql -u root --execute="flush privileges;"
  # mysql -u root roundcube < /var/www/roundcube/SQL/mysql.initial.sql

   define mysqldb() {

      exec { "db create":
          unless  => "/usr/bin/mysql -u root roundcube",
          command => "/usr/bin/mysql -uroot  -e \"CREATE DATABASE roundcube DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;\"",
          require => Service["mysqld"],
      }

      exec  {"db create user":
          unless  => "/usr/bin/mysql -u roundcubeuser -ppassword",
          command => "/usr/bin/mysql -uroot  -e \"CREATE USER roundcubeuser@localhost IDENTIFIED BY 'password';\"",
          require => Service["mysqld"],
      }

      exec { "db grant privileges":
          unless => "/usr/bin/mysql -u roundcubeuser -ppassword roundcube",
          command => "/usr/bin/mysql -uroot  -e \"GRANT ALL PRIVILEGES ON roundcube.* TO roundcubeuser@localhost;\"",
          require => Service["mysqld"],
          }
  
      exec { "db flush privileges":
          unless => "/usr/bin/mysql -u roundcubeuser -ppassword roundcube",
          command => "/usr/bin/mysql -uroot  -e \"flush privileges;\"",
          require => Service["mysqld"],
          }
  
      exec { "db rc init":
          unless => "/usr/bin/mysql -u root roundcube -e 'desc searches;'",
          command => "/usr/bin/mysql -uroot roundcube < /var/www/roundcube/SQL/mysql.initial.sql",
          require => Service["mysqld"],
      }
  }
  
  
  # systemctl start httpd
  service { 'httpd':
    ensure => running,
    enable => true,
  }
      # Create a MySQL Database and User for Roundcube
  # systemctl start mysqld
  service { 'mysqld':
    ensure => running,
    enable => true,
  }
  
  mysqldb { "init mysql for roundcube": }
      # PHP-MySQL extension
  # yum -y install php-mysql      //TODO: ensure installing
  
      # SE Linux permission configuration
  # chcon -t httpd_sys_content_t /var/www/roundcube/ -R
  
  file { "/var/www/roundcube/":
      ensure  => directory,
      recurse => true,
      seltype => "httpd_sys_content_t",
  }
  
  # chcon -t httpd_sys_rw_content_t /var/www/roundcube/temp/ /var/www/roundcube/logs/ -R
  file { "/var/www/roundcube/temp/":
      ensure  => directory,
      recurse => true,
      seltype => "httpd_sys_rw_content_t",
  }
  
  file { "/var/www/roundcube/logs/":
      ensure  => directory,
      recurse => true,
      seltype => "httpd_sys_rw_content_t",
  }
  
  
  # setfacl -R -m u:apache:rwx /var/www/roundcube/temp/ /var/www/roundcube/logs/
  exec { "setfacl apache":
      command => "/usr/bin/setfacl -R -m u:apache:rwx /var/www/roundcube/temp/ /var/www/roundcube/logs/",
  }
  
  
  # setsebool -P httpd_can_network_connect 1
  
  selboolean { 'setting up httpd_can_network_connect to true':
    name       => "httpd_can_network_connect",
    value      => 'on',
  }
  
  
  # Setting up inet_interfaces to all(listening all addresses)
  
  file_line {'Setting up inet_interfaces to all':
    path  => '/etc/postfix/main.cf',
    line  => "inet_interfaces = all",
    match => "inet_interfaces = localhost",
  }
  
  file_line {'Enabling sasl authentication':
    path  => '/etc/postfix/main.cf',
    line  => "\n# Custom added options\nsmtpd_sasl_auth_enable = yes",
  }
  
  file_line {'Setting up mbox path':
    path  => '/etc/dovecot/conf.d/10-mail.conf',
    line  => 'mail_location = mbox:~/mail:INBOX=/var/mail/%u',
    match => '#   mail_location = mbox:~/mail:INBOX=/var/mail/%u',
  }
  
  file_line { 'removing manager from alias list':
    ensure => absent,
    path => '/etc/aliases',
    match => 'manager',
    match_for_absence => true,
  }
  
  file_line {' Uncomment local-port 53 at pdns-recursor config file':
    path  => '/etc/pdns-recursor/recursor.conf',
    line  => 'local-port=53',
    match => '# local-port=53',
  }
  
  file_line {'Uncomment local-port at pdns config file and changing port value to 54':
    path  => '/etc/pdns/pdns.conf',
    line  => 'local-port=54',
    match => '# local-port=53',
  }
  
  # Creating custom named.conf and adding path to him to pdns.conf
  file { '/etc/pdns/named.conf':
    source => '/vagrant/config_files/named.conf'
  }
  file_line {' adding path to named.conf to pdns config':
    path  => '/etc/pdns/pdns.conf',
    line  => 'bind-config=/etc/pdns/named.conf',
  }
  
  # Creating directory for zone file and copying it to his directory
  file{"/var/lib/pdns":
      ensure  =>  directory,
  }
  file{"/var/lib/pdns/youdidnotevenimaginethisdomainexists.com.db":
      ensure  =>  file,
      content =>  template("/vagrant/config_files/youdidnotevenimaginethisdomainexists.com.db"),
      require => File["/var/lib/pdns"],
  }
  
  # Configuring forward-zones
  file_line {'Configuring forward-zones':
    path  => '/etc/pdns-recursor/recursor.conf',
    line  => 'forward-zones=youdidnotevenimaginethisdomainexists.com=127.0.0.1:54',
    match => "# forward-zones=",
  
  }
  
  # Setting up Timezone for PHP
  file_line {'Setting up Timezone for PHP':
    path  => '/etc/php.ini',
    line  => "date.timezone = 'UTC'",
    match => ";date.timezone =",
  }
  
  exec { "change mod to user's mailhome folders":
      command => "/usr/bin/chmod 0600 /var/mail/*"
  }
  
  # Hint taken from https://ask.puppet.com/question/27007/how-to-recursively-chmod-files-in-directory/
  file {'Ensure proper permissions for mail location':
    path => '/var/mail',
    recurse => true,
    recurselimit => 1,
    ensure => directory,
    mode => '0600',
  }
  
  # From https://puppet.com/docs/puppet/5.5/types/exec.html#exec-attribute-refreshonly
  # Rebuild the database, but only when the file changes
  exec { newaliases:
    path        => ['/usr/bin', '/usr/sbin'],
    subscribe   => File_line['removing manager from alias list'],
    refreshonly => true,
  }
  }
