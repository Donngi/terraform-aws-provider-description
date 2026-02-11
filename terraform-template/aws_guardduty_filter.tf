#---------------------------------------------------------------
# GuardDuty Filter
#---------------------------------------------------------------
#
# GuardDutyの検出結果（findings）をフィルタリングして自動的にアーカイブ
# または特定の条件に一致する検出結果を管理するためのフィルターリソース。
# フィルターを使用することで、誤検知や低優先度の検出結果を抑制し、
# 重要な脅威に集中できます。
#
# AWS公式ドキュメント:
#   - Filtering findings in GuardDuty: https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_filter-findings.html
#   - Managing Amazon GuardDuty findings: https://docs.aws.amazon.com/guardduty/latest/ug/findings_management.html
#   - Suppression rules in GuardDuty: https://docs.aws.amazon.com/guardduty/latest/ug/findings_suppression-rule.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_filter
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_guardduty_filter" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # (Required) フィルターに一致した検出結果に適用するアクション
  # - ARCHIVE: 検出結果を自動的にアーカイブ（抑制ルールとして機能）
  # - NOOP: アクションなし（検出結果の表示フィルターとして機能）
  action = "ARCHIVE"

  # (Required) GuardDuty DetectorのID
  # このフィルターを適用するGuardDuty Detectorを指定します。
  # 各AWSリージョンとアカウントごとに一意のDetector IDが存在します。
  detector_id = "12abc34d567e8fa901bc2d34eabcdef5"

  # (Required) フィルターの名前
  # 3〜64文字で指定。使用可能な文字: a-z, A-Z, 0-9, ピリオド(.), ハイフン(-), アンダースコア(_)
  name = "MyGuardDutyFilter"

  # (Required) フィルターの優先順位（適用順序）
  # 1から始まる整数で、数値が小さいほど優先度が高くなります。
  # 複数のフィルターが存在する場合、この順序で評価されます。
  rank = 1

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # (Optional) フィルターの説明
  # 最大512文字まで指定可能。フィルターの目的や条件を記述します。
  description = "Filter to archive low severity findings from specific regions"

  # (Optional) このリソースが管理されるAWSリージョン
  # 未指定の場合、プロバイダー設定のリージョンが使用されます。
  # マルチリージョン管理時に明示的にリージョンを指定する場合に使用。
  # region = "us-east-1"

  # (Optional) リソースに付与するタグ
  # キー・バリューのマップ形式で指定。管理・請求・アクセス制御等に使用。
  tags = {
    Name        = "MyGuardDutyFilter"
    Environment = "production"
    ManagedBy   = "Terraform"
  }

  # (Optional) プロバイダーのdefault_tagsと統合された全タグ
  # 通常はプロバイダーレベルで設定したdefault_tagsと個別リソースのtagsがマージされます。
  # 明示的に指定する場合は使用しますが、通常はtagsのみの指定で十分です。
  # tags_all = {}

  #---------------------------------------------------------------
  # Finding Criteria Block (Required)
  #---------------------------------------------------------------

  # (Required) 検出結果のフィルタリング条件を定義するブロック
  # 最小1つ、最大50個の条件（criterion）を指定可能。
  # 各条件はAND演算子で評価され、同一属性の複数値はAND/ORで評価されます。
  finding_criteria {

    # (Required) フィルター条件を定義するcriterionブロック（1個以上必須）
    # 各criterionは特定のフィールドに対する条件を指定します。
    criterion {
      # (Required) 評価対象のフィールド名
      # 利用可能なフィールドの完全なリストはAWS公式ドキュメントを参照:
      # https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_filter-findings.html#filter_criteria
      # 主なフィールド例:
      # - region: AWSリージョン
      # - severity: 重大度（0-10の数値）
      # - type: 検出結果タイプ（例: Recon:EC2/Portscan）
      # - resource.instanceDetails.instanceId: EC2インスタンスID
      # - resource.s3BucketDetails.name: S3バケット名
      # - service.additionalInfo.threatListName: 脅威リスト名
      # - updatedAt: 更新日時（RFC 3339形式）
      field = "region"

      # (Optional) 完全一致する値のリスト
      # 指定したフィールドがこのリストのいずれかの値と完全に一致する場合にマッチ。
      equals = ["us-west-2", "us-east-1"]

      # (Optional) 一致しない値のリスト
      # 指定したフィールドがこのリストのいずれの値とも一致しない場合にマッチ。
      # not_equals = ["value1", "value2"]

      # (Optional) より大きい値を指定
      # 整数値またはRFC 3339形式の日時を指定可能。
      # 例: "2020-01-01T00:00:00Z" や "5"
      # greater_than = "2024-01-01T00:00:00Z"

      # (Optional) 以上の値を指定
      # 整数値またはRFC 3339形式の日時を指定可能。
      # 例: severity（重大度）フィルタリング時に使用
      # greater_than_or_equal = "4"

      # (Optional) より小さい値を指定
      # 整数値またはRFC 3339形式の日時を指定可能。
      # less_than = "2024-12-31T23:59:59Z"

      # (Optional) 以下の値を指定
      # 整数値またはRFC 3339形式の日時を指定可能。
      # less_than_or_equal = "3"

      # (Optional) パターンマッチする値のリスト
      # 指定したフィールドが部分一致条件を満たす場合にマッチ。
      # matches = ["pattern1", "pattern2"]

      # (Optional) パターンマッチしない値のリスト
      # 指定したフィールドが部分一致条件を満たさない場合にマッチ。
      # not_matches = ["pattern1", "pattern2"]
    }

    # 複数のcriterionを追加する例
    criterion {
      field      = "severity"
      # 重大度が4以上（MEDIUM以上）の検出結果にマッチ
      # LOW: 1-3, MEDIUM: 4-6, HIGH: 7-8, CRITICAL: 9-10
      greater_than_or_equal = "4"
    }

    criterion {
      field = "type"
      # 特定の検出結果タイプを除外する例
      not_equals = [
        "Recon:EC2/PortProbeUnprotectedPort",
        "UnauthorizedAccess:EC2/SSHBruteForce"
      ]
    }

    criterion {
      field = "updatedAt"
      # 特定期間の検出結果のみを対象とする例
      greater_than = "2024-01-01T00:00:00Z"
      less_than    = "2024-12-31T23:59:59Z"
    }

    # その他のcriterionの例（必要に応じて追加）
    # criterion {
    #   field = "resource.instanceDetails.instanceId"
    #   equals = ["i-1234567890abcdef0"]
    # }
    #
    # criterion {
    #   field = "resource.s3BucketDetails.name"
    #   equals = ["my-bucket-name"]
    # }
    #
    # criterion {
    #   field = "service.additionalInfo.threatListName"
    #   not_equals = ["some-threat-list"]
    # }
  }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です（computed属性）:
