module ApplicationHelper

  def title(page_title)
    content_for(:title) { page_title }
  end

  def flash_box(the_type, the_prefix, msg)
    content_tag(:div, class: "alert mb10") do
      Array(msg).concat(Array("<b>#{the_prefix}</b>")).reverse.join(' ').html_safe
    end
  end

  def flash_message_helper
    if request.flash.any?
      flash_type = request.flash.to_hash.keep_if { |key, val| val.present? }.keys.first
      flash_body = request.flash.discard.collect { |k, msg| msg }
      flash_prefix = if flash_body.first.is_a?(Array)
                       flash_body.first.shift
                     elsif flash_type == :notice
                       'Success!'
                     else
                       'Oops!'
                     end
      flash_box(flash_type, flash_prefix, flash_body)
    end
  end

  def sortable(column, title = nil)
    title ||= column.to_s.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'
    link_to title, {:sort => column, :direction => direction}, {:class => css_class}
  end

  def main_nav_links(in_customer_mode)
    content_tag(:div, class: "customer-actions #{customer_action_class}") do
      concat tab_link_to('Home', root_path, at?('main'))
      concat tab_link_to('Customers', customers_path, (at?('customers') || in_customer_mode) && controller_name != 'users')
      unless in_customer_mode
        concat tab_link_to('Cars', cars_path, at?('cars'))
        concat tab_link_to('Work Orders', workorders_path, at?('workorders'))
        concat tab_link_to('Jobs', jobs_path, at?('jobs'))
        concat tab_link_to('Parts', parts_path, at?('parts'))
      end
      concat tab_link_to('Admin', users_path, at?('users'))
      concat link_to('Log out', logout_path, style: 'margin-right:0')
    end
  end

  def render_paging(collection=nil)
    x = will_paginate(collection ||= instance_variable_get("@#{controller_name}"))

    if collection.present? && collection.any?
      content_tag(:table, class: 'plain') do
        content_tag(:tbody) do
          content_tag(:tr) do
            concat(content_tag(:td, x, style: 'width:60%'))
            concat(content_tag(:td, "Showing <b>#{collection.offset + 1}</b>-<b>#{collection.offset + collection.length}</b> of <b>#{collection.total_entries}</b>".html_safe, class: 'ra page-count', style: 'width:40%'))
          end
        end
      end
    end
  end

  def at?(name='')
    controller_name == name
  end

  def tab_link_to(*args)
    link_to(*args, class: "#{'active' if args.pop}")
  end

  def customer_action_class
    in_customer_mode ? ' customer-mode' : ''
  end

  def errors_for(record)
    if record.errors.any?
      content_tag(:div, id: 'error_explanation') do
        content_tag(:h2) do
          "#{pluralize(record.errors.count, 'error')} prohibited this record from being saved"
        end + content_tag(:ul) do
          record.errors.full_messages.each do |msg|
            concat content_tag(:li, msg)
          end
        end
      end
    end
  end
end
