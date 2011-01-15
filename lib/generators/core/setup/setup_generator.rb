require 'rails/generators/named_base'

class Core::SetupGenerator < Rails::Generators::NamedBase

  source_root File.expand_path('../templates', __FILE__)

  def copy_load_setting_file
    copy_file 'settings.yml', 'config/settings.yml'
    initializer '001_load_config.rb' do
      require "ostruct"
      conf = YAML.load(ERB.new(File.read("#{Rails.root}/config/settings.yml")).result)[Rails.env].symbolize_keys
      APP_CONFIG = OpenStruct.new(conf)
    end
  end
    
  def add_dependencies_to_gemfile
    # General
    gem 'ffaker'
    gem 'haml-rails'
    gem 'inherited_resources', '1.1.2'
    gem 'jquery-rails', '0.2.5'
    gem 'meta_search'
    gem 'mysql2', '0.2.6'
    gem 'show_for'
    gem 'simple-navigation'
    gem 'simple_form', '1.3.0'
    gem 'whenever', '0.6.2'
    gem 'will_paginate', '3.0.pre2'

    # Development
    gem 'annotate', :group => :development
    gem 'irbtools', :group => :development, :require => false
    
    # Test
    with_options(:group => [:development, :test]) do |g|
      g.gem 'delorean'
      g.gem 'factory_girl', '2.0.0.beta1'
      g.gem 'factory_girl_rails', '1.1.beta1'
      g.gem 'fuubar'
      g.gem 'rspec-rails', '2.4.1'
      g.gem 'shoulda'
      g.gem 'steak', '1.0.1'
    end
  end
  
  def setup_git_configutation
    # git ignore
  end
  
  def run_generators
    generate 'rspec:install'
    generate 'jquery:install'
  end
  
end
