#---------------------------------------------------------------
# Amazon Verified Permissions Policy
#---------------------------------------------------------------
#
# Amazon Verified Permissionsのポリシーをプロビジョニングするリソースです。
# Verified Permissionsは、きめ細かい認可システムを提供し、Cedar言語で記述された
# ポリシーを使用してアクセス制御を管理します。
# このリソースでは、静的ポリシー（static）またはテンプレートリンクポリシー
# （template_linked）のいずれかを作成できます。
#
# AWS公式ドキュメント:
#   - Amazon Verified Permissions ポリシー: https://docs.aws.amazon.com/verifiedpermissions/latest/userguide/policies.html
#   - ポリシーテンプレート: https://docs.aws.amazon.com/verifiedpermissions/latest/userguide/policy-templates.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/verifiedpermissions_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_verifiedpermissions_policy" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # policy_store_id (Required)
  # 設定内容: ポリシーを作成するポリシーストアのIDを指定します。
  # 設定可能な値: 有効なポリシーストアID
  # 関連機能: Amazon Verified Permissions ポリシーストア
  #   ポリシーストアは、ポリシー、スキーマ、認証設定を保存する
  #   コンテナです。各ポリシーは必ず1つのポリシーストアに属します。
  #   - https://docs.aws.amazon.com/verifiedpermissions/latest/userguide/policy-stores.html
  policy_store_id = "PSEXAMPLEabcdefg111111"

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
  # ポリシー定義
  #-------------------------------------------------------------

  # definition (Required)
  # 設定内容: ポリシーの定義を指定します。
  # 注意: staticまたはtemplate_linkedのいずれか一方のみを指定する必要があります。
  definition {
    #---------------------------------------------------------
    # 静的ポリシー（Static Policy）
    #---------------------------------------------------------
    # 設定内容: Cedar言語で記述された静的なポリシーステートメントを定義します。
    # 用途: 固定的なアクセス制御ルールを定義する場合に使用します。
    # 注意: template_linkedと排他的（どちらか一方のみ指定可能）
    # 関連機能: Amazon Verified Permissions 静的ポリシー
    #   静的ポリシーは、プリンシパル、アクション、リソースを直接指定した
    #   ポリシーです。各ポリシーは独立して評価されます。
    #   - https://docs.aws.amazon.com/verifiedpermissions/latest/userguide/policies.html
    static {
      # statement (Required)
      # 設定内容: Cedar言語で記述されたポリシーステートメントを指定します。
      # 設定可能な値: 有効なCedar言語のポリシーステートメント
      # 例:
      #   - permit (principal, action == Action::"view", resource in Album:: "test_album");
      #   - forbid (principal == User::"alice", action, resource);
      # 関連機能: Cedar ポリシー言語
      #   Cedarは、きめ細かいアクセス制御のための宣言型ポリシー言語です。
      #   permit（許可）またはforbid（拒否）のステートメントで構成されます。
      #   - https://docs.cedarpolicy.com/
      statement = "permit (principal, action == Action::\"view\", resource in Album:: \"test_album\");"

      # description (Optional)
      # 設定内容: 静的ポリシーの説明を指定します。
      # 設定可能な値: 文字列（ポリシーの目的や内容を説明するテキスト）
      # 省略時: 説明なし
      description = null
    }

    #---------------------------------------------------------
    # テンプレートリンクポリシー（Template Linked Policy）
    #---------------------------------------------------------
    # 設定内容: ポリシーテンプレートを使用して動的なポリシーを定義します。
    # 用途: 同じアクセスパターンを複数のプリンシパルとリソースに
    #       適用する場合に使用します。
    # 注意: staticと排他的（どちらか一方のみ指定可能）
    # 関連機能: Amazon Verified Permissions ポリシーテンプレート
    #   ポリシーテンプレートは、プリンシパルやリソースのプレースホルダーを
    #   含むポリシーです。テンプレートの更新は、リンクされた全ポリシーに
    #   自動的に反映されます。
    #   - https://docs.aws.amazon.com/verifiedpermissions/latest/userguide/policy-templates.html
    template_linked {
      # policy_template_id (Required)
      # 設定内容: 使用するポリシーテンプレートのIDを指定します。
      # 設定可能な値: 有効なポリシーテンプレートID
      # 関連機能: ポリシーテンプレート
      #   ポリシーテンプレートには、?principalや?resourceといった
      #   プレースホルダーが含まれ、これらを具体的なエンティティに
      #   バインドしてポリシーを生成します。
      policy_template_id = "PTEXAMPLEabcdefg111111"

      # principal (Optional)
      # 設定内容: ポリシーテンプレートのプリンシパルプレースホルダーに
      #          バインドするエンティティを指定します。
      # 省略時: プリンシパルを指定せずにテンプレートを使用
      # 注意: テンプレートが?principalプレースホルダーを含む場合に指定します
      principal {
        # entity_type (Required)
        # 設定内容: プリンシパルのエンティティタイプを指定します。
        # 設定可能な値: スキーマで定義されたエンティティタイプ（例: User, Role）
        # 例: "User", "Role", "Group"
        entity_type = "User"

        # entity_id (Required)
        # 設定内容: プリンシパルのエンティティIDを指定します。
        # 設定可能な値: 一意のエンティティ識別子（UUIDの使用を推奨）
        # 注意: エンティティIDの再利用による意図しないアクセスを避けるため、
        #       UUIDの使用が推奨されます。
        # 参考: https://docs.aws.amazon.com/verifiedpermissions/latest/userguide/policies.html
        entity_id = "user123"
      }

      # resource (Optional)
      # 設定内容: ポリシーテンプレートのリソースプレースホルダーに
      #          バインドするエンティティを指定します。
      # 省略時: リソースを指定せずにテンプレートを使用
      # 注意: テンプレートが?resourceプレースホルダーを含む場合に指定します
      resource {
        # entity_type (Required)
        # 設定内容: リソースのエンティティタイプを指定します。
        # 設定可能な値: スキーマで定義されたエンティティタイプ（例: Album, Document）
        # 例: "Album", "Document", "Photo"
        entity_type = "Album"

        # entity_id (Required)
        # 設定内容: リソースのエンティティIDを指定します。
        # 設定可能な値: 一意のエンティティ識別子（UUIDの使用を推奨）
        # 注意: エンティティIDの再利用による意図しないアクセスを避けるため、
        #       UUIDの使用が推奨されます。
        # 参考: https://docs.aws.amazon.com/verifiedpermissions/latest/userguide/policies.html
        entity_id = "album456"
      }
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ポリシーのID（Terraform内部で使用）
#
# - policy_id: Amazon Verified Permissionsが割り当てたポリシーID
#
# - created_date: ポリシーが作成された日時
#---------------------------------------------------------------
