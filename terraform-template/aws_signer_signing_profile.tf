###############################################################################
# AWS Signer Signing Profile
# Provider Version: 6.28.0
# Resource: aws_signer_signing_profile
###############################################################################
# 概要:
#   AWS Signerの署名プロファイルを作成します。署名プロファイルには、
#   特定のコード署名ユーザーが使用できるコード署名設定パラメータに関する
#   情報が含まれています。
#
# 主な用途:
#   - AWS Lambda関数のコード署名
#   - AWS IoT jobsのコード署名
#   - コンテナイメージの署名
#
# 注意事項:
#   - 署名プロファイル名は不変であり、キャンセル後は再利用できません
#   - platform_id, name, name_prefix, signature_validity_period, signing_material,
#     signing_parameters は変更時に新しいリソースを作成します(Forces new resource)
#   - name と name_prefix は競合するため、同時に指定できません
###############################################################################

###############################################################################
# Required Parameters (必須パラメータ)
###############################################################################

variable "platform_id" {
  description = <<-EOT
    (必須) 署名プロファイルで使用するプラットフォームのID

    利用可能なプラットフォームID:
    - AWSLambda-SHA384-ECDSA: AWS Lambda関数用
    - AWSIoTDeviceManagement-SHA256-ECDSA: AWS IoT jobs用
    - AmazonFreeRTOS-Default: Amazon FreeRTOS OTA更新用
    - AmazonFreeRTOS-TI-CC3220SF: Texas Instruments CC3220SF用
    - Notation-OCI-SHA384-ECDSA: コンテナイメージ署名用

    【変更時の影響】
    変更すると新しいリソースが作成されます

    【検証】
    - 有効なプラットフォームIDを指定する必要があります

    【依存関係】
    - プラットフォームに応じて署名アルゴリズムと証明書要件が決定されます
  EOT
  type        = string

  validation {
    condition = can(regex("^(AWSLambda-SHA384-ECDSA|AWSIoTDeviceManagement-SHA256-ECDSA|AmazonFreeRTOS-Default|AmazonFreeRTOS-TI-CC3220SF|Notation-OCI-SHA384-ECDSA)$", var.platform_id))
    error_message = "platform_id must be one of: AWSLambda-SHA384-ECDSA, AWSIoTDeviceManagement-SHA256-ECDSA, AmazonFreeRTOS-Default, AmazonFreeRTOS-TI-CC3220SF, Notation-OCI-SHA384-ECDSA."
  }
}

###############################################################################
# Optional Parameters (オプションパラメータ)
###############################################################################

variable "name" {
  description = <<-EOT
    (オプション) 署名プロファイルの一意の名前

    【デフォルト値】
    Terraformによって自動生成されます

    【変更時の影響】
    変更すると新しいリソースが作成されます

    【制約】
    - 署名プロファイル名は不変であり、キャンセル後は再利用できません
    - name_prefix と競合するため、同時に指定できません

    【推奨事項】
    - 名前の自動生成を利用する場合は name_prefix を使用することを推奨
    - 明示的な命名規則がある場合のみこのパラメータを使用
  EOT
  type        = string
  default     = null
}

variable "name_prefix" {
  description = <<-EOT
    (オプション) 署名プロファイル名のプレフィックス

    【デフォルト値】
    null

    【動作】
    指定すると、Terraformが一意のサフィックスを生成します

    【変更時の影響】
    変更すると新しいリソースが作成されます

    【制約】
    - name と競合するため、同時に指定できません

    【推奨事項】
    - 命名の一貫性を保ちつつ、一意性を確保したい場合に使用
    - 環境やプロジェクト名をプレフィックスとして使用することを推奨
  EOT
  type        = string
  default     = null
}

variable "region" {
  description = <<-EOT
    (オプション) このリソースが管理されるリージョン

    【デフォルト値】
    プロバイダー設定で指定されたリージョン

    【動作】
    指定したリージョンでリソースが作成・管理されます

    【推奨事項】
    - 通常はプロバイダーのデフォルト設定を使用
    - マルチリージョン展開の場合のみ明示的に指定
  EOT
  type        = string
  default     = null
}

