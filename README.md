maphosts
========
[![Gem Version](https://badge.fury.io/rb/maphosts.png)](http://rubygems.org/gems/maphosts)
[![Circle CI](https://circleci.com/gh/mpscholten/maphosts.svg?style=shield)](https://circleci.com/gh/mpscholten/maphosts)

Small command line application for keeping your project hostnames in sync with `/etc/hosts`.

Use it within your startup script (`make up`, shell scripts, etc.) to provide a `vagrant up`-like experience
so people can start coding without spending time setting up and updating `/etc/hosts` by hand.

### Get started ###

    gem install maphosts

### Usage ###

    maphosts {www.,static.,}example.lo
    
    
This will add www.example.lo, static.example.lo and example.lo to your `/etc/hosts`. The tool will only update parts of your `/etc/hosts` which requires the update to preserve the original formatting. When required and with your permission the tool uses sudo to write to `/etc/hosts`.

By default the hosts will point to `127.0.0.1` but you can provide a custom ip address with the `--to` option.

**boot2docker**

    maphosts {www.,static.,}example.lo --to $(boot2docker ip)

This will do the same as above but will point these hosts to your boot2docker vm. In case you use multiple docker containers, you can use maphosts to keep your `/etc/hosts` file in sync with all the containers. You could add maphosts to your docker startup script so it syncs the hosts everytime you start the containers.

```make
# Example of a docker startup script with maphosts
# Developers just run `make up` and can start hacking 
up:
    maphosts {www.,static.,}example.lo --to $(boot2docker ip)
    docker start example-www
    docker start example-static
```

### Tests ###

You can run the `rspec` suite with rake
    
    rake spec
    
### Contributing ###

Feel free to send pull requests!
