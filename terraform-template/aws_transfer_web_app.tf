#---------------------------------------------------------------
# AWS Transfer Family Web App
#---------------------------------------------------------------
#
# AWS Transfer Family の Web App をプロビジョニングするリソースです。
# Web App は、ブラウザベースのファイル転送インターフェースを提供し、
# エンドユーザーが専用クライアントなしに SFTP/FTPS サーバーへ
# アクセスできるようにします。VPC エンドポイントを使用したプライベート
# アクセスや、IAM Identity Center との統合による認証が可能です。
#
# AWS公式ドキュメント:
#   - Transfer Family Web Apps: https://docs.aws.amazon.com/transfer/latest/userguide/web-apps.html
#   - CreateWebApp API: https://docs.aws.amazon.com/transfer/latest/APIReference/API_CreateWebApp.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/transfer_web_app
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_transfer_web_app" "example" {
  #-------------------------------------------------------------
  # エンドポイント設定
  #-------------------------------------------------------------

  # access_endpoint (Optional)
  # 設定内容: Web App へのアクセスに使用するエンドポイント URL を指定します。
  # 設定可能な値: 有効な HTTPS URL 文字列
  # 省略時: AWS が自動的にエンドポイントを割り当てます。
  access_endpoint = null

  # endpoint_details (Optional)
  # 設定内容: VPC エンドポイントを使用したプライベートアクセス設定を指定します。
  # 関連機能: VPC エンドポイントを通じて Transfer Family Web App へのアクセスを
  #   プライベートネットワーク内に制限できます。
  endpoint_details {
    # vpc (Optional)
    # 設定内容: VPC エンドポイントの詳細設定を指定するブロックです。
    vpc {
      # vpc_id (Required)
      # 設定内容: VPC エンドポイントを作成する VPC の ID を指定します。
      # 設定可能な値: 有効な VPC ID（例: vpc-12345678）
      vpc_id = "vpc-12345678"

      # subnet_ids (Required)
      # 設定内容: VPC エンドポイントに関連付けるサブネット ID のセットを指定します。
      # 設定可能な値: 有効なサブネット ID のセット
      subnet_ids = ["subnet-12345678", "subnet-87654321"]

      # security_group_ids (Optional)
      # 設定内容: VPC エンドポイントに関連付けるセキュリティグループ ID のセットを指定します。
      # 設定可能な値: 有効なセキュリティグループ ID のセット
      # 省略時: AWS がデフォルトのセキュリティグループを使用します。
      security_group_ids = ["sg-12345678"]

      # vpc_endpoint_id (Computed)
      # 設定内容: 作成された VPC エンドポイントの ID です。読み取り専用属性です。
    }
  }

  #-------------------------------------------------------------
  # 認証プロバイダー設定
  #-------------------------------------------------------------

  # identity_provider_details (Optional)
  # 設定内容: Web App の認証プロバイダー設定を指定するブロックです。
  # 関連機能: IAM Identity Center と統合することで、組織のシングルサインオン (SSO)
  #   を使用した認証が可能になります。
  identity_provider_details {
    # identity_center_config (Optional)
    # 設定内容: IAM Identity Center との統合設定を指定するブロックです。
    identity_center_config {
      # instance_arn (Optional)
      # 設定内容: IAM Identity Center インスタンスの ARN を指定します。
      # 設定可能な値: 有効な IAM Identity Center インスタンス ARN
      # 省略時: AWS がデフォルトの Identity Center インスタンスを使用します。
      instance_arn = "arn:aws:sso:::instance/ssoins-1234567890abcdef0"

      # role (Optional)
      # 設定内容: IAM Identity Center が Web App にアクセスするために使用する
      #   IAM ロールの ARN を指定します。
      # 設定可能な値: 有効な IAM ロール ARN
      role = "arn:aws:iam::123456789012:role/TransferWebAppRole"

      # application_arn (Computed)
      # 設定内容: Identity Center に作成されたアプリケーションの ARN です。読み取り専用属性です。
    }
  }

  #-------------------------------------------------------------
  # Web App エンドポイントポリシー設定
  #-------------------------------------------------------------

  # web_app_endpoint_policy (Optional)
  # 設定内容: Web App エンドポイントへのアクセスを制御する IAM リソースポリシーを
  #   JSON 形式で指定します。
  # 設定可能な値: 有効な IAM ポリシー JSON 文字列
  # 省略時: アクセス制限なし（デフォルトのアクセス設定が使用されます）。
  web_app_endpoint_policy = null

  #-------------------------------------------------------------
  # Web App ユニット設定
  #-------------------------------------------------------------

  # web_app_units (Optional)
  # 設定内容: Web App のキャパシティユニット設定を指定するリストブロックです。
  # 関連機能: プロビジョニングされたキャパシティを設定することで、
  #   安定したパフォーマンスを確保できます。
  web_app_units = [
    {
      # provisioned (Optional)
      # 設定内容: プロビジョニングするキャパシティユニット数を指定します。
      # 設定可能な値: 正の整数
      provisioned = 1
    }
  ]

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-transfer-web-app"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Web App の ARN
# - web_app_id: Web App の一意な識別子（例: webapp-1234567890abcdef0）
# - access_endpoint: Web App へのアクセスエンドポイント URL
# - web_app_endpoint_policy: Web App エンドポイントのアクセス制御ポリシー
# - endpoint_details[*].vpc[*].vpc_endpoint_id: 作成された VPC エンドポイントの ID
# - identity_provider_details[*].identity_center_config[*].application_arn: Identity Center アプリケーションの ARN
# - tags_all: プロバイダーの default_tags から継承されたタグを含む全タグのマップ
#---------------------------------------------------------------
