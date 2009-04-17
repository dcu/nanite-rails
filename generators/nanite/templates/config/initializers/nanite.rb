require 'nanite'
require 'nanite/rails'

unless ENV["NO_NM"]
  Thread.new do
    opts = YAML.load_file(RAILS_ROOT+"/config/nanite_mapper.yml")[ENV["RAILS_ENV"] || "development"]
    opts.merge!(:offline_failsafe => true)

    is_thin = false
    if defined?(Thin)
      10.times do
        if EM.reactor_running?
          is_thin = true
          break
        end
        sleep 0.5
      end
    end

    if is_thin
      $stderr.puts "Starting Nanite mapper on Thin..."
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
