#---------------------------------------------------------------
# AWS EMR Block Public Access Configuration
#---------------------------------------------------------------
#
# Amazon EMRのブロックパブリックアクセス設定を管理するリソースです。
# このリージョンレベルのセキュリティ設定は、未指定のポートでパブリックアクセスを
# 許可するセキュリティグループが関連付けられたEMRクラスターの起動を制限します。
#
# Block Public Access (BPA) は、パブリックサブネット内でセキュリティ設定が
# パブリックIPアドレスからのインバウンドトラフィックを許可する場合、
# クラスターの起動を防止します。
#
# AWS公式ドキュメント:
#   - EMR Block Public Access: https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-block-public-access.html
#   - BlockPublicAccessConfiguration API: https://docs.aws.amazon.com/emr/latest/APIReference/API_BlockPublicAccessConfiguration.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/emr_block_public_access_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-01-23
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_emr_block_public_access_configuration" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # block_public_security_group_rules (Required)
  # 設定内容: EMRブロックパブリックアクセスを有効または無効にします。
  # 設定可能な値:
  #   - true: ブロックパブリックアクセスを有効化
  #           セキュリティグループにパブリックアクセスルールがあるクラスターの起動を防止
  #   - false: ブロックパブリックアクセスを無効化（非推奨）
  #           任意のポートでパブリックアクセスを許可するセキュリティグループを持つ
  #           クラスターの作成を許可
  # 注意: アカウント保護を強化するため、trueに設定することを推奨
  # 関連機能: 有効にした場合、クラスターに関連付けられたセキュリティグループに
  #          パブリックIPアドレス(0.0.0.0/0または::/0)からのインバウンドルールがあり、
  #          そのポートがアカウントの例外として指定されていない場合、
  #          EMRはクラスターの作成を許可しません。
  block_public_security_group_rules = true

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 注意: BPA設定はリージョンごとに適用されます。
  #       各リージョンで個別に設定する必要があります。
  region = null

  #-------------------------------------------------------------
  # 許可されるパブリックセキュリティグループルール範囲
  #-------------------------------------------------------------

  # permitted_public_security_group_rule_range (Optional)
  # 設定内容: 許可されるパブリックセキュリティグループルールのポート範囲を定義する
  #          設定ブロックです。
  # 注意:
  #   - block_public_security_group_rulesがtrueの場合のみ有効です。
  #   - 複数のブロックを指定できます。
  #   - 指定されたポート範囲は、パブリックアクセスルールの例外として扱われます。
  #   - デフォルトでは、ポート22（SSH）が例外として設定されています。
  # 関連機能: PermittedPublicSecurityGroupRuleRanges
  #          ブロックパブリックアクセスが有効な場合でも、特定のポートへの
  #          パブリックアクセスを許可する例外を設定できます。

  # SSH接続用のデフォルト例外（ポート22）
  permitted_public_security_group_rule_range {
    # min_range (Required)
    # 設定内容: TCPポート範囲の最初のポートを指定します。
    # 設定可能な値: 0-65535の整数
    min_range = 22

    # max_range (Required)
    # 設定内容: TCPポート範囲の最後のポートを指定します。
    # 設定可能な値: 0-65535の整数
    # 注意: min_range以上の値を指定する必要があります。
    #       単一ポートを指定する場合はmin_rangeと同じ値を設定します。
    max_range = 22
  }

  # 追加のポート範囲の例（必要に応じてコメントを解除）
  # permitted_public_security_group_rule_range {
  #   min_range = 100
  #   max_range = 101
  # }
}

#---------------------------------------------------------------
#
# 1. ブロックパブリックアクセスを有効化（SSHのみ許可）- 推奨設定
#    resource "aws_emr_block_public_access_configuration" "default" {
#      block_public_security_group_rules = true
#
#      permitted_public_security_group_rule_range {
#        min_range = 22
#        max_range = 22
#      }
#    }
#
# 2. 複数のポート範囲を例外として許可
#    resource "aws_emr_block_public_access_configuration" "multiple_ranges" {
#      block_public_security_group_rules = true
#
#      permitted_public_security_group_rule_range {
#        min_range = 22
#        max_range = 22
#      }
#
#      permitted_public_security_group_rule_range {
#        min_range = 100
#        max_range = 101
#      }
#    }
#
# 3. ブロックパブリックアクセスを無効化（非推奨）
#    resource "aws_emr_block_public_access_configuration" "disabled" {
#      block_public_security_group_rules = false
#    }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 設定が管理されているAWSリージョン
#
#---------------------------------------------------------------
