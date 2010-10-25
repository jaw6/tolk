module Tolk
  module ApplicationHelper
    def format_i18n_value(value)
      h(yaml_value(value)).gsub(/\n/, '<br />')
    end

    def format_i18n_text_area_value(value)
      yaml_value(value)
    end

    def yaml_value(value)
      if value.present?
        unless value.is_a?(String)
          value = value.respond_to?(:ya2yaml) ? value.ya2yaml(:syck_compatible => true) : value.to_yaml
        end
      end
      
      value
    end

    def tolk_locale_selection
      existing_locale_names = Tolk::Locale.all.map(&:name)

      pairs = Tolk::Locale::MAPPING.to_a.map(&:reverse).sort_by(&:first)
      pairs.reject {|pair| existing_locale_names.include?(pair.last) }
    end

    def scope_selector_for(locale)
      select_tag 'scope', options_for_select([[Tolk::Locale.primary_locale.language_name, "origin"],
                                              [locale.language_name, "target"]], params[:scope])
    end
  end
  
  def ajax_pagination_links(paginator, controller, action, options={}, html_options={})
    html   = []
  
    html << if paginator.current.previous 
      content_tag(:span, link_to_remote("&laquo; Previous".html_safe, :method => :get, :url => { :controller => controller, :action => action, :page => paginator.current.previous}), :class => 'prev')
    end
      
    html << pagination_links_each(paginator, options) do |page|
      html_options[:title] = "Go to Page #{page}"    
      link_to_remote(page.to_s, :method => :get, :url => { :controller => controller, :action => action, :page => page})
    end
      
    html << if paginator.current.next 
      content_tag(:span, link_to_remote("Next &raquo;".html_safe, :method => :get, :url => {:controller => controller, :action => action, :page => paginator.current.next} ), :class => 'next') 
    end

    content_tag :div, html.join.html_safe, :id => 'pagination'
  end
  
  
  def pagination_links(paginator, options={}, html_options={})
    html   = []
    
    html << if paginator.current.previous 
      content_tag(:span, link_to("&laquo; Previous".html_safe, params.update(:page => paginator.current.previous) ), :class => 'prev') 
    end
        
    html << pagination_links_each(paginator, options) do |page|
      html_options[:title] = "Go to Page #{page}"
      
      link_to(page.to_s, params.update(:page => page), html_options)
    end
    
    html << if paginator.current.next 
      content_tag(:span, link_to("Next &raquo;".html_safe, params.update(:page => paginator.current.next) ), :class => 'next') 
    end
        
    content_tag :div, html.join(' ').html_safe, :id => 'pagination'
  end
  
  def js_pagination_links(paginator, options={}, html_options={})
    html   = []
    
    html << if paginator.current.previous 
      content_tag(:span, link_to("&laquo; Previous".html_safe, '#', {"data-page" => paginator.current.previous.to_i, :onclick => "return false;"}), :class => 'prev') 
    end
        
    html << pagination_links_each(paginator, options) do |page|
      html_options[:title] = "Go to Page #{page}"
      link_to(page.to_s, "#", html_options.merge("data-page" => page, :onclick => "return false;"))
    end
    
    html << if paginator.current.next 
      content_tag(:span, link_to("Next &raquo;".html_safe, "#", {"data-page" => paginator.current.next.to_i, :onclick => "return false;"}), :class => 'next') 
    end
        
    content_tag :div, html.join(' ').html_safe, :id => 'pagination'    
  end
end
