#---------------------------------------------------------------
# AWS EC2 Allowed Images Settings
#---------------------------------------------------------------
#
# AWSアカウントレベルでEC2インスタンス起動時に使用可能なAMIを制御する
# 設定を管理するリソースです。指定した基準を満たすAMIのみを検出・使用
# 可能にすることで、AMIガバナンスを強化します。
#
# AWS公式ドキュメント:
#   - Control the discovery and use of AMIs in Amazon EC2 with Allowed AMIs: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-allowed-amis.html
#   - Manage the settings for Allowed AMIs: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/manage-settings-allowed-amis.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_allowed_images_settings
#
# Provider Version: 6.28.0
# Generated: 2026-01-31
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
# 重要な制約:
#   - このリソースはAWSアカウント・リージョンごとに1つのみ存在します（アカウントレベル設定）
#   - AWS APIはこのリソースを削除しません。destroy実行時はプロバイダーが設定を無効化（disabled状態に変更）します
#   - アカウントが所有するAMIは制御対象外です（パブリックAMI・共有AMIのみが対象）
#   - AWS Organizationsの宣言的ポリシーを使用して複数アカウントに展開可能
#
#---------------------------------------------------------------

resource "aws_ec2_allowed_images_settings" "example" {
  #-------------------------------------------------------------
  # 状態設定
  #-------------------------------------------------------------

  # state (Required)
  # 設定内容: Allowed AMIs設定の状態を指定します
  # 設定可能な値:
  #   - "enabled": 基準を強制し、非準拠AMIの使用をブロック
  #   - "disabled": Allowed AMIs機能を無効化
  #   - "audit-mode": プレビューモード（非準拠インスタンスを特定するが、ブロックはしない）
  # 関連機能: Allowed AMIs
  #   AMIの検出と使用を制御する機能。3つの動作状態（enabled、disabled、audit-mode）をサポート。
  #   audit-modeを使用することで、本番適用前に影響範囲を確認可能。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-allowed-amis.html
  # 注意: 本番適用前に必ず"audit-mode"で影響範囲を確認してください
  state = "enabled"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # AMI基準設定
  #-------------------------------------------------------------

  # image_criterion (Optional)
  # 設定内容: AMIが検出・使用可能となるために満たすべき基準を定義します
  # 評価ロジック:
  #   - AMIは単一のimage_criterionブロック内のすべてのパラメータに一致する必要があります（AND条件）
  #   - 各パラメータリスト内では少なくとも1つの値に一致する必要があります（OR条件）
  #   - 複数のimage_criterionが定義されている場合、AMIは少なくとも1つに一致する必要があります（OR条件）
  # 関連機能: Allowed AMIs Criteria
  #   AMIの検出と使用を制御するための基準。image_providers、image_names、marketplace_product_codes、
  #   creation_date_condition、deprecation_time_conditionなどのパラメータを使用して詳細な制御が可能。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-allowed-amis.html#allowed-amis-json-configuration
  image_criterion {
    # image_providers (Optional)
    # 設定内容: AMIの提供を許可するAWSアカウントIDまたはオーナーエイリアスのリスト
    # 設定可能な値:
    #   - "amazon": Amazon所有のAMI
    #   - "aws-marketplace": AWS MarketplaceのAMI
    #   - "self": 自アカウント所有のAMI
    #   - 12桁のAWSアカウントID（例: "123456789012"）
    # 関連機能: Image Providers
    #   信頼できるAMI提供元を指定。Amazonの公式AMI、特定のパートナーアカウント、
    #   または社内アカウントからのAMIのみを許可することでセキュリティを強化。
    #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-allowed-amis.html
    image_providers = ["amazon"]

    # image_names (Optional)
    # 設定内容: 許可するAMI名のパターンリスト。ワイルドカードマッチングをサポート
    # 設定可能な値: AMI名のパターン（"*"でワイルドカード使用可）
    # 関連機能: AMI Name Filtering
    #   AMIの命名規則を強制することで、承認されたAMIのみの使用を保証。
    #   image_providersと組み合わせることでより強力なガバナンスを実現。
    #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-allowed-amis.html
    # 例: image_names = ["approved-ami-*", "golden-image-*"]
    image_names = null

    # marketplace_product_codes (Optional)
    # 設定内容: 許可するAWS Marketplaceプロダクトコードのリスト
    # 設定可能な値: AWS Marketplaceプロダクトコード
    # 関連機能: Marketplace AMI Filtering
    #   特定のMarketplace製品からのAMIのみを許可。プロダクトコードは
    #   AWS Marketplaceの製品詳細ページで確認可能。
    #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-allowed-amis.html
    # 例: marketplace_product_codes = ["marketplace-code-123"]
    marketplace_product_codes = null

    # creation_date_condition (Optional)
    # 設定内容: AMIの作成日に基づいて制限を設定します
    # 関連機能: AMI Age Filtering
    #   古いAMIの使用を防止。最新のセキュリティパッチやコンプライアンス要件を満たすAMIのみを使用。
    #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-allowed-amis.html
    creation_date_condition {
      # maximum_days_since_created (Optional)
      # 設定内容: AMIが作成されてからの最大日数
      # 設定可能な値: 数値（日数）
      # 推奨値:
      #   - 30: 非常に厳格（月次更新）
      #   - 90: 中程度（四半期更新）
      #   - 180: 緩い（半年更新）
      # 例: maximum_days_since_created = 90
      maximum_days_since_created = null
    }

    # deprecation_time_condition (Optional)
    # 設定内容: AMIの非推奨状態に基づいて制限を設定します
    # 関連機能: AMI Deprecation Filtering
    #   非推奨AMIの使用を防止。移行に必要な猶予期間を設定可能。
    #   本番環境では厳格なコンプライアンスのため0を推奨。
    #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-allowed-amis.html
    deprecation_time_condition {
      # maximum_days_since_deprecated (Optional)
      # 設定内容: AMIが非推奨となってからの最大日数
      # 設定可能な値: 数値（日数）
      # 推奨値:
      #   - 0: すべての非推奨AMIを即座にブロック
      #   - 30: 30日間の猶予期間
      #   - 90: 90日間の猶予期間
      # 例: maximum_days_since_deprecated = 0
      maximum_days_since_deprecated = null
    }
  }
}

