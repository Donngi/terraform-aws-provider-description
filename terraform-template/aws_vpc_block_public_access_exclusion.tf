#---------------------------------------------------------------
# VPC Block Public Access Exclusion
#---------------------------------------------------------------
#
# VPCまたはサブネットに対するBlock Public Access（BPA）の除外設定を管理するリソースです。
# アカウントレベルのBPAモードから特定のVPCまたはサブネットを除外し、
# 双方向またはエグレスのみのインターネットアクセスを許可します。
# BPAが有効でない場合でもトラフィックの中断を防ぐために除外設定を作成できます。
#
# AWS公式ドキュメント:
#   - CreateVpcBlockPublicAccessExclusion: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_CreateVpcBlockPublicAccessExclusion.html
#   - VpcBlockPublicAccessExclusion: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_VpcBlockPublicAccessExclusion.html
#   - Block Public Access for VPC発表記事: https://aws.amazon.com/about-aws/whats-new/2024/11/block-public-access-amazon-virtual-private-cloud/
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_block_public_access_exclusion
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpc_block_public_access_exclusion" "example" {
  #-------------------------------------------------------------
  # 除外モード設定
  #-------------------------------------------------------------

  # internet_gateway_exclusion_mode (Required)
  # 設定内容: インターネットゲートウェイトラフィックの除外モードを指定します。
  # 設定可能な値:
  #   - allow-bidirectional: 双方向（インバウンド/アウトバウンド）アクセスを許可
  #   - allow-egress: エグレス（アウトバウンド）のみのアクセスを許可
  # 関連機能: VPC Block Public Access
  #   ネットワークおよびセキュリティ管理者がVPCへのインターネットトラフィックを
  #   集中的に制御およびブロックできる機能。この除外設定により、特定のリソースに
  #   対してアカウントレベルのBPAモードを適用しないことができます。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_CreateVpcBlockPublicAccessExclusion.html
  internet_gateway_exclusion_mode = "allow-bidirectional"

  #-------------------------------------------------------------
  # リソース識別設定
  #-------------------------------------------------------------

  # vpc_id (Optional)
  # 設定内容: 除外設定を適用するVPCのIDを指定します。
  # 設定可能な値: 有効なVPC ID（例: vpc-12345678）
  # 注意: vpc_idまたはsubnet_idのいずれか一方を指定する必要があります。
  #       vpc_idを指定した場合、そのVPC全体に対してBPA除外が適用されます。
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_CreateVpcBlockPublicAccessExclusion.html
  vpc_id = null

  # subnet_id (Optional)
  # 設定内容: 除外設定を適用するサブネットのIDを指定します。
  # 設定可能な値: 有効なサブネットID（例: subnet-12345678）
  # 注意: vpc_idまたはsubnet_idのいずれか一方を指定する必要があります。
  #       subnet_idを指定した場合、そのサブネットに対してBPA除外が適用されます。
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_CreateVpcBlockPublicAccessExclusion.html
  subnet_id = null

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
  # 設定内容: 除外設定に割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-bpa-exclusion"
    Environment = "production"
  }

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
# - id: VPC Block Public Access ExclusionのID
#
# - resource_arn: 除外されたリソースのAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
