###################################################################################
# Terraform Template: aws_docdb_cluster_parameter_group
###################################################################################
# Provider Version: 6.28.0
# Generated: 2026-02-14
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/docdb_cluster_parameter_group
#
# NOTE: このテンプレートは参考実装です。実際の利用時は環境に応じて適切に調整してください。
#
# 用途: Amazon DocumentDBクラスター内の全インスタンスに適用されるパラメータグループを作成
# 説明: DocumentDBクラスター全体に共通のエンジン設定値を定義し、監査ログや
#       プロファイラー、TLS設定などの動作を制御するパラメータグループを管理
#
# 主な用途:
#   - クラスター全体のエンジン設定変更（監査ログ、プロファイラーなど）
#   - TLS接続の有効化/無効化設定
#   - 変更ストリーム機能の設定
#   - 監査ログ出力先CloudWatch Logsグループの指定
#
# 制限事項:
#   - デフォルトパラメータグループ（default.docdb*）は変更不可（カスタムグループが必要）
#   - パラメータグループ名は一意である必要があり、小文字で保存される
#   - 静的パラメータの変更は、クラスター内全インスタンスの再起動が必要
#   - パラメータグループの変更後、少なくとも5分待機してから適用を推奨
#
# 注意事項:
#   - パラメータのapply_method指定により、即座反映（immediate）か再起動必須（pending-reboot）か決定
#   - familyはDocumentDBエンジンバージョン（例: docdb3.6, docdb4.0, docdb5.0）と一致させる必要あり
#   - パラメータ変更は全インスタンスに適用されるため、クラスター全体への影響を考慮
#
# AWS公式ドキュメント:
#   https://docs.aws.amazon.com/documentdb/latest/developerguide/cluster_parameter_groups-create.html
#   https://docs.aws.amazon.com/documentdb/latest/developerguide/API_CreateDBClusterParameterGroup.html
#
# AWS Provider DocumentDB リソース一覧:
#   - aws_docdb_cluster                      # DocumentDBクラスター本体
#   - aws_docdb_cluster_instance             # クラスター内のインスタンス
#   - aws_docdb_cluster_parameter_group      # クラスターパラメータグループ（本リソース）
#   - aws_docdb_cluster_snapshot             # クラスタースナップショット
#   - aws_docdb_subnet_group                 # サブネットグループ
#   - aws_docdb_event_subscription           # イベントサブスクリプション
#   - aws_docdb_global_cluster               # グローバルクラスター
###################################################################################