#
# - id
#     GuardDuty FilterのID（通常は {detector_id}:{filter_name} の形式）
#     例: "12abc34d567e8fa901bc2d34eabcdef5:MyGuardDutyFilter"
#
# - arn
#     GuardDuty FilterのAmazon Resource Name (ARN)
#     例: "arn:aws:guardduty:us-east-1:123456789012:detector/12abc34d567e8fa901bc2d34eabcdef5/filter/MyGuardDutyFilter"
#
# - tags_all
#     プロバイダーのdefault_tagsとリソース個別のtagsを統合した全タグのマップ
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: 重大度ベースのフィルター
#---------------------------------------------------------------
# resource "aws_guardduty_filter" "low_severity" {
#   name        = "ArchiveLowSeverityFindings"
#   description = "Archive all low severity findings"
#   detector_id = aws_guardduty_detector.primary.id
#   rank        = 1
#   action      = "ARCHIVE"
#
#   finding_criteria {
#     criterion {
#       field  = "severity"
#       # LOW severity (1, 2, 3)
#       equals = ["1", "2", "3"]
#     }
#   }
#
#   tags = {
#     Purpose = "Suppress low severity alerts"
#   }
# }

#---------------------------------------------------------------
# 使用例: 特定リソースタイプの除外
#---------------------------------------------------------------
# resource "aws_guardduty_filter" "exclude_s3" {
#   name        = "ExcludeS3Findings"
#   description = "Exclude all S3 related findings"
#   detector_id = aws_guardduty_detector.primary.id
#   rank        = 2
#   action      = "ARCHIVE"
#
#   finding_criteria {
#     criterion {
#       field  = "resource.resourceType"
#       equals = ["S3Bucket"]
#     }
#   }
#
#   tags = {
#     Purpose = "S3 findings handled separately"
#   }
# }

#---------------------------------------------------------------
# 使用例: 複数条件の組み合わせ
#---------------------------------------------------------------
# resource "aws_guardduty_filter" "complex_filter" {
#   name        = "ComplexFilterExample"
#   description = "Archive findings based on multiple criteria"
#   detector_id = aws_guardduty_detector.primary.id
#   rank        = 3
#   action      = "ARCHIVE"
#
#   finding_criteria {
#     # 特定リージョンからの検出結果
#     criterion {
#       field  = "region"
#       equals = ["eu-west-1"]
#     }
#
#     # 重大度がMEDIUM以下
#     criterion {
#       field           = "severity"
#       less_than_or_equal = "6"
#     }
#
#     # 特定の検出結果タイプを除外
#     criterion {
#       field = "type"
#       not_equals = [
#         "UnauthorizedAccess:IAMUser/InstanceCredentialExfiltration"
#       ]
#     }
#
#     # 最近の検出結果のみ対象
#     criterion {
#       field        = "updatedAt"
#       greater_than = "2024-01-01T00:00:00Z"
#     }
#   }
#
#   tags = {
#     Environment = "production"
#     Purpose     = "Regional low severity suppression"
#   }
# }
