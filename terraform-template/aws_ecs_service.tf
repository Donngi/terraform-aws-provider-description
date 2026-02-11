# ============================================================
# aws_ecs_service - Amazon ECS Service
# ============================================================
# Resource Type: aws_ecs_service
# Provider Version: 6.28.0
#
# DESCRIPTION:
# Provides an ECS service - effectively a task that is expected to run until
# an error occurs or a user terminates it (typically a webserver or a database).
#
# IMPORTANT NOTES:
# - To prevent a race condition during service deletion, set `depends_on` to the
#   related `aws_iam_role_policy`; otherwise, the policy may be destroyed too
#   soon and the ECS service will get stuck in the DRAINING state.
# - Tasks using the Fargate launch type or the CODE_DEPLOY/EXTERNAL deployment
#   controller types don't support the DAEMON scheduling strategy.
# - When using Blue/Green deployments (CODE_DEPLOY), only certain parameters
#   can be updated.
#
# AWS DOCUMENTATION:
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs_services.html
# ============================================================

resource "aws_ecs_service" "example" {
  # ============================================================
  # REQUIRED ARGUMENTS
  # ============================================================

  # (Required) Name of the service (up to 255 letters, numbers, hyphens, and underscores)
  #
  # The service name is used to identify the service within the cluster.
  # It must be unique within a cluster and follows DNS naming conventions.
  #
  # Example: "web-application", "api-service", "worker-service"
  name = "example-service"

  # ============================================================
  # OPTIONAL ARGUMENTS - Core Service Configuration
  # ============================================================

  # (Optional) ARN of an ECS cluster
  #
  # Specifies which ECS cluster this service should run in. If not specified,
  # the default cluster will be used. The cluster provides the infrastructure
  # capacity (EC2 instances, Fargate, or ECS Managed Instances) where tasks
  # will be launched.
  #
  # Example: "arn:aws:ecs:us-east-1:123456789012:cluster/my-cluster"
  cluster = "arn:aws:ecs:us-east-1:123456789012:cluster/production-cluster"

  # (Optional) Family and revision (family:revision) or full ARN of the task
  # definition that you want to run in your service
  #
  # Required unless using the EXTERNAL deployment controller. If a revision is
  # not specified, the latest ACTIVE revision is used. The task definition
  # defines the containers, CPU/memory requirements, networking mode, and
  # volumes for your tasks.
  #
  # Example: "my-task-family:3" or "my-task-family" or full ARN
  task_definition = "arn:aws:ecs:us-east-1:123456789012:task-definition/my-task:1"

  # (Optional) Number of instances of the task definition to place and keep running
  #
  # Defaults to 0. Do not specify if using the DAEMON scheduling strategy.
  # For REPLICA strategy, this determines how many tasks should be running.
  # You can use lifecycle.ignore_changes to allow external auto-scaling to
  # manage this value without Terraform interference.
  #
  # Valid range: 0 to maximum supported by your capacity
  desired_count = 2

  # (Optional) Launch type on which to run your service
  #
  # Valid values: EC2, FARGATE, EXTERNAL
  # Default: EC2
  #
  # - EC2: Tasks run on EC2 instances you manage
  # - FARGATE: Tasks run on AWS-managed serverless infrastructure
  # - EXTERNAL: For services deployed on external infrastructure
  #
  # Conflicts with capacity_provider_strategy. Use capacity providers for more
  # flexibility and advanced features like mixed EC2/Fargate deployments.
  launch_type = "FARGATE"

  # (Optional) Platform version on which to run your service
  #
  # Only applicable for launch_type set to FARGATE. Defaults to LATEST.
  # Platform versions define the task infrastructure features available.
  #
  # Example: "1.4.0", "LATEST"
  #
  # AWS Documentation:
  # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/platform_versions.html
  platform_version = "LATEST"

  # (Optional) Scheduling strategy to use for the service
  #
  # Valid values: REPLICA, DAEMON
  # Default: REPLICA
  #
  # - REPLICA: Maintains the specified number of tasks (desired_count)
  # - DAEMON: Runs exactly one task on each active container instance
  #
  # Note: Fargate launch type and CODE_DEPLOY/EXTERNAL deployment controllers
  # don't support the DAEMON scheduling strategy.
  scheduling_strategy = "REPLICA"

  # (Optional) Region where this resource will be managed
  #
  # Defaults to the Region set in the provider configuration. This allows you
  # to explicitly specify the region for this resource, which can be useful
  # for multi-region deployments.
  #
  # Example: "us-west-2", "eu-central-1"
  region = "us-east-1"

  # ============================================================
  # OPTIONAL ARGUMENTS - Deployment Configuration
  # ============================================================

  # (Optional) Upper limit (as a percentage) of the number of running tasks
  # that can be running in a service during a deployment
  #
  # Not valid when using the DAEMON scheduling strategy. This allows you to
  # control how many additional tasks can be started during a deployment.
  #
  # Example: 200 means up to twice the desired count can run during deployment
  # Valid range: 100-200 (typically)
  deployment_maximum_percent = 200

  # (Optional) Lower limit (as a percentage) of the number of running tasks
  # that must remain running and healthy in a service during a deployment
  #
  # This ensures availability during deployments by maintaining a minimum
  # number of healthy tasks.
  #
  # Example: 50 means at least half of desired_count must remain healthy
  # Valid range: 0-100
  deployment_minimum_healthy_percent = 50

  # (Optional) Enable to force a new task deployment of the service
  #
  # This can be used to:
  # - Update tasks to use a newer Docker image with same image:tag combination
  # - Roll Fargate tasks onto a newer platform version
  # - Immediately deploy ordered_placement_strategy and placement_constraints updates
  #
  # When combined with triggers, you can force redeployment on every apply.
  force_new_deployment = false

  # (Optional) Map of arbitrary keys and values that trigger an in-place update
  #
  # Useful with plantimestamp() to force redeployment on every apply.
  # Any change to these values will trigger a new deployment.
  #
  # Example:
  # triggers = {
  #   redeployment = plantimestamp()
  # }
  triggers = {}

  # (Optional) Enable to delete a service even if it wasn't scaled down to zero tasks
  #
  # Only necessary to use this if the service uses the REPLICA scheduling strategy.
  # Normally, ECS requires services to have 0 tasks before deletion.
  force_delete = false

  # (Optional) If true, Terraform will wait for the service to reach a steady state
  #
  # Similar to running `aws ecs wait services-stable`. This is useful when you
  # want Terraform to wait for deployments to complete before proceeding.
  #
  # Default: false
  # Required when using sigint_rollback = true
  wait_for_steady_state = false

  # (Optional) Enable graceful termination of deployments using SIGINT signals
  #
  # When enabled, allows you to safely cancel an in-progress deployment and
  # automatically trigger a rollback to the previous stable state.
  #
  # Default: false
  # Only applicable when using ECS deployment controller
  # Requires wait_for_steady_state = true
  sigint_rollback = false

  # ============================================================
  # OPTIONAL ARGUMENTS - Availability & Rebalancing
  # ============================================================

  # (Optional) ECS automatically redistributes tasks within a service across AZs
  #
  # Valid values: ENABLED, DISABLED
  #
  # When creating a new service, defaults to ENABLED if the service is compatible.
  # When updating an existing service, defaults to the existing value.
  # This helps mitigate the risk of impaired application availability due to
  # underlying infrastructure failures and task lifecycle activities.
  availability_zone_rebalancing = "ENABLED"

  # ============================================================
  # OPTIONAL ARGUMENTS - IAM & Permissions
  # ============================================================

  # (Optional) ARN of the IAM role that allows Amazon ECS to make calls to
  # your load balancer on your behalf
  #
  # This parameter is required if you are using a load balancer with your service,
  # but only if your task definition does not use the awsvpc network mode.
  # If using awsvpc network mode, do not specify this role.
  # If your account has already created the Amazon ECS service-linked role,
  # that role is used by default for your service unless you specify a role here.
  #
  # Example: "arn:aws:iam::123456789012:role/ecsServiceRole"
  iam_role = null

  # ============================================================
  # OPTIONAL ARGUMENTS - Load Balancer Integration
  # ============================================================

  # (Optional) Seconds to ignore failing load balancer health checks on newly
  # instantiated tasks to prevent premature shutdown
  #
  # Valid range: 0 to 2147483647 seconds
  # Only valid for services configured to use load balancers.
  #
  # This grace period allows newly started tasks time to initialize before
  # being subject to health check failures.
  health_check_grace_period_seconds = 60

  # ============================================================
  # OPTIONAL ARGUMENTS - Tags
  # ============================================================

  # (Optional) Key-value map of resource tags
  #
  # Tags help you organize and identify your resources. If configured with a
  # provider default_tags configuration block, tags with matching keys will
  # overwrite those defined at the provider-level.
  #
  # Example:
  # tags = {
  #   Environment = "production"
  #   Application = "web-api"
  #   ManagedBy   = "terraform"
  # }
  tags = {
    Environment = "production"
    Service     = "example"
  }

  # ============================================================
  # OPTIONAL ARGUMENTS - ECS Features
  # ============================================================

  # (Optional) Whether to enable Amazon ECS managed tags for the tasks within the service
  #
  # ECS managed tags automatically add cluster and service information to tasks,
  # which can be useful for cost allocation and resource organization.
  enable_ecs_managed_tags = true

  # (Optional) Whether to enable Amazon ECS Exec for the tasks within the service
  #
  # ECS Exec allows you to execute commands in running containers for debugging
  # and troubleshooting. Requires appropriate IAM permissions in the task role.
  #
  # AWS Documentation:
  # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-exec.html
  enable_execute_command = false

  # (Optional) Whether to propagate the tags from the task definition or the
  # service to the tasks
  #
  # Valid values: SERVICE, TASK_DEFINITION
  #
  # - SERVICE: Tags from the service definition are propagated to tasks
  # - TASK_DEFINITION: Tags from the task definition are propagated to tasks
  propagate_tags = "SERVICE"

  # ============================================================
  # BLOCK: alarms
  # ============================================================
  # (Optional) Information about the CloudWatch alarms
  # Max items: 1
  #
  # CloudWatch deployment alarms provide automatic rollback capabilities when
  # specified alarms are triggered during a deployment. This helps ensure
  # service reliability by reverting to the previous stable state if issues
  # are detected.

  alarms {
    # (Required) One or more CloudWatch alarm names
    #
    # List of CloudWatch alarm names to monitor during deployments.
    # When any of these alarms enter the ALARM state, the deployment can
    # be automatically rolled back if rollback is enabled.
    alarm_names = [
      "service-cpu-high",
      "service-error-rate-high"
    ]

    # (Required) Whether to use the CloudWatch alarm option in the service
    # deployment process
    #
    # When true, ECS will monitor the specified alarms during deployments.
    enable = true

    # (Required) Whether to configure Amazon ECS to roll back the service if
    # a service deployment fails
    #
    # If rollback is enabled and a deployment triggers an alarm, the service
    # is rolled back to the last deployment that completed successfully.
    rollback = true
  }

  # ============================================================
  # BLOCK: capacity_provider_strategy
  # ============================================================
  # (Optional) Capacity provider strategies to use for the service
  # Can be one or more
  # Nesting mode: set
  #
  # Capacity providers offer more flexibility than launch types, allowing you
  # to use multiple capacity types (EC2, Fargate, Fargate Spot) and control
  # how tasks are distributed across them. This enables cost optimization and
  # mixed workload strategies.
  #
  # Conflicts with launch_type.
  # Updating this argument requires force_new_deployment = true.
  #
  # AWS Documentation:
  # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/capacity-launch-type-comparison.html

  capacity_provider_strategy {
    # (Required) Short name of the capacity provider
    #
    # Example: "FARGATE", "FARGATE_SPOT", or a custom capacity provider name
    capacity_provider = "FARGATE"

    # (Optional) Number of tasks, at a minimum, to run on the specified capacity provider
    #
    # Only one capacity provider in a capacity provider strategy can have a
    # base defined. This ensures a minimum number of tasks always run on this
    # capacity provider.
    #
    # Valid range: 0 to 100,000
    base = 1

    # (Optional) Relative percentage of the total number of launched tasks that
    # should use the specified capacity provider
    #
    # Tasks are distributed proportionally based on weight. If no weight is
    # specified, the default is 0. At least one capacity provider must have
    # a weight greater than 0.
    #
    # Valid range: 0 to 1,000
    weight = 50
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 50
  }

  # ============================================================
  # BLOCK: deployment_circuit_breaker
  # ============================================================
  # (Optional) Configuration block for deployment circuit breaker
  # Max items: 1
  #
  # The deployment circuit breaker automatically rolls back unhealthy service
  # deployments without the need for manual intervention. This feature monitors
  # task health and stops the deployment if tasks fail to start or become unhealthy.

  deployment_circuit_breaker {
    # (Required) Whether to enable the deployment circuit breaker logic for the service
    #
    # When enabled, ECS monitors the deployment progress and stops it if tasks
    # fail to reach a running state or fail health checks.
    enable = true

    # (Required) Whether to enable Amazon ECS to roll back the service if a
    # service deployment fails
    #
    # If rollback is enabled, when a deployment fails the circuit breaker check,
    # the service is rolled back to the last deployment that completed successfully.
    rollback = true
  }

  # ============================================================
  # BLOCK: deployment_configuration
  # ============================================================
  # (Optional) Configuration block for deployment settings
  # Max items: 1
  #
  # The deployment configuration controls how new task deployments are executed,
  # including rolling updates, blue/green deployments, and canary deployments.

  deployment_configuration {
    # (Optional) Type of deployment strategy
    #
    # Valid values: ROLLING, BLUE_GREEN, LINEAR, CANARY
    # Default: ROLLING
    #
    # - ROLLING: Traditional rolling update strategy
    # - BLUE_GREEN: Full blue/green deployment with traffic shift
    # - LINEAR: Gradual linear increase in traffic to new deployment
    # - CANARY: Initial small percentage, then full shift
    strategy = "ROLLING"

    # (Optional) Number of minutes to wait after a new deployment is fully
    # provisioned before terminating the old deployment
    #
    # Valid range: 0-1440 minutes
    # Used with BLUE_GREEN, LINEAR, and CANARY strategies
    #
    # This bake time allows you to monitor the new deployment before the old
    # tasks are terminated, enabling quick rollback if issues are detected.
    bake_time_in_minutes = 10

    # --------------------------------------------------------
    # Nested Block: linear_configuration
    # --------------------------------------------------------
    # (Optional) Configuration for linear deployment strategy
    # Required when strategy is set to LINEAR
    # Max items: 1

    linear_configuration {
      # (Required) Percentage of traffic to shift in each step during a linear deployment
      #
      # Valid range: 3.0-100.0
      # Example: 25.0 means shift 25% of traffic in each step
      step_percent = 25.0

      # (Optional) Number of minutes to wait between each step during a linear deployment
      #
      # Valid range: 0-1440 minutes
      # This wait time allows you to monitor each step before proceeding.
      step_bake_time_in_minutes = 5
    }

    # --------------------------------------------------------
    # Nested Block: canary_configuration
    # --------------------------------------------------------
    # (Optional) Configuration for canary deployment strategy
    # Required when strategy is set to CANARY
    # Max items: 1

    canary_configuration {
      # (Required) Percentage of traffic to route to the canary deployment
      #
      # Valid range: 0.1-100.0
      # The canary deployment receives this percentage of traffic initially.
      canary_percent = 10.0

      # (Optional) Number of minutes to wait before shifting all traffic to
      # the new deployment
      #
      # Valid range: 0-1440 minutes
      # After this bake time, all remaining traffic shifts to the new deployment.
      canary_bake_time_in_minutes = 5
    }

    # --------------------------------------------------------
    # Nested Block: lifecycle_hook
    # --------------------------------------------------------
    # (Optional) Configuration for lifecycle hooks invoked during deployments
    # Nesting mode: set
    #
    # Lifecycle hooks allow you to run custom Lambda functions at specific
    # stages of the deployment process for validation or custom logic.

    lifecycle_hook {
      # (Required) ARN of the Lambda function to invoke for the lifecycle hook
      #
      # This Lambda function will be invoked at the specified lifecycle stages.
      # It can perform validation, run tests, or execute custom logic.
      hook_target_arn = "arn:aws:lambda:us-east-1:123456789012:function:deployment-validator"

      # (Required) ARN of the IAM role that grants the service permission to
      # invoke the Lambda function
      #
      # This role must have permissions to invoke the specified Lambda function.
      role_arn = "arn:aws:iam::123456789012:role/ecs-deployment-hook-role"

      # (Required) Stages during the deployment when the hook should be invoked
      #
      # Valid values: RECONCILE_SERVICE, PRE_SCALE_UP, POST_SCALE_UP,
      # TEST_TRAFFIC_SHIFT, POST_TEST_TRAFFIC_SHIFT, PRODUCTION_TRAFFIC_SHIFT,
      # POST_PRODUCTION_TRAFFIC_SHIFT
      lifecycle_stages = [
        "PRE_SCALE_UP",
        "POST_PRODUCTION_TRAFFIC_SHIFT"
      ]

      # (Optional) Custom parameters that Amazon ECS will pass to the hook
      # target invocations
      #
      # This JSON string can contain any custom data you want to pass to your
      # Lambda function, such as configuration or validation parameters.
      hook_details = jsonencode({
        validation_type = "health_check"
        timeout         = 300
      })
    }
  }

  # ============================================================
  # BLOCK: deployment_controller
  # ============================================================
  # (Optional) Configuration block for deployment controller configuration
  # Max items: 1
  #
  # The deployment controller determines which deployment strategy engine is
  # used for the service.

  deployment_controller {
    # (Optional) Type of deployment controller
    #
    # Valid values: CODE_DEPLOY, ECS, EXTERNAL
    # Default: ECS
    #
    # - ECS: Use the standard ECS rolling update deployment
    # - CODE_DEPLOY: Use AWS CodeDeploy for blue/green deployments
    # - EXTERNAL: Deployment is managed by external tooling
    type = "ECS"
  }

  # ============================================================
  # BLOCK: load_balancer
  # ============================================================
  # (Optional) Configuration block for load balancers
  # Nesting mode: set
  #
  # Load balancer configuration allows you to integrate your service with
  # Application Load Balancers (ALB), Network Load Balancers (NLB), or
  # Classic Load Balancers (ELB). Multiple load balancers are supported
  # (added in provider version 2.22.0).
  #
  # AWS Documentation:
  # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/service-load-balancing.html

  load_balancer {
    # (Required) Name of the container to associate with the load balancer
    #
    # Must match a container name from your task definition. This is the
    # container that will receive traffic from the load balancer.
    container_name = "web-container"

    # (Required) Port on the container to associate with the load balancer
    #
    # Must match a port mapping defined in the task definition for the
    # specified container.
    container_port = 80

    # (Required for ALB/NLB) ARN of the Load Balancer target group to associate
    # with the service
    #
    # The target group defines the protocol, port, health check settings, and
    # other parameters for routing traffic to your tasks.
    target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/my-targets/abc123"

    # (Required for ELB Classic) Name of the ELB (Classic) to associate with
    # the service
    #
    # Only use for Classic Load Balancers. For ALB/NLB, use target_group_arn instead.
    # elb_name = "my-classic-lb"

    # --------------------------------------------------------
    # Nested Block: advanced_configuration
    # --------------------------------------------------------
    # (Optional) Configuration for Blue/Green deployment settings
    # Required when using BLUE_GREEN deployment strategy
    # Max items: 1
    #
    # This configuration is used with CodeDeploy blue/green deployments to
    # specify the alternate target group and listener rules for traffic shifting.

    advanced_configuration {
      # (Required) ARN of the alternate target group to use for Blue/Green deployments
      #
      # During a blue/green deployment, the new tasks are registered to this
      # alternate target group before traffic is shifted.
      alternate_target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/my-targets-alt/def456"

      # (Required) ARN of the listener rule that routes production traffic
      #
      # This listener rule will be modified during deployment to shift
      # production traffic from the primary to the alternate target group.
      production_listener_rule = "arn:aws:elasticloadbalancing:us-east-1:123456789012:listener-rule/app/my-load-balancer/abc123/def456/ghi789"

      # (Required) ARN of the IAM role that allows ECS to manage the target groups
      #
      # This role must have permissions to modify the load balancer listener
      # rules and target group registrations.
      role_arn = "arn:aws:iam::123456789012:role/ecsCodeDeployRole"

      # (Optional) ARN of the listener rule that routes test traffic
      #
      # During blue/green deployments, this listener can be used to test the
      # new deployment before shifting production traffic.
      test_listener_rule = "arn:aws:elasticloadbalancing:us-east-1:123456789012:listener-rule/app/my-load-balancer/abc123/def456/jkl012"
    }
  }

  # ============================================================
  # BLOCK: network_configuration
  # ============================================================
  # (Optional) Network configuration for the service
  # Max items: 1
  #
  # This parameter is required for task definitions that use the awsvpc network
  # mode to receive their own Elastic Network Interface. It is not supported
  # for other network modes.
  #
  # AWS Documentation:
  # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-networking.html

  network_configuration {
    # (Required) Subnets associated with the task or service
    #
    # Specify the subnets where your tasks should be launched. For high
    # availability, use subnets in multiple Availability Zones.
    subnets = [
      "subnet-12345678",
      "subnet-87654321"
    ]

    # (Optional) Security groups associated with the task or service
    #
    # If you do not specify a security group, the default security group for
    # the VPC is used. Security groups control inbound and outbound traffic
    # for your tasks.
    security_groups = [
      "sg-12345678"
    ]

    # (Optional) Assign a public IP address to the ENI
    #
    # Only applicable for Fargate launch type.
    # Valid values: true or false
    # Default: false
    #
    # Set to true if your tasks need direct internet access and are in public
    # subnets. Not needed if using NAT Gateway.
    assign_public_ip = false
  }

  # ============================================================
  # BLOCK: ordered_placement_strategy
  # ============================================================
  # (Optional) Service level strategy rules taken into consideration during
  # task placement
  # Max items: 5
  # Nesting mode: list (order matters)
  #
  # Placement strategies control how tasks are placed on container instances.
  # They are evaluated from top to bottom in order of precedence.
  # Updates take effect on next task deployment unless force_new_deployment is enabled.
  #
  # AWS Documentation:
  # https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_PlacementStrategy.html

  ordered_placement_strategy {
    # (Required) Type of placement strategy
    #
    # Valid values: binpack, random, spread
    #
    # - binpack: Place tasks based on the least available amount of CPU or memory
    # - random: Place tasks randomly
    # - spread: Place tasks evenly based on the specified field
    type = "spread"

    # (Optional) Field to apply the placement strategy against
    #
    # For spread strategy: Valid values are instanceId (or host, same effect),
    #   or any platform or custom attribute applied to a container instance
    # For binpack: Valid values are memory and cpu
    # For random: This attribute is not needed
    #
    # Note: For spread, "host" and "instanceId" will be normalized by AWS to
    # "instanceId", so the statefile will show instanceId even if you use host.
    field = "attribute:ecs.availability-zone"
  }

  ordered_placement_strategy {
    type  = "binpack"
    field = "memory"
  }

  # ============================================================
  # BLOCK: placement_constraints
  # ============================================================
  # (Optional) Rules taken into consideration during task placement
  # Max items: 10
  # Nesting mode: set
  #
  # Placement constraints allow you to control which instances your tasks can
  # be placed on based on custom attributes or requirements.
  # Updates take effect on next task deployment unless force_new_deployment is enabled.
  #
  # AWS Documentation:
  # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/cluster-query-language.html

  placement_constraints {
    # (Required) Type of constraint
    #
    # Valid values: memberOf, distinctInstance
    #
    # - memberOf: Place tasks on instances that match the expression
    # - distinctInstance: Place each task on a different instance
    type = "memberOf"

    # (Optional) Cluster Query Language expression to apply to the constraint
    #
    # Does not need to be specified for the distinctInstance type.
    # For memberOf, you can filter on instance attributes, custom attributes,
    # Availability Zones, instance types, etc.
    #
    # Example expressions:
    # - "attribute:ecs.instance-type == t2.micro"
    # - "attribute:ecs.availability-zone in [us-east-1a, us-east-1b]"
    # - "attribute:custom-attribute == value"
    expression = "attribute:ecs.instance-type =~ t2.*"
  }

  # ============================================================
  # BLOCK: service_connect_configuration
  # ============================================================
  # (Optional) ECS Service Connect configuration for service discovery and
  # connection
  # Max items: 1
  #
  # Service Connect provides management of service-to-service communication,
  # including service discovery and a service mesh. It allows services to
  # connect using short names instead of IP addresses or DNS names.
  #
  # AWS Documentation:
  # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/service-connect.html

  service_connect_configuration {
    # (Required) Whether to use Service Connect with this service
    #
    # When true, Service Connect is enabled and the service can discover and
    # connect to other services in the same namespace.
    enabled = true

    # (Optional) Namespace name or ARN of the aws_service_discovery_http_namespace
    #
    # The namespace provides a logical grouping for services that communicate
    # with each other. Services in the same namespace can discover each other.
    namespace = "arn:aws:servicediscovery:us-east-1:123456789012:namespace/ns-abc123"

    # --------------------------------------------------------
    # Nested Block: log_configuration
    # --------------------------------------------------------
    # (Optional) Log configuration for the container
    # Max items: 1

    log_configuration {
      # (Required) Log driver to use for the container
      #
      # Common values: awslogs, json-file, syslog, journald, gelf, fluentd
      # For ECS, awslogs is the most common choice for CloudWatch Logs integration.
      log_driver = "awslogs"

      # (Optional) Configuration options to send to the log driver
      #
      # Options vary depending on the log driver. For awslogs, you typically
      # specify the log group, region, and stream prefix.
      options = {
        "awslogs-group"         = "/ecs/service-connect"
        "awslogs-region"        = "us-east-1"
        "awslogs-stream-prefix" = "sc"
      }

      # ------------------------------------------------
      # Nested Block: secret_option
      # ------------------------------------------------
      # (Optional) Secrets to pass to the log configuration
      # Nesting mode: list

      secret_option {
        # (Required) Name of the secret
        #
        # The name used to reference this secret in the log configuration.
        name = "log-secret"

        # (Required) Secret to expose to the container
        #
        # The full ARN of the AWS Secrets Manager secret or the full ARN of
        # the parameter in the SSM Parameter Store.
        value_from = "arn:aws:secretsmanager:us-east-1:123456789012:secret:log-credentials-abc123"
      }
    }

    # --------------------------------------------------------
    # Nested Block: service
    # --------------------------------------------------------
    # (Optional) List of Service Connect service objects
    # Nesting mode: list
    #
    # For services that run network applications and expose endpoints, you
    # configure at least one service object. For client-only services, you
    # can omit this block.

    service {
      # (Required) Name of one of the portMappings from the task definition
      #
      # This references a port mapping defined in your task definition.
      # Service Connect will create an endpoint for this port.
      port_name = "http"

      # (Optional) Name of the new AWS Cloud Map service that Amazon ECS creates
      #
      # If not specified, the port_name is used as the discovery name.
      # This is the intermediate name used to create the Cloud Map service.
      discovery_name = "web-service"

      # (Optional) Port number for the Service Connect proxy to listen on
      #
      # If specified, the Service Connect proxy will listen on this port
      # instead of the port defined in the task definition.
      ingress_port_override = 8080

      # ------------------------------------------------
      # Nested Block: client_alias
      # ------------------------------------------------
      # (Optional) List of client aliases for this Service Connect service
      # Max items: 1
      #
      # Client aliases define the names and ports that client applications
      # use to connect to this service. You should specify exactly one
      # client_alias when enabled is true.

      client_alias {
        # (Required) Listening port number for the Service Connect proxy
        #
        # This port is available inside all tasks within the same namespace.
        # Client applications use this port to connect to the service.
        port = 80

        # (Optional) Name that you use in client applications to connect to
        # this service
        #
        # If not specified, the discovery_name is used. This becomes the DNS
        # name that clients use to connect.
        dns_name = "web.local"

        # ------------------------------------------------
        # Nested Block: test_traffic_rules
        # ------------------------------------------------
        # (Optional) Configuration for test traffic routing rules
        # Nesting mode: list

        test_traffic_rules {
          # ------------------------------------------------
          # Nested Block: header
          # ------------------------------------------------
          # (Optional) Configuration for header-based routing rules
          # Max items: 1

          header {
            # (Required) Name of the HTTP header to match
            #
            # Test traffic can be routed based on HTTP header values,
            # allowing you to test new versions with specific requests.
            name = "X-Test-Version"

            # ------------------------------------------------
            # Nested Block: value
            # ------------------------------------------------
            # (Required) Configuration for header value matching criteria
            # Min items: 1
            # Max items: 1

            value {
              # (Required) Exact string value to match in the header
              #
              # Requests with this exact header value will be routed as test traffic.
              exact = "canary"
            }
          }
        }
      }

      # ------------------------------------------------
      # Nested Block: timeout
      # ------------------------------------------------
      # (Optional) Configuration timeouts for Service Connect
      # Max items: 1

      timeout {
        # (Optional) Amount of time in seconds a connection will stay active while idle
        #
        # A value of 0 can be set to disable idleTimeout.
        # This prevents connections from being closed due to inactivity.
        idle_timeout_seconds = 300

        # (Optional) Amount of time in seconds for the upstream to respond
        # with a complete response per request
        #
        # A value of 0 can be set to disable perRequestTimeout.
        # Can only be set when appProtocol isn't TCP.
        # This ensures requests don't hang indefinitely.
        per_request_timeout_seconds = 60
      }

      # ------------------------------------------------
      # Nested Block: tls
      # ------------------------------------------------
      # (Optional) Configuration for enabling Transport Layer Security (TLS)
      # Max items: 1
      #
      # TLS configuration enables encrypted communication between services.

      tls {
        # (Optional) KMS key used to encrypt the private key in Secrets Manager
        #
        # The KMS key ARN used to encrypt the TLS private key stored in
        # AWS Secrets Manager.
        kms_key = "arn:aws:kms:us-east-1:123456789012:key/abc12345-1234-1234-1234-123456789012"

        # (Optional) ARN of the IAM Role associated with Service Connect TLS
        #
        # This role allows Service Connect to access the certificate authority
        # and manage certificates.
        role_arn = "arn:aws:iam::123456789012:role/ecs-service-connect-tls-role"

        # ------------------------------------------------
        # Nested Block: issuer_cert_authority
        # ------------------------------------------------
        # (Required) Details of the certificate authority which will issue the certificate
        # Min items: 1
        # Max items: 1

        issuer_cert_authority {
          # (Required) ARN of the aws_acmpca_certificate_authority used to
          # create the TLS Certificates
          #
          # This is the AWS Certificate Manager Private Certificate Authority
          # that will issue certificates for TLS connections.
          aws_pca_authority_arn = "arn:aws:acm-pca:us-east-1:123456789012:certificate-authority/abc12345-1234-1234-1234-123456789012"
        }
      }
    }
  }

  # ============================================================
  # BLOCK: service_registries
  # ============================================================
  # (Optional) Service discovery registries for the service
  # Max items: 1
  #
  # Service registries enable service discovery using AWS Cloud Map. This
  # allows other services to discover and connect to your service using DNS
  # or API-based service discovery.
  #
  # AWS Documentation:
  # https://docs.aws.amazon.com/Route53/latest/APIReference/API_autonaming_Service.html

  service_registries {
    # (Required) ARN of the Service Registry
    #
    # The currently supported service registry is Amazon Route 53 Auto Naming
    # Service (aws_service_discovery_service).
    registry_arn = "arn:aws:servicediscovery:us-east-1:123456789012:service/srv-abc123"

    # (Optional) Container name value, already specified in the task definition,
    # to be used for your service discovery service
    #
    # If the task definition uses the bridge or host network mode, the
    # container_name and container_port combination must be specified.
    container_name = "web-container"

    # (Optional) Port value, already specified in the task definition, to be
    # used for your service discovery service
    #
    # If the task definition uses the bridge or host network mode, the
    # container_name and container_port combination must be specified.
    container_port = 80

    # (Optional) Port value used if your Service Discovery service specified
    # an SRV record
    #
    # This port is used when the service registry uses SRV records for
    # service discovery.
    port = 80
  }

  # ============================================================
  # BLOCK: volume_configuration
  # ============================================================
  # (Optional) Configuration for volumes specified in the task definition that
  # are configured at launch time
  # Max items: 1
  #
  # Currently, the only supported volume type is an Amazon EBS volume. This
  # allows you to attach EBS volumes to ECS tasks for persistent storage.

  volume_configuration {
    # (Required) Name of the volume
    #
    # Must match a volume name defined in the task definition. This is the
    # volume that will be configured with the managed EBS settings.
    name = "data-volume"

    # --------------------------------------------------------
    # Nested Block: managed_ebs_volume
    # --------------------------------------------------------
    # (Required) Configuration for the Amazon EBS volume that Amazon ECS
    # creates and manages
    # Min items: 1
    # Max items: 1

    managed_ebs_volume {
      # (Required) Amazon ECS infrastructure IAM role that manages your
      # Amazon Web Services infrastructure
      #
      # Recommended using the Amazon ECS-managed
      # AmazonECSInfrastructureRolePolicyForVolumes IAM policy with this role.
      role_arn = "arn:aws:iam::123456789012:role/ecsInfrastructureRole"

      # (Optional) Whether the volume should be encrypted
      #
      # Default: true
      # When enabled, the volume is encrypted using the specified KMS key or
      # the default AWS managed key.
      encrypted = true

      # (Optional) Amazon Resource Name (ARN) identifier of the AWS Key
      # Management Service key to use for Amazon EBS encryption
      #
      # If not specified, the default AWS managed key for EBS is used.
      kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/abc12345-1234-1234-1234-123456789012"

      # (Optional) Size of the volume in GiB
      #
      # You must specify either size_in_gb or snapshot_id.
      # You can optionally specify a volume size greater than or equal to the
      # snapshot size.
      size_in_gb = 100

      # (Optional) Snapshot that Amazon ECS uses to create the volume
      #
      # You must specify either size_in_gb or snapshot_id.
      # When using a snapshot, you can optionally specify a larger size_in_gb.
      snapshot_id = "snap-0123456789abcdef0"

      # (Optional) Volume type
      #
      # Valid values: gp2, gp3, io1, io2, sc1, st1, standard
      # Different volume types offer different performance characteristics
      # and pricing.
      volume_type = "gp3"

      # (Optional) Number of I/O operations per second (IOPS)
      #
      # Required for io1 and io2 volume types. Optional for gp3.
      # Valid range depends on volume type and size.
      iops = 3000

      # (Optional) Throughput to provision for a volume, in MiB/s
      #
      # Only valid for gp3 volume types.
      # Valid range: 125-1000 MiB/s
      throughput = 125

      # (Optional) Linux filesystem type for the volume
      #
      # Valid values: ext3, ext4, xfs
      # Default: xfs
      #
      # For volumes created from a snapshot, the same filesystem type must be
      # specified that the volume was using when the snapshot was created.
      file_system_type = "xfs"

      # (Optional) Volume Initialization Rate in MiB/s
      #
      # You must also specify a snapshot_id when using this parameter.
      # This controls how fast data is restored from the snapshot.
      volume_initialization_rate = 500

      # ------------------------------------------------
      # Nested Block: tag_specifications
      # ------------------------------------------------
      # (Optional) The tags to apply to the volume
      # Nesting mode: list

      tag_specifications {
        # (Required) The type of volume resource
        #
        # Valid values: volume
        resource_type = "volume"

        # (Optional) The tags applied to this Amazon EBS volume
        #
        # AmazonECSCreated and AmazonECSManaged are reserved tags that can't be used.
        tags = {
          Name        = "ecs-task-volume"
          Environment = "production"
        }

        # (Optional) Determines whether to propagate tags from the task
        # definition to the Amazon EBS volume
        #
        # Valid values: TASK_DEFINITION, SERVICE, NONE
        propagate_tags = "TASK_DEFINITION"
      }
    }
  }

  # ============================================================
  # BLOCK: vpc_lattice_configurations
  # ============================================================
  # (Optional) VPC Lattice configuration for your service
  # Nesting mode: set
  #
  # VPC Lattice allows you to connect, secure, and monitor services across
  # multiple accounts and VPCs. It's a managed application networking service
  # that simplifies service-to-service communication.
  #
  # AWS Documentation:
  # https://docs.aws.amazon.com/vpc-lattice/latest/ug/what-is-vpc-lattice.html

  vpc_lattice_configurations {
    # (Required) The name of the port for a target group associated with the
    # VPC Lattice configuration
    #
    # This should match a port name defined in your task definition.
    port_name = "http"

    # (Required) The ARN of the IAM role to associate with this volume
    #
    # This is the Amazon ECS infrastructure IAM role used to manage your
    # AWS infrastructure.
    role_arn = "arn:aws:iam::123456789012:role/ecsVpcLatticeRole"

    # (Required) The full ARN of the target group or groups associated with
    # the VPC Lattice configuration
    #
    # VPC Lattice target groups define how traffic is routed to your service.
    target_group_arn = "arn:aws:vpc-lattice:us-east-1:123456789012:targetgroup/tg-abc123"
  }

  # ============================================================
  # BLOCK: timeouts
  # ============================================================
  # (Optional) Configuration block for operation timeouts
  #
  # These timeouts allow you to customize how long Terraform will wait for
  # service operations to complete.

  timeouts {
    # (Optional) Timeout for service creation
    #
    # Default: 20 minutes
    # Format: "20m", "1h", etc.
    create = "20m"

    # (Optional) Timeout for service updates
    #
    # Default: 20 minutes
    # Format: "20m", "1h", etc.
    update = "20m"

    # (Optional) Timeout for service deletion
    #
    # Default: 20 minutes
    # Format: "20m", "1h", etc.
    delete = "20m"
  }

  # ============================================================
  # COMPUTED ATTRIBUTES (Read-only)
  # ============================================================
  # These attributes are automatically set by AWS and can be referenced
  # in other resources:
  #
  # - arn: ARN that identifies the service
  #   Example: aws_ecs_service.example.arn
  #
  # - id: Service ARN (same as arn)
  #   Example: aws_ecs_service.example.id
  #
  # - tags_all: Map of tags assigned to the resource, including those
  #   inherited from the provider default_tags configuration block
  #   Example: aws_ecs_service.example.tags_all
  # ============================================================
}

