#---------------------------------------------------------------
# AWS Systems Manager Default Patch Baseline
#---------------------------------------------------------------
#
# AWS Systems ManagerのPatch Managerで使用するデフォルトパッチベースラインを
# 登録するリソースです。オペレーティングシステムごとにデフォルトとして
# 使用するパッチベースラインを指定できます。
#
# AWS公式ドキュメント:
#   - デフォルトパッチベースラインの設定: https://docs.aws.amazon.com/systems-manager/latest/userguide/patch-manager-default-patch-baseline.html
#   - RegisterDefaultPatchBaseline API: https://docs.aws.amazon.com/systems-manager/latest/APIReference/API_RegisterDefaultPatchBaseline.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_default_patch_baseline
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ssm_default_patch_baseline" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # baseline_id (Required)
  # 設定内容: デフォルトとして設定するパッチベースラインのIDまたはARNを指定します。
  # 設定可能な値:
  #   - カスタムパッチベースラインのID（例: pb-1234567890abcdef0）
  #   - パッチベースラインのARN（例: arn:aws:ssm:region:account-id:patchbaseline/pb-1234567890abcdef0）
  #   - AWSが提供するパッチベースラインの場合は、ARN形式での指定が必須
  # 関連機能: Patch Managerパッチベースライン
  #   パッチベースラインは、管理対象インスタンスに承認および拒否すべきパッチを定義します。
  #   カスタムパッチベースラインを作成するか、AWSが提供する定義済みパッチベースラインを使用できます。
  #   - https://docs.aws.amazon.com/systems-manager/latest/userguide/patch-manager-predefined-and-custom-patch-baselines.html
  # 注意: AWSが提供するパッチベースラインを指定する場合は、IDではなくARN形式で指定する必要があります。
  baseline_id = "pb-1234567890abcdef0"

  # operating_system (Required)
  # 設定内容: パッチベースラインが適用されるオペレーティングシステムを指定します。
  # 設定可能な値:
  #   - "AMAZON_LINUX": Amazon Linux
  #   - "AMAZON_LINUX_2": Amazon Linux 2
  #   - "AMAZON_LINUX_2022": Amazon Linux 2022
  #   - "AMAZON_LINUX_2023": Amazon Linux 2023
  #   - "CENTOS": CentOS
  #   - "DEBIAN": Debian
  #   - "MACOS": macOS
  #   - "ORACLE_LINUX": Oracle Linux
  #   - "RASPBIAN": Raspbian
  #   - "REDHAT_ENTERPRISE_LINUX": Red Hat Enterprise Linux
  #   - "ROCKY_LINUX": Rocky Linux
  #   - "SUSE": SUSE Linux Enterprise Server
  #   - "UBUNTU": Ubuntu
  #   - "WINDOWS": Windows
  # 関連機能: Patch Managerサポート対象OS
  #   Patch Managerは、複数のオペレーティングシステムに対してパッチ適用をサポートしています。
  #   各OSタイプごとにデフォルトパッチベースラインを個別に設定できます。
  #   - https://docs.aws.amazon.com/systems-manager/latest/userguide/patch-manager-supported-oses.html
  # 注意: baseline_idで指定したパッチベースラインのオペレーティングシステムと一致する必要があります。
  operating_system = "AMAZON_LINUX_2023"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 注意: デフォルトパッチベースラインの設定はリージョンごとに独立しています。
  #       別のリージョンでデフォルトパッチベースラインを設定する場合は、
  #       region引数を使用するか、別のプロバイダーインスタンスを使用してください。
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: パッチベースラインのID
#       baseline_idとoperating_systemの値を組み合わせた識別子が自動生成されます。
#---------------------------------------------------------------
