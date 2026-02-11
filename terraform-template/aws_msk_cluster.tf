#==============================================================================
# AWS MSK (Managed Streaming for Apache Kafka) Cluster - Provisioned
#==============================================================================
# Amazon MSK is a fully managed service for Apache Kafka that makes it easy to
# build and run applications that use Apache Kafka to process streaming data.
# This resource manages PROVISIONED clusters (for serverless, use aws_msk_serverless_cluster).
#
# Key Features:
# - Fully managed Apache Kafka infrastructure
# - Automatic patching and updates
# - Built-in security with encryption and authentication
# - Integration with AWS services (CloudWatch, S3, Kinesis Firehose)
# - Multi-AZ deployment for high availability
# - Support for Apache Kafka versions 2.x and 3.x
#
# Use Cases:
# - Real-time data streaming and processing
# - Log aggregation and analytics
# - Event sourcing architectures
# - IoT data ingestion
# - Change data capture (CDC) from databases
#
# Important Notes:
# - This resource manages provisioned clusters only
# - Cluster creation takes approximately 15-30 minutes
# - Number of broker nodes must be a multiple of number of AZs (client_subnets)
# - For production workloads, use at least 3 broker nodes across 3 AZs
# - Bootstrap broker endpoints may not be stable across applies
#
# Pricing Considerations:
# - Charged based on broker instance hours, storage, and data transfer
# - Storage costs include both EBS volume size and provisioned throughput (if enabled)
# - Data transfer charges apply for cross-AZ and internet data transfer
#
# AWS Provider Version: 6.28.0
# Terraform AWS Provider Documentation:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_cluster
#
# AWS Service Documentation:
# https://docs.aws.amazon.com/msk/latest/developerguide/what-is-msk.html
#==============================================================================

