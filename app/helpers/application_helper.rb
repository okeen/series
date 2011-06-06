module ApplicationHelper
  def header
    content_tag :div, :id=>'header', :class=>'header' do
      link_to( "Seri.es", root_path)+
      user_panel
    end
  end

  def user_panel
    content_tag :div, :id=>'user_panel' do
      '<div id="user_panel_title">Login to unleash the power</div>'.html_safe+
      '<fb:login-button perms="read_stream,publish_stream,email" show-faces="false" width="200" max-rows="1"></fb:login-button>'.html_safe
    end
  end
  
  def nav_menu
    content_tag :div, :id=>'nav', :class=>'nav' do
      link_to( "Indice", series_index_path)+
      clearer
    end
  end

  def footer
    content_tag :div, :id=>'footer', :class=>'footer' do
      footer_bottom
    end
  end

  def footer_bottom
    content_tag :div, :id=>'footer_bottom', :class=>'bottom' do
      ('<span class="left"><a href="http://seri.es/">seri.es</a>. Valid <a href="http://jigsaw.w3.org/css-validator/check/referer">CSS</a> and <a href="http://validator.w3.org/check?uri=referer">XHTML</a>.</span>'+
          '<span class="right">Template design by <a href="http://templates.arcsin.se">Arcsin</a></span>'+
          clearer).html_safe
    end
  end
  
  def clearer
    content_tag :div, :class=>'clearer' do
      content_tag :span
    end
  end

  def stripes
    content_tag :div, :class=>'stripes' do
      content_tag :span
    end
  end

  def catalog_header
    content_tag :div, :class=> 'catalog_header' do
      (
        content_tag :div, :class => 'catalog_header_tab clickable_container z-index-2 last_tab' do
          link_to "Favourites", home_path
        end
      ) +
        (
        content_tag :div, :class => 'catalog_header_tab clickable_container z-index-1'do
          link_to "Latests", home_path
        end
      )
    end
  end

  def letter_filter_links_sidebar
    content_tag :div, :id=>'catalogue_filter_letters' do
      ('A'..'Z').to_a.collect { |letter|
        content_tag :div, :class => 'letter_filter_letter_container clickable_container' do
          link_to letter, catalog_letter_path(letter.downcase)
        end
      }.join(" ").html_safe
    end
  end
  
  def catalog_next_results_link(todos)
    url = catalog_path + "?page=#{todos.current_page.next}"
    link_to("Next results", url, :id => "catalog_next_results")
  end

  def catalog_previous_results_link(todos)
    url= catalog_path + "?page=#{todos.current_page-1}"
    link_to("Previous results", url, :id => "catalog_previous_results")
  end

end
