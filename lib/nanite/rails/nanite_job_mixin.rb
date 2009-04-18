module NaniteJobMixin
  def self.included(klass)
    class << klass
      attr_accessor :options
    end
    klass.options = {:selector => :least_loaded, :timeout => 7}
  end
end
