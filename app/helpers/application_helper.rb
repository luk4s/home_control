module ApplicationHelper

  # @param [String] icon name
  # @param [String, nil] text (optional text after icon)
  # @param [Hash] html_options
  # @option [String] :title (optional title for icon)
  # @option [String] :class (optional class for icon)
  # @option [String] :text (optional text for icon)
  def icon(icon, text = nil, html_options = {})
    if text.is_a?(Hash)
      html_options = text
      text = nil
    end

    text_content = if text
                     tag.span(text, class: "d-none d-sm-inline")
                   elsif html_options[:text]
                     html_options.delete(:text)
                   end
    html_options[:title] ||= text
    html_options[:class] = "fa-solid fa-#{icon}"
    html_options["aria-hidden"] ||= true

    html = tag.i(nil, **html_options)
    html << " " << text_content.to_s if text_content.present?
    html
  end

  def render_flash_messages
    s = ""
    flash.each do |type, text|
      bootstrap_flash = bootstrap_flash_map[type.to_sym]
      next unless bootstrap_flash

      s << tag.div(class: "d-print-none alert #{bootstrap_flash[:class_name]} alert-dismissible fade show", role: "alert") do
        icon(bootstrap_flash[:icon], text:) +
          tag.button("", class: "btn-close close", data: { "bs-dismiss": "alert" }, "aria-label": "Close")
      end
    end

    s.html_safe
  end

  private

  def bootstrap_flash_map
    {
      notice: { class_name: "alert-success", icon: "check-circle" },
      error: { class_name: "alert-danger", icon: "circle-exclamation" },
      alert: { class_name: "alert-danger", icon: "circle-exclamation" },
      warning: { class_name: "alert-warning", icon: "circle-exclamation" },
      info: { class_name: "alert-info", icon: "info-circle" },
    }
  end

end
