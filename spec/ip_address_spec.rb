describe "be_an_ip_address" do
  subject { "127.0.0.1" }

  it { is_expected.to be_an_ip_address }
  it { is_expected.to be_an_ip_address.v4 }

  context "with generated addresses" do
    specify do
      100.times { expect(Faker::Internet.ip_v4_address).to be_an_ip_address }
    end
  end

  context "with invalid address" do
    specify { expect("999.0.0.0").not_to be_an_ip_address }
    specify { expect("abc").not_to be_an_ip_address }

    it "fails with a useful message" do
      expect {
        expect(nil).to be_an_ip_address
      }.to fail_including("to be an IP address")
    end

    it "fails with a useful negation message" do
      expect {
        is_expected.not_to be_an_ip_address
      }.to fail_including("not to be an IP address")
    end
  end

  describe "#localhost" do
    describe "v4 localhost" do
      let(:ip) { "127.0.0.1" }
      it { expect(ip).to be_an_ip_address }
      it { expect(ip).to be_an_ip_address.v4 }
      it { expect(ip).not_to be_an_ip_address.v6 }
      it { expect(ip).to be_an_ip_address.localhost }
      it { expect(ip).to be_an_ip_address.localhost.v4 }
      it { expect(ip).not_to be_an_ip_address.localhost.v6 }
    end

    describe "v6 localhost" do
      describe "short form" do
        let(:ip) { "::1" }
        it { expect(ip).to be_an_ip_address }
        it { expect(ip).to be_an_ip_address.v6 }
        it { expect(ip).not_to be_an_ip_address.v4 }
        it { expect(ip).to be_an_ip_address.localhost }
        it { expect(ip).to be_an_ip_address.localhost.v6 }
        it { expect(ip).not_to be_an_ip_address.localhost.v4 }
      end

      describe "long form" do
        let(:ip) { "0:0:0:0:0:0:0:1" }
        it { expect(ip).to be_an_ip_address }
        it { expect(ip).to be_an_ip_address.v6 }
        it { expect(ip).not_to be_an_ip_address.v4 }
        it { expect(ip).to be_an_ip_address.localhost }
        it { expect(ip).to be_an_ip_address.localhost.v6 }
        it { expect(ip).not_to be_an_ip_address.localhost.v4 }
      end
    end

    let(:ip) { "1.1.1.1" }

    it { is_expected.to be_an_ip_address.localhost }

    it { expect(ip).to be_an_ip_address }
    it { expect(ip).not_to be_an_ip_address.localhost }

    it "fails with a useful message" do
      expect {
        expect(ip).to be_an_ip_address.localhost
      }.to fail_including("to be a localhost")

      expect {
        expect(ip).to be_an_ip_address.v6.localhost
      }.to fail_including("to be an IPv6 localhost")
    end

    it "fails with a useful negation message" do
      expect {
        is_expected.not_to be_an_ip_address.localhost
      }.to fail_including("not to be a localhost")

      expect {
        is_expected.not_to be_an_ip_address.v4.localhost
      }.to fail_including("not to be an IPv4 localhost")
    end
  end

  context "with ipv6 addresses" do
    subject { Faker::Internet.ip_v6_address }

    it { is_expected.to be_an_ip_address.v6 }
  end

  it "is composable" do
    data = {
      abc: { a: 1 },
      addr: Faker::Internet.ip_v4_address,
    }

    expect(data).to include(addr: an_ip_address)

    expect(data).to match(
      abc: a_hash_including(:a),
      addr: an_ip_address.v4,
    )
  end

  context "with an IPAddr object" do
    subject { IPAddr.new(Faker::Internet.ip_v4_address) }

    it { is_expected.to be_an_ip_address }
  end
end
