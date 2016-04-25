#!/usr/bin/env ruby
# kafka_status.rb

# Brandon Burton, 2014

require 'rubygems'
require 'trollop'
require_relative 'lib/status'

cmd_opts = Trollop::options do
              banner "Kafka Status Utility"
              opt :kafka_path, "Path to Kafka", :required => false, :type => :string, :default => "/opt/kafka"
              opt :verbose, "Verbose output?", :required => false
              opt :json, "JSON output", :required => false
            end


# Where kafka lives
kafka_dir = cmd_opts[:kafka_path]
$kafka_bin = "#{kafka_dir}/bin/"
$kafka_config = "#{kafka_dir}/config/server.properties"

puts "Looking for Kafka config at #{$kafka_config}"

if __FILE__ == $0
  $verbose = cmd_opts[:verbose]
  $json_output = cmd_opts[:json]
  kafka_status()
end
