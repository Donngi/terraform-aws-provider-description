#---------------------------------------
# Amazon Glacier ボルトロックポリシー
#---------------------------------------
# Amazon Glacierボルトにロックポリシーを適用するリソース。
# ボルトロックポリシーはWORM（Write Once Read Many）モデルを実現し、
# 一度ロックされたポリシーはImmutableとなり変更・削除が不可能になる。
# コンプライアンス要件やデータ保持ポリシーの強制に使用する。
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glacier_vault_lock
#
# NOTE: complete_lock = true に設定するとポリシーがロックされ、
#       以降はTerraformでの変更・削除ができなくなります。
#       本番環境での適用前に必ずポリシー内容を確認してください。

resource "aws_glacier_vault_lock" "example" {
  #---------------------------------------
  # ボルト識別設定
  #---------------------------------------

  # 設定内容: ロックポリシーを適用するGlacierボルトの名前
  # 設定可能な値: 既存のGlacierボルト名
  vault_name = "example-vault"

  #---------------------------------------
  # ロックポリシー設定
  #---------------------------------------

  # 設定内容: ボルトに適用するロックポリシーのJSON文書
  # 設定可能な値: IAMポリシー形式のJSON文字列
  # 注意: ポリシーはComplete Lock前に必ず検証すること
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Deny"
        Principal = "*"
        Action    = "glacier:DeleteArchive"
        Resource  = "arn:aws:glacier:us-east-1:123456789012:vaults/example-vault"
        Condition = {
          NumericLessThanEquals = {
            "glacier:ArchiveAgeInDays" = "365"
          }
        }
      }
    ]
  })

  # 設定内容: ボルトロックポリシーをロック状態にするかどうか
  # 設定可能な値: true（ロック完了・不可逆） / false（試行状態・変更可能）
  # 省略時: 必須項目のため省略不可
  # 注意: true に設定後はポリシーの変更・削除が不可能になる（24時間以内のみ変更可能）
  complete_lock = false

  #---------------------------------------
  # エラーハンドリング設定
  #---------------------------------------

  # 設定内容: リソース削除時のエラーを無視するかどうか
  # 設定可能な値: true / false
  # 省略時: false（削除エラーが発生した場合はエラーを返す）
  # 用途: complete_lock = true でロックされたリソースの削除試行時にエラーを無視する場合に使用
  ignore_deletion_error = false

  #---------------------------------------
  # リージョン設定
  #---------------------------------------

  # 設定内容: このリソースを管理するAWSリージョン
  # 省略時: プロバイダー設定のリージョンが使用される
  region = "us-east-1"
}

#---------------------------------------
# Attributes Reference（参照可能な属性）
#---------------------------------------
# このリソースでは以下の属性が参照可能です:
#
# - id
#   ボルトロックのID（ボルト名と同一）
#
