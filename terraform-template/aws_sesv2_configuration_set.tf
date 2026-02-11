# ============================================================
# Terraform AWS Resource Template
# ============================================================
# Resource Type: aws_sesv2_configuration_set
# Provider Version: 6.28.0
# Description: Terraform resource for managing an AWS SESv2 (Simple Email V2) Configuration Set.
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sesv2_configuration_set
# ============================================================

resource "aws_sesv2_configuration_set" "example" {
  # ============================================================
  # Required Arguments
  # ============================================================

  # (Required) The name of the configuration set.
  # Type: string
  configuration_set_name = "example"

  # ============================================================
  # Optional Arguments
  # ============================================================

  # (Optional) Region where this resource will be managed.
  # Defaults to the Region set in the provider configuration.
  # Type: string
  # Default: Provider region
  # region = "us-east-1"

  # (Optional) A map of tags to assign to the service.
  # If configured with a provider default_tags configuration block present,
  # tags with matching keys will overwrite those defined at the provider-level.
  # Type: map(string)
  # tags = {
  #   Name        = "example"
  #   Environment = "production"
  # }

  # ============================================================
  # Optional Block: delivery_options
  # ============================================================
  # (Optional) An object that defines the dedicated IP pool that is used
  # to send emails that you send using the configuration set.

  delivery_options {
    # (Optional) The maximum amount of time, in seconds, that Amazon SES API v2
    # will attempt delivery of email. If specified, the value must be greater
    # than or equal to 300 seconds (5 minutes) and less than or equal to
    # 50400 seconds (840 minutes).
    # Type: number
    # Valid Range: 300-50400
    max_delivery_seconds = 300

    # (Optional) The name of the dedicated IP pool to associate with the
    # configuration set.
    # Type: string
    # sending_pool_name = "example-pool"

    # (Optional) Specifies whether messages that use the configuration set
    # are required to use Transport Layer Security (TLS).
    # Type: string
    # Valid Values: REQUIRE, OPTIONAL
    tls_policy = "REQUIRE"
  }

  # ============================================================
  # Optional Block: reputation_options
  # ============================================================
  # (Optional) An object that defines whether or not Amazon SES collects
  # reputation metrics for the emails that you send that use the configuration set.

  reputation_options {
    # (Optional) If true, tracking of reputation metrics is enabled for the
    # configuration set. If false, tracking of reputation metrics is disabled
    # for the configuration set.
    # Type: bool
    reputation_metrics_enabled = false

    # Computed Attribute:
    # last_fresh_start - The date and time (in Unix time) when the reputation
    # metrics were last given a fresh start. When your account is given a fresh
    # start, your reputation metrics are calculated starting from the date of
    # the fresh start.
  }

  # ============================================================
  # Optional Block: sending_options
  # ============================================================
  # (Optional) An object that defines whether or not Amazon SES can send email
  # that you send using the configuration set.

  sending_options {
    # (Optional) If true, email sending is enabled for the configuration set.
    # If false, email sending is disabled for the configuration set.
    # Type: bool
    sending_enabled = true
  }

  # ============================================================
  # Optional Block: suppression_options
  # ============================================================
  # (Optional) An object that contains information about the suppression list
  # preferences for your account.

  suppression_options {
    # (Optional) A list that contains the reasons that email addresses are
    # automatically added to the suppression list for your account.
    # Type: list(string)
    # Valid Values: BOUNCE, COMPLAINT
    suppressed_reasons = ["BOUNCE", "COMPLAINT"]
  }

  # ============================================================
  # Optional Block: tracking_options
  # ============================================================
  # (Optional) An object that defines the open and click tracking options
  # for emails that you send using the configuration set.

  tracking_options {
    # (Required) The domain to use for tracking open and click events.
    # Type: string
    custom_redirect_domain = "example.com"

    # (Optional) Specifies whether to use HTTPS for tracking open and click events.
    # Type: string
    # Valid Values: REQUIRE, OPTIONAL
    # https_policy = "REQUIRE"
  }

  # ============================================================
  # Optional Block: vdm_options
  # ============================================================
  # (Optional) An object that defines the VDM settings that apply to emails
  # that you send using the configuration set.

  # vdm_options {
  #   # Optional Block: dashboard_options
  #   # Specifies additional settings for your VDM configuration as applicable
  #   # to the Dashboard.
  #   dashboard_options {
  #     # (Optional) Specifies the status of your VDM engagement metrics collection.
  #     # Type: string
  #     # Valid Values: ENABLED, DISABLED
  #     engagement_metrics = "ENABLED"
  #   }
  #
  #   # Optional Block: guardian_options
  #   # Specifies additional settings for your VDM configuration as applicable
  #   # to the Guardian.
  #   guardian_options {
  #     # (Optional) Specifies the status of your VDM optimized shared delivery.
  #     # Type: string
  #     # Valid Values: ENABLED, DISABLED
  #     optimized_shared_delivery = "ENABLED"
  #   }
  # }
}

# ============================================================
# Outputs
# ============================================================

output "configuration_set_arn" {
  description = "ARN of the Configuration Set"
  value       = aws_sesv2_configuration_set.example.arn
}

output "configuration_set_id" {
  description = "ID of the Configuration Set"
  value       = aws_sesv2_configuration_set.example.id
}

output "configuration_set_name" {
  description = "Name of the Configuration Set"
  value       = aws_sesv2_configuration_set.example.configuration_set_name
}

output "reputation_last_fresh_start" {
  description = "The date and time when the reputation metrics were last given a fresh start"
  value       = aws_sesv2_configuration_set.example.reputation_options[0].last_fresh_start
}

# ============================================================
# Additional Notes
# ============================================================
# - Amazon SES Configuration Sets allow you to organize email sending
#   into groups with different settings.
# - Configuration sets can be used to track metrics, manage IP pools,
#   and control email sending behavior.
# - The reputation_options block helps monitor your sender reputation.
# - The suppression_options block helps manage bounces and complaints.
# - VDM (Virtual Deliverability Manager) options provide advanced
#   deliverability insights and optimizations.
# ============================================================
