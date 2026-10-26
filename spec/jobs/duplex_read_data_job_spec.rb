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

  context "with influxDB" do
    let(:home) { create(:my_home, influxdb_options: { url: "http://influx.invalid", token: "synthetic-token" }) }
    let(:client) { instance_double(InfluxDB2::Client) }
    let(:writer) { instance_double(InfluxDB2::WriteApi) }
    let(:data) { { current_mode: "off", current_power: 0, outdoor_temperature: 5, input_temperature: temperature } }

    before do
      allow(home).to receive(:duplex).and_return(instance_double(AtreaDuplex, data: data))
      allow(InfluxDB2::Client).to receive(:new).and_return(client)
      allow(client).to receive(:create_write_api).and_return(writer)
    end

    [nil, 0, 11.1].each do |temperature|
      context "with input temperature #{temperature.inspect}" do
        let(:temperature) { temperature }

        it "writes valid fields and broadcasts original data" do
          line = "atrea,current_mode=off power=0,outdoor_temperature=5"
          line += ",input_temperature=#{temperature}" unless temperature.nil?
          expect(DuplexChannel).to receive(:broadcast_to).with(home.user, data)
          expect(writer).to receive(:write).with(data: line)
          job.perform(home)
        end
      end
    end
  end
end
