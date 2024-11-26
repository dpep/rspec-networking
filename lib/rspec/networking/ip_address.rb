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
    @actual = actual

    return false unless actual.is_a?(String) || actual.is_a?(IPAddr)

    addr = actual.is_a?(IPAddr) ? actual : IPAddr.new(actual)

    if @version
      return false unless @version == 4 ? addr.ipv4? : addr.ipv6?
    end

    if @localhost
      return false unless addr.loopback?
    end

    true
  rescue IPAddr::InvalidAddressError
    false
  end

  description do
    if @version
      addr = @localhost ? "localhost " : "address"
      "an IPv#{@version} #{addr}"
    else
      @localhost ? "a localhost" : "an IP address"
    end
  end

  failure_message do
    "expected '#{@actual}' to be #{description}"
  end

  failure_message_when_negated do
    "expected '#{@actual}' not to be #{description}"
  end
end

RSpec::Matchers.alias_matcher :an_ip_address, :be_an_ip_address
