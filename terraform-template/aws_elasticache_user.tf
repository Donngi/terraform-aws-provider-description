#---------------------------------------------------------------
# AWS ElastiCache User
#---------------------------------------------------------------
#
# Amazon ElastiCacheのユーザーアカウントをプロビジョニングするリソースです。
# ElastiCache Userは、Redis OSS / Valkeyエンジンにおけるロールベースアクセスコントロール（RBAC）の
# 構成要素として、認証情報（パスワード/IAM）とアクセス権限（ACL）を持つ個別ユーザーを定義します。
# 作成したユーザーはaws_elasticache_user_groupでグループ化し、レプリケーショングループや
# サーバーレスキャッシュへ関連付けることでアクセス制御を実現します。
#
# AWS公式ドキュメント:
#   - ElastiCache RBAC概要: https://docs.aws.amazon.com/AmazonElastiCache/latest/dg/Clusters.RBAC.html
#   - 認証とアクセス制御: https://docs.aws.amazon.com/AmazonElastiCache/latest/dg/IAM.html
#   - IAM認証によるElastiCache接続: https://docs.aws.amazon.com/AmazonElastiCache/latest/dg/auth-iam.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_user
#
# Provider Version: 6.43.0
# Generated: 2026-04-30
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_elasticache_user" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # user_id (Required, Forces new resource)
  # 設定内容: ElastiCache Userの一意な識別子を指定します。
  # 設定可能な値: 英数字、ハイフン、アンダースコアを含む文字列
  # 注意: 作成後は変更できません。変更する場合はリソースの再作成が必要です。
  #       同一AWSアカウント・リージョン内で一意である必要があります。
  user_id = "example-user-id"

  # user_name (Required, Forces new resource)
  # 設定内容: ElastiCacheに接続する際のログイン名（ユーザー名）を指定します。
  # 設定可能な値: 英数字、ハイフン、アンダースコアを含む文字列（最大40文字）
  # 注意: 作成後は変更できません。変更する場合はリソースの再作成が必要です。
  #       特殊なユーザー名 "default" はElastiCacheで予約されています。
  # 参考: https://docs.aws.amazon.com/AmazonElastiCache/latest/dg/Clusters.RBAC.html
  user_name = "example-username"

  # engine (Required)
  # 設定内容: ユーザーが対象とするキャッシュエンジンの種類を指定します。
  # 設定可能な値:
  #   - "redis": Redis OSSエンジン
  #   - "valkey": Valkeyエンジン
  # 注意: 大文字小文字は区別されません。
  #       Redis 6.0以降またはValkeyエンジンでのみRBACが利用可能です。
  # 参考: https://docs.aws.amazon.com/AmazonElastiCache/latest/dg/WhatIs.html
  engine = "redis"

  #-------------------------------------------------------------
  # アクセス権限設定（ACL）
  #-------------------------------------------------------------

  # access_string (Required)
  # 設定内容: ユーザーに付与するアクセス権限をRedis ACL構文で指定します。
  # 設定可能な値: Redis ACL構文に準拠した文字列。主な要素:
  #   - on / off: ユーザーの有効化/無効化
  #   - ~pattern: アクセス可能なキーのパターン（例: ~app::*）
  #   - +@category / -@category: コマンドカテゴリの許可/拒否（例: +@read, -@dangerous）
  #   - +command / -command: 個別コマンドの許可/拒否（例: +get, -flushall）
  #   - &pattern: アクセス可能なPub/Subチャネルのパターン（Redis 6.2以降）
  # 関連機能: ElastiCache RBAC アクセス文字列
  #   ACL文字列でユーザーごとの細かい権限制御が可能。複数の要素をスペース区切りで連結します。
  #   - https://docs.aws.amazon.com/AmazonElastiCache/latest/dg/Clusters.RBAC.html#Access-string
  # 例:
  #   - "on ~* +@all": すべてのキー・全コマンドへのフルアクセス
  #   - "on ~app::* -@all +@read": app::プレフィックスのキーに対する読み取り専用アクセス
  #   - "off ~* +@all": ユーザー無効化
  access_string = "on ~* +@all"

  #-------------------------------------------------------------
  # パスワード認証設定
  #-------------------------------------------------------------

  # no_password_required (Optional)
  # 設定内容: パスワードなしで認証可能とするかを指定します。
  # 設定可能な値:
  #   - true: パスワード認証を無効化（認証なしで接続可能）
  #   - false: パスワード認証またはIAM認証が必要
  # 省略時: false
  # 注意: trueの場合、passwords / passwords_wo および authentication_mode との併用は不可です。
  #       セキュリティ上の理由から本番環境では非推奨です。
  no_password_required = null

  # passwords (Optional, Sensitive)
  # 設定内容: ユーザー認証に使用するパスワードのセットを指定します。
  # 設定可能な値: 16〜128文字のパスワード文字列の集合（最大2つ）
  # 省略時: パスワードなし
  # 注意:
  #   - センシティブ情報として扱われます。
  #   - Terraformのステートファイルに平文で保存されるため、
  #     ステートの保護（暗号化されたバックエンド等）が必要です。
  #   - passwords_wo および authentication_mode との併用は不可です。
  #   - 同時に最大2つまで設定可能（ローテーション用途）。
  # 参考: https://docs.aws.amazon.com/AmazonElastiCache/latest/dg/Clusters.RBAC.html
  passwords = null

  # passwords_wo (Optional, Sensitive, Write-Only)
  # 設定内容: 書き込み専用（write-only）属性としてパスワードを指定します。
  # 設定可能な値: 16〜128文字のパスワード文字列
  # 省略時: 書き込み専用パスワードを使用しない
  # 関連機能: Terraform Write-Only属性
  #   write-only属性はTerraformのステートファイルやプランに保存されません。
  #   値の更新を反映させるには passwords_wo_version を変更する必要があります。
  #   - https://developer.hashicorp.com/terraform/language/v1.11.x/resources/ephemeral/write-only
  # 注意:
  #   - passwords / authentication_mode との併用は不可です。
  #   - Terraform 1.11.0以降が必要です。
  #   - 値変更時は passwords_wo_version を必ずインクリメントしてください。
  passwords_wo = null

  # passwords_wo_version (Optional)
  # 設定内容: passwords_wo の更新トリガーとして使用するバージョン番号を指定します。
  # 設定可能な値: 整数（例: 1, 2, 3, ...）
  # 省略時: バージョン管理なし（passwords_wo の値変更が検出されない）
  # 注意:
  #   - passwords_wo の値を変更する場合は、本値もインクリメントする必要があります。
  #   - Terraformはこのバージョン値の変化を検知し、passwords_wo の更新を実行します。
  passwords_wo_version = null

  #-------------------------------------------------------------
  # 認証モード設定（authentication_modeブロック）
  #-------------------------------------------------------------
  # 用途: 認証方式（パスワード認証/IAM認証/認証なし）を構造化して指定するためのブロック。
  # 注意:
  #   - 最大1つのブロックのみ指定可能です（max_items=1）。
  #   - passwords / passwords_wo / no_password_required との併用は不可です。
  #-------------------------------------------------------------

  authentication_mode {
    # type (Required)
    # 設定内容: 認証タイプを指定します。
    # 設定可能な値:
    #   - "password": パスワード認証（passwordsの指定が必須）
    #   - "iam": IAM認証（パスワード不要。IAMポリシーで接続を制御）
    #   - "no-password-required": 認証なし（非推奨）
    # 関連機能: ElastiCache IAM認証
    #   IAM認証を使用すると、長期パスワードを管理せずに短期トークンで接続できます。
    #   - https://docs.aws.amazon.com/AmazonElastiCache/latest/dg/auth-iam.html
    type = "password"

    # passwords (Optional, Sensitive)
    # 設定内容: 認証用パスワードのセット（type="password"の場合に指定）
    # 設定可能な値: 16〜128文字のパスワード文字列の集合（最大2つ）
    # 省略時: typeが"password"の場合はエラー
    # 注意:
    #   - センシティブ情報として扱われ、ステートファイルに平文で保存されます。
    #   - type="iam" / "no-password-required" の場合は指定不可です。
    passwords = ["ChangeThisPassword1234"]
  }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/AmazonElastiCache/latest/dg/Tagging-Resources.html
  tags = {
    Name        = "example-elasticache-user"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定（timeoutsブロック）
  #-------------------------------------------------------------
  # 用途: 各種操作のタイムアウト時間をカスタマイズするためのブロック。
  # 関連機能: Terraform Resource Timeouts
  #   - https://developer.hashicorp.com/terraform/language/resources/syntax#operation-timeouts
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: ユーザー作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "5m", "1h", "30s"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    create = "10m"

    # read (Optional)
    # 設定内容: ユーザー情報読み取り時のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "5m", "1h", "30s"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    read = "10m"

    # update (Optional)
    # 設定内容: ユーザー更新時のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "5m", "1h", "30s"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    update = "10m"

    # delete (Optional)
    # 設定内容: ユーザー削除時のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "5m", "1h", "30s"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    delete = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ElastiCache Userの識別子（user_idと同じ値）
# - arn: ElastiCache UserのAmazon Resource Name (ARN)
#        形式: arn:aws:elasticache:<region>:<account-id>:user:<user-id>
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#
# authentication_modeブロック内:
# - password_count: 設定されているパスワードの数（計算値）
#---------------------------------------------------------------
