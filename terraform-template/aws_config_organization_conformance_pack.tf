# ==========================================
# Terraform Resource: aws_config_organization_conformance_pack
# ==========================================
# Generated: 2026-01-19
# Provider Version: 6.28.0
#
# 【注意事項】
# このテンプレートは生成時点（2026-01-19）の AWS Provider v6.28.0 に基づいています。
# 最新の仕様や詳細については、必ず以下の公式ドキュメントをご確認ください：
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_organization_conformance_pack
# ==========================================

# AWS Config Organization Conformance Pack
# 組織全体の全アカウントに対してコンプライアンスルールを一括デプロイ・管理するリソース
#
# 【重要な前提条件】
# - このリソースは組織の管理アカウントまたは委任された管理者アカウントで作成する必要があります
# - AWS Organizations で全ての機能が有効化されている必要があります（feature_set = "ALL"）
# - excluded_accounts で除外されたアカウント以外の全アカウントに Configuration Recorder が適切な IAM 権限と共に設定されている必要があります
# - 組織サービスアクセス（config-multiaccountsetup.amazonaws.com）が有効化されている必要があります
#
# 公式ドキュメント:
# https://docs.aws.amazon.com/config/latest/developerguide/conformance-pack-organization-apis.html
# https://docs.aws.amazon.com/config/latest/APIReference/API_PutOrganizationConformancePack.html

