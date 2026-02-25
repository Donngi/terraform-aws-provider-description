#-------
# Amazon FSx Data Repository Association
#-------
# Provider Version: 6.28.0
# Generated: 2026-02-17
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/fsx_data_repository_association
#
# 用途: FSx for LustreファイルシステムとS3バケット間のデータ同期設定
# ドキュメント: https://docs.aws.amazon.com/fsx/latest/LustreGuide/create-dra-linked-data-repo.html
#
# 主な機能:
# - S3バケットとFSx Lustreファイルシステム間の双方向データ同期
# - 自動インポート/エクスポートポリシーの設定
# - ファイルメタデータの自動同期
# - ファイルシステムとデータリポジトリのパスマッピング
#
# 前提条件:
# - FSx for Lustre File System (PERSISTENT_2デプロイタイプのみ対応)
# - S3バケットとファイルシステムは同一リージョンに存在すること
# - 最大8つのデータリポジトリ関連付けを作成可能
# - 重複するファイルシステムパスは設定不可
#
# NOTE: Data Repository Associationsはaws FSx for Lustre File SystemsおよびPERSISTENT_2デプロイタイプのみ対応
#
# 注意事項:
# - 同じS3バケットを同じファイルシステムに複数回リンク不可
# - ファイルシステムバックアップが有効な場合は作成不可
# - 削除時に自動エクスポートキューが空でない場合、データ損失の可能性あり
# - 自動インポート/エクスポートの遅延が14日を超えるとMISCONFIGURED状態になる
#-------

#-------
# 基本設定
#-------
resource "aws_fsx_data_repository_association" "example" {
  # 設定内容: FSx Lustreファイルシステムの識別子
  # 設定可能な値: 有効なFSx Lustreファイルシステムid (PERSISTENT_2デプロイタイプのみ)
  file_system_id = "fs-0123456789abcdef0"

  # 設定内容: S3データリポジトリへのパス
  # 設定可能な値: s3://バケット名/プレフィックス/ 形式
  # 注意: 同じS3バケットを同じファイルシステムに複数回リンク不可
  data_repository_path = "s3://my-bucket/my-prefix/"

  # 設定内容: ファイルシステム上のマウントパス
  # 設定可能な値: /ns1/ のような最上位ディレクトリ、または /ns1/subdir/ のようなサブディレクトリ
  # 注意: 先頭のスラッシュは必須、重複するパスは設定不可
  file_system_path = "/my-bucket"

  #-------
  # インポート設定
  #-------
  # 設定内容: データリポジトリ関連付け作成時にメタデータインポートタスクを実行するかどうか
  # 設定可能な値: true (実行する) / false (実行しない)
  # 省略時: false
  batch_import_meta_data_on_create = false

  # 設定内容: データリポジトリからインポートされたファイルのストライプ数と物理ディスクあたりの最大データ量 (MiB)
  # 設定可能な値: 1〜512000 (MiB単位)
  # 注意: ファイルシステムを構成する物理ディスクの総数によって制限される
  imported_file_chunk_size = 1024

  #-------
  # 削除時の動作設定
  #-------
  # 設定内容: データリポジトリ関連付けの削除時にファイルシステムからファイルを削除するかどうか
  # 設定可能な値: true (削除する) / false (削除しない)
  # 省略時: false
  delete_data_in_filesystem = false

  #-------
  # S3連携設定
  #-------
  s3 {
    # 自動エクスポートポリシー設定
    auto_export_policy {
      # 設定内容: ファイルシステムからS3バケットへ自動エクスポートするイベントタイプ
      # 設定可能な値: NEW (新規作成) / CHANGED (変更) / DELETED (削除) の組み合わせ (最大3つ)
      # 推奨: すべてのイベントタイプを設定してデータの一貫性を確保
      # 注意: FSx for Lustre 2.10およびScratch 1ファイルシステムでは利用不可
      events = ["NEW", "CHANGED", "DELETED"]
    }

    # 自動インポートポリシー設定
    auto_import_policy {
      # 設定内容: S3バケットからファイルシステムへ自動インポートするイベントタイプ
      # 設定可能な値: NEW (新規作成) / CHANGED (変更) / DELETED (削除) の組み合わせ (最大3つ)
      # 推奨: すべてのイベントタイプを設定してデータの一貫性を確保
      # 注意: S3ライフサイクルによる削除、バージョン削除、復元は同期されない
      events = ["NEW", "CHANGED", "DELETED"]
    }
  }

  #-------
  # リージョン設定
  #-------
  # 設定内容: リソースを管理するAWSリージョン
  # 設定可能な値: 有効なAWSリージョン識別子 (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョン
  region = "us-east-1"

  #-------
  # タグ設定
  #-------
  tags = {
    Name        = "my-fsx-dra"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  #-------
  # タイムアウト設定
  #-------
  timeouts {
    # 設定内容: データリポジトリ関連付け作成時の最大待機時間
    # 設定可能な値: 時間文字列 (例: 10m, 1h)
    create = "10m"

    # 設定内容: データリポジトリ関連付け更新時の最大待機時間
    # 設定可能な値: 時間文字列 (例: 10m, 1h)
    update = "10m"

    # 設定内容: データリポジトリ関連付け削除時の最大待機時間
    # 設定可能な値: 時間文字列 (例: 10m, 1h)
    delete = "10m"
  }
}

#-------
# Attributes Reference
#-------
# arn: データリポジトリ関連付けのARN
# association_id: データリポジトリ関連付けの一意な識別子 (例: dra-0123456789abcdef0)
# id: データリポジトリ関連付けの識別子 (association_idと同値)
# tags_all: リソースに割り当てられたすべてのタグ (プロバイダーのdefault_tagsを含む)
