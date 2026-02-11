################################################################################
# AWS GameLift Script
################################################################################
# GameLift Script リソースは、Realtime Servers用のゲームスクリプトをAmazon GameLiftに
# アップロードして管理するためのリソースです。
# Realtime Serversは、軽量なマルチプレイヤーゲームサーバーフレームワークで、
# カスタムゲームロジックをJavaScriptで実装できます。
#
# 主な用途:
# - Realtime Servers用のゲームスクリプトのアップロード
# - S3バケットからのスクリプトのインポート
# - スクリプトのバージョン管理
# - Realtime Fleetsでの使用
#
# 関連ドキュメント:
# - https://docs.aws.amazon.com/gamelift/latest/developerguide/realtime-script-uploading.html
# - https://docs.aws.amazon.com/gamelift/latest/developerguide/realtime-intro.html
################################################################################

resource "aws_gamelift_script" "example" {
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # 基本設定
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  # name - (必須)
  # スクリプトの名前
  #
  # 用途:
  # - スクリプトを識別するための分かりやすい名前
  # - コンソールやAPIでの表示に使用
  # - 複数のスクリプトを区別するための識別子
  #
  # 制約:
  # - 1〜1024文字
  # - アルファベット、数字、スペース、ハイフン、アンダースコアが使用可能
  #
  # 例:
  # - "production-realtime-script"
  # - "dev-game-logic-v1"
  # - "my-realtime-server-script"
  name = "example-realtime-script"

  # version - (オプション)
  # スクリプトに関連付けるバージョン情報
  #
  # 用途:
  # - スクリプトのバージョン管理
  # - デプロイの追跡
  # - ロールバック時の参照
  #
  # 特徴:
  # - 任意の文字列を指定可能
  # - GameLift内部では使用されない（メタデータとして保存）
  # - セマンティックバージョニング（例: "1.0.0"）の使用を推奨
  #
  # 例:
  # version = "1.0.0"
  # version = "2.1.3-beta"
  # version = "2024-01-15"

  # region - (オプション)
  # このリソースが管理されるAWSリージョン
  #
  # 用途:
  # - マルチリージョン構成での明示的なリージョン指定
  # - プロバイダーのデフォルトリージョンを上書き
  #
  # デフォルト:
  # - プロバイダー設定のリージョンを使用
  #
  # 注意:
  # - スクリプトは指定したリージョンにのみ作成される
  # - 他のリージョンで使用する場合は、各リージョンで個別にアップロードが必要
  #
  # 例:
  # region = "us-west-2"
  # region = "ap-northeast-1"

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # スクリプトアップロード方法
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # スクリプトのアップロードには2つの方法があります:
  # 1. zip_file: 直接ZIPファイルをアップロード（開発・テスト向け）
  # 2. storage_location: S3バケットからインポート（本番環境推奨）
  #
  # いずれか一方を選択してください（両方指定することはできません）

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # 方法1: 直接ZIPファイルをアップロード
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  # zip_file - (オプション)
  # Realtimeスクリプトと依存関係を含むZIPファイルのデータオブジェクト
  #
  # 用途:
  # - 開発環境での迅速なスクリプトのアップロード
  # - 小規模なスクリプトの直接デプロイ
  # - CI/CDパイプラインでの自動デプロイ
  #
  # 制約:
  # - 最大ファイルサイズ: 5 MB
  # - ZIPファイルには1つ以上のファイルを含めることができる
  # - storage_locationと同時に指定できない
  #
  # 使用方法:
  # - filebase64()関数でZIPファイルを読み込む
  # - アーカイブプロバイダーで動的にZIP作成も可能
  #
  # 例:
  # zip_file = filebase64("${path.module}/scripts/realtime-script.zip")

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # 方法2: S3バケットからインポート（推奨）
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  # storage_location - (オプション)
  # ゲームスクリプトファイルが保存されている場所の情報
  #
  # 用途:
  # - 本番環境でのスクリプト管理
  # - 大容量スクリプトのアップロード（5MB以上）
  # - S3のバージョニング機能を活用した履歴管理
  # - IAMロールによる細かいアクセス制御
  #
  # 特徴:
  # - S3バケットからGameLiftがスクリプトを取得
  # - S3のライフサイクル管理やバージョニングが利用可能
  # - zip_fileと同時に指定できない
  #
  # ベストプラクティス:
  # - 本番環境では常にstorage_locationを使用
  # - S3バケットのバージョニングを有効化
  # - 暗号化されたS3バケットの使用
  storage_location {
    # bucket - (必須)
    # スクリプトZIPファイルが保存されているS3バケット名
    #
    # 用途:
    # - GameLiftがアクセスするS3バケットの指定
    #
    # 制約:
    # - バケット名は有効なS3バケット名の規則に従う必要がある
    # - GameLiftからアクセス可能なバケットである必要がある
    #
    # 例:
    # bucket = "my-gamelift-scripts"
    # bucket = aws_s3_bucket.gamelift_scripts.id
    bucket = "example-gamelift-scripts-bucket"

    # key - (必須)
    # スクリプトファイルを含むZIPファイルのS3オブジェクトキー
    #
    # 用途:
    # - S3バケット内のスクリプトファイルの場所を指定
    #
    # 形式:
    # - S3オブジェクトキーの標準形式
    # - プレフィックス（フォルダ）を含めることができる
    #
    # 例:
    # key = "scripts/realtime-v1.0.0.zip"
    # key = "production/realtime-script.zip"
    # key = aws_s3_object.script.key
    key = "scripts/realtime-script.zip"

    # role_arn - (必須)
    # Amazon GameLiftがS3バケットにアクセスするためのIAMロールのARN
    #
    # 用途:
    # - GameLiftサービスにS3バケットへのアクセス権限を付与
    # - セキュアなクロスサービスアクセスの実現
    #
    # 必要な権限:
    # - s3:GetObject: スクリプトZIPファイルの読み取り
    # - s3:GetObjectVersion: バージョン指定時の読み取り
    #
    # 信頼ポリシー:
    # - Principal: gamelift.amazonaws.com
    # - Action: sts:AssumeRole
    #
    # 例:
    # role_arn = aws_iam_role.gamelift_script_access.arn
    role_arn = "arn:aws:iam::123456789012:role/GameLiftScriptAccessRole"

    # object_version - (オプション)
    # 取得するファイルの特定バージョン
    #
    # 用途:
    # - S3バージョニングが有効な場合の特定バージョンの指定
    # - スクリプトの履歴管理とロールバック
    #
    # 動作:
    # - 未指定の場合: ファイルの最新バージョンを取得
    # - 指定した場合: 指定したバージョンIDのファイルを取得
    #
    # 前提条件:
    # - S3バケットでバージョニングが有効化されている必要がある
    #
    # 例:
    # object_version = "Vz7a9b8c7d6e5f4g3h2i1j0k"
    # object_version = aws_s3_object.script.version_id
  }

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # タグ設定
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  # tags - (オプション)
  # リソースに付けるタグのキー・バリューマップ
  #
  # 用途:
  # - リソースの分類と管理
  # - コスト配分タグ
  # - 自動化スクリプトでのリソース識別
  #
  # 特徴:
  # - プロバイダーのdefault_tagsと統合
  # - 同じキーのタグはリソースレベルのタグが優先
  #
  # ベストプラクティス:
  # - Environment（環境）タグの追加
  # - Application（アプリケーション）タグの追加
  # - Version（バージョン）タグの追加
  # - Owner（所有者）タグの追加
  #
  # 例:
  # tags = {
  #   Environment = "production"
  #   Application = "my-realtime-game"
  #   Version     = "1.0.0"
  #   Owner       = "game-team"
  #   CostCenter  = "gaming"
  # }
  tags = {
    Name        = "example-realtime-script"
    Environment = "development"
    ManagedBy   = "terraform"
  }

  # tags_all - (読み取り専用)
  # プロバイダーのdefault_tagsを含む、リソースに割り当てられた全タグのマップ
  #
  # 特徴:
  # - Terraformによって自動的に管理される
  # - リソースレベルのtagsとプロバイダーレベルのdefault_tagsをマージ
  # - 読み取り専用の計算値
}

