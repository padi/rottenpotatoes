module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end

  # gives a "hilite" class if the page described is the current page
  def highlight_if_clicked(page_info={})
    "hilite" if current_page?(page_info)
  end
end