#---------------------------------------------------------------
#
# 1. 基本: Amazonのみ許可
# resource "aws_ec2_allowed_images_settings" "amazon_only" {
#   state = "enabled"
#   image_criterion {
#     image_providers = ["amazon"]
#   }
# }
#
# 2. 監査モードで特定アカウント
# resource "aws_ec2_allowed_images_settings" "audit_mode" {
#   state = "audit-mode"
#   image_criterion {
#     image_providers = ["amazon", "123456789012"]
#   }
# }
#
# 3. 包括的な設定（複数基準）
# resource "aws_ec2_allowed_images_settings" "comprehensive" {
#   state = "enabled"
#
#   # 基準1: Amazon AMIと信頼できるアカウント（鮮度制限付き）
#   image_criterion {
#     image_providers = ["amazon", "123456789012"]
#     creation_date_condition {
#       maximum_days_since_created = 90
#     }
#     deprecation_time_condition {
#       maximum_days_since_deprecated = 0
#     }
#   }
#
#   # 基準2: Marketplace AMI（承認済み製品）
#   image_criterion {
#     marketplace_product_codes = ["marketplace-code-123"]
#     image_names = ["approved-ami-*"]
#   }
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは引数以外の追加属性をエクスポートしません。
#---------------------------------------------------------------

#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
# EC2 Allowed Images Settingsは、リージョンを使用してインポートできます。
#
# terraform import aws_ec2_allowed_images_settings.example ap-northeast-1
#
# 注意:
#   - アカウント・リージョンごとに設定は1つのみ存在します
#   - インポート後、既存の設定がTerraformで管理されます
#---------------------------------------------------------------
