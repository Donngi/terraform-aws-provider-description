#---------------------------------------------------------------
# Amazon Verified Permissions Policy Store
#---------------------------------------------------------------
#
# Amazon Verified Permissionsのポリシーストアをプロビジョニングするリソースです。
# ポリシーストアは、ポリシーとポリシーテンプレートを格納するコンテナであり、
# アプリケーションの認可決定を管理します。各ポリシーストアには、ポリシー検証用の
# スキーマを作成でき、ポリシー検証を有効にすることで、スキーマに対して
# ポリシーを検証し、無効なポリシーを拒否できます。
#
# AWS公式ドキュメント:
#   - Amazon Verified Permissions policy stores: https://docs.aws.amazon.com/verifiedpermissions/latest/userguide/policy-stores.html
#   - Creating Verified Permissions policy stores: https://docs.aws.amazon.com/verifiedpermissions/latest/userguide/policy-stores-create.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/verifiedpermissions_policy_store
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_verifiedpermissions_policy_store" "example" {
  #-------------------------------------------------------------
  # 検証設定
  #-------------------------------------------------------------

  # validation_settings (Required)
  # 設定内容: ポリシーストアの検証設定を指定します。
  # 説明: ポリシー検証は、ポリシーがスキーマに対して妥当かどうかをチェックし、
  #       無効なポリシーを拒否します。検証を有効にすることで、ポリシーの一貫性を
  #       保ち、タイプミスやミスを防ぐことができます。
  # 参考: https://docs.aws.amazon.com/verifiedpermissions/latest/userguide/schema.html
  validation_settings {
    # mode (Required)
    # 設定内容: 検証設定のモードを指定します。
    # 設定可能な値:
    #   - "OFF": ポリシー検証を無効化。スキーマなしでポリシーを作成可能
    #   - "STRICT": ポリシー検証を有効化。すべてのポリシーがスキーマに対して検証される
    # 関連機能: Policy Validation
    #   STRICTモードでは、スキーマに定義されたエンティティタイプとアクションに対して
    #   ポリシーが参照する属性やアクションが存在することを検証します。
    #   本番環境では検証を有効にすることが強く推奨されます。
    # 参考: https://docs.aws.amazon.com/verifiedpermissions/latest/userguide/schema.html
    mode = "STRICT"
  }

  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: ポリシーストアの説明を指定します。
  # 設定可能な値: 文字列
  # 省略時: 説明なし
  # 用途: ポリシーストアの目的や用途を記録するために使用します。
  #       マルチテナントアプリケーションでは、テナントごとに
  #       ポリシーストアを作成する際の識別に有用です。
  description = "Policy store for my application authorization"

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
  # 削除保護設定
  #-------------------------------------------------------------

  # deletion_protection (Optional)
  # 設定内容: ポリシーストアの削除保護を有効にするかを指定します。
  # 設定可能な値:
  #   - "ENABLED": 削除保護を有効化。ポリシーストアの削除を防止
  #   - "DISABLED" (デフォルト): 削除保護を無効化。ポリシーストアの削除が可能
  # 省略時: "DISABLED"
  # 関連機能: Deletion Protection
  #   ポリシーストアの誤削除を防止する機能。有効化すると、ポリシーストアを
  #   削除できなくなります。削除するには、まず削除保護を無効化する必要があります。
  # 参考: https://docs.aws.amazon.com/verifiedpermissions/latest/userguide/policy-stores.html
  deletion_protection = "DISABLED"

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "my-application-policy-store"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - policy_store_id: ポリシーストアの一意の識別子。
#                    API呼び出しやポリシーの作成時に使用されます。
#
# - arn: ポリシーストアのAmazon Resource Name (ARN)。
#        他のAWSサービスとの統合やIAMポリシーでの参照に使用されます。
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
