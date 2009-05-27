$:.unshift *Dir.glob(File.dirname(__FILE__)+"/../../../vendor/plugins/nanite-rails*/lib/")
require 'nanite/rails'

module NaniteAgent

class <%= agent_options[:class_name] %>
  include Nanite::Actor

  expose :ping
  def ping(payload)
    "PONG #{payload.inspect}"
  end

  <%- if !agent_options[:actions].empty? -%>
  expose <%= agent_options[:actions].map{|a| ":#{a}"}.join(", ") %>
  <%- agent_options[:actions].each do |action| -%>

  def <%= action %>(payload)
    "FIND ME IN #{__FILE__}:#{__LINE__}"
  end
  <%- end -%>
  <%- end -%>

end

end
