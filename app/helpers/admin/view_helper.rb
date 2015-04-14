module Admin::ViewHelper

  def hint(hint_text)
    return content_tag(:p, hint_text, class:"hint")
  end

  def index_th(label, sort:false)

    sorting_class = sort.present?? "-sortable" : "-unsortable"
    sort_direction = nil

    if label == :id
      label = "ID"
    elsif label.is_a?(Symbol)
      label = label.to_s.humanize.titleize
    end

    content_tag(:th, label, class:"index-th #{sorting_class} #{sort_direction}")

  end

  def index_td(resource, method_or_content, options = {})

    if method_or_content.is_a?(Symbol)
      content = resource.send(method_or_content)
    else
      content = method_or_content
    end

    options[:class] = "index-td #{options[:class]}"

    return content_tag(:td, options) do
      link_to url_for(action:"edit", id:resource.id) do
        content.to_s
      end
    end

  end

  def actions_th
    index_th("Actions", sort:false)
  end

  def actions_td(resource)

    edit_link = link_to("Edit", url_for(action:"edit", id:resource.id), class:"button -small")

    inspect_link = link_to("Inspect", url_for(action:"show", id:resource.id), class:"button -small")

    delete_link = link_to("Delete", url_for(action:"show", id:resource.id), {
      class: "button -small",
      method: :delete,
      :'data-confirm' => "Are you sure you want to delete the #{resource.model_name.human.downcase} “#{Tolaria.display_name(resource)}”? This action is not reversible.",
    })

    return content_tag(:td, "#{edit_link}#{inspect_link}#{delete_link}".html_safe, class:"actions-td")

  end

end
