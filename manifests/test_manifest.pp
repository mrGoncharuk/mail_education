exec { "change mod to user's mailhome folders":
    command => "/usr/bin/chmod 0600 /var/mail/*"
 }