describe "be_a_mac_address" do
  subject { "00:00:00:11:11:11" }

  context "with a valid address" do
    it { is_expected.to be_a_mac_address }
  end

  context "with generated addresses" do
    specify do
      100.times { expect(Faker::Internet.mac_address).to be_a_mac_address }
    end
  end

  context "when separated by dashes" do
    subject { "00-00-00-00-00-00" }

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
      addr: Faker::Internet.mac_address,
    }

    expect(data).to include(addr: a_mac_address)

    expect(data).to match(
      abc: a_hash_including(:a),
      addr: a_mac_address,
    )
  end

  describe "#from" do
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
    it { is_expected.to be_a_mac_address.for("11:11:11") }
    it { is_expected.to be_a_mac_address.for("11-11-11") }
    it { is_expected.to be_a_mac_address.for("111.111") }

    it "catches mismatches" do
      expect {
        is_expected.to be_a_mac_address.for("FF:FF:FF")
      }.to fail_including("for FF:FF:FF")
    end

    it "catches invalid devices" do
      expect {
        is_expected.to be_a_mac_address.for("FF:FF")
      }.to raise_error(ArgumentError)
    end
  end

  describe "#bits" do
    it { is_expected.to be_a_mac_address.bits(48) }
    it { is_expected.not_to be_a_mac_address.bits(64) }

    it "catches mismatches" do
      expect {
        is_expected.to be_a_mac_address.bits(64)
      }.to fail_including("64 bits")
    end

    it "catches invalid bit lengths" do
      expect {
        is_expected.to be_a_mac_address.bits(11)
      }.to raise_error(ArgumentError)
    end

    describe "#broadcast" do
      it { is_expected.not_to be_a_mac_address.broadcast }

      it { expect("FF:FF:FF:FF:FF:FF").to be_a_mac_address.broadcast }
    end
  end

  describe "#unicast and #multicast" do
    it { expect("00:00:00:00:00:00").to be_a_mac_address.unicast }
    it { expect("0E:00:00:00:00:00").to be_a_mac_address.unicast }

    it { expect("01:00:00:00:00:00").to be_a_mac_address.multicast }
    it { expect("0F:00:00:00:00:00").to be_a_mac_address.multicast }

    it { expect("00:00:00:00:00:00").not_to be_a_mac_address.multicast }
    it { expect("01:00:00:00:00:00").not_to be_a_mac_address.unicast }
  end

  context "with 64 bits" do
    subject { "00:00:00:FF:FE:11:11:11" }

    it { is_expected.to be_a_mac_address }
    it { is_expected.to be_a_mac_address.from("00:00:00") }
    it { is_expected.to be_a_mac_address.from("Xerox") }
    it { is_expected.to be_a_mac_address.for("11:11:11") }
    it { is_expected.to be_a_mac_address.unicast }

    describe "#bits" do
      it { is_expected.to be_a_mac_address.bits(64) }
      it { is_expected.not_to be_a_mac_address.bits(48) }

      it "catches mismatches" do
        expect {
          is_expected.to be_a_mac_address.bits(48)
        }.to fail_including("48 bits")
      end
    end

    describe "#broadcast" do
      subject { "FF:FF:FF:FF:FE:FF:FF:FF" }

      it { is_expected.to be_a_mac_address.bits(64).broadcast }
    end
  end
end
