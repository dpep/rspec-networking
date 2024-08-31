require 'rspec/networking/mac_address_manufacturers'

RSpec::Matchers.define :be_a_mac_address do
  chain :from do |manufacturer|
    @manufacturer_str = manufacturer

    if manufacturer.match?(/^\h{2}([:-])\h{2}\1\h{2}$/) || manufacturer.match?(/^\h{3}\.\h{3}$/)
      # exact match
      @manufacturer = manufacturer.delete('.:-').upcase
    else
      # manufacturer lookup
      @manufacturer = manufacturer.to_s.downcase

      unless RSpec::Networking::MANUFACTURERS.key?(@manufacturer)
        raise ArgumentError, "unknown manufacturer: #{manufacturer}"
      end
    end
  end

  chain :for do |device|
    unless device.match?(/^\h{2}([:-])\h{2}\1\h{2}$/) || device.match?(/^\h{3}\.\h{3}$/)
      raise ArgumentError, "invalid device: #{device}"
    end

    @device = device
  end

  chain :bits do |bits|
    unless [ 48, 64 ].include?(bits)
      raise ArgumentError, "invalid bit length: #{bits}"
    end

    @bits = bits
  end

  chain :broadcast do
    @broadcast = true
  end

  match do |actual|
    @actual = actual

    return false unless actual.is_a?(String)

    hex = nil

    if actual.match?(/^\h{2}(:\h{2}){7}$/) || actual.match?(/^\h{4}(:\h{4}){3}$/)
      # 64 bits
      # 00:00:00:FF:FE:00:00:00
      # 0000:00FF:FE00:0000

      hex = actual.delete(':').upcase
      return false unless hex.slice(6, 4) == 'FFFE'
      return false if @bits == 48

      # normalize to 48 bits
      hex.slice!(6, 4)
    elsif actual.match?(/^\h{2}([:-])(\h{2}\1){4}\h{2}$/) || actual.match?(/^\h{3}(\.\h{3}){3}$/)
      # 48 bits
      # MM:MM:MM:SS:SS:SS
      # MM-MM-MM-SS-SS-SS
      # MMM.MMM.SSS.SSS

      return false if @bits == 64

      hex = actual.delete('.:-').upcase
    else
      return false
    end

    if @broadcast
      return false unless hex == 'FF' * 6
    end

    matches = true

    if @manufacturer
      prefix = hex.slice(0, 6)

      matches &&= if @manufacturer_str.match?(/[.:-]/)
        # exact match
        prefix == @manufacturer
      else
        # manufacturer lookup
        RSpec::Networking::MANUFACTURERS[@manufacturer].include?(prefix)
      end
    end

    if @device
      suffix = hex.slice(-6, 6)
      matches &&= suffix == @device.delete('.:-').upcase
    end

    matches
  end

  description do
    from_s = @manufacturer ? " from #{@manufacturer_str}" : ""
    for_s = @device ? " for #{@device}" : ""
    bits_s = @bits ? " with #{@bits} bits" : ""
    broadcast_s = @broadcast ? " broadcast" : ""

    "a MAC address#{bits_s}#{from_s}#{for_s}#{broadcast_s}"
  end

  failure_message do
    "expected '#{@actual}' to be #{description}"
  end

  failure_message_when_negated do
    "expected '#{@actual}' not to be #{description}"
  end
end

RSpec::Matchers.alias_matcher :a_mac_address, :be_a_mac_address
