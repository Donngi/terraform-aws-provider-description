#---------------------------------------------------------------
# AWS CloudWatch Observability Admin Centralization Rule For Organization
#---------------------------------------------------------------
#
# AWS Organizations 内の複数のAWSアカウントとリージョンから
# 単一の宛先アカウントとリージョンにログデータを一元化する
# ルールを管理します。これにより、ログ管理、コンプライアンス、
# およびコスト最適化のためにログを中央の場所に統合できます。
#
# このリソースを使用するには、AWS Organizations 内のAWSアカウントで
# 少なくとも委任管理者権限が必要です。
#
# AWS公式ドキュメント:
#   - Cross-account cross-Region log centralization:
#     https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/CloudWatchLogs_Centralization.html
#   - CentralizationRule API Reference:
#     https://docs.aws.amazon.com/cloudwatch/latest/observabilityadmin/API_CentralizationRule.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/observabilityadmin_centralization_rule_for_organization
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_observabilityadmin_centralization_rule_for_organization" "this" {
  #---------------------------------------------------------------
  # 基本設定
  #---------------------------------------------------------------

  # (Required) 一元化ルールの名前
  # Organization 内で一意である必要があります。
  rule_name = "example-centralization-rule"

  # (Optional) このリソースが管理されるリージョン
  # 省略した場合、プロバイダー設定のリージョンが使用されます。
  # https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #---------------------------------------------------------------
  # rule ブロック (Required)
  # 一元化ルールの設定ブロック
  # destination と source の設定が必要です。
  #---------------------------------------------------------------
  rule {

    #---------------------------------------------------------------
    # destination ブロック (Required)
    # ログが一元化される宛先の設定
    #---------------------------------------------------------------
    destination {
      # (Required) ログが一元化されるAWSアカウントID
      account = "123456789012"

      # (Required) ログが一元化されるAWSリージョン
      region = "ap-northeast-1"

      #---------------------------------------------------------------
      # destination_logs_configuration ブロック (Optional)
      # 宛先ログの設定
      #---------------------------------------------------------------
      destination_logs_configuration {

        #---------------------------------------------------------------
        # logs_encryption_configuration ブロック (Optional)
        # ログの暗号化設定
        #---------------------------------------------------------------
        logs_encryption_configuration {
          # (Required) ログの暗号化戦略
          # 有効な値:
          #   - "AWS_OWNED"       : AWS所有のキーで暗号化
          #   - "CUSTOMER_MANAGED": カスタマー管理のKMSキーで暗号化
          encryption_strategy = "AWS_OWNED"

          # (Optional) 暗号化の競合解決戦略
          # 有効な値:
          #   - "ALLOW": 競合を許可
          #   - "SKIP" : 競合をスキップ
          encryption_conflict_resolution_strategy = null

          # (Optional) 暗号化に使用するKMSキーのARN
          # encryption_strategy が "CUSTOMER_MANAGED" の場合に指定
          kms_key_arn = null
        }

        #---------------------------------------------------------------
        # backup_configuration ブロック (Optional)
        # バックアップ設定
        #---------------------------------------------------------------
        backup_configuration {
          # (Optional) バックアップストレージ用のAWSリージョン
          region = null

          # (Optional) バックアップ暗号化に使用するKMSキーのARN
          kms_key_arn = null
        }
      }
    }

    #---------------------------------------------------------------
    # source ブロック (Required)
    # 一元化するログのソースの設定
    #---------------------------------------------------------------
    source {
      # (Required) ログを一元化するAWSリージョンのセット
      # 少なくとも1つのリージョンを含む必要があります。
      regions = ["ap-southeast-1", "us-east-1"]

      # (Required) 含めるリソースを定義するスコープ
      # Organization ID形式を使用: OrganizationId = 'o-example123456'
      scope = "OrganizationId = 'o-example123456'"

      #---------------------------------------------------------------
      # source_logs_configuration ブロック (Optional)
      # ソースログの設定
      #---------------------------------------------------------------
      source_logs_configuration {
        # (Required) 暗号化されたロググループの処理戦略
        # 有効な値:
        #   - "ALLOW": 暗号化されたロググループを許可
        #   - "SKIP" : 暗号化されたロググループをスキップ
        encrypted_log_group_strategy = "SKIP"

        # (Required) ロググループの選択基準
        # - "*" を使用するとすべてのロググループが対象
        # - OAMフィルター構文を使用可能
        #   例: "LogGroupName LIKE '/aws/lambda%'"
        # 1〜2000文字の範囲で指定する必要があります。
        log_group_selection_criteria = "*"
      }
    }
  }

  #---------------------------------------------------------------
  # タグ設定
  #---------------------------------------------------------------

  # (Optional) リソースに割り当てるタグのキーと値のマップ
  # プロバイダーレベルの default_tags 設定ブロックが存在する場合、
  # 一致するキーのタグはプロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-centralization-rule"
    Environment = "production"
  }

  #---------------------------------------------------------------
  # timeouts ブロック (Optional)
  # 作成・更新操作のタイムアウト設定
  #---------------------------------------------------------------
  timeouts {
    # (Optional) 作成操作のタイムアウト
    # 数値と単位サフィックスを含む文字列で指定
    # 有効な時間単位: "s" (秒), "m" (分), "h" (時間)
    # 例: "30s", "2h45m"
    create = null

    # (Optional) 更新操作のタイムアウト
    # 数値と単位サフィックスを含む文字列で指定
    # 有効な時間単位: "s" (秒), "m" (分), "h" (時間)
    # 例: "30s", "2h45m"
    update = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (参照専用属性)
#
# 以下の属性はリソース作成後に参照できます（Terraformで設定不可）:
#
# rule_arn  - 一元化ルールのARN
# tags_all  - プロバイダーの default_tags 設定ブロックから
#             継承されたタグを含む、リソースに割り当てられた
#             すべてのタグのマップ
#
#---------------------------------------------------------------
