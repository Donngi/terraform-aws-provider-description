#---------------------------------------------------------------
# AWS CodeArtifact Domain
#---------------------------------------------------------------
#
# AWS CodeArtifactのドメインをプロビジョニングするリソースです。
# ドメインは、リポジトリの論理的なグループであり、重複排除されたストレージ、
# 高速なコピー、複数のリポジトリやチーム間での簡単な共有、
# 複数のリポジトリにわたるポリシーの適用を提供します。
#
# AWS公式ドキュメント:
#   - Domain overview: https://docs.aws.amazon.com/codeartifact/latest/ug/domain-overview.html
#   - Create a domain: https://docs.aws.amazon.com/codeartifact/latest/ug/domain-create.html
#   - Data encryption: https://docs.aws.amazon.com/codeartifact/latest/ug/security-encryption.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain
#
# Provider Version: 6.28.0
# Generated: 2026-01-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_codeartifact_domain" "example" {
  #-------------------------------------------------------------
  # ドメイン名設定
  #-------------------------------------------------------------

  # domain (Required)
  # 設定内容: 作成するドメインの名前を指定します。
  # 設定可能な値: 2-50文字の文字列。同一AWSアカウント内の同一リージョンでは一意である必要があります。
  # 注意: ドメイン名はDNSホスト名のプレフィックスとして使用されます。
  #       公開可能な情報となるため、機密情報を含めないでください。
  # 参考: https://docs.aws.amazon.com/codeartifact/latest/ug/domain-overview.html
  domain = "example-domain"

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
  # 暗号化設定
  #-------------------------------------------------------------

  # encryption_key (Optional)
  # 設定内容: ドメイン内のコンテンツを暗号化するために使用するKMSキーのARNを指定します。
  # 設定可能な値: 有効なKMSキーARN
  # 省略時: デフォルトのAWS管理キー（aws/codeartifact）が使用されます。
  # 関連機能: CodeArtifact データ暗号化
  #   ドメインには1つのKMSキーが割り当てられ、ドメイン内のすべてのアセットが暗号化されます。
  #   カスタマー管理キーを使用する場合は、ドメイン作成前にキーの作成と設定が必要です。
  #   CodeArtifactは対称KMSキーのみをサポートし、非対称KMSキーはサポートしていません。
  #   - https://docs.aws.amazon.com/codeartifact/latest/ug/security-encryption.html
  #   - https://docs.aws.amazon.com/codeartifact/latest/ug/domain-create.html
  encryption_key = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  #-------------------------------------------------------------
  # ID設定
  #-------------------------------------------------------------

  # id (Optional, Computed)
  # 設定内容: リソースの一意の識別子を指定します。
  # 設定可能な値: 文字列
  # 省略時: Terraformによって自動的に計算されます（ドメインのARN）。
  # 注意: 通常は省略することを推奨します。Terraformが自動的に管理します。
  id = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-domain"
    Environment = "production"
  }

  # tags_all (Optional, Computed)
  # 設定内容: リソースに割り当てられた全てのタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: tagsとプロバイダーのdefault_tagsを組み合わせたものが自動的に計算されます。
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
  #   リソースに割り当てられたすべてのタグのマップ。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  # 注意: 通常は省略することを推奨します。Terraformが自動的に管理します。
  tags_all = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ドメインのARN
#
# - arn: ドメインのAmazon Resource Name (ARN)
#
# - owner: ドメインを所有するAWSアカウントID
#
# - repository_count: ドメイン内のリポジトリ数
#
# - s3_bucket_arn: ドメイン内のパッケージアセットを保存するために使用される
#                  Amazon S3バケットのARN
#
# - created_time: ドメインが作成された日時を表すタイムスタンプ（RFC3339形式）
#                 - https://tools.ietf.org/html/rfc3339#section-5.8
#
# - asset_size_bytes: ドメイン内のすべてのアセットの合計サイズ
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#             - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
#---------------------------------------------------------------