#-------
# 基本設定
#-------
resource "aws_docdb_cluster_parameter_group" "example" {
  # パラメータグループ名
  # 設定内容: パラメータグループの一意識別名（name_prefixと排他）
  # 設定可能な値: 英数字とハイフン、1文字目は英字、最大255文字、小文字で保存
  # 省略時: name_prefixが指定されていればそれを使用、両方省略時は自動生成
  name = "example-docdb-cluster-params"

  # パラメータグループ名プレフィックス
  # 設定内容: パラメータグループ名のプレフィックス（nameと排他）
  # 設定可能な値: 英数字とハイフン、1文字目は英字、以降にランダム文字列が付与される
  # 省略時: nameが指定されていればそれを使用、両方省略時は"terraform-"が使用される
  # name_prefix = "prod-docdb-"

  # パラメータグループファミリ（必須）
  # 設定内容: このパラメータグループが互換性を持つDocumentDBエンジンファミリ
  # 設定可能な値: docdb3.6, docdb4.0, docdb5.0など（エンジンバージョンに依存）
  # 省略時: 省略不可（必須パラメータ）
  family = "docdb5.0"

  # パラメータグループの説明
  # 設定内容: パラメータグループの目的や用途を説明するテキスト
  # 設定可能な値: 任意の文字列
  # 省略時: "Managed by Terraform"が設定される
  description = "DocumentDB cluster parameter group for production environment"

  # リソースタグ
  # 設定内容: パラメータグループに付与する任意のタグ
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  tags = {
    Name        = "example-docdb-cluster-params"
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}

#-------
# 名前プレフィックス設定
#-------
resource "aws_docdb_cluster_parameter_group" "prefix_example" {
  # name_prefixを使用した名前自動生成
  name_prefix = "prod-docdb-"
  family      = "docdb5.0"
  description = "DocumentDB parameter group with auto-generated name"

  parameter {
    name  = "audit_logs"
    value = "enabled"
  }

  tags = {
    Name = "prod-docdb-auto-named"
  }
}

#-------
# 監査ログとセキュリティ設定
#-------
resource "aws_docdb_cluster_parameter_group" "audit_enabled" {
  name        = "docdb-audit-enabled"
  family      = "docdb5.0"
  description = "DocumentDB parameter group with audit logging enabled"

  # 監査ログ有効化
  parameter {
    # パラメータ名（必須）
    # 設定内容: 設定対象のパラメータの名前
    # 設定可能な値: DocumentDBエンジンが定義する有効なパラメータ名
    # 省略時: 省略不可（必須パラメータ）
    name = "audit_logs"

    # パラメータ値（必須）
    # 設定内容: パラメータに設定する値
    # 設定可能な値: パラメータにより異なる（enabled, disabled, 数値など）
    # 省略時: 省略不可（必須パラメータ）
    value = "enabled"

    # 適用方法
    # 設定内容: パラメータ変更の適用タイミング指定
    # 設定可能な値: immediate（即座適用）, pending-reboot（再起動時適用）
    # 省略時: 動的パラメータはimmediate、静的パラメータはpending-rebootが自動選択
    apply_method = "immediate"
  }

  # TLS接続の強制
  parameter {
    name         = "tls"
    value        = "enabled"
    apply_method = "pending-reboot"
  }

  # 変更ストリーム有効化
  parameter {
    name         = "change_stream_log_retention_duration"
    value        = "10800" # 3時間（秒単位）
    apply_method = "immediate"
  }

  tags = {
    Name      = "docdb-audit-enabled"
    Compliance = "enabled"
  }
}

#-------
# プロファイラーとパフォーマンス設定
#-------
resource "aws_docdb_cluster_parameter_group" "profiler_enabled" {
  name        = "docdb-profiler-enabled"
  family      = "docdb5.0"
  description = "DocumentDB parameter group with profiler enabled"

  # プロファイラー有効化
  parameter {
    name         = "profiler"
    value        = "enabled"
    apply_method = "immediate"
  }

  # プロファイラーのしきい値（ミリ秒）
  parameter {
    name         = "profiler_threshold_ms"
    value        = "100"
    apply_method = "immediate"
  }

  # プロファイラーのサンプリングレート
  parameter {
    name         = "profiler_sampling_rate"
    value        = "1.0"
    apply_method = "immediate"
  }

  tags = {
    Name        = "docdb-profiler-enabled"
    Monitoring  = "enhanced"
  }
}

#-------
# リージョン指定設定
#-------
resource "aws_docdb_cluster_parameter_group" "regional" {
  name        = "docdb-ap-northeast-1"
  family      = "docdb5.0"
  description = "DocumentDB parameter group for Tokyo region"

  # リージョン指定
  # 設定内容: パラメータグループを管理するAWSリージョン
  # 設定可能な値: 有効なAWSリージョンコード（ap-northeast-1, us-east-1など）
  # 省略時: プロバイダー設定のリージョンが使用される
  region = "ap-northeast-1"

  parameter {
    name  = "audit_logs"
    value = "enabled"
  }

  tags = {
    Name   = "docdb-ap-northeast-1"
    Region = "Tokyo"
  }
}

#-------
# 複数パラメータ設定
#-------
resource "aws_docdb_cluster_parameter_group" "comprehensive" {
  name        = "docdb-comprehensive-config"
  family      = "docdb5.0"
  description = "Comprehensive DocumentDB parameter configuration"

  # 監査ログ設定
  parameter {
    name         = "audit_logs"
    value        = "enabled"
    apply_method = "immediate"
  }

  # TLS必須化
  parameter {
    name         = "tls"
    value        = "enabled"
    apply_method = "pending-reboot"
  }

  # プロファイラー設定
  parameter {
    name         = "profiler"
    value        = "enabled"
    apply_method = "immediate"
  }

  parameter {
    name         = "profiler_threshold_ms"
    value        = "200"
    apply_method = "immediate"
  }

  # 変更ストリーム設定
  parameter {
    name         = "change_stream_log_retention_duration"
    value        = "21600" # 6時間
    apply_method = "immediate"
  }

  # TTLモニター有効化
  parameter {
    name         = "ttl_monitor"
    value        = "enabled"
    apply_method = "immediate"
  }

  tags = {
    Name        = "docdb-comprehensive-config"
    Environment = "production"
    Compliance  = "strict"
  }
}

###################################################################################
# Attributes Reference（参照可能な属性）
###################################################################################
# このリソースでは以下の属性が参照可能:
#
# id          - パラメータグループ名（nameと同じ値）
# arn         - パラメータグループのAmazon Resource Name（ARN）
# name        - パラメータグループ名
# region      - パラメータグループが管理されているリージョン
# tags_all    - デフォルトタグとリソースタグを統合した全タグのマップ
#
# 参照例:
#   output "parameter_group_arn" {
#     value = aws_docdb_cluster_parameter_group.example.arn
#   }
###################################################################################

###################################################################################
# Import
###################################################################################
# 既存のDocumentDBクラスターパラメータグループをインポート可能:
#
# terraform import aws_docdb_cluster_parameter_group.example example-docdb-cluster-params
#
# インポート時の識別子: パラメータグループ名
###################################################################################
