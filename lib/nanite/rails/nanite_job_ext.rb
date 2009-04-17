module NaniteJobExt
  # NaniteJob.enqueue(Calc, :sum, 1, 2, 3).request!
  def enqueue(klass, method, *arguments)
    if klass.kind_of?(Class)
      unless klass.respond_to?(method)
        raise "#{klass} does not respond to #{method.inspect}"
      end
    end

    job = self.new(:target_class => klass.to_s, :method => method.to_s, :arguments => arguments)
    yield job if block_given?
    job.save!
    job
  end

  def perform_pending_jobs!
    pending_jobs.each do |job|
      begin
        job.perform!
      rescue => e
        bt = e.to_s+"\n"+e.backtrace.join("\n  ")
        self.class.logger.error "Error while executing: #{job.to_s}\n"+bt
        job.performed = true
        job.failed = true
        job.save
      end
    end
  end

  def push!(klass, method, *args)
    url = '/jobs/run'
    begin
      Nanite.push(url, [klass.to_s, method.to_s, args], self.options)
    rescue Errno::ENOENT
      self.logger.error "AMQP(rabbitmq) server is not running"
    end
  end

  def request!(klass, method, *args, &block)
    url = '/jobs/run'

    begin
      Nanite.request(url, [klass.to_s, method.to_s, args], self.options, &block)
    rescue Errno::ENOENT
      self.logger.error "AMQP(rabbitmq) server is not running"
    end
  end
end
