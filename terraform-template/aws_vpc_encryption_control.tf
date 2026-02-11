#---------------------------------------------------------------
# AWS VPC Encryption Control
#---------------------------------------------------------------
#
# Amazon VPCの暗号化コントロールをプロビジョニングするリソースです。
# VPC内およびVPC間のトランジット中のトラフィックの暗号化状態を監視し、
# 暗号化を強制することができます。HIPAA、FedRAMP、PCI DSSなどの
# コンプライアンス要件に対応するため、ハードウェアベースのAES-256暗号化を
# 提供します。
#
# AWS公式ドキュメント:
#   - VPC Encryption Controls発表: https://aws.amazon.com/blogs/aws/introducing-vpc-encryption-controls-enforce-encryption-in-transit-within-and-across-vpcs-in-a-region/
#   - CreateVpcEncryptionControl API: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_CreateVpcEncryptionControl.html
#   - ModifyVpcEncryptionControl API: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_ModifyVpcEncryptionControl.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_encryption_control
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpc_encryption_control" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # vpc_id (Required)
  # 設定内容: VPC Encryption ControlをリンクするVPCのIDを指定します。
  # 設定可能な値: 有効なVPC ID（例: vpc-0123456789abcdef0）
  # 関連機能: VPC Encryption Control
  #   指定したVPCに対して暗号化コントロールを有効化します。
  #   VPC内のNitroインスタンス間のトラフィックが暗号化対象となります。
  #   - https://aws.amazon.com/blogs/aws/introducing-vpc-encryption-controls-enforce-encryption-in-transit-within-and-across-vpcs-in-a-region/
  vpc_id = "vpc-0123456789abcdef0"

  # mode (Required)
  # 設定内容: VPC Encryption Controlの動作モードを指定します。
  # 設定可能な値:
  #   - "monitor": 暗号化状態を監視し、暗号化されていないトラフィックを特定します。
  #                 既存のリソースには影響を与えず、監査用途に利用できます。
  #   - "enforce": 暗号化を強制します。将来作成されるリソースは互換性のある
  #                 Nitroインスタンスのみに制限され、暗号化されていないトラフィックは
  #                 破棄されます。
  # 関連機能: VPC Encryption Control動作モード
  #   monitorモードで暗号化状態を確認後、enforceモードに切り替えることで
  #   段階的に暗号化を適用できます。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_ModifyVpcEncryptionControl.html
  mode = "monitor"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # 暗号化除外設定（enforceモード時のみ有効）
  #-------------------------------------------------------------

  # egress_only_internet_gateway_exclusion (Optional)
  # 設定内容: Egress-Only Internet Gatewayを暗号化の強制から除外するかを指定します。
  # 設定可能な値:
  #   - "disable" (デフォルト): 除外しない。暗号化を強制します。
  #   - "enable": 除外する。暗号化を強制しません。
  # 注意: modeが"enforce"の場合にのみ有効です。
  # 関連機能: VPC Encryption Control リソース除外
  #   特定のリソースタイプを暗号化の強制から除外することで、
  #   互換性の問題を回避できます。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_ModifyVpcEncryptionControl.html
  egress_only_internet_gateway_exclusion = null

  # elastic_file_system_exclusion (Optional)
  # 設定内容: Elastic File System（EFS）を暗号化の強制から除外するかを指定します。
  # 設定可能な値:
  #   - "disable" (デフォルト): 除外しない。暗号化を強制します。
  #   - "enable": 除外する。暗号化を強制しません。
  # 注意: modeが"enforce"の場合にのみ有効です。
  # 関連機能: VPC Encryption Control リソース除外
  #   EFSマウントターゲットへのトラフィックを除外設定の対象とします。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_ModifyVpcEncryptionControl.html
  elastic_file_system_exclusion = null

  # internet_gateway_exclusion (Optional)
  # 設定内容: Internet Gatewayを暗号化の強制から除外するかを指定します。
  # 設定可能な値:
  #   - "disable" (デフォルト): 除外しない。暗号化を強制します。
  #   - "enable": 除外する。暗号化を強制しません。
  # 注意: modeが"enforce"の場合にのみ有効です。
  # 関連機能: VPC Encryption Control リソース除外
  #   Internet Gatewayを経由するトラフィックを除外設定の対象とします。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_ModifyVpcEncryptionControl.html
  internet_gateway_exclusion = null

  # lambda_exclusion (Optional)
  # 設定内容: Lambda Functionを暗号化の強制から除外するかを指定します。
  # 設定可能な値:
  #   - "disable" (デフォルト): 除外しない。暗号化を強制します。
  #   - "enable": 除外する。暗号化を強制しません。
  # 注意: modeが"enforce"の場合にのみ有効です。
  # 関連機能: VPC Encryption Control リソース除外
  #   VPC内のLambda関数からのトラフィックを除外設定の対象とします。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_ModifyVpcEncryptionControl.html
  lambda_exclusion = null

  # nat_gateway_exclusion (Optional)
  # 設定内容: NAT Gatewayを暗号化の強制から除外するかを指定します。
  # 設定可能な値:
  #   - "disable" (デフォルト): 除外しない。暗号化を強制します。
  #   - "enable": 除外する。暗号化を強制しません。
  # 注意: modeが"enforce"の場合にのみ有効です。
  # 関連機能: VPC Encryption Control リソース除外
  #   NAT Gatewayを経由するトラフィックを除外設定の対象とします。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_ModifyVpcEncryptionControl.html
  nat_gateway_exclusion = null

  # virtual_private_gateway_exclusion (Optional)
  # 設定内容: Virtual Private Gatewayを暗号化の強制から除外するかを指定します。
  # 設定可能な値:
  #   - "disable" (デフォルト): 除外しない。暗号化を強制します。
  #   - "enable": 除外する。暗号化を強制しません。
  # 注意: modeが"enforce"の場合にのみ有効です。
  # 関連機能: VPC Encryption Control リソース除外
  #   VPN接続用のVirtual Private Gatewayを経由するトラフィックを
  #   除外設定の対象とします。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_ModifyVpcEncryptionControl.html
  virtual_private_gateway_exclusion = null

  # vpc_lattice_exclusion (Optional)
  # 設定内容: VPC Latticeを暗号化の強制から除外するかを指定します。
  # 設定可能な値:
  #   - "disable" (デフォルト): 除外しない。暗号化を強制します。
  #   - "enable": 除外する。暗号化を強制しません。
  # 注意: modeが"enforce"の場合にのみ有効です。
  # 関連機能: VPC Encryption Control リソース除外
  #   VPC Latticeサービスネットワークへのトラフィックを除外設定の対象とします。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_ModifyVpcEncryptionControl.html
  vpc_lattice_exclusion = null

  # vpc_peering_exclusion (Optional)
  # 設定内容: VPC Peeringを暗号化の強制から除外するかを指定します。
  # 設定可能な値:
  #   - "disable" (デフォルト): 除外しない。暗号化を強制します。
  #   - "enable": 除外する。暗号化を強制しません。
  # 注意: modeが"enforce"の場合にのみ有効です。
  # 関連機能: VPC Encryption Control リソース除外
  #   VPC Peering接続を経由するトラフィックを除外設定の対象とします。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_ModifyVpcEncryptionControl.html
  vpc_peering_exclusion = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-vpc-encryption-control"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: "30s"、"2h45m"などの時間文字列（秒: s、分: m、時: h）
    # 省略時: デフォルトのタイムアウト値が使用されます。
    # 参考: https://pkg.go.dev/time#ParseDuration
    create = null

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: "30s"、"2h45m"などの時間文字列（秒: s、分: m、時: h）
    # 省略時: デフォルトのタイムアウト値が使用されます。
    # 参考: https://pkg.go.dev/time#ParseDuration
    update = null

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: "30s"、"2h45m"などの時間文字列（秒: s、分: m、時: h）
    # 省略時: デフォルトのタイムアウト値が使用されます。
    # 注意: deleteタイムアウトの設定は、destroy操作が発生する前に
    #       変更がstateに保存される場合にのみ適用されます。
    # 参考: https://pkg.go.dev/time#ParseDuration
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: VPC Encryption ControlのID
#
# - state: VPC Encryption Controlの現在の状態
#
# - state_message: VPC Encryption Controlの状態に関する追加情報を提供するメッセージ
#
# - resource_exclusions: 暗号化の強制から除外されたリソースの状態。
#                        modeが"monitor"の場合はnilになります。
#                        以下のネストされたオブジェクトを含みます:
#   - egress_only_internet_gateway: Egress-Only Internet Gatewayの
#                                    暗号化強制状態を示すstateとstate_message
#   - elastic_file_system: Elastic File System（EFS）の暗号化強制状態を示す
#                          stateとstate_message
#   - internet_gateway: Internet Gatewayの暗号化強制状態を示す
#                       stateとstate_message
#   - lambda: Lambda Functionの暗号化強制状態を示すstateとstate_message
#   - nat_gateway: NAT Gatewayの暗号化強制状態を示すstateとstate_message
#   - virtual_private_gateway: Virtual Private Gatewayの暗号化強制状態を示す
#                              stateとstate_message
#   - vpc_lattice: VPC Latticeの暗号化強制状態を示すstateとstate_message
#---------------------------------------------------------------
