#---------------------------------------------------------------
# AWS DMS Replication Config
#---------------------------------------------------------------
#
# AWS Database Migration Service (DMS) Serverless レプリケーション設定リソースです。
# DMS Serverless は、レプリケーションインスタンスの管理を必要とせず、
# 自動的にスケーリングされるサーバーレスなデータベース移行ソリューションを提供します。
#
# NOTE: ほとんどの引数を変更すると、実行中のレプリケーションが停止します。
#       変更後にレプリケーションを再開するには start_replication を true に設定してください。
#
# AWS公式ドキュメント:
#   - DMS Serverless 概要: https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Serverless.html
#   - テーブルマッピング: https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Tasks.CustomizingTasks.TableMapping.html
#   - タスク設定: https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Tasks.CustomizingTasks.TaskSettings.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dms_replication_config
#
# Provider Version: 6.28.0
# Generated: 2026-01-31
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_dms_replication_config" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # replication_config_identifier (Required)
  # 設定内容: レプリケーション設定を作成するための一意な識別子を指定します。
  # 設定可能な値: 文字列（一意な値）
  # 注意: この識別子は、レプリケーション設定を一意に特定するために使用されます。
  replication_config_identifier = "example-dms-serverless-replication-config"

  # replication_type (Required)
  # 設定内容: 実行する移行のタイプを指定します。
  # 設定可能な値:
  #   - "full-load": 既存データの完全ロードのみを実行
  #   - "cdc": 変更データキャプチャ（継続的レプリケーション）のみを実行
  #   - "full-load-and-cdc": 完全ロード後に継続的レプリケーションを実行
  # 参考: https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Task.CDC.html
  replication_type = "full-load-and-cdc"

  # source_endpoint_arn (Required)
  # 設定内容: ソースエンドポイントを一意に識別する Amazon Resource Name (ARN) を指定します。
  # 設定可能な値: DMS エンドポイントの ARN
  # 注意: aws_dms_endpoint リソースで作成したソースエンドポイントの ARN を指定します。
  source_endpoint_arn = "arn:aws:dms:us-east-1:123456789012:endpoint:ABCDEFGHIJKLMNOPQRSTUVWXYZ"

  # target_endpoint_arn (Required)
  # 設定内容: ターゲットエンドポイントを一意に識別する Amazon Resource Name (ARN) を指定します。
  # 設定可能な値: DMS エンドポイントの ARN
  # 注意: aws_dms_endpoint リソースで作成したターゲットエンドポイントの ARN を指定します。
  target_endpoint_arn = "arn:aws:dms:us-east-1:123456789012:endpoint:ZYXWVUTSRQPONMLKJIHGFEDCBA"

  # table_mappings (Required)
  # 設定内容: テーブルマッピングを含むエスケープされた JSON 文字列を指定します。
  # 設定可能な値: JSON 文字列（エスケープ済み）
  # 注意:
  #   - どのテーブルをレプリケーションに含めるかを定義するルールを記述します。
  #   - selection ルール: レプリケーション対象のテーブルを選択
  #   - transformation ルール: スキーマ名やテーブル名の変換（オプション）
  # 参考: https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Tasks.CustomizingTasks.TableMapping.html
  table_mappings = jsonencode({
    rules = [
      {
        rule-type   = "selection"
        rule-id     = "1"
        rule-name   = "include-all-tables"
        rule-action = "include"
        object-locator = {
          schema-name = "%"
          table-name  = "%"
        }
      }
    ]
  })

  #-------------------------------------------------------------
  # コンピュート設定（必須ブロック）
  #-------------------------------------------------------------

  # compute_config (Required)
  # 設定内容: DMS Serverless レプリケーションのプロビジョニング設定を指定します。
  compute_config {
    # max_capacity_units (Required)
    # 設定内容: DMS Serverless レプリケーションでプロビジョニング可能な
    #          DMS 容量ユニット (DCU) の最大値を指定します。
    # 設定可能な値: 1, 2, 4, 8, 16, 32, 64, 128, 192, 256, 384
    # 注意:
    #   - 1 DCU = 2GB RAM
    #   - ワークロードのサイズに応じて適切な値を設定してください。
    max_capacity_units = 64

    # min_capacity_units (Optional)
    # 設定内容: DMS Serverless レプリケーションでプロビジョニング可能な
    #          DMS 容量ユニット (DCU) の最小値を指定します。
    # 設定可能な値: 1, 2, 4, 8, 16, 32, 64, 128, 192, 256, 384
    # 省略時: 1（最低許可値）
    # 注意: この値を設定しない場合、DMS は最低許可値の 1 を使用します。
    min_capacity_units = 2

    # availability_zone (Optional)
    # 設定内容: DMS Serverless レプリケーションを実行するアベイラビリティゾーンを指定します。
    # 設定可能な値: 有効な AZ 名（例: us-east-1a）
    # 省略時: ランダムな AZ
    # 注意: multi_az が true の場合、このパラメータは設定できません。
    # availability_zone = "us-east-1a"

    # dns_name_servers (Optional)
    # 設定内容: DMS Serverless レプリケーションがソースまたはターゲットデータベースに
    #          アクセスする際にサポートされるカスタム DNS ネームサーバーのリストを指定します。
    # 設定可能な値: DNS サーバーの IP アドレスのリスト
    # 省略時: デフォルトの DNS ネームサーバーを使用
    # dns_name_servers = ["10.0.0.2", "10.0.1.2"]

    # kms_key_id (Optional)
    # 設定内容: DMS Serverless レプリケーション中にデータを暗号化するために使用する
    #          Key Management Service (KMS) キーの Amazon Resource Name (ARN) を指定します。
    # 設定可能な値: KMS キーの ARN
    # 省略時: DMS のデフォルト暗号化キーを使用
    # 参考: https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Security.html#CHAP_Security.EncryptionAtRest
    # kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

    # multi_az (Optional)
    # 設定内容: レプリケーションインスタンスがマルチ AZ デプロイメントかどうかを指定します。
    # 設定可能な値: true または false
    # 省略時: false
    # 注意:
    #   - multi_az を true に設定すると、availability_zone パラメータは設定できません。
    #   - 高可用性が必要な本番環境では true に設定することを推奨します。
    # multi_az = true

    # preferred_maintenance_window (Optional)
    # 設定内容: システムメンテナンスが実行可能な週次の時間範囲を Universal Coordinated Time (UTC) で指定します。
    # 設定可能な値:
    #   - 形式: ddd:hh24:mi-ddd:hh24:mi
    #   - 有効な曜日: mon, tue, wed, thu, fri, sat, sun
    # 省略時: リージョンごとに 8 時間のブロックからランダムに選択された 30 分ウィンドウ
    # 制約: 最低 30 分のウィンドウが必要
    # 例: "sun:23:45-mon:00:30" は日曜日の 23:45 から月曜日の 00:30 まで
    preferred_maintenance_window = "sun:23:45-mon:00:30"

    # replication_subnet_group_id (Optional)
    # 設定内容: DMS Serverless レプリケーションに関連付けるサブネットグループ識別子を指定します。
    # 設定可能な値: レプリケーションサブネットグループの ID
    # 注意: aws_dms_replication_subnet_group リソースで作成したサブネットグループの ID を指定します。
    # 参考: https://docs.aws.amazon.com/dms/latest/userguide/CHAP_ReplicationInstance.VPC.html
    # replication_subnet_group_id = "example-replication-subnet-group"

    # vpc_security_group_ids (Optional)
    # 設定内容: DMS Serverless レプリケーションで使用する
    #          Virtual Private Cloud (VPC) セキュリティグループ ID のリストを指定します。
    # 設定可能な値: セキュリティグループ ID のリスト
    # 注意: VPC セキュリティグループは、レプリケーションを含む VPC で動作する必要があります。
    # vpc_security_group_ids = ["sg-12345678", "sg-87654321"]
  }

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # resource_identifier (Optional)
  # 設定内容: リソースの Amazon Resource Name (ARN) を構築するために使用できる
  #          一意な値または名前を指定します。
  # 設定可能な値: 文字列
  # 関連機能: きめ細かいアクセス制御で使用されます。
  # 参考: https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Security.html#CHAP_Security.FineGrainedAccess
  resource_identifier = "example-serverless-replication-resource"

  # replication_settings (Optional)
  # 設定内容: このレプリケーション設定をプロビジョニングするために使用される
  #          エスケープされた JSON 文字列を指定します。
  # 設定可能な値: JSON 文字列（エスケープ済み）
  # 注意: レプリケーションタスクの詳細な動作を調整できます。
  # 例: 変更処理チューニング設定、LOB 処理、フルロード設定など
  # 参考: https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Tasks.CustomizingTasks.TaskSettings.ChangeProcessingTuning.html
  # replication_settings = jsonencode({
  #   TargetMetadata = {
  #     TargetSchema           = ""
  #     SupportLobs            = true
  #     FullLobMode            = false
  #     LobChunkSize           = 64
  #     LimitedSizeLobMode     = true
  #     LobMaxSize             = 32
  #   }
  #   FullLoadSettings = {
  #     TargetTablePrepMode              = "DROP_AND_CREATE"
  #     CreatePkAfterFullLoad            = false
  #     StopTaskCachedChangesApplied     = false
  #     StopTaskCachedChangesNotApplied  = false
  #     MaxFullLoadSubTasks              = 8
  #     TransactionConsistencyTimeout    = 600
  #     CommitRate                       = 10000
  #   }
  # })

  # supplemental_settings (Optional)
  # 設定内容: サプリメンタルデータを指定するための JSON 設定を指定します。
  # 設定可能な値: JSON 文字列
  # 参考: https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Tasks.TaskData.html
  # supplemental_settings = jsonencode({})

  # start_replication (Optional)
  # 設定内容: Serverless レプリケーションを実行するか停止するかを指定します。
  # 設定可能な値: true または false
  # 省略時: false
  # 注意:
  #   - true: レプリケーション設定の作成後、自動的にレプリケーションを開始します。
  #   - false: レプリケーション設定のみを作成し、手動で開始する必要があります。
  #   - ほとんどの引数を変更すると、実行中のレプリケーションが停止します。
  #     変更後にレプリケーションを再開するには、このパラメータを true に設定してください。
  start_replication = true

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWS リソースタグ付け
  #   プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-dms-serverless-replication"
    Environment = "production"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーの default_tags から継承されたタグを含む全タグのマップです。
  # 注意: 通常は明示的に設定せず、Terraform が自動計算します。
  # tags_all = {}
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: DMS Serverless レプリケーション設定の Amazon Resource Name (ARN)
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例と補足説明
#---------------------------------------------------------------
#
# DMS Serverless レプリケーション設定の主な特徴:
#
# 1. サーバーレスアーキテクチャ
#    - レプリケーションインスタンスの管理が不要
#    - 自動スケーリングによる容量の最適化
#    - 使用した容量に対してのみ課金
#
# 2. レプリケーションタイプの選択
#    - full-load: 初回の完全データロードのみ
#    - cdc: 変更データキャプチャ（継続的な変更のみ）
#    - full-load-and-cdc: 完全ロード後に継続的な変更をキャプチャ
#
# 3. 容量ユニット (DCU) の設定
#    - 1 DCU = 2GB RAM
#    - min_capacity_units と max_capacity_units で自動スケーリング範囲を定義
#    - ワークロードに応じて適切な範囲を設定することが重要
#
# 4. ネットワークとセキュリティ
#    - replication_subnet_group_id: VPC サブネットの指定
#    - vpc_security_group_ids: セキュリティグループによるアクセス制御
#    - kms_key_id: データの暗号化設定
#
# 5. 高可用性
#    - multi_az: マルチ AZ 配置による冗長性の確保
#    - preferred_maintenance_window: メンテナンスウィンドウの指定
#
# 6. テーブルマッピング
#    - table_mappings: レプリケーション対象のテーブルを選択
#    - selection ルール: 含める/除外するテーブルの指定
#    - transformation ルール: スキーマ名やテーブル名の変換
#
# 7. レプリケーション設定の調整
#    - replication_settings: 詳細なタスク設定（LOB 処理、フルロード設定など）
#    - supplemental_settings: サプリメンタルデータの指定
#
# 8. 変更管理
#    - ほとんどの引数を変更すると実行中のレプリケーションが停止します
#    - start_replication を true に設定することで変更後に自動的に再開可能
#
# ベストプラクティス:
#
# 1. 適切な容量設定
#    - ワークロードのサイズに基づいて DCU 範囲を設定
#    - 初期は小さめに設定し、パフォーマンスを監視しながら調整
#
# 2. ネットワークセキュリティ
#    - 必要最小限のネットワークアクセスをセキュリティグループで設定
#    - プライベートサブネットでの実行を推奨
#
# 3. 暗号化
#    - 機密データの場合は KMS キーを使用した暗号化を推奨
#    - 保存時と転送時の両方で暗号化を検討
#
# 4. 監視とロギング
#    - CloudWatch メトリクスでレプリケーションの状態を監視
#    - CloudWatch Logs でエラーやパフォーマンス問題をトラブルシューティング
#
# 5. テーブルマッピングの最適化
#    - 必要なテーブルのみをレプリケーション対象に含める
#    - 大量のテーブルがある場合は、スキーマレベルでの選択を検討
#
# 6. 本番環境での考慮事項
#    - multi_az を有効にして高可用性を確保
#    - preferred_maintenance_window を業務に影響の少ない時間帯に設定
#    - start_replication は初期構築時は false にして、設定確認後に true に変更
#
# 関連リソース:
# - aws_dms_endpoint: ソースとターゲットのエンドポイント定義
# - aws_dms_replication_subnet_group: レプリケーション用のサブネットグループ
# - aws_dms_event_subscription: DMS イベントの通知設定
# - aws_kms_key: データ暗号化用の KMS キー
#---------------------------------------------------------------
