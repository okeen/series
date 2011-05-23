module CapitlesHelper
  
  def capitle_content_header
    content_tag :div, :id => "capitle_content_header" do
      (%w(Videos Photos Links All).collect do |content_type|
          content_tag :div, :class => "clickable_container capitle_content_header_tab" do
            link_to_function content_type, "alert('#{content_type}');"
          end
        end).join(" ").html_safe
    end
  end

end
