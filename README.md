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

expect(obj).to be_an_ip_address

# check version
expect(obj).to be_an_ip_address.v4

# check for localhost
expect(obj).to be_an_ip_address.localhost

# compose with other matchers
expect(data).to include(addr: an_ip_address)



###  match a MAC address  ###
expect(obj).to be_a_mac_address

expect(obj).to be_a_mac_address.broadcast
expect(obj).to be_a_mac_address.multicast
expect(obj).to be_a_mac_address.unicast

# check manufacturer or specific device
expect(obj).to be_a_mac_address.from("xerox")
expect(obj).to be_a_mac_address.for(device)

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
