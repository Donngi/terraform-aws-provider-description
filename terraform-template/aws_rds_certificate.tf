#---------------------------------------------------------------
# AWS RDS Certificate (Data Source)
#---------------------------------------------------------------
#
# RDS証明書情報を取得するためのデータソースです。
# Amazon RDSでSSL/TLS接続を使用する際に必要な証明書の情報を取得します。
#
# このデータソースを使用することで、以下の情報を取得できます:
#   - 証明書のARN、サムプリント
#   - 証明書の有効期間（開始日、終了日）
#   - 証明書タイプ
#   - デフォルト証明書の情報
#
# 主な用途:
#   - RDSインスタンスやクラスターのSSL/TLS証明書設定
#   - 最新の有効な証明書の自動選択
#   - 証明書のローテーション管理
#
# AWS公式ドキュメント:
#   - SSL/TLSを使用したDB接続: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.SSL.html
#   - 証明書のローテーション: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.SSL-certificate-rotation.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/rds_certificate
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

data "aws_rds_certificate" "example" {
  #-------------------------------------------------------------
  # 証明書識別子 (オプション)
  #-------------------------------------------------------------

  # id (Optional)
  # 設定内容: 取得する証明書の識別子を指定します。
  # 設定可能な値: 証明書ID（例: "rds-ca-2019", "rds-ca-rsa2048-g1"）
  # 省略時: 他のフィルター条件（latest_valid_till や default_for_new_launches）に基づいて証明書を検索
  # 用途: 特定の証明書を明示的に取得する場合に使用
  # 例:
  #   - "rds-ca-2019": 2019年にリリースされたCA証明書
  #   - "rds-ca-rsa2048-g1": RSA 2048ビットの証明書
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.SSL.html
  id = null

  #-------------------------------------------------------------
  # 最新の有効期限証明書 (オプション)
  #-------------------------------------------------------------

  # latest_valid_till (Optional)
  # 設定内容: 有効期限が最も遅い証明書を取得するかどうかを指定します。
  # 設定可能な値: true または false
  # 省略時: false
  # 用途:
  #   - 証明書のローテーション時に最新の証明書を自動的に取得
  #   - 長期間有効な証明書を選択
  # 注意:
  #   - id が指定されている場合、このオプションは無視されます
  #   - default_for_new_launches と併用すると、両方の条件を満たす証明書を検索します
  # ベストプラクティス: 証明書の自動更新を行う場合は true を設定することを推奨
  latest_valid_till = true

  #-------------------------------------------------------------
  # 新規起動時のデフォルト証明書 (オプション)
  #-------------------------------------------------------------

  # default_for_new_launches (Optional)
  # 設定内容: 新しいRDSインスタンス作成時のデフォルト証明書を取得するかどうかを指定します。
  # 設定可能な値: true または false
  # 省略時: false
  # 用途:
  #   - 新規RDSインスタンスで使用される証明書を確認
  #   - AWSが推奨する証明書を取得
  # 注意:
  #   - リージョンによってデフォルト証明書が異なる場合があります
  #   - カスタマーオーバーライドが設定されている場合、その情報も取得できます
  default_for_new_launches = null

  #-------------------------------------------------------------
  # リージョン設定 (オプション)
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: 証明書情報を取得するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1, eu-west-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 用途:
  #   - マルチリージョン環境で特定のリージョンの証明書を取得
  #   - クロスリージョンレプリケーション時の証明書管理
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このデータソースは以下の属性をエクスポートします:
#
# - arn: 証明書のAmazon Resource Name (ARN)
#   形式: arn:aws:rds:{region}::cert:{certificate-id}
#   用途: IAMポリシーやタグ付けでの証明書参照
#
# - certificate_type: 証明書のタイプ
#   値: "CA"（Certificate Authority）
#   説明: RDS証明書は通常CA証明書として提供されます
#
# - customer_override: デフォルト証明書の顧客オーバーライドが存在するかどうか
#   値: true または false
#   説明: カスタム証明書が設定されている場合に true
#
# - customer_override_valid_till: 顧客オーバーライドの有効期限
#   形式: RFC3339形式のタイムスタンプ
#   例: "2024-08-22T17:08:50Z"
#   説明: customer_override が true の場合のみ値が設定されます
#
# - thumbprint: 証明書のサムプリント（SHA-1ハッシュ）
#   例: "1234567890ABCDEF1234567890ABCDEF12345678"
#   用途: 証明書の検証、識別
#
# - valid_from: 証明書の有効期間開始日時
#   形式: RFC3339形式のタイムスタンプ
#   例: "2019-09-19T18:16:53Z"
#
# - valid_till: 証明書の有効期間終了日時
#   形式: RFC3339形式のタイムスタンプ
#   例: "2024-08-22T17:08:50Z"
#   用途: 証明書のローテーション計画、有効期限監視
#
# - id: 証明書の識別子（入力パラメータと同じ）
#   例: "rds-ca-2019"
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------

# 例1: 最新の有効な証明書を取得
# data "aws_rds_certificate" "latest" {
#   latest_valid_till = true
# }

# 例2: 特定の証明書を取得
# data "aws_rds_certificate" "specific" {
#   id = "rds-ca-2019"
# }

# 例3: 新規起動時のデフォルト証明書を取得
# data "aws_rds_certificate" "default" {
#   default_for_new_launches = true
# }

# 例4: RDSクラスターで証明書を使用
# resource "aws_rds_cluster" "example" {
#   cluster_identifier  = "my-cluster"
#   engine             = "aurora-mysql"
#   master_username    = "admin"
#   master_password    = "changeme"
#
#   # 取得した最新の証明書を適用
#   ca_certificate_identifier = data.aws_rds_certificate.latest.id
# }

# 例5: 証明書の有効期限を監視
# output "certificate_expiry" {
#   description = "RDS証明書の有効期限"
#   value       = data.aws_rds_certificate.latest.valid_till
# }

#---------------------------------------------------------------
