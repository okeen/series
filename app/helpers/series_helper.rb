module SeriesHelper

  def simple_link_to_serie(serie)
    link_to serie.title, series_path(h(serie.title)), :class => 'serie_link'
  end

  def serie_info_panel(serie)
    content_tag :div, :id =>'serie_info_panel' do
      "<p id='serie_title'><b>#{serie.title}</b></p>
       <p id='serie_description'>
         <b>Description:</b>
         #{serie.description}
       </p>".html_safe+
        serie_seasons_and_capitles_info(serie)
    end
  end

  def serie_seasons_and_capitles_info(serie)
    content_tag :div, :id=>'serie_seasons_and_capitles_info' do
      "<b>Seasons:</b> #{ serie.seasons_count }, <b>capitles: </b>#{ serie.capitles_count }".html_safe
    end
  end
end

