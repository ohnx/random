noJSON
============

simple nodejs server that extracts the value of a key from a piece of JSON.
It *should* never crash.

Also, it has 3 dependencies that are pretty common. They are:
 - http
 - url
 - cluster

If you don't have the first two, I don't know how you plan on running nodejs servers.

Usage:

`GET /?url=<url here>&key=<JSON key>`

ie, `GET /?url=http://ipinfo.io&key=city`.

Created because I didn't feel like adding JSON parsing to [athena](https://github.com/ohnx/athena).
Also, I wanted to learn nodejs.
