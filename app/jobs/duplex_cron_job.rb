class DuplexCronJob < ApplicationJob
  queue_as :default

  def perform
    Home.active.find_each do |home|
      DuplexReadDataJob.perform_later(home)
    end
  end

end
