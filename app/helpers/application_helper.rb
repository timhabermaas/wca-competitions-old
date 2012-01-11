module ApplicationHelper
  def title
    if current_competition?
      current_competition.name
    else
      "WCA Competitions"
    end
  end

  def m(text, *options)
    text.nil? ? "" : RedCloth.new(text, options).to_html.html_safe
  end

  def wca(id)
    "http://worldcubeassociation.org/results/p.php?i=#{id}"
  end

  def link_to_flag(locale)
    link_to locale, url_for(:locale => locale), :class => I18n.locale.to_s == locale.to_s ? "#{locale} active" : "#{locale}"
  end
end
