require 'rbconfig'
require 'fileutils'
require 'active_resource'

class AgentGenerator < Rails::Generator::Base
  DEFAULT_SHEBANG = File.join(Config::CONFIG['bindir'],
                              Config::CONFIG['ruby_install_name'])

  attr_accessor :agent_options
  def initialize(runtime_args, runtime_options = {})
    super

    @agent_options = {}
    klass, *actions = runtime_args

    if klass.blank?
      raise "Agent name was not given"
    end

    @agent_options[:actions] = actions
    @agent_options[:class_name] = klass.classify
    @agent_options[:agent_name] = klass.underscore
    @agent_options[:route] = agent_options[:agent_name].pluralize
    $stdout.sync = true
  end

  def manifest
    record do |m|
      # Config
      m.directory 'config/nanite'
      m.file      'config/nanite/agent.yml', "config/nanite/#{agent_options[:agent_name]}.yml"

      # Nanite
      m.directory "nanite/#{agent_options[:agent_name]}"
      m.template  'nanite/agent/config.yml', "nanite/#{agent_options[:agent_name]}/config.yml"
      m.template  'nanite/agent/init.rb', "nanite/#{agent_options[:agent_name]}/init.rb"

      m.directory "nanite/#{agent_options[:agent_name]}/actors"
      m.template  'nanite/agent/actors/agent.rb', "nanite/#{agent_options[:agent_name]}/actors/#{agent_options[:agent_name]}.rb"
    end
  end

  protected
  def banner
    "Usage: #{$0} agent <ClassName> [actions]"
  end
end
