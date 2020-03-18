
# mysql -u root --execute="CREATE DATABASE roundcube DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"
# mysql -u root --execute="CREATE USER roundcubeuser@localhost IDENTIFIED BY 'password';"
# mysql -u root --execute="GRANT ALL PRIVILEGES ON roundcube.* TO roundcubeuser@localhost;"
# mysql -u root --execute="flush privileges;"
# mysql -u root roundcube < /var/www/roundcube/SQL/mysql.initial.sql



define mysqldb() {

    exec { "db create":
        unless => "/usr/bin/mysql -u root",
        command => "/usr/bin/mysql -uroot  -e \"CREATE DATABASE roundcube DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;\"",
        require => Service["mysqld"],
    }

    exec  {"db create user":
        unless => "/usr/bin/mysql -u root",
        command => "/usr/bin/mysql -uroot  -e \"CREATE USER roundcubeuser@localhost IDENTIFIED BY 'password';\"",
        require => Service["mysqld"],
    }

    exec { "db grant privileges":
        unless => "/usr/bin/mysql -u root",
        command => "/usr/bin/mysql -uroot  -e \"GRANT ALL PRIVILEGES ON roundcube.* TO roundcubeuser@localhost;\"",
        require => Service["mysqld"],
        }

    exec { "db flush privileges":
        unless => "/usr/bin/mysql -u root",
        command => "/usr/bin/mysql -uroot  -e \"flush privileges;\"",
        require => Service["mysqld"],
        }

    exec { "db rc init":
        unless => "/usr/bin/mysql -u root",
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