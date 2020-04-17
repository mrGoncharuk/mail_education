# @summary A short summary of the purpose of this class
#
# A description of what this class does
# mysql -u root --execute="CREATE DATABASE roundcube DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"
# mysql -u root --execute="CREATE USER roundcubeuser@localhost IDENTIFIED BY 'password';"
# mysql -u root --execute="GRANT ALL PRIVILEGES ON roundcube.* TO roundcubeuser@localhost;"
# mysql -u root --execute="flush privileges;"
# mysql -u root roundcube < /var/www/roundcube/SQL/mysql.initial.sql
# @example
#   include mailplatform::configure::mysql

class mailplatform::configure::mysql (
  String $password = $mailplatform::configure_mysql_rc_pass,
)
{
  # Create a MySQL Database and User for Roundcube
  #  systemctl start mysqld
  $roundcube_mysql_password = $password
  service { 'mysqld':
    ensure => running,
    enable => true,
  }
  exec { 'db create':
      unless  => '/usr/bin/mysql -u root roundcube',
      command => "/usr/bin/mysql -uroot  -e \"CREATE DATABASE roundcube DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;\"",
      require => Service['mysqld'],
  }
  exec  {'db create user':
      unless  => "/usr/bin/mysql -u roundcubeuser -p${roundcube_mysql_password}",
      command => "/usr/bin/mysql -uroot  -e \"CREATE USER roundcubeuser@localhost IDENTIFIED BY '${roundcube_mysql_password}';\"",
      require => Exec['db create'],
  }
  exec { 'db grant privileges':
      unless  => "/usr/bin/mysql -u roundcubeuser -p${roundcube_mysql_password} roundcube",
      command => "/usr/bin/mysql -uroot  -e \"GRANT ALL PRIVILEGES ON roundcube.* TO roundcubeuser@localhost;\"",
      require => Exec['db create user'],
      }
  exec { 'db flush privileges':
      unless  => "/usr/bin/mysql -u roundcubeuser -p${roundcube_mysql_password} roundcube",
      command => "/usr/bin/mysql -uroot  -e \"flush privileges;\"",
      require => Exec['db grant privileges'],
      }
  exec { 'db rc init':
      unless  => "/usr/bin/mysql -u root roundcube -e 'desc searches;'",
      command => '/usr/bin/mysql -uroot roundcube < /var/www/roundcube/SQL/mysql.initial.sql',
      require => Exec['db flush privileges'],
  }

}

#class { 'mailplatform::configure::mysql':
#  password => 'temp123',
#}
