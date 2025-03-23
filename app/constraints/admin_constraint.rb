class AdminConstraint

  def matches?(request)
    return false unless request.env["warden"]

    user = request.env["warden"].user
    user&.admin?
  end

end
