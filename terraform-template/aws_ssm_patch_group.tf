#---------------------------------------------------------------
# SSM Patch Group
#---------------------------------------------------------------
#
# AWS Systems Manager Patch Managerのパッチグループを作成し、パッチベースラインに
# 登録するためのリソースです。パッチグループを使用することで、管理対象ノードを
# 論理的にグループ化し、特定のパッチベースラインを適用できます。
#
# パッチグループは、管理対象ノードに "Patch Group" または "PatchGroup" タグを
# 付与することで定義されます。このリソースは、そのパッチグループ名をパッチ
# ベースラインに関連付けます。
#
# 注意: パッチポリシーを使用する場合、パッチグループ機能は使用されません。
# パッチグループは、2022年12月22日のパッチポリシーリリース前から使用していた
# アカウント・リージョンペアでのみコンソールでサポートされています。
#
# AWS公式ドキュメント:
#   - Creating and managing patch groups: https://docs.aws.amazon.com/systems-manager/latest/userguide/patch-manager-tag-a-patch-group.html
#   - RegisterPatchBaselineForPatchGroup API: https://docs.aws.amazon.com/systems-manager/latest/userguide/example_ssm_RegisterPatchBaselineForPatchGroup_section.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_patch_group
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ssm_patch_group" "example" {
  #---------------------------------------------------------------
  # パッチベースライン設定
  #---------------------------------------------------------------

  # baseline_id (Required)
  # 設定内容: パッチグループを登録するパッチベースラインのIDを指定します。
  # 設定可能な値: 有効なパッチベースラインID（例: pb-0123456789abcdef0）
  # 関連機能: パッチベースライン
  #   パッチベースラインは、管理対象ノードにインストールする承認済みパッチを定義します。
  #   承認済みパッチは個別に指定するか、自動承認ルールで指定できます。
  #   - https://docs.aws.amazon.com/systems-manager/latest/userguide/patch-manager-create-a-patch-baseline.html
  # 参考: aws_ssm_patch_baselineリソースのidを参照することが一般的です。
  baseline_id = "pb-0123456789abcdef0"

  #---------------------------------------------------------------
  # パッチグループ設定
  #---------------------------------------------------------------

  # patch_group (Required)
  # 設定内容: パッチベースラインに登録するパッチグループの名前を指定します。
  # 設定可能な値: 任意の文字列（管理対象ノードのPatch Group/PatchGroupタグの値と一致する必要あり）
  # 関連機能: パッチグループ
  #   パッチグループは、管理対象ノードに "Patch Group" または "PatchGroup" タグを
  #   付与することで定義されます。パッチグループをパッチベースラインに登録することで、
  #   パッチング操作時に正しいパッチがインストールされることを保証します。
  #   - https://docs.aws.amazon.com/systems-manager/latest/userguide/patch-manager-tag-a-patch-group.html
  # 注意: EC2インスタンスメタデータでタグの使用を許可している場合は、
  #       スペースなしの "PatchGroup" タグキーを使用する必要があります。
  patch_group = "production-servers"

  #---------------------------------------------------------------
  # リージョン設定
  #---------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #---------------------------------------------------------------
  # リソースID
  #---------------------------------------------------------------

  # id (Optional)
  # 設定内容: リソースのIDを指定します。通常は明示的に指定する必要はありません。
  # 省略時: Terraformによって自動的に計算されます（フォーマット: "{patch_group},{baseline_id}"）
  # 注意: このパラメータは通常、Terraformによって自動管理されるため設定不要です。
  id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: パッチグループ名とパッチベースラインIDをカンマ区切りで結合した文字列
#       フォーマット: "{patch_group},{baseline_id}"
#       例: "production-servers,pb-0123456789abcdef0"
#---------------------------------------------------------------
