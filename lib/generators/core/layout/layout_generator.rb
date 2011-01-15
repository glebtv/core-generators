require 'rails/generators/named_base'

class Core::LayoutGenerator < Rails::Generators::NamedBase

  source_root File.expand_path('../templates', __FILE__)
  
  def copy_layout_file
    template "views/#{view_language}/layout.html.#{view_language}", "app/views/layouts/#{name}.html.#{view_language}"
  end
  
  def copy_sidebar_file
    template "views/#{view_language}/_sidebar.html.#{view_language}", "app/views/shared/_sidebar.html.#{view_language}"
  end
  
  def copy_core_helper
    template 'core_helper.rb', File.join('app/helpers', "core_helper.rb")
  end
  
  def copy_buttons
    directory "images", "public/images"
  end
  
  def copy_locale_file
    copy_file "locales/core.en.yml", "config/locales/core.en.yml"
    copy_file "locales/core.es.yml", "config/locales/core.es.yml"
  end
  
  def install_haml_and_rails
    gem 'haml-rails'
    initializer 'haml_sass.rb', 
      'Sass::Plugin.options[:template_location] = File.join([Rails.root, "app", "stylesheets"])'
  end
  
  def copy_static_files
    directory "stylesheets", "app/stylesheets/#{file_name}"
  end
  
  private
  
  def view_language
    'haml'
  end
    
end
