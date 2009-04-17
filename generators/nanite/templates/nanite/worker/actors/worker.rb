class Worker
  include Nanite::Actor
  expose :perform, :run, :test

  def perform(job_id)
    job = ::NaniteJob.find_by_id(job_id)
    ret = {}

    ret[:state] = :error
    if job
      begin
        ret[:result] = job.perform!
      rescue => e
        ret[:error] = e.to_s
        ret[:backtrace] = e.backtrace
        ::NaniteJob.logger.error e.to_s + "\n" + e.backtrace.join("\n  ")
        job.failed = true
        job.performed = true
        job.save
      end

      if job.performed
        ret[:state] = :ok
      end
    end

    $stderr.puts ret.inspect

    ret
  end

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
      ::NaniteJob.logger.error e.to_s + "\n" + e.backtrace.join("\n  ")
    end

    $stderr.puts ret.inspect
    ret
  end

  def test(*args)
    "You're testing nanite-rails. ARGS = #{args.join(", ")}"
  end
end

