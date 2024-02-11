class DuplexChannel < ApplicationCable::Channel

  def subscribed
    # stream_from "some_channel"
    stream_for current_user
    ReadDuplexJob.perform_later(current_user.home) if current_user.home
  end

  # After appear, refresh data
  def appear(_data)
    ReadDuplexJob.perform_later(current_user.home) if current_user.home
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

end
