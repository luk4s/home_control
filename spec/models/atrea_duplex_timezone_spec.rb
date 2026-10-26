require "faraday"

RSpec.describe AtreaDuplex do
  let(:home) { create(:my_home, duplex_auth_token: "existing-token", duplex_user_ctrl: metadata) }
  let(:metadata) do
    {
      input_temperature_source: "unsupported",
      sensors: { current_mode_switch: "H10701", current_mode: "H10709" },
      modes: { "1" => "auto" },
    }
  end

  around do |example|
    previous_timezone = ENV.fetch("TZ", nil)
    ENV["TZ"] = "UTC"
    example.run
  ensure
    ENV["TZ"] = previous_timezone
  end

  before do
    allow(ENV).to receive(:fetch).and_call_original
    allow(ENV).to receive(:fetch).with("ATREA_TIME_ZONE", "Europe/Prague").and_return("Europe/Prague")
  end

  { "winter" => [10, 26, 19], "summer" => [7, 26, 20] }.each do |season, (month, day, hour)|
    context "with Prague #{season} time in a UTC process" do
      before do
        allow(Time).to receive(:now).and_return(Time.utc(2026, month, day, 18, 36, 38))
        xml = <<~XML
          <RD5WEB t="2026-#{month}-#{day} #{hour}:36:38"><RD5><group>
            <O I="H10701" V="0"/><O I="H10709" V="1"/>
          </group></RD5></RD5WEB>
        XML
        response = instance_double(Faraday::Response, body: xml)
        request = instance_double(AtreaControl::Duplex::Request, call: response)
        allow(AtreaControl::Duplex::Request).to receive(:new).and_return(request)
      end

      it "accepts current device readings without re-login" do
        expect(AtreaControl::Duplex::Login).not_to receive(:user_tokens)
        expect(home.duplex.data[:timestamp]).to eq(Time.utc(2026, month, day, 18, 36, 38))
      end
    end
  end
end
