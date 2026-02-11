#---------------------------------------------------------------
# AWS Network Firewall - Firewall
#---------------------------------------------------------------
#
# AWS Network Firewall のファイアウォールリソースをプロビジョニングする。
# Network Firewall は VPC 内のネットワークトラフィックを検査・フィルタリングするための
# マネージドファイアウォールサービスである。ファイアウォールは VPC 内の指定したサブネットに
# ファイアウォールエンドポイントを作成し、トラフィックをファイアウォールポリシーに従って
# 検査する。VPC アタッチ型と Transit Gateway アタッチ型の2つのデプロイモードをサポートする。
#
# AWS公式ドキュメント:
#   - AWS Network Firewall とは: https://docs.aws.amazon.com/network-firewall/latest/developerguide/what-is-aws-network-firewall.html
#   - ファイアウォールとファイアウォールエンドポイント: https://docs.aws.amazon.com/network-firewall/latest/developerguide/firewalls.html
#   - ファイアウォールコンポーネント: https://docs.aws.amazon.com/network-firewall/latest/developerguide/firewall-components.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_firewall
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_networkfirewall_firewall" "this" {
  #---------------------------------------------------------------
  # 必須引数 (Required Arguments)
  #---------------------------------------------------------------

  # name (必須, 変更時に再作成)
  # ファイアウォールのフレンドリーな名前。
  # ファイアウォールを識別するための一意の名前を指定する。
  # 一度作成後に変更すると、ファイアウォールは再作成される。
  name = "example-firewall"

  # firewall_policy_arn (必須)
  # VPC ファイアウォールポリシーの Amazon Resource Name (ARN)。
  # ファイアウォールが使用するファイアウォールポリシーを指定する。
  # ファイアウォールポリシーは、トラフィック検査のルールグループや
  # ポリシーレベルの動作設定を定義する。
  firewall_policy_arn = "arn:aws:network-firewall:ap-northeast-1:123456789012:firewall-policy/example-policy"

  #---------------------------------------------------------------
  # オプション引数 (Optional Arguments)
  #---------------------------------------------------------------

  # vpc_id (オプション, 変更時に再作成)
  # VPC アタッチ型ファイアウォールを作成する場合に必須。
  # Network Firewall がファイアウォールを作成する VPC の一意の識別子。
  # Transit Gateway アタッチ型ファイアウォールの場合は指定しない。
  vpc_id = "vpc-xxxxxxxxxxxxxxxxx"

  # transit_gateway_id (オプション, 変更時に再作成)
  # Transit Gateway アタッチ型ファイアウォールを作成する場合に必須。
  # このファイアウォールにアタッチする Transit Gateway の一意の識別子。
  # 自アカウントの Transit Gateway、または AWS Resource Access Manager を通じて
  # 共有された Transit Gateway を指定できる。
  # VPC アタッチ型ファイアウォールの場合は指定しない。
  # transit_gateway_id = "tgw-xxxxxxxxxxxxxxxxx"

  # description (オプション)
  # ファイアウォールのフレンドリーな説明。
  # ファイアウォールの目的や用途を説明するテキストを指定できる。
  description = "Example Network Firewall for traffic inspection"

  # delete_protection (オプション)
  # ファイアウォールが削除から保護されているかどうかを示すフラグ。
  # true に設定すると、使用中のファイアウォールを誤って削除することを防ぐ。
  # デフォルト: false
  delete_protection = false

  # firewall_policy_change_protection (オプション)
  # ファイアウォールポリシーの関連付け変更から保護されているかどうかを示すフラグ。
  # true に設定すると、使用中のファイアウォールのポリシーを誤って変更することを防ぐ。
  # デフォルト: false
  firewall_policy_change_protection = false

  # subnet_change_protection (オプション)
  # サブネット関連付けの変更から保護されているかどうかを示すフラグ。
  # true に設定すると、使用中のファイアウォールのサブネット設定を誤って変更することを防ぐ。
  # デフォルト: false
  subnet_change_protection = false

  # availability_zone_change_protection (オプション)
  # アベイラビリティゾーン構成の変更から保護されているかどうかを示すフラグ。
  # true に設定すると、アベイラビリティゾーンの追加・削除を行う前に
  # まずこの保護を無効にする必要がある。
  availability_zone_change_protection = false

  # enabled_analysis_types (オプション)
  # 分析メトリクスを収集するタイプのセット。
  # Network Firewall でネットワークトラフィックのレポートを有効にする。
  # 有効な値: "TLS_SNI", "HTTP_HOST"
  # デフォルト: [] (空のセット)
  # 詳細: https://docs.aws.amazon.com/network-firewall/latest/developerguide/reporting.html
  enabled_analysis_types = []

  # region (オプション, computed)
  # このリソースが管理されるリージョン。
  # 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用される。
  # https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "ap-northeast-1"

  # tags (オプション)
  # リソースに関連付けるタグのマップ。
  # プロバイダーの default_tags 設定ブロックでタグが設定されている場合、
  # 一致するキーを持つタグはプロバイダーレベルで定義されたものを上書きする。
  tags = {
    Name        = "example-firewall"
    Environment = "development"
  }

  #---------------------------------------------------------------
  # subnet_mapping ブロック (オプション, VPC アタッチ型ファイアウォールの場合は必須)
  #---------------------------------------------------------------
  # パブリックサブネットを設定するブロック。
  # 各サブネットは VPC 内の異なるアベイラビリティゾーンに属する必要がある。
  # AWS Network Firewall は各サブネットにファイアウォールエンドポイントを作成する。
  # Transit Gateway アタッチ型ファイアウォールの場合は指定しない。

  subnet_mapping {
    # subnet_id (必須)
    # サブネットの一意の識別子。
    # ファイアウォールエンドポイントを作成するサブネットを指定する。
    subnet_id = "subnet-xxxxxxxxxxxxxxxxx"

    # ip_address_type (オプション, computed)
    # サブネットの IP アドレスタイプ。
    # 有効な値: "DUALSTACK", "IPV4"
    # デフォルト: "IPV4" (computed)
    # ip_address_type = "IPV4"
  }

  # subnet_mapping {
  #   subnet_id       = "subnet-yyyyyyyyyyyyyyyyy"
  #   ip_address_type = "IPV4"
  # }

  #---------------------------------------------------------------
  # availability_zone_mapping ブロック (オプション, Transit Gateway アタッチ型ファイアウォールの場合は必須)
  #---------------------------------------------------------------
  # Transit Gateway アタッチ型ファイアウォールのファイアウォールエンドポイントを
  # 作成するアベイラビリティゾーンを設定するブロック。
  # VPC アタッチ型ファイアウォールの場合は指定しない。

  # availability_zone_mapping {
  #   # availability_zone_id (必須)
  #   # ファイアウォールエンドポイントが配置されるアベイラビリティゾーンの ID。
  #   # ゾーン名 (ap-northeast-1a) ではなく、ゾーン ID (apne1-az1) を指定する。
  #   availability_zone_id = "apne1-az1"
  # }

  # availability_zone_mapping {
  #   availability_zone_id = "apne1-az2"
  # }

  #---------------------------------------------------------------
  # encryption_configuration ブロック (オプション)
  #---------------------------------------------------------------
  # KMS 暗号化構成設定。
  # Network Firewall リソースの暗号化に使用する KMS キーを指定する。

  # encryption_configuration {
  #   # type (必須)
  #   # Network Firewall リソースの暗号化に使用する AWS KMS キーのタイプ。
  #   # 有効な値:
  #   #   - "CUSTOMER_KMS": カスタマーマネージド KMS キーを使用
  #   #   - "AWS_OWNED_KMS_KEY": AWS が所有する KMS キーを使用 (デフォルト)
  #   type = "CUSTOMER_KMS"
  #
  #   # key_id (オプション)
  #   # カスタマーマネージドキーの ID。
  #   # KMS がサポートするキー識別子 (キー ID, キー ARN, エイリアス名, エイリアス ARN) を使用できる。
  #   # 別のアカウントが管理するキーを使用する場合は、キー ARN を指定する。
  #   # type が "CUSTOMER_KMS" の場合に指定する。
  #   # https://docs.aws.amazon.com/kms/latest/developerguide/concepts.html#key-id
  #   key_id = "arn:aws:kms:ap-northeast-1:123456789012:key/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  # }

  #---------------------------------------------------------------
  # timeouts ブロック (オプション)
  #---------------------------------------------------------------
  # リソース操作のタイムアウト設定。
  # 各操作のタイムアウト時間をカスタマイズできる。

  # timeouts {
  #   # create (オプション)
  #   # ファイアウォール作成操作のタイムアウト。
  #   # デフォルト: 30m
  #   create = "30m"
  #
  #   # update (オプション)
  #   # ファイアウォール更新操作のタイムアウト。
  #   # デフォルト: 30m
  #   update = "30m"
  #
  #   # delete (オプション)
  #   # ファイアウォール削除操作のタイムアウト。
  #   # デフォルト: 30m
  #   delete = "30m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (参照専用属性)
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能な computed 属性です。
# Terraform 設定で直接設定することはできません。
#
# id:
#   ファイアウォールを識別する Amazon Resource Name (ARN)。
#   例: aws_networkfirewall_firewall.this.id
#
# arn:
#   ファイアウォールを識別する Amazon Resource Name (ARN)。
#   例: aws_networkfirewall_firewall.this.arn
#
# firewall_status:
#   ファイアウォールの現在のステータスに関する情報のネストされたリスト。
#   - sync_states: ファイアウォール用に構成されたサブネットのセット
#     - attachment: ファイアウォールと単一の VPC サブネットとの関連付け状態を説明するネストリスト
#       - endpoint_id: サブネットでインスタンス化されたファイアウォールエンドポイントの識別子。
#                      VPC ルートテーブルでトラフィックをエンドポイント経由でルーティングする際に使用。
#       - subnet_id: ファイアウォールエンドポイント用に指定されたサブネットの一意の識別子
#     - availability_zone: サブネットが構成されているアベイラビリティゾーン
#   - transit_gateway_attachment_sync_states: Transit Gateway 構成のセット
#     - attachment_id: Transit Gateway アタッチメントの一意の識別子
#   例: aws_networkfirewall_firewall.this.firewall_status
#
# tags_all:
#   プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#   リソースに割り当てられたタグのマップ。
#   例: aws_networkfirewall_firewall.this.tags_all
#
# transit_gateway_owner_account_id:
#   Transit Gateway を所有する AWS アカウント ID。
#   Transit Gateway アタッチ型ファイアウォールで使用。
#   例: aws_networkfirewall_firewall.this.transit_gateway_owner_account_id
#
# update_token:
#   ファイアウォールを更新するときに使用される文字列トークン。
#   例: aws_networkfirewall_firewall.this.update_token
#---------------------------------------------------------------
