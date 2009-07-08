
namespace :nanite do
  desc "Configure rabbitmq"
  task :rabbitmq => :environment do
    vhost = nil
    users = {}
    Dir.glob(RAILS_ROOT+"/config/nanite/*.yml") do |config_file|
      opts = YAML.load_file(config_file)[ENV["RAILS_ENV"] || "development"]

      next if users.has_key?(opts[:user])
      users[opts[:user]] = true

      if vhost.nil?
        vhost = opts[:vhost]
        puts `rabbitmqctl add_vhost #{vhost}`
      end

      agent = opts[:user]
      puts `rabbitmqctl delete_user #{agent}`
      puts `rabbitmqctl add_user #{agent} #{opts[:pass]}`
      puts `rabbitmqctl map_user_vhost #{agent} #{vhost}`
    end
  end
end
