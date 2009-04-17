require 'nanite'
require 'nanite/rails'

unless ENV["NO_NM"]
  Thread.new do
    opts = YAML.load_file(RAILS_ROOT+"/config/nanite_mapper.yml")[ENV["RAILS_ENV"] || "development"]
    opts.merge!(:offline_failsafe => true)

    if defined?(Thin)
      until EM.reactor_running?
        sleep 0.5
      end
      $stderr.puts "Starting Nanite mapper..."
      Nanite.start_mapper(opts)
    else
      EM.run do
        $stderr.puts "Starting Nanite mapper..."
        Nanite.start_mapper(opts)
      end
    end
    # TODO: add support for passenger :)
  end
end
