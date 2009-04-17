
namespace :nanite do
  desc "Configure rabbitmq"
  task :setup => :environment do
    # SETUP MAPPER
    mapper_opts = YAML.load_file(RAILS_ROOT+"/config/nanite_mapper.yml")[ENV["RAILS_ENV"] || "development"]
    vhost = mapper_opts[:vhost]
    puts `rabbitmqctl add_vhost #{vhost}`

    mapper = mapper_opts[:user]
    puts `rabbitmqctl delete_user #{mapper}`
    puts `rabbitmqctl add_user #{mapper} #{mapper_opts[:pass]}`
    puts `rabbitmqctl map_user_vhost #{mapper} #{vhost}`

    # SETUP WORKER
    worker_opts = YAML.load_file(RAILS_ROOT+"/config/nanite_worker.yml")[ENV["RAILS_ENV"] || "development"]
    agent = worker_opts[:user]
    puts `rabbitmqctl delete_user #{agent}`
    puts `rabbitmqctl add_user #{agent} #{worker_opts[:pass]}`
    puts `rabbitmqctl map_user_vhost #{agent} #{vhost}`
  end
end
