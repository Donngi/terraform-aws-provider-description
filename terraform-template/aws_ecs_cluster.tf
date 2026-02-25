#---------------------------------------------------------------
# Amazon ECS クラスター
#---------------------------------------------------------------
#
# Amazon Elastic Container Service (ECS) のクラスターをプロビジョニングするリソースです。
# ECSクラスターは、タスクとサービスを実行するコンテナインスタンスの論理的なグループです。
# クラスターには実行コマンド設定、マネージドストレージ設定、Service Connect設定などを
# 構成することができます。
#
# AWS公式ドキュメント:
#   - Amazon ECS クラスター: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/clusters.html
#   - ECS Exec (実行コマンド): https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-exec.html
#   - Service Connect: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/service-connect.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ecs_cluster" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: クラスターの名前を指定します。
  # 設定可能な値: 最大255文字の英字、数字、ハイフン、アンダースコア
  name = "example-cluster"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

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
    Name        = "example-cluster"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # クラスター設定
  #-------------------------------------------------------------

  # configuration (Optional)
  # 設定内容: クラスターの設定オプションを指定するブロックです。
  #          実行コマンド設定やマネージドストレージ設定を含みます。
  configuration {
    #-----------------------------------------------------------
    # 実行コマンド設定 (execute_command_configuration)
    #-----------------------------------------------------------
    # ECS Exec機能を使用してタスク内のコンテナで対話的なコマンドを実行する際の
    # 設定を指定します。この機能により、実行中のコンテナへのセキュアなアクセスと
    # デバッグが可能になります。
    # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-exec.html
    execute_command_configuration {
      # kms_key_id (Optional)
      # 設定内容: ローカルクライアントとコンテナ間のデータを暗号化するためのKMSキーIDを指定します。
      # 設定可能な値: KMSキーのARNまたはキーID
      # 注意: ログをCloudWatch LogsまたはS3に送信する際の暗号化にも使用されます
      kms_key_id = null

      # logging (Optional)
      # 設定内容: 実行コマンドの結果をリダイレクトするログ設定を指定します。
      # 設定可能な値:
      #   - "NONE": ログを記録しない
      #   - "DEFAULT": CloudWatch Logsにログを送信（awslogsログドライバーが設定されている場合）
      #   - "OVERRIDE": log_configurationで指定した設定でログを送信
      # 省略時: "DEFAULT"
      # 注意: "OVERRIDE"を指定する場合は、log_configurationブロックが必須です
      logging = "DEFAULT"

      # log_configuration (Optional)
      # 設定内容: 実行コマンドの結果のログ設定を指定します。
      # 注意: loggingが "OVERRIDE" の場合に必須です
      log_configuration {
        # cloud_watch_encryption_enabled (Optional)
        # 設定内容: CloudWatch Logsでの暗号化を有効にするかどうかを指定します。
        # 設定可能な値: true, false
        # 省略時: false（暗号化無効）
        cloud_watch_encryption_enabled = false

        # cloud_watch_log_group_name (Optional)
        # 設定内容: ログを送信するCloudWatch Logsのロググループ名を指定します。
        # 設定可能な値: CloudWatch Logsグループ名
        cloud_watch_log_group_name = null

        # s3_bucket_name (Optional)
        # 設定内容: ログを送信するS3バケット名を指定します。
        # 設定可能な値: S3バケット名
        s3_bucket_name = null

        # s3_bucket_encryption_enabled (Optional)
        # 設定内容: S3に送信されるログの暗号化を有効にするかどうかを指定します。
        # 設定可能な値: true, false
        # 省略時: false（暗号化無効）
        s3_bucket_encryption_enabled = false

        # s3_key_prefix (Optional)
        # 設定内容: S3バケット内にログを配置するオプションのフォルダパスを指定します。
        # 設定可能な値: S3オブジェクトキーのプレフィックス
        s3_key_prefix = null
      }
    }

    #-----------------------------------------------------------
    # マネージドストレージ設定 (managed_storage_configuration)
    #-----------------------------------------------------------
    # ECSタスクが使用するマネージドストレージの暗号化設定を指定します。
    # Fargateエフェメラルストレージやその他のマネージドストレージに
    # カスタマー管理のKMSキーを使用できます。
    managed_storage_configuration {
      # fargate_ephemeral_storage_kms_key_id (Optional)
      # 設定内容: Fargateエフェメラルストレージ用のKMSキーARNを指定します。
      # 設定可能な値: KMSキーのARN
      # 注意: このキーを使用するには、適切なKMSキーポリシーの設定が必要です。
      #       Fargateサービスに対して、暗号化コンテキストを用いた
      #       GenerateDataKeyWithoutPlaintextおよびCreateGrant権限を付与する必要があります。
      # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/fargate-task-storage.html
      fargate_ephemeral_storage_kms_key_id = null

      # kms_key_id (Optional)
      # 設定内容: マネージドストレージを暗号化するためのKMSキーARNを指定します。
      # 設定可能な値: KMSキーのARN
      kms_key_id = null
    }
  }

  #-------------------------------------------------------------
  # Service Connect デフォルト設定
  #-------------------------------------------------------------

  # service_connect_defaults (Optional)
  # 設定内容: デフォルトのService Connect名前空間を指定します。
  #          サービス作成時にService Connect設定を指定しない場合に使用されます。
  # 関連機能: ECS Service Connect
  #   サービス間の通信を簡素化し、サービスディスカバリーと接続管理を自動化します。
  #   - https://docs.aws.amazon.com/AmazonECS/latest/developerguide/service-connect.html
  service_connect_defaults {
    # namespace (Required)
    # 設定内容: Service Connect設定を指定しない場合に使用される
    #          Service Discovery HTTPネームスペースのARNを指定します。
    # 設定可能な値: aws_service_discovery_http_namespace リソースのARN
    # 注意: このnamespaceは、クラスター内のサービスでService Connectを使用する際の
    #       デフォルトとして機能します
    namespace = "arn:aws:servicediscovery:ap-northeast-1:123456789012:namespace/ns-xxxxxxxxxxxx"
  }

  #-------------------------------------------------------------
  # クラスター設定
  #-------------------------------------------------------------

  # setting (Optional)
  # 設定内容: クラスターの設定項目を指定するブロックです。
  # 注意: 複数のsettingブロックを指定できます
  setting {
    # name (Required)
    # 設定内容: 管理する設定の名前を指定します。
    # 設定可能な値:
    #   - "containerInsights": CloudWatch Container Insightsの有効化設定
    name = "containerInsights"

    # value (Required)
    # 設定内容: 設定に割り当てる値を指定します。
    # 設定可能な値:
    #   - "enhanced": 拡張モード（より詳細なメトリクスとログを収集）
    #   - "enabled": 有効
    #   - "disabled": 無効
    # 関連機能: CloudWatch Container Insights
    #   ECSクラスター、タスク、サービスのメトリクスとログを収集・可視化します。
    #   - https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/ContainerInsights.html
    value = "enabled"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: クラスターを識別するARN
#
# - id: クラスターの名前
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
