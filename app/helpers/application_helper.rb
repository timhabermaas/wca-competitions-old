module ApplicationHelper
  def m(text)
    text.nil? ? "" : RedCloth.new(text).to_html.html_safe
  end

  def wca(id)
    "http://worldcubeassociation.org/results/p.php?i=#{id}"
  end

  def link_to_flag(locale)
    link_to locale, url_for(:locale => locale), :class => I18n.locale.to_s == locale.to_s ? "#{locale} active" : "#{locale}"
  end
end
