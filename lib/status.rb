# status.rb

require_relative 'zookeeper'
require_relative 'broker'

def kafka_status()

  kafka_cluster_name = get_kafka_cluster_name

  zk, zookeeper_cluster_hosts = connect_to_zookeeper()
  broker_ids = get_broker_ids(zk)
  kafka_brokers = get_broker_details(broker_ids, zk)
  kafka_topics = get_topic_details(kafka_brokers, zookeeper_cluster_hosts)


  outputter = $json_output ? :json_outputter : :text_outputter
  send(outputter, kafka_cluster_name, kafka_brokers, kafka_topics)
end

def json_outputter(kafka_cluster_name, kafka_brokers, kafka_topics)
  kafka_info = Hash["name" => kafka_cluster_name, "brokers" => kafka_brokers, "topics" => kafka_topics]

  puts kafka_info.to_json
end

def text_outputter(kafka_cluster_name, kafka_brokers, kafka_topics)
  # show status
  puts "Kafka Cluster Status: #{kafka_cluster_name}"
  puts "\s\sThe members of this cluster are:"
  kafka_brokers.each do | broker, broker_data |
    puts "\s\s\s\sBroker: #{broker_data['hostname']}"
    puts "\s\s\s\s\s\sBroker ID: #{broker_data['broker_id']}"
    puts "\s\s\s\s\s\sBroker IP: #{broker_data['ip_address']}"
  end

  puts "\n\s\sThis cluster has the following topics:"
  kafka_topics.each do | topic, topic_data |

    puts "\s\s\s\sTopic: #{topic}"
    puts "\s\s\s\s\s\sReplication Factor: #{topic_data['config']['ReplicationFactor']}"
    puts "\s\s\s\s\s\sPartition Count: #{topic_data['config']['PartitionCount']}"
    #TODO: add more info about which broker is the leader and which brokers are ISRs
    # partition counts in kafka are zero based
    topic_data["config"]["PartitionCount"].to_i.times do |i|
      if topic_data["partitions"]["partition_#{i}"]["NumberOfReplicas"].to_i != topic_data["config"]["ReplicationFactor"].to_i
      puts "partition_#{i} does not have a sufficient number of replicas"
      #TODO: add more logic here to show which brokers have a replica
      end
    end
  end
end