resource "aws_config_organization_conformance_pack" "example" {
  # ==========================================
  # 必須パラメータ
  # ==========================================

  # name - 組織コンプライアンスパックの名前
  # 型: string (必須)
  # 説明: 組織コンプライアンスパックの名前。文字で始まり、1～128文字の英数字とハイフンを含める必要があります。
  #      この名前は組織内で一意である必要があり、変更すると新しいリソースが作成されます（Forces new resource）。
  # 制約:
  #   - 1～128文字
  #   - 文字で始まる必要がある
  #   - 英数字とハイフン（-）のみ使用可能
  #   - パターン: [a-zA-Z][-a-zA-Z0-9]*
  # 参考: https://docs.aws.amazon.com/config/latest/APIReference/API_OrganizationConformancePack.html
  name = "example-org-conformance-pack"

  # ==========================================
  # オプションパラメータ
  # ==========================================

  # delivery_s3_bucket - コンプライアンスパックテンプレートを保存する S3 バケット
  # 型: string (オプション)
  # 説明: AWS Config が組織コンプライアンスパックのテンプレートや結果を保存する Amazon S3 バケット名。
  #      バケット名は "awsconfigconforms" で始まる必要があります。
  # 制約:
  #   - 最大63文字
  #   - "awsconfigconforms" プレフィックスが必須
  # 参考: https://docs.aws.amazon.com/config/latest/APIReference/API_OrganizationConformancePack.html
  # delivery_s3_bucket = "awsconfigconforms-example-bucket"

  # delivery_s3_key_prefix - S3 バケット内のプレフィックス
  # 型: string (オプション)
  # 説明: Amazon S3 バケット内のプレフィックス（フォルダ構造）。
  #      複数の組織コンプライアンスパックを同じバケットで管理する場合に便利です。
  # 制約:
  #   - 最大1024文字
  # 参考: https://docs.aws.amazon.com/config/latest/APIReference/API_OrganizationConformancePack.html
  # delivery_s3_key_prefix = "conformance-packs/"

  # excluded_accounts - コンプライアンスパックのデプロイから除外するアカウント
  # 型: set(string) (オプション)
  # 説明: 組織コンプライアンスパックのデプロイから除外する AWS アカウント ID のセット。
  #      テストアカウントや特定の要件を持つアカウントを除外する際に使用します。
  # 制約:
  #   - 最大1000アカウント
  #   - 各アカウント ID は12桁の数字
  # 参考: https://docs.aws.amazon.com/config/latest/APIReference/API_OrganizationConformancePack.html
  # excluded_accounts = [
  #   "123456789012",
  #   "234567890123"
  # ]

  # id - リソースの識別子
  # 型: string (オプション、Computed)
  # 説明: Terraform によって管理されるリソース ID。
  #      通常は明示的に設定する必要はなく、自動的に組織コンプライアンスパック名が設定されます。
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_organization_conformance_pack#id
  # id = "example-org-conformance-pack"

  # region - このリソースを管理するリージョン
  # 型: string (オプション、Computed)
  # 説明: このリソースが管理されるリージョン。
  #      指定しない場合はプロバイダー設定のリージョンがデフォルトで使用されます。
  #      組織コンプライアンスパックのデプロイは特定のリージョンに対して行われます。
  # 注意: 組織全体のデプロイであっても、API 呼び出しはリージョン固有です。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # template_body - コンプライアンスパックテンプレートの本体
  # 型: string (オプション、template_s3_uri と競合)
  # 説明: コンプライアンスパックの完全なテンプレート本体を含む文字列。
  #      YAML 形式で AWS Config ルールとパラメータを定義します。
  #      template_s3_uri と同時に指定することはできません（どちらか一方のみ）。
  # 制約:
  #   - 最大51200文字
  #   - YAML 形式
  # 注意: この方法ではドリフト検出ができません
  # 参考:
  #   - https://docs.aws.amazon.com/config/latest/developerguide/conformance-packs.html
  #   - https://github.com/awslabs/aws-config-rules/tree/master/aws-config-conformance-packs
  # template_body = <<-EOT
  #   Parameters:
  #     AccessKeysRotatedParameterMaxAccessKeyAge:
  #       Type: String
  #       Default: "90"
  #   Resources:
  #     IAMPasswordPolicy:
  #       Properties:
  #         ConfigRuleName: IAMPasswordPolicy
  #         Source:
  #           Owner: AWS
  #           SourceIdentifier: IAM_PASSWORD_POLICY
  #       Type: AWS::Config::ConfigRule
  # EOT

  # template_s3_uri - S3 に保存されたテンプレートの URI
  # 型: string (オプション、template_body と競合)
  # 説明: コンプライアンスパックテンプレートが保存されている S3 の場所。
  #      形式: s3://bucketname/prefix
  #      URI が示す S3 バケットは、コンプライアンスパックと同じリージョンに存在する必要があります。
  #      template_body と同時に指定することはできません（どちらか一方のみ）。
  # 制約:
  #   - 最大1024文字
  #   - コンプライアンスパックと同じリージョンの S3 バケットである必要がある
  # 注意: この方法ではドリフト検出ができません
  # 参考: https://docs.aws.amazon.com/config/latest/APIReference/API_PutOrganizationConformancePack.html
  # template_s3_uri = "s3://example-bucket/conformance-pack-template.yaml"

  # ==========================================
  # ネストブロック: input_parameter
  # ==========================================
  # コンプライアンスパックテンプレートに渡す入力パラメータのセット
  # テンプレート内で定義されたパラメータに値を設定する際に使用します。
  # 最大60個のパラメータを設定可能です。
  # 参考: https://docs.aws.amazon.com/config/latest/APIReference/API_ConformancePackInputParameter.html

  # input_parameter {
  #   # parameter_name - パラメータのキー名
  #   # 型: string (必須)
  #   # 説明: コンプライアンスパックテンプレート内で定義されたパラメータ名。
  #   #      テンプレートの Parameters セクションで定義された名前と一致する必要があります。
  #   parameter_name = "AccessKeysRotatedParameterMaxAccessKeyAge"
  #
  #   # parameter_value - パラメータの値
  #   # 型: string (必須)
  #   # 説明: パラメータに設定する値。テンプレート内のパラメータ型に応じた適切な値を指定します。
  #   parameter_value = "90"
  # }

  # 複数のパラメータを設定する例:
  # input_parameter {
  #   parameter_name  = "RequiredTagKey"
  #   parameter_value = "Environment"
  # }
  #
  # input_parameter {
  #   parameter_name  = "RequiredTagValue"
  #   parameter_value = "Production"
  # }

  # ==========================================
  # ネストブロック: timeouts
  # ==========================================
  # リソース操作のタイムアウト設定
  # 組織全体へのデプロイには時間がかかる場合があるため、適切なタイムアウトを設定できます。

  # timeouts {
  #   # create - 作成操作のタイムアウト
  #   # 型: string (オプション)
  #   # 説明: リソース作成時の最大待機時間。
  #   #      組織のアカウント数が多い場合、デプロイに時間がかかる可能性があります。
  #   # デフォルト: 設定されていない場合はプロバイダーのデフォルト値が使用されます
  #   # 形式: "30m", "1h" など
  #   create = "30m"
  #
  #   # update - 更新操作のタイムアウト
  #   # 型: string (オプション)
  #   # 説明: リソース更新時の最大待機時間。
  #   # デフォルト: 設定されていない場合はプロバイダーのデフォルト値が使用されます
  #   # 形式: "30m", "1h" など
  #   update = "30m"
  #
  #   # delete - 削除操作のタイムアウト
  #   # 型: string (オプション)
  #   # 説明: リソース削除時の最大待機時間。
  #   #      全アカウントからのコンプライアンスパック削除には時間がかかる場合があります。
  #   # デフォルト: 設定されていない場合はプロバイダーのデフォルト値が使用されます
  #   # 形式: "30m", "1h" など
  #   delete = "30m"
  # }
}

