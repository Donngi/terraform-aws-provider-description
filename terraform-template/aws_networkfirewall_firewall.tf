#---------------------------------------------------------------
# AWS Network Firewall Firewall
#---------------------------------------------------------------
#
# AWS Network Firewall のファイアウォールリソースをプロビジョニングします。
# VPC アタッチ型またはトランジットゲートウェイアタッチ型のファイアウォールを
# 作成して、VPC のトラフィックを検査・フィルタリングします。
#
# AWS公式ドキュメント:
#   - AWS Network Firewall とは: https://docs.aws.amazon.com/network-firewall/latest/developerguide/what-is-aws-network-firewall.html
#   - ファイアウォールの作成: https://docs.aws.amazon.com/network-firewall/latest/developerguide/getting-started.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_firewall
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_networkfirewall_firewall" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: ファイアウォールのフレンドリ名を指定します。
  # 設定可能な値: 最大128文字の英数字、ハイフン、アンダースコア
  name = "example-firewall"

  # description (Optional)
  # 設定内容: ファイアウォールのフレンドリな説明文を指定します。
  # 設定可能な値: 文字列
  # 省略時: 説明文なし
  description = "example network firewall"

  # firewall_policy_arn (Required)
  # 設定内容: ファイアウォールに関連付ける VPC ファイアウォールポリシーの ARN を指定します。
  # 設定可能な値: aws_networkfirewall_firewall_policy リソースの ARN
  firewall_policy_arn = aws_networkfirewall_firewall_policy.example.arn

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # ネットワーク設定（VPC アタッチ型）
  #-------------------------------------------------------------

  # vpc_id (Optional, Forces new resource)
  # 設定内容: ファイアウォールエンドポイントを作成する VPC の一意識別子を指定します。
  # 設定可能な値: 有効な VPC ID（vpc-XXXXXXXXXXXXXXXX 形式）
  # 注意: VPC アタッチ型ファイアウォールの作成時に必須です。
  #       transit_gateway_id と排他的ではありませんが、通常どちらか一方を使用します。
  vpc_id = "vpc-12345678901234567"

  #-------------------------------------------------------------
  # サブネットマッピング設定（VPC アタッチ型）
  #-------------------------------------------------------------

  # subnet_mapping (Optional)
  # 設定内容: ファイアウォールエンドポイントを配置するパブリックサブネットを設定するブロックです。
  # 設定可能な値: 各サブネットは異なるアベイラビリティゾーンに属する必要があります。
  # 注意: VPC アタッチ型ファイアウォールの作成時に必須です。
  #       AWS Network Firewall は各サブネットにファイアウォールエンドポイントを作成します。
  subnet_mapping {
    # subnet_id (Required)
    # 設定内容: ファイアウォールエンドポイントを配置するサブネットの一意識別子を指定します。
    # 設定可能な値: 有効なサブネット ID（subnet-XXXXXXXXXXXXXXXX 形式）
    subnet_id = "subnet-12345678901234567"

    # ip_address_type (Optional)
    # 設定内容: サブネットの IP アドレスタイプを指定します。
    # 設定可能な値:
    #   - "IPV4": IPv4 アドレスのみ（デフォルト）
    #   - "DUALSTACK": IPv4 と IPv6 の両方
    ip_address_type = "IPV4"
  }

  #-------------------------------------------------------------
  # トランジットゲートウェイアタッチ設定
  #-------------------------------------------------------------

  # transit_gateway_id (Optional, Forces new resource)
  # 設定内容: このファイアウォールにアタッチするトランジットゲートウェイの一意識別子を指定します。
  # 設定可能な値: 自分のアカウントまたは AWS Resource Access Manager で共有されたトランジットゲートウェイの ID
  # 注意: トランジットゲートウェイアタッチ型ファイアウォールの作成時に必須です。
  #       transit_gateway_id を指定する場合、availability_zone_mapping も必須になります。
  transit_gateway_id = null

  #-------------------------------------------------------------
  # アベイラビリティゾーンマッピング設定（トランジットゲートウェイアタッチ型）
  #-------------------------------------------------------------

  # availability_zone_mapping (Optional)
  # 設定内容: トランジットゲートウェイアタッチ型ファイアウォールのファイアウォールエンドポイントを
  #   作成するアベイラビリティゾーンを設定するブロックです。
  # 注意: トランジットゲートウェイアタッチ型ファイアウォールの作成時に必須です。
  availability_zone_mapping {
    # availability_zone_id (Required)
    # 設定内容: ファイアウォールエンドポイントを配置するアベイラビリティゾーンの ID を指定します。
    # 設定可能な値: 有効なアベイラビリティゾーン ID（例: use1-az1）
    availability_zone_id = "apne1-az1"
  }

  #-------------------------------------------------------------
  # 分析設定
  #-------------------------------------------------------------

  # enabled_analysis_types (Optional)
  # 設定内容: 分析メトリクスを収集するトラフィックタイプのセットを指定します。
  # 設定可能な値:
  #   - "TLS_SNI": TLS SNI（Server Name Indication）の分析を有効化
  #   - "HTTP_HOST": HTTP Host ヘッダーの分析を有効化
  # 省略時: [] （分析なし）
  # 参考: https://docs.aws.amazon.com/network-firewall/latest/developerguide/reporting.html
  enabled_analysis_types = []

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # encryption_configuration (Optional)
  # 設定内容: Network Firewall リソースの KMS 暗号化設定を指定するブロックです。
  # 関連機能: AWS Key Management Service (KMS)
  #   カスタマー管理キーを使用してリソースを暗号化できます。
  encryption_configuration {
    # type (Required)
    # 設定内容: Network Firewall リソースの暗号化に使用する AWS KMS キーのタイプを指定します。
    # 設定可能な値:
    #   - "CUSTOMER_KMS": カスタマー管理の KMS キーを使用して暗号化
    #   - "AWS_OWNED_KMS_KEY": AWS が管理する KMS キーを使用して暗号化
    type = "AWS_OWNED_KMS_KEY"

    # key_id (Optional)
    # 設定内容: カスタマー管理キーの ID を指定します。type が "CUSTOMER_KMS" の場合に使用します。
    # 設定可能な値: KMS がサポートするキー識別子（キー ID、キー ARN、エイリアス名、エイリアス ARN）
    # 注意: 別アカウントが管理するキーを使用する場合はキー ARN を指定する必要があります。
    # 省略時: type が "AWS_OWNED_KMS_KEY" の場合は不要
    key_id = null
  }

  #-------------------------------------------------------------
  # 保護設定
  #-------------------------------------------------------------

  # delete_protection (Optional)
  # 設定内容: 使用中のファイアウォールが誤って削除されないよう保護するかを指定します。
  # 設定可能な値:
  #   - true: 削除保護を有効化。AWS API を通じた削除を防止します。
  #   - false (デフォルト): 削除保護を無効化
  delete_protection = false

  # firewall_policy_change_protection (Optional)
  # 設定内容: 使用中のファイアウォールのポリシー関連付けが誤って変更されないよう保護するかを指定します。
  # 設定可能な値:
  #   - true: ポリシー変更保護を有効化
  #   - false (デフォルト): ポリシー変更保護を無効化
  firewall_policy_change_protection = false

  # subnet_change_protection (Optional)
  # 設定内容: 使用中のファイアウォールのサブネット関連付けが誤って変更されないよう保護するかを指定します。
  # 設定可能な値:
  #   - true: サブネット変更保護を有効化
  #   - false (デフォルト): サブネット変更保護を無効化
  subnet_change_protection = false

  # availability_zone_change_protection (Optional)
  # 設定内容: ファイアウォールのアベイラビリティゾーン設定が変更されないよう保護するかを指定します。
  # 設定可能な値:
  #   - true: AZ 変更保護を有効化。AZ の追加・削除の前に保護を無効化する必要があります。
  #   - false (デフォルト): AZ 変更保護を無効化
  availability_zone_change_protection = false

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソースの作成・更新・削除操作のタイムアウト時間を設定するブロックです。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: "30m", "1h" などの Go duration 形式の文字列
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: "30m", "1h" などの Go duration 形式の文字列
    update = "30m"

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: "30m", "1h" などの Go duration 形式の文字列
    delete = "30m"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-firewall"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ファイアウォールを識別する ARN
# - arn: ファイアウォールの Amazon Resource Name (ARN)
# - firewall_status: ファイアウォールの現在の状態を示すネストリスト
#   - sync_states: ファイアウォールで使用するように設定されたサブネットのセット
#     - attachment: ファイアウォールと VPC サブネットの関連付け状態を示すネストリスト
#       - endpoint_id: AWS Network Firewall がサブネット内に作成したファイアウォールエンドポイントの識別子
#       - subnet_id: ファイアウォールエンドポイントに指定したサブネットの一意識別子
#     - availability_zone: サブネットが設定されているアベイラビリティゾーン
#   - transit_gateway_attachment_sync_states: トランジットゲートウェイのセット
#     - attachment_id: トランジットゲートウェイアタッチメントの一意識別子
# - transit_gateway_owner_account_id: トランジットゲートウェイを所有する AWS アカウント ID
# - update_token: ファイアウォールの更新時に使用される文字列トークン
# - tags_all: プロバイダーの default_tags から継承されたタグを含む全タグのマップ
#---------------------------------------------------------------
