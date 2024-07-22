module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_user || reject_unauthorized_connection
      logger.add_tags "ActionCable", current_user.login unless current_user.nil?
    end

    protected

    def find_user
      return if (credentials = request.session["symphonia/user_credentials"]).blank?

      ::Symphonia::User.find_by(persistence_token: credentials.split(":")[0])
    end

  end
end