# ============================================================
# EXAMPLE CONFIGURATIONS
# ============================================================

# Example 1: Simple Fargate Service
# resource "aws_ecs_service" "fargate_simple" {
#   name            = "fargate-service"
#   cluster         = aws_ecs_cluster.main.id
#   task_definition = aws_ecs_task_definition.app.arn
#   desired_count   = 2
#   launch_type     = "FARGATE"
#
#   network_configuration {
#     subnets          = aws_subnet.private[*].id
#     security_groups  = [aws_security_group.ecs_tasks.id]
#     assign_public_ip = false
#   }
# }

# Example 2: Service with Load Balancer
# resource "aws_ecs_service" "with_alb" {
#   name            = "web-service"
#   cluster         = aws_ecs_cluster.main.id
#   task_definition = aws_ecs_task_definition.web.arn
#   desired_count   = 3
#   launch_type     = "FARGATE"
#
#   load_balancer {
#     target_group_arn = aws_lb_target_group.app.arn
#     container_name   = "web"
#     container_port   = 80
#   }
#
#   network_configuration {
#     subnets         = aws_subnet.private[*].id
#     security_groups = [aws_security_group.ecs_tasks.id]
#   }
#
#   health_check_grace_period_seconds = 60
#
#   depends_on = [aws_lb_listener.front_end]
# }

