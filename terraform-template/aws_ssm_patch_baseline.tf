#---------------------------------------------------------------
# AWS SSM Patch Baseline
#---------------------------------------------------------------
#
# AWS Systems Manager Patch Managerのパッチベースラインをプロビジョニングするリソースです。
# パッチベースラインは、マネージドノードへのパッチ適用を制御するルールセットを定義します。
# 承認済みパッチの明示的な指定や、自動承認ルールによるパッチの承認が可能です。
#
# AWS公式ドキュメント:
#   - Patch Manager概要: https://docs.aws.amazon.com/systems-manager/latest/userguide/patch-manager.html
#   - パッチベースラインの操作: https://docs.aws.amazon.com/systems-manager/latest/userguide/patch-manager-create-a-patch-baseline.html
#   - 定義済みおよびカスタムパッチベースライン: https://docs.aws.amazon.com/systems-manager/latest/userguide/patch-manager-predefined-and-custom-patch-baselines.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_patch_baseline
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ssm_patch_baseline" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: パッチベースラインの名前を指定します。
  # 設定可能な値: 文字列
  name = "my-patch-baseline"

  # description (Optional)
  # 設定内容: パッチベースラインの説明を指定します。
  # 設定可能な値: 文字列
  description = "Custom patch baseline for production servers"

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
  # OS設定
  #-------------------------------------------------------------

  # operating_system (Optional)
  # 設定内容: パッチベースラインが適用されるオペレーティングシステムを指定します。
  # 設定可能な値:
  #   - "ALMA_LINUX": Alma Linux
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
  #   - "WINDOWS" (デフォルト): Windows Server
  operating_system = "WINDOWS"

  #-------------------------------------------------------------
  # 承認済みパッチ設定
  #-------------------------------------------------------------

  # approved_patches (Optional)
  # 設定内容: 明示的に承認するパッチのリストを指定します。
  # 設定可能な値: パッチIDの文字列セット（例: "KB123456"）
  # 注意: approval_ruleと排他的（どちらか一方を指定する必要があります）
  approved_patches = ["KB123456"]

  # approved_patches_compliance_level (Optional)
  # 設定内容: 承認済みパッチのコンプライアンスレベルを指定します。
  # 設定可能な値:
  #   - "CRITICAL": 重大
  #   - "HIGH": 高
  #   - "MEDIUM": 中
  #   - "LOW": 低
  #   - "INFORMATIONAL": 情報
  #   - "UNSPECIFIED" (デフォルト): 未指定
  # 注意: 承認済みパッチが欠落と報告された場合、この値がコンプライアンス違反の重大度になります。
  approved_patches_compliance_level = "HIGH"

  # approved_patches_enable_non_security (Optional)
  # 設定内容: 承認済みパッチのリストにセキュリティ以外の更新を含めるかを指定します。
  # 設定可能な値:
  #   - true: セキュリティ以外の更新も含める
  #   - false: セキュリティ更新のみ
  # 注意: Linuxインスタンスにのみ適用されます。
  approved_patches_enable_non_security = false

  #-------------------------------------------------------------
  # 拒否パッチ設定
  #-------------------------------------------------------------

  # rejected_patches (Optional)
  # 設定内容: 拒否するパッチのリストを指定します。
  # 設定可能な値: パッチIDの文字列セット
  # 注意: 承認ルールや承認済みリストよりも優先されます。
  rejected_patches = ["KB987654"]

  # rejected_patches_action (Optional)
  # 設定内容: 拒否パッチリストに含まれるパッチに対するPatch Managerのアクションを指定します。
  # 設定可能な値:
  #   - "ALLOW_AS_DEPENDENCY": 他のパッチの依存関係としてインストールを許可
  #   - "BLOCK": パッチのインストールを完全にブロック
  rejected_patches_action = "BLOCK"

  #-------------------------------------------------------------
  # セキュリティ更新コンプライアンス設定
  #-------------------------------------------------------------

  # available_security_updates_compliance_status (Optional)
  # 設定内容: セキュリティ関連パッチが利用可能だが承認されていないマネージドノードの
  #          コンプライアンスステータスを指定します。
  # 設定可能な値:
  #   - "COMPLIANT": 準拠
  #   - "NON_COMPLIANT": 非準拠
  # 注意: Windows Serverマネージドノードのみサポートされています。
  available_security_updates_compliance_status = null

  #-------------------------------------------------------------
  # 承認ルール設定
  #-------------------------------------------------------------

  # approval_rule (Optional)
  # 設定内容: パッチをベースラインに含めるためのルールセットを定義します。
  # 最大10個のルールを指定可能です。
  # 注意: approved_patchesと排他的（どちらか一方を指定する必要があります）
  # 参考: https://docs.aws.amazon.com/systems-manager/latest/userguide/patch-manager-predefined-and-custom-patch-baselines.html
  approval_rule {
    # approve_after_days (Optional)
    # 設定内容: パッチのリリース日から承認までの日数を指定します。
    # 設定可能な値: 0〜360の整数
    # 注意: approve_until_dateと排他的（どちらか一方のみ指定可能）
    approve_after_days = 7

    # approve_until_date (Optional)
    # 設定内容: パッチ自動承認のカットオフ日を指定します。
    # 設定可能な値: "YYYY-MM-DD"形式の日付文字列
    # 注意: この日付以前にリリースされたパッチは自動的にインストールされます。
    #       approve_after_daysと排他的（どちらか一方のみ指定可能）
    # approve_until_date = "2026-12-31"

    # compliance_level (Optional)
    # 設定内容: このルールで承認されたパッチのコンプライアンスレベルを指定します。
    # 設定可能な値:
    #   - "CRITICAL": 重大
    #   - "HIGH": 高
    #   - "MEDIUM": 中
    #   - "LOW": 低
    #   - "INFORMATIONAL": 情報
    #   - "UNSPECIFIED" (デフォルト): 未指定
    compliance_level = "HIGH"

    # enable_non_security (Optional)
    # 設定内容: セキュリティ以外の更新の適用を有効にするかを指定します。
    # 設定可能な値:
    #   - true: セキュリティ以外の更新も適用
    #   - false (デフォルト): セキュリティ更新のみ
    # 注意: Linuxインスタンスにのみ適用されます。
    enable_non_security = false

    # patch_filter (Required, 1〜10個)
    # 設定内容: ルールの条件を定義するパッチフィルターグループを指定します。
    # 1つのルールにつき最大10個のパッチフィルターを指定可能です。
    # 参考: https://docs.aws.amazon.com/systems-manager/latest/APIReference/API_DescribePatchProperties.html
    patch_filter {
      # key (Required)
      # 設定内容: フィルターのキーを指定します。
      # 設定可能な値: OSによって異なります。一般的なキー:
      #   - "PRODUCT": 製品名
      #   - "CLASSIFICATION": パッチ分類
      #   - "MSRC_SEVERITY": MSRC重大度（Windows）
      #   - "PATCH_ID": パッチID
      #   - "PATCH_SET": パッチセット（"OS" または "APPLICATION"）
      #   - "PRIORITY": 優先度（Linux）
      #   - "SEVERITY": 重大度（Linux）
      key = "CLASSIFICATION"

      # values (Required)
      # 設定内容: フィルターの値を指定します。
      # 設定可能な値: キーに対応する正確な値、またはワイルドカード "*"
      #   PATCH_SET未指定時のデフォルトは "OS"
      values = ["CriticalUpdates", "SecurityUpdates"]
    }

    patch_filter {
      key    = "MSRC_SEVERITY"
      values = ["Critical", "Important"]
    }
  }

  #-------------------------------------------------------------
  # グローバルフィルター設定
  #-------------------------------------------------------------

  # global_filter (Optional, 最大4個)
  # 設定内容: ベースラインからパッチを除外するためのグローバルフィルターを定義します。
  # Key/Valueペアで最大4つのフィルターを指定可能です。
  # 設定可能なKey: "PRODUCT", "CLASSIFICATION", "MSRC_SEVERITY", "PATCH_ID"
  global_filter {
    # key (Required)
    # 設定内容: フィルターのキーを指定します。
    key = "PRODUCT"

    # values (Required)
    # 設定内容: フィルターの値を指定します。
    values = ["WindowsServer2016"]
  }

  #-------------------------------------------------------------
  # パッチソース設定
  #-------------------------------------------------------------

  # source (Optional, 最大20個)
  # 設定内容: パッチの代替ソースリポジトリを定義します。
  # 注意: Linuxインスタンスにのみ適用されます。
  source {
    # name (Required)
    # 設定内容: パッチソースを識別するための名前を指定します。
    name = "My-AL2023"

    # products (Required)
    # 設定内容: パッチリポジトリが適用される特定のOSバージョンを指定します。
    # 設定可能な値: "AmazonLinux2023", "Ubuntu16.04", "RedhatEnterpriseLinux7.2" 等
    # 参考: https://docs.aws.amazon.com/systems-manager/latest/APIReference/API_PatchFilter.html
    products = ["AmazonLinux2023"]

    # configuration (Required)
    # 設定内容: yumリポジトリの設定値を指定します。
    # 参考: https://man7.org/linux/man-pages/man5/dnf.conf.5.html
    configuration = <<-EOF
[amzn-main]
name=amzn-main-Base
mirrorlist=http://repo.$awsregion.$awsdomain/$releasever/main/mirror.list
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-amazon-ga
EOF
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-patch-baseline"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: パッチベースラインのAmazon Resource Name (ARN)
#
# - id: パッチベースラインのID
#
# - json: パッチベースラインのJSON定義
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
