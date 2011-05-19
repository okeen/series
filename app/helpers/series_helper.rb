module SeriesHelper

  def simple_link_to_serie(serie)
    link_to serie.title, series_path(serie), :class => 'serie_link'
  end
end
