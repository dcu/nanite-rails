module WorkerMixin
  def run(args)
    klass, method, arguments = args
    ret = {:state => :ok}
    begin
      klass = klass.constantize
      ret[:result] = klass.__send__(method, *arguments)
    rescue => e
      ret[:state] = :error
      ret[:error] = e.to_s
      ret[:backtrace] = e.backtrace
      Nanite::Log.logger.error e.to_s + "\n" + e.backtrace.join("\n  ")
    end

    $stderr.puts ret.inspect
    ret
  end
end
