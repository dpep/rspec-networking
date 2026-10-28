describe "RSpec::Networking::MANUFACTURERS" do
  subject(:manufacturers) { RSpec::Networking::MANUFACTURERS }

  it "contains only well-formed OUIs" do
    expect(manufacturers.values.flat_map(&:to_a)).to all(match(/\A[0-9A-F]{6}\z/))
  end

  it "keeps leading zeros" do
    expect(manufacturers["microsoft"]).to include("002248")
    expect(manufacturers["xerox"]).to include("000000")
  end

  it { expect("00:12:4B:00:00:00").to be_a_mac_address.from("texas instruments") }
end
