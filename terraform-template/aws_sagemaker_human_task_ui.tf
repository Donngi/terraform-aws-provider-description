################################################################################
# AWS SageMaker Human Task UI
################################################################################
# Purpose:
#   Provides a SageMaker AI Human Task UI resource for custom labeling workflows.
#   This resource allows you to define custom user interfaces for human annotators
#   working on SageMaker Ground Truth labeling jobs.
#
# Key Features:
#   - Custom UI templates using Liquid templating language
#   - Integration with SageMaker Ground Truth labeling workflows
#   - Reusable UI templates across multiple labeling jobs
#   - Content validation with SHA-256 checksums
#
# Common Use Cases:
#   - Creating custom labeling interfaces for specialized annotation tasks
#   - Defining reusable UI templates for multiple labeling jobs
#   - Building interactive forms for human-in-the-loop ML workflows
#   - Customizing worker portals for data annotation tasks
#
# Dependencies:
#   - SageMaker Ground Truth service
#   - Valid Liquid HTML template content
#   - S3 bucket (if using file() function to load templates)
#
# Important Notes:
#   - The template content must be valid Liquid HTML
#   - The UI template is used when creating SageMaker labeling jobs
#   - Template content is immutable; changes require resource replacement
#   - Maximum template size is 128 KB
#   - Templates support Crowd HTML Elements for interactive UI components
#
# Related Resources:
#   - aws_sagemaker_workteam: Manages worker teams for labeling
#   - aws_sagemaker_labeling_job: Creates labeling jobs using this UI
#   - aws_lambda_function: Pre/post-processing functions for custom workflows
#
# AWS Documentation:
#   - https://docs.aws.amazon.com/sagemaker/latest/dg/sms-custom-templates.html
#   - https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_HumanTaskUiConfig.html
################################################################################

resource "aws_sagemaker_human_task_ui" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # human_task_ui_name - (Required)
  # Type: string
  # The name of the Human Task UI.
  #
  # Constraints:
  #   - Must be unique within your AWS account and region
  #   - Must start with an alphanumeric character
  #   - Can contain alphanumeric characters and hyphens
  #   - Maximum length: 63 characters
  #
  # Notes:
  #   - This name is used to reference the UI template in labeling jobs
  #   - Cannot be changed after creation (forces new resource)
  #   - Must follow SageMaker naming conventions
  #
  # Examples:
  #   - "custom-image-classification-ui"
  #   - "medical-image-annotation-ui"
  #   - "text-sentiment-labeling-ui"
  human_task_ui_name = "example-custom-ui"

  ################################################################################
  # UI Template Configuration (Required Block)
  ################################################################################
  # This block defines the Liquid template for the worker user interface.
  # The template specifies how data is presented to human annotators.

  ui_template {
    # content - (Required)
    # Type: string
    # The content of the Liquid template for the worker user interface.
    #
    # Requirements:
    #   - Must be valid Liquid HTML syntax
    #   - Must include required Crowd HTML Elements
    #   - Maximum size: 128 KB
    #   - Must define input variables using Liquid syntax (e.g., {{ task.input.data }})
    #
    # Template Structure:
    #   - Must contain <crowd-form> element as the main container
    #   - Should include crowd-* elements for interactive components
    #   - Must define <crowd-button> for task submission
    #   - Should use Liquid variables to display input data
    #
    # Common Crowd Elements:
    #   - <crowd-bounding-box>: For object detection/localization
    #   - <crowd-image-classifier>: For image classification
    #   - <crowd-semantic-segmentation>: For pixel-level labeling
    #   - <crowd-text-area>: For text input
    #   - <crowd-radio-group>: For single-choice selection
    #   - <crowd-checkbox>: For multi-choice selection
    #
    # Notes:
    #   - Use file() function to load template from external file
    #   - Template content is immutable; changes require recreation
    #   - Content is automatically validated by SageMaker
    #   - SHA-256 checksum is computed and stored automatically
    #
    # Example Template (inline):
    #   content = <<-EOF
    #     <script src="https://assets.crowd.aws/crowd-html-elements.js"></script>
    #     <crowd-form>
    #       <crowd-image-classifier
    #         name="category"
    #         categories="['Cat', 'Dog', 'Bird']"
    #         src="{{ task.input.taskObject | grant_read_access }}"
    #         header="Classify this image"
    #       >
    #         <full-instructions header="Classification Instructions">
    #           <p>Select the category that best describes the image.</p>
    #         </full-instructions>
    #       </crowd-image-classifier>
    #     </crowd-form>
    #   EOF
    #
    # Example Template (from file):
    #   content = file("${path.module}/templates/custom-labeling-ui.html")
    content = file("${path.module}/templates/sagemaker-human-task-ui-template.html")

    # content_sha256 - (Computed)
    # Type: string
    # The SHA-256 digest of the contents of the template.
    # This is automatically computed and cannot be set manually.
    # Used for content validation and change detection.

    # url - (Computed)
    # Type: string
    # The URL for the user interface template.
    # This is automatically generated by AWS and points to the stored template.
    # Used internally by SageMaker when creating labeling jobs.
  }

  ################################################################################
  # Optional Arguments
  ################################################################################

  # region - (Optional)
  # Type: string
  # Default: Provider region configuration
  # Region where this resource will be managed.
  #
  # Notes:
  #   - Defaults to the region set in the provider configuration
  #   - Useful for multi-region deployments
  #   - Must be a valid AWS region identifier
  #
  # Example:
  #   region = "us-west-2"
  # region = null

  # tags - (Optional)
  # Type: map(string)
  # A map of tags to assign to the resource.
  #
  # Best Practices:
  #   - Use consistent tagging strategy across resources
  #   - Include environment, project, and owner tags
  #   - Tags are inherited by labeling jobs that use this UI
  #   - Consider using default_tags in provider configuration
  #
  # Notes:
  #   - Maximum 50 tags per resource
  #   - Tag keys are case-sensitive
  #   - Compatible with provider default_tags configuration
  #
  # Example:
  #   tags = {
  #     Name        = "Custom Labeling UI"
  #     Environment = "production"
  #     Project     = "ml-data-labeling"
  #     Owner       = "data-science-team"
  #     Purpose     = "custom-annotation-workflow"
  #   }
  tags = {
    Name        = "example-human-task-ui"
    Environment = "development"
  }

  ################################################################################
  # Computed Attributes (Read-Only)
  ################################################################################
  # These attributes are automatically set by AWS and can be referenced using
  # aws_sagemaker_human_task_ui.example.<attribute_name>

  # arn - (Computed)
  # Type: string
  # The Amazon Resource Name (ARN) assigned by AWS to this Human Task UI.
  # Format: arn:aws:sagemaker:region:account-id:human-task-ui/human-task-ui-name
  # Used to reference this UI in SageMaker labeling job configurations.

  # id - (Computed)
  # Type: string
  # The name of the Human Task UI (same as human_task_ui_name).
  # Used as the Terraform resource identifier.

  # tags_all - (Computed)
  # Type: map(string)
  # A map of tags assigned to the resource, including those inherited from
  # the provider default_tags configuration block.
}

