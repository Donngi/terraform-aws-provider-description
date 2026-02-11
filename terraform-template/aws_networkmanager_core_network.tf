#---------------------------------------------------------------
# AWS Network Manager Core Network (aws_networkmanager_core_network)
#---------------------------------------------------------------
#
# AWS Cloud WANのコアネットワークを作成・管理するリソース。
# コアネットワークは、グローバルネットワーク内でVPC、VPN、
# Transit Gatewayなどのアタッチメントを接続し、
# ネットワークセグメントとルーティングポリシーを定義する
# 中央管理されたネットワークインフラストラクチャ。
#
# AWS公式ドキュメント:
#   - What is AWS Cloud WAN?: https://docs.aws.amazon.com/network-manager/latest/cloudwan/what-is-cloudwan.html
#   - Core network policy: https://docs.aws.amazon.com/network-manager/latest/cloudwan/cloudwan-policy-examples.html
#   - Dashboards: https://docs.aws.amazon.com/network-manager/latest/cloudwan/cloudwan-visualize-networks.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkmanager_core_network
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_networkmanager_core_network" "this" {
  #---------------------------------------------------------------
  # 必須引数 (Required Arguments)
  #---------------------------------------------------------------

  # global_network_id (必須, string)
  # コアネットワークが属するグローバルネットワークのID。
  # グローバルネットワークは、Cloud WANのすべてのネットワークリソースを
  # 論理的にグループ化するコンテナとして機能する。
  # aws_networkmanager_global_networkリソースで作成したIDを指定。
  global_network_id = aws_networkmanager_global_network.example.id

  #---------------------------------------------------------------
  # オプション引数 (Optional Arguments)
  #---------------------------------------------------------------

  # description (オプション, string)
  # コアネットワークの説明文。
  # ネットワークの目的や用途を記述し、管理・識別を容易にする。
  description = "Example Core Network for Cloud WAN"

  # create_base_policy (オプション, bool)
  # コアネットワーク作成時にベースポリシーを自動作成するかどうか。
  #
  # true に設定すると、基本的なベースポリシーが作成され LIVE 状態に設定される。
  # これにより、aws_networkmanager_core_network_policy_attachment で
  # 詳細なポリシーを適用する前に、VPCアタッチメントなどを接続可能になる。
  #
  # ポリシードキュメントにVPCアタッチメントへの静的ルートが含まれ、
  # ポリシー適用前にVPCを接続したい場合に使用する。
  #
  # ベースポリシーは後から aws_networkmanager_core_network_policy_attachment で
  # 指定したポリシーで上書きされる。
  create_base_policy = true

  # base_policy_document (オプション, string, create_base_policyがtrueの場合に使用)
  # カスタムベースポリシーのJSONドキュメント。
  # base_policy_regions と競合するため、どちらか一方のみ指定可能。
  #
  # data "aws_networkmanager_core_network_policy_document" を使用して
  # HCLでポリシーを定義し、.json 属性でJSON形式に変換して渡すのが推奨。
  #
  # ベースポリシーには最低限以下が必要:
  # - ASN範囲の定義
  # - 少なくとも1つのエッジロケーション
  # - 少なくとも1つのセグメント
  base_policy_document = data.aws_networkmanager_core_network_policy_document.base.json

  # base_policy_regions (オプション, set(string), create_base_policyがtrueの場合に使用)
  # ベースポリシーに追加するリージョンのリスト。
  # base_policy_document と競合するため、どちらか一方のみ指定可能。
  #
  # create_base_policy を true に設定した際、ベースポリシーの edge-locations に
  # location として設定されるリージョンを指定する。
  # 指定しない場合、プロバイダーブロックで設定されたリージョンがデフォルトで使用される。
  #
  # マルチリージョン構成の場合、すべての対象リージョンをここで指定する。
  # base_policy_regions = ["us-west-2", "us-east-1", "ap-northeast-1"]

  # tags (オプション, map(string))
  # コアネットワークに付与するタグのキー・値ペア。
  # プロバイダーレベルの default_tags が設定されている場合、
  # 同じキーのタグはこちらで指定した値で上書きされる。
  #
  # タグはコスト配分、リソース管理、アクセス制御などに使用できる。
  tags = {
    Name        = "example-core-network"
    Environment = "production"
    Project     = "cloud-wan"
  }

  #---------------------------------------------------------------
  # timeouts ブロック (オプション)
  #---------------------------------------------------------------
  # コアネットワークの作成・更新・削除操作のタイムアウト時間を指定。
  # コアネットワークの作成には複数のAWSリージョンへの展開が含まれるため、
  # デフォルトより長い時間が必要になる場合がある。

  timeouts {
    # create (オプション, string)
    # コアネットワーク作成のタイムアウト時間。
    # 形式: "30m"（30分）, "1h"（1時間）など。
    # マルチリージョン構成や大規模なポリシーの場合は長めに設定。
    create = "30m"

    # update (オプション, string)
    # コアネットワーク更新のタイムアウト時間。
    # ポリシー変更やリージョン追加などの更新操作に適用。
    update = "30m"

    # delete (オプション, string)
    # コアネットワーク削除のタイムアウト時間。
    # すべてのアタッチメントを先に削除してから、コアネットワークを削除する必要がある。
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (参照専用属性)
#---------------------------------------------------------------
# 以下の属性はTerraformによって自動的に設定され、他のリソースから参照可能。
# これらは resource ブロック内では設定できない。
#
# arn (string)
#   コアネットワークのARN。
#   形式: arn:aws:networkmanager::<account-id>:core-network/<core-network-id>
#   例: aws_networkmanager_core_network.this.arn
#
# id (string)
#   コアネットワークの一意識別子（Core Network ID）。
#   形式: core-network-xxxxxxxxxxxxxxxxx
#   例: aws_networkmanager_core_network.this.id
#
# created_at (string)
#   コアネットワークが作成された日時（ISO 8601形式）。
#   例: aws_networkmanager_core_network.this.created_at
#
# state (string)
#   コアネットワークの現在の状態。
#   値: CREATING, AVAILABLE, UPDATING, DELETING
#   例: aws_networkmanager_core_network.this.state
#
# edges (list(object))
#   コアネットワーク内のエッジ（各リージョンのCore Network Edge）の詳細リスト。
#   各エッジオブジェクトには以下の属性が含まれる:
#   - asn (number): エッジのASN（Autonomous System Number）
#   - edge_location (string): エッジが配置されているAWSリージョン
#   - inside_cidr_blocks (list(string)): エッジ内部で使用されるCIDRブロック
#   例: aws_networkmanager_core_network.this.edges[0].edge_location
#
# segments (list(object))
#   コアネットワーク内のセグメントの詳細リスト。
#   各セグメントオブジェクトには以下の属性が含まれる:
#   - name (string): セグメント名
#   - edge_locations (list(string)): セグメントが有効なエッジロケーション
#   - shared_segments (list(string)): 共有されているセグメント
#   例: aws_networkmanager_core_network.this.segments[0].name
#
# tags_all (map(string))
#   リソースに割り当てられたすべてのタグ。
#   プロバイダーレベルの default_tags で定義されたタグを含む。
#   例: aws_networkmanager_core_network.this.tags_all
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: ベースポリシードキュメントの定義
#---------------------------------------------------------------
# data "aws_networkmanager_core_network_policy_document" "base" {
#   core_network_configuration {
#     asn_ranges = ["65022-65534"]
#
#     edge_locations {
#       location = "us-west-2"
#       asn      = "65500"
#     }
#
#     edge_locations {
#       location = "ap-northeast-1"
#       asn      = "65501"
#     }
#   }
#
#   segments {
#     name = "shared"
#   }
#
#   segments {
#     name = "production"
#   }
# }

#---------------------------------------------------------------
# 使用例: VPCアタッチメントとの組み合わせ
#---------------------------------------------------------------
# resource "aws_networkmanager_vpc_attachment" "example" {
#   core_network_id = aws_networkmanager_core_network.this.id
#   subnet_arns     = aws_subnet.example[*].arn
#   vpc_arn         = aws_vpc.example.arn
#
#   tags = {
#     segment = "production"
#   }
# }

#---------------------------------------------------------------
# 使用例: 詳細ポリシーの適用
#---------------------------------------------------------------
# resource "aws_networkmanager_core_network_policy_attachment" "example" {
#   core_network_id = aws_networkmanager_core_network.this.id
#   policy_document = data.aws_networkmanager_core_network_policy_document.full.json
# }
