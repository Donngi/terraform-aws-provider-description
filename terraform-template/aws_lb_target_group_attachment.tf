# ==============================================================================
# Terraform AWS Provider Resource: aws_lb_target_group_attachment
# Provider Version: 6.28.0
# ==============================================================================
#
# Description:
# Provides the ability to register instances and containers with an Application
# Load Balancer (ALB) or Network Load Balancer (NLB) target group. For attaching
# resources with Elastic Load Balancer (ELB), see the aws_elb_attachment resource.
#
# Note: aws_alb_target_group_attachment is known as aws_lb_target_group_attachment.
# The functionality is identical.
#
# ==============================================================================
# AWS Documentation:
# - Target Groups for Application Load Balancers:
#   https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-target-groups.html
# - Register Targets with Target Group:
#   https://docs.aws.amazon.com/elasticloadbalancing/latest/application/target-group-register-targets.html
# - RegisterTargets API:
#   https://docs.aws.amazon.com/elasticloadbalancing/latest/APIReference/API_RegisterTargets.html
# ==============================================================================

resource "aws_lb_target_group_attachment" "example" {
  # ============================================================================
  # REQUIRED ARGUMENTS
  # ============================================================================

  # target_group_arn - (Required)
  # The ARN of the target group with which to register targets.
  # Type: string
  #
  # The target group must already exist and be configured with the appropriate
  # target type (instance, ip, or lambda). This attachment will register the
  # specified target with this target group, allowing the load balancer to
  # route traffic to it.
  #
  # Example values:
  # - "arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/my-targets/50dc6c495c0c9188"
  # - aws_lb_target_group.example.arn
  target_group_arn = "arn:aws:elasticloadbalancing:REGION:ACCOUNT-ID:targetgroup/TARGET-GROUP-NAME/ID"

  # target_id - (Required)
  # The ID of the target. This is the Instance ID for an instance, or the IP
  # address for an IP target, or the ARN for a Lambda target.
  # Type: string
  #
  # Supported target types:
  # - Instance ID: "i-1234567890abcdef0" (for target_type = "instance")
  # - IP address: "10.0.1.5" (for target_type = "ip")
  # - Lambda ARN: "arn:aws:lambda:us-east-1:123456789012:function:my-function"
  #   (for target_type = "lambda")
  #
  # Requirements by target type:
  # - instance: Must be in the same VPC as the target group and in running state
  # - ip: Must be from RFC 1918 (10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16),
  #   RFC 6598 (100.64.0.0/10), or RFC 4193 (IPv6) CIDR blocks
  # - lambda: Lambda function must grant permission to elasticloadbalancing.amazonaws.com
  #
  # Example values:
  # - aws_instance.example.id (for EC2 instance)
  # - "10.0.1.5" (for IP address)
  # - aws_lambda_function.example.arn (for Lambda function)
  target_id = "TARGET-ID-HERE"

  # ============================================================================
  # OPTIONAL ARGUMENTS
  # ============================================================================

  # port - (Optional)
  # The port on which targets receive traffic.
  # Type: number
  # Valid values: 1-65535
  #
  # This is optional and can override the port specified in the target group.
  # If not specified, traffic is sent to the target on the target group's port.
  # Not applicable for Lambda targets.
  #
  # Use cases:
  # - Different instances in the target group listening on different ports
  # - Dynamic port assignment in container environments (e.g., ECS)
  # - Testing scenarios where you need to override the default port
  #
  # Example values:
  # - 80 (HTTP)
  # - 443 (HTTPS)
  # - 8080 (alternative HTTP port)
  # - 3000 (application server port)
  # port = 80

  # availability_zone - (Optional)
  # The Availability Zone where the IP address of the target is to be registered.
  # Type: string
  #
  # Required when the target is an IP address outside of the VPC scope.
  # Must be set to "all" if the private IP address is outside of the VPC scope.
  #
  # Use cases:
  # - Registering on-premises servers via AWS Direct Connect or VPN
  # - Registering targets in peered VPCs
  # - Cross-zone load balancing scenarios
  #
  # Example values:
  # - "us-east-1a"
  # - "us-west-2b"
  # - "all" (for IP addresses outside VPC scope)
  # availability_zone = null

  # quic_server_id - (Optional)
  # Server ID for the targets, consisting of the 0x prefix followed by 16
  # hexadecimal characters.
  # Type: string
  # Format: "0x" + 16 hex characters
  #
  # Required if aws_lb_target_group protocol is "QUIC" or "TCP_QUIC".
  # Not valid with other protocols.
  # The value must be unique at the listener level.
  # Forces replacement if modified.
  #
  # QUIC (Quick UDP Internet Connections) is a transport protocol that provides:
  # - Reduced connection establishment latency
  # - Improved performance on lossy networks
  # - Connection migration support
  #
  # Example values:
  # - "0x1a2b3c4d5e6f7a8b"
  # - "0x0123456789abcdef"
  # quic_server_id = null

  # region - (Optional)
  # Region where this resource will be managed.
  # Type: string
  #
  # Defaults to the Region set in the provider configuration.
  # Use this to override the provider's region for this specific resource.
  #
  # Example values:
  # - "us-east-1"
  # - "eu-west-1"
  # - "ap-southeast-1"
  # region = null

  # ============================================================================
  # ATTRIBUTES REFERENCE
  # ============================================================================
  # The following attributes are exported:
  #
  # - id - A unique identifier for the attachment
  #        Format: {target_group_arn}/{target_id}/{port}

  # ============================================================================
  # LIFECYCLE CONSIDERATIONS
  # ============================================================================
  #
  # Target Registration:
  # - Targets begin receiving traffic after they pass initial health checks
  # - Initial health check typically takes 30-60 seconds depending on configuration
  # - Connection draining (deregistration delay) applies when removing targets
  #
  # Target Deregistration:
  # - When a target is deregistered, the load balancer waits for in-flight
  #   requests to complete (deregistration delay, default 300 seconds)
  # - For IP targets, observe deregistration delay before registering the
  #   same IP address again
  #
  # Replacement Triggers:
  # - Changing quic_server_id forces replacement
  # - Changing target_group_arn forces replacement
  # - Changing target_id forces replacement
  #
  # Dependencies:
  # - For Lambda targets, ensure aws_lambda_permission is created first using
  #   depends_on to grant invoke permission to elasticloadbalancing.amazonaws.com
  #
  # Health Checks:
  # - Health check settings are configured on the target group, not the attachment
  # - Unhealthy targets are automatically removed from the load balancer rotation
  # - Health status can be monitored via CloudWatch metrics
}

