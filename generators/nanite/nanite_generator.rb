require 'rbconfig'
require 'fileutils'

class NaniteGenerator < Rails::Generator::Base
  DEFAULT_SHEBANG = File.join(Config::CONFIG['bindir'],
                              Config::CONFIG['ruby_install_name'])

  def initialize(runtime_args, runtime_options = {})
    puts File.read(File.dirname(__FILE__)+"/README")
    sleep 5
    $stdout.flush
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

      # Config
      m.directory 'config/nanite'
      m.file      'config/nanite/mapper.yml', 'config/nanite/mapper.sample.yml'
      m.file      'config/nanite/worker.yml', 'config/nanite/worker.sample.yml'

      # Nanite
      m.directory 'nanite/worker'
      m.file      'nanite/worker/config.yml', 'nanite/worker/config.yml'
      m.file      'nanite/worker/init.rb', 'nanite/worker/init.rb'

      m.directory 'nanite/worker/actors'
      m.file      'nanite/worker/actors/worker.rb', 'nanite/worker/actors/worker.rb'

      # Initializer
      m.directory 'config/initializers'
      m.file      'config/initializers/nanite.rb', 'config/initializers/nanite.rb'
    end
  end

  protected
  def banner
    "Usage: #{$0} nanite"
  end
end
