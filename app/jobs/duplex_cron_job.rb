class DuplexCronJob < ApplicationJob
  queue_as :default

  def perform
    Home.all.find_each do |home|
      next if home.status_login_in_progress? && home.updated_at > 10.minutes.ago

      DuplexReadDataJob.perform_later(home)
    end
  end

end