# ==============================================================================
# EXAMPLE USAGE SCENARIOS
# ==============================================================================

# Example 1: Basic EC2 Instance Target
# ------------------------------------------------------------------------------
# Register a single EC2 instance with an Application Load Balancer target group.
# The instance will receive traffic on port 80.

# resource "aws_lb_target_group_attachment" "example_instance" {
#   target_group_arn = aws_lb_target_group.app.arn
#   target_id        = aws_instance.web.id
#   port             = 80
# }
#
# resource "aws_lb_target_group" "app" {
#   name     = "app-target-group"
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.main.id
#
#   health_check {
#     enabled             = true
#     healthy_threshold   = 2
#     interval            = 30
#     matcher             = "200"
#     path                = "/health"
#     port                = "traffic-port"
#     protocol            = "HTTP"
#     timeout             = 5
#     unhealthy_threshold = 2
#   }
# }
#
# resource "aws_instance" "web" {
#   ami           = "ami-0c55b159cbfafe1f0"
#   instance_type = "t3.micro"
#   # ... other configuration ...
# }

# Example 2: Lambda Function Target
# ------------------------------------------------------------------------------
# Register a Lambda function with an Application Load Balancer target group.
# Requires proper Lambda permissions for ELB to invoke the function.

# resource "aws_lambda_permission" "with_lb" {
#   statement_id  = "AllowExecutionFromLB"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.api.function_name
#   principal     = "elasticloadbalancing.amazonaws.com"
#   source_arn    = aws_lb_target_group.lambda.arn
# }
#
# resource "aws_lb_target_group" "lambda" {
#   name        = "lambda-target-group"
#   target_type = "lambda"
# }
#
# resource "aws_lambda_function" "api" {
#   filename      = "lambda.zip"
#   function_name = "api_handler"
#   role          = aws_iam_role.lambda.arn
#   handler       = "index.handler"
#   runtime       = "python3.11"
# }
#
# resource "aws_lb_target_group_attachment" "lambda" {
#   target_group_arn = aws_lb_target_group.lambda.arn
#   target_id        = aws_lambda_function.api.arn
#   depends_on       = [aws_lambda_permission.with_lb]
# }

