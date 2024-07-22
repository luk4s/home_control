class DuplexCronJob < ApplicationJob
  queue_as :default

  def perform
    Home.where.not(atrea_password: nil).find_each do |home|
      ReadDuplexJob.perform_later(home)
    end
  end

end