# Example 3: DAEMON Scheduling Strategy
# resource "aws_ecs_service" "daemon" {
#   name                = "monitoring-daemon"
#   cluster             = aws_ecs_cluster.main.id
#   task_definition     = aws_ecs_task_definition.monitor.arn
#   scheduling_strategy = "DAEMON"
#   launch_type         = "EC2"
# }

# Example 4: Service with Capacity Provider Strategy
# resource "aws_ecs_service" "mixed_capacity" {
#   name            = "mixed-service"
#   cluster         = aws_ecs_cluster.main.id
#   task_definition = aws_ecs_task_definition.app.arn
#   desired_count   = 10
#
#   capacity_provider_strategy {
#     capacity_provider = "FARGATE"
#     base              = 2
#     weight            = 1
#   }
#
#   capacity_provider_strategy {
#     capacity_provider = "FARGATE_SPOT"
#     weight            = 3
#   }
#
#   network_configuration {
#     subnets         = aws_subnet.private[*].id
#     security_groups = [aws_security_group.ecs_tasks.id]
#   }
# }

# Example 5: Service with Auto-scaling Ignore Changes
# resource "aws_ecs_service" "autoscaled" {
#   name            = "autoscaled-service"
#   cluster         = aws_ecs_cluster.main.id
#   task_definition = aws_ecs_task_definition.app.arn
#   desired_count   = 2
#   launch_type     = "FARGATE"
#
#   network_configuration {
#     subnets         = aws_subnet.private[*].id
#     security_groups = [aws_security_group.ecs_tasks.id]
#   }
#
#   lifecycle {
#     ignore_changes = [desired_count]
#   }
# }

