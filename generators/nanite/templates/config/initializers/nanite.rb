require 'nanite/rails'

def load_mapper_opts
  YAML::load(ERB.new(IO.read(RAILS_ROOT+"/config/nanite/mapper.yml")).result)[ENV["RAILS_ENV"] || "development"]
end

def start_mapper_on_passenger
  logger = RAILS_DEFAULT_LOGGER

	opts = load_mapper_opts
  opts.merge!(:offline_failsafe => true)

  th = Thread.current
  Thread.new do
    logger.info "Starting Nanite mapper on Passenger..."
    EM.run do
      begin
        Nanite.start_mapper(opts)
      rescue => e
        logger.error e.to_s
        logger.error e.backtrace.join("\n  ")
      ensure
        th.wakeup
      end
    end
  end
  Thread.stop
end

if ENV["NO_NM"].nil? && RAILS_ENV != "test"
  if defined?(PhusionPassenger)
    PhusionPassenger.on_event(:starting_worker_process) do |forked|
      if forked
        start_mapper_on_passenger
      else
        if !EM.reactor_running?
          start_mapper_on_passenger
        end
      end
    end
  else
    Thread.new do
      opts = load_mapper_opts
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
    end
  end
end
