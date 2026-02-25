#---------------------------------------------------------------
# AWS License Manager License Configuration
#---------------------------------------------------------------
#
# AWS License Manager のライセンス設定をプロビジョニングするリソースです。
# ソフトウェアライセンスのカウントルールを定義し、使用量の追跡および制限を
# 一元管理できます。Microsoft、Oracle、SAP などのライセンスに対応しています。
#
# 主なユースケース:
#   - EC2インスタンスへのライセンスカウント追跡
#   - ソフトウェアライセンスの使用量の上限管理
#   - AWS Organizations全体でのライセンスコンプライアンス管理
#
# AWS公式ドキュメント:
#   - AWS License Manager とは: https://docs.aws.amazon.com/license-manager/latest/userguide/license-manager.html
#   - ライセンス設定の作成: https://docs.aws.amazon.com/license-manager/latest/userguide/create-license-configuration.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/licensemanager_license_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_licensemanager_license_configuration" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: ライセンス設定の名前を指定します。
  # 設定可能な値: 英数字、スペース、ハイフン、アンダースコアを含む文字列
  name = "example-license-configuration"

  # license_counting_type (Required)
  # 設定内容: ライセンスのカウント対象を指定します。
  # 設定可能な値:
  #   - "vCPU": 仮想CPUコア数でカウント
  #   - "Instance": EC2インスタンス数でカウント
  #   - "Core": 物理コア数でカウント
  #   - "Socket": 物理ソケット数でカウント
  license_counting_type = "vCPU"

  # description (Optional)
  # 設定内容: ライセンス設定の説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  description = "Example license configuration for vCPU-based licensing"

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # ライセンスカウント設定
  #-------------------------------------------------------------

  # license_count (Optional)
  # 設定内容: 管理するライセンスの総数を指定します。
  # 設定可能な値: 正の整数
  # 省略時: ライセンス数の上限を設定しない
  # 注意: license_count_hard_limit と組み合わせることで上限を強制適用できます
  license_count = 10

  # license_count_hard_limit (Optional)
  # 設定内容: ライセンス数の上限を厳密に適用するかを指定します。
  # 設定可能な値:
  #   - true: license_count を超えるライセンス使用を禁止する（ハードリミット）
  #   - false (デフォルト): license_count を超えてもアラートのみ（ソフトリミット）
  # 省略時: false
  license_count_hard_limit = false

  #-------------------------------------------------------------
  # ライセンスルール設定
  #-------------------------------------------------------------

  # license_rules (Optional)
  # 設定内容: ライセンスのカウントルールをリストで指定します。
  # 設定可能な値: "#<ルール名>=<値>" 形式の文字列リスト
  #
  # 利用可能なルール（license_counting_type に応じて異なります）:
  #   vCPU の場合:
  #     - "#minimumVcpus=<数値>": カウント対象の最小vCPU数
  #     - "#maximumVcpus=<数値>": カウント対象の最大vCPU数
  #   Core の場合:
  #     - "#minimumCores=<数値>": カウント対象の最小コア数
  #     - "#maximumCores=<数値>": カウント対象の最大コア数
  #   Socket の場合:
  #     - "#minimumSockets=<数値>": カウント対象の最小ソケット数
  #     - "#maximumSockets=<数値>": カウント対象の最大ソケット数
  #   Instance の場合:
  #     - "#allowedTenancy=<値>": 使用可能なテナンシー（EC2-Default, EC2-VPC, EC2-VPC-Dedicated）
  #     - "#minimumVcpus=<数値>": カウント対象の最小vCPU数
  #     - "#maximumVcpus=<数値>": カウント対象の最大vCPU数
  #
  # 参考: https://docs.aws.amazon.com/license-manager/latest/userguide/license-rules.html
  # 省略時: ルールなし
  license_rules = [
    "#minimumVcpus=2",
    "#maximumVcpus=16",
  ]

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  tags = {
    Name        = "example-license-configuration"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ライセンス設定のARN
# - id: ライセンス設定のARN（arn と同一）
# - owner_account_id: ライセンス設定を所有するAWSアカウントID
# - tags_all: プロバイダーのdefault_tagsを含む全タグマップ
#---------------------------------------------------------------
