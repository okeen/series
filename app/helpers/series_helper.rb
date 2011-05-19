module SeriesHelper

  def simple_link_to_serie(serie)
    link_to serie.title, series_path(h(serie.title)), :class => 'serie_link'
  end
end
