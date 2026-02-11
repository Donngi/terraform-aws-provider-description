#---------------------------------------------------------------
# AWS KMS Multi-Region Replica Key
#---------------------------------------------------------------
#
# AWS KMS マルチリージョンレプリカキーをプロビジョニングするリソースです。
# マルチリージョンキーは、異なるAWSリージョンに存在しながら同じキーマテリアルと
# キーIDを共有するKMSキーであり、一方のリージョンで暗号化したデータを別のリージョンで
# 復号できます。レプリカキーはプライマリキーと同じ暗号特性を持つ完全に機能するKMSキーであり、
# プライマリキーやその他のレプリカキーが無効化されていても独立して使用できます。
#
# AWS公式ドキュメント:
#   - マルチリージョンキーの概要: https://docs.aws.amazon.com/kms/latest/developerguide/multi-region-keys-overview.html
#   - マルチリージョンレプリカキーの作成: https://docs.aws.amazon.com/kms/latest/developerguide/multi-region-keys-replicate.html
#   - ReplicateKey API: https://docs.aws.amazon.com/kms/latest/APIReference/API_ReplicateKey.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_replica_key
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------
resource "aws_kms_replica_key" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # primary_key_arn (Required)
  # 設定内容: レプリケート元となるマルチリージョンプライマリキーのARNを指定します。
  # 設定可能な値: 有効なKMSマルチリージョンプライマリキーのARN
  # 注意: プライマリキーは同じAWSパーティション内の異なるリージョンに存在する必要があります。
  #       各リージョンには同一のプライマリキーから1つのレプリカキーのみ作成可能です。
  # 参考: https://docs.aws.amazon.com/kms/latest/developerguide/multi-region-keys-replicate.html
  primary_key_arn = "arn:aws:kms:us-east-1:123456789012:key/mrk-1234abcd12ab34cd56ef1234567890ab"

  # description (Optional)
  # 設定内容: KMSキーの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  # 注意: エイリアス・説明・タグにはCloudTrailログ等に平文で表示される可能性があるため、
  #       機密情報を含めないでください。
  description = "Multi-Region replica key"

  # enabled (Optional)
  # 設定内容: レプリカキーを有効にするかどうかを指定します。
  # 設定可能な値:
  #   - true (デフォルト): キーを有効化。暗号化操作に使用可能
  #   - false: キーを無効化。暗号化操作に使用不可
  # 省略時: true
  # 注意: 無効化されたKMSキーは暗号化操作に使用できませんが、キーの管理操作は引き続き可能です。
  # 参考: https://docs.aws.amazon.com/kms/latest/developerguide/enabling-keys.html
  enabled = true
