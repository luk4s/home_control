RSpec.describe ReadDuplexJob do
  subject(:job) { described_class.new }
  context "without influxDB" do
    let(:home) { create :my_home }
    it "just read data" do
      expect(home).to receive(:duplex).and_return double(data: {})
      expect(DuplexChannel).to receive(:broadcast_to)
      expect(InfluxDB2::Client).not_to receive(:new)
      described_class.perform_now(home)
    end
  end
end
