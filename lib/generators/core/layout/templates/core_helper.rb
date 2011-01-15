module CoreHelper
  def flashes
    haml_tag '.flash' do
      flash.each do |type, message|
        haml_tag :div, {:class => "message #{type}"} do
          haml_tag :p, message
        end
      end
    end
  end
  
  def sidebar
    yield
    content_for :sidebar, render('shared/sidebar')
  end
  
  def yes_no(value)
    value ? I18n.t('show_for.yes') : I18n.t('show_for.no')    
  end
  
  def navigation_list
    content_for(:actions) do
      haml_tag 'ul.navigation' do
        yield
      end
    end
  end
  
  def extra_content(title = nil, &block)
    content_for(:extra) do
      haml_tag 'div.block.notice' do
        haml_tag("h3", title) if title
        haml_tag "div.content" do
          yield
        end
      end
    end
  end
  
  def action_links_for_current_action
    case params[:action]
    when 'index' then 
      action_link_to('new')
    when 'edit' then 
      action_link_to('show')
      action_link_to('new')
      action_link_to('list')
    when 'new' then 
      action_link_to('list')
    when 'show' then 
      action_link_to('edit')
      action_link_to('new')
      action_link_to('list')
    end
  end
  
  def action_link_to(name, url = nil)
    if crud_actions.include?(name)
      resource_name = resource_class.human_name
      resource_name = resource_name.pluralize if name == "list"
    end
    
    url ||= url_for_name(name)
    link = link_to(t("core.#{name}" , :default => "#{name.humanize} #{resource_name}"), url)
    haml_tag :li, link
  end
  
  def toggle_box(title, collapsed = true)    
    haml_tag :div, :class => 'toggle' do
      haml_tag :h2 do
        haml_concat title
        haml_tag "span.small.expanded-link", "[view]", (collapsed ? {} : { :class => 'hide' } )
        haml_tag "span.small.collapsed-link", "[hide]", (collapsed ? { :class => 'hide' } : {} )
      end
      haml_tag ".content", (collapsed ? { :class => 'hide' } : {} ) do
        yield
      end
    end
  end
  
  def url_for_name(name)
    case name
    when 'new' then new_resource_path
    when 'edit' then edit_resource_path
    when 'show' then resource_path
    when 'destroy' then resource_path
    when 'list' then collection_path
    end
  end
  
  def show_content_if(content, &block)
    if content.present?
      content + with_output_buffer(&block)
    end
  end
  
  def content_block(title = "")
    haml_tag '.content' do
      haml_tag :h2, :class => "title" do
        haml_concat title
      end
      haml_tag ".inner" do
        yield
      end
    end
  end
  
  private

  def crud_actions
    %w(list edit new show destroy)
  end
    
end