resource "aws_msk_cluster" "example" {
  #----------------------------------------------------------------------------
  # REQUIRED ARGUMENTS
  #----------------------------------------------------------------------------

  # cluster_name - (Required) Name of the MSK cluster
  # - Must be unique within your AWS account in the region
  # - 1-64 characters: letters, numbers, hyphens
  # - Cannot start or end with a hyphen
  # - Used for identification in console and APIs
  # Example: "production-kafka-cluster", "analytics-streaming"
  cluster_name = "example-msk-cluster"

  # kafka_version - (Required) Desired Kafka software version
  # - Format: "X.Y.Z" (e.g., "3.8.0") or "X.Y.x" for latest patch (e.g., "3.8.x")
  # - Using "x" for patch version ensures automatic updates to latest patch
  # - Supported versions vary by region and time (check AWS documentation)
  # - Common versions: 2.8.x, 3.4.x, 3.5.x, 3.6.x, 3.7.x, 3.8.x
  # - Version upgrades are supported but downgrades are not
  # - Major version upgrades should be tested in non-production first
  # Note: Kafka 3.x offers better performance and features than 2.x
  kafka_version = "3.8.x"

  # number_of_broker_nodes - (Required) Total number of broker nodes
  # - Must be a multiple of the number of availability zones (client_subnets)
  # - Minimum: 2 for Standard brokers (but 3 recommended for production)
  # - Minimum: 3 for Express brokers (must span 3 AZs)
  # - Maximum: Varies by region (typically up to 30 nodes)
  # - For high availability: Use 3+ nodes across 3 AZs
  # - Can be increased after cluster creation but not decreased
  # - More brokers = higher throughput and fault tolerance
  # Example:
  #   - 2 subnets (AZs) → must be 2, 4, 6, 8, etc.
  #   - 3 subnets (AZs) → must be 3, 6, 9, 12, etc.
  number_of_broker_nodes = 3

  #----------------------------------------------------------------------------
  # broker_node_group_info - (Required) Configuration for broker nodes
  #----------------------------------------------------------------------------
  # Defines the compute, networking, and storage configuration for Kafka brokers
  broker_node_group_info {
    # instance_type - (Required) Instance type for Kafka brokers
    # - Format: kafka.{instance_family}.{size}
    # - Standard brokers: kafka.m5.large, kafka.m5.xlarge, kafka.m5.2xlarge, etc.
    # - Express brokers: kafka.m7i.large, kafka.m7i.xlarge, etc.
    # - Larger instances = more CPU, memory, network bandwidth
    # - For provisioned throughput: Must use kafka.m5.4xlarge or larger
    # Common instance types:
    #   - kafka.m5.large: 2 vCPU, 8 GiB RAM (dev/test)
    #   - kafka.m5.xlarge: 4 vCPU, 16 GiB RAM (small production)
    #   - kafka.m5.2xlarge: 8 vCPU, 32 GiB RAM (medium production)
    #   - kafka.m5.4xlarge: 16 vCPU, 64 GiB RAM (large production with high throughput)
    # Pricing: https://aws.amazon.com/msk/pricing/
    instance_type = "kafka.m5.large"

    # client_subnets - (Required) List of subnet IDs for broker nodes
    # - Must be in the same VPC
    # - Must be in different Availability Zones
    # - Number of subnets determines the AZ distribution
    # - For Standard brokers: 2 or 3 subnets (2-3 AZs)
    # - For Express brokers: Exactly 3 subnets (3 AZs) required
    # - Ensure subnets have sufficient IP addresses for broker nodes
    # - Brokers are distributed evenly across the provided subnets
    # - Each subnet should have /24 or larger CIDR block
    # Example: If 3 subnets and 6 broker nodes → 2 brokers per subnet/AZ
    client_subnets = [
      "subnet-12345678", # us-east-1a
      "subnet-23456789", # us-east-1b
      "subnet-34567890", # us-east-1c
    ]

    # security_groups - (Required) List of security group IDs
    # - Applied to broker Elastic Network Interfaces (ENIs)
    # - Controls inbound/outbound traffic to/from brokers
    # - Must allow traffic between brokers for cluster communication
    # - Must allow client connections on Kafka ports (9092, 9094, 9096, 9098)
    # Required inbound rules:
    #   - From clients: TCP 9092 (PLAINTEXT), 9094 (TLS), 9096 (SASL_SCRAM), 9098 (SASL_IAM)
    #   - From brokers: TCP 9092-9098 (inter-broker communication)
    #   - From brokers: TCP 2181 (ZooKeeper for Kafka < 3.x)
    # Required outbound rules:
    #   - To brokers: TCP 9092-9098
    #   - To internet: TCP 443 (for AWS service API calls if needed)
    security_groups = ["sg-12345678"]

    # az_distribution - (Optional) Distribution of broker nodes across AZs
    # - Valid values: "DEFAULT" (currently the only option)
    # - Default: "DEFAULT"
    # - Controls how broker nodes are distributed across availability zones
    # - "DEFAULT": Even distribution across all specified AZs
    # - Future AWS updates may add additional distribution strategies
    az_distribution = "DEFAULT"

    #--------------------------------------------------------------------------
    # storage_info - (Optional) Storage volume configuration for broker nodes
    #--------------------------------------------------------------------------
    storage_info {
      #------------------------------------------------------------------------
      # ebs_storage_info - (Optional) EBS volume configuration
      #------------------------------------------------------------------------
      ebs_storage_info {
        # volume_size - (Optional) Size of EBS volume per broker in GiB
        # - Minimum: 1 GiB
        # - Maximum: 16,384 GiB (16 TiB)
        # - Default: 1000 GiB if not specified
        # - Can be increased after cluster creation but not decreased
        # - Volume size affects storage capacity and baseline I/O performance
        # - For production: Start with expected data retention needs × replication factor
        # - Consider compression ratios (Kafka typically achieves 3-10x compression)
        # - Monitor storage utilization and scale before reaching 80% capacity
        # Sizing guidance:
        #   - Development: 100-500 GiB
        #   - Small production: 500-2000 GiB
        #   - Medium production: 2000-5000 GiB
        #   - Large production: 5000+ GiB
        volume_size = 1000

        #----------------------------------------------------------------------
        # provisioned_throughput - (Optional) Provisioned throughput configuration
        #----------------------------------------------------------------------
        # Enables Amazon EBS gp3 volumes with custom throughput (MiB/s)
        # Required instance type: kafka.m5.4xlarge or larger
        provisioned_throughput {
          # enabled - (Optional) Enable/disable provisioned throughput
          # - Default: false
          # - Set to true to use EBS gp3 volumes with custom throughput
          # - When disabled, uses standard gp2 volumes
          # - gp3 volumes offer better price/performance for high-throughput workloads
          enabled = true

          # volume_throughput - (Optional) Throughput in MiB per second
          # - Minimum: 250 MiB/s
          # - Maximum: Varies by broker instance type
          #   - kafka.m5.4xlarge: 250 MiB/s
          #   - kafka.m5.8xlarge: 500 MiB/s
          #   - kafka.m5.12xlarge: 750 MiB/s
          #   - kafka.m5.16xlarge: 1000 MiB/s
          #   - kafka.m5.24xlarge: 1000 MiB/s
          # - Higher throughput = better performance for high-volume workloads
          # - Consider total cluster throughput = volume_throughput × number_of_broker_nodes
          # - Only applicable when enabled = true
          # Documentation: https://docs.aws.amazon.com/msk/latest/developerguide/msk-provision-throughput.html
          volume_throughput = 250
        }
      }
    }

    #--------------------------------------------------------------------------
    # connectivity_info - (Optional) Network connectivity configuration
    #--------------------------------------------------------------------------
    # Controls public and VPC connectivity options for the cluster
    # Note: Cannot enable public access during cluster creation for security reasons
    # Public access can only be enabled on existing clusters via update
    connectivity_info {
      #------------------------------------------------------------------------
      # public_access - (Optional) Public internet access configuration
      #------------------------------------------------------------------------
      public_access {
        # type - (Optional) Public access type
        # - Valid values: "DISABLED", "SERVICE_PROVIDED_EIPS"
        # - Default: "DISABLED"
        # - "DISABLED": No public internet access (VPC-only access)
        # - "SERVICE_PROVIDED_EIPS": AWS assigns public Elastic IPs to brokers
        # Security considerations:
        #   - Public access exposes brokers to internet
        #   - Use with authentication (SASL/IAM or SASL/SCRAM) and TLS encryption
        #   - Implement IP allowlisting via security groups
        #   - Monitor unauthorized access attempts
        # When enabled, provides bootstrap_brokers_public_* attributes
        # Documentation: https://docs.aws.amazon.com/msk/latest/developerguide/public-access.html
        type = "DISABLED"
      }

      #------------------------------------------------------------------------
      # vpc_connectivity - (Optional) VPC connectivity configuration
      #------------------------------------------------------------------------
      # Enables multi-VPC private connectivity via AWS PrivateLink
      vpc_connectivity {
        # client_authentication - (Optional) Authentication for VPC connectivity
        client_authentication {
          # sasl - (Optional) SASL authentication configuration
          sasl {
            # iam - (Optional) Enable SASL/IAM authentication
            # - Default: false
            # - Uses AWS IAM for authentication and authorization
            # - Clients use AWS credentials (access keys, IAM roles)
            # - No password management required
            # - Fine-grained access control via IAM policies
            # - Recommended for AWS-native applications
            iam = true

            # scram - (Optional) Enable SASL/SCRAM authentication
            # - Default: false
            # - Uses username/password stored in AWS Secrets Manager
            # - Credentials are encrypted at rest
            # - Requires creating secrets and associating with cluster
            # - Suitable for applications requiring username/password auth
            scram = false
          }

          # tls - (Optional) Enable TLS authentication for VPC connectivity
          # - Default: false
          # - Uses TLS client certificates for mutual TLS (mTLS) authentication
          # - Requires AWS Private CA for certificate management
          # - Provides certificate-based authentication
          # - Highest security level but more complex to manage
          tls = false
        }
      }
    }
  }

  #----------------------------------------------------------------------------
  # OPTIONAL ARGUMENTS - Authentication & Authorization
  #----------------------------------------------------------------------------

  #----------------------------------------------------------------------------
  # client_authentication - (Optional) Client authentication configuration
  #----------------------------------------------------------------------------
  # Controls how clients authenticate with the Kafka cluster
  # Multiple authentication methods can be enabled simultaneously
  client_authentication {
    #--------------------------------------------------------------------------
    # sasl - (Optional) SASL (Simple Authentication and Security Layer) config
    #--------------------------------------------------------------------------
    sasl {
      # iam - (Optional) Enable SASL/IAM authentication
      # - Default: false
      # - Clients authenticate using AWS IAM credentials
      # - Uses AWS Signature Version 4 signing process
      # - No separate password management needed
      # - Integrates with AWS IAM policies for authorization
      # - Requires kafka-python or similar library with IAM support
      # - Bootstrap brokers available via bootstrap_brokers_sasl_iam attribute
      # - Uses port 9098 for IAM authentication
      # IAM policy example:
      #   {
      #     "Version": "2012-10-17",
      #     "Statement": [{
      #       "Effect": "Allow",
      #       "Action": ["kafka-cluster:*"],
      #       "Resource": "arn:aws:kafka:region:account-id:cluster/cluster-name/*"
      #     }]
      #   }
      iam = true

      # scram - (Optional) Enable SASL/SCRAM authentication
      # - Default: false
      # - Uses username/password authentication
      # - Credentials stored in AWS Secrets Manager
      # - Supports SCRAM-SHA-512 mechanism
      # - Requires creating and associating secrets via aws_msk_scram_secret_association
      # - Bootstrap brokers available via bootstrap_brokers_sasl_scram attribute
      # - Uses port 9096 for SCRAM authentication
      # Secret format in Secrets Manager:
      #   {
      #     "username": "alice",
      #     "password": "alice-secret-password"
      #   }
      scram = false
    }

    #--------------------------------------------------------------------------
    # tls - (Optional) TLS/mTLS authentication configuration
    #--------------------------------------------------------------------------
    tls {
      # certificate_authority_arns - (Optional) List of ACM PCA ARNs
      # - Private Certificate Authority (PCA) ARNs from AWS Certificate Manager
      # - Used for mutual TLS (mTLS) authentication
      # - Clients must present certificates signed by specified CAs
      # - Provides strong certificate-based authentication
      # - More complex setup compared to IAM or SCRAM
      # - Bootstrap brokers available via bootstrap_brokers_tls attribute
      # - Uses port 9094 for TLS authentication
      # Requirements:
      #   - Create AWS Private CA first
      #   - Issue client certificates from the CA
      #   - Configure clients with certificates and private keys
      # Example: ["arn:aws:acm-pca:us-east-1:123456789012:certificate-authority/12345678-1234-1234-1234-123456789012"]
      certificate_authority_arns = []
    }

    # unauthenticated - (Optional) Enable unauthenticated access
    # - Default: false (implicitly disabled if not specified)
    # - Allows clients to connect without authentication
    # - NOT RECOMMENDED for production environments
    # - Provides bootstrap_brokers attribute (plaintext port 9092 if PLAINTEXT enabled)
    # - Only use for development/testing or when network security is sufficient
    # - If enabled with TLS_PLAINTEXT encryption, exposes plaintext port
    # Security warning: Only enable if cluster is in isolated VPC with strict network controls
    # unauthenticated = false
  }

  #----------------------------------------------------------------------------
  # OPTIONAL ARGUMENTS - Encryption
  #----------------------------------------------------------------------------

  #----------------------------------------------------------------------------
  # encryption_info - (Optional) Encryption configuration
  #----------------------------------------------------------------------------
  # Controls encryption at rest and in transit
  encryption_info {
    # encryption_at_rest_kms_key_arn - (Optional) KMS key for encryption at rest
    # - ARN of AWS KMS customer managed key (CMK) for encrypting broker data volumes
    # - If not specified, uses AWS managed key (aws/msk)
    # - Encrypts data stored on broker EBS volumes
    # - Cannot be changed after cluster creation
    # - KMS key must be in the same region as the cluster
    # - Key policy must grant MSK service permissions:
    #   - kms:CreateGrant
    #   - kms:DescribeKey
    #   - kms:Decrypt
    #   - kms:GenerateDataKey
    # - Using customer managed keys provides more control and audit capabilities
    # - Consider KMS costs for frequent encryption/decryption operations
    # Example: "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
    encryption_at_rest_kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

    #--------------------------------------------------------------------------
    # encryption_in_transit - (Optional) In-transit encryption configuration
    #--------------------------------------------------------------------------
    encryption_in_transit {
      # client_broker - (Optional) Encryption between clients and brokers
      # - Valid values: "TLS", "TLS_PLAINTEXT", "PLAINTEXT"
      # - Default: "TLS"
      # - "TLS": Only encrypted TLS connections allowed (RECOMMENDED)
      # - "TLS_PLAINTEXT": Both TLS and plaintext connections allowed
      # - "PLAINTEXT": Only unencrypted connections (NOT RECOMMENDED)
      # Port mapping:
      #   - TLS: port 9094 (or 9096 for SASL_SCRAM, 9098 for SASL_IAM)
      #   - PLAINTEXT: port 9092
      # Security considerations:
      #   - Use "TLS" for production to ensure all data is encrypted in transit
      #   - "TLS_PLAINTEXT" useful for gradual migration from plaintext to TLS
      #   - "PLAINTEXT" should only be used in isolated, trusted networks
      client_broker = "TLS"

      # in_cluster - (Optional) Encryption between brokers
      # - Default: true
      # - Controls encryption for inter-broker communication
      # - When true: Broker-to-broker traffic is encrypted
      # - When false: Broker-to-broker traffic is plaintext
      # - STRONGLY RECOMMENDED: Leave as true for security
      # - Minimal performance impact in most cases
      # - Cannot be changed if using mTLS authentication (must be true)
      in_cluster = true
    }
  }

  #----------------------------------------------------------------------------
  # OPTIONAL ARGUMENTS - Monitoring & Logging
  #----------------------------------------------------------------------------

  # enhanced_monitoring - (Optional) CloudWatch monitoring level
  # - Valid values: "DEFAULT", "PER_BROKER", "PER_TOPIC_PER_BROKER", "PER_TOPIC_PER_PARTITION"
  # - Default: "DEFAULT" (cluster-level metrics)
  # - "DEFAULT": Basic cluster-level metrics
  # - "PER_BROKER": Metrics for each broker node
  # - "PER_TOPIC_PER_BROKER": Metrics per topic per broker (more detailed)
  # - "PER_TOPIC_PER_PARTITION": Most detailed metrics per partition per broker
  # - Higher monitoring levels = more detailed metrics but higher CloudWatch costs
  # - Metrics include: CPU, memory, disk, network, JVM metrics
  # - Useful for troubleshooting performance issues
  # Recommendation:
  #   - Production: PER_BROKER or PER_TOPIC_PER_BROKER
  #   - Development: DEFAULT
  # Documentation: https://docs.aws.amazon.com/msk/latest/developerguide/monitoring.html
  enhanced_monitoring = "PER_BROKER"

  #----------------------------------------------------------------------------
  # open_monitoring - (Optional) Prometheus monitoring configuration
  #----------------------------------------------------------------------------
  # Enables Prometheus exporters for monitoring with open-source tools
  open_monitoring {
    prometheus {
      # jmx_exporter - (Optional) JMX Exporter configuration
      # Exposes JVM and Kafka metrics in Prometheus format
      jmx_exporter {
        # enabled_in_broker - (Required) Enable/disable JMX Exporter
        # - When true: Exposes JMX metrics on port 11001
        # - Metrics include: JVM memory, garbage collection, Kafka broker metrics
        # - Accessible from within VPC (configure security groups to allow port 11001)
        # - Useful for monitoring with Prometheus, Grafana, or other tools
        # - No additional cost from AWS (but consider data transfer costs)
        # - Metrics endpoint: http://<broker-node>:11001/metrics
        enabled_in_broker = true
      }

      # node_exporter - (Optional) Node Exporter configuration
      # Exposes system-level metrics (CPU, memory, disk, network)
      node_exporter {
        # enabled_in_broker - (Required) Enable/disable Node Exporter
        # - When true: Exposes node metrics on port 11002
        # - Metrics include: CPU usage, memory, disk I/O, network I/O
        # - Accessible from within VPC (configure security groups to allow port 11002)
        # - Provides OS-level visibility complementing JMX metrics
        # - Metrics endpoint: http://<broker-node>:11002/metrics
        enabled_in_broker = true
      }
    }
  }

  #----------------------------------------------------------------------------
  # logging_info - (Optional) Broker log delivery configuration
  #----------------------------------------------------------------------------
  # Streams broker logs to CloudWatch Logs, S3, and/or Kinesis Firehose
  # Multiple destinations can be enabled simultaneously
  logging_info {
    broker_logs {
      #------------------------------------------------------------------------
      # cloudwatch_logs - (Optional) CloudWatch Logs configuration
      #------------------------------------------------------------------------
      cloudwatch_logs {
        # enabled - (Required) Enable/disable CloudWatch Logs delivery
        # - When true: Broker logs streamed to CloudWatch Logs
        # - Logs include: Kafka server logs (server.log), controller logs (controller.log)
        # - Useful for real-time monitoring and alerting
        # - CloudWatch Logs costs apply (ingestion and storage)
        # - Logs can be analyzed with CloudWatch Logs Insights
        enabled = true

        # log_group - (Optional) CloudWatch Logs group name
        # - Target log group must exist before enabling logging
        # - Format: /aws/msk/cluster-name or custom name
        # - Ensure log group has appropriate retention settings
        # - IAM service role automatically created by MSK for log delivery
        # - Each broker sends logs to separate log streams within the group
        # Example: "/aws/msk/production-kafka-cluster"
        log_group = "/aws/msk/example-msk-cluster"
      }

      #------------------------------------------------------------------------
      # firehose - (Optional) Kinesis Data Firehose configuration
      #------------------------------------------------------------------------
      firehose {
        # enabled - (Required) Enable/disable Firehose delivery
        # - When true: Broker logs streamed to Kinesis Data Firehose
        # - Useful for delivering logs to S3, Redshift, OpenSearch, or custom destinations
        # - Provides buffering and transformation capabilities
        # - Kinesis Firehose costs apply
        # - Delivery stream must exist before enabling
        enabled = true

        # delivery_stream - (Optional) Kinesis Firehose delivery stream name
        # - Target delivery stream must exist in the same region
        # - Delivery stream can send to S3, Redshift, OpenSearch, Splunk, HTTP endpoint
        # - IAM role for delivery stream must have necessary permissions
        # - Stream receives logs from all brokers
        # - Configure delivery stream buffering and compression as needed
        # Example: "msk-broker-logs-stream"
        delivery_stream = "msk-broker-logs-stream"
      }

      #------------------------------------------------------------------------
      # s3 - (Optional) S3 bucket configuration
      #------------------------------------------------------------------------
      s3 {
        # enabled - (Required) Enable/disable S3 delivery
        # - When true: Broker logs delivered directly to S3
        # - Useful for long-term archival and compliance
        # - Logs delivered in batches (typically every 5 minutes or 5 MB)
        # - S3 storage costs apply
        # - Consider lifecycle policies for cost optimization
        enabled = true

        # bucket - (Optional) S3 bucket name
        # - Target bucket must exist before enabling logging
        # - Bucket must be in the same region as the cluster
        # - Bucket policy must grant MSK service permissions to write objects
        # - IAM service role automatically created by MSK
        # Required bucket policy:
        #   {
        #     "Version": "2012-10-17",
        #     "Statement": [{
        #       "Sid": "AWSLogDeliveryWrite",
        #       "Effect": "Allow",
        #       "Principal": {"Service": "kafka.amazonaws.com"},
        #       "Action": "s3:PutObject",
        #       "Resource": "arn:aws:s3:::bucket-name/*"
        #     }]
        #   }
        bucket = "my-msk-logs-bucket"

        # prefix - (Optional) S3 object key prefix
        # - Prefix added to all log objects in S3
        # - Useful for organizing logs by cluster or environment
        # - Format: prefix/date/broker-id/
        # - Consider including cluster name for multi-cluster setups
        # - Do not include leading slash
        # Example: "msk-logs/production" results in s3://bucket/msk-logs/production/2024/01/15/...
        prefix = "logs/msk-"
      }
    }
  }

  #----------------------------------------------------------------------------
  # OPTIONAL ARGUMENTS - Configuration & Management
  #----------------------------------------------------------------------------

  #----------------------------------------------------------------------------
  # configuration_info - (Optional) Custom MSK configuration
  #----------------------------------------------------------------------------
  # Attach custom Kafka broker configuration to override defaults
  # configuration_info {
  #   # arn - (Required) ARN of the MSK Configuration
  #   # - Reference to aws_msk_configuration resource
  #   # - Defines custom Kafka broker properties (server.properties)
  #   # - Configuration must be compatible with the Kafka version
  #   # - Common properties: log.retention.hours, compression.type, num.io.threads
  #   # - Cannot change configuration ARN after cluster creation
  #   # - Can update to different revision of same configuration
  #   # Example: "arn:aws:kafka:us-east-1:123456789012:configuration/my-config/12345678-1234-1234-1234-123456789012-1"
  #   arn = aws_msk_configuration.example.arn
  #
  #   # revision - (Required) Configuration revision number
  #   # - Each configuration update creates a new revision
  #   # - Must specify exact revision to use
  #   # - Cluster updates when new revision is applied
  #   # - Use latest_revision attribute from aws_msk_configuration
  #   # Example: 1, 2, 3, etc.
  #   revision = aws_msk_configuration.example.latest_revision
  # }

  # storage_mode - (Optional) Storage tier mode
  # - Valid values: "LOCAL", "TIERED"
  # - Default: "LOCAL"
  # - "LOCAL": Standard EBS-only storage (traditional mode)
  # - "TIERED": Enables tiered storage (S3 for infrequently accessed data)
  # - Tiered storage reduces costs for large data retention requirements
  # - Tiered storage automatically moves older data to S3
  # - Requires Kafka 3.6 or later
  # - Can impact performance for older data access
  # - Consider for use cases with long retention periods (30+ days)
  # Tiered storage benefits:
  #   - Lower storage costs for older data
  #   - Unlimited storage capacity
  #   - Useful for log retention, audit trails, compliance
  # Documentation: https://docs.aws.amazon.com/msk/latest/developerguide/msk-tiered-storage.html
  # storage_mode = "LOCAL"

  #----------------------------------------------------------------------------
  # rebalancing - (Optional) Intelligent rebalancing configuration
  #----------------------------------------------------------------------------
  # Controls automatic partition rebalancing for Express brokers only
  # Only applicable to MSK Provisioned clusters with Express brokers
  # rebalancing {
  #   # status - (Required) Rebalancing status
  #   # - Valid values: "ACTIVE", "PAUSED"
  #   # - Default: "ACTIVE" for new Express clusters
  #   # - "ACTIVE": Automatic intelligent rebalancing enabled
  #   # - "PAUSED": Rebalancing temporarily disabled
  #   # - Only works with Express brokers (not Standard brokers)
  #   # - When enabled, AWS automatically rebalances partitions across brokers
  #   # - Optimizes for even distribution and performance
  #   # - Cannot use third-party tools like Cruise Control when enabled
  #   # Note: Intelligent rebalancing is an Express broker feature
  #   # Documentation: https://docs.aws.amazon.com/msk/latest/developerguide/intelligent-rebalancing.html
  #   status = "ACTIVE"
  # }

  # region - (Optional) AWS region for the cluster
  # - Specifies the region where the cluster will be created
  # - Default: Region set in the AWS provider configuration
  # - Format: "us-east-1", "eu-west-1", "ap-southeast-1", etc.
  # - Must match the region of VPC, subnets, and security groups
  # - Generally not needed as provider region is sufficient
  # - Useful for multi-region provider configurations
  # - Once set, cluster cannot be moved to different region
  # Note: Check MSK availability and Kafka version support by region
  # region = "us-east-1"

  # tags - (Optional) Resource tags
  # - Key-value pairs for resource organization and cost tracking
  # - Tags are case-sensitive
  # - Maximum 50 tags per resource
  # - Tag keys have 1-128 characters, values have 0-256 characters
  # - Inherited by default_tags from provider if configured
  # - Useful for cost allocation, automation, and access control
  # - Common tags: Environment, Owner, CostCenter, Project, Name
  # - Appears in AWS console, billing reports, and Cost Explorer
  tags = {
    Name        = "example-msk-cluster"
    Environment = "production"
    ManagedBy   = "terraform"
    Project     = "data-streaming"
    Owner       = "data-engineering-team"
    CostCenter  = "engineering"
  }

  #----------------------------------------------------------------------------
  # timeouts - (Optional) Resource operation timeouts
  #----------------------------------------------------------------------------
  # Custom timeout durations for resource operations
  # timeouts {
  #   # create - (Optional) Timeout for cluster creation
  #   # - Default: 120m (2 hours)
  #   # - Format: "120m", "2h"
  #   # - Cluster creation typically takes 15-30 minutes
  #   # - May take longer for larger clusters or during high AWS load
  #   # - If creation exceeds timeout, Terraform marks as failed (cluster may still be creating)
  #   create = "120m"
  #
  #   # update - (Optional) Timeout for cluster updates
  #   # - Default: 120m (2 hours)
  #   # - Format: "120m", "2h"
  #   # - Update duration varies by operation type:
  #   #   - Adding brokers: 10-20 minutes
  #   #   - Scaling storage: 5-15 minutes
  #   #   - Configuration changes: 5-10 minutes
  #   #   - Security updates: 15-30 minutes
  #   update = "120m"
  #
  #   # delete - (Optional) Timeout for cluster deletion
  #   # - Default: 120m (2 hours)
  #   # - Format: "120m", "2h"
  #   # - Deletion typically takes 10-20 minutes
  #   # - Includes cleanup of ENIs, EBS volumes, and other resources
  #   delete = "120m"
  # }
}