variable "signature_validity_period" {
  description = <<-EOT
    (オプション) 署名ジョブの有効期間

    【デフォルト値】
    null (プラットフォームのデフォルト設定が適用されます)

    【変更時の影響】
    変更すると新しいリソースが作成されます

    【構造】
    - type: (必須) 署名の有効期間の時間単位
      - 有効な値: DAYS, MONTHS, YEARS
    - value: (必須) 署名の有効期間の数値
      - 正の整数を指定

    【使用例】
    {
      type  = "YEARS"
      value = 5
    }

    【推奨事項】
    - プロダクション環境では長期間の有効期限(3-5年)を設定
    - 開発環境では短期間の有効期限(数ヶ月)でテスト可能
    - セキュリティ要件に応じて適切な期間を設定
  EOT
  type = object({
    type  = string
    value = number
  })
  default = null

  validation {
    condition = var.signature_validity_period == null || (
      can(regex("^(DAYS|MONTHS|YEARS)$", var.signature_validity_period.type)) &&
      var.signature_validity_period.value > 0
    )
    error_message = "signature_validity_period.type must be one of DAYS, MONTHS, or YEARS, and value must be a positive number."
  }
}

variable "signing_material" {
  description = <<-EOT
    (オプション) コードの署名に使用されるAWS Certificate Manager証明書

    【デフォルト値】
    null (AWS Signerが管理する証明書を使用)

    【変更時の影響】
    変更すると新しいリソースが作成されます

    【構造】
    - certificate_arn: (必須) コードの署名に使用される証明書のARN

    【使用例】
    {
      certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"
    }

    【推奨事項】
    - 既存のACM証明書を使用する場合に指定
    - 証明書はコード署名用途で発行されている必要があります
    - 証明書の有効期限管理に注意

    【依存関係】
    - AWS Certificate Managerで証明書が事前に作成されている必要があります
  EOT
  type = object({
    certificate_arn = string
  })
  default = null

  validation {
    condition = var.signing_material == null || can(regex("^arn:aws:acm:[a-z0-9-]+:[0-9]{12}:certificate/[a-f0-9-]+$", var.signing_material.certificate_arn))
    error_message = "signing_material.certificate_arn must be a valid ACM certificate ARN."
  }
}

variable "signing_parameters" {
  description = <<-EOT
    (オプション) 署名時に使用するキーと値のペアのマップ

    【デフォルト値】
    null

    【変更時の影響】
    変更すると新しいリソースが作成されます

    【動作】
    署名プロセス中に使用したい任意の情報を含めることができます

    【使用例】
    {
      "key1" = "value1"
      "key2" = "value2"
    }

    【推奨事項】
    - プラットフォーム固有のパラメータがある場合に使用
    - 署名のトレーサビリティのためのメタデータを含めることも可能
  EOT
  type        = map(string)
  default     = null
}

variable "tags" {
  description = <<-EOT
    (オプション) 署名プロファイルに関連付けるタグのリスト

    【デフォルト値】
    {} (空のマップ)

    【動作】
    リソースに追加のメタデータを付与します

    【プロバイダーのdefault_tags設定との関係】
    - プロバイダーレベルでdefault_tagsが設定されている場合、
      同じキーを持つタグはこちらで指定した値で上書きされます

    【推奨事項】
    - 環境(Environment)、プロジェクト(Project)、コスト管理(CostCenter)などの
      タグを標準化して使用することを推奨
    - セキュリティやコンプライアンス要件に応じたタグ付けを実施
  EOT
  type        = map(string)
  default     = {}
}

###############################################################################
# Resource Definition
###############################################################################

resource "aws_signer_signing_profile" "this" {
  # Required parameters
  platform_id = var.platform_id

  # Optional parameters - Identity
  name        = var.name
  name_prefix = var.name_prefix

  # Optional parameters - Configuration
  region             = var.region
  signing_parameters = var.signing_parameters

  # Optional parameters - Validity
  dynamic "signature_validity_period" {
    for_each = var.signature_validity_period != null ? [var.signature_validity_period] : []
    content {
      type  = signature_validity_period.value.type
      value = signature_validity_period.value.value
    }
  }

  # Optional parameters - Certificate
  dynamic "signing_material" {
    for_each = var.signing_material != null ? [var.signing_material] : []
    content {
      certificate_arn = signing_material.value.certificate_arn
    }
  }

  # Optional parameters - Tags
  tags = var.tags

  # Lifecycle configuration
  lifecycle {
    create_before_destroy = true

    # Ignore tags_all as it's managed by provider default_tags
    ignore_changes = [
      tags_all
    ]
  }
}

