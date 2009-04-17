require 'rbconfig'
require 'fileutils'

class NaniteGenerator < Rails::Generator::Base
  DEFAULT_SHEBANG = File.join(Config::CONFIG['bindir'],
                              Config::CONFIG['ruby_install_name'])

  def initialize(runtime_args, runtime_options = {})
    puts File.read(File.dirname(__FILE__)+"/README")
    sleep 5
    super
  end

  def manifest
    record do |m|
      script_options = { :chmod => 0755, :shebang => options[:shebang] == DEFAULT_SHEBANG ? nil : options[:shebang] }

      # Rake tasks
      m.directory 'lib/tasks'
      m.file      'nanite.rake', 'lib/tasks/nanite.rake'

      # Scripts
      m.file      'script/nanite', 'script/nanite', script_options
      m.file      'script/run-jobs', 'script/run-jobs', script_options

      # Config
      m.directory 'config'
      m.file      'config/nanite_mapper.yml', 'config/nanite_mapper.sample.yml'
      m.file      'config/nanite_mapper.yml', 'config/nanite_mapper.yml'

      m.file      'config/nanite_worker.yml', 'config/nanite_worker.sample.yml'
      m.file      'config/nanite_worker.yml', 'config/nanite_worker.yml'

      # Nanite
      m.directory 'nanite/worker'
      m.file      'nanite/worker/config.yml', 'nanite/worker/config.yml'
      m.file      'nanite/worker/init.rb', 'nanite/worker/init.rb'

      m.directory 'nanite/worker/actors'
      m.file      'nanite/worker/actors/worker.rb', 'nanite/worker/actors/worker.rb'

      # Initializer
      m.directory 'config/initializers'
      m.file      'config/initializers/nanite.rb', 'config/initializers/nanite.rb'

      # Model
      m.directory 'app/models'
      m.file      'app/models/nanite_job.rb', 'app/models/nanite_job.rb'

      # Migration
      m.migration_template 'db/migrate/create_nanite_jobs.rb', 'db/migrate', :assigns => {
          :migration_name => "CreateNaniteJobs"
      }, :migration_file_name => "create_nanite_jobs"
    end
  end

  protected
  def banner
    "Usage: #{$0} nanite"
  end
end