# ==========================================
# Computed 属性（読み取り専用）
# ==========================================
# 以下の属性は Terraform によって自動的に設定され、参照のみ可能です:
#
# - arn (string): 組織コンプライアンスパックの Amazon Resource Name (ARN)
#     他のリソースで参照する際に使用可能
#     例: aws_config_organization_conformance_pack.example.arn

# ==========================================
# 使用例とベストプラクティス
# ==========================================

# 例1: テンプレート本体を直接指定する方法
# resource "aws_config_organization_conformance_pack" "example_inline" {
#   name = "security-baseline"
#
#   template_body = <<-EOT
#     Parameters:
#       AccessKeysRotatedParameterMaxAccessKeyAge:
#         Type: String
#         Default: "90"
#     Resources:
#       IAMPasswordPolicy:
#         Properties:
#           ConfigRuleName: IAMPasswordPolicy
#           Source:
#             Owner: AWS
#             SourceIdentifier: IAM_PASSWORD_POLICY
#         Type: AWS::Config::ConfigRule
#       AccessKeysRotated:
#         Properties:
#           ConfigRuleName: AccessKeysRotated
#           Source:
#             Owner: AWS
#             SourceIdentifier: ACCESS_KEYS_ROTATED
#         Type: AWS::Config::ConfigRule
#   EOT
#
#   input_parameter {
#     parameter_name  = "AccessKeysRotatedParameterMaxAccessKeyAge"
#     parameter_value = "90"
#   }
#
#   depends_on = [
#     aws_config_configuration_recorder.example,
#     aws_organizations_organization.example
#   ]
# }

# 例2: S3 に保存されたテンプレートを使用する方法（推奨）
# resource "aws_config_organization_conformance_pack" "example_s3" {
#   name            = "compliance-pack-from-s3"
#   template_s3_uri = "s3://${aws_s3_bucket.conformance_packs.bucket}/templates/security-baseline.yaml"
#
#   delivery_s3_bucket     = aws_s3_bucket.config_delivery.bucket
#   delivery_s3_key_prefix = "organization-conformance-packs/"
#
#   excluded_accounts = [
#     "123456789012"  # テストアカウント
#   ]
#
#   depends_on = [
#     aws_config_configuration_recorder.example,
#     aws_organizations_organization.example
#   ]
# }

# 例3: AWS Organizations と Configuration Recorder のセットアップ
# resource "aws_organizations_organization" "example" {
#   aws_service_access_principals = [
#     "config-multiaccountsetup.amazonaws.com"
#   ]
#   feature_set = "ALL"
# }
#
# resource "aws_config_configuration_recorder" "example" {
#   name     = "example-recorder"
#   role_arn = aws_iam_role.config.arn
#
#   recording_group {
#     all_supported = true
#   }
# }

# ==========================================
# 注意事項とトラブルシューティング
# ==========================================
# 1. 新しいアカウントが組織に追加された場合、レコーダーが利用可能でない場合は7時間まで自動リトライされます
# 2. 委任された管理者がデプロイした組織ルールやコンプライアンスパックは、組織管理アカウントや委任管理者アカウントには表示されません
# 3. 組織管理アカウントと委任管理者の両方を使用する場合、サービスリンクロール (SLR) を IAM を使用して個別に手動作成する必要があります
# 4. template_body または template_s3_uri を使用する場合、ドリフト検出は機能しません
# 5. すべてのメンバーアカウント（excluded_accounts で除外されたアカウントを除く）に Configuration Recorder が設定されている必要があります
#
# サポート対象リージョン: https://docs.aws.amazon.com/config/latest/developerguide/conformance-pack-organization-apis.html
# サンプルテンプレート: https://github.com/awslabs/aws-config-rules/tree/master/aws-config-conformance-packs
