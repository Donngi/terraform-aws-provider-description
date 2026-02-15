####################################################################################
# Terraform AWS Resource: aws_cloudfrontkeyvaluestore_key
# Provider Version: 6.28.0
# Generated: 2026-02-12
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/cloudfrontkeyvaluestore_key
#
# NOTE:
#   このテンプレートは AWS Provider 6.28.0 のスキーマから生成されています。
#   実際の使用時は、プロジェクトの要件に応じて適切にカスタマイズしてください。
#
# リソース概要:
#   CloudFront KeyValueStore にキーバリューペアを格納するためのリソース。
#   エッジロケーションでの低遅延なキーバリューストレージとして使用され、
#   CloudFront Functions から参照可能なデータを管理する。
#
# 主要用途:
#   - エッジロケーションでの設定データ管理
#   - CloudFront Functions からのデータ参照
#   - A/Bテストやパーソナライゼーション用のデータ格納
#   - 低遅延が求められるキーバリューデータの管理
#
# 制約事項:
#   - KeyValueStore は事前に作成済みである必要がある
#   - キーと値は文字列型のみサポート
#   - 値のサイズ制限に注意（total_size_in_bytes で確認可能）
#   - キーは一意である必要がある
#
# 依存関係:
#   - aws_cloudfrontkeyvaluestore: KeyValueStore 本体の作成
#   - CloudFront Functions: データ参照元
#
####################################################################################

resource "aws_cloudfrontkeyvaluestore_key" "example" {
  #-----------------------------------------------------------------------
  # 基本設定
  #-----------------------------------------------------------------------
  # key: KeyValueStore のキー名
  # 設定内容: キーバリューストアに格納するキーの名前
  # 設定可能な値: 任意の文字列（一意である必要がある）
  # 省略時: エラー（必須項目）
  key = "user-preference"

  # key_value_store_arn: 対象の KeyValueStore の ARN
  # 設定内容: キーを格納する KeyValueStore リソースの ARN
  # 設定可能な値: aws_cloudfrontkeyvaluestore リソースの ARN
  # 省略時: エラー（必須項目）
  key_value_store_arn = aws_cloudfrontkeyvaluestore.example.arn

  # value: キーに関連付ける値
  # 設定内容: キーに対応する値データ（JSON 形式も可）
  # 設定可能な値: 任意の文字列データ
  # 省略時: エラー（必須項目）
  value = jsonencode({
    theme    = "dark"
    language = "ja"
    region   = "ap-northeast-1"
  })
}

####################################################################################
# Attributes Reference (参照可能な属性)
####################################################################################
# このリソースから参照可能な主要属性:
#
# - id: リソースID（非推奨、key を使用推奨）
# - total_size_in_bytes: KeyValueStore 全体のサイズ（バイト単位）
#
# 属性の参照例:
#   aws_cloudfrontkeyvaluestore_key.example.total_size_in_bytes
#
####################################################################################
