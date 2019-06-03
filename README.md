# Onityper

Onion Omega2 + USB keyboard = dumb typewriter

To [run this on boot](https://docs.onion.io/omega2-docs/running-a-command-on-boot.html), add

```
ruby /root/onityper.rb >> /tmp/onityper.log 2>&1 &
```

to `/etc/rc.local`.

Requirements:

* Ruby
* Make sure `/root/notes` folder exists
