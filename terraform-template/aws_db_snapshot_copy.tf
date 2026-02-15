#---------------------------------------
# RDS DBスナップショットコピー
#---------------------------------------
# RDSデータベーススナップショットを別のリージョンまたは別のアカウントにコピーする
# ディザスタリカバリやマルチリージョン展開で使用する
# 暗号化スナップショットのコピーも可能
#
# Provider Version: 6.28.0
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/db_snapshot_copy
# Generated: 2026-02-14
# NOTE: このテンプレートは全属性を網羅した参考実装です。実際の利用時は必要な項目のみ使用してください。

resource "aws_db_snapshot_copy" "example" {
  #-------
  # 必須設定
  #-------
  # 設定内容: コピー元のDBスナップショット識別子
  # 設定可能な値: 既存のDBスナップショットARNまたは識別子
  # 省略時: 指定必須
  source_db_snapshot_identifier = "arn:aws:rds:us-west-2:123456789012:snapshot:source-snapshot-id"

  # 設定内容: コピー先のDBスナップショット識別子
  # 設定可能な値: 1〜255文字の英数字とハイフン（先頭は文字）
  # 省略時: 指定必須
  target_db_snapshot_identifier = "target-snapshot-id"

  #-------
  # 暗号化設定
  #-------
  # 設定内容: コピー先スナップショットの暗号化に使用するKMSキーID
  # 設定可能な値: KMSキーID、ARN、エイリアス
  # 省略時: ソーススナップショットの暗号化設定を継承
  kms_key_id = null

  #-------
  # リージョン・配置設定
  #-------
  # 設定内容: このリソースを管理するAWSリージョン
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1）
  # 省略時: プロバイダー設定のリージョン
  region = null

  # 設定内容: コピー先のAWSリージョン
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1）
  # 省略時: プロバイダー設定のリージョン
  destination_region = null

  # 設定内容: コピー先のカスタムアベイラビリティーゾーン
  # 設定可能な値: 既存のカスタムAZ識別子
  # 省略時: 標準AZが使用される
  target_custom_availability_zone = null

  #-------
  # クロスリージョンコピー設定
  #-------
  # 設定内容: クロスリージョンコピー用の事前署名URL
  # 設定可能な値: RDS APIで生成された事前署名URL
  # 省略時: destination_regionが指定された場合は自動生成
  presigned_url = null

  #-------
  # オプショングループ設定
  #-------
  # 設定内容: コピー先スナップショットに関連付けるオプショングループ名
  # 設定可能な値: 既存のオプショングループ名
  # 省略時: ソーススナップショットのオプショングループを継承
  option_group_name = null

  #-------
  # タグ設定
  #-------
  # 設定内容: ソーススナップショットからタグをコピーするかどうか
  # 設定可能な値: true（コピーする）、false（コピーしない）
  # 省略時: false
  copy_tags = null

  # 設定内容: リソースに付与するタグ
  # 設定可能な値: キーと値のペア（最大50タグ）
  # 省略時: タグなし
  tags = {
    Name        = "example-snapshot-copy"
    Environment = "production"
  }

  #-------
  # 共有設定
  #-------
  # 設定内容: スナップショットを共有するAWSアカウントIDのリスト
  # 設定可能な値: 12桁のAWSアカウントID（複数指定可能）
  # 省略時: 共有なし
  shared_accounts = null

  #-------
  # タイムアウト設定
  #-------
  timeouts {
    # 設定内容: スナップショットコピーの作成タイムアウト
    # 設定可能な値: 時間文字列（例: 30m、1h、2h30m）
    # 省略時: 20m
    create = null
  }
}

#---------------------------------------
# Attributes Reference（参照可能な属性）
#---------------------------------------
# スナップショット識別情報
# - id: スナップショット識別子
# - db_snapshot_arn: スナップショットのARN
#
# ストレージ情報
# - allocated_storage: 割り当てられたストレージサイズ（GB）
# - storage_type: ストレージタイプ（gp2、gp3、io1、io2等）
# - iops: プロビジョンドIOPS値
# - encrypted: 暗号化の有効/無効
#
# データベース情報
# - engine: DBエンジン（mysql、postgres等）
# - engine_version: DBエンジンバージョン
# - license_model: ライセンスモデル
# - port: データベースポート番号
#
# 配置情報
# - availability_zone: アベイラビリティーゾーン
# - vpc_id: VPC ID
# - source_region: ソースリージョン
#
# その他
# - snapshot_type: スナップショットタイプ（manual、automated等）
# - tags_all: リソースに付与された全タグ（プロバイダーデフォルトタグを含む）
