class Core::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def copy_load_setting_file
    copy_file 'settings.yml', 'config/settings.yml'
    initializer '001_load_config.rb', <<-FILE
require "ostruct"
conf = YAML.load(ERB.new(File.read("#{Rails.root}/config/settings.yml")).result)[Rails.env].symbolize_keys
APP_CONFIG = OpenStruct.new(conf)
FILE
  end
    
  def add_dependencies_to_gemfile
    # General
    gem 'ffaker'
    gem 'haml-rails'
    gem 'inherited_resources', '1.1.2'
    gem 'jquery-rails', '0.2.6'
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
    
    ask("Before answering, please, run bundle install in another terminal (Sorry):")
  end
  
  def copy_locale_file
    copy_file "locales/core.en.yml", "config/locales/core.en.yml"
    copy_file "locales/core.es.yml", "config/locales/core.es.yml"
  end
  
  def setup_git_configutation
    run 'rm README'
    run 'cp config/database.yml config/database.yml.example'
    run 'rm public/index.html'
    run 'rm public/favicon.ico'
    run 'rm public/images/rails.png'
    run 'touch README'

    # Ignoring files
    create_file '.gitignore', <<-FILE
!gems/bundler
!gems/cache
*.swp
.bundle
.DS_Store
.yardoc
capybara*
config/database.yml
db/*.sqlite3
db/schema.rb
doc/api
doc/app
gems/*
log/*.log
nbproject/
public/system
public/uploads/*
tmp/**/*
    FILE
    
    git :init
    git :add => '.gitignore'
    git :commit => '-m "Adding ignore file".'
  end

  def run_generators
    with_ssl_fix_for_jquery_rails do
      generate 'rspec:install'
      generate 'jquery:install --ui'
    end
  end
  
  def install_log_rotator
    log_path = '#{Rails.root}/log/#{Rails.env}.log'
    gsub_file 'config/application.rb', /(< Rails::Application.*)/ , "\\1\n    config.logger = Logger.new(\"#{log_path}\", 50, 1048576)"    
  end
  
  private
  
  def with_ssl_fix_for_jquery_rails 
    initializer '002_fixes.rb', <<-FIX
      # Until the issue with github ssl is fixed.
      require 'openssl'
      OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
    FIX
    yield
    run 'rm config/initializers/002_fixes.rb'
  end
end
