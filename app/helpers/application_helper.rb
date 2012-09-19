module ApplicationHelper

  def add_this(title, options)
    # add google analytics tracking
    url = request.url
    url += url.include?('?') ? '&' : '?'
    url += 'utm_source=add_this&utm_medium=%{provider}'

    Codecamp::StaticAddthis.icons(options.reverse_merge(
      :title => title,
      :url => request.url,
      :username => 'ra-500d191b69503060',
      :uid => 'UA-34680064-1'
    ))
  end

  def layout_name
    layout_name = controller.send(:_layout)
    return layout_name if layout_name.is_a?(String)
    layout_name.virtual_path.name
  end

  def devise_layout?
    layout_name == 'devise'
  end

  def serialize_title(str)
    str.gsub(/\-/,' ').split(/\s/).map{|x| x.capitalize}.join(" ")
  end



  def currency_format(nominal, unit = "USD")
    number_to_currency(nominal, :unit => unit||"USD", :format => "%u. %n")
  end



  def expand_tree_into_select_field(categories, selected_id = nil, recursive=false)
    html = recursive ? "" : "<option value=''></option>"
    categories.each do |category|
      if selected_id.present? && selected_id == category.id
        selected = "selected='selected'"
      else
        selected = ""
      end
      html << %{<option #{selected} value="#{ category.id }">#{ '&nbsp;-&nbsp;' * category.ancestors.count }#{ category.name }</option>}
      html << expand_tree_into_select_field(category.children, selected_id, true) if category.has_children?
    end
    return html.html_safe
  end

  delegate :resource_error_messages!, to: Codecamp::Helpers

  # to include javascsript file to page
  def javascript(*args)
    content_for(:javascript) { javascript_include_tag(*args) }
  end

  # to call js function on document.ready
  def call_js_init(something_js)
    content_for :javascript do
      "<script type='text/javascript'>
          $(document).ready(function(){
            #{something_js}
          });
      </script>".html_safe
    end
  end

  def page_entries_info(collection, options = {})
    if collection.num_pages < 2
      case collection.size
      when 0; info = "No entries found"
      when 1; info = "Showing <strong>1</strong> entry"
      else;   info = "Showing <strong>all #{collection.size}</strong> entries"
      end
    else
      info = %{Showing <strong>%d to %d</strong> of <strong>%d</strong> in entries}% [
        collection.offset_value + 1,
        collection.offset_value + collection.count(true),
        collection.total_count
      ]
    end
    info.html_safe
  end


end
