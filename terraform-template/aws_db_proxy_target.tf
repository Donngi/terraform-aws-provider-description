#---------------------------------------------------------------
# RDS DB Proxy Target
#---------------------------------------------------------------
#
# Amazon RDS Proxy のターゲットリソースを管理します。
# DB Proxy Target は、RDS Proxy がトラフィックをルーティングする
# RDS DB インスタンスまたは Aurora DB クラスターを指定します。
#
# RDS Proxy は、アプリケーションとデータベース間の接続を効率的にプールし、
# アプリケーションのスケーラビリティ、可用性、セキュリティを向上させます。
#
# NOTE: 関連する aws_db_proxy リソースが置換されると、Terraform はこの
# リソースの追跡を失い、次回の apply で予期しない差分が発生します。
# 適切な依存関係管理のため、aws_db_proxy リソースの id 属性を参照する
# replace_triggered_by を持つ lifecycle ブロックを追加することを推奨します。
#
# AWS公式ドキュメント:
#   - RDS Proxy 概要: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/rds-proxy.html
#   - RDS Proxy の作成: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/rds-proxy-creating.html
#   - RDS Proxy エンドポイント: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/rds-proxy-endpoints.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_proxy_target
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_db_proxy_target" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # db_proxy_name (Required, Forces new resource)
  # 設定内容: ターゲットを関連付けるDB Proxyの名前を指定します。
  # 設定可能な値: 既存の aws_db_proxy リソースの名前
  # 注意: この属性を変更するとリソースが再作成されます
  # 関連機能: RDS Proxy
  #   アプリケーションとデータベース間の接続をプールし、
  #   フェイルオーバー時のリカバリ時間を短縮します。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/rds-proxy.html
  db_proxy_name = aws_db_proxy.example.name

  # target_group_name (Required, Forces new resource)
  # 設定内容: ターゲットを関連付けるターゲットグループの名前を指定します。
  # 設定可能な値: 既存の aws_db_proxy_default_target_group リソースの名前
  # 注意: 現在、RDS Proxy は "default" という名前のターゲットグループのみをサポート
  # 注意: この属性を変更するとリソースが再作成されます
  # 関連機能: RDS Proxy ターゲットグループ
  #   接続プール構成を管理し、ターゲットデータベースへの接続を制御します。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/rds-proxy-creating.html
  target_group_name = aws_db_proxy_default_target_group.example.name

  #-------------------------------------------------------------
  # ターゲットデータベース設定
  #-------------------------------------------------------------
  # NOTE: db_instance_identifier または db_cluster_identifier の
  # いずれか一方を指定する必要があります。両方を同時に指定することはできません。

  # db_instance_identifier (Optional, Forces new resource)
  # 設定内容: ターゲットとするRDS DBインスタンスの識別子を指定します。
  # 設定可能な値: 既存の aws_db_instance リソースの識別子
  # 用途: 単一のRDS DBインスタンスをProxyのターゲットにする場合
  # 注意: db_cluster_identifier と同時に指定することはできません
  # 注意: この属性を変更するとリソースが再作成されます
  # 関連機能: RDS DB インスタンス
  #   MySQL, PostgreSQL, MariaDB, SQL Server などの
  #   データベースエンジンを実行する個別のインスタンス。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Overview.DBInstance.html
  db_instance_identifier = aws_db_instance.example.identifier

  # db_cluster_identifier (Optional, Forces new resource)
  # 設定内容: ターゲットとするAurora DBクラスターの識別子を指定します。
  # 設定可能な値: 既存の aws_rds_cluster リソースの識別子
  # 用途: Aurora DBクラスターをProxyのターゲットにする場合
  # 注意: db_instance_identifier と同時に指定することはできません
  # 注意: この属性を変更するとリソースが再作成されます
  # 関連機能: Aurora DB クラスター
  #   高可用性と自動スケーリングを備えたAmazon Aurora データベース。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Aurora.Overview.html
  db_cluster_identifier = null # Aurora使用時: aws_rds_cluster.example.cluster_identifier

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # その他の設定
  #-------------------------------------------------------------

  # id (Optional, Computed)
  # 設定内容: リソースの識別子を指定します。
  # 設定可能な値: 文字列形式の識別子
  # 省略時: Terraform が自動的に生成します
  # 形式: db_proxy_name/target_group_name/ターゲットタイプ/リソース識別子
  # 例: "my-proxy/default/RDS_INSTANCE/my-db-instance"
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  id = null

  #-------------------------------------------------------------
  # ライフサイクル設定の推奨
  #-------------------------------------------------------------
  # 関連する aws_db_proxy リソースが置換されると、
  # Terraform はこのリソースの追跡を失います。
  # 適切な依存関係管理のため、以下の lifecycle ブロックを
  # 追加することを強く推奨します:
  #
  # lifecycle {
  #   replace_triggered_by = [aws_db_proxy.example.id]
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: db_proxy_name, target_group_name, ターゲットタイプ
#   (例: RDS_INSTANCE または TRACKED_CLUSTER)、およびリソース識別子を
#   スラッシュ (/) で区切った識別子
#   例: "my-proxy/default/RDS_INSTANCE/my-db-instance"
#
# - endpoint: ターゲット RDS DB インスタンスのホスト名
#   RDS_INSTANCE タイプの場合のみ返されます
#
# - port: ターゲット RDS DB インスタンスまたは Aurora DB クラスターのポート番号
#
# - rds_resource_id: DB インスタンスまたは DB クラスターターゲットを表す識別子
#
# - target_arn: DB インスタンスまたは DB クラスターの Amazon Resource Name (ARN)
#   現在、RDS API からは返されません
#
# - tracked_cluster_id: DB Instance ターゲットの DB クラスター識別子
#   DB クラスターの一部である RDS_INSTANCE ターゲットを手動でインポートする
#   場合を除き、返されません
#
# - type: ターゲットのタイプ
#---------------------------------------------------------------
