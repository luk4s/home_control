RSpec.describe DuplexReadDataJob do
  subject(:job) { described_class.new }

  context "without influxDB" do
    let(:home) { create :my_home }

    it "just read data" do
      allow(home).to receive(:duplex).and_return instance_double(AtreaDuplex, data: {})
      expect(DuplexChannel).to receive(:broadcast_to)
      expect(InfluxDB2::Client).not_to receive(:new)
      job.perform(home)
    end
  end
end
