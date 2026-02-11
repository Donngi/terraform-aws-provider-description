# Terraform Resource: aws_elastic_beanstalk_environment
# AWS Provider Version: 6.28.0
# Last Updated: 2026-01-27
#
# Description:
# Provides an Elastic Beanstalk Environment Resource. Elastic Beanstalk allows
# you to deploy and manage applications in the AWS cloud without worrying about
# the infrastructure that runs those applications. Environments are often things
# such as development, integration, or production.
#
# AWS Documentation:
# https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/Welcome.html
# ============================================================

resource "aws_elastic_beanstalk_environment" "example" {
  # ============================================================
  # Required Arguments
  # ============================================================

  # name - (Required) string
  # A unique name for this Environment. This name is used in the application URL.
  # - Must be unique within the account and region
  # - Length: 4-40 characters
  # - Can contain letters, numbers, and hyphens
  # - Cannot start or end with a hyphen
  # AWS API: EnvironmentName
  name = "my-environment"

  # application - (Required) string
  # Name of the application that contains the version to be deployed.
  # - Must reference an existing Elastic Beanstalk application
  # - The application serves as a logical container for environments
  # AWS API: ApplicationName
  application = "my-application"

  # ============================================================
  # Optional Arguments - Platform Selection (choose one)
  # ============================================================

  # solution_stack_name - (Optional) string
  # A solution stack to base your environment off of. Example stacks can be
  # found in the Amazon API documentation. Solution stacks define the platform
  # (OS, runtime, web server, application server) for the environment.
  # - Mutually exclusive with platform_arn and template_name
  # - Use aws elasticbeanstalk list-available-solution-stacks to list options
  # - Example: "64bit Amazon Linux 2023 v4.0.0 running Python 3.11"
  # AWS API: SolutionStackName
  solution_stack_name = "64bit Amazon Linux 2023 v4.0.0 running Python 3.11"

  # platform_arn - (Optional) string (computed)
  # The ARN of the Elastic Beanstalk Platform to use in deployment.
  # - Mutually exclusive with solution_stack_name and template_name
  # - More specific than solution_stack_name, includes version
  # - Format: arn:aws:elasticbeanstalk:region::platform/platform-name/version
  # - Example: arn:aws:elasticbeanstalk:us-east-1::platform/Python 3.11 running on 64bit Amazon Linux 2023/4.0.0
  # AWS API: PlatformArn
  # platform_arn = "arn:aws:elasticbeanstalk:us-east-1::platform/Python 3.11 running on 64bit Amazon Linux 2023/4.0.0"

  # template_name - (Optional) string
  # The name of the Elastic Beanstalk Configuration template to use in deployment.
  # - Mutually exclusive with solution_stack_name and platform_arn
  # - References a saved configuration template
  # - Useful for standardizing environment configurations across teams
  # AWS API: TemplateName
  # template_name = "my-config-template"

  # ============================================================
  # Optional Arguments - Environment Configuration
  # ============================================================

  # description - (Optional) string
  # Short description of the Environment.
  # - Maximum length: 200 characters
  # - Helps identify the purpose and context of the environment
  # AWS API: Description
  description = "Production environment for my application"

  # tier - (Optional) string
  # Elastic Beanstalk Environment tier. Valid values are Worker or WebServer.
  # If tier is left blank, WebServer will be used.
  # - WebServer: Processes HTTP requests (web applications)
  # - Worker: Processes background tasks from an SQS queue
  # - Determines the type of resources provisioned (load balancer vs SQS)
  # AWS API: Tier.Name
  tier = "WebServer"

  # cname_prefix - (Optional) string (computed)
  # Prefix to use for the fully qualified DNS name of the Environment.
  # - Only applicable for WebServer tier environments
  # - Must be unique across all Elastic Beanstalk environments in the region
  # - Results in: <cname_prefix>.<region>.elasticbeanstalk.com
  # - Length: 4-63 characters
  # - Can contain lowercase letters, numbers, and hyphens
  # AWS API: CNAMEPrefix
  cname_prefix = "my-app-prod"

  # version_label - (Optional) string (computed)
  # The name of the Elastic Beanstalk Application Version to use in deployment.
  # - References a specific version of your application code
  # - The version must exist in the specified application
  # - If not specified, Elastic Beanstalk uses a sample application
  # AWS API: VersionLabel
  version_label = "v1.0.0"

  # region - (Optional) string (computed)
  # Region where this resource will be managed. Defaults to the Region set in
  # the provider configuration.
  # - Allows for explicit region specification per resource
  # - Overrides the provider-level region setting
  # - Useful for multi-region deployments
  # AWS API: Region (implicit in endpoint)
  # region = "us-east-1"

  # ============================================================
  # Optional Arguments - Operational Settings
  # ============================================================

  # wait_for_ready_timeout - (Optional) string
  # Default: "20m"
  # The maximum duration that Terraform should wait for an Elastic Beanstalk
  # Environment to be in a ready state before timing out.
  # - Format: Duration string (e.g., "20m", "1h", "30s")
  # - Applies to environment creation and updates
  # - Increase for environments with long startup times
  # Terraform-specific parameter
  wait_for_ready_timeout = "20m"

  # poll_interval - (Optional) string
  # The time between polling the AWS API to check if changes have been applied.
  # Use this to adjust the rate of API calls for any create or update action.
  # - Minimum: 10s
  # - Maximum: 180s
  # - Default: exponential backoff
  # - Helps avoid API rate limiting
  # Terraform-specific parameter
  poll_interval = "10s"

  # ============================================================
  # Optional Arguments - Tags
  # ============================================================

  # tags - (Optional) map(string)
  # A set of tags to apply to the Environment. If configured with a provider
  # default_tags configuration block present, tags with matching keys will
  # overwrite those defined at the provider-level.
  # - Maximum 50 tags per resource
  # - Tag keys and values are case-sensitive
  # - Tags are propagated to underlying resources
  # AWS API: Tags
  tags = {
    Environment = "production"
    Project     = "my-project"
    ManagedBy   = "terraform"
  }

  # ============================================================
  # Optional Block - Setting (Option Settings)
  # ============================================================

  # setting - (Optional) set of objects
  # Option settings to configure the new Environment. These override specific
  # values that are set as defaults. The format is detailed below.
  # 
  # Configuration options are organized into namespaces (e.g., aws:autoscaling:asg)
  # and can control various aspects of the environment including:
  # - Auto Scaling group settings
  # - Load balancer configuration
  # - EC2 instance settings
  # - Application settings
  # - Monitoring and logging
  # 
  # See AWS documentation for complete list of available options:
  # https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options.html
  # AWS API: OptionSettings

  # Example: Configure Auto Scaling
  setting {
    # namespace - (Required) string
    # A unique namespace identifying the option's associated AWS resource.
    # Common namespaces:
    # - aws:autoscaling:asg (Auto Scaling group)
    # - aws:autoscaling:launchconfiguration (Launch configuration)
    # - aws:ec2:instances (EC2 instances)
    # - aws:elasticbeanstalk:environment (Environment settings)
    # - aws:elb:loadbalancer (Load balancer)
    namespace = "aws:autoscaling:asg"

    # name - (Required) string
    # The name of the configuration option.
    # Valid options depend on the namespace.
    name = "MinSize"

    # value - (Required) string
    # The current value for the configuration option.
    # All values must be specified as strings.
    value = "1"

    # resource - (Optional) string
    # A unique resource name for a scheduled configuration action.
    # Only used for scheduled configuration actions in certain namespaces.
    # resource = ""
  }

  # Example: Configure maximum instances
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "4"
  }

  # Example: Configure instance type
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t3.small"
  }

  # Example: Configure VPC
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = "vpc-12345678"
  }

  # Example: Configure health check
  setting {
    namespace = "aws:elasticbeanstalk:application"
    name      = "Application Healthcheck URL"
    value     = "/health"
  }

  # Example: Configure environment variables
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DATABASE_URL"
    value     = "postgres://localhost/mydb"
  }

  # Example: Enable enhanced health reporting
  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "enhanced"
  }

  # Example: Configure load balancer type
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "application"
  }

  # Example: Configure rolling updates
  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "RollingUpdateEnabled"
    value     = "true"
  }

  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "RollingUpdateType"
    value     = "Health"
  }

  # Example: Configure managed updates
  setting {
    namespace = "aws:elasticbeanstalk:managedactions"
    name      = "ManagedActionsEnabled"
    value     = "true"
  }

  setting {
    namespace = "aws:elasticbeanstalk:managedactions"
    name      = "PreferredStartTime"
    value     = "Sun:02:00"
  }

  # Example: Configure CloudWatch logs streaming
  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "StreamLogs"
    value     = "true"
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "DeleteOnTerminate"
    value     = "false"
  }

  # Example: Configure X-Ray daemon
  setting {
    namespace = "aws:elasticbeanstalk:xray"
    name      = "XRayEnabled"
    value     = "true"
  }
}

