#---------------------------------------------------------------
# AWS Network Manager Core Network
#---------------------------------------------------------------
#
# AWS Cloud WANのグローバルネットワーク内にコアネットワークを
# プロビジョニングするリソースです。コアネットワークは、グローバルネットワークの
# 中央管理ポイントとして機能し、VPCアタッチメント、VPNアタッチメントなど
# 各種アタッチメントを接続するための基盤となります。
# 1つのグローバルネットワークに対してコアネットワークは1つのみ作成可能です。
#
# AWS公式ドキュメント:
#   - コアネットワークの作成: https://docs.aws.amazon.com/network-manager/latest/cloudwan/cloudwan-core-network-policy.html
#   - コアネットワークの概要: https://docs.aws.amazon.com/network-manager/latest/cloudwan/cloudwan-networks-working-with.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkmanager_core_network
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_networkmanager_core_network" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # global_network_id (Required)
  # 設定内容: コアネットワークが属するグローバルネットワークのIDを指定します。
  # 設定可能な値: 有効なグローバルネットワークID
  global_network_id = "global-network-0123456789abcdef0"

  # description (Optional)
  # 設定内容: コアネットワークの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なしで作成されます。
  description = "example core network"

  #-------------------------------------------------------------
  # ベースポリシー設定
  #-------------------------------------------------------------

  # base_policy_document (Optional)
  # 設定内容: コアネットワークのベースポリシードキュメントをJSON形式で指定します。
  #   create_base_policy と組み合わせて使用します。
  #   VPCアタッチメント等を接続する前に、LIVEポリシーが必要な場合に使用します。
  #   このベースポリシーは aws_networkmanager_core_network_policy_attachment
  #   リソースで指定したポリシーによって上書きされます。
  # 設定可能な値: 有効なコアネットワークポリシーJSON文字列
  # 省略時: create_base_policy=trueの場合、デフォルトのベースポリシーが作成されます。
  # 注意: base_policy_regions と排他的（どちらか一方のみ指定可能）
  # 参考: https://docs.aws.amazon.com/network-manager/latest/cloudwan/cloudwan-policy-change-sets.html
  base_policy_document = null

  # base_policy_regions (Optional)
  # 設定内容: ベースポリシーに追加するリージョンのリストを指定します。
  #   create_base_policy=trueで作成されるベースポリシーの edge-locations に
  #   設定するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコードのセット（例: ["us-east-1", "us-west-2"]）
  # 省略時: providerブロックで指定されたリージョンがデフォルトで使用されます。
  # 注意: base_policy_document と排他的（どちらか一方のみ指定可能）
  base_policy_regions = null

  # create_base_policy (Optional)
  # 設定内容: コアネットワーク作成・更新時にベースポリシーを作成するかを指定します。
  #   LIVEポリシーが存在しない状態でVPCアタッチメント等を接続する場合に
  #   事前にベースポリシーが必要となります。この設定を true にすることで
  #   ベースポリシーが自動的に作成・LIVE状態に設定されます。
  # 設定可能な値:
  #   - true: ベースポリシーを作成する
  #   - false (デフォルト): ベースポリシーを作成しない
  create_base_policy = false

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなしで作成されます。
  # 参考: プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-core-network"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が使用されます。
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が使用されます。
    update = "30m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が使用されます。
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: コアネットワークのARN
# - created_at: コアネットワークが作成されたタイムスタンプ
# - edges: コアネットワークのエッジ情報のリスト（asn, edge_location, inside_cidr_blocks）
# - id: コアネットワークID
# - segments: コアネットワークのセグメント情報のリスト（edge_locations, name, shared_segments）
# - state: コアネットワークの現在の状態
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む全タグのマップ
#---------------------------------------------------------------
