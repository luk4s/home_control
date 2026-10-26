RSpec.describe Home do
  let(:home) do
    create(:my_home, duplex_user_ctrl: {
             input_temperature_source: source,
             sensors: { "input_temperature" => "I10204", "current_mode" => "H10708", "current_mode_switch" => "H10709" },
             modes: { "0" => "off" }, user_modes: {},
           }).reload
  end
  let(:source) { "rd5_standard" }
  let(:request) { instance_double(AtreaControl::Duplex::Request) }

  def readings(profile:, motor:, temperature: 111)
    registers = { "H11300" => profile, "H10501" => motor, "H10200" => 50, "H10201" => 50,
                  "I10200" => temperature, "I10201" => 222, "I10204" => 333, "H10708" => 0, "H10709" => 0, }
    objects = registers.map { |id, value| %(<O I="#{id}" V="#{value}"/>) }.join
    %(<RD5WEB t="#{Time.now.getlocal.strftime('%Y-%m-%d %H:%M:%S')}"><RD5><values>#{objects}</values></RD5></RD5WEB>)
  end

  def unit_temperature(**options)
    allow(AtreaControl::Duplex::Request).to receive(:new).with(user_id: "user", unit_id: "unit", sid: "token").and_return(request)
    allow(request).to receive(:call).with(_t: "config/xml.xml").and_return(Struct.new(:body).new(readings(**options)))
    AtreaControl::Duplex::Unit.new(user_id: "user", unit_id: "unit", sid: "token", user_ctrl: home).values[:input_temperature]
  end

  it "exposes source metadata after JSON persistence" do
    expect(home).to respond_to(:input_temperature_source)
    expect(home.input_temperature_source).to eq("rd5_standard")
  end

  it "selects M1 instead of direct temperature after persistence" do
    expect(unit_temperature(profile: 0, motor: 1)).to eq(11.1)
  end

  it "selects M2 instead of direct temperature after persistence" do
    expect(unit_temperature(profile: 0, motor: 2)).to eq(22.2)
  end

  it "selects direct temperature for direct profile" do
    expect(unit_temperature(profile: 1, motor: 1)).to eq(33.3)
  end

  it "preserves unavailable sensor readings as nil" do
    expect(unit_temperature(profile: 0, motor: 1, temperature: 1260)).to be_nil
  end

  context "with unsupported source" do
    let(:source) { "unsupported" }

    it "does not fall back to direct temperature" do
      expect(unit_temperature(profile: 1, motor: 1)).to be_nil
    end
  end

  context "with null legacy source" do
    let(:source) { nil }

    it "retains gem legacy direct fallback" do
      expect(unit_temperature(profile: 0, motor: 1)).to eq(33.3)
    end
  end
end
