#---------------------------------------------------------------
# VPC Endpoint Service Allowed Principal
#---------------------------------------------------------------
#
# VPCエンドポイントサービスを検出できるプリンシパル（AWSアカウント、IAMユーザー、
# IAMロール）に対して権限を付与するリソースです。
# この権限により、指定されたプリンシパルがVPCエンドポイントを作成して
# エンドポイントサービスに接続できるようになります。
#
# AWS公式ドキュメント:
#   - VPCエンドポイントサービスの設定: https://docs.aws.amazon.com/vpc/latest/privatelink/configure-endpoint-service.html
#   - ModifyVpcEndpointServicePermissions API: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_ModifyVpcEndpointServicePermissions.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_service_allowed_principal
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpc_endpoint_service_allowed_principal" "example" {
  #-------------------------------------------------------------
  # VPCエンドポイントサービス設定
  #-------------------------------------------------------------

  # vpc_endpoint_service_id (Required, Forces new resource)
  # 設定内容: 権限を付与するVPCエンドポイントサービスのIDを指定します。
  # 設定可能な値: 有効なVPCエンドポイントサービスID（例: vpce-svc-xxxxxxxxxxxxxxxxx）
  # 関連機能: VPCエンドポイントサービスの権限管理
  #   エンドポイントサービスへのアクセスを制御するために、特定のAWSプリンシパルに
  #   権限を付与します。権限と接続要求の承認設定を組み合わせることで、どのサービス
  #   コンシューマー（AWSプリンシパル）がエンドポイントサービスにアクセスできるかを
  #   制御できます。
  #   - https://docs.aws.amazon.com/vpc/latest/privatelink/configure-endpoint-service.html
  # 注意: このリソースとVPCエンドポイントサービスリソースのallowed_principals属性を
  #      同時に使用すると競合が発生します。同じプリンシパルARNに対してはどちらか一方のみを
  #      使用してください。
  vpc_endpoint_service_id = "vpce-svc-0a1b2c3d4e5f6g7h8"

  #-------------------------------------------------------------
  # プリンシパル設定
  #-------------------------------------------------------------

  # principal_arn (Required, Forces new resource)
  # 設定内容: 権限を付与するAWSプリンシパルのARNを指定します。
  # 設定可能な値:
  #   - AWSアカウント（アカウント内の全プリンシパルを含む）: arn:aws:iam::123456789012:root
  #   - IAMロール: arn:aws:iam::123456789012:role/role_name
  #   - IAMユーザー: arn:aws:iam::123456789012:user/user_name
  #   - 全AWSアカウントの全プリンシパル: *
  # 関連機能: AWSプリンシパルのARN
  #   VPCエンドポイントサービスへのアクセス権限を付与するプリンシパルを指定します。
  #   プリンシパルに権限を付与することで、そのプリンシパルはインターフェイスVPCエンドポイントを
  #   作成してエンドポイントサービスに接続できるようになります。
  #   - https://docs.aws.amazon.com/vpc/latest/privatelink/configure-endpoint-service.html
  # 注意:
  #   - 全員に権限を付与（*）し、かつエンドポイントサービスが全リクエストを自動承認する
  #     設定の場合、ロードバランサーにパブリックIPアドレスがなくてもパブリックになります。
  #   - 権限を削除しても、既に承認されたエンドポイントとサービス間の既存接続には影響しません。
  #   - パスコンポーネントを含むプリンシパルARNはサポートされていません。
  principal_arn = "arn:aws:iam::123456789012:root"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 関連付けのID（VPCエンドポイントサービスIDとプリンシパルARNの組み合わせ）
#---------------------------------------------------------------
