Symphonia.configure do |config|
  config.after_login_path = ->(h) { h.symphonia.user_current_path }
  config.allow_registrations = true
  config.default_locale = :cs
end
Rails.application.config.to_prepare do
  begin
    # initialization code goes here
    Symphonia::User.include UserHome
  rescue StandardError => e
    Rails.logger.error e
    # skip if migrations
  end
  Symphonia::MenuManager.map :top_menu do |m|
    m[:home] = {
      label: :label_home,
      icon: 'fa fa-home',
      url: '/'
    }
  end
  Symphonia::MenuManager.map :top_menu_account do |m|
    # -----
    m[:my_account] = {
      label: :label_my_account,
      icon: 'fa fa-wrench',
      url: ->(h) { h.main_app.edit_home_path },
      if: proc { Symphonia::User.current.logged_in? }
    }
    m[:logout] = {
      label: :button_logout,
      icon: 'fa fa-sign-out',
      url: ->(h) { h.symphonia.logout_path },
      method: 'delete',
      if: proc { Symphonia::User.current.logged_in? }
    }
    m[:login] = {
      label: :button_login,
      icon: 'fa fa-right-to-bracket',
      url: ->(h) { h.symphonia.login_path },
      if: proc { !Symphonia::User.current.logged_in? }
    }
  end

end
