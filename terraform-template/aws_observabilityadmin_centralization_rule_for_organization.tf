#---------------------------------------------------------------
# AWS Observability Admin Centralization Rule For Organization
#---------------------------------------------------------------
#
# AWS Organizations 全体のログデータを指定した集約先アカウント・
# リージョンに集中管理するための集中化ルールをプロビジョニングする
# リソースです。複数のAWSアカウント・リージョンからのログを
# 単一の宛先に集約し、ログ管理・コンプライアンス・コスト最適化を
# 実現します。
#
# 前提条件:
#   - AWS Organizations が有効であること
#   - 管理アカウントまたは委任管理者アカウントから実行すること
#   - CloudWatch の信頼されたアクセスが有効であること
#
# AWS公式ドキュメント:
#   - CloudWatch Logs 集中化: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/CloudWatchLogs_Centralization.html
#   - Observability Admin API: https://docs.aws.amazon.com/cloudwatch/latest/observabilityadmin/API_CreateCentralizationRuleForOrganization.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/observabilityadmin_centralization_rule_for_organization
#
# Provider Version: 6.36.0
# Generated: 2026-03-18
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
  # 設定内容: 集中化ルールの名前を指定します。Organizations 内で一意である必要があります。
  # 設定可能な値: 任意の文字列
  rule_name = "example-centralization-rule"

  #-------------------------------------------------------------
  # ルール定義
  #-------------------------------------------------------------

  # rule (Required)
  # 設定内容: 集中化ルールの詳細設定を行うブロックです。
  # ソース（収集元）と宛先（集約先）の設定を含みます。
  rule {
    #-----------------------------------------------------------
    # ソース設定
    #-----------------------------------------------------------

    # source (Required)
    # 設定内容: ログデータの収集元となるリージョンとスコープを指定します。
    source {

      # scope (Required)
      # 設定内容: データ収集対象のスコープを指定します。
      # 設定可能な値: "OrganizationId = '<組織ID>'" 形式の文字列
      scope = "OrganizationId = 'o-example123456'"

      # regions (Required)
      # 設定内容: データ収集対象のリージョンセットを指定します。
      # 設定可能な値: 有効なAWSリージョンコードのセット（1つ以上必須）
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
        #   - "*": すべてのロググループを対象
        #   - "LogGroupName LIKE '/aws/lambda%'" 等のOAMフィルタ構文
        # 注意: 1〜2000文字の範囲で指定
        log_group_selection_criteria = "*"

        # encrypted_log_group_strategy (Required)
        # 設定内容: 暗号化済みロググループの取り扱い戦略を指定します。
        # 設定可能な値:
        #   - "ALLOW": 暗号化済みロググループも含めて収集
        #   - "SKIP": 暗号化済みロググループを除外して収集
        encrypted_log_group_strategy = "SKIP"
      }
    }

    #-----------------------------------------------------------
    # 宛先設定
    #-----------------------------------------------------------

    # destination (Required)
    # 設定内容: ログデータの集約先となるアカウント・リージョンを指定します。
    destination {

      # account (Required)
      # 設定内容: データの集約先となるAWSアカウントIDを指定します。
      # 設定可能な値: 12桁のAWSアカウントID
      account = "123456789012"

      # region (Required)
      # 設定内容: データの集約先となるAWSリージョンを指定します。
      # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
      region = "ap-northeast-1"

      #---------------------------------------------------------
      # 宛先ログ設定
      #---------------------------------------------------------

      # destination_logs_configuration (Optional)
      # 設定内容: 宛先側のログ管理に関する設定を行うブロックです。
      # 暗号化、バックアップ、ロググループ名パターンを制御できます。
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
          #   - "AWS_OWNED": AWSマネージドキーで暗号化
          #   - "CUSTOMER_MANAGED": カスタマーマネージドキー（CMK）で暗号化
          encryption_strategy = "AWS_OWNED"

          # kms_key_arn (Optional)
          # 設定内容: 暗号化に使用するKMSキーのARNを指定します。
          # 設定可能な値: 有効なKMSキーのARN
          # 省略時: encryption_strategyがAWS_OWNEDの場合は不要
          # 注意: encryption_strategyがCUSTOMER_MANAGEDの場合は必須
          # kms_key_arn = "arn:aws:kms:ap-northeast-1:123456789012:key/example-key-id"

          # encryption_conflict_resolution_strategy (Optional)
          # 設定内容: 暗号化設定の競合時の解決戦略を指定します。
          # 設定可能な値:
          #   - "ALLOW": 競合を許可して処理を続行
          #   - "SKIP": 競合するロググループをスキップ
          # 省略時: null
          encryption_conflict_resolution_strategy = null
        }

        #-------------------------------------------------------
        # バックアップ設定
        #-------------------------------------------------------

        # backup_configuration (Optional)
        # 設定内容: 集約ログのバックアップ先に関する設定を行うブロックです。
        # バックアップリージョンを指定することで耐障害性を向上できます。
        backup_configuration {

          # region (Optional)
          # 設定内容: バックアップを保存するリージョンを指定します。
          # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-west-2）
          # 省略時: null
          region = null

          # kms_key_arn (Optional)
          # 設定内容: バックアップデータの暗号化に使用するKMSキーのARNを指定します。
          # 設定可能な値: 有効なKMSキーのARN
          # 省略時: null
          # kms_key_arn = "arn:aws:kms:us-west-2:123456789012:key/backup-key-id"
        }

        #-------------------------------------------------------
        # ロググループ名設定
        #-------------------------------------------------------

        # log_group_name_configuration (Optional)
        # 設定内容: 集約先で作成されるロググループの命名パターンを指定するブロックです。
        # 動的変数を使用してソース属性に基づいた名前を生成できます。
        log_group_name_configuration {

          # log_group_name_pattern (Required)
          # 設定内容: 宛先ロググループ名の生成パターンを指定します。
          # 設定可能な値: 静的テキストと動的変数を組み合わせた文字列
          # 動的変数の例:
          #   - $${source.accountId}: ソースアカウントID
          #   - $${source.region}: ソースリージョン
          #   - $${source.logGroup}: ソースロググループ名
          # 注意: Terraform構成では $ を $$ にエスケープする必要があります
          log_group_name_pattern = "/centralized-logs/$${source.accountId}/$${source.region}/$${source.logGroup}"
        }
      }
    }
  }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "ap-northeast-1"

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
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
    # 設定内容: リソース作成時のタイムアウトを指定します。
    # 設定可能な値: 時間文字列（例: "30s", "5m", "2h45m"）
    # 省略時: デフォルトのタイムアウトが適用されます
    create = null

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウトを指定します。
    # 設定可能な値: 時間文字列（例: "30s", "5m", "2h45m"）
    # 省略時: デフォルトのタイムアウトが適用されます
    update = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - rule_arn: 作成された集中化ルールのAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承された
#             タグを含む、リソースに割り当てられた全タグのマップ
#---------------------------------------------------------------