################################################################################
# Example: Complete Custom Labeling UI with Image Classification
################################################################################
/*
resource "aws_sagemaker_human_task_ui" "image_classification" {
  human_task_ui_name = "custom-image-classification-ui"

  ui_template {
    content = <<-EOF
      <script src="https://assets.crowd.aws/crowd-html-elements.js"></script>

      <crowd-form>
        <crowd-image-classifier
          name="image-category"
          categories='["Dog", "Cat", "Bird", "Other"]'
          src="{{ task.input.taskObject | grant_read_access }}"
          header="Classify the animal in this image"
        >
          <full-instructions header="Classification Instructions">
            <h3>Guidelines for Image Classification</h3>
            <ul>
              <li><strong>Dog:</strong> Select if the image contains a dog</li>
              <li><strong>Cat:</strong> Select if the image contains a cat</li>
              <li><strong>Bird:</strong> Select if the image contains a bird</li>
              <li><strong>Other:</strong> Select if none of the above apply</li>
            </ul>
            <p>If multiple animals are present, select the most prominent one.</p>
          </full-instructions>

          <short-instructions>
            <p>Select the category that best describes the primary animal in the image.</p>
          </short-instructions>
        </crowd-image-classifier>
      </crowd-form>
    EOF
  }

  tags = {
    Name        = "Image Classification UI"
    Project     = "animal-detection"
    Environment = "production"
  }
}
*/

################################################################################
# Example: Custom Bounding Box Labeling UI
################################################################################
/*
resource "aws_sagemaker_human_task_ui" "bounding_box" {
  human_task_ui_name = "custom-bounding-box-ui"

  ui_template {
    content = <<-EOF
      <script src="https://assets.crowd.aws/crowd-html-elements.js"></script>

      <crowd-form>
        <crowd-bounding-box
          name="boundingBox"
          src="{{ task.input.taskObject | grant_read_access }}"
          header="Draw bounding boxes around objects"
          labels='["Person", "Vehicle", "Building", "Animal"]'
        >
          <full-instructions header="Bounding Box Instructions">
            <h3>How to Draw Bounding Boxes</h3>
            <ol>
              <li>Select a label from the dropdown menu</li>
              <li>Click and drag to draw a box around the object</li>
              <li>Ensure the box tightly fits the object</li>
              <li>Repeat for all objects in the image</li>
            </ol>
            <p>The boxes should be as tight as possible around each object.</p>
          </full-instructions>

          <short-instructions>
            <p>Draw tight bounding boxes around all objects of interest.</p>
          </short-instructions>
        </crowd-bounding-box>
      </crowd-form>
    EOF
  }

  tags = {
    Name    = "Bounding Box UI"
    UseCase = "object-detection"
  }
}
*/

