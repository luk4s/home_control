Symphonia.configure do |config|
  config.after_login_path = ->(h) { h.symphonia.user_current_path }
  config.allow_registrations = false
  config.default_locale = :cs
end

# Symphonia::MenuManager.map :top_menu do |m|
#   m[:home] = {
#     label: :label_home,
#     icon: 'fa fa-home',
#     url: '/'
#   }
#   m[:users] = {
#     label: :label_users,
#     icon: 'fa fa-user',
#     url: ->(h) { h.symphonia.users_path },
#     if: proc { Symphonia::User.current.admin? }
#   }
#   m[:roles] = {
#     label: :label_roles,
#     icon: 'fa fa-key',
#     url: ->(h) { h.symphonia.roles_path },
#     if: proc { Symphonia::User.current.admin? }
#   }
#
# end
# Symphonia::MenuManager.map :top_menu_account do |m|
#   # -----
#   m[:my_account] = {
#     label: :label_my_account,
#     icon: 'fa fa-wrench',
#     url: ->(h) { h.symphonia.account_path },
#     if: proc { Symphonia::User.current.logged_in? }
#   }
#   m[:logout] = {
#     label: :button_logout,
#     icon: 'fa fa-sign-out',
#     url: ->(h) { h.symphonia.logout_path },
#     method: 'delete',
#     if: proc { Symphonia::User.current.logged_in? }
#   }
#   m[:login] = {
#     label: :button_login,
#     icon: 'fa fa-signin',
#     url: ->(h) { h.symphonia.login_path },
#     if: proc { !Symphonia::User.current.logged_in? }
#   }
# end
