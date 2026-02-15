#-------
# AWS Provider v6.28.0
# resource "aws_dax_cluster"
# Provider Version: 6.28.0
# Generated: 2026-02-14
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/dax_cluster
#-------
# NOTE: DynamoDB Accelerator（DAX）クラスターの作成により、DynamoDBテーブルへのマイクロ秒レベルの
# 読み取りアクセスを実現します。暗号化設定は作成後変更不可のため、事前に要件を確認してください。
#-------
# 目的: DynamoDB用のインメモリキャッシュクラスターを作成し、読み取りパフォーマンスを最大10倍向上
#
# 主な用途:
# - DynamoDBテーブルの読み取り集約的なワークロードの高速化
# - アプリケーション側のキャッシュロジック実装を不要化
# - マイクロ秒レベルのレスポンスタイムが必要なリアルタイムアプリケーション
#
# 関連リソース:
# - aws_dax_subnet_group: クラスターを配置するサブネットグループ
# - aws_dax_parameter_group: クラスターの動作パラメータ設定
# - aws_iam_role: DAXがDynamoDBにアクセスするためのロール

#-----------------------------------------------------------------------
# 基本設定
#-----------------------------------------------------------------------

# クラスター名（必須）
# 設定内容: DAXクラスターの一意な識別名
# 設定可能な値: 1〜20文字の英数字とハイフン（先頭は英字）
variable "cluster_name" {
  type    = string
  default = "my-dax-cluster"
}

# IAMロールARN（必須）
# 設定内容: DAXがDynamoDBにアクセスするために使用するIAMロールのARN
# 注意点: DAXサービスプリンシパルを信頼するロールで、DynamoDBへのアクセス権限が必要
variable "iam_role_arn" {
  type    = string
  default = "arn:aws:iam::123456789012:role/DAXServiceRole"
}

# ノードタイプ（必須）
# 設定内容: クラスター内の各ノードのコンピューティングとメモリ容量
# 設定可能な値: dax.t3.small, dax.t3.medium, dax.r4.large, dax.r4.xlarge, dax.r4.2xlarge, dax.r4.4xlarge, dax.r4.8xlarge, dax.r4.16xlarge, dax.r5.large, dax.r5.xlarge, dax.r5.2xlarge, dax.r5.4xlarge, dax.r5.8xlarge, dax.r5.12xlarge, dax.r5.16xlarge, dax.r5.24xlarge
variable "node_type" {
  type    = string
  default = "dax.t3.small"
}

# レプリケーションファクター（必須）
# 設定内容: クラスター内のノード数
# 設定可能な値: 1〜10（1は高可用性なし、3以上推奨）
# 注意点: ノード数が増えるとコストと可用性が向上
variable "replication_factor" {
  type    = number
  default = 1
}

#-----------------------------------------------------------------------
# ネットワーク設定
#-----------------------------------------------------------------------

# アベイラビリティゾーン
# 設定内容: クラスターノードを配置するAZ一覧
# 省略時: AWSが自動選択
# 注意点: レプリケーションファクターと同数またはそれ以上のAZを指定可能
variable "availability_zones" {
  type    = set(string)
  default = null
}

# サブネットグループ名
# 設定内容: クラスターを配置するサブネットグループ
# 省略時: デフォルトサブネットグループ使用
# 関連: aws_dax_subnet_group
variable "subnet_group_name" {
  type    = string
  default = null
}

# セキュリティグループID
# 設定内容: クラスターに関連付けるセキュリティグループのID一覧
# 省略時: デフォルトVPCセキュリティグループ使用
# 注意点: クライアントからのインバウンドトラフィック（ポート8111）を許可する必要あり
variable "security_group_ids" {
  type    = set(string)
  default = null
}

#-----------------------------------------------------------------------
# 暗号化とセキュリティ
#-----------------------------------------------------------------------

# クラスターエンドポイント暗号化タイプ
# 設定内容: クライアント-クラスター間の通信暗号化方式
# 設定可能な値: NONE（暗号化なし）, TLS（TLS暗号化）
# 省略時: NONE
# 注意点: 一度設定すると変更には再作成が必要
variable "cluster_endpoint_encryption_type" {
  type    = string
  default = null
}