# ============================================================
# Computed Attributes (Read-Only)
# ============================================================

# The following attributes are exported and can be referenced in other resources:
#
# id - (string)
#   ID of the Elastic Beanstalk Environment.
#   Format: e-<environment-id>
#   Example: e-abcd1234
#
# arn - (string)
#   Amazon Resource Name (ARN) of the environment.
#   Format: arn:aws:elasticbeanstalk:region:account-id:environment/application-name/environment-name
#
# name - (string)
#   Name of the Elastic Beanstalk Environment.
#
# description - (string)
#   Description of the Elastic Beanstalk Environment.
#
# tier - (string)
#   The environment tier specified (WebServer or Worker).
#
# application - (string)
#   The Elastic Beanstalk Application specified for this environment.
#
# cname - (string)
#   Fully qualified DNS name for this Environment.
#   Format: <cname_prefix>.<region>.elasticbeanstalk.com
#   Only available for WebServer tier environments.
#
# endpoint_url - (string)
#   The URL to the Load Balancer for this Environment.
#   For WebServer tier with load balancer.
#
# all_settings - (set of objects)
#   List of all option settings configured in this Environment.
#   These are a combination of default settings and their overrides from
#   setting in the configuration. Each object contains:
#   - namespace: The option namespace
#   - name: The option name
#   - value: The option value
#   - resource: The resource name (if applicable)
#
# setting - (set of objects)
#   Settings specifically set for this Environment (user-configured).
#
# autoscaling_groups - (list of strings)
#   The autoscaling groups used by this Environment.
#
# instances - (list of strings)
#   EC2 instances used by this Environment.
#   List of instance IDs.
#
# launch_configurations - (list of strings)
#   Launch configurations in use by this Environment.
#
# load_balancers - (list of strings)
#   Elastic load balancers in use by this Environment.
#   For WebServer tier environments.
#
# queues - (list of strings)
#   SQS queues in use by this Environment.
#   For Worker tier environments.
#
# triggers - (list of strings)
#   Autoscaling triggers in use by this Environment.
#
# tags_all - (map of strings)
#   A map of tags assigned to the resource, including those inherited from
#   the provider default_tags configuration block.

