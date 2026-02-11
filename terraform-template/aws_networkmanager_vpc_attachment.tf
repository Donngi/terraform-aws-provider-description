#---------------------------------------------------------------
# AWS Network Manager VPC Attachment
#---------------------------------------------------------------
#
# VPCをAWS Cloud WANのコアネットワークに接続するためのアタッチメントを作成します。
# Cloud WANは、グローバルネットワークを一元管理し、VPC、オンプレミス環境、
# SD-WANなどを接続するためのサービスです。VPCアタッチメントにより、
# VPC内のリソースがコアネットワークを通じて他のVPCやオンプレミス環境と
# 通信できるようになります。
#
# AWS公式ドキュメント:
#   - VPCアタッチメントの作成: https://docs.aws.amazon.com/network-manager/latest/cloudwan/cloudwan-vpc-attachment-add.html
#   - Cloud WANの概要: https://docs.aws.amazon.com/whitepapers/latest/building-scalable-secure-multi-vpc-network-infrastructure/aws-cloud-wan.html
#   - アタッチメントの概要: https://docs.aws.amazon.com/network-manager/latest/cloudwan/cloudwan-create-attachment.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkmanager_vpc_attachment
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_networkmanager_vpc_attachment" "example" {
  #---------------------------------------------------------------
  # 必須属性
  #---------------------------------------------------------------

  # コアネットワークID
  # 型: string (必須)
  #
  # VPCをアタッチするCloud WANコアネットワークのID。
  # コアネットワークは、グローバルネットワーク内に作成された
  # マネージドネットワークインフラストラクチャです。
  # aws_networkmanager_core_networkまたはawscc_networkmanager_core_networkの
  # リソースから取得できます。
  core_network_id = "core-network-xxxxxxxxx"

  # VPC ARN
  # 型: string (必須)
  #
  # アタッチするVPCのAmazon Resource Name (ARN)。
  # VPCはコアネットワークのエッジロケーションと同じリージョンに
  # 存在する必要があります。
  vpc_arn = "arn:aws:ec2:ap-northeast-1:123456789012:vpc/vpc-xxxxxxxxx"

  # サブネットARN
  # 型: set(string) (必須)
  #
  # VPCアタッチメントで使用するサブネットのARNセット。
  # 各サブネットは異なるアベイラビリティゾーンに配置することを推奨します。
  # これにより、高可用性が確保されます。
  # Cloud WANは指定されたサブネットにENI (Elastic Network Interface) を作成し、
  # VPCとコアネットワーク間のトラフィックを転送します。
  subnet_arns = [
    "arn:aws:ec2:ap-northeast-1:123456789012:subnet/subnet-xxxxxxxxx",
    "arn:aws:ec2:ap-northeast-1:123456789012:subnet/subnet-yyyyyyyyy",
  ]

  #---------------------------------------------------------------
  # オプション属性
  #---------------------------------------------------------------

  # ルーティングポリシーラベル
  # 型: string (オプション)
  #
  # トラフィックルーティングの決定に使用するルーティングポリシーラベル。
  # コアネットワークポリシーで定義されたルーティングルールと組み合わせて、
  # トラフィックの転送先を制御できます。
  # 最大256文字まで指定可能です。
  # routing_policy_label = "production-workload"

  # タグ
  # 型: map(string) (オプション)
  #
  # リソースに付与するタグのキーバリューマップ。
  # providerレベルでdefault_tagsが設定されている場合、
  # 同じキーのタグはこちらの値で上書きされます。
  # タグはコアネットワークポリシーでのセグメント割り当てにも使用できます。
  tags = {
    Name        = "example-vpc-attachment"
    Environment = "production"
  }

  #---------------------------------------------------------------
  # optionsブロック
  #---------------------------------------------------------------
  # VPCアタッチメントの追加オプションを設定します。
  # 最大1つのoptionsブロックを指定できます。
  # アタッチメントが承認待ち状態の場合、これらの値を変更すると
  # リソースが再作成されます。

  options {
    # アプライアンスモードサポート
    # 型: bool (オプション, computed)
    #
    # アプライアンスモードを有効にするかどうか。
    # 有効にすると、送信元と宛先間のトラフィックフローは、
    # そのフローの存続期間中、同じアベイラビリティゾーンを使用します。
    # これは、ステートフルなネットワークアプライアンス（ファイアウォールなど）を
    # 使用する場合に重要です。
    # デフォルト: false
    # appliance_mode_support = false

    # DNSサポート
    # 型: bool (オプション, computed)
    #
    # DNSサポートを有効にするかどうか。
    # 有効にすると、VPC内のリソースは他のアタッチされたVPCの
    # プライベートDNS名を解決できます。
    # デフォルト: true
    # dns_support = true

    # IPv6サポート
    # 型: bool (オプション, computed)
    #
    # IPv6サポートを有効にするかどうか。
    # 有効にすると、VPCアタッチメントはIPv6トラフィックをサポートします。
    # VPC自体がIPv6 CIDRブロックを持っている必要があります。
    # デフォルト: false
    # ipv6_support = false

    # セキュリティグループ参照サポート
    # 型: bool (オプション, computed)
    #
    # セキュリティグループ参照サポートを有効にするかどうか。
    # 有効にすると、セキュリティグループルールで他のVPCの
    # セキュリティグループを参照できます。
    # リソースレベルのデフォルト: true
    # コアネットワークポリシーレベルのデフォルト: false
    # security_group_referencing_support = true
  }

  #---------------------------------------------------------------
  # timeoutsブロック
  #---------------------------------------------------------------
  # リソース操作のタイムアウト時間をカスタマイズします。
  # VPCアタッチメントの作成・更新・削除には時間がかかる場合があります。

  # timeouts {
  #   # 作成タイムアウト
  #   # 型: string (オプション)
  #   #
  #   # リソース作成のタイムアウト時間。
  #   # 例: "30m", "1h"
  #   create = "30m"
  #
  #   # 更新タイムアウト
  #   # 型: string (オプション)
  #   #
  #   # リソース更新のタイムアウト時間。
  #   # 例: "30m", "1h"
  #   update = "30m"
  #
  #   # 削除タイムアウト
  #   # 型: string (オプション)
  #   #
  #   # リソース削除のタイムアウト時間。
  #   # 例: "30m", "1h"
  #   delete = "30m"
  # }

  #---------------------------------------------------------------
  # tags_all (オプション, computed)
  #---------------------------------------------------------------
  # 型: map(string)
  #
  # providerのdefault_tagsとこのリソースのtagsを統合した
  # 全タグのマップ。通常は直接設定せず、tags属性を使用します。
  # この属性は主にcomputed値として参照用途で使用されます。
}

#---------------------------------------------------------------
# Attributes Reference (参照専用属性)
#---------------------------------------------------------------
# 以下の属性はTerraformによって自動的に設定され、
# 他のリソースから参照できます。
#
# arn                          - アタッチメントのARN
# attachment_policy_rule_number - アタッチメントに関連付けられたポリシールール番号
# attachment_type               - アタッチメントのタイプ（この場合は"vpc"）
# core_network_arn             - コアネットワークのARN
# edge_location                - エッジが配置されているリージョン
# id                           - アタッチメントのID
# owner_account_id             - アタッチメント所有者のアカウントID
# resource_arn                 - アタッチメントリソースのARN
# segment_name                 - セグメントアタッチメントの名前
# state                        - アタッチメントの状態
#                                (Creating, Available, Pending attachment acceptance,
#                                 Pending network update, Deleting, Failed, Rejected等)
# tags_all                     - default_tagsを含む全タグのマップ
