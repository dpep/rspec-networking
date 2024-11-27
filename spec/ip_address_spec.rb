describe "be_an_ip_address" do
  describe ".v4" do
    subject { Faker::Internet.ip_v4_address }

    it { is_expected.to be_an_ip_address }
    it { is_expected.to be_an_ip_address.v4 }
  end

  describe ".v6" do
    subject { Faker::Internet.ip_v6_address }

    it { is_expected.to be_an_ip_address }
    it { is_expected.to be_an_ip_address.v6 }
  end

  it "is composable" do
    data = {
      abc: { a: 1 },
      addr: Faker::Internet.ip_v4_address,
    }

    expect(data).to include(addr: an_ip_address.v4)
  end

  describe ".localhost" do
    describe "IPv4 localhost" do
      subject { "127.0.0.1" }

      it { is_expected.to be_an_ip_address }
      it { is_expected.to be_an_ip_address.v4 }
      it { is_expected.not_to be_an_ip_address.v6 }
      it { is_expected.to be_an_ip_address.localhost }
      it { is_expected.to be_an_ip_address.localhost.v4 }
      it { is_expected.not_to be_an_ip_address.localhost.v6 }

      it "fails with a useful negation message" do
        expect {
          is_expected.not_to be_an_ip_address.localhost
        }.to fail_including("not to be a localhost")

        expect {
          is_expected.not_to be_an_ip_address.v4.localhost
        }.to fail_including("not to be an IPv4 localhost")
      end
    end

    describe "IPv6 localhost" do
      describe "short form" do
        subject { "::1" }

        it { is_expected.to be_an_ip_address }
        it { is_expected.to be_an_ip_address.v6 }
        it { is_expected.not_to be_an_ip_address.v4 }
        it { is_expected.to be_an_ip_address.localhost }
        it { is_expected.to be_an_ip_address.localhost.v6 }
        it { is_expected.not_to be_an_ip_address.localhost.v4 }
      end

      describe "long form" do
        subject { "0:0:0:0:0:0:0:1" }

        it { is_expected.to be_an_ip_address }
        it { is_expected.to be_an_ip_address.v6 }
        it { is_expected.not_to be_an_ip_address.v4 }
        it { is_expected.to be_an_ip_address.localhost }
        it { is_expected.to be_an_ip_address.localhost.v6 }
        it { is_expected.not_to be_an_ip_address.localhost.v4 }
      end
    end

    context "with a non-localhost address" do
      subject { "1.1.1.1" }

      it { is_expected.to be_an_ip_address }
      it { is_expected.not_to be_an_ip_address.localhost }
    end
  end

  context "with an IPAddr object" do
    subject { IPAddr.new(Faker::Internet.ip_v4_address) }

    it { is_expected.to be_an_ip_address }
    it { is_expected.to be_an_ip_address.v4 }
  end

  context "with invalid address" do
    it { expect("999.0.0.0").not_to be_an_ip_address }
    it { expect("abc").not_to be_an_ip_address }
    it { expect("").not_to be_an_ip_address }
    it { expect(nil).not_to be_an_ip_address }
  end

  describe "failure messages" do
    it "fails with a useful message" do
      expect {
        expect(nil).to be_an_ip_address
      }.to fail_including("to be an IP address")

      expect {
        expect(nil).to be_an_ip_address.localhost
      }.to fail_including("to be a localhost")

      expect {
        expect(nil).to be_an_ip_address.v4
      }.to fail_including("to be an IPv4 address")

      expect {
        expect(nil).to be_an_ip_address.v4.localhost
      }.to fail_including("to be an IPv4 localhost")

      expect {
        expect(nil).to be_an_ip_address.v6
      }.to fail_including("to be an IPv6 address")

      expect {
        expect(nil).to be_an_ip_address.v6.localhost
      }.to fail_including("to be an IPv6 localhost")
    end
  end
end
