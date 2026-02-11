#---------------------------------------------------------------
# AWS Security Group
#---------------------------------------------------------------
#
# VPC のセキュリティグループをプロビジョニングするリソースです。
# セキュリティグループは、EC2 インスタンスや RDS、ELB などのリソースへの
# インバウンドおよびアウトバウンドトラフィックを制御する仮想ファイアウォールです。
#
# 重要な推奨事項:
#   - ingress および egress 引数の使用は推奨されません
#   - 代わりに aws_vpc_security_group_ingress_rule および
#     aws_vpc_security_group_egress_rule リソースの使用を推奨
#   - インラインルールは複数の CIDR ブロック管理やタグ、説明の扱いに問題があります
#
# 警告:
#   - インラインルール (ingress/egress) と aws_vpc_security_group_*_rule や
#     aws_security_group_rule リソースを併用しないでください
#   - 併用するとルールの競合、永続的な差分、ルールの上書きが発生する可能性があります
#
# AWS公式ドキュメント:
#   - Security Groups 概要: https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-groups.html
#   - VPC Peering とセキュリティグループ: https://docs.aws.amazon.com/vpc/latest/peering/vpc-peering-security-groups.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_security_group" "example" {
  #-------------------------------------------------------------
  # 名前設定
  #-------------------------------------------------------------

  # name (Optional, Computed, Forces new resource)
  # 設定内容: セキュリティグループの名前を指定します。
  # 設定可能な値: 文字列（255文字まで）
  # 省略時: Terraform がランダムでユニークな名前を割り当てます。
  # 注意:
  #   - name_prefix と排他的（どちらか一方のみ指定可能）
  #   - 変更するとリソースが再作成されます
  name = "example-security-group"

  # name_prefix (Optional, Computed, Forces new resource)
  # 設定内容: セキュリティグループ名のプレフィックスを指定します。
  # 設定可能な値: 文字列。Terraform が後ろにランダムなサフィックスを追加します。
  # 注意:
  #   - name と排他的（どちらか一方のみ指定可能）
  #   - 変更するとリソースが再作成されます
  name_prefix = null

  #-------------------------------------------------------------
  # 説明設定
  #-------------------------------------------------------------

  # description (Optional, Forces new resource)
  # 設定内容: セキュリティグループの説明を指定します。
  # 設定可能な値: 文字列（空文字列 "" は不可）
  # 省略時: "Managed by Terraform" が設定されます。
  # 注意:
  #   - AWS の GroupDescription 属性にマッピングされ、更新 API がありません
  #   - 変更可能な分類にはタグの使用を推奨します
  #   - 変更するとリソースが再作成されます
  description = "Security group for example application"

  #-------------------------------------------------------------
  # VPC 設定
  #-------------------------------------------------------------

  # vpc_id (Optional, Computed, Forces new resource)
  # 設定内容: セキュリティグループを作成する VPC の ID を指定します。
  # 設定可能な値: VPC ID（例: vpc-xxxxxxxxxxxxxxxxx）
  # 省略時: リージョンのデフォルト VPC を使用します。
  # 注意: 変更するとリソースが再作成されます
  vpc_id = "vpc-xxxxxxxxxxxxxxxxx"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # インバウンドルール設定（非推奨）
  #-------------------------------------------------------------

  # ingress (Optional, Computed)
  # 設定内容: インバウンドトラフィックのルールを指定します。
  # 警告: この引数の使用は推奨されません。代わりに aws_vpc_security_group_ingress_rule を使用してください。
  # 注意:
  #   - 複数の CIDR ブロック管理に問題があります
  #   - タグや説明の履歴的な欠如により管理が困難です
  #   - aws_vpc_security_group_ingress_rule や aws_security_group_rule と併用しないでください
  ingress = [
    # {
    #   # from_port (Required)
    #   # 設定内容: 開始ポート番号を指定します（ICMP の場合は ICMP タイプ番号）
    #   # 設定可能な値: 0-65535 の整数
    #   from_port = 443
    #
    #   # to_port (Required)
    #   # 設定内容: 終了ポート番号を指定します（ICMP の場合は ICMP コード）
    #   # 設定可能な値: 0-65535 の整数
    #   to_port = 443
    #
    #   # protocol (Required)
    #   # 設定内容: プロトコルを指定します。
    #   # 設定可能な値:
    #   #   - "tcp": TCP プロトコル
    #   #   - "udp": UDP プロトコル
    #   #   - "icmp": ICMP プロトコル
    #   #   - "icmpv6": ICMPv6 プロトコル
    #   #   - "-1": すべてのプロトコル（from_port と to_port は 0 にする必要があります）
    #   #   - プロトコル番号（例: "6" for TCP）
    #   # 参考: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_IpPermission.html
    #   # 注意: 小文字で指定してください
    #   protocol = "tcp"
    #
    #   # cidr_blocks (Optional)
    #   # 設定内容: アクセスを許可する CIDR ブロックのリストを指定します。
    #   # 設定可能な値: CIDR ブロックのリスト（例: ["10.0.0.0/16", "192.168.1.0/24"]）
    #   # 注意: cidr_blocks、ipv6_cidr_blocks、prefix_list_ids、security_groups のいずれかを指定する必要があります
    #   cidr_blocks = ["0.0.0.0/0"]
    #
    #   # ipv6_cidr_blocks (Optional)
    #   # 設定内容: アクセスを許可する IPv6 CIDR ブロックのリストを指定します。
    #   # 設定可能な値: IPv6 CIDR ブロックのリスト（例: ["::/0"]）
    #   ipv6_cidr_blocks = []
    #
    #   # prefix_list_ids (Optional)
    #   # 設定内容: アクセスを許可するプレフィックスリスト ID のリストを指定します。
    #   # 設定可能な値: プレフィックスリスト ID のリスト
    #   prefix_list_ids = []
    #
    #   # security_groups (Optional)
    #   # 設定内容: アクセスを許可するセキュリティグループのリストを指定します。
    #   # 設定可能な値:
    #   #   - セキュリティグループ ID のリスト（例: ["sg-xxxxxxxxxxxxxxxxx"]）
    #   #   - デフォルト VPC の場合はグループ名も使用可能
    #   security_groups = []
    #
    #   # self (Optional)
    #   # 設定内容: このセキュリティグループ自体からのアクセスを許可するかを指定します。
    #   # 設定可能な値:
    #   #   - true: このセキュリティグループをソースとして追加
    #   #   - false: 追加しない
    #   self = false
    #
    #   # description (Optional)
    #   # 設定内容: このインバウンドルールの説明を指定します。
    #   # 設定可能な値: 文字列
    #   description = "Allow HTTPS from anywhere"
    # }
  ]

  #-------------------------------------------------------------
  # アウトバウンドルール設定（非推奨）
  #-------------------------------------------------------------

  # egress (Optional, Computed)
  # 設定内容: アウトバウンドトラフィックのルールを指定します。
  # 警告: この引数の使用は推奨されません。代わりに aws_vpc_security_group_egress_rule を使用してください。
  # 注意:
  #   - VPC のみで使用可能
  #   - 複数の CIDR ブロック管理に問題があります
  #   - aws_vpc_security_group_egress_rule や aws_security_group_rule と併用しないでください
  #   - cidr_blocks や ipv6_cidr_blocks などを何も指定しない場合、トラフィックはブロックされます
  egress = [
    # {
    #   # from_port (Required)
    #   # 設定内容: 開始ポート番号を指定します（ICMP の場合は ICMP タイプ番号）
    #   # 設定可能な値: 0-65535 の整数
    #   from_port = 0
    #
    #   # to_port (Required)
    #   # 設定内容: 終了ポート番号を指定します（ICMP の場合は ICMP コード）
    #   # 設定可能な値: 0-65535 の整数
    #   to_port = 0
    #
    #   # protocol (Required)
    #   # 設定内容: プロトコルを指定します。
    #   # 設定可能な値:
    #   #   - "tcp": TCP プロトコル
    #   #   - "udp": UDP プロトコル
    #   #   - "icmp": ICMP プロトコル
    #   #   - "icmpv6": ICMPv6 プロトコル
    #   #   - "-1": すべてのプロトコル（from_port と to_port は 0 にする必要があります）
    #   #   - プロトコル番号（例: "6" for TCP）
    #   # 参考: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_IpPermission.html
    #   # 注意: 小文字で指定してください
    #   protocol = "-1"
    #
    #   # cidr_blocks (Optional)
    #   # 設定内容: アクセスを許可する CIDR ブロックのリストを指定します。
    #   # 設定可能な値: CIDR ブロックのリスト（例: ["0.0.0.0/0"]）
    #   # 注意: cidr_blocks、ipv6_cidr_blocks、prefix_list_ids、security_groups のいずれかを指定する必要があります
    #   cidr_blocks = ["0.0.0.0/0"]
    #
    #   # ipv6_cidr_blocks (Optional)
    #   # 設定内容: アクセスを許可する IPv6 CIDR ブロックのリストを指定します。
    #   # 設定可能な値: IPv6 CIDR ブロックのリスト（例: ["::/0"]）
    #   ipv6_cidr_blocks = []
    #
    #   # prefix_list_ids (Optional)
    #   # 設定内容: アクセスを許可するプレフィックスリスト ID のリストを指定します。
    #   # 設定可能な値: プレフィックスリスト ID のリスト
    #   prefix_list_ids = []
    #
    #   # security_groups (Optional)
    #   # 設定内容: アクセスを許可するセキュリティグループのリストを指定します。
    #   # 設定可能な値:
    #   #   - セキュリティグループ ID のリスト（例: ["sg-xxxxxxxxxxxxxxxxx"]）
    #   #   - デフォルト VPC の場合はグループ名も使用可能
    #   security_groups = []
    #
    #   # self (Optional)
    #   # 設定内容: このセキュリティグループ自体へのアクセスを許可するかを指定します。
    #   # 設定可能な値:
    #   #   - true: このセキュリティグループを宛先として追加
    #   #   - false: 追加しない
    #   self = false
    #
    #   # description (Optional)
    #   # 設定内容: このアウトバウンドルールの説明を指定します。
    #   # 設定可能な値: 文字列
    #   description = "Allow all outbound traffic"
    # }
  ]

  #-------------------------------------------------------------
  # 削除設定
  #-------------------------------------------------------------

  # revoke_rules_on_delete (Optional)
  # 設定内容: セキュリティグループを削除する前に、アタッチされている全てのルールを取り消すかを指定します。
  # 設定可能な値:
  #   - true: 削除前にルールを取り消す
  #   - false (デフォルト): ルールを取り消さずに削除
  # 用途:
  #   - Elastic Map Reduce など、一部の AWS サービスは自動的にルールを追加します
  #   - これらのルールに循環依存がある場合、削除前に依存を解消する必要があります
  revoke_rules_on_delete = false

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWS リソースタグ付け
  #   プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-security-group"
    Environment = "production"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーの default_tags から継承されたタグを含む全タグのマップです。
  # 注意: 通常は明示的に設定せず、Terraform が自動計算します。
  # tags_all = {}

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト値を指定します。
  # 注意:
  #   - Lambda 関数に関連付けられたセキュリティグループは削除に最大 45 分かかることがあります
  #   - Provider バージョン 2.31.0 以降は自動的にこの延長タイムアウトを処理します
  #   - 古いバージョンを使用する場合は、delete タイムアウトを 45 分に設定してください
  timeouts {
    # create (Optional)
    # 設定内容: 作成操作のタイムアウトを指定します。
    # 設定可能な値: "10m" などの duration 文字列
    create = null

    # delete (Optional)
    # 設定内容: 削除操作のタイムアウトを指定します。
    # 設定可能な値: "45m" などの duration 文字列
    # 推奨: Lambda 関連の場合は "45m" を設定
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: セキュリティグループの Amazon Resource Name (ARN)
#
# - id: セキュリティグループの ID
#
# - owner_id: セキュリティグループの所有者 ID
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------

#---------------------------------------------------------------
#
# インラインルール (ingress/egress) の代わりに、以下のリソースを使用することを推奨します:
#
# resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
#   security_group_id = aws_security_group.example.id
#   cidr_ipv4         = "10.0.0.0/8"
#   from_port         = 443
#   ip_protocol       = "tcp"
#   to_port           = 443
#---------------------------------------------------------------
