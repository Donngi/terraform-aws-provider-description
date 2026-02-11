#---------------------------------------------------------------
# AWS Systems Manager Parameter Store パラメータ
#---------------------------------------------------------------
#
# AWS Systems Manager Parameter Storeで設定データやシークレットを安全に保存・管理するための
# パラメータリソースをプロビジョニングします。String、StringList、SecureStringの3種類の
# パラメータタイプをサポートし、階層構造での整理やバージョン管理が可能です。
#
# AWS公式ドキュメント:
#   - Parameter Store: https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-parameter-store.html
#   - Parameter API Reference: https://docs.aws.amazon.com/systems-manager/latest/APIReference/API_Parameter.html
#   - SecureString暗号化: https://docs.aws.amazon.com/systems-manager/latest/userguide/secure-string-parameter-kms-encryption.html
#   - パラメータの作成: https://docs.aws.amazon.com/systems-manager/latest/userguide/parameter-create-console.html
#   - パラメータ名の制約: https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-parameter-name-constraints.html
#   - Advanced Parameters: https://docs.aws.amazon.com/systems-manager/latest/userguide/parameter-store-advanced-parameters.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ssm_parameter" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # パラメータ名
  # - パスを含む場合（スラッシュ `/` を含む場合）は、先頭にスラッシュ `/` を付けて
  #   完全修飾名とする必要があります
  # - 階層構造を使用することで、パラメータを論理的にグループ化できます
  #   例: /production/database/password, /dev/api/key
  # - 名前の制約については AWS SSM User Guide を参照してください
  # - 型: string (required)
  name = "/example/parameter/name"

  # パラメータタイプ
  # - String: プレーンテキストのデータ（デフォルト）
  # - StringList: カンマ区切りの値のリスト
  # - SecureString: 暗号化が必要な機密データ（パスワード、APIキーなど）
  # - 型: string (required)
  # - 有効な値: "String", "StringList", "SecureString"
  type = "String"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # 許可パターン（正規表現）
  # - パラメータ値の検証に使用する正規表現を指定します
  # - パラメータ作成・更新時に値がこのパターンに一致するか検証されます
  # - 型: string (optional)
  # allowed_pattern = "^[a-zA-Z0-9]*$"

  # ARN（Amazon Resource Name）
  # - パラメータのARNを指定します
  # - 通常は自動生成されるため、明示的に指定する必要はありません
  # - 型: string (optional, computed)
  # arn = null

  # データタイプ
  # - パラメータのデータタイプを指定します
  # - text: 通常のテキストデータ（デフォルト）
  # - aws:ssm:integration: SSM統合用（webhookパラメータなど）
  # - aws:ec2:image: AMI ID用の特殊なデータタイプ
  # - 型: string (optional, computed)
  # - 有効な値: "text", "aws:ssm:integration", "aws:ec2:image"
  # - 注意: aws:ssm:integrationを使用する場合、typeはSecureStringである必要があり、
  #   名前は /d9d01087-4a3f-49e0-b0b4-d568d7826553/ssm/integrations/webhook/ で始まる必要があります
  # data_type = "text"

  # パラメータの説明
  # - パラメータの用途や内容を説明するテキストを指定します
  # - ドキュメント化やパラメータの目的を明確にするために使用します
  # - 型: string (optional)
  # description = "Example parameter description"

  # ID
  # - パラメータの識別子
  # - 通常はnameと同じ値が自動設定されます
  # - 型: string (optional, computed)
  # id = null

  # 非セキュア値
  # - パラメータの値を指定します（平文）
  # - 注意: この値はTerraform planの出力でセンシティブとしてマークされません
  # - type が SecureString の場合は使用できません
  # - value、value_wo、insecure_value のいずれか1つが必須です
  # - 型: string (optional, computed)
  # - セキュリティ注意: 機密情報には value または value_wo を使用してください
  # insecure_value = "example-value"

  # KMSキーID
  # - SecureStringパラメータの暗号化に使用するKMSキーのIDまたはARNを指定します
  # - 指定しない場合は、デフォルトのSSM KMSキーが使用されます
  # - typeがSecureStringの場合のみ有効です
  # - 型: string (optional, computed)
  # key_id = "alias/aws/ssm"

  # 上書き設定
  # - 既存のパラメータを上書きするかどうかを指定します
  # - 作成時（Terraform管理外の既存パラメータがある場合）: デフォルトfalse
  # - 更新時（Terraform管理下になった後）: デフォルトtrue
  # - Terraform外で作成されたパラメータを取り込む場合にtrueを設定します
  # - 型: bool (optional)
  # - ライフサイクルルールと組み合わせて非標準の更新動作を管理できます
  # overwrite = false

  # リージョン
  # - このリソースが管理されるAWSリージョンを指定します
  # - 指定しない場合は、プロバイダー設定のリージョンが使用されます
  # - 型: string (optional, computed)
  # region = "us-east-1"

  # タグ
  # - パラメータに割り当てるタグのマップを指定します
  # - リソースの識別、コスト配分、アクセス制御などに使用できます
  # - プロバイダーのdefault_tags設定と統合されます
  # - 型: map(string) (optional)
  # tags = {
  #   Environment = "production"
  #   Project     = "example"
  # }

  # 全タグ（プロバイダーのdefault_tagsを含む）
  # - パラメータに割り当てられるすべてのタグ（プロバイダーのdefault_tagsを含む）
  # - 通常は自動的に管理されるため、明示的に指定する必要はありません
  # - 型: map(string) (optional, computed)
  # tags_all = {}

  # パラメータティア
  # - Standard: 最大4KBの値、無料（月間10,000件のAPIコールまで無料）
  # - Advanced: 最大8KBの値、パラメータポリシーのサポート、追加料金が発生
  # - Intelligent-Tiering: 使用パターンに基づいて自動的にティアを最適化
  # - 指定しない場合は、リージョンのデフォルトティア（Standard）が使用されます
  # - 注意: AdvancedからStandardへのダウングレードはリソースの再作成が必要です
  # - 型: string (optional, computed)
  # - 有効な値: "Standard", "Advanced", "Intelligent-Tiering"
  # tier = "Standard"

  # パラメータ値
  # - パラメータの値を指定します（センシティブ）
  # - この値は常にTerraform planの出力でセンシティブとしてマークされます
  # - value、value_wo、insecure_value のいずれか1つが必須です
  # - 型: string (optional, computed, sensitive)
  # - Terraform 0.15以降では、特定のシナリオで追加の設定が必要な場合があります
  # value = "example-value"

  # 書き込み専用パラメータ値
  # - パラメータの値を指定します（書き込み専用、センシティブ）
  # - この値は常にTerraform planの出力でセンシティブとしてマークされます
  # - さらに、write-only値はステートに保存されません（より高いセキュリティ）
  # - value_wo_versionと組み合わせて使用し、更新をトリガーします
  # - value、value_wo、insecure_value のいずれか1つが必須です
  # - 型: string (optional, sensitive, write_only)
  # - 要件: Terraform 1.11.0以降が必要です
  # - value_wo_versionの指定が必須です
  # value_wo = "example-secret-value"

  # 書き込み専用パラメータ値のバージョン
  # - value_woと組み合わせて使用し、パラメータ値の更新をトリガーします
  # - value_woの値を更新する際は、この値をインクリメントしてください
  # - 型: number (optional)
  # value_wo_version = 1
}

