# ----------------------------------------------------------------------------
# AWS Default Security Group - Annotated Template
# ----------------------------------------------------------------------------
# Generated: 2026-01-22
# Provider Version: 6.28.0
#
# NOTE: このテンプレートは生成時点の情報です。
# 最新の仕様については公式ドキュメントを確認してください。
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group
#
# IMPORTANT: このリソースは特殊な動作をします:
# - Terraformは新しいリソースを作成するのではなく、既存のデフォルトセキュリティグループを「管理下に置く」
# - 管理開始時、すべての既存のイングレス/エグレスルールを即座に削除します
# - その後、設定で指定されたルールのみを作成します
# - このリソースはインラインルールを絶対的なものとして扱います
# - aws_security_group_ruleリソースとは互換性がありません
#
# AWS公式ドキュメント:
# https://docs.aws.amazon.com/vpc/latest/userguide/default-security-group.html
# ----------------------------------------------------------------------------

resource "aws_default_security_group" "example" {
  # ----------------------------------------------------------------------------
  # VPC Configuration
  # ----------------------------------------------------------------------------

  # vpc_id - VPC ID
  # Type: string
  # Optional (Forces new resource)
  #
  # 管理対象とするVPCのID。
  #
  # 注意: vpc_idを変更しても、変更前のデフォルトセキュリティグループで
  # 追加・変更・削除されたルールは復元されません。現在の状態のまま残ります。
  #
  # 参考: https://docs.aws.amazon.com/vpc/latest/userguide/default-security-group.html
  vpc_id = "vpc-12345678"

  # ----------------------------------------------------------------------------
  # Ingress Rules
  # ----------------------------------------------------------------------------

  # ingress - インバウンドルール設定ブロック
  # Type: set of objects
  # Optional, Computed
  #
  # インバウンド（受信）トラフィックのルールを定義します。
  # 複数のingressブロックを指定できます。
  #
  # 参考: https://docs.aws.amazon.com/vpc/latest/userguide/security-group-rules.html
  ingress {
    # protocol - プロトコル
    # Type: string
    # Required
    #
    # 許可するプロトコル。
    # 値: "tcp", "udp", "icmp", "-1"（すべて）、または
    # プロトコル番号（https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml）
    #
    # "-1"を指定する場合、from_portとto_portは0にする必要があります。
    protocol = "tcp"

    # from_port - 開始ポート
    # Type: number
    # Required
    #
    # ポート範囲の開始ポート、またはICMPタイプ番号。
    # プロトコルが"-1"の場合は0を指定します。
    from_port = 443

    # to_port - 終了ポート
    # Type: number
    # Required
    #
    # ポート範囲の終了ポート、またはICMPコード。
    # プロトコルが"-1"の場合は0を指定します。
    to_port = 443

    # cidr_blocks - CIDR ブロックリスト
    # Type: list of strings
    # Optional
    #
    # 許可するIPv4 CIDRブロックのリスト。
    # 例: ["10.0.0.0/8", "172.16.0.0/12"]
    cidr_blocks = ["0.0.0.0/0"]

    # ipv6_cidr_blocks - IPv6 CIDR ブロックリスト
    # Type: list of strings
    # Optional
    #
    # 許可するIPv6 CIDRブロックのリスト。
    # 例: ["::/0"]
    ipv6_cidr_blocks = []

    # prefix_list_ids - プレフィックスリストIDリスト
    # Type: list of strings
    # Optional
    #
    # VPCエンドポイントへのアクセスを許可するためのプレフィックスリストIDのリスト。
    #
    # 参考: https://docs.aws.amazon.com/vpc/latest/userguide/managed-prefix-lists.html
    prefix_list_ids = []

    # security_groups - セキュリティグループリスト
    # Type: set of strings
    # Optional
    #
    # 許可するセキュリティグループのリスト。
    # デフォルトVPCに対してはグループ名を使用できます。
    # それ以外の場合はグループIDを使用します。
    security_groups = []

    # self - 自己参照
    # Type: bool
    # Optional
    #
    # trueの場合、このセキュリティグループ自身をソースとして追加します。
    # 同じセキュリティグループに属するリソース間の通信を許可する場合に使用します。
    self = false

    # description - ルールの説明
    # Type: string
    # Optional
    #
    # このルールの説明。
    description = "HTTPS inbound traffic"
  }

  # ----------------------------------------------------------------------------
  # Egress Rules
  # ----------------------------------------------------------------------------

  # egress - アウトバウンドルール設定ブロック
  # Type: set of objects
  # Optional, Computed (VPC only)
  #
  # アウトバウンド（送信）トラフィックのルールを定義します。
  # 複数のegressブロックを指定できます。
  # VPCでのみ使用可能です。
  #
  # 参考: https://docs.aws.amazon.com/vpc/latest/userguide/security-group-rules.html
  egress {
    # protocol - プロトコル
    # Type: string
    # Required
    #
    # 許可するプロトコル。
    # 値: "tcp", "udp", "icmp", "-1"（すべて）、または
    # プロトコル番号（https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml）
    #
    # "-1"を指定する場合、from_portとto_portは0にする必要があります。
    protocol = "-1"

    # from_port - 開始ポート
    # Type: number
    # Required
    #
    # ポート範囲の開始ポート、またはICMPタイプ番号。
    # プロトコルが"-1"の場合は0を指定します。
    from_port = 0

    # to_port - 終了ポート
    # Type: number
    # Required
    #
    # ポート範囲の終了ポート、またはICMPコード。
    # プロトコルが"-1"の場合は0を指定します。
    to_port = 0

    # cidr_blocks - CIDR ブロックリスト
    # Type: list of strings
    # Optional
    #
    # 許可するIPv4 CIDRブロックのリスト。
    # 例: ["10.0.0.0/8", "172.16.0.0/12"]
    cidr_blocks = ["0.0.0.0/0"]

    # ipv6_cidr_blocks - IPv6 CIDR ブロックリスト
    # Type: list of strings
    # Optional
    #
    # 許可するIPv6 CIDRブロックのリスト。
    # 例: ["::/0"]
    ipv6_cidr_blocks = []

    # prefix_list_ids - プレフィックスリストIDリスト
    # Type: list of strings
    # Optional
    #
    # VPCエンドポイントへのアクセスを許可するためのプレフィックスリストIDのリスト。
    #
    # 参考: https://docs.aws.amazon.com/vpc/latest/userguide/managed-prefix-lists.html
    prefix_list_ids = []

    # security_groups - セキュリティグループリスト
    # Type: set of strings
    # Optional
    #
    # 許可するセキュリティグループのリスト。
    # デフォルトVPCに対してはグループ名を使用できます。
    # それ以外の場合はグループIDを使用します。
    security_groups = []

    # self - 自己参照
    # Type: bool
    # Optional
    #
    # trueの場合、このセキュリティグループ自身をソースとして追加します。
    # 同じセキュリティグループに属するリソース間の通信を許可する場合に使用します。
    self = false

    # description - ルールの説明
    # Type: string
    # Optional
    #
    # このルールの説明。
    description = "Allow all outbound traffic"
  }

  # ----------------------------------------------------------------------------
  # Additional Configuration
  # ----------------------------------------------------------------------------

  # revoke_rules_on_delete - 削除時のルール取り消し
  # Type: bool
  # Optional
  #
  # trueの場合、リソース削除時にセキュリティグループルールを取り消します。
  # デフォルトはfalseです。
  revoke_rules_on_delete = false

  # ----------------------------------------------------------------------------
  # Region Configuration
  # ----------------------------------------------------------------------------

  # region - リージョン
  # Type: string
  # Optional, Computed
  #
  # このリソースが管理されるリージョン。
  # 指定しない場合、プロバイダー設定のリージョンが使用されます。
  #
  # 参考:
  # - https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#aws-configuration-reference
  region = "us-east-1"

  # ----------------------------------------------------------------------------
  # Tagging
  # ----------------------------------------------------------------------------

  # tags - タグマップ
  # Type: map of strings
  # Optional
  #
  # リソースに割り当てるタグのマップ。
  #
  # プロバイダーのdefault_tags設定ブロックで定義されたタグと
  # キーが一致する場合、このtagsで定義された値が優先されます。
  #
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "default-security-group"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # tags_all - 全タグマップ（読み取り専用として扱う）
  # Type: map of strings
  # Optional, Computed
  #
  # リソースに割り当てられたすべてのタグ（プロバイダーのdefault_tagsから
  # 継承されたタグを含む）のマップ。
  #
  # 注意: このフィールドはcomputedであるため、通常は明示的に設定する必要はありません。
  # プロバイダーのdefault_tagsとこのリソースのtagsの統合結果が自動的に反映されます。
  #
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  # tags_all = {}

  # id - セキュリティグループID
  # Type: string
  # Optional, Computed
  #
  # セキュリティグループのID。
  # 通常はcomputedとして扱われますが、インポート時などに使用できます。
  #
  # 注意: このフィールドは通常、明示的に設定する必要はありません。
  # id = "sg-12345678"
}

# ----------------------------------------------------------------------------
# Computed Attributes (読み取り専用)
# ----------------------------------------------------------------------------
#
# 以下の属性はTerraformによって自動的に計算され、参照可能です:
#
# - arn         : セキュリティグループのARN
# - description : セキュリティグループの説明
# - id          : セキュリティグループのID
# - name        : セキュリティグループの名前
# - owner_id    : オーナーID
# - tags_all    : すべてのタグ（プロバイダーのdefault_tagsを含む）
#
# 使用例:
# output "security_group_arn" {
#   value = aws_default_security_group.example.arn
# }
#
# output "security_group_id" {
#   value = aws_default_security_group.example.id
# }
# ----------------------------------------------------------------------------