################################################################################
# 出力値
################################################################################

# id
# GameLift Script ID
#
# 用途:
# - スクリプトの一意識別子
# - Fleetリソースでのスクリプト参照
# - API呼び出しでのスクリプト指定
#
# 形式:
# - script-xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
#
# 例:
# output "script_id" {
#   description = "GameLift Script ID"
#   value       = aws_gamelift_script.example.id
# }

# arn
# GameLift Script ARN
#
# 用途:
# - IAMポリシーでのリソース指定
# - CloudWatchアラームのターゲット指定
# - クロスアカウント参照
#
# 形式:
# - arn:aws:gamelift:region:account-id:script/script-id
#
# 例:
# output "script_arn" {
#   description = "GameLift Script ARN"
#   value       = aws_gamelift_script.example.arn
# }

################################################################################
# 使用例
################################################################################

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 例1: 直接ZIPファイルをアップロード（開発環境）
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/*
resource "aws_gamelift_script" "dev" {
  name    = "dev-realtime-script"
  version = "1.0.0-dev"

  # ローカルのZIPファイルを直接アップロード
  zip_file = filebase64("${path.module}/scripts/realtime-script.zip")

  tags = {
    Environment = "development"
    Purpose     = "testing"
  }
}
*/

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 例2: S3バケットからインポート（本番環境）
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/*
# S3バケットの作成
resource "aws_s3_bucket" "gamelift_scripts" {
  bucket = "my-gamelift-scripts-bucket"

  tags = {
    Name        = "GameLift Scripts"
    Environment = "production"
  }
}

# S3バケットのバージョニング有効化
resource "aws_s3_bucket_versioning" "gamelift_scripts" {
  bucket = aws_s3_bucket.gamelift_scripts.id

  versioning_configuration {
    status = "Enabled"
  }
}

# スクリプトZIPファイルをS3にアップロード
resource "aws_s3_object" "realtime_script" {
  bucket = aws_s3_bucket.gamelift_scripts.id
  key    = "scripts/production/realtime-v1.0.0.zip"
  source = "${path.module}/scripts/realtime-script.zip"
  etag   = filemd5("${path.module}/scripts/realtime-script.zip")

  tags = {
    Version = "1.0.0"
  }
}

# GameLift用のIAMロール
resource "aws_iam_role" "gamelift_script_access" {
  name = "gamelift-script-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "gamelift.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "GameLift Script Access Role"
  }
}

# S3アクセス用のIAMポリシー
resource "aws_iam_role_policy" "gamelift_s3_access" {
  name = "gamelift-s3-access-policy"
  role = aws_iam_role.gamelift_script_access.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion"
        ]
        Resource = "${aws_s3_bucket.gamelift_scripts.arn}/*"
      }
    ]
  })
}

# GameLiftスクリプトの作成（S3から）
resource "aws_gamelift_script" "production" {
  name    = "production-realtime-script"
  version = "1.0.0"

  storage_location {
    bucket   = aws_s3_bucket.gamelift_scripts.id
    key      = aws_s3_object.realtime_script.key
    role_arn = aws_iam_role.gamelift_script_access.arn
    # バージョン指定でピン留めも可能
    object_version = aws_s3_object.realtime_script.version_id
  }

  tags = {
    Environment = "production"
    Application = "my-game"
    Version     = "1.0.0"
  }
}
*/

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 例3: アーカイブプロバイダーで動的にZIPを作成
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/*
# アーカイブプロバイダーを使用してZIP作成
data "archive_file" "realtime_script" {
  type        = "zip"
  source_dir  = "${path.module}/src/realtime-server"
  output_path = "${path.module}/dist/realtime-script.zip"
}

resource "aws_gamelift_script" "dynamic" {
  name    = "dynamic-realtime-script"
  version = "1.0.0"

  zip_file = filebase64(data.archive_file.realtime_script.output_path)

  tags = {
    Environment = "staging"
    BuildHash   = data.archive_file.realtime_script.output_md5
  }
}
*/

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 例4: マルチリージョンデプロイ
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/*
# us-east-1リージョン
resource "aws_gamelift_script" "us_east_1" {
  provider = aws.us_east_1

  name    = "global-realtime-script"
  version = "1.0.0"

  zip_file = filebase64("${path.module}/scripts/realtime-script.zip")

  tags = {
    Region = "us-east-1"
  }
}

# eu-west-1リージョン
resource "aws_gamelift_script" "eu_west_1" {
  provider = aws.eu_west_1

  name    = "global-realtime-script"
  version = "1.0.0"

  zip_file = filebase64("${path.module}/scripts/realtime-script.zip")

  tags = {
    Region = "eu-west-1"
  }
}

# ap-northeast-1リージョン
resource "aws_gamelift_script" "ap_northeast_1" {
  provider = aws.ap_northeast_1

  name    = "global-realtime-script"
  version = "1.0.0"

  zip_file = filebase64("${path.module}/scripts/realtime-script.zip")

  tags = {
    Region = "ap-northeast-1"
  }
}
*/

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 例5: FleetでのScript使用
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/*
# Realtime Scriptの作成
resource "aws_gamelift_script" "game_script" {
  name    = "my-game-script"
  version = "2.0.0"

  storage_location {
    bucket   = aws_s3_bucket.scripts.id
    key      = "scripts/game-v2.0.0.zip"
    role_arn = aws_iam_role.gamelift_access.arn
  }

  tags = {
    Environment = "production"
  }
}

# Realtime Fleet（Scriptを使用）
resource "aws_gamelift_fleet" "realtime_fleet" {
  name        = "realtime-fleet"
  description = "Fleet for realtime game sessions"

  # Realtime Serverの設定
  fleet_type = "ON_DEMAND"
  script_id  = aws_gamelift_script.game_script.id

  ec2_instance_type = "c5.large"

  runtime_configuration {
    server_process {
      concurrent_executions = 5
      launch_path           = "/local/game/script.js"
    }
  }

  ec2_inbound_permission {
    from_port = 3000
    to_port   = 3010
    ip_range  = "0.0.0.0/0"
    protocol  = "UDP"
  }

  tags = {
    Environment = "production"
  }
}
*/

