#---------------------------------------------------------------
# IAM Server Certificate
#---------------------------------------------------------------
#
# IAM サーバー証明書をアップロードして管理するリソース。
# SSL/TLS証明書を AWS サービス（Elastic Load Balancing、CloudFront、
# AWS Elastic Beanstalk、AWS OpsWorks など）で使用できるようにする。
#
# 注意事項:
#   - AWS Certificate Manager (ACM) がサポートされているリージョンでは
#     ACM の使用が推奨される（自動更新などの利便性が高い）
#   - IAM 証明書は ACM が利用できないリージョンや特定のユースケース向け
#   - 秘密鍵を含む全ての引数が平文で Terraform state に保存される
#   - 証明書は PEM エンコード形式である必要がある
#
# AWS公式ドキュメント:
#   - サーバー証明書の管理: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_server-certs.html
#   - UploadServerCertificate API: https://docs.aws.amazon.com/IAM/latest/APIReference/API_UploadServerCertificate.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_server_certificate
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_server_certificate" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # certificate_body - 公開鍵証明書の内容（PEM エンコード形式）
  # - サーバー証明書の公開鍵部分
  # - PEM 形式である必要がある（-----BEGIN CERTIFICATE----- で始まる）
  # - UNIX 改行（LF）を使用することを推奨（DOS 改行は AWS が変更する場合がある）
  # - 証明書本体には1つの証明書のみを含める（チェーンは certificate_chain に含める）
  # - 変更すると新しいリソースが作成される（Forces new resource）
  # Type: string
  # Required: Yes
  certificate_body = file("path/to/certificate.pem")

  # private_key - 秘密鍵の内容（PEM エンコード形式）
  # - 証明書に対応する秘密鍵
  # - PEM 形式である必要がある（-----BEGIN RSA PRIVATE KEY----- で始まる）
  # - 暗号化されていない状態である必要がある
  # - この値は Terraform state に平文で保存されるため注意が必要
  # - 変更すると新しいリソースが作成される（Forces new resource）
  # Type: string (sensitive)
  # Required: Yes
  private_key = file("path/to/private-key.pem")

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # certificate_chain - 証明書チェーンの内容
  # - 認証局（CA）が提供する中間証明書とルート証明書の連結
  # - 自己署名証明書でない場合に必要
  # - PEM 形式の証明書を連結したもの
  # - 変更すると新しいリソースが作成される（Forces new resource）
  # Type: string
  # Default: null
  certificate_chain = file("path/to/certificate-chain.pem")

  # name - サーバー証明書の名前
  # - IAM での証明書の識別名
  # - パス情報は含めない（パスは path パラメータで指定）
  # - 英数字、ハイフン、アンダースコアなどが使用可能
  # - 省略した場合は Terraform がランダムで一意な名前を生成
  # - name_prefix と競合する（どちらか一方のみ指定可能）
  # Type: string
  # Default: Terraform が自動生成
  name = "example-server-cert"

  # name_prefix - 証明書名のプレフィックス
  # - 指定したプレフィックスで始まる一意な名前を自動生成
  # - name と競合する（どちらか一方のみ指定可能）
  # - ローリングアップデートで証明書を更新する場合に有用
  # Type: string
  # Default: null
  # name_prefix = "example-cert-"

  # path - IAM パス
  # - サーバー証明書の IAM パス
  # - 指定しない場合はデフォルトでルートパス（/）となる
  # - CloudFront で使用する場合は "/cloudfront/your_path_here" 形式が必要
  # - パスはスラッシュで区切られた階層構造（例: /division_abc/subdivision_xyz/）
  # Type: string
  # Default: "/"
  path = "/"

  # tags - タグのマップ
  # - サーバー証明書に付与するリソースタグ
  # - キーと値のペアで管理・課金管理・検索に使用
  # - プロバイダーレベルの default_tags と統合される
  # Type: map(string)
  # Default: {}
  tags = {
    Name        = "example-server-certificate"
    Environment = "production"
    ManagedBy   = "Terraform"
  }

  #---------------------------------------------------------------
  # タイムアウト設定
  #---------------------------------------------------------------

  timeouts {
    # delete - 削除操作のタイムアウト時間
    # - サーバー証明書の削除にかかる最大待機時間
    # - 証明書が他のリソース（ELB など）で使用中の場合、削除に時間がかかる場合がある
    # Type: string (duration)
    # Default: なし
    delete = "10m"
  }

  #---------------------------------------------------------------
  # ライフサイクル設定（推奨）
  #---------------------------------------------------------------

  # 証明書のローリングアップデート時に推奨される設定
  # lifecycle {
  #   create_before_destroy = true
  # }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# 以下の属性は computed 属性であり、リソース作成後に参照可能です。
