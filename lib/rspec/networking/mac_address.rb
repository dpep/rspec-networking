require "rspec/networking/mac_address_manufacturers"

module RSpec
  module Networking
    module MacAddress
      # MM:MM:MM:SS:SS:SS, MM-MM-MM-SS-SS-SS, MMMM.MMSS.SSSS
      EUI48 = /\A\h{2}([:-])(\h{2}\1){4}\h{2}\z|\A\h{4}(\.\h{4}){2}\z/

      # MM:MM:MM:FF:FE:SS:SS:SS, MMMM:MMFF:FESS:SSSS
      EUI64 = /\A\h{2}([:-])(\h{2}\1){6}\h{2}\z|\A\h{4}(:\h{4}){3}\z/

      # half an EUI-48: MM:MM:MM or SS-SS-SS
      HALF = /\A\h{2}([:-])\h{2}\1\h{2}\z/

      def self.normalize(str)
        str.delete(".:-").upcase
      end
    end
  end
end

RSpec::Matchers.define :be_a_mac_address do
  mac = RSpec::Networking::MacAddress

  chain :from do |manufacturer|
    @manufacturer = manufacturer

    @prefixes = if mac::HALF.match?(manufacturer.to_s)
      Set[mac.normalize(manufacturer)]
    else
      RSpec::Networking::MANUFACTURERS.fetch(manufacturer.to_s.downcase.tr(" ", "_")) do
        raise ArgumentError, "unknown manufacturer: #{manufacturer}"
      end
    end
  end

  chain :for do |device|
    raise ArgumentError, "invalid device: #{device}" unless mac::HALF.match?(device.to_s)

    @device = device
    @suffix = mac.normalize(device)
  end

  chain :bits do |bits|
    raise ArgumentError, "invalid bit length: #{bits}" unless [48, 64].include?(bits)

    @bits = bits
  end

  chain :broadcast do
    @broadcast = true
  end

  chain :unicast do
    @cast = :unicast
  end

  chain :multicast do
    @cast = :multicast
  end

  match do |actual|
    return false unless actual.is_a?(String)

    if mac::EUI64.match?(actual)
      return false if @bits == 48

      hex = mac.normalize(actual)
      return false unless hex[6, 4] == "FFFE"

      # normalize to 48 bits
      hex = hex[0, 6] + hex[10, 6]
    elsif mac::EUI48.match?(actual)
      return false if @bits == 64

      hex = mac.normalize(actual)
    else
      return false
    end

    return false if @broadcast && hex != "FF" * 6

    # the I/G bit: least significant bit of the first octet
    return false if @cast && hex[0, 2].to_i(16).odd? != (@cast == :multicast)

    return false if @prefixes && !@prefixes.include?(hex[0, 6])
    return false if @suffix && @suffix != hex[6, 6]

    true
  end

  description do
    [
      "be a",
      ("broadcast" if @broadcast),
      @cast,
      "MAC address",
      ("with #{@bits} bits" if @bits),
      ("from #{@manufacturer}" if @manufacturer),
      ("for #{@device}" if @device),
    ].compact.join(" ")
  end
end

RSpec::Matchers.alias_matcher(:a_mac_address, :be_a_mac_address) { _1.delete_prefix("be ") }
