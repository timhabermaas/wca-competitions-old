module ApplicationHelper
  def m(text)
    RedCloth.new(text).to_html.html_safe
  end

  def wca(id)
    "http://worldcubeassociation.org/results/p.php?i=#{id}"
  end
end