# これらは入力パラメータではなく、outputs や他のリソースから参照します。
#
# - arn
#     サーバー証明書の Amazon Resource Name (ARN)
#     例: arn:aws:iam::123456789012:server-certificate/example-cert
#     Type: string
#
# - expiration
#     証明書の有効期限（RFC3339 形式）
#     例: 2025-12-31T23:59:59Z
#     Type: string
#
# - id
#     サーバー証明書の一意な名前（name と同じ値）
#     Type: string
#
# - tags_all
#     リソースに割り当てられたすべてのタグのマップ
#     プロバイダーレベルの default_tags を含む
#     Type: map(string)
#
# - upload_date
#     サーバー証明書がアップロードされた日時（RFC3339 形式）
#     例: 2024-01-15T10:30:00Z
#     Type: string
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------

# 例1: ファイルから証明書を読み込む基本的な使用例
# resource "aws_iam_server_certificate" "example_basic" {
#   name             = "example-cert"
#   certificate_body = file("${path.module}/certs/certificate.pem")
#   private_key      = file("${path.module}/certs/private-key.pem")
# }

# 例2: 証明書チェーン付きの完全な例
# resource "aws_iam_server_certificate" "example_with_chain" {
#   name              = "example-cert-with-chain"
#   certificate_body  = file("${path.module}/certs/certificate.pem")
#   certificate_chain = file("${path.module}/certs/ca-bundle.pem")
#   private_key       = file("${path.module}/certs/private-key.pem")
#   path              = "/cloudfront/"
#
#   tags = {
#     Name        = "CloudFront Certificate"
#     Service     = "CloudFront"
#     Environment = "production"
#   }
# }

# 例3: ローリングアップデート用の設定（name_prefix + lifecycle）
# resource "aws_iam_server_certificate" "example_rolling" {
#   name_prefix      = "example-cert-"
#   certificate_body = file("${path.module}/certs/certificate.pem")
#   private_key      = file("${path.module}/certs/private-key.pem")
#
#   lifecycle {
#     create_before_destroy = true
#   }
# }

# 例4: ELB で使用する例
# resource "aws_elb" "example" {
#   name               = "example-elb"
#   availability_zones = ["us-east-1a", "us-east-1b"]
#
#   listener {
#     instance_port      = 8000
#     instance_protocol  = "http"
#     lb_port            = 443
#     lb_protocol        = "https"
#     ssl_certificate_id = aws_iam_server_certificate.example.arn
#   }
# }

#---------------------------------------------------------------
# 重要な注意事項
#---------------------------------------------------------------
# 1. 証明書フォーマット:
#    - 証明書と秘密鍵は PEM エンコード形式である必要がある
#    - UNIX 改行（LF）を使用する（DOS 改行は AWS が変更する可能性がある）
#    - certificate_body には1つの証明書のみを含める
#    - 中間証明書とルート証明書は certificate_chain に含める
#
# 2. セキュリティ:
#    - private_key を含むすべての引数が Terraform state に平文で保存される
#    - state ファイルのアクセス制御と暗号化を適切に設定すること
#    - 可能であれば AWS Certificate Manager (ACM) の使用を検討すること
#
# 3. ACM vs IAM:
#    - ACM がサポートされているリージョンでは ACM を使用することを推奨
#    - ACM は自動更新、統合管理、無料証明書などの利点がある
#    - IAM 証明書は ACM が利用できないリージョンやレガシーシステム向け
#
# 4. CloudFront での使用:
#    - CloudFront で使用する証明書は path が "/cloudfront/..." である必要がある
#    - CloudFront 用証明書は us-east-1 リージョンにアップロードする必要がある
#
# 5. ローリングアップデート:
#    - 証明書の更新時は name_prefix と create_before_destroy の使用を推奨
#    - 既存の証明書が使用中の場合、新しい証明書を先に作成してから切り替える
#
# 6. 証明書の有効期限:
#    - expiration 属性で有効期限を確認可能
#    - 有効期限前に証明書を更新する仕組みを用意すること
#---------------------------------------------------------------
