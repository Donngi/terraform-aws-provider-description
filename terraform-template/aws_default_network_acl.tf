#---------------------------------------------------------------
# AWS Default Network ACL
#---------------------------------------------------------------
#
# VPCのデフォルトネットワークACLを管理するためのリソースです。
# デフォルトVPCまたは非デフォルトVPCのデフォルトネットワークACLを管理できます。
#
# 重要な注意事項:
#   - このリソースは特殊なリソースです。Terraformはこのリソースを「作成」するのではなく、
#     既存のデフォルトNetwork ACLを管理下に「採用」します。
#   - Terraformがデフォルトネットワークを採用する際、ACL内の全てのルールを即座に削除し、
#     設定に定義されたルールのみを作成します。
#   - このリソースはインラインルールを絶対的なものとして扱うため、
#     aws_network_acl_rule リソースとは互換性がありません。
#
# AWS公式ドキュメント:
#   - Network ACL 概要: https://docs.aws.amazon.com/vpc/latest/userguide/vpc-network-acls.html
#   - デフォルト Network ACL: https://docs.aws.amazon.com/vpc/latest/userguide/default-network-acl.html
#   - Network ACL ルール: https://docs.aws.amazon.com/vpc/latest/userguide/nacl-rules.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_network_acl
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_default_network_acl" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # default_network_acl_id (Required)
  # 設定内容: 管理対象のデフォルトネットワークACLのIDを指定します。
  # 設定可能な値: aws_vpc リソースからエクスポートされる default_network_acl_id、
  #              またはAWSコンソールから手動で取得したNetwork ACL ID
  # 用途: どのVPCのデフォルトNetwork ACLを管理するかを指定
  # 関連機能: VPCのデフォルトNetwork ACL
  #   すべてのVPCには自動的にデフォルトNetwork ACLが作成されます。
  #   - https://docs.aws.amazon.com/vpc/latest/userguide/default-network-acl.html
  default_network_acl_id = aws_vpc.main.default_network_acl_id

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # サブネット関連付け
  #-------------------------------------------------------------

  # subnet_ids (Optional)
  # 設定内容: このACLを適用するサブネットIDのリストを指定します。
  # 設定可能な値: サブネットIDの文字列セット
  # 省略時: 関連付けは変更されません
  # 重要な注意:
  #   - サブネットは常に1つのNetwork ACLにのみ関連付けられます。
  #   - サブネットがこのリストから削除されると、自動的にVPCのデフォルトNetwork ACLに戻ります。
  #   - Terraform外部でサブネットの関連付けが変更されると差分が発生します。
  #   - この動作を避けるには、lifecycle { ignore_changes = [subnet_ids] } を使用してください。
  # 関連機能: Network ACLとサブネットの関連付け
  #   - https://docs.aws.amazon.com/vpc/latest/userguide/network-acl-associations.html
  subnet_ids = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id,
  ]

  #-------------------------------------------------------------
  # インバウンドルール設定
  #-------------------------------------------------------------

  # ingress (Optional)
  # 設定内容: インバウンド（受信）トラフィックのルールを定義します。
  # 用途: サブネットに入ってくるトラフィックの許可/拒否を制御
  # 注意: Network ACLはステートレスのため、戻りトラフィック用のegressルールも必要です。
  # 関連機能: Network ACL ルール
  #   ルールは番号の小さい順に評価され、最初にマッチしたルールが適用されます。
  #   - https://docs.aws.amazon.com/vpc/latest/userguide/nacl-rules.html

  # 例: 全てのインバウンドトラフィックを許可
  ingress {
    # rule_no (Required)
    # 設定内容: ルールの評価順序を決定する番号を指定します。
    # 設定可能な値: 1 - 32766 の整数
    # 用途: ルールは番号の小さい順に評価されます。最初にマッチしたルールが適用されます。
    rule_no = 100

    # action (Required)
    # 設定内容: ルールがマッチした場合のアクションを指定します。
    # 設定可能な値:
    #   - "allow": トラフィックを許可
    #   - "deny": トラフィックを拒否
    action = "allow"

    # protocol (Required)
    # 設定内容: ルールが適用されるプロトコルを指定します。
    # 設定可能な値:
    #   - "-1" または "all": 全てのプロトコル
    #   - "tcp" または "6": TCP
    #   - "udp" または "17": UDP
    #   - "icmp" または "1": ICMP
    #   - その他のIANA プロトコル番号
    # 注意: "-1" (全て) を使用する場合、from_port と to_port は 0 に設定する必要があります。
    protocol = "-1"

    # from_port (Required)
    # 設定内容: ルールが適用されるポート範囲の開始ポートを指定します。
    # 設定可能な値: 0 - 65535 の整数
    # 注意: protocol が "-1" の場合は 0 を指定
    from_port = 0

    # to_port (Required)
    # 設定内容: ルールが適用されるポート範囲の終了ポートを指定します。
    # 設定可能な値: 0 - 65535 の整数
    # 注意: protocol が "-1" の場合は 0 を指定
    to_port = 0

    # cidr_block (Optional)
    # 設定内容: ルールが適用されるIPv4 CIDRブロックを指定します。
    # 設定可能な値: 有効なIPv4 CIDRブロック (例: "0.0.0.0/0", "10.0.0.0/16")
    # 注意: cidr_block または ipv6_cidr_block のいずれかを指定する必要があります。
    cidr_block = "0.0.0.0/0"

    # ipv6_cidr_block (Optional)
    # 設定内容: ルールが適用されるIPv6 CIDRブロックを指定します。
    # 設定可能な値: 有効なIPv6 CIDRブロック (例: "::/0")
    # ipv6_cidr_block = "::/0"

    # icmp_code (Optional)
    # 設定内容: ICMPコードを指定します。
    # 設定可能な値: -1 (全て) または 0-255 の整数
    # 省略時: 0
    # 用途: ICMPプロトコル使用時のみ有効
    # 参考: https://www.iana.org/assignments/icmp-parameters/icmp-parameters.xhtml
    # icmp_code = 0

    # icmp_type (Optional)
    # 設定内容: ICMPタイプを指定します。
    # 設定可能な値: -1 (全て) または 0-255 の整数
    # 省略時: 0
    # 用途: ICMPプロトコル使用時のみ有効
    # 参考: https://www.iana.org/assignments/icmp-parameters/icmp-parameters.xhtml
    # icmp_type = 0
  }

  #-------------------------------------------------------------
  # アウトバウンドルール設定
  #-------------------------------------------------------------

  # egress (Optional)
  # 設定内容: アウトバウンド（送信）トラフィックのルールを定義します。
  # 用途: サブネットから出ていくトラフィックの許可/拒否を制御
  # 注意: Network ACLはステートレスのため、リクエストへの応答トラフィックも明示的に許可が必要です。
  # 関連機能: Network ACL ルール
  #   - https://docs.aws.amazon.com/vpc/latest/userguide/nacl-rules.html

  # 例: 全てのアウトバウンドトラフィックを許可
  egress {
    # rule_no (Required)
    # 設定内容: ルールの評価順序を決定する番号を指定します。
    # 設定可能な値: 1 - 32766 の整数
    rule_no = 100

    # action (Required)
    # 設定内容: ルールがマッチした場合のアクションを指定します。
    # 設定可能な値:
    #   - "allow": トラフィックを許可
    #   - "deny": トラフィックを拒否
    action = "allow"

    # protocol (Required)
    # 設定内容: ルールが適用されるプロトコルを指定します。
    # 設定可能な値:
    #   - "-1" または "all": 全てのプロトコル
    #   - "tcp" または "6": TCP
    #   - "udp" または "17": UDP
    #   - "icmp" または "1": ICMP
    protocol = "-1"

    # from_port (Required)
    # 設定内容: ルールが適用されるポート範囲の開始ポートを指定します。
    # 設定可能な値: 0 - 65535 の整数
    from_port = 0

    # to_port (Required)
    # 設定内容: ルールが適用されるポート範囲の終了ポートを指定します。
    # 設定可能な値: 0 - 65535 の整数
    to_port = 0

    # cidr_block (Optional)
    # 設定内容: ルールが適用されるIPv4 CIDRブロックを指定します。
    # 設定可能な値: 有効なIPv4 CIDRブロック
    cidr_block = "0.0.0.0/0"

    # ipv6_cidr_block (Optional)
    # 設定内容: ルールが適用されるIPv6 CIDRブロックを指定します。
    # 設定可能な値: 有効なIPv6 CIDRブロック
    # ipv6_cidr_block = "::/0"

    # icmp_code (Optional)
    # 設定内容: ICMPコードを指定します。
    # icmp_code = 0

    # icmp_type (Optional)
    # 設定内容: ICMPタイプを指定します。
    # icmp_type = 0
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "default-network-acl"
    Environment = "production"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーのdefault_tagsから継承されるタグを含む全タグのマップ
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  tags_all = null

  # id (Optional, Computed)
  # 設定内容: リソースのID。デフォルトNetwork ACLのIDと同じ値
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  id = null

  #-------------------------------------------------------------
  # ライフサイクル設定の推奨
  #-------------------------------------------------------------
  # サブネット関連付けの外部変更を無視したい場合:
  #
  # lifecycle {
  #   ignore_changes = [subnet_ids]
  # }
}

#---------------------------------------------------------------
# Network ACLでは、ルールを定義しなければ全トラフィックが拒否されます。
# セキュリティを最大化するには、以下のように空のルールで定義します:
#
# resource "aws_default_network_acl" "deny_all" {
#   default_network_acl_id = aws_vpc.main.default_network_acl_id
#
#   # ingress/egress ブロックを定義しないことで、全トラフィックを拒否
#
#   tags = {
#     Name = "deny-all-default-nacl"
#   }
# }

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: デフォルトネットワークACLのAmazon Resource Name (ARN)
#
# - id: デフォルトネットワークACLのID
#
# - owner_id: デフォルトネットワークACLを所有するAWSアカウントのID
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#   リソースに割り当てられたすべてのタグのマップ
#
# - vpc_id: 関連付けられたVPCのID
#---------------------------------------------------------------