################################################################################
# Example: Text Classification UI
################################################################################
/*
resource "aws_sagemaker_human_task_ui" "text_classification" {
  human_task_ui_name = "sentiment-analysis-ui"

  ui_template {
    content = <<-EOF
      <script src="https://assets.crowd.aws/crowd-html-elements.js"></script>

      <crowd-form>
        <crowd-classifier
          name="sentiment"
          categories='["Positive", "Neutral", "Negative"]'
          header="Classify the sentiment of this text"
        >
          <classification-target>
            <h3>Text to Classify:</h3>
            <p style="padding: 1em; background-color: #f5f5f5; border-radius: 4px;">
              {{ task.input.text }}
            </p>
          </classification-target>

          <full-instructions header="Sentiment Classification Guidelines">
            <h3>Classification Criteria</h3>
            <ul>
              <li><strong>Positive:</strong> Text expresses positive emotions, satisfaction, or approval</li>
              <li><strong>Neutral:</strong> Text is factual or expresses no clear sentiment</li>
              <li><strong>Negative:</strong> Text expresses negative emotions, dissatisfaction, or criticism</li>
            </ul>
          </full-instructions>

          <short-instructions>
            <p>Select the sentiment category that best describes the text.</p>
          </short-instructions>
        </crowd-classifier>
      </crowd-form>
    EOF
  }

  tags = {
    Name        = "Sentiment Analysis UI"
    Application = "nlp-labeling"
  }
}
*/

################################################################################
# Example: Loading Template from External File
################################################################################
/*
# File structure:
# terraform/
#   ├── main.tf
#   └── templates/
#       └── custom-labeling-template.html

resource "aws_sagemaker_human_task_ui" "from_file" {
  human_task_ui_name = "external-template-ui"

  ui_template {
    # Load template content from external file
    content = file("${path.module}/templates/custom-labeling-template.html")
  }

  tags = {
    Name           = "External Template UI"
    TemplateSource = "external-file"
  }
}
*/

################################################################################
# Outputs
################################################################################

output "human_task_ui_arn" {
  description = "The ARN of the SageMaker Human Task UI"
  value       = aws_sagemaker_human_task_ui.example.arn
}

output "human_task_ui_name" {
  description = "The name of the Human Task UI"
  value       = aws_sagemaker_human_task_ui.example.human_task_ui_name
}

output "ui_template_url" {
  description = "The URL for the user interface template"
  value       = aws_sagemaker_human_task_ui.example.ui_template[0].url
}

output "ui_template_content_sha256" {
  description = "The SHA-256 digest of the template contents"
  value       = aws_sagemaker_human_task_ui.example.ui_template[0].content_sha256
}

################################################################################
# Usage Example with SageMaker Labeling Job
################################################################################
/*
# This shows how to use the Human Task UI in a labeling job

resource "aws_sagemaker_workteam" "example" {
  workteam_name = "example-workteam"
  description   = "Example workteam for labeling tasks"

  member_definition {
    cognito_member_definition {
      client_id  = aws_cognito_user_pool_client.example.id
      user_pool  = aws_cognito_user_pool.example.id
      user_group = aws_cognito_user_group.example.id
    }
  }
}

resource "aws_iam_role" "sagemaker_labeling" {
  name = "sagemaker-labeling-job-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "sagemaker.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_sagemaker_labeling_job" "example" {
  name     = "example-labeling-job"
  role_arn = aws_iam_role.sagemaker_labeling.arn

  input_config {
    data_source {
      s3_data_source {
        manifest_s3_uri = "s3://bucket/path/to/manifest.json"
      }
    }
  }

  output_config {
    s3_output_path = "s3://bucket/path/to/output/"
  }

  human_task_config {
    workteam_arn = aws_sagemaker_workteam.example.arn

    ui_config {
      # Reference the Human Task UI created above
      human_task_ui_arn = aws_sagemaker_human_task_ui.example.arn
    }

    task_title              = "Image Classification Task"
    task_description        = "Classify images into categories"
    number_of_human_workers_per_data_object = 1
    task_time_limit_in_seconds = 3600
    task_availability_lifetime_in_seconds = 864000

    annotation_consolidation_config {
      annotation_consolidation_lambda_arn = aws_lambda_function.consolidation.arn
    }
  }

  stopping_conditions {
    max_human_labeled_object_count = 1000
  }
}
*/
