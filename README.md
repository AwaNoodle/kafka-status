# kafka-status

A simple, opinionated ruby script for checking the health of a [Kafka](https://kafka.apache.org/) cluster.

## How it works

1. The script reads kafka's `server.properties` file to determine the zookeeper hosts kafka is using
2. The script connects to zookeeper and reads the info of all the brokers in the cluster from `/brokers/ids`
3. The script then uses `kafka-topics.sh` to get a list of topics
4. It uses `--describe` on each topic to get the details of each topic
5. It prints out the list of brokers and their details, such as ID, IP address, hostname
6. It prints out a list of topics, and for each topic it lists out the replication factor and partition count

## Usage

### Setup the Script

Clone this repository and then ensure the required Gems are installed. You will need Bundler installed (try ``gem install bundler``) and possibly the Ruby Development package (like **ruby-devel** on CentOS) and build tools so that packages can be built if needs be.

```
> cd location/of/the/repository
> bundle install
```

Set the script to be executable:

```
> chmod +x kafka_status.rb
```

### Run the Script

The script has a couple of optional parameters:

- ```--kafka_path```: The location of the Kafka install folder. Defaults to ```/opt/kafka```
- ```--verbose```: Set to enable verbose output
- ```--json```: Set to enable json output of the results

```
> ./kafka_status
Kafka Cluster Status: bburton
  The members of this cluster are:
    Broker: lookout-kafka-bburton-1
      Broker ID: 169869504
      Broker IP: 10.1.1.11
    Broker: lookout-kafka-bburton-2
      Broker ID: 169869810
      Broker IP: 10.1.1.12
    Broker: lookout-kafka-bburton-0
      Broker ID: 169869792
      Broker IP: 10.1.1.10

  This cluster has the following topics:
    Topic: bburton.test3
      Replication Factor: 3
      Partition Count: 8
    Topic: bburton.test2
      Replication Factor: 1
      Partition Count: 1
    Topic: bburton.test1
      Replication Factor: 1
      Partition Count: 1
```
