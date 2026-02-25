#---------------------------------------------------------------
# AWS Observability Admin Centralization Rule For Organization
#---------------------------------------------------------------
#
# AWS Organizations 全体のオブザーバビリティデータ（ログ等）を
# 指定した集約先アカウント・リージョンに集中管理するための
# 集中化ルールをプロビジョニングするリソースです。
# ソースアカウントやリージョンのスコープ、ログの暗号化設定、
# バックアップ先などを詳細に制御できます。
#
# AWS公式ドキュメント:
#   - AWS Observability Access Manager: https://docs.aws.amazon.com/OAM/latest/APIReference/Welcome.html
#   - CloudWatch クロスアカウントオブザーバビリティ: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-Unified-Cross-Account.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/observabilityadmin_centralization_rule_for_organization
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_observabilityadmin_centralization_rule_for_organization" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # rule_name (Required)
  # 設定内容: 集中化ルールの名前を指定します。
  # 設定可能な値: 任意の文字列
  rule_name = "example-centralization-rule"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # ルール定義
  #-------------------------------------------------------------

  # rule (Optional)
  # 設定内容: 集中化ルールの詳細設定を行うブロックです。
  rule {
    #-----------------------------------------------------------
    # ソース設定
    #-----------------------------------------------------------

    # source (Optional)
    # 設定内容: オブザーバビリティデータの収集元となるアカウント・リージョンのスコープを指定します。
    source {

      # scope (Required)
      # 設定内容: データ収集対象のスコープを指定します。
      # 設定可能な値:
      #   - "ALL": Organizations 全アカウントを対象
      #   - "SPECIFIC_ACCOUNTS": 特定アカウントのみを対象
      scope = "ALL"

      # regions (Required)
      # 設定内容: データ収集対象のリージョンセットを指定します。
      # 設定可能な値: 有効な AWS リージョンコードのセット（例: ["ap-northeast-1", "us-east-1"]）
      regions = ["ap-northeast-1", "us-east-1"]

      #---------------------------------------------------------
      # ソースログ設定
      #---------------------------------------------------------

      # source_logs_configuration (Optional)
      # 設定内容: ソース側のログ収集に関する設定を行うブロックです。
      source_logs_configuration {

        # log_group_selection_criteria (Required)
        # 設定内容: 収集対象のロググループを選択する基準を指定します。
        # 設定可能な値:
        #   - "ALL": すべてのロググループを対象
        #   - "SPECIFIC": 特定のロググループのみを対象
        log_group_selection_criteria = "ALL"

        # encrypted_log_group_strategy (Required)
        # 設定内容: 暗号化済みロググループの取り扱い戦略を指定します。
        # 設定可能な値:
        #   - "INCLUDE": 暗号化済みロググループも含めて収集
        #   - "EXCLUDE": 暗号化済みロググループを除外して収集
        encrypted_log_group_strategy = "INCLUDE"
      }
    }

    #-----------------------------------------------------------
    # 宛先設定
    #-----------------------------------------------------------

    # destination (Optional)
    # 設定内容: オブザーバビリティデータの集約先となるアカウント・リージョンを指定します。
    destination {

      # account (Required)
      # 設定内容: データの集約先となる AWS アカウント ID を指定します。
      # 設定可能な値: 12桁の AWS アカウント ID
      account = "123456789012"

      # region (Required)
      # 設定内容: データの集約先となる AWS リージョンを指定します。
      # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
      region = "ap-northeast-1"

      #---------------------------------------------------------
      # 宛先ログ設定
      #---------------------------------------------------------

      # destination_logs_configuration (Optional)
      # 設定内容: 宛先側のログ管理に関する設定を行うブロックです。
      destination_logs_configuration {

        #-------------------------------------------------------
        # ログ暗号化設定
        #-------------------------------------------------------

        # logs_encryption_configuration (Optional)
        # 設定内容: 集約先で保存するログの暗号化設定を行うブロックです。
        logs_encryption_configuration {

          # encryption_strategy (Required)
          # 設定内容: ログデータの暗号化方式を指定します。
          # 設定可能な値:
          #   - "AWS_OWNED_KEY": AWS マネージドキーで暗号化
          #   - "CUSTOMER_MANAGED_KEY": カスタマーマネージドキー（CMK）で暗号化
          encryption_strategy = "AWS_OWNED_KEY"

          # kms_key_arn (Optional)
          # 設定内容: 暗号化に使用する KMS キーの ARN を指定します。
          # 設定可能な値: 有効な KMS キーの ARN
          # 省略時: encryption_strategy が AWS_OWNED_KEY の場合は不要
          # 注意: encryption_strategy が CUSTOMER_MANAGED_KEY の場合は必須
          kms_key_arn = null

          # encryption_conflict_resolution_strategy (Optional)
          # 設定内容: ロググループ側の暗号化設定と競合した場合の解決戦略を指定します。
          # 設定可能な値:
          #   - "USE_SOURCE_ENCRYPTION": ソース側の暗号化設定を優先
          #   - "USE_DESTINATION_ENCRYPTION": 宛先側の暗号化設定を優先
          # 省略時: null（デフォルト動作に従う）
          encryption_conflict_resolution_strategy = null
        }

        #-------------------------------------------------------
        # バックアップ設定
        #-------------------------------------------------------

        # backup_configuration (Optional)
        # 設定内容: 集約ログのバックアップ先に関する設定を行うブロックです。
        backup_configuration {

          # region (Optional)
          # 設定内容: バックアップを保存するリージョンを指定します。
          # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
          # 省略時: null
          region = null

          # kms_key_arn (Optional)
          # 設定内容: バックアップデータの暗号化に使用する KMS キーの ARN を指定します。
          # 設定可能な値: 有効な KMS キーの ARN
          # 省略時: null（暗号化なし、またはデフォルト暗号化を使用）
          kms_key_arn = null
        }
      }
    }
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-centralization-rule"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h" など duration 形式の文字列
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h" など duration 形式の文字列
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    update = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - rule_arn: 作成された集中化ルールの Amazon Resource Name (ARN)
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
