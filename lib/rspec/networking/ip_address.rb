require "ipaddr"

module RSpec
  module Networking
    # IANA special-purpose ranges that are not globally reachable, plus multicast
    # https://www.iana.org/assignments/iana-ipv4-special-registry
    # https://www.iana.org/assignments/iana-ipv6-special-registry
    NON_PUBLIC_IP_RANGES = %w[
      0.0.0.0/8 10.0.0.0/8 100.64.0.0/10 127.0.0.0/8 169.254.0.0/16 172.16.0.0/12
      192.0.0.0/24 192.0.2.0/24 192.168.0.0/16 198.18.0.0/15 198.51.100.0/24
      203.0.113.0/24 224.0.0.0/4 240.0.0.0/4
      ::/96 ::ffff:0:0/96 64:ff9b::/96 64:ff9b:1::/48 100::/64 2001::/23
      2001:db8::/32 2002::/16 fc00::/7 fe80::/10 fec0::/10 ff00::/8
    ].map { |range| IPAddr.new(range) }.freeze
  end
end

RSpec::Matchers.define :be_an_ip_address do
  chain :v4 do
    @version = 4
  end

  chain :v6 do
    @version = 6
  end

  chain :localhost do
    scope!(:localhost)
  end

  chain :private do
    scope!(:private)
  end

  chain :public do
    scope!(:public)
  end

  def scope!(scope)
    raise ArgumentError, "can't combine .#{@scope} and .#{scope}" if @scope

    @scope = scope
  end

  match do |actual|
    return false unless actual.is_a?(String) || actual.is_a?(IPAddr)

    # IPAddr also parses CIDR ranges and brackets, eg. "10.0.0.0/8", "[::1]"
    return false if actual.is_a?(String) && actual.match?(%r{[/\[\]]})

    addr = actual.is_a?(IPAddr) ? actual : IPAddr.new(actual)

    # an IPAddr may be a network, eg. IPAddr.new("10.0.0.0/8")
    return false unless addr.prefix == (addr.ipv4? ? 32 : 128)

    return false if @version == 4 && !addr.ipv4?
    return false if @version == 6 && !addr.ipv6?

    case @scope
    when :localhost then addr.loopback?
    when :private then addr.private?
    # native unwraps IPv4-mapped/compatible IPv6, eg. ::ffff:127.0.0.1
    when :public then RSpec::Networking::NON_PUBLIC_IP_RANGES.none? { |range| range.include?(addr.native) }
    else true
    end
  rescue IPAddr::Error
    false
  end

  description do
    version = @version ? "IPv#{@version}" : "IP"

    case @scope
    when :localhost
      @version ? "be an #{version} localhost address" : "be a localhost address"
    when nil
      "be an #{version} address"
    else
      "be a #{@scope} #{version} address"
    end
  end
end

RSpec::Matchers.alias_matcher(:an_ip_address, :be_an_ip_address) { |desc| desc.delete_prefix("be ") }
