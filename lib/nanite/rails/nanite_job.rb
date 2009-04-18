class NaniteJob
  include NaniteJobMixin
  extend  NaniteJobExt

  class << self
    attr_accessor :worker
  end
  self.worker = "jobs"

  def self.push!(klass, method, *args)
    url = "/#{self.worker}/run"
    push_url(url, [klass.to_s, method.to_s, args])
  end

  def self.request!(klass, method, *args, &block)
    url = "/#{self.worker}/run"
    request_url(url, [klass.to_s, method.to_s, args], &block)
  end
end