# ============================================================
# Usage Examples
# ============================================================

# Example 1: Basic WebServer environment
resource "aws_elastic_beanstalk_environment" "web" {
  name                = "my-web-app"
  application         = aws_elastic_beanstalk_application.app.name
  solution_stack_name = "64bit Amazon Linux 2023 v4.0.0 running Python 3.11"
  tier                = "WebServer"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t3.micro"
  }
}

# Example 2: Worker environment with SQS
resource "aws_elastic_beanstalk_environment" "worker" {
  name                = "my-worker"
  application         = aws_elastic_beanstalk_application.app.name
  solution_stack_name = "64bit Amazon Linux 2023 v4.0.0 running Python 3.11"
  tier                = "Worker"

  setting {
    namespace = "aws:elasticbeanstalk:sqsd"
    name      = "WorkerQueueURL"
    value     = aws_sqs_queue.queue.url
  }

  setting {
    namespace = "aws:elasticbeanstalk:sqsd"
    name      = "HttpPath"
    value     = "/tasks"
  }
}

# Example 3: Environment with VPC configuration
resource "aws_elastic_beanstalk_environment" "vpc" {
  name                = "my-vpc-app"
  application         = aws_elastic_beanstalk_application.app.name
  solution_stack_name = "64bit Amazon Linux 2023 v4.0.0 running Node.js 20"

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = aws_vpc.main.id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(",", aws_subnet.private[*].id)
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = join(",", aws_subnet.public[*].id)
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = "false"
  }
}

# Example 4: Environment with custom domain
resource "aws_elastic_beanstalk_environment" "custom" {
  name                = "production"
  application         = aws_elastic_beanstalk_application.app.name
  solution_stack_name = "64bit Amazon Linux 2023 v4.0.0 running PHP 8.3"
  cname_prefix        = "myapp-prod"

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "application"
  }
}

# Example 5: Output usage
output "environment_url" {
  description = "URL of the Elastic Beanstalk environment"
  value       = aws_elastic_beanstalk_environment.example.cname
}

output "environment_arn" {
  description = "ARN of the Elastic Beanstalk environment"
  value       = aws_elastic_beanstalk_environment.example.arn
}

output "environment_instances" {
  description = "EC2 instances in the environment"
  value       = aws_elastic_beanstalk_environment.example.instances
}

# ============================================================
# Important Notes and Best Practices
# ============================================================

# 1. Platform Selection:
#    - Choose ONE of: solution_stack_name, platform_arn, or template_name
#    - solution_stack_name is the most common approach
#    - Use aws elasticbeanstalk list-available-solution-stacks to find options
#    - Keep platform versions up to date for security patches

# 2. Environment Tiers:
#    - WebServer: Use for web applications that serve HTTP traffic
#      * Provisions load balancer and web server instances
#      * Access via CNAME (e.g., myapp.us-east-1.elasticbeanstalk.com)
#    - Worker: Use for background processing tasks
#      * Provisions SQS queue and worker instances
#      * No load balancer or CNAME

# 3. Setting Configuration:
#    - Settings follow namespace:name pattern
#    - All values must be strings (convert numbers/booleans to strings)
#    - Settings override platform defaults
#    - Use setting blocks for environment-specific configuration
#    - Precedence: direct settings > saved configs > .ebextensions > defaults

# 4. Common Configuration Options:
#    - Instance type: aws:autoscaling:launchconfiguration/InstanceType
#    - Auto Scaling: aws:autoscaling:asg/MinSize, MaxSize
#    - VPC: aws:ec2:vpc/VPCId, Subnets
