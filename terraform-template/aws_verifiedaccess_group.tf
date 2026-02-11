#---------------------------------------------------------------
# AWS Verified Access Group
#---------------------------------------------------------------
#
# AWS Verified Accessグループをプロビジョニングするリソースです。
# Verified Accessグループは、Verified Accessエンドポイントのコレクションと、
# グループ内の全エンドポイントに適用されるVerified Accessポリシーで構成されます。
# 共通のセキュリティ要件を持つエンドポイントをグループ化することで、
# 個別のポリシーを作成・管理する代わりに、単一のグループポリシーを定義できます。
#
# AWS公式ドキュメント:
#   - Verified Access groups: https://docs.aws.amazon.com/verified-access/latest/ug/verified-access-groups.html
#   - Verified Access policies: https://docs.aws.amazon.com/verified-access/latest/ug/auth-policies.html
#   - CreateVerifiedAccessGroup API: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_CreateVerifiedAccessGroup.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/verifiedaccess_group
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_verifiedaccess_group" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # verifiedaccess_instance_id (Required)
  # 設定内容: このグループが関連付けられるVerified AccessインスタンスのIDを指定します。
  # 設定可能な値: 有効なVerified AccessインスタンスID（例: vai-0ce000c0b7643abea）
  # 関連機能: Verified Access Instance
  #   グループを作成する際は、Verified Accessインスタンスと関連付ける必要があります。
  #   インスタンスは、信頼プロバイダーとグループを統合する基盤となります。
  #   - https://docs.aws.amazon.com/verified-access/latest/ug/verified-access-groups.html
  verifiedaccess_instance_id = "vai-0ce000c0b7643abea"

  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: Verified Accessグループの説明を指定します。
  # 設定可能な値: 文字列
  # 省略時: 空の説明が設定されます
  # 用途: グループの目的や用途を識別するために使用
  description = "Sales applications group with common security requirements"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # ポリシー設定
  #-------------------------------------------------------------

  # policy_document (Optional)
  # 設定内容: このグループに関連付けられるポリシードキュメントを指定します。
  # 設定可能な値: Cedar言語で記述されたポリシードキュメント（文字列）
  # 省略時: ポリシーが定義されない場合、すべてのアクセスリクエストがブロックされます
  # 関連機能: Verified Access Policies
  #   Cedar（AWS ポリシー言語）で記述されたポリシーを使用して、
  #   アプリケーションへのアクセスルールを定義します。ポリシーは、
  #   設定した ID またはデバイスベースの信頼プロバイダーから送信される
  #   信頼データに対して評価されます。
  #   - https://docs.aws.amazon.com/verified-access/latest/ug/auth-policies.html
  # 注意: グループまたはエンドポイント作成時にポリシーを定義せずに作成可能ですが、
  #      ポリシーを定義するまですべてのアクセスがブロックされます。
  policy_document = <<-EOT
    permit(
      principal,
      action,
      resource
    )
    when {
      context.identity.groups.contains("sales") &&
      context.identity.email_verified == true
    };
  EOT

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # sse_configuration (Optional)
  # 設定内容: サーバーサイド暗号化にKMSキーを使用するための設定ブロックです。
  # 最大設定数: 1つまで
  # 関連機能: Server-Side Encryption
  #   AWS KMSカスタマーマネージドキー（CMK）を使用して、
  #   Verified Accessグループのデータを暗号化します。
  sse_configuration {
    # customer_managed_key_enabled (Optional)
    # 設定内容: カスタマーマネージドキー（CMK）を使用するかどうかを指定します。
    # 設定可能な値:
    #   - true: CMKを使用して暗号化
    #   - false (デフォルト): CMKを使用しない
    customer_managed_key_enabled = true

    # kms_key_arn (Optional)
    # 設定内容: 暗号化に使用するKMSキーのARNを指定します。
    # 設定可能な値: 有効なKMSキーARN
    # 注意: customer_managed_key_enabledがtrueの場合に指定が推奨されます
    kms_key_arn = "arn:aws:kms:ap-northeast-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/verified-access/latest/ug/create-verified-access-group.html
  tags = {
    Name        = "sales-verified-access-group"
    Environment = "production"
    Department  = "sales"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - creation_time: アクセスグループが作成されたタイムスタンプ
#
# - deletion_time: アクセスグループが削除されたタイムスタンプ
#
# - id: Verified AccessグループのID（verifiedaccess_group_idと同じ値）
#
# - last_updated_time: アクセスグループが最後に更新されたタイムスタンプ
#
# - owner: このリソースを所有するAWSアカウント番号
#
# - verifiedaccess_group_arn: このVerified AccessグループのAmazon Resource Name (ARN)
#
# - verifiedaccess_group_id: このVerified AccessグループのID
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