#==============================================================================
# COMPUTED ATTRIBUTES (Available after creation)
#==============================================================================
# These attributes are populated after the cluster is created and can be
# referenced in other resources or output values.
#
# Primary Attributes:
# - arn: Amazon Resource Name of the cluster
# - cluster_uuid: Unique identifier for the cluster (use in IAM policies)
# - current_version: Current version string for updates (required for most updates)
# - zookeeper_connect_string: ZooKeeper connection string (host:port pairs)
# - zookeeper_connect_string_tls: ZooKeeper TLS connection string
#
# Bootstrap Broker Endpoints (depending on configuration):
# - bootstrap_brokers: Plaintext connection endpoints (PLAINTEXT encryption)
# - bootstrap_brokers_tls: TLS connection endpoints (TLS encryption)
# - bootstrap_brokers_sasl_iam: SASL/IAM connection endpoints (requires IAM auth + TLS)
# - bootstrap_brokers_sasl_scram: SASL/SCRAM connection endpoints (requires SCRAM auth + TLS)
# - bootstrap_brokers_public_tls: Public TLS endpoints (requires public access)
# - bootstrap_brokers_public_sasl_iam: Public SASL/IAM endpoints (public + IAM auth)
# - bootstrap_brokers_public_sasl_scram: Public SASL/SCRAM endpoints (public + SCRAM auth)
# - bootstrap_brokers_vpc_connectivity_tls: VPC connectivity TLS endpoints
# - bootstrap_brokers_vpc_connectivity_sasl_iam: VPC connectivity SASL/IAM endpoints
# - bootstrap_brokers_vpc_connectivity_sasl_scram: VPC connectivity SASL/SCRAM endpoints
#
# Important Notes:
# - Bootstrap broker lists are comma-separated hostname:port pairs
# - AWS may not return all endpoints, so values may not be stable across applies
# - Resource sorts values alphabetically for consistency
# - Ports vary by authentication method:
#   - 9092: PLAINTEXT (unauthenticated)
#   - 9094: TLS (certificate-based or unauthenticated with TLS)
#   - 9096: SASL_SCRAM (username/password with TLS)
#   - 9098: SASL_IAM (IAM-based with TLS)
# - Use appropriate bootstrap_brokers_* attribute based on your authentication setup
#==============================================================================