###############################################################################
# Outputs
###############################################################################

output "signing_profile_id" {
  description = <<-EOT
    署名プロファイルのID

    【用途】
    - 他のリソースでこの署名プロファイルを参照する際に使用
    - AWS Signer Signing Jobの作成時などに必要
  EOT
  value       = aws_signer_signing_profile.this.id
}

output "signing_profile_arn" {
  description = <<-EOT
    署名プロファイルのARN (Amazon Resource Name)

    【用途】
    - IAMポリシーでのリソース指定
    - 他のAWSサービスとの統合
    - リソースの一意な識別子として使用
  EOT
  value       = aws_signer_signing_profile.this.arn
}

output "signing_profile_name" {
  description = <<-EOT
    署名プロファイルの名前

    【特性】
    - nameまたはname_prefixを指定した場合はその値(またはその値+サフィックス)
    - 指定しなかった場合はTerraformが自動生成した名前
  EOT
  value       = aws_signer_signing_profile.this.name
}

output "signing_profile_version" {
  description = <<-EOT
    署名プロファイルの現在のバージョン

    【用途】
    - 署名プロファイルのバージョン管理
    - 特定のバージョンを参照する場合に使用
  EOT
  value       = aws_signer_signing_profile.this.version
}

output "signing_profile_version_arn" {
  description = <<-EOT
    バージョンを含む署名プロファイルのARN

    【用途】
    - 特定のバージョンの署名プロファイルを明示的に参照
    - バージョン管理が重要な場合に使用
  EOT
  value       = aws_signer_signing_profile.this.version_arn
}

output "signing_profile_status" {
  description = <<-EOT
    署名プロファイルのステータス

    【可能な値】
    - Active: アクティブな状態
    - Canceled: キャンセルされた状態
    - Revoked: 失効された状態

    【用途】
    - リソースの状態確認
    - 条件分岐での使用
  EOT
  value       = aws_signer_signing_profile.this.status
}

output "platform_display_name" {
  description = <<-EOT
    署名プロファイルに関連付けられた署名プラットフォームの人間が読める名前

    【用途】
    - UIやログでの表示
    - ドキュメント化
  EOT
  value       = aws_signer_signing_profile.this.platform_display_name
}

output "revocation_record" {
  description = <<-EOT
    署名プロファイルの失効情報

    【構造】
    - revocation_effective_from: 失効が有効になる時刻
    - revoked_at: 署名プロファイルが失効された時刻
    - revoked_by: 失効者の識別情報

    【用途】
    - 失効履歴の追跡
    - 監査とコンプライアンス
  EOT
  value       = aws_signer_signing_profile.this.revocation_record
}

output "tags_all" {
  description = <<-EOT
    リソースに割り当てられたすべてのタグ

    【内容】
    - 明示的に指定したタグ
    - プロバイダーのdefault_tagsから継承されたタグ

    【用途】
    - タグの完全なリストの確認
    - タグベースのリソース管理
  EOT
  value       = aws_signer_signing_profile.this.tags_all
}

###############################################################################
# Usage Examples
###############################################################################

# Example 1: Basic Signing Profile for AWS Lambda
# 最もシンプルなLambda用の署名プロファイル
#
# module "lambda_signing_profile_basic" {
#   source = "./path/to/this/module"
#
#   platform_id = "AWSLambda-SHA384-ECDSA"
#
#   tags = {
#     Environment = "development"
#     Purpose     = "lambda-code-signing"
#   }
# }

# Example 2: Production Signing Profile with Custom Validity Period
# 本番環境用の署名プロファイル（5年間の有効期限付き）
#
# module "lambda_signing_profile_prod" {
#   source = "./path/to/this/module"
#
#   platform_id = "AWSLambda-SHA384-ECDSA"
#   name_prefix = "prod_lambda_"
#
#   signature_validity_period = {
#     type  = "YEARS"
#     value = 5
#   }
#
#   tags = {
#     Environment = "production"
#     Purpose     = "lambda-code-signing"
#     Compliance  = "required"
#   }
# }

