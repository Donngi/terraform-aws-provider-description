#---------------------------------------------------------------
# AWS Network Firewall VPC Endpoint Association
#---------------------------------------------------------------
#
# AWS Network FirewallのVPCエンドポイントアソシエーションを管理する。
#
# VPCエンドポイントアソシエーションは、ファイアウォールが既に使用されている
# アベイラビリティゾーンに新しいファイアウォールエンドポイントを作成するために使用する。
# これにより、単一のファイアウォールで複数のVPCを保護したり、
# 同一アベイラビリティゾーン内の同一VPCに複数のファイアウォールエンドポイントを
# 定義したりすることが可能になる。
#
# 注意: アベイラビリティゾーンでのファイアウォールの最初の使用は、
# aws_networkfirewall_firewall リソースの subnet_mapping 引数で定義する必要がある。
# VPCエンドポイントアソシエーションは、プライマリエンドポイントが既に存在する
# アベイラビリティゾーンでのみ作成可能。
#
# AWS公式ドキュメント:
#   - Creating a VPC endpoint association in AWS Network Firewall:
#     https://docs.aws.amazon.com/network-firewall/latest/developerguide/creating-vpc-endpoint-association.html
#   - What is AWS Network Firewall?:
#     https://docs.aws.amazon.com/network-firewall/latest/developerguide/what-is-aws-network-firewall.html
#   - VpcEndpointAssociation API Reference:
#     https://docs.aws.amazon.com/network-firewall/latest/APIReference/API_VpcEndpointAssociation.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/networkfirewall_vpc_endpoint_association
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_networkfirewall_vpc_endpoint_association" "this" {
  #---------------------------------------------------------------
  # Required Arguments
  #---------------------------------------------------------------

  # firewall_arn - (Required) ファイアウォールのARN
  # アソシエーションを作成する対象のNetwork FirewallのARN。
  # AWS Resource Access Manager (RAM) を使用して共有されたファイアウォールも指定可能。
  # 共有されたファイアウォールを使用する場合、ファイアウォール所有者アカウントまたは
  # 共有先アカウントでVPCエンドポイントアソシエーションを作成できる。
  firewall_arn = null # 例: aws_networkfirewall_firewall.example.arn

  # vpc_id - (Required) VPC ID
  # ファイアウォールエンドポイントを作成するVPCの一意の識別子。
  # ファイアウォールのプライマリVPCと同じでも、異なるVPCでも構わない。
  vpc_id = null # 例: aws_vpc.example.id

  #---------------------------------------------------------------
  # subnet_mapping Block (Required)
  #---------------------------------------------------------------
  # ファイアウォールエンドポイントを作成するサブネットの設定。
  # 少なくとも1つのsubnet_mappingブロックが必要。
  # 各サブネットは、ファイアウォールのプライマリエンドポイントが存在する
  # アベイラビリティゾーンに属している必要がある。

  subnet_mapping {
    # subnet_id - (Required) サブネットID
    # ファイアウォールエンドポイントを作成するサブネットの一意の識別子。
    # このサブネットは他のファイアウォールで使用されていてはならない。
    # また、ファイアウォールのプライマリエンドポイントが存在する
    # アベイラビリティゾーンに属している必要がある。
    subnet_id = null # 例: aws_subnet.example.id

    # ip_address_type - (Optional) IPアドレスタイプ
    # サブネットのIPアドレスタイプを指定する。
    # 有効な値:
    #   - "IPV4": IPv4のみ
    #   - "DUALSTACK": IPv4とIPv6の両方
    # デフォルトはサブネットの設定に基づいて自動的に決定される。
    # ip_address_type = "IPV4"
  }

  # 追加のサブネットマッピング例（複数のアベイラビリティゾーンに展開する場合）
  # subnet_mapping {
  #   subnet_id       = aws_subnet.example_2.id
  #   ip_address_type = "IPV4"
  # }

  #---------------------------------------------------------------
  # Optional Arguments
  #---------------------------------------------------------------

  # description - (Optional) 説明
  # VPCエンドポイントアソシエーションの説明テキスト。
  # 最大512文字。管理目的でアソシエーションを識別するために使用する。
  # description = "Example VPC endpoint association for secondary VPC"

  # region - (Optional) リージョン
  # このリソースが管理されるAWSリージョン。
  # 指定しない場合、プロバイダー設定で指定されたリージョンがデフォルトで使用される。
  # クロスリージョンでの管理が必要な場合にのみ指定する。
  # region = "us-east-1"

  # tags - (Optional) タグ
  # リソースに関連付けるタグのマップ。
  # プロバイダーレベルの default_tags 設定ブロックが存在する場合、
  # 同じキーを持つタグはプロバイダーレベルで定義されたものを上書きする。
  # tags = {
  #   Name        = "example-vpc-endpoint-association"
  #   Environment = "production"
  # }

  #---------------------------------------------------------------
  # timeouts Block (Optional)
  #---------------------------------------------------------------
  # リソースの作成・削除操作のタイムアウト設定。
  # VPCエンドポイントの作成には時間がかかる場合があるため、
  # 必要に応じてタイムアウト値を調整する。

  # timeouts {
  #   # create - (Optional) 作成タイムアウト
  #   # リソース作成時のタイムアウト時間。
  #   # 形式: "30s"（秒）、"10m"（分）、"1h"（時間）など。
  #   # VPCエンドポイントの作成が完了するまで待機する最大時間を指定する。
  #   # デフォルトは内部的に設定された値が使用される。
  #   create = "30m"
  #
  #   # delete - (Optional) 削除タイムアウト
  #   # リソース削除時のタイムアウト時間。
  #   # 形式: "30s"（秒）、"10m"（分）、"1h"（時間）など。
  #   # VPCエンドポイントの削除が完了するまで待機する最大時間を指定する。
  #   # 削除前にstateへの変更保存が行われた場合のみ適用される。
  #   delete = "30m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (Computed / Read-Only)
