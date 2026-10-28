require "ipaddr"

RSpec::Matchers.define :be_an_ip_address do
  chain :v4 do
    @version = 4
  end

  chain :v6 do
    @version = 6
  end

  chain :localhost do
    @localhost = true
  end

  match do |actual|
    return false unless actual.is_a?(String) || actual.is_a?(IPAddr)

    addr = actual.is_a?(IPAddr) ? actual : IPAddr.new(actual)

    # IPAddr also parses CIDR ranges, eg. "10.0.0.0/8"
    return false unless addr.prefix == (addr.ipv4? ? 32 : 128)

    return false if @version == 4 && !addr.ipv4?
    return false if @version == 6 && !addr.ipv6?
    return false if @localhost && !addr.loopback?

    true
  rescue IPAddr::Error
    false
  end

  description do
    if @version
      "be an IPv#{@version} #{"localhost " if @localhost}address"
    else
      @localhost ? "be a localhost address" : "be an IP address"
    end
  end
end

RSpec::Matchers.alias_matcher(:an_ip_address, :be_an_ip_address) { _1.delete_prefix("be ") }
