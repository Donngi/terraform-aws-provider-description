#---------------------------------------------------------------
# Amazon OpenSearch Service ドメインアクセスポリシー
#---------------------------------------------------------------
#
# Amazon OpenSearch Serviceドメインのリソースベースアクセスポリシーを管理する
# リソースです。このポリシーは、どのプリンシパル（ユーザー、ロール、サービス）が
# ドメインのサブリソース（インデックス、API等）に対してどのアクションを実行できるかを
# 定義します。
#
# 主な用途:
# - ドメインへのIPアドレスベースのアクセス制限
# - 特定のIAMプリンシパルへのアクセス許可
# - クロスアカウントアクセスの構成
# - サービス（Lambda、EC2等）からのアクセス許可
#
# セキュリティレイヤーの位置付け:
# OpenSearch Serviceには3つのセキュリティレイヤーがあります:
# 1. ネットワーク層: リクエストがドメインに到達できるかを決定（VPC、セキュリティグループ）
# 2. ドメインアクセスポリシー層（このリソース）: ドメインのエッジでリクエストを許可/拒否
# 3. きめ細かいアクセス制御層: ユーザー認証と詳細な権限管理（インデックス、ドキュメント、フィールドレベル）
#
# AWS公式ドキュメント:
#   - Identity and Access Management: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/ac.html
#   - Fine-grained access control: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/fgac.html
#   - Resource-based policies: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/ac.html#ac-types-resource
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearch_domain_policy
#
# Provider Version: 6.28.0
# Generated: 2026-01-31
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_opensearch_domain_policy" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # domain_name (Required)
  # 設定内容: アクセスポリシーを設定するOpenSearch Serviceドメインの名前を指定します。
  # 設定可能な値: 既存のOpenSearch Serviceドメイン名
  # 参照方法: 通常は aws_opensearch_domain リソースの domain_name 属性を参照します
  # 注意: このリソースはポリシーのみを管理します。OpenSearch Serviceドメイン自体の
  #       作成は aws_opensearch_domain リソースで行う必要があります。
  # 例:
  #   domain_name = aws_opensearch_domain.example.domain_name
  domain_name = "example-domain"

  # access_policies (Required)
  # 設定内容: ドメインに適用するIAMポリシードキュメントをJSON形式で指定します。
  #           このポリシーは、どのプリンシパルがドメインのどのリソースに対して
  #           どのアクションを実行できるかを定義します。
  # 設定可能な値: 有効なIAMポリシードキュメント（JSON形式の文字列）
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 用途: マルチリージョン構成で、リソースごとに異なるリージョンを指定する場合に使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウトをカスタマイズします。
  # 注意: OpenSearchドメインのポリシー更新は、ドメインの状態によっては
  #       時間がかかる場合があります。必要に応じてタイムアウトを調整してください。
  timeouts {

    # update (Optional)
    # 設定内容: ポリシーの更新操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "60m", "1h", "90m"）
    # 省略時: デフォルトのタイムアウト値を使用
    # 推奨値: 大規模なドメインや複雑なポリシーの場合は "60m" 以上を推奨
    update = null

    # delete (Optional)
    # 設定内容: ポリシーの削除操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "60m", "1h", "90m"）
    # 省略時: デフォルトのタイムアウト値を使用
    # 推奨値: 大規模なドメインの場合は "60m" 以上を推奨
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ポリシーが関連付けられているドメインの名前
#---------------------------------------------------------------

#---------------------------------------------------------------
# ポリシー設定例
#---------------------------------------------------------------

# 例1: IPアドレスベースのアクセス制限
# 特定のIPアドレス範囲からのみアクセスを許可する最も一般的なパターンです。
# VPC外からのアクセスを制限する場合に使用します。
#
# data "aws_iam_policy_document" "ip_restricted" {
#   statement {
#     effect = "Allow"
#
#     principals {
#       type        = "*"
#       identifiers = ["*"]
#     }
#
#---------------------------------------------------------------
