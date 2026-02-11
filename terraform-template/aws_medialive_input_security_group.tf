#---------------------------------------------------------------
# AWS MediaLive Input Security Group
#---------------------------------------------------------------
#
# Amazon MediaLive の入力セキュリティグループをプロビジョニングするリソースです。
# 入力セキュリティグループは、特定の入力に対してコンテンツを送信することが許可された
# IPアドレス範囲（CIDRブロック）のリストを定義します。
# セキュリティグループに関連付けられた入力には、定義されたルール内のIPアドレスを持つ
# アップストリームシステムのみがコンテンツをプッシュできます。
#
# AWS公式ドキュメント:
#   - 入力セキュリティグループの操作: https://docs.aws.amazon.com/medialive/latest/ug/working-with-input-security-groups.html
#   - 入力セキュリティグループの作成: https://docs.aws.amazon.com/medialive/latest/ug/create-input-security-groups.html
#   - 入力セキュリティグループの目的: https://docs.aws.amazon.com/medialive/latest/ug/purpose-input-security-groups.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/medialive_input_security_group
#
# Provider Version: 6.28.0
# Generated: 2026-01-31
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_medialive_input_security_group" "example" {
  #-------------------------------------------------------------
  # ホワイトリストルール設定
  #-------------------------------------------------------------

  # whitelist_rules (Required)
  # 設定内容: 入力へのアクセスを許可するIPアドレス範囲（CIDRブロック）のリストを指定します。
  # 設定可能な値: 1個以上のホワイトリストルールブロック。最大10個まで指定可能。
  # 関連機能: MediaLive 入力セキュリティグループ
  #   各ルールはIPv4 CIDRブロックを指定します。入力セキュリティグループに関連付けられた
  #   入力には、これらのCIDRブロック内のIPアドレスからのみコンテンツをプッシュできます。
  #   MediaLiveは、入力セキュリティグループ外のIPアドレスからのプッシュリクエストを無視します。
  #   - https://docs.aws.amazon.com/medialive/latest/ug/working-with-input-security-groups.html
  # 用途: RTPやRTMPプッシュ入力（VPCを使用しない）のセキュリティ保護に使用します。
  #       VPC入力、MediaConnect入力、Elemental Link入力には不要です。
  # 参考: https://docs.aws.amazon.com/medialive/latest/ug/purpose-input-security-groups.html
  whitelist_rules {
    # cidr (Required)
    # 設定内容: 許可するIPv4 CIDRブロックを指定します。
    # 設定可能な値: 有効なIPv4 CIDR表記（例: 192.0.2.0/24 はサブネット全体、192.0.2.111/32 は単一IPアドレス）
    # 注意: 各CIDRブロックにはサブネットマスクを含める必要があります。
    # 参考: https://docs.aws.amazon.com/medialive/latest/ug/create-input-security-groups.html
    cidr = "10.0.0.8/32"
  }

  # 複数のホワイトリストルールを追加する例
  whitelist_rules {
    cidr = "203.0.113.0/24"
  }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: 入力セキュリティグループに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-input-security-group"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: 期間を表す文字列（例: "5m", "1h"）
    create = null

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: 期間を表す文字列（例: "5m", "1h"）
    update = null

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: 期間を表す文字列（例: "5m", "1h"）
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 入力セキュリティグループのID
#
# - arn: 入力セキュリティグループのAmazon Resource Name (ARN)
#
# - inputs: この入力セキュリティグループを現在使用している入力のリスト
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
