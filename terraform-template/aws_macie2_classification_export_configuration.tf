#---------------------------------------------------------------
# AWS Macie Classification Export Configuration
#---------------------------------------------------------------
#
# Amazon Macieのデータ分類結果をS3バケットに保存するための設定を
# プロビジョニングするリソースです。
# Macieは、S3オブジェクトを分析して機密データが含まれているかどうかを
# 判定し、分析結果（classification result）を自動的に生成します。
# このリソースを使用することで、これらの結果を暗号化してS3に長期保存でき、
# データプライバシーや保護監査、調査に役立てることができます。
#
# AWS公式ドキュメント:
#   - Macie 分類結果の保存: https://docs.aws.amazon.com/macie/latest/user/discovery-results-repository-s3.html
#   - Macie API Reference: https://docs.aws.amazon.com/macie/latest/APIReference/classification-export-configuration.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/macie2_classification_export_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_macie2_classification_export_configuration" "example" {
  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: 分類結果を保存するS3バケットと同じリージョンに設定する必要があります。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # S3エクスポート先設定
  #-------------------------------------------------------------

  # s3_destination (Required)
  # 設定内容: Macieの分類結果を保存するS3バケットの設定を指定します。
  # 注意: このブロックは必須で、1つのみ指定可能です。
  # 関連機能: Macie Classification Results Export
  #   Macieが分析したS3オブジェクトごとに分類結果レコードを生成し、
  #   指定されたS3バケットに保存します。結果にはデータの場所や
  #   検出された機密データの種類などの詳細が含まれます。
  #   - https://docs.aws.amazon.com/macie/latest/user/discovery-results-repository-s3.html
  s3_destination {
    # bucket_name (Required)
    # 設定内容: 分類結果を保存するS3バケットの名前を指定します。
    # 設定可能な値: 有効なS3バケット名
    # 注意: バケットはgeneral purpose bucket（汎用バケット）である必要があります。
    #       また、バケットポリシーでMacieがオブジェクトを追加できるように
    #       設定されている必要があります。
    # 参考: https://docs.aws.amazon.com/macie/latest/user/discovery-results-repository-s3.html
    bucket_name = "my-macie-classification-results"

    # key_prefix (Optional)
    # 設定内容: S3バケット内でオブジェクトを保存する際のキープレフィックスを指定します。
    # 設定可能な値: 有効なS3オブジェクトキープレフィックス（パス形式）
    # 省略時: バケットのルートに直接保存されます
    # 用途: 複数の環境やアカウントの結果を同じバケットで管理する場合、
    #       プレフィックスで分類することができます。
    # 注意: プレフィックスを変更した場合は、S3バケットポリシーも
    #       新しいプレフィックスを反映するように更新する必要があります。
    key_prefix = "macie-results/production/"

    # kms_key_arn (Required)
    # 設定内容: 分類結果を暗号化するために使用するKMSキーのARNを指定します。
    # 設定可能な値: 有効なKMSキーARN
    # 注意: 以下の要件を満たす必要があります:
    #       - カスタマーマネージド対称暗号化キー
    #       - S3バケットと同じリージョンで有効化されている
    #       - Macieサービスにキーの使用権限が付与されている
    # 関連機能: KMS暗号化
    #   分類結果に含まれる機密データ情報を保護するため、
    #   AWS KMSを使用して暗号化します。
    #   - https://docs.aws.amazon.com/kms/latest/developerguide/overview.html
    # 参考: https://docs.aws.amazon.com/macie/latest/user/discovery-results-repository-s3.html
    kms_key_arn = "arn:aws:kms:ap-northeast-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースの一意の識別子。通常は設定が適用されるリージョンと
#       同じ値になります。
#---------------------------------------------------------------
