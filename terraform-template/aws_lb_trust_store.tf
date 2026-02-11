#---------------------------------------------------------------
# Elastic Load Balancing Trust Store
#---------------------------------------------------------------
#
# Application Load Balancerのmutual TLS認証で使用するTrust Storeをプロビジョニングします。
# Trust Storeには、クライアント証明書の検証に使用するCA証明書バンドルをS3バケットから
# 参照して格納します。ALBリスナーと関連付けることで、クライアント証明書の検証を
# ロードバランサー側で実行し、アプリケーションの負荷を軽減します。
#
# AWS公式ドキュメント:
#   - Mutual authentication with TLS in Application Load Balancer: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/mutual-authentication.html
#   - Configuring mutual TLS on an Application Load Balancer: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/configuring-mtls-with-elb.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_trust_store
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lb_trust_store" "example" {
  #---------------------------------------------------------------
  # Required Arguments
  #---------------------------------------------------------------

  # S3バケット名（CA証明書バンドルの保存先）
  # Application Load BalancerがクライアントのTLS証明書を検証する際に使用する
  # CA（認証局）証明書バンドルを格納したS3バケットの名前を指定します。
  # 証明書バンドルはPEM形式である必要があります。
  ca_certificates_bundle_s3_bucket = "my-ca-bundle-bucket"

  # S3オブジェクトキー（CA証明書バンドルファイルのパス）
  # S3バケット内のCA証明書バンドルファイルのキー（パス）を指定します。
  # 証明書バンドルには、信頼するCAの証明書チェーン全体が含まれている必要があります。
  ca_certificates_bundle_s3_key = "path/to/ca-bundle.pem"

  #---------------------------------------------------------------
  # Optional Arguments
  #---------------------------------------------------------------

  # S3オブジェクトバージョンID（CA証明書バンドルのバージョン管理）
  # S3バケットでバージョニングが有効になっている場合、特定のバージョンの
  # CA証明書バンドルを指定できます。省略した場合は最新バージョンが使用されます。
  # バージョンIDを指定することで、証明書の更新履歴を管理し、必要に応じて
  # 以前のバージョンにロールバックすることができます。
  # ca_certificates_bundle_s3_object_version = "example-version-id"

  # Trust Store名
  # Trust Storeの名前を指定します。省略した場合、Terraformがランダムで
  # ユニークな名前を割り当てます。name_prefixとは競合するため、どちらか一方のみを指定します。
  # 名前の要件:
  # - リージョンごと、アカウントごとに一意である必要があります
  # - 最大32文字まで
  # - 英数字またはハイフンのみ使用可能
  # - ハイフンで始めたり終わったりすることはできません
  # - 変更するとリソースの再作成が発生します（Forces new resource）
  name = "my-trust-store"

  # Trust Store名のプレフィックス
  # 指定したプレフィックスで始まるユニークな名前を自動生成します。
  # nameとは競合するため、どちらか一方のみを指定します。
  # 最大6文字まで指定可能です。
  # 変更するとリソースの再作成が発生します（Forces new resource）
  # name_prefix = "ts-"

  # リージョン指定
  # このリソースを管理するAWSリージョンを明示的に指定します。
  # 省略した場合、プロバイダー設定で指定されたリージョンが使用されます。
  # 通常はプロバイダーレベルで設定するため、リソースごとに指定する必要はありません。
  # 詳細: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # タグ
  # Trust Storeに割り当てるタグのマップを指定します。
  # プロバイダーレベルでdefault_tagsが設定されている場合、
  # ここで指定したタグは同じキーのdefault_tagsを上書きします。
  # タグは、リソースの整理、コスト配分、アクセス制御などに使用できます。
  tags = {
    Environment = "production"
    Purpose     = "mutual-tls-authentication"
    ManagedBy   = "terraform"
  }

  # 全タグ（プロバイダーのdefault_tagsとマージされた結果）
  # このフィールドは通常、明示的に設定する必要はありません。
  # プロバイダー設定のdefault_tagsと、このリソースで指定したtagsが
  # 自動的にマージされた結果が格納されます。
  # 詳細: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  # tags_all = {}

  # リソースID
  # Terraformによって自動的に管理されるリソースのID（ARN）です。
  # 通常、このフィールドを明示的に設定する必要はありません。
  # 作成後、このIDを使用して他のリソースから参照できます。
  # id = aws_lb_trust_store.example.arn

  #---------------------------------------------------------------
  # Timeouts Block
  #---------------------------------------------------------------

  # タイムアウト設定
  # Trust Storeの作成および削除操作のタイムアウト時間を設定できます。
  # 大規模な証明書バンドルを使用する場合など、デフォルトのタイムアウトでは
  # 不十分な場合に調整します。
  timeouts {
    # 作成時のタイムアウト（デフォルト: 設定なし）
    # Trust Store作成操作が完了するまでの最大待機時間を指定します。
    # 形式: "60m"（60分）、"2h"（2時間）など
    # create = "30m"

    # 削除時のタイムアウト（デフォルト: 設定なし）
    # Trust Store削除操作が完了するまでの最大待機時間を指定します。
    # 形式: "60m"（60分）、"2h"（2時間）など
    # delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
#
# このリソースは以下の属性をエクスポートします（computed only）:
#
# - arn: Trust StoreのARN（Amazon Resource Name）。idと同じ値です。
#        他のリソース（ALBリスナーなど）でこのTrust Storeを参照する際に使用します。
#        形式: arn:aws:elasticloadbalancing:region:account-id:truststore/name/id
#
# - arn_suffix: ARNのサフィックス部分。CloudWatch Metricsでの使用を想定しています。
#               メトリクスのディメンションとして使用することで、特定のTrust Storeに
#               関連するメトリクスをフィルタリングできます。
#
# - id: Trust StoreのARN。arnと同じ値です。
#
# - name: Trust Storeの名前。nameまたはname_prefixを省略した場合、
#         自動生成された名前が格納されます。
#
# - tags_all: プロバイダーのdefault_tagsとリソース固有のtagsをマージした
#             全タグのマップ。
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Usage Example: ALB Listenerとの統合
#---------------------------------------------------------------
#
# Trust Storeは通常、Application Load Balancerのリスナーと組み合わせて使用します。
# 以下は、mutual TLS認証を有効化したリスナーの例です:
#
# resource "aws_lb_listener" "example" {
#   load_balancer_arn = aws_lb.example.arn
#   port              = 443
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
#   certificate_arn   = aws_acm_certificate.example.arn
#
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.example.arn
#   }
#
#   # Mutual TLS認証の設定
#   mutual_authentication {
#     mode            = "verify"  # または "passthrough"
#     trust_store_arn = aws_lb_trust_store.example.arn
#
#     # オプション: 証明書失効リスト（CRL）の無視設定
#     # ignore_client_certificate_expiry = false
#   }
# }
#
# Mutual TLS認証モード:
# - verify: ALBがクライアント証明書を検証し、検証結果をHTTPヘッダーで
#           バックエンドに渡します。アプリケーション側での証明書検証が不要です。
# - passthrough: ALBはクライアント証明書チェーン全体をHTTPヘッダーで
#                バックエンドに渡しますが、検証は行いません。
#                アプリケーション側で証明書検証ロジックを実装する必要があります。
#
#---------------------------------------------------------------
