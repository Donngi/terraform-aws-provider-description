#---------------------------------------------------------------
# VPC Block Public Access Options
#---------------------------------------------------------------
#
# VPCのBlock Public Access（BPA）オプションを管理するリソースです。
# アカウントおよびリージョンレベルでインターネットゲートウェイを経由する
# インバウンド/アウトバウンドトラフィックをブロックするモードを設定します。
# このリソースはアカウントごとに1つのみ存在し、デフォルト値は "off" です。
#
# AWS公式ドキュメント:
#   - ModifyVpcBlockPublicAccessOptions: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_ModifyVpcBlockPublicAccessOptions.html
#   - VpcBlockPublicAccessOptions: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_VpcBlockPublicAccessOptions.html
#   - Block Public Access for VPC発表記事: https://aws.amazon.com/about-aws/whats-new/2024/11/block-public-access-amazon-virtual-private-cloud/
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_block_public_access_options
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpc_block_public_access_options" "example" {
  #-------------------------------------------------------------
  # BPAモード設定
  #-------------------------------------------------------------

  # internet_gateway_block_mode (Required)
  # 設定内容: インターネットゲートウェイを経由するトラフィックのブロックモードを指定します。
  # 設定可能な値:
  #   - "off": BPAを無効化し、インターネットアクセスを許可（デフォルト）
  #   - "block-bidirectional": 双方向（インバウンド/アウトバウンド）トラフィックをブロック
  #   - "block-ingress": インバウンドトラフィックのみをブロック（エグレスは許可）
  # 注意: このモードはアカウント全体に適用されます。
  #       除外設定（aws_vpc_block_public_access_exclusion）を使用することで
  #       特定のVPCまたはサブネットを対象外にすることができます。
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_ModifyVpcBlockPublicAccessOptions.html
  internet_gateway_block_mode = "block-bidirectional"

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
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 数値と単位サフィックスからなる文字列（例: "30s", "2h45m"）
    #             有効な時間単位は "s"（秒）、"m"（分）、"h"（時間）
    # 参考: https://pkg.go.dev/time#ParseDuration
    create = null

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: 数値と単位サフィックスからなる文字列（例: "30s", "2h45m"）
    #             有効な時間単位は "s"（秒）、"m"（分）、"h"（時間）
    # 参考: https://pkg.go.dev/time#ParseDuration
    update = null

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: 数値と単位サフィックスからなる文字列（例: "30s", "2h45m"）
    #             有効な時間単位は "s"（秒）、"m"（分）、"h"（時間）
    # 注意: 削除操作のタイムアウト設定は、destroy操作の前に状態が保存される場合にのみ適用されます。
    # 参考: https://pkg.go.dev/time#ParseDuration
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: VPC Block Public Access OptionsのID（アカウントIDとリージョンの組み合わせ）
#
# - aws_account_id: BPAオプションが設定されているAWSアカウントID
#
# - aws_region: BPAオプションが設定されているAWSリージョン
#---------------------------------------------------------------