# Example 6: Blue/Green Deployment with CodeDeploy
# resource "aws_ecs_service" "blue_green" {
#   name            = "blue-green-service"
#   cluster         = aws_ecs_cluster.main.id
#   task_definition = aws_ecs_task_definition.app.arn
#   desired_count   = 3
#   launch_type     = "FARGATE"
#
#   deployment_controller {
#     type = "CODE_DEPLOY"
#   }
#
#   load_balancer {
#     target_group_arn = aws_lb_target_group.blue.arn
#     container_name   = "app"
#     container_port   = 80
#   }
#
#   network_configuration {
#     subnets         = aws_subnet.private[*].id
#     security_groups = [aws_security_group.ecs_tasks.id]
#   }
#
#   lifecycle {
#     ignore_changes = [task_definition, load_balancer]
#   }
# }

# Example 7: Service with Circuit Breaker
# resource "aws_ecs_service" "circuit_breaker" {
#   name            = "resilient-service"
#   cluster         = aws_ecs_cluster.main.id
#   task_definition = aws_ecs_task_definition.app.arn
#   desired_count   = 2
#   launch_type     = "FARGATE"
#
#   deployment_circuit_breaker {
#     enable   = true
#     rollback = true
#   }
#
#   network_configuration {
#     subnets         = aws_subnet.private[*].id
#     security_groups = [aws_security_group.ecs_tasks.id]
#   }
# }

