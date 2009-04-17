module NaniteJobMixin
  def self.included(klass)
    class << klass
      attr_accessor :options
    end
    klass.options = {:selector => :least_loaded, :timeout => 7}
  end

  def perform!
    self.class.logger.info "Performing job: #{self.to_s}"
    transaction do
      k = self.target_class.to_s.constantize
      if ret = k.send(self.method, *self.arguments)
        self.class.logger.info "Result was: #{ret.inspect}"
        self.performed = true
        self.failed = false
        self.save!
      else
        self.class.logger.error "Error while executing #{self.to_s} -> #{ret}"
      end
      ret
    end
  end

  def request!
    url = '/jobs/perform'

    begin
      save! if new_record?
      Nanite.push(url, self.id, self.class.options)
    rescue Errno::ENOENT
      self.class.logger.error "RabbitMQ server is not running"
    end
  end

  def to_s
    args = self.arguments || []
    "#{self.class}<#{self.target_class.to_s}.#{self.method.to_s}(#{args.join(", ")})>"
  end
end