################################################################################
# 補足情報
################################################################################

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Realtime Serversとは
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Amazon GameLift Realtime Serversは、軽量なマルチプレイヤーゲームサーバー
# フレームワークです。カスタムゲームサーバーを構築せずに、JavaScriptで
# ゲームロジックを記述できます。
#
# 特徴:
# - Node.js環境で動作
# - WebSocketベースの通信
# - 低レイテンシーのマルチプレイヤー体験
# - カスタムゲームロジックの実装が可能
#
# 用途:
# - カジュアルマルチプレイヤーゲーム
# - ターンベースゲーム
# - リアルタイム対戦ゲーム
# - 軽量なマルチプレイヤー機能

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# スクリプトの構造
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Realtime Scriptは以下のような構造を持ちます:
#
# realtime-script.zip
# ├── script.js           # メインスクリプト（必須）
# ├── node_modules/       # npm依存関係（オプション）
# │   └── ...
# └── other-files/        # その他のファイル（オプション）
#     └── ...
#
# script.js の主要な関数:
# - init(): サーバー初期化時に呼ばれる
# - onProcessStarted(): プロセス開始時に呼ばれる
# - onMessage(): メッセージ受信時に呼ばれる
# - onPlayerConnect(): プレイヤー接続時に呼ばれる
# - onPlayerDisconnect(): プレイヤー切断時に呼ばれる

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# BuildとScriptの違い
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# GameLiftには2種類のゲームサーバーホスティング方法があります:
#
# 1. Build (aws_gamelift_build):
#    - カスタムゲームサーバーバイナリ
#    - C++、C#、Javaなどで作成
#    - GameLift Server SDKとの統合が必要
#    - より複雑なゲームロジック向け
#
# 2. Script (aws_gamelift_script):
#    - Realtime Servers用のJavaScriptスクリプト
#    - 軽量なゲームロジック
#    - SDK統合不要
#    - 迅速な開発が可能

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# デプロイのベストプラクティス
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 1. バージョン管理:
#    - セマンティックバージョニングの使用
#    - S3バケットのバージョニング有効化
#    - タグでのバージョン追跡
#
# 2. 環境分離:
#    - 開発、ステージング、本番環境で別のスクリプトを使用
#    - 環境ごとに異なるS3バケットまたはプレフィックスを使用
#
# 3. セキュリティ:
#    - S3バケットの暗号化有効化
#    - 最小権限の原則でIAMロール設定
#    - パブリックアクセスのブロック
#
# 4. CI/CD統合:
#    - 自動テストの実装
#    - 自動デプロイパイプライン
#    - ロールバック計画
#
# 5. モニタリング:
#    - CloudWatchでのログ監視
#    - メトリクスの追跡
#    - アラート設定

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# コスト最適化
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# - スクリプト自体に課金はない（ストレージのみ）
# - S3ストレージコストの最適化
# - 古いバージョンのライフサイクル管理
# - Fleetのオートスケーリング設定
# - 開発環境では必要時のみFleetを起動

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# トラブルシューティング
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 一般的な問題と解決策:
#
# 1. "AccessDenied" エラー:
#    - IAMロールの権限を確認
#    - S3バケットポリシーを確認
#    - ロールの信頼関係を確認
#
# 2. "InvalidZipFile" エラー:
#    - ZIPファイルの形式を確認
#    - ファイルサイズが5MB以下か確認（zip_file使用時）
#    - script.jsが含まれているか確認
#
# 3. "ResourceNotFound" エラー:
#    - S3バケット名とキーを確認
#    - リージョンが正しいか確認
#    - S3オブジェクトが存在するか確認
#
# 4. スクリプトが動作しない:
#    - CloudWatchログを確認
#    - script.jsの構文エラーをチェック
#    - 必要なnpmパッケージが含まれているか確認

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 関連リソース
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# - aws_gamelift_fleet: スクリプトを実行するFleetの作成
# - aws_gamelift_alias: Fleetへのエイリアス設定
# - aws_gamelift_game_session_queue: セッションキューの設定
# - aws_s3_bucket: スクリプト保存用のS3バケット
# - aws_iam_role: GameLiftのS3アクセス用IAMロール
# - aws_cloudwatch_log_group: ログ収集

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 参考リンク
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# - Terraform Registry:
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/gamelift_script
#
# - AWS GameLift Realtime Servers:
#   https://docs.aws.amazon.com/gamelift/latest/developerguide/realtime-intro.html
#
# - スクリプトのアップロード:
#   https://docs.aws.amazon.com/gamelift/latest/developerguide/realtime-script-uploading.html
#
# - Realtime Servers スクリプトリファレンス:
#   https://docs.aws.amazon.com/gamelift/latest/developerguide/realtime-script.html
#
# - GameLift Fleet設定:
#   https://docs.aws.amazon.com/gamelift/latest/developerguide/fleets-intro.html
