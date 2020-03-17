$hstname = "allinone-mh.localhost"

exec { "change hostname":
    command  => "/usr/bin/hostnamectl set-hostname $hstname",
}
