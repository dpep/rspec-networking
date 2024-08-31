require 'set'

module RSpec
  module Networking
    MANUFACTURERS = {
      "xerox" => Set.new(['00:00:00'.delete(':')]),
    }

    # load manufacturers
    Dir.glob("#{__dir__}/mac_address/*.txt").each do |file|
      manufacturer = File.basename(file, '.txt').downcase

      File.readlines(file).map(&:chomp).each do |entry|
        MANUFACTURERS[manufacturer] ||= Set.new
        MANUFACTURERS[manufacturer] << entry.upcase
      end
    end
  end
end
