class Core::ScaffoldGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  
  include Rails::Generators::Migration
  
  def copy_controller_file
    say "Copying"
  end
  
  def copy_model_file
    say "Copying"
  end
  
end
