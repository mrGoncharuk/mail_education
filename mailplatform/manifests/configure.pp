# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include mailplatform::configure
class mailplatform::configure {
#1) hostname
  include mailplatform::configure::hostnamechange
#2) php file creation
  include mailplatform::configure::php
#3) roundcube file creating and roundcube folder permissions 
  include mailplatform::configure::roundcube
#4) mysql configuring
  include mailplatform::configure::mysql
#5) (was here: roundcube folder permissions) 
  include mailplatform::configure::systems
#6) Postfix  
  include mailplatform::configure::postfix
#7) Dovecot  
  include mailplatform::configure::dovecot
#8) pdns-recursor config
  include mailplatform::configure::pdns_recursor
#9) pdns config
  include mailplatform::configure::pdns
#10) mailhome permissions
  include mailplatform::configure::permissions
#11) Alias change
  include mailplatform::configure::aliases
  Class[mailplatform::users]
  -> Class[mailplatform::configure::hostnamechange]
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
