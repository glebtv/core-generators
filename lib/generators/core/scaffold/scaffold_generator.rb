require 'rails/generators/named_base'
require 'rails/generators/migration'
require 'rails/generators/resource_helpers'
require 'rails/generators/generated_attribute'
require 'rails/generators/active_record/migration'

class Core::ScaffoldGenerator < Rails::Generators::NamedBase

  include Rails::Generators::ResourceHelpers  
  include Rails::Generators::Migration
  extend ActiveRecord::Generators::Migration
  
  source_root File.expand_path('../../templates', __FILE__)
  
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
 
  def create_model_file
    template 'model.rb', File.join('app/models', class_path, "#{file_name}.rb")
  end
  
  def create_migration_file
    migration_template "migration.rb", "db/migrate/create_#{table_name}.rb"
  end
  
  def add_resource_route
    return if options[:actions].present?
    route_config =  class_path.collect{|namespace| "namespace :#{namespace} do " }.join(" ")
    route_config << "resources :#{file_name.pluralize}"
    route_config << " end" * class_path.size
    route route_config
  end
  
  private
  
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
  
end
