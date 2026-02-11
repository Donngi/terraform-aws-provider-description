#---------------------------------------------------------------
# AWS Security Hub Insight
#---------------------------------------------------------------
#
# AWS Security Hubのカスタムインサイトをプロビジョニングするリソースです。
# インサイトは、Security Hubの検出結果を集約し、特定の基準に基づいて
# グループ化することで、セキュリティ態勢を視覚的に把握できるようにします。
# カスタムフィルターを使用して、特定のセキュリティ問題や傾向を
# 追跡・分析することが可能です。
#
# AWS公式ドキュメント:
#   - Security Hub概要: https://docs.aws.amazon.com/securityhub/latest/userguide/what-is-securityhub.html
#   - カスタムインサイト管理: https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-custom-insights.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_insight
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_securityhub_insight" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: カスタムインサイトの名前を指定します。
  # 設定可能な値: 1文字以上の文字列
  # 注意: わかりやすく説明的な名前を付けることを推奨
  name = "example-insight"

  # group_by_attribute (Required)
  # 設定内容: 検出結果をグループ化するために使用する属性を指定します。
  #          インサイトは、この属性に基づいて検出結果のリストを生成します。
  # 設定可能な値: Security Hubの検出結果フィールド名
  #   - 一般的な例: "ResourceId", "AwsAccountId", "SeverityLabel", "ComplianceStatus",
  #                  "ProductName", "ResourceType", "CreatedAt", "Confidence" など
  # 関連機能: AWS Security Hub検出結果フィールド
  #   - https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-findings-format.html
  group_by_attribute = "ResourceId"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # フィルター設定
  #-------------------------------------------------------------

  # filters (Required)
  # 設定内容: インサイトに含める検出結果をフィルタリングするための設定ブロックです。
  #          最大10個の異なる属性を使用してフィルタリングできます。
  #          フィルター基準に一致する検出結果のみがインサイトに含まれます。
  # 注意: filtersブロックは必須です。少なくとも1つのフィルター条件を指定する必要があります。
  filters {
    #-----------------------------------------------------------
    # アカウント・組織関連フィルター
    #-----------------------------------------------------------

    # aws_account_id (Optional)
    # 設定内容: 検出結果が生成されたAWSアカウントIDでフィルタリングします。
    # フィルタータイプ: String Filter
    # 製品・プロバイダー関連フィルター
    #-----------------------------------------------------------

    # company_name (Optional)
    # 設定内容: 検出結果を生成したソリューション（製品）を所有する会社名でフィルタリングします。
    # フィルタータイプ: String Filter
    # コンプライアンス関連フィルター
    #-----------------------------------------------------------

    # compliance_status (Optional)
    # 設定内容: サポートされている標準（CIS AWS Foundationsなど）の特定ルールに対する
    #          チェック実行の結果として生成された検出結果のコンプライアンスステータスで
    #          フィルタリングします。
    # フィルタータイプ: String Filter
    # 設定可能な値: "PASSED", "WARNING", "FAILED", "NOT_AVAILABLE"
    # compliance_status {
    #   comparison = "EQUALS"
    #   value      = "FAILED"
    # }

    #-----------------------------------------------------------
    # 重要度・信頼度関連フィルター
    #-----------------------------------------------------------

    # severity_label (Optional)
    # 設定内容: 検出結果の重要度ラベルでフィルタリングします。
    # フィルタータイプ: String Filter
    # 設定可能な値: "INFORMATIONAL", "LOW", "MEDIUM", "HIGH", "CRITICAL"
    # Finding Provider Fields フィルター
    #-----------------------------------------------------------
    # 検出結果プロバイダーが提供する元の値でフィルタリングします

    # finding_provider_fields_confidence (Optional)
    # 設定内容: 検出結果プロバイダーが提供する信頼度の値でフィルタリングします。
    # フィルタータイプ: Number Filter
    # finding_provider_fields_confidence {
    #   gte = "80"
    # }

    # finding_provider_fields_criticality (Optional)
    # 設定内容: 検出結果プロバイダーが提供する重要度レベルでフィルタリングします。
    # フィルタータイプ: Number Filter
    # finding_provider_fields_criticality {
    #   gte = "80"
    # }

    # finding_provider_fields_severity_label (Optional)
    # 設定内容: 検出結果プロバイダーが提供する重要度ラベルでフィルタリングします。
    # フィルタータイプ: String Filter
    # finding_provider_fields_severity_label {
    #   comparison = "EQUALS"
    #   value      = "HIGH"
    # }

    # finding_provider_fields_severity_original (Optional)
    # 設定内容: 検出結果プロバイダーの重要度の元の値でフィルタリングします。
    # フィルタータイプ: String Filter
    # finding_provider_fields_severity_original {
    #   comparison = "EQUALS"
    #   value      = "HIGH"
    # }

    # finding_provider_fields_types (Optional)
    # 設定内容: 検出結果プロバイダーが割り当てた検出結果タイプでフィルタリングします。
    # フィルタータイプ: String Filter
    # フォーマット: "namespace/category/classifier"
    # 有効なネームスペース: "Software and Configuration Checks", "TTPs", "Effects",
    #                       "Unusual Behaviors", "Sensitive Data Identifications"
    # finding_provider_fields_types {
    #   comparison = "PREFIX"
    #   value      = "Software and Configuration Checks"
    # }

    # finding_provider_fields_related_findings_id (Optional)
    # 設定内容: 検出結果プロバイダーが特定した関連検出結果の識別子でフィルタリングします。
    # フィルタータイプ: String Filter
    # finding_provider_fields_related_findings_id {
    #   comparison = "EQUALS"
    #   value      = "example-finding-id"
    # }

    # finding_provider_fields_related_findings_product_arn (Optional)
    # 設定内容: 検出結果プロバイダーが特定した関連検出結果を生成したソリューションのARNで
    #          フィルタリングします。
    # フィルタータイプ: String Filter
    # finding_provider_fields_related_findings_product_arn {
    #   comparison = "PREFIX"
    #   value      = "arn:aws:securityhub"
    # }

    #-----------------------------------------------------------
    # 日時関連フィルター
    #-----------------------------------------------------------

    # created_at (Optional)
    # 設定内容: セキュリティ検出結果プロバイダーが潜在的なセキュリティ問題を
    #          キャプチャした日時（ISO8601形式）でフィルタリングします。
    # フィルタータイプ: Date Filter
    # 検出結果メタデータフィルター
    #-----------------------------------------------------------

    # id (Optional)
    # 設定内容: セキュリティ検出結果プロバイダー固有の検出結果識別子でフィルタリングします。
    # フィルタータイプ: String Filter
    # id {
    #   comparison = "PREFIX"
    #   value      = "arn:aws:securityhub"
    # }

    # generator_id (Optional)
    # 設定内容: 検出結果を生成したソリューション固有のコンポーネント（論理単位）の
    #          識別子でフィルタリングします。
    # フィルタータイプ: String Filter
    # generator_id {
    #   comparison = "PREFIX"
    #   value      = "aws-foundational-security-best-practices"
    # }

    # type (Optional)
    # 設定内容: 検出結果を分類する検出結果タイプでフィルタリングします。
    # フィルタータイプ: String Filter
    # フォーマット: "namespace/category/classifier"
    # type {
    #   comparison = "PREFIX"
    #   value      = "Software and Configuration Checks"
    # }

    # title (Optional)
    # 設定内容: 検出結果のタイトルでフィルタリングします。
    # フィルタータイプ: String Filter
    # title {
    #   comparison = "CONTAINS"
    #   value      = "S3 bucket"
    # }

    # description (Optional)
    # 設定内容: 検出結果の説明でフィルタリングします。
    # フィルタータイプ: String Filter
    # description {
    #   comparison = "CONTAINS"
    #   value      = "encryption"
    # }

    # source_url (Optional)
    # 設定内容: セキュリティ検出結果プロバイダーのソリューション内で、
    #          現在の検出結果に関するページへのリンクURLでフィルタリングします。
    # フィルタータイプ: String Filter
    # source_url {
    #   comparison = "PREFIX"
    #   value      = "https://console.aws.amazon.com"
    # }

    # record_state (Optional)
    # 設定内容: 検出結果の更新されたレコード状態でフィルタリングします。
    # フィルタータイプ: String Filter
    # 設定可能な値: "ACTIVE", "ARCHIVED"
    # record_state {
    #   comparison = "EQUALS"
    #   value      = "ACTIVE"
    # }

    # verification_state (Optional)
    # 設定内容: 検出結果の正確性でフィルタリングします。
    # フィルタータイプ: String Filter
    # 設定可能な値: "UNKNOWN", "TRUE_POSITIVE", "FALSE_POSITIVE", "BENIGN_POSITIVE"
    # verification_state {
    #   comparison = "EQUALS"
    #   value      = "TRUE_POSITIVE"
    # }

    # workflow_status (Optional)
    # 設定内容: 検出結果に対する調査のステータスでフィルタリングします。
    # フィルタータイプ: Workflow Status Filter
    # 設定可能な値: "NEW", "NOTIFIED", "SUPPRESSED", "RESOLVED"
    # workflow_status {
    #   comparison = "EQUALS"
    #   value      = "NEW"
    # }

    #-----------------------------------------------------------
    # リソース関連フィルター
    #-----------------------------------------------------------

    # resource_id (Optional)
    # 設定内容: 指定されたリソースタイプの正規識別子でフィルタリングします。
    # フィルタータイプ: String Filter
    # EC2インスタンス関連フィルター
    #-----------------------------------------------------------

    # resource_aws_ec2_instance_iam_instance_profile_arn (Optional)
    # 設定内容: インスタンスのIAMプロファイルARNでフィルタリングします。
    # フィルタータイプ: String Filter
    # resource_aws_ec2_instance_iam_instance_profile_arn {
    #   comparison = "PREFIX"
    #   value      = "arn:aws:iam::123456789012:instance-profile/"
    # }

    # resource_aws_ec2_instance_image_id (Optional)
    # 設定内容: インスタンスのAmazon Machine Image (AMI) IDでフィルタリングします。
    # フィルタータイプ: String Filter
    # resource_aws_ec2_instance_image_id {
    #   comparison = "EQUALS"
    #   value      = "ami-0abcdef1234567890"
    # }

    # resource_aws_ec2_instance_ipv4_addresses (Optional)
    # 設定内容: インスタンスに関連付けられたIPv4アドレスでフィルタリングします。
    # フィルタータイプ: Ip Filter
    # resource_aws_ec2_instance_ipv4_addresses {
    #   cidr = "10.0.0.0/16"
    # }

    # resource_aws_ec2_instance_ipv6_addresses (Optional)
    # 設定内容: インスタンスに関連付けられたIPv6アドレスでフィルタリングします。
    # フィルタータイプ: Ip Filter
    # resource_aws_ec2_instance_ipv6_addresses {
    #   cidr = "2001:db8::/32"
    # }

    # resource_aws_ec2_instance_key_name (Optional)
    # 設定内容: インスタンスに関連付けられたキー名でフィルタリングします。
    # フィルタータイプ: String Filter
    # resource_aws_ec2_instance_key_name {
    #   comparison = "EQUALS"
    #   value      = "my-key-pair"
    # }

    # resource_aws_ec2_instance_launched_at (Optional)
    # 設定内容: インスタンスが起動された日時でフィルタリングします。
    # フィルタータイプ: Date Filter
    # resource_aws_ec2_instance_launched_at {
    #   date_range {
    #     unit  = "DAYS"
    #     value = 30
    #   }
    # }

    # resource_aws_ec2_instance_subnet_id (Optional)
    # 設定内容: インスタンスが起動されたサブネットの識別子でフィルタリングします。
    # フィルタータイプ: String Filter
    # resource_aws_ec2_instance_subnet_id {
    #   comparison = "EQUALS"
    #   value      = "subnet-12345678"
    # }

    # resource_aws_ec2_instance_type (Optional)
    # 設定内容: インスタンスのインスタンスタイプでフィルタリングします。
    # フィルタータイプ: String Filter
    # resource_aws_ec2_instance_type {
    #   comparison = "EQUALS"
    #   value      = "t3.micro"
    # }

    # resource_aws_ec2_instance_vpc_id (Optional)
    # 設定内容: インスタンスが起動されたVPCの識別子でフィルタリングします。
    # フィルタータイプ: String Filter
    # resource_aws_ec2_instance_vpc_id {
    #   comparison = "EQUALS"
    #   value      = "vpc-12345678"
    # }

    #-----------------------------------------------------------
    # IAMアクセスキー関連フィルター
    #-----------------------------------------------------------

    # resource_aws_iam_access_key_created_at (Optional)
    # 設定内容: 検出結果に関連するIAMアクセスキーの作成日時でフィルタリングします。
    # フィルタータイプ: Date Filter
    # resource_aws_iam_access_key_created_at {
    #   date_range {
    #     unit  = "DAYS"
    #     value = 90
    #   }
    # }

    # resource_aws_iam_access_key_status (Optional)
    # 設定内容: 検出結果に関連するIAMアクセスキーのステータスでフィルタリングします。
    # フィルタータイプ: String Filter
    # 設定可能な値: "Active", "Inactive"
    # resource_aws_iam_access_key_status {
    #   comparison = "EQUALS"
    #   value      = "Active"
    # }

    # resource_aws_iam_access_key_user_name (Optional)
    # 設定内容: 検出結果に関連するIAMアクセスキーに関連付けられたユーザーで
    #          フィルタリングします。
    # フィルタータイプ: String Filter
    # resource_aws_iam_access_key_user_name {
    #   comparison = "EQUALS"
    #   value      = "example-user"
    # }

    #-----------------------------------------------------------
    # S3バケット関連フィルター
    #-----------------------------------------------------------

    # resource_aws_s3_bucket_owner_id (Optional)
    # 設定内容: S3バケット所有者の正規ユーザーIDでフィルタリングします。
    # フィルタータイプ: String Filter
    # resource_aws_s3_bucket_owner_id {
    #   comparison = "EQUALS"
    #   value      = "1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef"
    # }

    # resource_aws_s3_bucket_owner_name (Optional)
    # 設定内容: S3バケット所有者の表示名でフィルタリングします。
    # フィルタータイプ: String Filter
    # resource_aws_s3_bucket_owner_name {
    #   comparison = "EQUALS"
    #   value      = "my-bucket-owner"
    # }

    #-----------------------------------------------------------
    # コンテナ関連フィルター
    #-----------------------------------------------------------

    # resource_container_name (Optional)
    # 設定内容: 検出結果に関連するコンテナの名前でフィルタリングします。
    # フィルタータイプ: String Filter
    # resource_container_name {
    #   comparison = "EQUALS"
    #   value      = "my-container"
    # }

    # resource_container_image_id (Optional)
    # 設定内容: 検出結果に関連するイメージの識別子でフィルタリングします。
    # フィルタータイプ: String Filter
    # resource_container_image_id {
    #   comparison = "PREFIX"
    #   value      = "sha256:"
    # }

    # resource_container_image_name (Optional)
    # 設定内容: 検出結果に関連するイメージの名前でフィルタリングします。
    # フィルタータイプ: String Filter
    # resource_container_image_name {
    #   comparison = "EQUALS"
    #   value      = "nginx:latest"
    # }

    # resource_container_launched_at (Optional)
    # 設定内容: コンテナが開始された日時でフィルタリングします。
    # フィルタータイプ: Date Filter
    # resource_container_launched_at {
    #   date_range {
    #     unit  = "DAYS"
    #     value = 7
    #   }
    # }

    #-----------------------------------------------------------
    # ネットワーク関連フィルター
    #-----------------------------------------------------------

    # network_direction (Optional)
    # 設定内容: 検出結果に関連するネットワークトラフィックの方向でフィルタリングします。
    # フィルタータイプ: String Filter
    # 設定可能な値: "IN", "OUT"
    # network_direction {
    #   comparison = "EQUALS"
    #   value      = "IN"
    # }

    # network_protocol (Optional)
    # 設定内容: 検出結果に関連するネットワーク情報のプロトコルでフィルタリングします。
    # フィルタータイプ: String Filter
    # 設定可能な値: "TCP", "UDP", "ICMP" など
    # network_protocol {
    #   comparison = "EQUALS"
    #   value      = "TCP"
    # }

    # network_source_ipv4 (Optional)
    # 設定内容: 検出結果に関連するネットワーク情報の送信元IPv4アドレスで
    #          フィルタリングします。
    # フィルタータイプ: Ip Filter
    # network_source_ipv4 {
    #   cidr = "192.168.1.0/24"
    # }

    # network_source_ipv6 (Optional)
    # 設定内容: 検出結果に関連するネットワーク情報の送信元IPv6アドレスで
    #          フィルタリングします。
    # フィルタータイプ: Ip Filter
    # network_source_ipv6 {
    #   cidr = "2001:db8::/32"
    # }

    # network_source_port (Optional)
    # 設定内容: 検出結果に関連するネットワーク情報の送信元ポートでフィルタリングします。
    # フィルタータイプ: Number Filter
    # network_source_port {
    #   eq = "443"
    # }

    # network_source_domain (Optional)
    # 設定内容: 検出結果に関連するネットワーク情報の送信元ドメインで
    #          フィルタリングします。
    # フィルタータイプ: String Filter
    # network_source_domain {
    #   comparison = "EQUALS"
    #   value      = "example.com"
    # }

    # network_source_mac (Optional)
    # 設定内容: 検出結果に関連するネットワーク情報の送信元メディアアクセス制御（MAC）
    #          アドレスでフィルタリングします。
    # フィルタータイプ: String Filter
    # network_source_mac {
    #   comparison = "EQUALS"
    #   value      = "00:0a:95:9d:68:16"
    # }

    # network_destination_ipv4 (Optional)
    # 設定内容: 検出結果に関連するネットワーク情報の宛先IPv4アドレスで
    #          フィルタリングします。
    # フィルタータイプ: Ip Filter
    # network_destination_ipv4 {
    #   cidr = "10.0.0.0/16"
    # }

    # network_destination_ipv6 (Optional)
    # 設定内容: 検出結果に関連するネットワーク情報の宛先IPv6アドレスで
    #          フィルタリングします。
    # フィルタータイプ: Ip Filter
    # network_destination_ipv6 {
    #   cidr = "2001:db8::/32"
    # }

    # network_destination_port (Optional)
    # 設定内容: 検出結果に関連するネットワーク情報の宛先ポートでフィルタリングします。
    # フィルタータイプ: Number Filter
    # network_destination_port {
    #   eq = "80"
    # }

    # network_destination_domain (Optional)
    # 設定内容: 検出結果に関連するネットワーク情報の宛先ドメインで
    #          フィルタリングします。
    # フィルタータイプ: String Filter
    # network_destination_domain {
    #   comparison = "EQUALS"
    #   value      = "malicious-site.com"
    # }

    #-----------------------------------------------------------
    # プロセス関連フィルター
    #-----------------------------------------------------------

    # process_name (Optional)
    # 設定内容: プロセスの名前でフィルタリングします。
    # フィルタータイプ: String Filter
    # process_name {
    #   comparison = "EQUALS"
    #   value      = "sshd"
    # }

    # process_path (Optional)
    # 設定内容: プロセス実行ファイルへのパスでフィルタリングします。
    # フィルタータイプ: String Filter
    # process_path {
    #   comparison = "EQUALS"
    #   value      = "/usr/sbin/sshd"
    # }

    # process_pid (Optional)
    # 設定内容: プロセスIDでフィルタリングします。
    # フィルタータイプ: Number Filter
    # process_pid {
    #   eq = "1234"
    # }

    # process_parent_pid (Optional)
    # 設定内容: 親プロセスIDでフィルタリングします。
    # フィルタータイプ: Number Filter
    # process_parent_pid {
    #   eq = "1"
    # }

    # process_launched_at (Optional)
    # 設定内容: プロセスが起動された日時でフィルタリングします。
    # フィルタータイプ: Date Filter
    # process_launched_at {
    #   date_range {
    #     unit  = "DAYS"
    #     value = 1
    #   }
    # }

    # process_terminated_at (Optional)
    # 設定内容: プロセスが終了した日時でフィルタリングします。
    # フィルタータイプ: Date Filter
    # process_terminated_at {
    #   date_range {
    #     unit  = "DAYS"
    #     value = 1
    #   }
    # }

    #-----------------------------------------------------------
    # マルウェア関連フィルター
    #-----------------------------------------------------------

    # malware_name (Optional)
    # 設定内容: 観察されたマルウェアの名前でフィルタリングします。
    # フィルタータイプ: String Filter
    # malware_name {
    #   comparison = "CONTAINS"
    #   value      = "trojan"
    # }

    # malware_type (Optional)
    # 設定内容: 観察されたマルウェアのタイプでフィルタリングします。
    # フィルタータイプ: String Filter
    # 設定可能な値: "ADWARE", "BLENDED_THREAT", "BOTNET_AGENT", "COIN_MINER",
    #              "EXPLOIT_KIT", "KEYLOGGER", "MACRO", "POTENTIALLY_UNWANTED",
    #              "SPYWARE", "RANSOMWARE", "REMOTE_ACCESS", "ROOTKIT", "TROJAN",
    #              "VIRUS", "WORM"
    # malware_type {
    #   comparison = "EQUALS"
    #   value      = "TROJAN"
    # }

    # malware_path (Optional)
    # 設定内容: 観察されたマルウェアのファイルシステムパスでフィルタリングします。
    # フィルタータイプ: String Filter
    # malware_path {
    #   comparison = "CONTAINS"
    #   value      = "/tmp/"
    # }

    # malware_state (Optional)
    # 設定内容: 観察されたマルウェアの状態でフィルタリングします。
    # フィルタータイプ: String Filter
    # 設定可能な値: "OBSERVED", "REMOVAL_FAILED", "REMOVED"
    # malware_state {
    #   comparison = "EQUALS"
    #   value      = "OBSERVED"
    # }

    #-----------------------------------------------------------
    # 脅威インテリジェンス関連フィルター
    #-----------------------------------------------------------

    # threat_intel_indicator_type (Optional)
    # 設定内容: 脅威インテリジェンスインジケーターのタイプでフィルタリングします。
    # フィルタータイプ: String Filter
    # 設定可能な値: "DOMAIN", "EMAIL_ADDRESS", "HASH_MD5", "HASH_SHA1", "HASH_SHA256",
    #              "HASH_SHA512", "IPV4_ADDRESS", "IPV6_ADDRESS", "MUTEX", "PROCESS", "URL"
    # threat_intel_indicator_type {
    #   comparison = "EQUALS"
    #   value      = "IPV4_ADDRESS"
    # }

    # threat_intel_indicator_value (Optional)
    # 設定内容: 脅威インテリジェンスインジケーターの値でフィルタリングします。
    # フィルタータイプ: String Filter
    # threat_intel_indicator_value {
    #   comparison = "EQUALS"
    #   value      = "192.0.2.1"
    # }

    # threat_intel_indicator_category (Optional)
    # 設定内容: 脅威インテリジェンスインジケーターのカテゴリでフィルタリングします。
    # フィルタータイプ: String Filter
    # 設定可能な値: "BACKDOOR", "CARD_STEALER", "COMMAND_AND_CONTROL", "DROP_SITE",
    #              "EXPLOIT_SITE", "KEYLOGGER"
    # threat_intel_indicator_category {
    #   comparison = "EQUALS"
    #   value      = "COMMAND_AND_CONTROL"
    # }

    # threat_intel_indicator_last_observed_at (Optional)
    # 設定内容: 脅威インテリジェンスインジケーターの最後の観察日時で
    #          フィルタリングします。
    # フィルタータイプ: Date Filter
    # threat_intel_indicator_last_observed_at {
    #   date_range {
    #     unit  = "DAYS"
    #     value = 30
    #   }
    # }

    # threat_intel_indicator_source (Optional)
    # 設定内容: 脅威インテリジェンスの送信元でフィルタリングします。
    # フィルタータイプ: String Filter
    # threat_intel_indicator_source {
    #   comparison = "EQUALS"
    #   value      = "AWS"
    # }

    # threat_intel_indicator_source_url (Optional)
    # 設定内容: 脅威インテリジェンスの送信元からの詳細情報へのURLで
    #          フィルタリングします。
    # フィルタータイプ: String Filter
    # threat_intel_indicator_source_url {
    #   comparison = "PREFIX"
    #   value      = "https://threat-intel.example.com"
    # }

    #-----------------------------------------------------------
    # ノート関連フィルター
    #-----------------------------------------------------------

    # note_text (Optional)
    # 設定内容: ノートのテキストでフィルタリングします。
    # フィルタータイプ: String Filter
    # note_text {
    #   comparison = "CONTAINS"
    #   value      = "investigated"
    # }

    # note_updated_at (Optional)
    # 設定内容: ノートが更新されたタイムスタンプでフィルタリングします。
    # フィルタータイプ: Date Filter
    # note_updated_at {
    #   date_range {
    #     unit  = "DAYS"
    #     value = 7
    #   }
    # }

    # note_updated_by (Optional)
    # 設定内容: ノートを作成したプリンシパルでフィルタリングします。
    # フィルタータイプ: String Filter
    # note_updated_by {
    #   comparison = "EQUALS"
    #   value      = "arn:aws:iam::123456789012:user/security-analyst"
    # }

    #-----------------------------------------------------------
    # レコメンデーション関連フィルター
    #-----------------------------------------------------------

    # recommendation_text (Optional)
    # 設定内容: 検出結果で説明されている問題について何をすべきかの
    #          レコメンデーションでフィルタリングします。
    # フィルタータイプ: String Filter
    # recommendation_text {
    #   comparison = "CONTAINS"
    #   value      = "enable encryption"
    # }

    #-----------------------------------------------------------
    # 関連検出結果フィルター
    #-----------------------------------------------------------

    # related_findings_product_arn (Optional)
    # 設定内容: 関連検出結果を生成したソリューションのARNでフィルタリングします。
    # フィルタータイプ: String Filter
    # related_findings_product_arn {
    #   comparison = "PREFIX"
    #   value      = "arn:aws:securityhub"
    # }

    # related_findings_id (Optional)
    # 設定内容: 関連検出結果のソリューション生成識別子でフィルタリングします。
    # フィルタータイプ: String Filter
    # related_findings_id {
    #   comparison = "EQUALS"
    #   value      = "example-finding-id"
    # }

    #-----------------------------------------------------------
    # カスタムフィールドフィルター
    #-----------------------------------------------------------

    # product_fields (Optional)
    # 設定内容: セキュリティ検出結果プロバイダーが定義されたAwsSecurityFinding
    #          フォーマットに含まれない追加のソリューション固有の詳細を含めることが
    #          できるデータ型でフィルタリングします。
    # フィルタータイプ: Map Filter
    # product_fields {
    #   comparison = "EQUALS"
    #   key        = "aws/guardduty/service/action/networkConnectionAction/blocked"
    #   value      = "true"
    # }

    # user_defined_values (Optional)
    # 設定内容: 検出結果に関連付けられた名前/値文字列ペアのリストで
    #          フィルタリングします。これらはカスタムのユーザー定義フィールドです。
    # フィルタータイプ: Map Filter
    # user_defined_values {
    #   comparison = "EQUALS"
    #   key        = "team"
    #   value      = "security"
    # }

    # keyword (Optional)
    # 設定内容: 検出結果のキーワードでフィルタリングします。
    # フィルタータイプ: Keyword Filter
    # keyword {
    #   value = "encryption"
    # }
  }

  #-------------------------------------------------------------
  # 依存関係
  #-------------------------------------------------------------

  # depends_on (Optional)
  # 設定内容: このリソースが依存する他のリソースを指定します。
  # 注意: Security Hubアカウントが有効になっている必要があります
