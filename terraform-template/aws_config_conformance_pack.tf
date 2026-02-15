#-------------------------------------------------------------------------------
# AWS Config Conformance Pack
#-------------------------------------------------------------------------------
# Provider Version: 6.28.0
# Generated: 2026-02-13
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/config_conformance_pack
#
# NOTE: このテンプレートは参照用のサンプルです。実際の環境に合わせてカスタマイズしてください。
#
# 用途: AWS Configの適合パックをアカウント・リージョンに展開
#
# 適合パック(Conformance Pack)は、AWS Configルールと修復アクションのコレクションで、
# 単一のエンティティとして簡単にデプロイできる。セキュリティ、運用、コスト最適化の
# ガバナンスチェックを一括で管理可能。
#
# 主な用途:
# - セキュリティベストプラクティスの一括適用
# - コンプライアンス標準への準拠チェック(PCI-DSS、HIPAA、CIS等)
# - 組織全体での統一的なガバナンスポリシー展開
# - AWS Control Tower検出的ガードレールとの統合
#
# 制約事項:
# - テンプレートソースはtemplate_body、template_s3_uri、TemplateSSMDocumentDetailsのいずれか1つのみ指定可能
# - input_parameterは最大60個まで設定可能
# - パラメータ名は最大255文字、パラメータ値は最大4096文字
# - リソース作成時にAWSServiceRoleForConfigConformsサービスリンクロールが自動作成される
#
# 注意事項:
# - サンプルテンプレートはベースラインとして使用し、リージョン固有のルールを確認してカスタマイズが必要
# - 適合パックのデプロイにはAWS Configが有効化されている必要がある
# - delivery_s3_bucketを指定すると、コンプライアンス詳細がS3に保存される
#
#-----------------------------------------------------------------------
# 基本設定
#-----------------------------------------------------------------------

resource "aws_config_conformance_pack" "example" {
  # 設定内容: 適合パックの名前
  # 制約: 必須、最小1文字～最大256文字
  # 用途: 適合パックの識別名として使用され、デプロイ後の管理・参照に利用される
  name = "example-conformance-pack"

  #-----------------------------------------------------------------------
  # テンプレート設定（いずれか1つのみ指定）
  #-----------------------------------------------------------------------

  # 設定内容: 適合パックのYAMLテンプレート本体
  # 省略時: template_s3_uriまたはTemplateSSMDocumentDetailsのいずれかが必須
  # 用途: インラインでテンプレートを定義する場合に使用
  # 例: AWSが提供するサンプルテンプレートまたはカスタムテンプレート
  template_body = <<-EOT
    Resources:
      S3BucketVersioningEnabled:
        Properties:
          ConfigRuleName: S3BucketVersioningEnabled
          Source:
            Owner: AWS
            SourceIdentifier: S3_BUCKET_VERSIONING_ENABLED
        Type: AWS::Config::ConfigRule
  EOT

  # 設定内容: S3に保存された適合パックテンプレートのURI
  # 省略時: template_bodyまたはTemplateSSMDocumentDetailsのいずれかが必須
  # 用途: 大規模なテンプレートや複数環境で共有するテンプレートをS3から参照
  # 形式: s3://bucket-name/path/to/template.yaml
  template_s3_uri = "s3://example-bucket/conformance-packs/security-best-practices.yaml"

  #-----------------------------------------------------------------------
  # 配信設定
  #-----------------------------------------------------------------------

  # 設定内容: 適合パックのテンプレートとコンプライアンス詳細を保存するS3バケット名
  # 省略時: デフォルトの保存場所が使用される
  # 用途: コンプライアンスレポートの長期保存やS3 Selectによる分析に利用
  # 注意: バケットポリシーでAWS Configからの書き込みを許可する必要がある
  delivery_s3_bucket = "config-conformance-pack-delivery-bucket"

  # 設定内容: S3バケット内のオブジェクトキープレフィックス
  # 省略時: バケットのルートに保存される
  # 用途: 複数の適合パックや環境ごとにファイルを整理
  # 例: production/, conformance-packs/security/
  delivery_s3_key_prefix = "conformance-packs/security/"

  #-----------------------------------------------------------------------
  # リージョン設定
  #-----------------------------------------------------------------------

  # 設定内容: 適合パックをデプロイするAWSリージョン
  # 省略時: プロバイダー設定のリージョンが使用される
  # 用途: マルチリージョン展開時に特定リージョンを明示的に指定
  # 注意: 適合パックはリージョン固有のリソースであるため、各リージョンごとにデプロイが必要
  region = "us-east-1"

  #-----------------------------------------------------------------------
  # 入力パラメータ設定
  #-----------------------------------------------------------------------

  # 設定内容: 適合パックテンプレート内のルールに渡すパラメータ
  # 省略時: テンプレートのデフォルト値が使用される
  # 用途: テンプレートをカスタマイズせずに、環境固有の値を注入
  # 制約: 最大60個まで設定可能
  # 例: S3バケットの暗号化アルゴリズム、CloudTrailログの保持期間など
  input_parameter {
    # 設定内容: パラメータ名
    # 制約: 必須、最大255文字
    # 用途: テンプレート内で定義されたパラメータ名と一致させる
    parameter_name = "AccessLoggingBucketName"

    # 設定内容: パラメータ値
    # 制約: 必須、最大4096文字
    # 用途: ルール評価時に使用される具体的な値
    parameter_value = "my-access-logging-bucket"
  }

  # input_parameter {
  #   parameter_name  = "RequiredTagKey"
  #   parameter_value = "Environment"
  # }

  # input_parameter {
  #   parameter_name  = "CloudTrailLogRetentionDays"
  #   parameter_value = "90"
  # }
}

#-------------------------------------------------------------------------------
# Attributes Reference
#-------------------------------------------------------------------------------
# arn - 適合パックのARN
# id  - 適合パック名（nameと同値）
