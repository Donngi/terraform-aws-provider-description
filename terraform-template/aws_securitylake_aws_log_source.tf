#---------------------------------------------------------------
# AWS Security Lake AWS Log Source
#---------------------------------------------------------------
#
# Amazon Security LakeにネイティブサポートされたAWSサービスのログソースを
# 追加するリソースです。Security Lakeは対象のAWSサービスからセキュリティ
# ログとイベントを自動的に収集し、Open Cybersecurity Schema Framework (OCSF)
# およびApache Parquet形式に変換して保存します。
#
# AWS公式ドキュメント:
#   - Security Lakeソース管理: https://docs.aws.amazon.com/security-lake/latest/userguide/source-management.html
#   - AWSサービスからのデータ収集: https://docs.aws.amazon.com/security-lake/latest/userguide/internal-sources.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securitylake_aws_log_source
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_securitylake_aws_log_source" "example" {
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
  # ソース設定
  #-------------------------------------------------------------

  # source (Required)
  # 設定内容: Security Lakeに追加するAWSサービスのログソースを指定します。
  # 注意: 1つのaws_securitylake_aws_log_sourceリソースで、全リージョン・全アカウントの
  #       ログソースを設定する必要があります。
  # 注意: このリソースを作成する前に、aws_securitylake_data_lakeリソースが構成されている
  #       必要があります。depends_onの使用を推奨します。
  source {
    # source_name (Required)
    # 設定内容: Security Lakeに追加するAWSサービスの名前を指定します。
    # 設定可能な値:
    #   - "ROUTE53": Amazon Route 53リゾルバークエリログ
    #   - "VPC_FLOW": Amazon VPCフローログ
    #   - "SH_FINDINGS": AWS Security Hub CSPMの検出結果
    #   - "CLOUD_TRAIL_MGMT": AWS CloudTrail管理イベント
    #   - "LAMBDA_EXECUTION": AWS Lambda実行ログ
    #   - "S3_DATA": Amazon S3データイベント
    #   - "EKS_AUDIT": Amazon EKS監査ログ
    #   - "WAF": AWS WAFv2ログ
    # 関連機能: Security Lakeネイティブサポートソース
    #   Security LakeはこれらのAWSサービスからログとイベントを自動的に収集し、
    #   OCSFスキーマとApache Parquet形式に変換します。
    #   - https://docs.aws.amazon.com/security-lake/latest/userguide/internal-sources.html
    source_name = "VPC_FLOW"

    # regions (Required)
    # 設定内容: Security Lakeを有効にするリージョンを指定します。
    # 設定可能な値: 有効なAWSリージョンコードのセット
    # 注意: Security Lakeが有効化されていないリージョンを指定するとエラーになります。
    regions = ["ap-northeast-1"]

    # accounts (Optional)
    # 設定内容: Security Lakeを有効にするAWSアカウントIDを指定します。
    # 設定可能な値: 有効なAWSアカウントIDの文字列セット
    # 省略時: Security Lakeに含まれる全アカウントが対象になります。
    # 注意: アカウントを指定しない場合、組織内の全アカウントに適用されます。
    accounts = ["123456789012"]

    # source_version (Optional)
    # 設定内容: AWSログソースのバージョンを指定します。
    # 設定可能な値: リージョン内で一意のバージョン文字列（例: "2.0"）
    # 省略時: デフォルトのバージョンが使用されます。
    source_version = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースの識別子
#---------------------------------------------------------------
