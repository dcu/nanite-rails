APP_ROOT = File.expand_path(File.dirname(__FILE__)+"/../../")

$: << APP_ROOT

ENV["RAILS_ENV"] ||= "development"
ENV["NO_NM"] = "1"
require APP_ROOT + "/config/environment"

::NaniteJob.logger = Logger.new(RAILS_ROOT+"/log/nanite.log")

AMQP.logging = true if ENV["DEBUG_WORKER"]
register Worker.new, "jobs"

