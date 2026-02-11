#---------------------------------------------------------------
# AWS Transfer Family Web App
#---------------------------------------------------------------
#
# AWS Transfer Family Web Appは、Amazon S3へのデータ転送を
# ウェブブラウザ経由で実現する完全マネージド型のサービスです。
# エンドユーザーがSFTP/FTPクライアントを使用せずに、
# ウェブインターフェース経由でS3バケットへのファイルアップロード、
# ダウンロード、一覧表示、削除などの操作が可能になります。
#
# AWS IAM Identity CenterやAmazon S3 Access Grantsと統合され、
# きめ細かいアクセス制御を提供します。最大160GBのファイル転送、
# HTTPS通信、自動リトライ、エンドツーエンドの整合性チェックを
# サポートし、カスタムドメイン名やブランディング（ロゴ、
# ファビコン）も設定可能です。
#
# AWS公式ドキュメント:
#   - AWS Transfer Family Web Apps: https://docs.aws.amazon.com/transfer/latest/userguide/web-app.html
#   - Web Apps チュートリアル: https://docs.aws.amazon.com/transfer/latest/userguide/web-app-tutorial.html
#   - Web Apps ローンチブログ: https://aws.amazon.com/blogs/aws/announcing-aws-transfer-family-web-apps-for-fully-managed-amazon-s3-file-transfers/
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/transfer_web_app
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_transfer_web_app" "example" {

  #-------------------------------------------------------------
  # 認証・ID設定 (必須)
  #-------------------------------------------------------------

  # identity_provider_details (Required)
  # 設定内容: Web Appで使用するIDプロバイダーの詳細を定義
  # 設定可能な値: identity_center_configブロックを含むブロック
  # 関連機能: AWS IAM Identity Center
  #   企業のIDプロバイダーと統合し、SSO認証を実現
  #   - https://docs.aws.amazon.com/singlesignon/latest/userguide/what-is.html
  identity_provider_details {
    identity_center_config {
      # instance_arn (Optional)
      # 設定内容: Web Appで使用するIAM Identity CenterインスタンスのARN
      # 設定可能な値: arn:aws:sso:::instance/{instance-id}形式のARN
      # 省略時: null
      instance_arn = "arn:aws:sso:::instance/ssoins-1234567890abcdef0"

      # role (Optional)
      # 設定内容: Web Appが使用するIdentity Bearerロール（IAMロール）のARN
      # 設定可能な値: S3アクセス権限とIdentity Center連携権限を持つIAMロールのARN
      # 省略時: null
      # 関連機能: S3 Access Grants
      #   ロールに s3:GetDataAccess, s3:ListCallerAccessGrants などの権限が必要
      #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-grants.html
      role = "arn:aws:iam::123456789012:role/TransferWebAppRole"
    }
  }

  #-------------------------------------------------------------
  # エンドポイント設定
  #-------------------------------------------------------------

  # access_endpoint (Optional, Computed)
  # 設定内容: Web AppにアクセスするためのカスタムエンドポイントURL
  # 設定可能な値: https://で始まる完全修飾ドメイン名
  # 省略時: AWSが自動生成するデフォルトエンドポイントが使用される
  # 注意: endpoint_details.vpcブロックを指定する場合は、access_endpointを指定できません
  # 関連機能: Amazon CloudFront
  #   カスタムURLとCloudFrontディストリビューションを組み合わせて
  #   ブランド化されたエンドポイントを作成可能
  #   - https://docs.aws.amazon.com/transfer/latest/userguide/webapp-customize.html
  access_endpoint = null

  # endpoint_details (Optional)
  # 設定内容: Web Appエンドポイントの詳細設定（パブリックまたはVPCホスト型）
  # 設定可能な値: vpcブロックを含むブロック（VPC内プライベートエンドポイント用）
  # 省略時: パブリックにアクセス可能なエンドポイントが作成される
  # 関連機能: VPC内プライベートエンドポイント
  #   VPC内にエンドポイントを配置し、プライベートネットワーク経由で
  #   S3へのデータ転送を実現（PrivateLinkとS3エンドポイントが必要）
  #   - https://docs.aws.amazon.com/transfer/latest/userguide/create-webapp-in-vpc.html
  # endpoint_details {
  #   vpc {
  #     # vpc_id (Required)
  #     # 設定内容: Web AppエンドポイントをホストするVPCのID
  #     # 設定可能な値: デュアルスタック（IPv4/IPv6）対応VPCのID
  #     # 注意: VPCはIPv4とIPv6の両方をサポートしている必要があります
  #     vpc_id = "vpc-0123456789abcdef0"
  #
  #     # subnet_ids (Required)
  #     # 設定内容: Web Appエンドポイントをデプロイするサブネットのリスト
  #     # 設定可能な値: 上記vpc_id内のサブネットIDのセット
  #     # 注意: 高可用性のため、複数のアベイラビリティゾーンのサブネットを推奨
  #     subnet_ids = ["subnet-0123456789abcdef0", "subnet-0123456789abcdef1"]
  #
  #     # security_group_ids (Optional, Computed)
  #     # 設定内容: Web Appエンドポイントへのアクセスを制御するセキュリティグループIDのリスト
  #     # 設定可能な値: VPC内のセキュリティグループIDのセット
  #     # 省略時: VPCのデフォルトセキュリティグループが使用される
  #     security_group_ids = ["sg-0123456789abcdef0"]
  #   }
  # }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: Web Appリソースを管理するAWSリージョン
  # 設定可能な値: us-east-1, us-west-2, eu-west-1など（Web Apps対応リージョン）
  # 省略時: プロバイダー設定で指定されたリージョンが使用される
  # 対応リージョン: 以下のリージョンで利用可能（2024年12月時点）
  #   - US East (N. Virginia), US East (Ohio), US West (Oregon)
  #   - Europe (Frankfurt), Europe (Ireland), Europe (London)
  #   - Asia Pacific (Tokyo), Asia Pacific (Singapore), Asia Pacific (Sydney)
  region = null

  #-------------------------------------------------------------
  # エンドポイントポリシー設定
  #-------------------------------------------------------------

  # web_app_endpoint_policy (Optional, Computed)
  # 設定内容: Web Appのエンドポイントポリシータイプ
  # 設定可能な値: STANDARD（デフォルト）またはFIPS
  # 省略時: STANDARD
  # 関連機能: FIPS 140-2準拠
  #   FIPSを選択すると、連邦情報処理標準に準拠したエンドポイントが使用される
  #   - https://aws.amazon.com/compliance/fips/
  web_app_endpoint_policy = "STANDARD"

  #-------------------------------------------------------------
  # 同時接続数設定
  #-------------------------------------------------------------

  # web_app_units (Optional, Computed)
  # 設定内容: Web Appの同時接続数またはユーザーセッション数を定義
  # 設定可能な値: provisionedフィールドを含むブロック
  # 省略時: デフォルト値（1）が使用される
  # 注意: Web App料金はこのユニット数とWeb App稼働時間に基づいて課金されます
  web_app_units {
    # provisioned (Optional)
    # 設定内容: 同時接続数のユニット数
    # 設定可能な値: 正の整数（1ユニット = 最大25同時ユーザー）
    # 省略時: 1
    # 課金: ユニット数とWeb App稼働時間に基づいて時間単位で課金
    provisioned = 1
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: Web Appをグループ化・検索するためのキー・バリューペア
  # 設定可能な値: 任意の文字列のマップ
  # 省略時: null
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Web AppのAmazon Resource Name (ARN)
#        形式: arn:aws:transfer:region:account-id:web-app/web-app-id
#
# - web_app_id: Web AppリソースのID（一意識別子）
#
# - access_endpoint: Web Appへアクセスするための実際のエンドポイントURL
#                    （access_endpointを指定しない場合はAWSが生成）
#
# - endpoint_details.vpc.vpc_endpoint_id: Web App用に作成されたVPCエンドポイントのID
#                                         （VPCホスト型の場合のみ）
#
# - tags_all: リソースに割り当てられたすべてのタグ
#             （デフォルトタグ含む）
#
# - identity_provider_details.identity_center_config.application_arn:
#             IAM Identity Centerで自動作成されたアプリケーションのARN
#
#---------------------------------------------------------------
# output "web_app_endpoint" {
#   description = "Web App access endpoint URL"
#---------------------------------------------------------------
