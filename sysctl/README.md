sysctl
===================
An easy way to control a system from ruby.

It connects to a specified IRC server (configurable). Afterwards, you can either run a command using `-exec` (ie, `-exec yes | apt-get upgrade`) or by explicitly mentioning its name (ie, `VPS: yes | apt-get upgrade`)

It also starts a listening port where you can interact with IRC people. Generally, it's assumed that this port is only open to trusted people (by using AWS security groups, firewalls, etc...)

I only did this to have more red.
