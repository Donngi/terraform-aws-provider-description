#---------------------------------------------------------------
# AWS ELBv2 Trust Store (Application Load Balancer)
#---------------------------------------------------------------
#
# Application Load Balancer (ALB) で相互TLS (mTLS) 認証に使用する
# トラストストアをプロビジョニングするリソースです。
# トラストストアには、クライアント証明書の検証に用いるCA証明書バンドルを
# S3から読み込んで登録します。ALBリスナーに関連付けることで
# mTLS verify モードが有効になります。
#
# AWS公式ドキュメント:
#   - ALBでの相互TLS認証の概要: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/mutual-authentication.html
#   - mTLS設定手順: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/configuring-mtls-with-elb.html
#   - CreateTrustStore APIリファレンス: https://docs.aws.amazon.com/elasticloadbalancing/latest/APIReference/API_CreateTrustStore.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_trust_store
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lb_trust_store" "example" {
  #-------------------------------------------------------------
  # 名前設定
  #-------------------------------------------------------------

  # name (Optional, Forces new resource)
  # 設定内容: トラストストアの名前を指定します。
  # 設定可能な値: 最大32文字の英数字またはハイフン。ハイフンで開始・終了することは不可。
  #              リージョン・アカウント内で一意である必要があります。
  # 省略時: Terraformがランダムな一意の名前を生成します。
  # 注意: name_prefix と排他的（どちらか一方のみ指定可能）
  name = "tf-example-lb-ts"

  # name_prefix (Optional, Forces new resource)
  # 設定内容: トラストストア名のプレフィックスを指定します。
  #          Terraform が後ろにランダムなサフィックスを付加して一意な名前を生成します。
  # 設定可能な値: 6文字以下の文字列
  # 注意: name と排他的（どちらか一方のみ指定可能）
  name_prefix = null

  #-------------------------------------------------------------
  # CA証明書バンドル設定
  #-------------------------------------------------------------

  # ca_certificates_bundle_s3_bucket (Required)
  # 設定内容: クライアント証明書の検証に使用するCA証明書バンドルが格納された
  #          S3バケットの名前を指定します。
  # 設定可能な値: 有効なS3バケット名
  # 注意: CA証明書バンドルはPEM形式でアップロードする必要があります。
  #       コメント行や空白行は含めないでください。
  ca_certificates_bundle_s3_bucket = "my-cert-bucket"

  # ca_certificates_bundle_s3_key (Required)
  # 設定内容: CA証明書バンドルが格納されたS3オブジェクトのキーを指定します。
  # 設定可能な値: 有効なS3オブジェクトキー文字列
  ca_certificates_bundle_s3_key = "ca-bundle/ca-bundle.pem"

  # ca_certificates_bundle_s3_object_version (Optional)
  # 設定内容: CA証明書バンドルのS3オブジェクトバージョンIDを指定します。
  #          S3バケットでバージョニングが有効な場合に使用します。
  # 設定可能な値: 有効なS3オブジェクトバージョンID文字列
  # 省略時: 最新バージョンが使用されます。
  ca_certificates_bundle_s3_object_version = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 注意: プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-trust-store"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: トラストストアの作成完了を待機するタイムアウト時間を指定します。
    # 設定可能な値: Goのduration形式の文字列（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウト値を使用します。
    create = "30m"

    # delete (Optional)
    # 設定内容: トラストストアの削除完了を待機するタイムアウト時間を指定します。
    # 設定可能な値: Goのduration形式の文字列（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウト値を使用します。
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: トラストストアのAmazon Resource Name (ARN)。id と同一の値。
#
# - arn_suffix: CloudWatch Metricsで使用するARNサフィックス。
#
# - id: トラストストアのARN（arn と同一の値）。
#
# - name: トラストストアの名前。
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
