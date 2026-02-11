################################################################################
# aws_s3_bucket_intelligent_tiering_configuration
################################################################################
# S3 Intelligent-Tiering設定リソース
# S3バケットに対してIntelligent-Tiering（自動階層化）を設定します。
# アクセスパターンに基づいて、オブジェクトを最もコスト効率の良いストレージ階層に
# 自動的に移動させることができます。
#
# 参考: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/s3_bucket_intelligent_tiering_configuration
# API: https://docs.aws.amazon.com/AmazonS3/latest/API/API_PutBucketIntelligentTieringConfiguration.html
#
# 重要な注意事項:
# - このリソースはS3ディレクトリバケットでは使用できません
# - Archive Access層は最低90日、Deep Archive Access層は最低180日必要です
# - 128KB未満のオブジェクトは監視対象外で、Frequent Access層に留まります
# - 取得料金は発生しません（S3 Intelligent-Tieringの特徴）
################################################################################

resource "aws_s3_bucket_intelligent_tiering_configuration" "this" {
  ################################################################################
  # 必須パラメータ
  ################################################################################

  # bucket - (Required) バケット名
  # この設定を関連付けるS3バケットの名前を指定します。
  # 型: string
  # 例: "my-bucket" または aws_s3_bucket.example.id
  bucket = "example-bucket"

  # name - (Required) 設定名
  # このIntelligent-Tiering設定を識別する一意の名前です。
  # 同じバケットに複数の設定を作成する場合、それぞれ異なる名前が必要です。
  # 型: string
  # 例: "EntireBucket", "ImportantDocuments", "ArchiveOldData"
  name = "example-configuration"

  ################################################################################
  # オプションパラメータ
  ################################################################################

  # status - (Optional) 設定の状態
  # この設定を有効または無効にするかを指定します。
  # 型: string
  # 有効な値: "Enabled", "Disabled"
  # デフォルト: "Enabled"（指定しない場合）
  #
  # 使用例:
  # - "Enabled"  : 設定を有効化（オブジェクトの自動階層化が実行される）
  # - "Disabled" : 設定を無効化（オブジェクトは移動されない）
  status = "Enabled"

  # region - (Optional) リージョン
  # このリソースが管理されるAWSリージョンを指定します。
  # 型: string
  # デフォルト: プロバイダー設定のリージョン
  # Computed: true（指定しない場合は自動設定される）
  #
  # 通常は指定不要ですが、マルチリージョン構成で明示的に指定したい場合に使用します。
  # 例: "us-east-1", "ap-northeast-1"
  # region = "us-east-1"

  ################################################################################
  # filter - (Optional) オブジェクトフィルター
  ################################################################################
  # この設定を適用するオブジェクトを絞り込むためのフィルター条件です。
  # フィルターを指定しない場合、バケット内のすべてのオブジェクトが対象になります。
  #
  # 最大数: 1（1つのfilterブロックのみ指定可能）
  #
  # ネストされた属性:
  # - prefix - (Optional) オブジェクトキーのプレフィックス
  #   型: string
  #   例: "documents/", "logs/2024/"
  #
  # - tags - (Optional) タグによるフィルター
  #   型: map(string)
  #   指定されたすべてのタグがオブジェクトに存在する場合のみ、設定が適用されます。
  #   例: { priority = "high", class = "blue" }
  #
  # 使用例1: プレフィックスのみでフィルタリング
  # filter {
  #   prefix = "documents/"
  # }
  #
  # 使用例2: プレフィックスとタグの両方でフィルタリング
  # filter {
  #   prefix = "documents/"
  #   tags = {
  #     priority = "high"
  #     class    = "blue"
  #   }
  # }
  #
  # 使用例3: タグのみでフィルタリング
  # filter {
  #   tags = {
  #     environment = "production"
  #     archive     = "true"
  #   }
  # }

  ################################################################################
  # tiering - (Required) 階層化設定
  ################################################################################
  # S3 Intelligent-Tieringのストレージアクセス階層を定義します。
  # 最低1つのtieringブロックが必要です。
  #
  # ネストされた属性:
  # - access_tier - (Required) アクセス階層
  #   型: string
  #   有効な値: "ARCHIVE_ACCESS", "DEEP_ARCHIVE_ACCESS"
  #
  # - days - (Required) 移行までの日数
  #   型: number
  #   アクセスがない状態が連続して何日続いたら該当階層に移行するかを指定します。
  #
  #   制約:
  #   - ARCHIVE_ACCESS: 最低90日、最大730日（2年）
  #   - DEEP_ARCHIVE_ACCESS: 最低180日、最大730日（2年）
  #
  # 階層の特徴:
  #
  # 1. ARCHIVE_ACCESS（アーカイブアクセス階層）
  #    - 標準取得時間: 3-5時間
  #    - コスト削減: 大幅なストレージコスト削減
  #    - 最低日数: 90日
  #    - 用途: めったにアクセスされないが、数時間以内の取得で問題ないデータ
  #
  # 2. DEEP_ARCHIVE_ACCESS（ディープアーカイブアクセス階層）
  #    - 標準取得時間: 12時間
  #    - コスト削減: 最大95%のストレージコスト削減
  #    - 最低日数: 180日
  #    - 用途: ほとんどアクセスされない長期保存データ（コンプライアンス、監査ログなど）
  #
  # 取得性能: 両階層とも最大1,000 TPS（Transactions Per Second）で復元可能

  # 使用例1: ARCHIVE_ACCESSのみ（90日後に移行）
  tiering {
    access_tier = "ARCHIVE_ACCESS"
    days        = 90
  }

  # 使用例2: ARCHIVE_ACCESSとDEEP_ARCHIVE_ACCESSの両方を使用
  # 125日後にARCHIVE_ACCESS、180日後にDEEP_ARCHIVE_ACCESSに移行
  # tiering {
  #   access_tier = "ARCHIVE_ACCESS"
  #   days        = 125
  # }
  # tiering {
  #   access_tier = "DEEP_ARCHIVE_ACCESS"
  #   days        = 180
  # }

  # 使用例3: DEEP_ARCHIVE_ACCESSのみ（長期保存データ用）
  # tiering {
  #   access_tier = "DEEP_ARCHIVE_ACCESS"
  #   days        = 365  # 1年後に移行
  # }
}

