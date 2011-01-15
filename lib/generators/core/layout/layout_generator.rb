require 'rails/generators/named_base'

class Core::LayoutGenerator < Rails::Generators::Base
  attr_accessor :file_name
  
  source_root File.expand_path('../templates', __FILE__)
  
  argument :name, :default => 'application'
  
  def initialize(*args, &block)
    super
    @file_name = name
  end
  
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
  
  def copy_static_files
    directory "stylesheets", "app/stylesheets/#{file_name}"
  end
  
  private
  
  def view_language
    'haml'
  end
    
end
