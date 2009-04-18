module NaniteJobExt
  def push_url(url, payload = nil)
    begin
      Nanite.push(url, payload, self.options)
    rescue Errno::ENOENT
      self.logger.error "AMQP(rabbitmq) server is not running"
    end
  end

  def request_url(url, payload = nil, &block)
    begin
      Nanite.request(url, payload, self.options, &block)
    rescue Errno::ENOENT
      self.logger.error "AMQP(rabbitmq) server is not running"
    end
  end
end
