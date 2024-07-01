provider "aws" {
  region = "us-west-2"  # Change to your desired region
}

resource "aws_vpc" "asia_stream" {
  cidr_block = var.vpc-cidr
}

resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.asia_stream.id
  cidr_block = var.subnet-cidr-1
  availability_zone = "us-west-2a"  # Change to your desired AZ
}

resource "aws_subnet" "subnet2" {
  vpc_id     = aws_vpc.asia_stream.id
  cidr_block = var.subnet-cidr-2
  availability_zone = "us-west-2b"  # Change to your desired AZ
}

resource "aws_subnet" "subnet3" {
  vpc_id     = aws_vpc.asia_stream.id
  cidr_block = var.subnet-cidr-3
  availability_zone = "us-west-2c"  # Change to your desired AZ
}

resource "aws_security_group" "kafka_sg" {
  vpc_id = aws_vpc.asia_stream.id

  ingress {
    from_port   = 9092
    to_port     = 9092
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # open inbound rule, can be confied.
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_msk_cluster" "kafka_cluster" {
  cluster_name           = var.kafka-cluster-name
  kafka_version          = "2.8.1"
  number_of_broker_nodes = 3

  broker_node_group_info {
    instance_type = "kafka.m5.large"
    client_subnets = [
      aws_subnet.subnet1.id,
      aws_subnet.subnet2.id,
      aws_subnet.subnet3.id,
    ]
    storage_info {
      ebs_storage_info {
        provisioned_throughput {
          enabled           = true
          volume_throughput = 250
        }
        volume_size = 100
      }
    }
  security_groups = [aws_security_group.kafka_sg.id]
 }
 encryption_info {
    encryption_in_transit {
      client_broker = "TLS"
      in_cluster    = true
    }
 }
 
 configuration_info {
    arn      = aws_msk_configuration.kafka_configuration.arn
    revision = aws_msk_configuration.kafka_configuration.latest_revision
  }
}


resource "aws_msk_configuration" "kafka_configuration" {
  name = "example-kafka-configuration"
  kafka_versions = ["2.8.1"]
  server_properties = <<PROPERTIES
auto.create.topics.enable = true
delete.topic.enable = true
PROPERTIES
}

