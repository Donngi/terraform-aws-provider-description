#---------------------------------------------------------------
# VPC IPAM Pool
#---------------------------------------------------------------
#
# Amazon VPC IP Address Manager (IPAM) のIPアドレスプールをプロビジョニングするリソースです。
# IPAMプールは、連続したIPアドレス範囲（CIDR）の集合であり、ルーティングや
# セキュリティのニーズに応じてIPアドレスを整理することができます。
# プールは階層構造で管理でき、トップレベルプール、リージョナルプール、
# 環境別プール（本番/開発など）といった形で構成できます。
#
# AWS公式ドキュメント:
#   - IPAM プールの計画: https://docs.aws.amazon.com/vpc/latest/ipam/planning-ipam.html
#   - IPAM の概要: https://docs.aws.amazon.com/vpc/latest/ipam/what-it-is-ipam.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam_pool
#
# Provider Version: 6.36.0
# Generated: 2026-03-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpc_ipam_pool" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # address_family (Required)
  # 設定内容: このプールに割り当てるIPプロトコルを指定します。
  # 設定可能な値:
  #   - "ipv4": IPv4プロトコル
  #   - "ipv6": IPv6プロトコル
  # 注意: プールごとにIPv4またはIPv6のいずれかを選択する必要があります。
  # 参考: https://docs.aws.amazon.com/vpc/latest/ipam/planning-ipam.html
  address_family = "ipv4"

  # ipam_scope_id (Required)
  # 設定内容: IPAMプールを作成するスコープのIDを指定します。
  # 設定可能な値: 有効なIPAMスコープID
  # 注意: プールは、対応するIPAMリソースのprivate_default_scope_idまたは
  #       public_default_scope_idのいずれかに作成されます。
  # 参考: https://docs.aws.amazon.com/vpc/latest/ipam/planning-ipam.html
  ipam_scope_id = "ipam-scope-0123456789abcdef0"

  # description (Optional)
  # 設定内容: IPAMプールの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  description = "Regional pool for production environment"

  #-------------------------------------------------------------
  # ロケーション設定
  #-------------------------------------------------------------

  # locale (Optional)
  # 設定内容: IPAMプールを作成するロケール（リージョン）を指定します。
  # 設定可能な値: 任意のAWSリージョン（例: us-east-1, ap-northeast-1）
  # 省略時: リージョン指定なし（グローバルプール）
  # 注意: IPAMの動作リージョンと一致するロケールのプールのみ作成可能。
  #       プールのロケールと一致するリージョンのVPCからのみ利用できます。
  # 参考: https://docs.aws.amazon.com/vpc/latest/ipam/planning-ipam.html
  locale = "ap-northeast-1"

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # プール階層設定
  #-------------------------------------------------------------

  # source_ipam_pool_id (Optional)
  # 設定内容: ソースIPAMプールのIDを指定します。
  # 設定可能な値: 有効なIPAMプールID
  # 省略時: トップレベルプールとして作成されます。
  # 用途: 既存のプール内に子プールを作成する場合に使用します。
  #       これにより、階層的なプール構造を構築できます。
  # 参考: https://docs.aws.amazon.com/vpc/latest/ipam/planning-ipam.html
  source_ipam_pool_id = null

  #-------------------------------------------------------------
  # ソースリソース設定
  #-------------------------------------------------------------

  # source_resource (Optional)
  # 設定内容: リソース計画IPAMプールを構成するためのソースリソースを指定します。
  # 省略時: ソースリソースなし
  # 注意: 設定する場合、親プールのlocaleはVPCが存在するリージョンと一致する必要があります。
  # 参考: https://docs.aws.amazon.com/vpc/latest/ipam/planning-ipam.html
  #
  # source_resource {
  #   # resource_id (Required)
  #   # 設定内容: ソースリソースのIDを指定します。
  #   # 設定可能な値: 有効なリソースID（例: VPC ID）
  #   resource_id = "vpc-0123456789abcdef0"
  #
  #   # resource_owner (Required)
  #   # 設定内容: ソースリソースの所有者（AWSアカウントID）を指定します。
  #   # 設定可能な値: 有効なAWSアカウントID
  #   resource_owner = "123456789012"
  #
  #   # resource_region (Required)
  #   # 設定内容: ソースリソースが存在するリージョンを指定します。
  #   # 設定可能な値: 有効なAWSリージョンコード
  #   # 注意: 親IPAMプールのlocaleと一致する必要があります。
  #   resource_region = "ap-northeast-1"
  #
  #   # resource_type (Required)
  #   # 設定内容: ソースリソースのタイプを指定します。
  #   # 設定可能な値:
  #   #   - "vpc": VPCリソース
  #   resource_type = "vpc"
  # }

  #-------------------------------------------------------------
  # アロケーション設定
  #-------------------------------------------------------------

  # allocation_default_netmask_length (Optional)
  # 設定内容: このプールに追加される割り当てのデフォルトネットマスク長を指定します。
  # 設定可能な値: 0-32（IPv4の場合）、0-128（IPv6の場合）
  # 省略時: 指定なし
  # 用途: 例えば、このプールに10.0.0.0/8が割り当てられていて、ここに16を入力した場合、
  #       新しい割り当ては10.0.0.0/16がデフォルトになります（別のネットマスク値を
  #       指定しない限り）。
  # 参考: https://docs.aws.amazon.com/vpc/latest/ipam/planning-ipam.html
  allocation_default_netmask_length = null

  # allocation_min_netmask_length (Optional)
  # 設定内容: このプールでのCIDR割り当てに必要な最小ネットマスク長を指定します。
  # 設定可能な値: 0-32（IPv4の場合）、0-128（IPv6の場合）
  # 省略時: 制限なし
  # 用途: プールから割り当てられるCIDRの最小サイズを制限します。
  # 参考: https://docs.aws.amazon.com/vpc/latest/ipam/planning-ipam.html
  allocation_min_netmask_length = null

  # allocation_max_netmask_length (Optional)
  # 設定内容: このプールでのCIDR割り当てに必要な最大ネットマスク長を指定します。
  # 設定可能な値: 0-32（IPv4の場合）、0-128（IPv6の場合）
  # 省略時: 制限なし
  # 用途: プールから割り当てられるCIDRの最大サイズを制限します。
  # 参考: https://docs.aws.amazon.com/vpc/latest/ipam/planning-ipam.html
  allocation_max_netmask_length = null

  # allocation_resource_tags (Optional)
  # 設定内容: このIPAMプールからCIDRを使用するリソースに必要なタグを指定します。
  # 設定可能な値: タグのキーと値のペアのマップ
  # 省略時: タグ要件なし
  # 注意: これらのタグを持たないリソースは、プールからスペースを割り当てることが
  #       できません。リソースがスペースを割り当てた後にタグが変更された場合、
  #       またはプールの割り当てタグ要件が変更された場合、リソースは非準拠として
  #       マークされる可能性があります。
  # 参考: https://docs.aws.amazon.com/vpc/latest/ipam/planning-ipam.html
  allocation_resource_tags = null

  #-------------------------------------------------------------
  # 自動インポート設定
  #-------------------------------------------------------------

  # auto_import (Optional)
  # 設定内容: プールのCIDR範囲内にあるスコープ内のVPCを自動的にインポートするかを指定します。
  # 設定可能な値:
  #   - true: 自動インポートを有効化
  #   - false: 自動インポートを無効化
  # 省略時: 自動インポート無効
  # 用途: この引数を含めると、IPAMはプール内のCIDR範囲に該当する
  #       スコープ内のVPCを自動的にインポートします。
  # 参考: https://docs.aws.amazon.com/vpc/latest/ipam/planning-ipam.html
  auto_import = null

  #-------------------------------------------------------------
  # パブリックIP設定
  #-------------------------------------------------------------

  # public_ip_source (Optional)
  # 設定内容: パブリックスコープのプールのIPアドレスソースを指定します。
  # 設定可能な値:
  #   - "byoip": Bring Your Own IP（独自IPの持ち込み）
  #   - "amazon": AmazonのIPアドレス
  # 省略時: "byoip"
  # 注意: パブリックスコープのプールにIPアドレスCIDRをプロビジョニングする場合にのみ使用されます。
  # 参考: https://docs.aws.amazon.com/vpc/latest/ipam/tutorials-eip-pool.html
  public_ip_source = null

  # publicly_advertisable (Optional)
  # 設定内容: IPv6プールスペースをインターネット経由で公開アドバタイズするかを指定します。
  # 設定可能な値:
  #   - true: パブリックにアドバタイズする
  #   - false: パブリックにアドバタイズしない
  # 省略時: false
  # 注意: address_family = "ipv6" かつ public_ip_source = "byoip" の場合に必須です。
  #       IPv4プールスペースまたはpublic_ip_source = "amazon"の場合は利用できません。
  #       利用できない場合にtrueに設定すると、誤った差分が報告される可能性があります。
  # 参考: https://docs.aws.amazon.com/vpc/latest/ipam/tutorials-eip-pool.html
  publicly_advertisable = null

  # aws_service (Optional)
  # 設定内容: プールを使用できるAWSサービスを制限します。
  # 設定可能な値:
  #   - "ec2": Amazon EC2サービスのみ
  # 省略時: サービス制限なし
  # 注意: パブリックスコープでのみ使用可能です。
  # 参考: https://docs.aws.amazon.com/vpc/latest/ipam/planning-ipam.html
  aws_service = null

  #-------------------------------------------------------------
  # 削除動作設定
  #-------------------------------------------------------------

  # cascade (Optional)
  # 設定内容: プロビジョニングされたCIDR、割り当て、その他のプールを含む
  #           IPAMプールとそのプール内のすべてのリソースを迅速に削除できるようにします。
  # 設定可能な値:
  #   - true: カスケード削除を有効化
  #   - false: カスケード削除を無効化
  # 省略時: false
  # 注意: このオプションを有効にすると、プール削除時に関連するすべてのリソースも削除されます。
  # 参考: https://docs.aws.amazon.com/vpc/latest/ipam/planning-ipam.html
  cascade = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 関連機能: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "production-ipam-pool"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト値
    # 注意: リソース計画プールをプロビジョニングする場合、CIDRがIPAMによって管理されるまで
    #       最大30分かかる場合があります。
    create = null

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト値
    update = null

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト値
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: IPAMのAmazon Resource Name (ARN)
# - id: IPAMプールのID
# - ipam_scope_type: IPAMスコープのタイプ
# - pool_depth: プールの深さ（階層レベル）
# - state: IPAMプールの状態
# - tags_all: プロバイダーのdefault_tags設定を含む全タグのマップ
#---------------------------------------------------------------