#---------------------------------------------------------------
# 以下の属性はTerraformによって自動的に設定され、参照可能。
# これらはリソース作成後に output や他のリソースで参照できる。
#
# tags_all
#   リソースに割り当てられたすべてのタグのマップ。
#   プロバイダーの default_tags 設定ブロックで定義されたタグを含む。
#   使用例: aws_networkfirewall_vpc_endpoint_association.this.tags_all
#
# vpc_endpoint_association_arn
#   VPCエンドポイントアソシエーションのARN。
#   他のAWSサービスやIAMポリシーでこのリソースを参照する際に使用する。
#   使用例: aws_networkfirewall_vpc_endpoint_association.this.vpc_endpoint_association_arn
#
# vpc_endpoint_association_id
#   VPCエンドポイントアソシエーションの一意の識別子。
#   使用例: aws_networkfirewall_vpc_endpoint_association.this.vpc_endpoint_association_id
#
# vpc_endpoint_association_status
#   VPCエンドポイントアソシエーションの現在のステータス情報（ネストされたリスト）。
#   以下の構造を持つ:
#     - association_sync_state: VPCエンドポイントアソシエーション用に設定されたサブネットのセット
#       - attachment: ファイアウォールのVPCエンドポイントアソシエーションと
#                     単一VPCサブネットとのアタッチメントステータスを示すネストされたリスト
#         - endpoint_id: サブネットにインスタンス化されたVPCエンドポイントの識別子。
#                        VPCルートテーブルでファイアウォールエンドポイントを識別し、
#                        VPCトラフィックをエンドポイント経由でリダイレクトする際に使用する。
#         - subnet_id: VPCエンドポイントアソシエーションのエンドポイントとして
#                      指定されたサブネットの一意の識別子。
#         - status: アタッチメントのステータス。
#         - status_message: ステータスに関する詳細メッセージ。
#       - availability_zone: サブネットが設定されているアベイラビリティゾーン。
#   使用例:
#     aws_networkfirewall_vpc_endpoint_association.this.vpc_endpoint_association_status[0].association_sync_state
#---------------------------------------------------------------
