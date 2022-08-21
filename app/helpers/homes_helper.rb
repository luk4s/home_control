module HomesHelper

  def atrea_controls
    # (controls = %w[poweroff auto ventilate].each_with_object({}) { |i, dict| dict[i] = t("controls.#{i}") }).to_json
    {
      poweroff: {
        icon: "power-off",
        text: t("controls.poweroff"),
        url: scenario_home_path(scenario: "poweroff"),
        css_class: "btn-danger",
      },
      auto: {
        icon: "cogs",
        text: t("controls.auto"),
        url: scenario_home_path(scenario: "auto"),
        css_class: "btn-secondary",
      },
      ventilate: {
        icon: "bullseye",
        text: t("controls.ventilate"),
        url: scenario_home_path(scenario: "ventilate"),
        css_class: "btn-light",
      },
      manual: {
        icon: "bullseye",
        text: t("controls.ventilate"),
        url: scenario_home_path(scenario: "manual"),
        css_class: "btn-light",
      },
    }
  end

end