#---------------------------------------------------------------
# Attributes Reference（参照専用の出力属性）
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です（computedのみの属性）:
#
# - has_value_wo (bool)
#   リソースにvalue_woが設定されているかどうかを示します
#   例: aws_ssm_parameter.example.has_value_wo
#
# - version (number)
#   パラメータのバージョン番号
#   パラメータが更新されるたびに自動的にインクリメントされます
#   例: aws_ssm_parameter.example.version
#
#---------------------------------------------------------------
# 使用例と注意事項
#---------------------------------------------------------------
#
# 【基本的な使用例】
# resource "aws_ssm_parameter" "basic" {
#   name  = "/myapp/config/database_host"
#   type  = "String"
#   value = "db.example.com"
# }
#
# 【SecureStringの使用例（デフォルトKMSキー）】
# resource "aws_ssm_parameter" "password" {
#   name        = "/production/database/password"
#   description = "Database master password"
#   type        = "SecureString"
#   value       = var.database_password
#
#   tags = {
#     Environment = "production"
#     Sensitive   = "true"
#   }
# }
#
# 【カスタムKMSキーを使用したSecureString】
# resource "aws_kms_key" "parameter_store" {
#   description = "KMS key for Parameter Store"
# }
#
# resource "aws_ssm_parameter" "secure_with_custom_key" {
#   name   = "/myapp/api/key"
#   type   = "SecureString"
#   value  = var.api_key
#   key_id = aws_kms_key.parameter_store.id
# }
#
# 【Advancedティアの使用例（大きな値やパラメータポリシー）】
# resource "aws_ssm_parameter" "large_config" {
#   name  = "/myapp/config/large_json"
#   type  = "String"
#   tier  = "Advanced"
#   value = file("${path.module}/large_config.json")
# }
#
# 【書き込み専用値の使用例（Terraform 1.11.0以降）】
# resource "aws_ssm_parameter" "write_only" {
#   name            = "/myapp/secret"
#   type            = "SecureString"
#   value_wo        = var.secret_value
#   value_wo_version = 1  # 値を更新する際はこの番号をインクリメント
# }
#
# 【既存パラメータの取り込み（overwrite使用）】
# resource "aws_ssm_parameter" "existing" {
#   name      = "/existing/parameter"
#   type      = "String"
#   value     = "new-value"
#   overwrite = true  # Terraform外で作成された既存パラメータを上書き
# }
#
# 【StringListの使用例】
# resource "aws_ssm_parameter" "allowed_ips" {
#   name  = "/myapp/security/allowed_ips"
#   type  = "StringList"
#   value = "10.0.1.0/24,10.0.2.0/24,10.0.3.0/24"
# }
#
# 【正規表現パターンによる検証】
# resource "aws_ssm_parameter" "validated" {
#   name            = "/myapp/version"
#   type            = "String"
#   value           = "1.2.3"
#   allowed_pattern = "^[0-9]+\\.[0-9]+\\.[0-9]+$"  # セマンティックバージョン形式
# }
#
# 【注意事項】
# 1. パラメータタイプの変更
#    - 既存パラメータのtypeは変更できません（リソースの再作成が必要）
#
# 2. ティアのダウングレード
#    - AdvancedからStandardへの変更はリソースの再作成が必要です
#
# 3. 値のサイズ制限
#    - Standard: 最大4KB
#    - Advanced: 最大8KB
#
# 4. SecureStringのセキュリティ
#    - SecureStringにはvalueまたはvalue_woを使用してください
#    - insecure_valueはSecureStringでは使用できません
#
# 5. KMSキーのアクセス許可
#    - SecureStringを使用する場合、適切なKMS権限が必要です
#    - カスタムKMSキーを使用する場合は、kms:Encrypt、kms:Decrypt権限が必要です
#
# 6. コスト
#    - Standardティア: 月間10,000件のAPIコールまで無料
#    - Advancedティア: パラメータごとに月額料金が発生
#
# 7. aws:ssm:integration データタイプ
#    - typeはSecureStringである必要があります
#    - 名前は /d9d01087-4a3f-49e0-b0b4-d568d7826553/ssm/integrations/webhook/ で始まる必要があります
#
# 8. write-only値（value_wo）
#    - Terraform 1.11.0以降が必要です
#    - ステートファイルに値が保存されないため、より高いセキュリティを提供します
#    - value_wo_versionと組み合わせて使用する必要があります
#
#---------------------------------------------------------------
