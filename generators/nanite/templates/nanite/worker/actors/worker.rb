$:.unshift *Dir.glob(File.dirname(__FILE__)+"/../../../vendor/plugins/nanite-rails*/lib/")
require 'nanite/rails'

class Worker
  include Nanite::Actor
  include WorkerMixin

  expose :run, :test

  def test(*args)
    "You're testing nanite-rails. ARGS = #{args.join(", ")}"
  end
end