# Date Filter サブブロック構成例
#---------------------------------------------------------------
# Date Filterには2つの指定方法があります:
#
# 1. date_range を使用する方法:
#    created_at {
#      date_range {
#        unit  = "DAYS"  # 必須: 日付範囲の単位（現在は "DAYS" のみサポート）
#        value = 30      # 必須: 日付範囲の値（整数）
#      }
#    }
#
# 2. start と end を使用する方法:
#    created_at {
#      start = "2024-01-01T00:00:00Z"  # 省略可能: 開始日時（ISO8601形式）
#      end   = "2024-12-31T23:59:59Z"  # 省略可能: 終了日時（ISO8601形式）
#    }
#
# 注意: date_range を指定しない場合は、start と end の両方が必須です

#---------------------------------------------------------------
# String Filter の comparison オプション
#---------------------------------------------------------------
# String Filterで使用可能な comparison 値:
#   - "EQUALS": 完全一致
#   - "NOT_EQUALS": 完全不一致
#   - "PREFIX": 前方一致
#   - "PREFIX_NOT_EQUALS": 前方不一致
#   - "CONTAINS": 部分一致
#   - "NOT_CONTAINS": 部分不一致

#---------------------------------------------------------------
# Number Filter の条件オプション
#---------------------------------------------------------------
# Number Filterで使用可能な条件:
#   - eq: 等しい（文字列として指定）
#   - gte: 以上（文字列として指定）
#   - lte: 以下（文字列として指定）
# 注意: 少なくとも1つの条件を指定する必要があります

