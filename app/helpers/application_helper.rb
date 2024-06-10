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

  def formatted_temperature(data, type)
    data['temperature'][type]['celsius'] || '-'
  end

  def back_link(path, text)
    link_to path, class: 'w-fit' do
      content_tag(:div, class: 'flex items-center w-fit') do
        concat(svg_tag('vuesax/linear/arrow-left.svg', css_class: 'inline'))
        concat(text)
      end
    end
  end

  def determine_back_link(from, params) # rubocop:disable Metrics/CyclomaticComplexity
    case from
    when 'home'
      back_link(home_path, 'ホームに戻る')
    when 'spot_search'
      back_link(search_spots_searches_path, 'スポット検索結果に戻る')
    when 'spot_registration'
      back_link(new_spot_path, 'スポット登録に戻る')
    when 'my_spots'
      back_link(my_spots_path(tab: params[:tab]), 'マイスポット一覧に戻る')
    when 'spot_detail'
      back_link(spot_path(params[:spot]), 'スポット詳細に戻る')
    when 'my_page'
      back_link(my_page_path, 'マイページに戻る')
    when 'friendships'
      back_link(friendships_path, '友達一覧に戻る')
    when 'search_top'
      back_link(new_search_path, '検索トップに戻る')
    when 'map_view'
      back_link(map_view_searches_path, 'マップビューに戻る')
    end
  end
end
