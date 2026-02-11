#---------------------------------------------------------------
# Amazon Verified Permissions Policy Store Schema
#---------------------------------------------------------------
#
# Amazon Verified Permissions Policy StoreのSchemaをプロビジョニングするリソースです。
# Schemaは、認可リクエストで使用するエンティティタイプとアクションの構造を
# 宣言するもので、ポリシーで参照されるエンティティと属性を検証します。
#
# AWS公式ドキュメント:
#   - Amazon Verified Permissions policy store schema: https://docs.aws.amazon.com/verifiedpermissions/latest/userguide/schema.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/verifiedpermissions_schema
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_verifiedpermissions_schema" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # policy_store_id (Required)
  # 設定内容: SchemaをアタッチするPolicy StoreのIDを指定します。
  # 設定可能な値: 有効なVerified Permissions Policy StoreのID
  # 関連機能: Amazon Verified Permissions Policy Store
  #   Policy Storeは認可モデルとリソースをプロビジョニングするコンテナです。
  #   - https://docs.aws.amazon.com/verifiedpermissions/latest/userguide/schema.html
  policy_store_id = aws_verifiedpermissions_policy_store.example.policy_store_id

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
  # Schema定義
  #-------------------------------------------------------------

  # definition (Required)
  # 設定内容: Schemaの定義を指定します。
  # Schemaには、名前空間、アクション、エンティティタイプが含まれます。
  # アクションは付与可能な権限を定義し、エンティティタイプは属性と型を含むレコードの構造を定義します。
  # 関連機能: Amazon Verified Permissions Schema
  #   Schemaの使用はオプションですが、本番ソフトウェアでは検証のため強く推奨されます。
  #   ポリシーで参照されるエンティティと属性を検証し、タイプミスや誤りを防止します。
  #   - https://docs.aws.amazon.com/verifiedpermissions/latest/userguide/schema.html
  definition {
    # value (Required)
    # 設定内容: SchemaのJSON文字列表現を指定します。
    # 設定可能な値: JSON形式の文字列（jsonencodeを使用して記述）
    # 注意: Schemaには名前空間、エンティティタイプ、アクションを定義する必要があります。
    value = jsonencode({
      "ExampleNamespace" : {
        "entityTypes" : {
          "User" : {
            "shape" : {
              "type" : "Record",
              "attributes" : {
                "department" : {
                  "type" : "String",
                  "required" : false
                },
                "jobLevel" : {
                  "type" : "Long",
                  "required" : false
                }
              }
            }
          },
          "Document" : {
            "shape" : {
              "type" : "Record",
              "attributes" : {
                "owner" : {
                  "type" : "Entity",
                  "name" : "User",
                  "required" : true
                }
              }
            }
          }
        },
        "actions" : {
          "ViewDocument" : {
            "appliesTo" : {
              "principalTypes" : ["User"],
              "resourceTypes" : ["Document"]
            }
          },
          "EditDocument" : {
            "appliesTo" : {
              "principalTypes" : ["User"],
              "resourceTypes" : ["Document"]
            }
          }
        }
      }
    })
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: SchemaのID
#
# - namespaces: このSchemaで参照されるエンティティの名前空間を識別します。
#---------------------------------------------------------------