#---------------------------------------------------------------
# Map Filter 構成
#---------------------------------------------------------------
# Map Filterには3つの必須フィールドがあります:
#   - comparison: 比較演算子（"EQUALS" または "NOT_EQUALS"）
#   - key: マップフィルターのキー
#         （ResourceTagsの場合はタグ名、UserDefinedFieldsの場合はフィールド名）
#   - value: キーに対する値（大文字小文字を区別します）

#---------------------------------------------------------------
# Ip Filter 構成
#---------------------------------------------------------------
# Ip Filterには1つの必須フィールドがあります:
#   - cidr: 検出結果のCIDR値（例: "10.0.0.0/16", "192.168.1.0/24"）

#---------------------------------------------------------------
# Keyword Filter 構成
#---------------------------------------------------------------
# Keyword Filterには1つの必須フィールドがあります:
#   - value: キーワードの値

#---------------------------------------------------------------
# Workflow Status Filter 構成
#---------------------------------------------------------------
# Workflow Status Filterには2つの必須フィールドがあります:
#   - comparison: 比較演算子（String Filterと同じオプション）
#   - value: ワークフローステータスの値
#            有効な値: "NEW", "NOTIFIED", "SUPPRESSED", "RESOLVED"

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: インサイトのARN
#
# - arn: インサイトのARN
#---------------------------------------------------------------
