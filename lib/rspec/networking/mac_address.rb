# https://en.wikipedia.org/wiki/MAC_address

RSpec::Matchers.define :be_a_mac_address do
  match do |actual|
    @actual = actual

    return false unless actual.is_a?(String)

    # MM:MM:MM:SS:SS:SS
    hex = ['\h{2}'] * 5
    matches = actual.match?(/^\h{2}([:-])#{hex.join('\1')}$/)

    # MMM.MMM.SSS.SSS
    hex = ['\h{3}'] * 4
    matches ||= actual.match?(/^#{hex.join('.')}$/)

    matches
  end

  description do
    "a MAC address"
  end

  failure_message do
    "expected '#{@actual}' to be #{description}"
  end

  failure_message_when_negated do
    "expected '#{@actual}' not to be #{description}"
  end
end

RSpec::Matchers.alias_matcher :a_mac_address, :be_a_mac_address
