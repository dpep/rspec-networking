RSpec::Networking
======
![Gem](https://img.shields.io/gem/dt/rspec-networking?style=plastic)
[![codecov](https://codecov.io/gh/dpep/rspec-networking/branch/main/graph/badge.svg)](https://codecov.io/gh/dpep/rspec-networking)

RSpec matchers for IP and MAC Addresses


### Install
```bash
gem install rspec-networking
```


### Usage

```ruby
require "rspec/networking"


###  match an IP address  ###
expect(obj).to be_an_ip_address

# check version
expect(obj).to be_an_ip_address.v4
expect(obj).to be_an_ip_address.v6

# check for localhost
expect(obj).to be_an_ip_address.localhost

# check for private (10/8, 172.16/12, 192.168/16, fc00::/7)
expect(obj).to be_an_ip_address.private

# check for public: globally reachable unicast, ie. outside every IANA
# special-purpose range (localhost, link-local, CGNAT, documentation, ...)
expect(obj).to be_an_ip_address.public

# negated matchers pass for anything that isn't an IP address, including nil
expect(obj).not_to be_an_ip_address.public  # passes for nil
expect(obj).to be_an_ip_address.private     # prefer the positive form

# compose with other matchers
expect(data).to include(addr: an_ip_address)



###  match a MAC address  ###
# 00:11:22:33:44:55, 00-11-22-33-44-55, 0011.2233.4455, or EUI-64
# leading zeros are optional, eg. 0:11:22:3:44:55 as macOS arp prints
expect(obj).to be_a_mac_address

expect(obj).to be_a_mac_address.bits(48)

expect(obj).to be_a_mac_address.broadcast
expect(obj).to be_a_mac_address.multicast
expect(obj).to be_a_mac_address.unicast

# check manufacturer, by name or OUI (raises on an unknown name)
expect("00:00:00:12:34:56").to be_a_mac_address.from("xerox")
expect("00:00:00:12:34:56").to be_a_mac_address.from("00:00:00")

# check device, by its last three octets
expect("00:00:00:12:34:56").to be_a_mac_address.for("12:34:56")

# compose with other matchers
expect(data).to include(addr: a_mac_address)
```


### Resources
- https://en.wikipedia.org/wiki/IP_address
- https://en.wikipedia.org/wiki/MAC_address
- https://www.lifewire.com/introduction-to-mac-addresses-817937


----
## Contributing

Yes please  :)

1. Fork it
1. Create your feature branch (`git checkout -b my-feature`)
1. Ensure the tests pass (`bundle exec rspec`)
1. Commit your changes (`git commit -am 'awesome new feature'`)
1. Push your branch (`git push origin my-feature`)
1. Create a Pull Request

Manufacturer OUIs come from the [IEEE registry](https://standards-oui.ieee.org/); refresh them with `script/update_manufacturers`.
