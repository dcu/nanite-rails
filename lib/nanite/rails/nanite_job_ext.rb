module NaniteJobExt
  def push_url(url, payload)
    begin
      Nanite.push(url, payload, self.options)
    rescue Errno::ENOENT
      self.logger.error "AMQP(rabbitmq) server is not running"
    end
  end

  def request_url(url, payload, &block)
    begin
      Nanite.request(url, payload, self.options, &block)
    rescue Errno::ENOENT
      self.logger.error "AMQP(rabbitmq) server is not running"
    end
  end
end
