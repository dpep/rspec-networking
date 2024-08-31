describe "be_a_mac_address" do
  context "with a valid address" do
    subject { "01-23-45-67-89-AB" }

    it { is_expected.to be_a_mac_address }
  end

  context "with nil address" do
    subject { "00-00-00-00-00-00" }

    it { is_expected.to be_a_mac_address }
  end

  context "with generated addresses" do
    specify do
      100.times { expect(Faker::Internet.mac_address).to be_a_mac_address }
    end
  end

  context "when separated by colons" do
    subject { "00:00:00:00:00:00" }

    it { is_expected.to be_a_mac_address }

    specify do
      addr = Faker::Internet.mac_address.gsub("-", ":")
      100.times { expect(addr).to be_a_mac_address }
    end
  end

  context "when separated by periods" do
    subject { "000.000.000.000" }

    it { is_expected.to be_a_mac_address }
  end

  context "with invalid address" do
    specify { expect("abc").not_to be_a_mac_address }
    specify { expect(:xyz).not_to be_a_mac_address }
    specify { expect(123).not_to be_a_mac_address }
    specify { expect(nil).not_to be_a_mac_address }

    it "requires the same separator" do
      expect("00:00-00-00-00-00").not_to be_a_mac_address
      expect("00:00:00-00-00-00").not_to be_a_mac_address
    end

    it "fails with a useful message" do
      expect {
        expect(nil).to be_a_mac_address
      }.to fail_including("to be a MAC address")
    end

    it "fails with a useful negation message" do
      expect {
        expect(Faker::Internet.mac_address).not_to be_a_mac_address
      }.to fail_including("not to be a MAC address")
    end
  end

  it "is composable" do
    data = {
      abc: { a: 1 },
      mac: Faker::Internet.mac_address,
    }

    expect(data).to include(mac: a_mac_address)

    expect(data).to match(
      abc: a_hash_including(:a),
      mac: a_mac_address,
    )
  end

  describe "#from" do
    subject { "00:00:00:11:11:11" }

    it { is_expected.to be_a_mac_address.from("00:00:00") }
    it { is_expected.to be_a_mac_address.from("00-00-00") }
    it { is_expected.to be_a_mac_address.from("000.000") }

    it { is_expected.to be_a_mac_address.from("xerox") }

    it "catches mismatches" do
      expect {
        is_expected.to be_a_mac_address.from("apple")
      }.to fail

      expect {
        is_expected.to be_a_mac_address.from("FF:FF:FF")
      }.to fail_including("from FF:FF:FF")
    end

    context "with an unknown manufacturer" do
      it "raises an error" do
        expect {
          is_expected.to be_a_mac_address.from("foo")
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#for" do
    subject { "00:00:00:11:11:11" }

    it { is_expected.to be_a_mac_address.for("11:11:11") }
    it { is_expected.to be_a_mac_address.for("11-11-11") }
    it { is_expected.to be_a_mac_address.for("111.111") }

    it "catches mismatches" do
      expect {
        is_expected.to be_a_mac_address.for("FF:FF:FF")
      }.to fail_including("for FF:FF:FF")
    end
  end
end
