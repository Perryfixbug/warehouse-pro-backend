module ApplicationHelper
  def active_link_to(name = nil, path = nil, **options, &block)
    active_class = current_page?(path) ? "bg-blue-100 text-blue-700 font-medium" : ""
    link_to(name, path, class: "#{options[:class]} #{active_class}", &block)
  end

  def sidebar_link_class(path, extra_condition = false)
    base = "flex items-center px-6 py-2 rounded-r-full transition"
    active = "bg-blue-200 text-blue-600 font-semibold"
    inactive = "text-gray-700 hover:bg-blue-50 hover:text-blue-600"

    current_page?(path) || extra_condition ? "#{base} #{active}" : "#{base} #{inactive}"
  end

  def sidebar_group_active?(*controllers)
    controllers.include?(controller.controller_name)
  end
end
