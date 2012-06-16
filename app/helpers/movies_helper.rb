module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end

  # gives a "hilite" class if the page described is the current page
  def highlight_if_clicked(url)
    current_page?(url) ? "hilite" : ""
  end

  def is_checked? rating
    params[:ratings] && params[:ratings].include?(rating)
  end

  def highlighted_header_link_to body, url, html_options = {}
    content_tag(:th, link_to(body, url, html_options), :class => highlight_if_clicked(url))
  end
end
