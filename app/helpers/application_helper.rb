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

  def as_admin?
    true if session[:as_admin] == true
  end

  def twitter_card(title:, description:)
    content_for :twitter_card do
      tag.meta(name: 'twitter:card', content: 'summary') +
        tag.meta(name: 'twitter:site', content: '@MotoTokyo_X') +
        tag.meta(name: 'twitter:title', content: title) +
        tag.meta(name: 'twitter:description', content: description) +
        tag.meta(name: 'twitter:image', content: image_path('logo_circle.png'))
    end
  end
end
