module ApplicationHelper
  def svg_tag(file_name, css_class: nil)
    file_path = Rails.root.join('app', 'assets', 'images', file_name)

    if File.exist?(file_path)
      file = File.read(file_path)
      doc = Nokogiri::HTML::DocumentFragment.parse(file)
      svg = doc.at_css 'svg'
      svg['class'] = css_class if css_class
      raw doc.to_html # rubocop:disable Rails/OutputSafety
    else
      content_tag(:div, 'svg not found')
    end
  end

  def t_enum(model, attr, key)
    I18n.t("activerecord.enums.#{model}.#{attr}.#{key}")
  end
end
