module UserHome

  extend ActiveSupport::Concern

  included do
    has_one :home, dependent: :destroy
  end

end