# Example 3: IP Address Target
# ------------------------------------------------------------------------------
# Register an IP address (e.g., container, on-premises server) with a target group.

# resource "aws_lb_target_group" "ip_based" {
#   name        = "ip-target-group"
#   port        = 8080
#   protocol    = "HTTP"
#   target_type = "ip"
#   vpc_id      = aws_vpc.main.id
# }
#
# resource "aws_lb_target_group_attachment" "ip_target" {
#   target_group_arn = aws_lb_target_group.ip_based.arn
#   target_id        = "10.0.1.100"
#   port             = 8080
# }

# Example 4: Multiple Instances with for_each
# ------------------------------------------------------------------------------
# Register multiple EC2 instances with a target group using for_each.
# This pattern is useful for auto-scaled or dynamically created instances.

# resource "aws_instance" "web_servers" {
#   count         = 3
#   ami           = "ami-0c55b159cbfafe1f0"
#   instance_type = "t3.micro"
#   # ... other configuration ...
# }
#
# resource "aws_lb_target_group" "web" {
#   name     = "web-target-group"
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.main.id
# }
#
# resource "aws_lb_target_group_attachment" "web_servers" {
#   # Convert a list of instance objects to a map with instance ID as the key
#   for_each = {
#     for k, v in aws_instance.web_servers :
#     k => v
#   }
#
#   target_group_arn = aws_lb_target_group.web.arn
#   target_id        = each.value.id
#   port             = 80
# }

# Example 5: QUIC Protocol Target
# ------------------------------------------------------------------------------
# Register a target with QUIC protocol support (Network Load Balancer).
# QUIC provides improved performance for applications requiring low latency.

# resource "aws_lb_target_group" "quic" {
#   name     = "quic-target-group"
#   port     = 443
#   protocol = "QUIC"
#   vpc_id   = aws_vpc.main.id
#
#   health_check {
#     enabled             = true
#     protocol            = "HTTP"
#     port                = "traffic-port"
#     path                = "/health"
#     interval            = 30
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#   }
# }
#
# resource "aws_lb_target_group_attachment" "quic_target" {
#   target_group_arn = aws_lb_target_group.quic.arn
#   target_id        = aws_instance.quic_server.id
#   port             = 443
#   quic_server_id   = "0x1a2b3c4d5e6f7a8b"
# }
#
# resource "aws_instance" "quic_server" {
#   ami           = "ami-0c55b159cbfafe1f0"
#   instance_type = "t3.micro"
#   # ... other configuration ...
# }

# Example 6: Cross-Zone IP Target
# ------------------------------------------------------------------------------
# Register an IP address from outside the VPC (e.g., on-premises via Direct Connect).

# resource "aws_lb_target_group" "hybrid" {
#   name        = "hybrid-target-group"
#   port        = 443
#   protocol    = "HTTPS"
#   target_type = "ip"
#   vpc_id      = aws_vpc.main.id
# }
#
# resource "aws_lb_target_group_attachment" "on_premises" {
#   target_group_arn  = aws_lb_target_group.hybrid.arn
#   target_id         = "192.168.100.50"  # On-premises IP
#   port              = 443
#   availability_zone = "all"  # Required for IP outside VPC
# }

