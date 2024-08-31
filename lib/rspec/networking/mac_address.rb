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

  match do |actual|
    @actual = actual

    return false unless actual.is_a?(String)

    # MM:MM:MM:SS:SS:SS
    # MM-MM-MM-SS-SS-SS
    hex = ['\h{2}'] * 5
    matches = actual.match?(/^\h{2}([:-])#{hex.join('\1')}$/)

    # MMM.MMM.SSS.SSS
    hex = ['\h{3}'] * 4
    matches ||= actual.match?(/^#{hex.join('.')}$/)

    if @manufacturer
      hex = actual.delete('.:-').slice(0, 6).upcase

      matches &&= if @manufacturer_str.match?(/[.:-]/)
        # exact match
        hex == @manufacturer
      else
        # manufacturer lookup
        RSpec::Networking::MANUFACTURERS[@manufacturer].include?(hex)
      end
    end

    if @device
      hex = actual.delete('.:-').slice(-6, 6).upcase
      matches &&= hex == @device.delete('.:-').upcase
    end

    matches
  end

  description do
    from_s = @manufacturer ? " from #{@manufacturer_str}" : ""
    for_s = @device ? " for #{@device}" : ""

    "a MAC address#{from_s}#{for_s}"
  end

  failure_message do
    "expected '#{@actual}' to be #{description}"
  end

  failure_message_when_negated do
    "expected '#{@actual}' not to be #{description}"
  end
end

RSpec::Matchers.alias_matcher :a_mac_address, :be_a_mac_address
