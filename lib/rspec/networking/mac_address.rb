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

    matches
  end

  description do
    @manufacturer ? "a MAC address from #{@manufacturer_str}" : "a MAC address"
  end

  failure_message do
    "expected '#{@actual}' to be #{description}"
  end

  failure_message_when_negated do
    "expected '#{@actual}' not to be #{description}"
  end
end

RSpec::Matchers.alias_matcher :a_mac_address, :be_a_mac_address