# ==============================================================================
# BEST PRACTICES AND RECOMMENDATIONS
# ==============================================================================
#
# 1. Health Check Configuration:
#    - Configure appropriate health check intervals and thresholds on the
#      target group to ensure timely detection of unhealthy targets
#    - Use application-specific health check endpoints (e.g., /health, /ping)
#    - Set realistic timeout values based on application response times
#
# 2. Deregistration Delay:
#    - Adjust deregistration_delay on the target group based on your
#      application's typical request duration
#    - Default is 300 seconds; reduce for short-lived requests, increase
#      for long-running operations
#
# 3. Security Groups:
#    - Ensure target instances/IPs have security groups allowing traffic
#      from the load balancer's security group
#    - For NLB, configure target security groups to allow traffic from
#      the client IPs or VPC CIDR
#
# 4. Lambda Targets:
#    - Always use depends_on to ensure Lambda permissions are created
#      before the target group attachment
#    - Verify Lambda function timeout is less than the target group's
#      deregistration delay
#    - Configure appropriate concurrency limits on the Lambda function
#
# 5. IP Targets:
#    - Ensure IP addresses are from allowed CIDR blocks (RFC 1918, etc.)
#    - For on-premises targets, verify network connectivity via Direct
#      Connect, VPN, or peering
#    - Use availability_zone = "all" for cross-VPC or on-premises targets
#
# 6. Dynamic Registration:
#    - Use for_each or count for registering multiple targets dynamically
#    - Consider using Auto Scaling Groups with target group integration
#      instead of manual attachments for EC2 instances
#    - For ECS, use awsvpc network mode with target type = "ip"
#
# 7. Monitoring and Observability:
#    - Monitor CloudWatch metrics for target health:
#      * HealthyHostCount
#      * UnHealthyHostCount
#      * TargetResponseTime
#    - Set up CloudWatch alarms for unhealthy target detection
#    - Use AWS X-Ray for distributed tracing in microservices
#
# 8. QUIC Protocol Considerations:
#    - QUIC is only supported with Network Load Balancers
#    - Ensure quic_server_id is unique across all targets in the listener
#    - QUIC requires UDP protocol support in security groups and NACLs
#    - Consider using QUIC for applications requiring low latency and
#      connection migration (e.g., mobile apps, video streaming)
#
# 9. Blue/Green Deployments:
#    - Create separate target groups for blue and green environments
#    - Use weighted target groups in listener rules for gradual traffic shift
#    - Test thoroughly in the green environment before full cutover
#
# 10. Cost Optimization:
#     - Minimize cross-AZ data transfer by using same-AZ targets when possible
#     - For NLB, disable cross-zone load balancing if not needed
#     - Right-size target instances based on actual traffic patterns
#     - Use Lambda targets for event-driven workloads to reduce always-on costs
#
# ==============================================================================
# COMMON ERRORS AND TROUBLESHOOTING
# ==============================================================================
#
# Error: "Target is in Availability Zone that is not enabled for the load balancer"
# Solution: Ensure the target's AZ is enabled in the load balancer's subnet configuration
#
# Error: "Target is not in the same VPC as the load balancer"
# Solution: For instance targets, verify VPC match; for IP targets, use availability_zone
#
# Error: "InvalidTarget: The target must be in the 'running' state"
# Solution: Ensure EC2 instances are in running state before registration
#
# Error: "InvalidPermission: Lambda function permission not found"
# Solution: Create aws_lambda_permission before attachment, use depends_on
#
# Error: "Targets may not be duplicated in a target group"
# Solution: Ensure each target ID is unique within the target group; check for duplicate attachments
#
# Unhealthy Targets:
# - Verify security group rules allow traffic from load balancer
# - Check health check configuration (path, port, protocol)
# - Ensure application is listening on the specified port
# - Review VPC route tables and network ACLs
# - Check application logs for health check endpoint errors
#
# Connection Timeouts:
# - Verify network connectivity between load balancer and targets
# - Check security groups and NACLs for blocking rules
# - Ensure target application is responding within timeout period
# - For cross-region setups, verify VPC peering or Transit Gateway configuration
#
# ==============================================================================
# ADDITIONAL RESOURCES
# ==============================================================================
#
# Terraform Documentation:
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment
#
# AWS Documentation:
# - Target Group Documentation:
#   https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-target-groups.html
# - Register Targets:
#   https://docs.aws.amazon.com/elasticloadbalancing/latest/application/target-group-register-targets.html
# - Health Checks:
#   https://docs.aws.amazon.com/elasticloadbalancing/latest/application/target-group-health-checks.html
# - Lambda as Target:
#   https://docs.aws.amazon.com/elasticloadbalancing/latest/application/lambda-functions.html
# - QUIC Protocol Support:
#   https://docs.aws.amazon.com/elasticloadbalancing/latest/network/load-balancer-target-groups.html
#
# ==============================================================================
