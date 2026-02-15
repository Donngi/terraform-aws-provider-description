#-------
# CloudFront Key Value Store
#-------
# Provider Version: 6.28.0
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_key_value_store
# Generated: 2026-02-12
#
# NOTE:
# CloudFront Key Value Storeは、CloudFront Functionsからアクセス可能な
# 低レイテンシのグローバルキーバリューストアです。エッジロケーションで
# 高速なデータ参照が必要な設定やマッピング情報の管理に使用します。
#
# ユースケース:
# - CloudFront Functionsからアクセス可能な低レイテンシのキーバリューストア
# - リージョン間で自動レプリケーションされるグローバルデータストア
# - エッジロケーションでの高速なデータ参照が必要な設定やマッピング情報の管理
# - A/Bテスト、フィーチャーフラグ、地域別設定などの動的コンテンツ配信制御
#
# 注意事項:
# - CloudFront Functionsとの統合が必須（単独では使用できない）
# - データの更新はPutKey APIまたはImportSource APIを使用
# - 最大ストレージサイズは1MB（キー数は最大1000個）
# - キーと値のサイズ制限あり（キー最大512バイト、値最大1KB）
# - グローバルに複製されるためデータの整合性には若干の遅延が発生する可能性
# - 削除には約30秒の伝播時間が必要
#
# 前提リソース:
# - なし（単独で作成可能だが、CloudFront Functionsとの紐付けが必要）
#
# 関連リソース:
# - aws_cloudfront_function: Key Value Storeを参照するFunctionの定義
# - aws_cloudfront_distribution: CloudFront Functionsを関連付けるディストリビューション

#-------
# 基本設定
#-------
resource "aws_cloudfront_key_value_store" "example" {
  # 設定内容: Key Value Storeの一意の名前
  # 制約事項:
  # - 1〜64文字の英数字、ハイフン、アンダースコアのみ使用可能
  # - AWS アカウント内で一意である必要がある
  # - 作成後の変更は新しいリソースの作成を強制
  name = "example-kvs"

  # 設定内容: Key Value Storeの説明文やメモ
  # 制約事項: 最大128文字
  # 省略時: 説明なし
  comment = "Example Key Value Store for CloudFront Functions"

  #-------
  # タイムアウト設定
  #-------
  # 設定内容: リソース作成時のタイムアウト時間
  # 省略時: 30s
  # timeouts {
  #   create = "2m"
  # }
}

#-------
# Attributes Reference（参照専用の出力値）
#-------
# arn               - Key Value StoreのARN
# etag              - 現在のバージョンを示すETagハッシュ値
# id                - Key Value StoreのリソースID
# last_modified_time - 最終更新日時（ISO 8601形式）
#
# 出力例:
# output "kvs_arn" {
#   value = aws_cloudfront_key_value_store.example.arn
# }
