# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include mailplatform::configure::dovecot
class mailplatform::configure::dovecot {
  file_line {'Setting up mbox path':
    path  => '/etc/dovecot/conf.d/10-mail.conf',
    line  => 'mail_location = mbox:~/mail:INBOX=/var/mail/%u',
    match => '#   mail_location = mbox:~/mail:INBOX=/var/mail/%u',
  }
}
