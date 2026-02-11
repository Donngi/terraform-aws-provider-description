#---------------------------------------------------------------
# Amazon FSx for Lustre Data Repository Association
#---------------------------------------------------------------
#
# FSx for LustreファイルシステムとAmazon S3データリポジトリ間の
# リンクを管理するリソースです。Data Repository Association（DRA）により、
# ファイルシステムとS3バケット間でデータとメタデータの自動インポート/
# エクスポートが可能になります。
#
# 注意事項:
#   - PERSISTENT_2デプロイメントタイプのFSx for Lustreファイルシステムでのみ利用可能
#   - 同じS3バケットを同じファイルシステムに複数回リンクすることはできません
#   - ファイルシステムパスは重複不可（例: /ns1/ と /ns1/ns2/ は共存不可）
#
# AWS公式ドキュメント:
#   - Data Repository Association: https://docs.aws.amazon.com/fsx/latest/APIReference/API_DataRepositoryAssociation.html
#   - CreateDataRepositoryAssociation: https://docs.aws.amazon.com/fsx/latest/APIReference/API_CreateDataRepositoryAssociation.html
#   - Linking file system to S3 bucket: https://docs.aws.amazon.com/fsx/latest/LustreGuide/create-dra-linked-data-repo.html
#   - Automatically export updates: https://docs.aws.amazon.com/fsx/latest/LustreGuide/autoexport-data-repo-dra.html
#   - Automatically import updates: https://docs.aws.amazon.com/fsx/latest/LustreGuide/autoimport-data-repo-dra.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/fsx_data_repository_association
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_fsx_data_repository_association" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # FSx for LustreファイルシステムのID
  # Data Repository Associationを作成する対象のファイルシステム
  # 例: "fs-0123456789abcdef0"
  # 要件: PERSISTENT_2デプロイメントタイプである必要があります
  file_system_id = "fs-XXXXXXXXXXXXXXXXX"

  # S3データリポジトリのパス
  # ファイルシステムとリンクするS3バケットまたはプレフィックスへのパス
  # 形式: s3://bucket-name/ または s3://bucket-name/prefix/
  # 制約:
  #   - 同じS3バケットを同じファイルシステムに複数回リンク不可
  #   - S3バケットとファイルシステムは同じAWSリージョンに存在する必要あり
  # 例: "s3://my-fsx-data-bucket/" または "s3://my-bucket/fsx-data/"
  data_repository_path = "s3://example-bucket/"

  # ファイルシステム上のパス
  # data_repository_pathと1対1でマッピングされるファイルシステム上のディレクトリパス
  # 形式: /で始まる高レベルディレクトリ（/ns1/）またはサブディレクトリ（/ns1/subdir/）
  # 制約:
  #   - 先頭の / は必須
  #   - 2つのDRAで重複するパスは設定不可（/ns1/ と /ns1/ns2/ は共存不可）
  #   - 1つのディレクトリは1つのS3バケットにのみリンク可能
  # 例: "/my-mount-point" または "/production/data"
  file_system_path = "/example"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # DRA作成時にメタデータインポートタスクを実行するかどうか
  # true: DRA作成後、データリポジトリからファイルシステムへメタデータを
  #       インポートするタスクを自動実行
  # false（デフォルト）: 自動実行しない
  # 用途: 既存のS3データをファイルシステムに即座に反映させたい場合に有効化
  # batch_import_meta_data_on_create = false

  # DRA削除時にファイルシステムからファイルを削除するかどうか
  # true: DRA削除時、file_system_path配下のファイルをファイルシステムから削除
  # false（デフォルト）: ファイルシステム上のファイルは保持
  # 注意: trueに設定すると、DRA削除時にデータが失われる可能性があります
  # delete_data_in_filesystem = false

  # インポートされたファイルのチャンクサイズ（MiB単位）
  # データリポジトリからインポートされるファイルの、単一の物理ディスクに
  # 保存される最大データ量とストライプカウントを決定します
  # 値の範囲: 1-512000 MiB
  # デフォルト: ファイルシステムの設定に基づく自動計算値
  # 用途: ファイルのストライピング戦略を最適化する場合に指定
  # 制約: ファイルがストライプできる最大ディスク数はファイルシステムの
  #       総ディスク数に制限されます
  # imported_file_chunk_size = 1024

  # リソースのタグ
  # Data Repository Associationに割り当てるキー・バリューペアのタグ
  # プロバイダーレベルのdefault_tagsと併用可能
  # tags = {
  #   Name        = "my-fsx-dra"
  #   Environment = "production"
  #   Project     = "data-analytics"
  # }

  # リージョンの明示的指定（オプション）
  # このリソースが管理されるAWSリージョン
  # 未指定の場合、プロバイダー設定のリージョンを使用
  # 通常は指定不要（プロバイダー設定に従う）
  # region = "us-west-2"

  #---------------------------------------------------------------
  # S3設定ブロック（オプション）
  #---------------------------------------------------------------

  # S3データリポジトリの自動インポート/エクスポート設定
  # FSx for LustreファイルシステムとS3バケット間でファイルイベントを
  # 自動的に同期する設定を定義します
  s3 {
    # 自動エクスポートポリシー
    # ファイルシステムからS3バケットへ自動的にエクスポートされる
    # 更新オブジェクトのタイプを指定
    auto_export_policy {
      # エクスポート対象のファイルイベント
      # 有効な値: "NEW", "CHANGED", "DELETED"
      # - NEW: 新しいファイル、ディレクトリ、シンボリックリンクが作成された時
      # - CHANGED: 既存のファイルが変更された時（ファイルを閉じる必要あり）
      # - DELETED: ファイル、ディレクトリ、シンボリックリンクが削除された時
      # 推奨: ["NEW", "CHANGED", "DELETED"] - すべての変更を確実にエクスポート
      # 最大3つまで指定可能
      events = ["NEW", "CHANGED", "DELETED"]
    }

    # 自動インポートポリシー
    # S3バケットからファイルシステムへ自動的にインポートされる
    # 更新オブジェクトのタイプを指定
    auto_import_policy {
      # インポート対象のファイルイベント
      # 有効な値: "NEW", "CHANGED", "DELETED"
      # - NEW: S3に新しいオブジェクトが追加された時
      # - CHANGED: S3の既存オブジェクトが変更された時
      # - DELETED: S3のオブジェクトが削除された時
      # 推奨: ["NEW", "CHANGED", "DELETED"] - すべての変更を確実にインポート
      # 最大3つまで指定可能
      # 注意:
      #   - ファイルシステムとS3バケットは同じAWSリージョンに存在する必要あり
      #   - ライフサイクル期限切れ削除などのS3アクションは同期されません
      #   - メタデータ変更の遅延が14日を超えるとDRAはMISCONFIGUREDになります
      events = ["NEW", "CHANGED", "DELETED"]
    }
  }

  #---------------------------------------------------------------
  # タイムアウト設定（オプション）
  #---------------------------------------------------------------

  # 各操作のタイムアウト時間を指定
  # timeouts {
  #   # DRA作成のタイムアウト（デフォルト: 10分）
  #   create = "10m"
  #
  #   # DRA更新のタイムアウト（デフォルト: 10分）
  #   update = "10m"
  #
  #   # DRA削除のタイムアウト（デフォルト: 10分）
  #   delete = "10m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------------------------------
#
# 以下の属性はリソース作成後に参照可能です（入力不可）:
#
# - arn
#     Data Repository AssociationのAmazon Resource Name（ARN）
#     形式: arn:aws:fsx:region:account-id:association/file-system-id/association-id
#
# - association_id
#     Data Repository Associationの一意識別子
#     形式: dra-0123456789abcdef0
#     用途: DRAの参照、更新、削除時に使用
#
# - id
#     TerraformリソースID（association_idと同じ値）
#
# - tags_all
#     リソースに割り当てられた全タグのマップ
#     プロバイダーのdefault_tagsから継承されたタグを含む
#
#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------
#
# 出力例:
# output "dra_id" {
#   description = "Data Repository Association ID"
#   value       = aws_fsx_data_repository_association.example.association_id
# }
#
# output "dra_arn" {
#   description = "Data Repository Association ARN"
#   value       = aws_fsx_data_repository_association.example.arn
# }
#
#---------------------------------------------------------------
