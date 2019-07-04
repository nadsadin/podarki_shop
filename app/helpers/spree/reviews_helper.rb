module Spree::ReviewsHelper
  def rating_class(rating)
    if rating >= 5
      'excellent'
    elsif rating > 3
      'good'
    elsif rating > 0
      'medium'
    elsif rating == 0
      'nothing'
    end
  end

  def star(the_class)
    content_tag(:span, ' &#10030; '.html_safe, class: the_class)
  end

  def mk_stars(m)
    (1..5).collect { |n| n <= m ? star('lit') : star('unlit') }.join
  end

  def txt_stars(n, show_out_of = true)
    res = Spree.t(:star, count: n)
    res += " #{Spree.t('out_of_5')}" if show_out_of
    res
  end
end