#-----------------------------------------------------------------------
# パラメータとメンテナンス
#-----------------------------------------------------------------------

# パラメータグループ名
# 設定内容: クラスターの動作を制御するパラメータグループ
# 省略時: デフォルトパラメータグループ使用
# 関連: aws_dax_parameter_group
variable "parameter_group_name" {
  type    = string
  default = null
}

# メンテナンスウィンドウ
# 設定内容: システムメンテナンスを実行する週次時間帯
# 設定可能な値: ddd:hh24:mi-ddd:hh24:mi形式（例: sun:05:00-sun:06:00、UTC）
# 省略時: AWSが自動設定
variable "maintenance_window" {
  type    = string
  default = null
}

#-----------------------------------------------------------------------
# 通知とモニタリング
#-----------------------------------------------------------------------

# 通知トピックARN
# 設定内容: クラスターイベント通知を送信するSNSトピックARN
# 省略時: 通知なし
# 関連: aws_sns_topic
variable "notification_topic_arn" {
  type    = string
  default = null
}

#-----------------------------------------------------------------------
# その他の設定
#-----------------------------------------------------------------------

# 説明
# 設定内容: クラスターの説明文
# 省略時: 説明なし
variable "description" {
  type    = string
  default = null
}

# リージョン
# 設定内容: リソースを管理するAWSリージョン
# 省略時: プロバイダー設定のリージョン使用
# 注意点: 通常は省略してプロバイダー設定に依存
variable "region" {
  type    = string
  default = null
}

# タグ
# 設定内容: クラスターに付与するリソースタグ
# 省略時: タグなし
variable "tags" {
  type    = map(string)
  default = null
}


#-----------------------------------------------------------------------
# リソース定義
#-----------------------------------------------------------------------

resource "aws_dax_cluster" "this" {
  cluster_name                     = var.cluster_name
  iam_role_arn                     = var.iam_role_arn
  node_type                        = var.node_type
  replication_factor               = var.replication_factor
  availability_zones               = var.availability_zones
  subnet_group_name                = var.subnet_group_name
  security_group_ids               = var.security_group_ids
  cluster_endpoint_encryption_type = var.cluster_endpoint_encryption_type
  parameter_group_name             = var.parameter_group_name
  maintenance_window               = var.maintenance_window
  notification_topic_arn           = var.notification_topic_arn
  description                      = var.description
  region                           = var.region
  tags                             = var.tags

  #-----------------------------------------------------------------------
  # サーバーサイド暗号化設定
  #-----------------------------------------------------------------------
  server_side_encryption {
    # 設定内容: 保存データの暗号化を有効にするか
    # 設定可能な値: true（有効）, false（無効）
    # 省略時: false
    # 注意点: 一度有効化すると無効化には再作成が必要
    enabled = false
  }

  #-----------------------------------------------------------------------
  # タイムアウト設定
  #-----------------------------------------------------------------------
  timeouts {
    # 設定内容: クラスター作成操作のタイムアウト時間
    # 設定可能な値: 時間文字列（例: 45m, 1h）
    # 省略時: 45m
    create = "45m"

    # 設定内容: クラスター更新操作のタイムアウト時間
    # 設定可能な値: 時間文字列（例: 90m）
    # 省略時: 90m
    update = "90m"

    # 設定内容: クラスター削除操作のタイムアウト時間
    # 設定可能な値: 時間文字列（例: 45m）
    # 省略時: 45m
    delete = "45m"
  }
}

#-----------------------------------------------------------------------
# Attributes Reference（参照可能な属性）
#-----------------------------------------------------------------------
# arn                     - クラスターのARN
# cluster_address         - クラスター検出エンドポイントのDNS名
# configuration_endpoint  - 設定エンドポイントのアドレス
# id                      - クラスター名（リソースID）
# port                    - クラスターが使用するポート番号（通常8111）
# nodes                   - クラスターノード一覧（各ノードのaddress, availability_zone, id, port含む）
#
# 参照方法:
# aws_dax_cluster.this.arn
# aws_dax_cluster.this.cluster_address
# aws_dax_cluster.this.configuration_endpoint
# aws_dax_cluster.this.port
# aws_dax_cluster.this.nodes[0].address
