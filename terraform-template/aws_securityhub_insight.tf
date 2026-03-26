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
# Provider Version: 6.38.0
# Generated: 2026-03-26
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
  name = "example-insight"

  # group_by_attribute (Required)
  # 設定内容: 検出結果をグループ化するために使用する属性を指定します。
  #          インサイトは、この属性に基づいて検出結果のリストを生成します。
  # 設定可能な値: Security Hubの検出結果フィールド名
  #   - 一般的な例: "ResourceId", "AwsAccountId", "SeverityLabel", "ComplianceStatus",
  #                  "ProductName", "ResourceType", "CreatedAt", "Confidence" など
  group_by_attribute = "ResourceId"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  region = null

  #-------------------------------------------------------------
  # フィルター設定
  #-------------------------------------------------------------

  # filters (Required, max: 1)
  # 設定内容: インサイトに含める検出結果をフィルタリングするための設定ブロックです。
  #          複数のフィルター属性を組み合わせて使用できます。
  #          フィルター基準に一致する検出結果のみがインサイトに含まれます。
  filters {
    #-----------------------------------------------------------
    # アカウント・組織関連フィルター
    #-----------------------------------------------------------

    # aws_account_id (Optional, max: 20)
    # 設定内容: 検出結果が生成されたAWSアカウントIDでフィルタリングします。
    # フィルタータイプ: String Filter
    # aws_account_id {
    #   comparison = "EQUALS"
    #   value      = "123456789012"
    # }

    # aws_account_name (Optional, max: 20)
    # 設定内容: 検出結果が生成されたAWSアカウント名でフィルタリングします。
    # フィルタータイプ: String Filter
    # aws_account_name {
    #   comparison = "EQUALS"
    #   value      = "my-account"
    # }

    #-----------------------------------------------------------
    # 製品・プロバイダー関連フィルター
    #-----------------------------------------------------------

    # company_name (Optional, max: 20)
    # 設定内容: 検出結果を生成したソリューション（製品）を所有する会社名でフィルタリングします。
    # フィルタータイプ: String Filter
    # company_name {
    #   comparison = "EQUALS"
    #   value      = "AWS"
    # }

    # product_arn (Optional, max: 20)
    # 設定内容: 検出結果を生成したサードパーティ製品のARNでフィルタリングします。
    # フィルタータイプ: String Filter
    # product_arn {
    #   comparison = "PREFIX"
    #   value      = "arn:aws:securityhub"
    # }

    # product_name (Optional, max: 20)
    # 設定内容: 検出結果を生成した製品名でフィルタリングします。
    # フィルタータイプ: String Filter
    # product_name {
    #   comparison = "EQUALS"
    #   value      = "GuardDuty"
    # }

    # product_fields (Optional, max: 20)
    # 設定内容: セキュリティ検出結果プロバイダーが定義したソリューション固有の
    #          追加詳細フィールドでフィルタリングします。
    # フィルタータイプ: Map Filter
    # product_fields {
    #   comparison = "EQUALS"
    #   key        = "aws/guardduty/service/action/networkConnectionAction/blocked"
    #   value      = "true"
    # }

    #-----------------------------------------------------------
    # コンプライアンス関連フィルター
    #-----------------------------------------------------------

    # compliance_status (Optional, max: 20)
    # 設定内容: コンプライアンスチェックの結果ステータスでフィルタリングします。
    # フィルタータイプ: String Filter
    # 設定可能な値: "PASSED", "WARNING", "FAILED", "NOT_AVAILABLE"
    # compliance_status {
    #   comparison = "EQUALS"
    #   value      = "FAILED"
    # }

    # compliance_associated_standards_id (Optional, max: 20)
    # 設定内容: 検出結果に関連付けられたセキュリティ標準のIDでフィルタリングします。
    # フィルタータイプ: String Filter
    # compliance_associated_standards_id {
    #   comparison = "PREFIX"
    #   value      = "standards/aws-foundational-security-best-practices"
    # }

    # compliance_security_control_id (Optional, max: 20)
    # 設定内容: コンプライアンスチェックのセキュリティコントロールIDでフィルタリングします。
    # フィルタータイプ: String Filter
    # compliance_security_control_id {
    #   comparison = "EQUALS"
    #   value      = "S3.1"
    # }

    # compliance_security_control_parameters_name (Optional, max: 20)
    # 設定内容: セキュリティコントロールのパラメータ名でフィルタリングします。
    # フィルタータイプ: String Filter
    # compliance_security_control_parameters_name {
    #   comparison = "EQUALS"
    #   value      = "maxCredentialUsageAge"
    # }

    # compliance_security_control_parameters_value (Optional, max: 20)
    # 設定内容: セキュリティコントロールのパラメータ値でフィルタリングします。
    # フィルタータイプ: String Filter
    # compliance_security_control_parameters_value {
    #   comparison = "EQUALS"
    #   value      = "90"
    # }

    #-----------------------------------------------------------
    # 重要度・信頼度関連フィルター
    #-----------------------------------------------------------

    # severity_label (Optional, max: 20)
    # 設定内容: 検出結果の重要度ラベルでフィルタリングします。
    # フィルタータイプ: String Filter
    # 設定可能な値: "INFORMATIONAL", "LOW", "MEDIUM", "HIGH", "CRITICAL"
    # severity_label {
    #   comparison = "EQUALS"
    #   value      = "HIGH"
    # }

    # confidence (Optional, max: 20)
    # 設定内容: 検出結果の信頼度スコアでフィルタリングします。
    # フィルタータイプ: Number Filter
    # confidence {
    #   gte = "80"
    # }

    # criticality (Optional, max: 20)
    # 設定内容: 検出結果に関連するリソースの重要度レベルでフィルタリングします。
    # フィルタータイプ: Number Filter
    # criticality {
    #   gte = "80"
    # }

    #-----------------------------------------------------------
    # Finding Provider Fields フィルター
    #-----------------------------------------------------------
    # 検出結果プロバイダーが提供する元の値でフィルタリングします

    # finding_provider_fields_confidence (Optional, max: 20)
    # 設定内容: 検出結果プロバイダーが提供する信頼度の値でフィルタリングします。
    # フィルタータイプ: Number Filter
    # finding_provider_fields_confidence {
    #   gte = "80"
    # }

    # finding_provider_fields_criticality (Optional, max: 20)
    # 設定内容: 検出結果プロバイダーが提供する重要度レベルでフィルタリングします。
    # フィルタータイプ: Number Filter
    # finding_provider_fields_criticality {
    #   gte = "80"
    # }

    # finding_provider_fields_severity_label (Optional, max: 20)
    # 設定内容: 検出結果プロバイダーが提供する重要度ラベルでフィルタリングします。
    # フィルタータイプ: String Filter
    # finding_provider_fields_severity_label {
    #   comparison = "EQUALS"
    #   value      = "HIGH"
    # }

    # finding_provider_fields_severity_original (Optional, max: 20)
    # 設定内容: 検出結果プロバイダーの重要度の元の値でフィルタリングします。
    # フィルタータイプ: String Filter
    # finding_provider_fields_severity_original {
    #   comparison = "EQUALS"
    #   value      = "HIGH"
    # }

    # finding_provider_fields_types (Optional, max: 20)
    # 設定内容: 検出結果プロバイダーが割り当てた検出結果タイプでフィルタリングします。
    # フィルタータイプ: String Filter
    # finding_provider_fields_types {
    #   comparison = "PREFIX"
    #   value      = "Software and Configuration Checks"
    # }

    # finding_provider_fields_related_findings_id (Optional, max: 20)
    # 設定内容: 検出結果プロバイダーが特定した関連検出結果の識別子でフィルタリングします。
    # フィルタータイプ: String Filter
    # finding_provider_fields_related_findings_id {
    #   comparison = "EQUALS"
    #   value      = "example-finding-id"
    # }

    # finding_provider_fields_related_findings_product_arn (Optional, max: 20)
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

    # created_at (Optional, max: 20)
    # 設定内容: セキュリティ検出結果プロバイダーが潜在的なセキュリティ問題を
    #          キャプチャした日時でフィルタリングします。
    # フィルタータイプ: Date Filter
    # created_at {
    #   date_range {
    #     unit  = "DAYS"
    #     value = 30
    #   }
    # }

    # updated_at (Optional, max: 20)
    # 設定内容: 検出結果プロバイダーが検出結果レコードを最後に更新した日時で
    #          フィルタリングします。
    # フィルタータイプ: Date Filter
    # updated_at {
    #   date_range {
    #     unit  = "DAYS"
    #     value = 7
    #   }
    # }

    # first_observed_at (Optional, max: 20)
    # 設定内容: 検出結果で説明されている潜在的なセキュリティ問題が最初に
    #          観察された日時でフィルタリングします。
    # フィルタータイプ: Date Filter
    # first_observed_at {
    #   date_range {
    #     unit  = "DAYS"
    #     value = 30
    #   }
    # }

    # last_observed_at (Optional, max: 20)
    # 設定内容: 検出結果で説明されている潜在的なセキュリティ問題が最後に
    #          観察された日時でフィルタリングします。
    # フィルタータイプ: Date Filter
    # last_observed_at {
    #   date_range {
    #     unit  = "DAYS"
    #     value = 7
    #   }
    # }

    #-----------------------------------------------------------
    # 検出結果メタデータフィルター
    #-----------------------------------------------------------

    # id (Optional, max: 20)
    # 設定内容: セキュリティ検出結果プロバイダー固有の検出結果識別子でフィルタリングします。
    # フィルタータイプ: String Filter
    # id {
    #   comparison = "PREFIX"
    #   value      = "arn:aws:securityhub"
    # }

    # generator_id (Optional, max: 20)
    # 設定内容: 検出結果を生成したソリューション固有のコンポーネントの
    #          識別子でフィルタリングします。
    # フィルタータイプ: String Filter
    # generator_id {
    #   comparison = "PREFIX"
    #   value      = "aws-foundational-security-best-practices"
    # }

    # type (Optional, max: 20)
    # 設定内容: 検出結果を分類する検出結果タイプでフィルタリングします。
    # フィルタータイプ: String Filter
    # type {
    #   comparison = "PREFIX"
    #   value      = "Software and Configuration Checks"
    # }

    # title (Optional, max: 20)
    # 設定内容: 検出結果のタイトルでフィルタリングします。
    # フィルタータイプ: String Filter
    # title {
    #   comparison = "CONTAINS"
    #   value      = "S3 bucket"
    # }

    # description (Optional, max: 20)
    # 設定内容: 検出結果の説明でフィルタリングします。
    # フィルタータイプ: String Filter
    # description {
    #   comparison = "CONTAINS"
    #   value      = "encryption"
    # }

    # source_url (Optional, max: 20)
    # 設定内容: セキュリティ検出結果プロバイダーのソリューション内で、
    #          現在の検出結果に関するページへのリンクURLでフィルタリングします。
    # フィルタータイプ: String Filter
    # source_url {
    #   comparison = "PREFIX"
    #   value      = "https://console.aws.amazon.com"
    # }

    # record_state (Optional, max: 20)
    # 設定内容: 検出結果の更新されたレコード状態でフィルタリングします。
    # フィルタータイプ: String Filter
    # 設定可能な値: "ACTIVE", "ARCHIVED"
    # record_state {
    #   comparison = "EQUALS"
    #   value      = "ACTIVE"
    # }

    # verification_state (Optional, max: 20)
    # 設定内容: 検出結果の正確性の検証ステータスでフィルタリングします。
    # フィルタータイプ: String Filter
    # 設定可能な値: "UNKNOWN", "TRUE_POSITIVE", "FALSE_POSITIVE", "BENIGN_POSITIVE"
    # verification_state {
    #   comparison = "EQUALS"
    #   value      = "TRUE_POSITIVE"
    # }

    # workflow_status (Optional, max: 20)
    # 設定内容: 検出結果に対する調査のステータスでフィルタリングします。
    # フィルタータイプ: String Filter
    # 設定可能な値: "NEW", "NOTIFIED", "SUPPRESSED", "RESOLVED"
    # workflow_status {
    #   comparison = "EQUALS"
    #   value      = "NEW"
    # }

    #-----------------------------------------------------------
    # リソース関連フィルター
    #-----------------------------------------------------------

    # resource_id (Optional, max: 20)
    # 設定内容: 指定されたリソースタイプの正規識別子でフィルタリングします。
    # フィルタータイプ: String Filter
    # resource_id {
    #   comparison = "PREFIX"
    #   value      = "arn:aws:"
    # }

    # resource_type (Optional, max: 20)
    # 設定内容: 検出結果に関連するリソースタイプでフィルタリングします。
    # フィルタータイプ: String Filter
    # resource_type {
    #   comparison = "EQUALS"
    #   value      = "AwsS3Bucket"
    # }

    # resource_region (Optional, max: 20)
    # 設定内容: 検出結果に関連するリソースのリージョンでフィルタリングします。
    # フィルタータイプ: String Filter
    # resource_region {
    #   comparison = "EQUALS"
    #   value      = "ap-northeast-1"
    # }

    # resource_partition (Optional, max: 20)
    # 設定内容: 検出結果に関連するリソースのAWSパーティションでフィルタリングします。
    # フィルタータイプ: String Filter
    # 設定可能な値: "aws", "aws-cn", "aws-us-gov"
    # resource_partition {
    #   comparison = "EQUALS"
    #   value      = "aws"
    # }

    # resource_tags (Optional, max: 20)
    # 設定内容: 検出結果に関連するリソースのタグでフィルタリングします。
    # フィルタータイプ: Map Filter
    # resource_tags {
    #   comparison = "EQUALS"
    #   key        = "Environment"
    #   value      = "Production"
    # }

    # resource_details_other (Optional, max: 20)
    # 設定内容: 既存の特定リソースフィールドに含まれないリソース詳細の
    #          追加情報でフィルタリングします。
    # フィルタータイプ: Map Filter
    # resource_details_other {
    #   comparison = "EQUALS"
    #   key        = "ExampleKey"
    #   value      = "ExampleValue"
    # }

    #-----------------------------------------------------------
    # EC2インスタンス関連フィルター
    #-----------------------------------------------------------

    # resource_aws_ec2_instance_iam_instance_profile_arn (Optional, max: 20)
    # 設定内容: インスタンスのIAMプロファイルARNでフィルタリングします。
    # フィルタータイプ: String Filter
    # resource_aws_ec2_instance_iam_instance_profile_arn {
    #   comparison = "PREFIX"
    #   value      = "arn:aws:iam::123456789012:instance-profile/"
    # }

    # resource_aws_ec2_instance_image_id (Optional, max: 20)
    # 設定内容: インスタンスのAmazon Machine Image (AMI) IDでフィルタリングします。
    # フィルタータイプ: String Filter
    # resource_aws_ec2_instance_image_id {
    #   comparison = "EQUALS"
    #   value      = "ami-0abcdef1234567890"
    # }

    # resource_aws_ec2_instance_ipv4_addresses (Optional, max: 20)
    # 設定内容: インスタンスに関連付けられたIPv4アドレスでフィルタリングします。
    # フィルタータイプ: Ip Filter
    # resource_aws_ec2_instance_ipv4_addresses {
    #   cidr = "10.0.0.0/16"
    # }

    # resource_aws_ec2_instance_ipv6_addresses (Optional, max: 20)
    # 設定内容: インスタンスに関連付けられたIPv6アドレスでフィルタリングします。
    # フィルタータイプ: Ip Filter
    # resource_aws_ec2_instance_ipv6_addresses {
    #   cidr = "2001:db8::/32"
    # }

    # resource_aws_ec2_instance_key_name (Optional, max: 20)
    # 設定内容: インスタンスに関連付けられたキー名でフィルタリングします。
    # フィルタータイプ: String Filter
    # resource_aws_ec2_instance_key_name {
    #   comparison = "EQUALS"
    #   value      = "my-key-pair"
    # }

    # resource_aws_ec2_instance_launched_at (Optional, max: 20)
    # 設定内容: インスタンスが起動された日時でフィルタリングします。
    # フィルタータイプ: Date Filter
    # resource_aws_ec2_instance_launched_at {
    #   date_range {
    #     unit  = "DAYS"
    #     value = 30
    #   }
    # }

    # resource_aws_ec2_instance_subnet_id (Optional, max: 20)
    # 設定内容: インスタンスが起動されたサブネットの識別子でフィルタリングします。
    # フィルタータイプ: String Filter
    # resource_aws_ec2_instance_subnet_id {
    #   comparison = "EQUALS"
    #   value      = "subnet-12345678"
    # }

    # resource_aws_ec2_instance_type (Optional, max: 20)
    # 設定内容: インスタンスのインスタンスタイプでフィルタリングします。
    # フィルタータイプ: String Filter
    # resource_aws_ec2_instance_type {
    #   comparison = "EQUALS"
    #   value      = "t3.micro"
    # }

    # resource_aws_ec2_instance_vpc_id (Optional, max: 20)
    # 設定内容: インスタンスが起動されたVPCの識別子でフィルタリングします。
    # フィルタータイプ: String Filter
    # resource_aws_ec2_instance_vpc_id {
    #   comparison = "EQUALS"
    #   value      = "vpc-12345678"
    # }

    #-----------------------------------------------------------
    # IAMアクセスキー関連フィルター
    #-----------------------------------------------------------

    # resource_aws_iam_access_key_created_at (Optional, max: 20)
    # 設定内容: 検出結果に関連するIAMアクセスキーの作成日時でフィルタリングします。
    # フィルタータイプ: Date Filter
    # resource_aws_iam_access_key_created_at {
    #   date_range {
    #     unit  = "DAYS"
    #     value = 90
    #   }
    # }

    # resource_aws_iam_access_key_status (Optional, max: 20)
    # 設定内容: 検出結果に関連するIAMアクセスキーのステータスでフィルタリングします。
    # フィルタータイプ: String Filter
    # 設定可能な値: "Active", "Inactive"
    # resource_aws_iam_access_key_status {
    #   comparison = "EQUALS"
    #   value      = "Active"
    # }

    # resource_aws_iam_access_key_user_name (Optional, max: 20)
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

    # resource_aws_s3_bucket_owner_id (Optional, max: 20)
    # 設定内容: S3バケット所有者の正規ユーザーIDでフィルタリングします。
    # フィルタータイプ: String Filter
    # resource_aws_s3_bucket_owner_id {
    #   comparison = "EQUALS"
    #   value      = "1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef"
    # }

    # resource_aws_s3_bucket_owner_name (Optional, max: 20)
    # 設定内容: S3バケット所有者の表示名でフィルタリングします。
    # フィルタータイプ: String Filter
    # resource_aws_s3_bucket_owner_name {
    #   comparison = "EQUALS"
    #   value      = "my-bucket-owner"
    # }

    #-----------------------------------------------------------
    # コンテナ関連フィルター
    #-----------------------------------------------------------

    # resource_container_name (Optional, max: 20)
    # 設定内容: 検出結果に関連するコンテナの名前でフィルタリングします。
    # フィルタータイプ: String Filter
    # resource_container_name {
    #   comparison = "EQUALS"
    #   value      = "my-container"
    # }

    # resource_container_image_id (Optional, max: 20)
    # 設定内容: 検出結果に関連するイメージの識別子でフィルタリングします。
    # フィルタータイプ: String Filter
    # resource_container_image_id {
    #   comparison = "PREFIX"
    #   value      = "sha256:"
    # }

    # resource_container_image_name (Optional, max: 20)
    # 設定内容: 検出結果に関連するイメージの名前でフィルタリングします。
    # フィルタータイプ: String Filter
    # resource_container_image_name {
    #   comparison = "EQUALS"
    #   value      = "nginx:latest"
    # }

    # resource_container_launched_at (Optional, max: 20)
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

    # network_direction (Optional, max: 20)
    # 設定内容: 検出結果に関連するネットワークトラフィックの方向でフィルタリングします。
    # フィルタータイプ: String Filter
    # 設定可能な値: "IN", "OUT"
    # network_direction {
    #   comparison = "EQUALS"
    #   value      = "IN"
    # }

    # network_protocol (Optional, max: 20)
    # 設定内容: 検出結果に関連するネットワーク情報のプロトコルでフィルタリングします。
    # フィルタータイプ: String Filter
    # 設定可能な値: "TCP", "UDP", "ICMP" など
    # network_protocol {
    #   comparison = "EQUALS"
    #   value      = "TCP"
    # }

    # network_source_ipv4 (Optional, max: 20)
    # 設定内容: 検出結果に関連するネットワーク情報の送信元IPv4アドレスで
    #          フィルタリングします。
    # フィルタータイプ: Ip Filter
    # network_source_ipv4 {
    #   cidr = "192.168.1.0/24"
    # }

    # network_source_ipv6 (Optional, max: 20)
    # 設定内容: 検出結果に関連するネットワーク情報の送信元IPv6アドレスで
    #          フィルタリングします。
    # フィルタータイプ: Ip Filter
    # network_source_ipv6 {
    #   cidr = "2001:db8::/32"
    # }

    # network_source_port (Optional, max: 20)
    # 設定内容: 検出結果に関連するネットワーク情報の送信元ポートでフィルタリングします。
    # フィルタータイプ: Number Filter
    # network_source_port {
    #   eq = "443"
    # }

    # network_source_domain (Optional, max: 20)
    # 設定内容: 検出結果に関連するネットワーク情報の送信元ドメインで
    #          フィルタリングします。
    # フィルタータイプ: String Filter
    # network_source_domain {
    #   comparison = "EQUALS"
    #   value      = "example.com"
    # }

    # network_source_mac (Optional, max: 20)
    # 設定内容: 検出結果に関連するネットワーク情報の送信元MACアドレスで
    #          フィルタリングします。
    # フィルタータイプ: String Filter
    # network_source_mac {
    #   comparison = "EQUALS"
    #   value      = "00:0a:95:9d:68:16"
    # }

    # network_destination_ipv4 (Optional, max: 20)
    # 設定内容: 検出結果に関連するネットワーク情報の宛先IPv4アドレスで
    #          フィルタリングします。
    # フィルタータイプ: Ip Filter
    # network_destination_ipv4 {
    #   cidr = "10.0.0.0/16"
    # }

    # network_destination_ipv6 (Optional, max: 20)
    # 設定内容: 検出結果に関連するネットワーク情報の宛先IPv6アドレスで
    #          フィルタリングします。
    # フィルタータイプ: Ip Filter
    # network_destination_ipv6 {
    #   cidr = "2001:db8::/32"
    # }

    # network_destination_port (Optional, max: 20)
    # 設定内容: 検出結果に関連するネットワーク情報の宛先ポートでフィルタリングします。
    # フィルタータイプ: Number Filter
    # network_destination_port {
    #   eq = "80"
    # }

    # network_destination_domain (Optional, max: 20)
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

    # process_name (Optional, max: 20)
    # 設定内容: プロセスの名前でフィルタリングします。
    # フィルタータイプ: String Filter
    # process_name {
    #   comparison = "EQUALS"
    #   value      = "sshd"
    # }

    # process_path (Optional, max: 20)
    # 設定内容: プロセス実行ファイルへのパスでフィルタリングします。
    # フィルタータイプ: String Filter
    # process_path {
    #   comparison = "EQUALS"
    #   value      = "/usr/sbin/sshd"
    # }

    # process_pid (Optional, max: 20)
    # 設定内容: プロセスIDでフィルタリングします。
    # フィルタータイプ: Number Filter
    # process_pid {
    #   eq = "1234"
    # }

    # process_parent_pid (Optional, max: 20)
    # 設定内容: 親プロセスIDでフィルタリングします。
    # フィルタータイプ: Number Filter
    # process_parent_pid {
    #   eq = "1"
    # }

    # process_launched_at (Optional, max: 20)
    # 設定内容: プロセスが起動された日時でフィルタリングします。
    # フィルタータイプ: Date Filter
    # process_launched_at {
    #   date_range {
    #     unit  = "DAYS"
    #     value = 1
    #   }
    # }

    # process_terminated_at (Optional, max: 20)
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

    # malware_name (Optional, max: 20)
    # 設定内容: 観察されたマルウェアの名前でフィルタリングします。
    # フィルタータイプ: String Filter
    # malware_name {
    #   comparison = "CONTAINS"
    #   value      = "trojan"
    # }

    # malware_type (Optional, max: 20)
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

    # malware_path (Optional, max: 20)
    # 設定内容: 観察されたマルウェアのファイルシステムパスでフィルタリングします。
    # フィルタータイプ: String Filter
    # malware_path {
    #   comparison = "CONTAINS"
    #   value      = "/tmp/"
    # }

    # malware_state (Optional, max: 20)
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

    # threat_intel_indicator_type (Optional, max: 20)
    # 設定内容: 脅威インテリジェンスインジケーターのタイプでフィルタリングします。
    # フィルタータイプ: String Filter
    # 設定可能な値: "DOMAIN", "EMAIL_ADDRESS", "HASH_MD5", "HASH_SHA1", "HASH_SHA256",
    #              "HASH_SHA512", "IPV4_ADDRESS", "IPV6_ADDRESS", "MUTEX", "PROCESS", "URL"
    # threat_intel_indicator_type {
    #   comparison = "EQUALS"
    #   value      = "IPV4_ADDRESS"
    # }

    # threat_intel_indicator_value (Optional, max: 20)
    # 設定内容: 脅威インテリジェンスインジケーターの値でフィルタリングします。
    # フィルタータイプ: String Filter
    # threat_intel_indicator_value {
    #   comparison = "EQUALS"
    #   value      = "192.0.2.1"
    # }

    # threat_intel_indicator_category (Optional, max: 20)
    # 設定内容: 脅威インテリジェンスインジケーターのカテゴリでフィルタリングします。
    # フィルタータイプ: String Filter
    # 設定可能な値: "BACKDOOR", "CARD_STEALER", "COMMAND_AND_CONTROL", "DROP_SITE",
    #              "EXPLOIT_SITE", "KEYLOGGER"
    # threat_intel_indicator_category {
    #   comparison = "EQUALS"
    #   value      = "COMMAND_AND_CONTROL"
    # }

    # threat_intel_indicator_last_observed_at (Optional, max: 20)
    # 設定内容: 脅威インテリジェンスインジケーターの最後の観察日時で
    #          フィルタリングします。
    # フィルタータイプ: Date Filter
    # threat_intel_indicator_last_observed_at {
    #   date_range {
    #     unit  = "DAYS"
    #     value = 30
    #   }
    # }

    # threat_intel_indicator_source (Optional, max: 20)
    # 設定内容: 脅威インテリジェンスの送信元でフィルタリングします。
    # フィルタータイプ: String Filter
    # threat_intel_indicator_source {
    #   comparison = "EQUALS"
    #   value      = "AWS"
    # }

    # threat_intel_indicator_source_url (Optional, max: 20)
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

    # note_text (Optional, max: 20)
    # 設定内容: ノートのテキストでフィルタリングします。
    # フィルタータイプ: String Filter
    # note_text {
    #   comparison = "CONTAINS"
    #   value      = "investigated"
    # }

    # note_updated_at (Optional, max: 20)
    # 設定内容: ノートが更新されたタイムスタンプでフィルタリングします。
    # フィルタータイプ: Date Filter
    # note_updated_at {
    #   date_range {
    #     unit  = "DAYS"
    #     value = 7
    #   }
    # }

    # note_updated_by (Optional, max: 20)
    # 設定内容: ノートを作成したプリンシパルでフィルタリングします。
    # フィルタータイプ: String Filter
    # note_updated_by {
    #   comparison = "EQUALS"
    #   value      = "arn:aws:iam::123456789012:user/security-analyst"
    # }

    #-----------------------------------------------------------
    # レコメンデーション・関連検出結果フィルター
    #-----------------------------------------------------------

    # recommendation_text (Optional, max: 20)
    # 設定内容: 検出結果で説明されている問題について何をすべきかの
    #          レコメンデーションでフィルタリングします。
    # フィルタータイプ: String Filter
    # recommendation_text {
    #   comparison = "CONTAINS"
    #   value      = "enable encryption"
    # }

    # related_findings_product_arn (Optional, max: 20)
    # 設定内容: 関連検出結果を生成したソリューションのARNでフィルタリングします。
    # フィルタータイプ: String Filter
    # related_findings_product_arn {
    #   comparison = "PREFIX"
    #   value      = "arn:aws:securityhub"
    # }

    # related_findings_id (Optional, max: 20)
    # 設定内容: 関連検出結果のソリューション生成識別子でフィルタリングします。
    # フィルタータイプ: String Filter
    # related_findings_id {
    #   comparison = "EQUALS"
    #   value      = "example-finding-id"
    # }

    #-----------------------------------------------------------
    # カスタムフィールド・キーワードフィルター
    #-----------------------------------------------------------

    # user_defined_values (Optional, max: 20)
    # 設定内容: 検出結果に関連付けられた名前/値文字列ペアのリストで
    #          フィルタリングします。
    # フィルタータイプ: Map Filter
    # user_defined_values {
    #   comparison = "EQUALS"
    #   key        = "team"
    #   value      = "security"
    # }

    # keyword (Optional, max: 20)
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
  # depends_on = [aws_securityhub_account.example]
}

#---------------------------------------------------------------
# フィルタータイプ リファレンス
#---------------------------------------------------------------
# String Filter: comparison (Required) + value (Required)
#   comparison: "EQUALS", "NOT_EQUALS", "PREFIX", "PREFIX_NOT_EQUALS",
#              "CONTAINS", "NOT_CONTAINS"
#
# Number Filter: eq / gte / lte (全てOptional、文字列で指定)
#
# Date Filter: date_range { unit + value } または start + end
#   date_range: unit = "DAYS" (Required), value = 数値 (Required)
#   start/end: ISO8601形式 (例: "2024-01-01T00:00:00Z")
#
# Ip Filter: cidr (Required、例: "10.0.0.0/16")
#
# Map Filter: comparison + key + value (全てRequired)
#   comparison: "EQUALS", "NOT_EQUALS"
#
# Keyword Filter: value (Required)
#---------------------------------------------------------------

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id  : インサイトのARN
# - arn : インサイトのARN
#---------------------------------------------------------------
