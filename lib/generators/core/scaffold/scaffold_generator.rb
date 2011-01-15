require 'rails/generators/migration'
require 'rails/generators/resource_helpers'
require 'rails/generators/generated_attribute'
require 'rails/generators/active_record/migration'

class Core::ScaffoldGenerator < Rails::Generators::NamedBase

  source_root File.expand_path('../templates', __FILE__)
  
  include Rails::Generators::ResourceHelpers  
  include Rails::Generators::Migration
  extend ActiveRecord::Generators::Migration
  
  check_class_collision :suffix => "Controller"
  
  argument :args_for_c_m, :type => :array, :default => [], :banner => 'controller_actions and model:attributes'
  
  class_option :timestamps, :type => :boolean, :default => true
  class_option :parent,     :type => :string, :default => 'ActiveRecord::Base', 
               :desc => "The parent class for the generated model"
  
  def initialize(*args, &block)
    super

    @controller_actions = []
    @model_attributes = []

    args_for_c_m.each do |arg|
      if arg.include?(':')
        @model_attributes << Rails::Generators::GeneratedAttribute.new(*arg.split(':'))
      else
        @controller_actions << arg
        @controller_actions << 'create' if arg == 'new'
        @controller_actions << 'update' if arg == 'edit'
      end
    end

    @controller_actions.uniq!
    @model_attributes.uniq!

    if @controller_actions.empty?
      @controller_actions = default_actions - @controller_actions
    end
  end

  def create_controller_files
    template 'controller.rb', File.join('app/controllers', class_path, "#{controller_file_name.pluralize}_controller.rb")
  end
 
  def create_helper_file
    template 'helper.rb', File.join('app/helpers', class_path, "#{controller_file_name.pluralize}_helper.rb")
  end
 
  def create_model_file
    template 'model.rb', File.join('app/models', class_path, "#{file_name}.rb")
  end
  
  def add_resource_route
    return if options[:actions].present?
    route_config =  class_path.collect{|namespace| "namespace :#{namespace} do " }.join(" ")
    route_config << "resources :#{file_name.pluralize}"
    route_config << " end" * class_path.size
    route route_config
  end

  def copy_view_files
    actions.each do |action|
      if %w[index show new edit].include?(action)
        template "views/#{view_language}/#{action}.html.#{view_language}", "#{views_path}/#{action}.html.#{view_language}"
      end
    end

    if form_partial?
      template "views/#{view_language}/_form.html.#{view_language}", "#{views_path}/_form.html.#{view_language}"
    end
    
    if index?
      template "views/#{view_language}/_search.html.#{view_language}", "#{views_path}/_search.html.#{view_language}"
      template "views/#{view_language}/_collection.html.#{view_language}", "#{views_path}/_#{plural_name}.html.#{view_language}"
      template "views/#{view_language}/index.js.#{view_language}", "#{views_path}/index.js.#{view_language}"
    end
  end
  
  def create_migration_file
    migration_template "migration.rb", "db/migrate/create_#{table_name}.rb"
  end

  private

  def views_path
    File.join("app/views", class_path, plural_name)
  end
  
  def form_partial?
    actions.include?("new") || actions.include?("edit")
  end
  
  def index?
    actions.include?("index")
  end
  def default_actions?
    actions == default_actions
  end
  
  def default_actions
    %w(index create update new edit destroy show)
  end
  
  def attributes
    @model_attributes
  end
  
  def actions
    @controller_actions || default_actions
  end
  
  def parent_class_name
     options[:parent] || "ActiveRecord::Base"
  end

  def view_language
    'haml'
  end  
end