# Example 3: Signing Profile with Custom Certificate
# カスタム証明書を使用する署名プロファイル
#
# module "custom_cert_signing_profile" {
#   source = "./path/to/this/module"
#
#   platform_id = "AWSLambda-SHA384-ECDSA"
#   name_prefix = "custom_cert_"
#
#   signing_material = {
#     certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"
#   }
#
#   signature_validity_period = {
#     type  = "YEARS"
#     value = 3
#   }
#
#   tags = {
#     Environment    = "production"
#     CertificateType = "custom"
#   }
# }

# Example 4: IoT Device Management Signing Profile
# AWS IoT jobs用の署名プロファイル
#
# module "iot_signing_profile" {
#   source = "./path/to/this/module"
#
#   platform_id = "AWSIoTDeviceManagement-SHA256-ECDSA"
#   name_prefix = "iot_jobs_"
#
#   signature_validity_period = {
#     type  = "MONTHS"
#     value = 12
#   }
#
#   tags = {
#     Environment = "production"
#     Purpose     = "iot-firmware-signing"
#   }
# }

# Example 5: Container Image Signing Profile
# コンテナイメージ署名用のプロファイル
#
# module "container_signing_profile" {
#   source = "./path/to/this/module"
#
#   platform_id = "Notation-OCI-SHA384-ECDSA"
#   name        = "container-image-signing"
#
#   signature_validity_period = {
#     type  = "YEARS"
#     value = 2
#   }
#
#   signing_parameters = {
#     "notation.signingScheme" = "notary.x509"
#   }
#
#   tags = {
#     Environment = "production"
#     Purpose     = "container-signing"
#   }
# }

# Example 6: Multi-Region Signing Profile
# 特定リージョンでの署名プロファイル
#
# module "regional_signing_profile" {
#   source = "./path/to/this/module"
#
#   platform_id = "AWSLambda-SHA384-ECDSA"
#   name_prefix = "eu_west_1_"
#   region      = "eu-west-1"
#
#   signature_validity_period = {
#     type  = "YEARS"
#     value = 5
#   }
#
#   tags = {
#     Environment = "production"
#     Region      = "eu-west-1"
#   }
# }

###############################################################################
# Additional Information
###############################################################################

# Platform IDs and Use Cases:
#
# 1. AWSLambda-SHA384-ECDSA
#    - 用途: AWS Lambda関数のコード署名
#    - アルゴリズム: SHA384 with ECDSA
#    - 証明書: AWS Signer管理またはACM証明書
#
# 2. AWSIoTDeviceManagement-SHA256-ECDSA
#    - 用途: AWS IoT jobsのコード署名
#    - アルゴリズム: SHA256 with ECDSA
#    - デバイスファームウェア更新の信頼性確保
#
# 3. AmazonFreeRTOS-Default
#    - 用途: Amazon FreeRTOS OTA更新
#    - IoTデバイス向けのファームウェア署名
#
# 4. AmazonFreeRTOS-TI-CC3220SF
#    - 用途: Texas Instruments CC3220SF用
#    - 特定のハードウェアプラットフォーム向け
#
# 5. Notation-OCI-SHA384-ECDSA
#    - 用途: コンテナイメージの署名
#    - OCI (Open Container Initiative) 準拠
#    - コンテナレジストリでの信頼性検証

# Best Practices:
#
# 1. 命名規則
#    - 環境やプラットフォームを識別できる名前を使用
#    - name_prefixの使用でTerraformに一意性を委ねることを推奨
#
# 2. 有効期限の設定
#    - プロダクション: 3-5年の長期間を推奨
#    - 開発環境: 短期間でテスト、定期的な更新を実施
#
# 3. タグ付け戦略
#    - Environment, Purpose, Complianceタグの使用を推奨
#    - コスト管理とリソース追跡のための一貫したタグ体系
#
# 4. セキュリティ
#    - カスタム証明書を使用する場合は証明書のローテーション計画を策定
#    - 失効レコードの定期的な監視
#    - IAMポリシーでの適切なアクセス制御
#
# 5. ライフサイクル管理
#    - create_before_destroyを有効化して安全な更新を実現
#    - 署名プロファイルのバージョン管理を活用
#
# 6. コンプライアンス
#    - 署名の有効期限をコンプライアンス要件に合わせる
#    - 失効情報の監査ログとしての活用
