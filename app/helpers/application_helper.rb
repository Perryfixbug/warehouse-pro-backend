module ApplicationHelper
  def active_link_to(name = nil, path = nil, **options, &block)
    active_class = current_page?(path) ? "bg-blue-100 text-blue-700 font-medium" : ""
    link_to(name, path, class: "#{options[:class]} #{active_class}", &block)
  end
end