#==============================================================================
# OUTPUTS - Example output definitions
#==============================================================================
# Uncomment and customize these outputs as needed for your infrastructure

# output "msk_cluster_arn" {
#   description = "Amazon Resource Name (ARN) of the MSK cluster"
#   value       = aws_msk_cluster.example.arn
# }

# output "msk_cluster_name" {
#   description = "Name of the MSK cluster"
#   value       = aws_msk_cluster.example.cluster_name
# }

# output "msk_cluster_uuid" {
#   description = "UUID of the MSK cluster for use in IAM policies"
#   value       = aws_msk_cluster.example.cluster_uuid
# }

# output "msk_bootstrap_brokers_tls" {
#   description = "TLS connection host:port pairs for Kafka clients"
#   value       = aws_msk_cluster.example.bootstrap_brokers_tls
#   sensitive   = false # Set to true if you want to hide in console output
# }

# output "msk_bootstrap_brokers_sasl_iam" {
#   description = "SASL/IAM connection host:port pairs for Kafka clients using IAM authentication"
#   value       = aws_msk_cluster.example.bootstrap_brokers_sasl_iam
#   sensitive   = false
# }

# output "msk_zookeeper_connect_string" {
#   description = "ZooKeeper connection string (for Kafka versions < 3.x that require ZooKeeper)"
#   value       = aws_msk_cluster.example.zookeeper_connect_string
# }