################################################################################
# 実用的な設定例
################################################################################

# 例1: バケット全体に対する基本的なIntelligent-Tiering設定
# resource "aws_s3_bucket_intelligent_tiering_configuration" "entire_bucket" {
#   bucket = aws_s3_bucket.example.id
#   name   = "EntireBucket"
#
#   tiering {
#     access_tier = "DEEP_ARCHIVE_ACCESS"
#     days        = 180
#   }
#   tiering {
#     access_tier = "ARCHIVE_ACCESS"
#     days        = 125
#   }
# }

# 例2: 特定のプレフィックスとタグでフィルタリングされた設定
# resource "aws_s3_bucket_intelligent_tiering_configuration" "filtered_documents" {
#   bucket = aws_s3_bucket.example.id
#   name   = "ImportantBlueDocuments"
#   status = "Disabled"  # 初期状態では無効化
#
#   filter {
#     prefix = "documents/"
#     tags = {
#       priority = "high"
#       class    = "blue"
#     }
#   }
#
#   tiering {
#     access_tier = "ARCHIVE_ACCESS"
#     days        = 125
#   }
# }

# 例3: ログデータの長期アーカイブ設定
# resource "aws_s3_bucket_intelligent_tiering_configuration" "log_archive" {
#   bucket = aws_s3_bucket.logs.id
#   name   = "LogArchive"
#
#   filter {
#     prefix = "logs/"
#   }
#
#   tiering {
#     access_tier = "ARCHIVE_ACCESS"
#     days        = 90   # 3ヶ月後にアーカイブ
#   }
#   tiering {
#     access_tier = "DEEP_ARCHIVE_ACCESS"
#     days        = 365  # 1年後にディープアーカイブ
#   }
# }

################################################################################
# 属性参照（Attributes Reference）
################################################################################
# このリソースは以下の属性をエクスポートします:
#
# - id - バケット名と設定名を組み合わせた識別子
#   形式: "bucket:name"
#   例: "my-bucket:EntireBucket"
#
# - bucket - バケット名（入力値と同じ）
# - name - 設定名（入力値と同じ）
# - region - リソースが管理されているリージョン
# - status - 設定の状態（Enabled/Disabled）

################################################################################
# インポート
################################################################################
# 既存のS3 Intelligent-Tiering設定をインポートできます。
#
# インポートコマンド:
# terraform import aws_s3_bucket_intelligent_tiering_configuration.this bucket-name:configuration-name
#
# 例:
# terraform import aws_s3_bucket_intelligent_tiering_configuration.this my-bucket:EntireBucket

################################################################################
# ベストプラクティスと推奨事項
################################################################################
# 1. 階層化戦略の選択:
#    - 頻繁にアクセスされないデータ: ARCHIVE_ACCESS（90日〜）
#    - ほとんどアクセスされない長期保存データ: DEEP_ARCHIVE_ACCESS（180日〜）
#    - 両方の階層を組み合わせて段階的にコストを削減することも可能
#
# 2. フィルター活用:
#    - バケット全体ではなく、特定のプレフィックスやタグでフィルタリングすることで
#      柔軟なデータ管理が可能
#    - 複数の設定を作成して、異なるデータセットに異なるポリシーを適用できる
#
# 3. コスト最適化:
#    - 小さいオブジェクト（128KB未満）は監視対象外なので、大きなオブジェクトに適用
#    - 取得料金がかからないため、アクセスパターンが不確実なデータにも安全に使用可能
#
# 4. モニタリング:
#    - CloudWatch メトリクスで階層化の状況を監視
#    - S3 Storage Class Analysisと組み合わせて最適な日数設定を決定
#
# 5. 他のライフサイクルポリシーとの併用:
#    - Intelligent-Tieringは他のS3ライフサイクルルールと組み合わせて使用可能
#    - 削除ポリシーと組み合わせて、古いデータを自動削除することも可能
