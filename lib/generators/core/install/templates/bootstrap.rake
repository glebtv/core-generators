task :adr => 'app:development:reset'
task :asr => 'app:staging:reset'
task :apr => 'app:production:reset'

namespace :app do
  namespace :development do

    desc "Reset development environment"
    task :reset => [
      "db:drop:all",
      "db:create:all",
      "db:migrate",
      "app:bootstrap"
    ]
  end
  
  namespace :staging do

    desc "Reset staging environment"
    task :reset => [
      "db:drop:all",
      "db:create:all",
      "db:migrate",
      "app:bootstrap"
    ]
  end

  namespace :production do

    desc "Reset production environment"
    task :reset => [
      "db:drop:all",
      "db:create:all",
      "db:migrate",
      "app:bootstrap"
    ]
  end

  desc "Boostrap the application"
  task :bootstrap => :environment do
    
  end
end