# output "msk_current_version" {
#   description = "Current version of the MSK cluster (used for updates)"
#   value       = aws_msk_cluster.example.current_version
# }

#==============================================================================
# COMMON PATTERNS AND BEST PRACTICES
#==============================================================================
#
# 1. High Availability Production Setup:
#    - Use 3+ broker nodes across 3 availability zones
#    - Enable encryption at rest and in transit
#    - Use authentication (IAM or SCRAM) with TLS
#    - Enable enhanced monitoring (PER_BROKER or PER_TOPIC_PER_BROKER)
#    - Configure broker logs to S3 or CloudWatch for auditing
#    - Set appropriate EBS volume size based on retention needs
#    - Use kafka.m5.xlarge or larger instances for production
#
# 2. Security Hardening:
#    - Never use PLAINTEXT encryption in production
#    - Always enable encryption at rest with customer managed KMS key
#    - Use SASL/IAM authentication for AWS-native applications
#    - Use SASL/SCRAM for applications requiring username/password
#    - Disable unauthenticated access
#    - Keep public_access disabled unless absolutely necessary
#    - Implement least-privilege IAM policies for client access
#    - Enable CloudWatch Logs for security auditing
#    - Monitor unauthorized access attempts
#
# 3. Cost Optimization:
#    - Right-size broker instance types based on workload
#    - Use tiered storage for long retention periods (30+ days)
#    - Implement S3 lifecycle policies for archived logs
#    - Monitor storage utilization and scale appropriately
#    - Use "DEFAULT" enhanced monitoring for non-production
#    - Disable unused logging destinations
#    - Consider reserved capacity for predictable workloads
#    - Review and remove unused topics and consumer groups
#
# 4. Performance Tuning:
#    - Use provisioned throughput for high-throughput workloads (kafka.m5.4xlarge+)
#    - Enable compression in producer configuration (snappy or lz4)
#    - Set appropriate retention policies to balance storage and performance
#    - Use custom MSK configuration to tune Kafka broker properties:
#      - num.io.threads (default: 8, increase for high throughput)
#      - num.network.threads (default: 5, increase for many connections)
#      - log.segment.bytes (default: 1 GB, adjust based on workload)
#      - compression.type (default: producer, consider gzip or snappy)
#    - Monitor JMX metrics to identify bottlenecks
#    - Ensure sufficient client subnet IP addresses
#    - Use batch processing in producers for higher throughput
#
# 5. Maintenance and Updates:
#    - Use kafka_version = "X.Y.x" for automatic patch updates
#    - Test version upgrades in non-production first
#    - Plan for maintenance windows during cluster updates
#    - Monitor current_version attribute for drift detection
#    - Keep Terraform state in sync with actual infrastructure
#    - Use lifecycle rules to prevent accidental deletion:
#      lifecycle {
#        prevent_destroy = true
#      }
#    - Tag resources for change tracking
#    - Document custom configurations and their purposes
#
# 6. Monitoring and Alerting:
#    - Enable open_monitoring for Prometheus integration
#    - Set up CloudWatch alarms for:
#      - Disk space utilization > 80%
#      - CPU utilization > 70%
#      - Network throughput approaching limits
#      - Under-replicated partitions > 0
#      - Offline partitions > 0
#      - Active controller count != 1
#    - Monitor broker logs for errors and warnings
#    - Use CloudWatch Logs Insights for log analysis
#    - Integrate with external monitoring (Datadog, New Relic, etc.)
#    - Track producer and consumer lag metrics
#
# 7. Disaster Recovery:
#    - Enable encryption at rest for data protection
#    - Use multi-AZ deployment for high availability
#    - Implement cross-region replication if needed (MirrorMaker 2)
#    - Back up custom MSK configurations
#    - Document cluster configuration and dependencies
#    - Test failover scenarios regularly
#    - Maintain up-to-date Terraform configurations in version control
#    - Use S3 logging for audit trails
#    - Consider snapshot strategies for critical data
#
# 8. Development and Testing:
#    - Use smaller instance types (kafka.m5.large)
#    - Reduce number of broker nodes (2 minimum)
#    - Use "DEFAULT" enhanced monitoring to reduce costs
#    - Disable unnecessary logging (S3, Firehose)
#    - Consider shorter retention periods
#    - Use same configuration structure as production (but scaled down)
#    - Test authentication and encryption in dev environments
#    - Use separate AWS accounts or VPCs for isolation
#
# 9. Migration Strategies:
#    - For existing clusters: Import using terraform import
#    - For new clusters: Start with this template and customize
#    - Use MirrorMaker 2 for zero-downtime migration
#    - Plan for authentication method transition (e.g., unauthenticated → IAM)
#    - Gradual encryption migration using TLS_PLAINTEXT temporarily
#    - Update clients progressively to new bootstrap brokers
#    - Monitor replication lag during migration
#    - Keep old cluster running until migration is verified
#
# 10. Troubleshooting Common Issues:
#     - Connection failures: Check security groups and network ACLs
#     - Authentication errors: Verify IAM policies or Secrets Manager secrets
#     - Performance issues: Review JMX metrics and broker logs
#     - Storage full: Scale up volume_size or implement retention policies
#     - Under-replicated partitions: Check broker health and network
#     - Bootstrap broker not available: Wait for cluster to become ACTIVE
#     - Terraform apply timeout: Check AWS console for actual cluster state
#     - Version upgrade failure: Ensure configuration compatibility
#
#==============================================================================
# RELATED RESOURCES
#==============================================================================
# Consider using these related resources for complete MSK setup:
#
# - aws_msk_configuration: Custom Kafka broker configuration
# - aws_msk_scram_secret_association: Associate SCRAM secrets with cluster
# - aws_msk_serverless_cluster: Serverless MSK cluster (alternative)
# - aws_kms_key: Customer managed key for encryption at rest
# - aws_cloudwatch_log_group: Log group for broker logs
# - aws_s3_bucket: Bucket for broker log archival
# - aws_kinesis_firehose_delivery_stream: Firehose for log delivery
# - aws_iam_policy: IAM policies for client access
# - aws_security_group: Security group for broker and client access
# - aws_vpc, aws_subnet: VPC and subnet resources for cluster networking
#
#==============================================================================
# REFERENCES
#==============================================================================
# - Terraform AWS Provider: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_cluster
# - AWS MSK Documentation: https://docs.aws.amazon.com/msk/latest/developerguide/
# - MSK Best Practices: https://docs.aws.amazon.com/msk/latest/developerguide/bestpractices.html
# - MSK Pricing: https://aws.amazon.com/msk/pricing/
# - Apache Kafka Documentation: https://kafka.apache.org/documentation/
# - MSK Security: https://docs.aws.amazon.com/msk/latest/developerguide/security.html
# - MSK Monitoring: https://docs.aws.amazon.com/msk/latest/developerguide/monitoring.html
# - Kafka Connect with MSK: https://docs.aws.amazon.com/msk/latest/developerguide/msk-connect.html
#==============================================================================
