require "faraday"

RSpec.describe AtreaDuplex do
  let(:home) { create(:my_home, duplex_auth_token: "old-token", duplex_user_ctrl: metadata) }
  let(:metadata) { {} }
  let(:duplex) { described_class.new(home) }
  let(:tokens) { { user_id: "new-user", unit_id: "new-unit", sid: "new-token" } }

  def stub_login
    allow(AtreaControl::Duplex::Login).to receive(:user_tokens).with(login: home.atrea_login, password: home.atrea_password).and_return(tokens)
    allow(AtreaControl::Duplex::UserCtrl).to receive(:data).with(**tokens).and_return({ input_temperature_source: "rd5_standard" })
  end

  [nil, "", "  "].each do |source|
    context "with cached source #{source.inspect}" do
      let(:metadata) { { input_temperature_source: source } }

      before { stub_login }

      it "refreshes existing token/config and persists source" do
        duplex.control
        expect([home.reload.duplex_auth_token, home.status]).to eq(%w[new-token authenticated])
        expect(home.duplex_user_ctrl["input_temperature_source"]).to eq("rd5_standard")
      end

      it "refreshes only once" do
        expect(AtreaControl::Duplex::Login).to receive(:user_tokens).once
        unit = duplex.control
        expect(duplex.control).to equal(unit)
      end
    end
  end

  %w[rd5_standard unsupported].each do |source|
    context "with current source #{source}" do
      let(:metadata) { { input_temperature_source: source } }

      it "reuses cached config without login" do
        expect(AtreaControl::Duplex::Login).not_to receive(:user_tokens)
        expect(duplex.control).to equal(duplex.control)
      end
    end
  end

  it "rebuilds previously cached Unit with refreshed credentials" do
    old_unit = cache_old_unit
    stub_login
    expect(AtreaControl::Duplex::Unit).to receive(:new).with(**tokens, user_ctrl: home, time_zone: ENV.fetch("ATREA_TIME_ZONE", "Europe/Prague")).and_call_original
    expect(duplex.control).not_to equal(old_unit)
  end

  it "discards Unit when login/config is explicitly refreshed" do
    home.duplex_user_ctrl = { input_temperature_source: "rd5_standard" }
    old_unit = duplex.control
    stub_login
    duplex.login_and_update_tokens!
    expect(duplex.control).not_to equal(old_unit)
  end

  it "marks failed and propagates refresh failure" do
    allow(AtreaControl::Duplex::Login).to receive(:user_tokens).and_raise(AtreaControl::Error, "synthetic failure")
    expect { duplex.control }.to raise_error(AtreaControl::Error, "synthetic failure")
    expect(home.reload).to be_status_failed
  end

  it "marks failed when configuration discovery fails" do
    stub_login
    allow(AtreaControl::Duplex::UserCtrl).to receive(:data).and_raise(AtreaControl::Error, "synthetic config failure")
    expect { duplex.control }.to raise_error(AtreaControl::Error, "synthetic config failure")
    expect(home.reload).to be_status_failed
  end

  context "without authentication token" do
    let(:metadata) { { input_temperature_source: "rd5_standard" } }

    it "still logs in with current metadata" do
      home.duplex_auth_token = nil
      stub_login
      duplex.control
      expect(home.reload.duplex_auth_token).to eq("new-token")
    end
  end

  describe "#data session recovery" do
    let(:metadata) { { input_temperature_source: "rd5_standard" } }
    let(:fresh_unit) { instance_double(AtreaControl::Duplex::Unit, values: { current_power: 88.0 }) }

    before do
      allow(duplex.control).to receive(:values).and_raise(AtreaControl::SessionExpired)
      stub_login
      allow(AtreaControl::Duplex::Unit).to receive(:new).with(**tokens, user_ctrl: home, time_zone: ENV.fetch("ATREA_TIME_ZONE", "Europe/Prague")).and_return(fresh_unit)
    end

    [AtreaControl::SessionExpired, Faraday::ForbiddenError].each do |error_class|
      it "logs in again and reads with fresh credentials after #{error_class}" do
        allow(duplex.control).to receive(:values).and_raise(error_class)
        expect(AtreaControl::Duplex::Login).to receive(:user_tokens).once

        expect(duplex.data).to eq(current_power: 88.0)
      end
    end

    it "propagates another expiry after one re-login instead of looping" do
      allow(fresh_unit).to receive(:values).and_raise(AtreaControl::SessionExpired)
      expect(AtreaControl::Duplex::Login).to receive(:user_tokens).once

      expect { duplex.data }.to raise_error(AtreaControl::SessionExpired)
    end
  end

  def cache_old_unit
    home.duplex_user_ctrl = { input_temperature_source: "rd5_standard" }
    unit = duplex.control
    home.duplex_user_ctrl = {}
    unit
  end
end
