# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   contain mailplatform::configure
class mailplatform::configure {
#1) hostname
  contain mailplatform::configure::hostnamechange
#2) php file creation
  contain mailplatform::configure::php
#3) roundcube file creating and roundcube folder permissions 
  contain mailplatform::configure::roundcube
#4) mysql configuring
  contain mailplatform::configure::mysql
#5) (was here: roundcube folder permissions) 
  contain mailplatform::configure::systems
#6) Postfix  
  contain mailplatform::configure::postfix
#7) Dovecot  
  contain mailplatform::configure::dovecot
#8) pdns-recursor config
  contain mailplatform::configure::pdns_recursor
#9) pdns config
  contain mailplatform::configure::pdns
#10) mailhome permissions
  contain mailplatform::configure::permissions
#11) Alias change
  contain mailplatform::configure::aliases
  Class[mailplatform::configure::hostnamechange]
  -> Class[mailplatform::configure::php]
  -> Class[mailplatform::configure::roundcube]
  -> Class[mailplatform::configure::mysql]
  -> Class[mailplatform::configure::systems]
  -> Class[mailplatform::configure::postfix]
  -> Class[mailplatform::configure::dovecot]
  -> Class[mailplatform::configure::pdns_recursor]
  -> Class[mailplatform::configure::pdns]
  -> Class[mailplatform::configure::permissions]
  -> Class[mailplatform::configure::aliases]
}
