RSpec.describe DuplexCronJob, type: :job do
  subject(:job) { described_class.new }

  it "queues the job" do
    expect { described_class.perform_later }.to have_enqueued_job(described_class)
  end
end
