#---------------------------------------------------------------
# AWS IAM Identity Center Permission Set
#---------------------------------------------------------------
#
# AWS IAM Identity Centerのパーミッションセットをプロビジョニングするリソースです。
# パーミッションセットは、IAMポリシーのコレクションを定義するテンプレートで、
# 複数のAWSアカウントに渡ってユーザーやグループへのアクセス権限を簡素化します。
# IAM Identity Centerは各アカウントで対応するIAMロールを割り当て・管理します。
#
# AWS公式ドキュメント:
#   - パーミッションセット概要: https://docs.aws.amazon.com/singlesignon/latest/userguide/permissionsetsconcept.html
#   - パーミッションセットの作成・管理: https://docs.aws.amazon.com/singlesignon/latest/userguide/permissionsets.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_permission_set
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ssoadmin_permission_set" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: パーミッションセットの名前を指定します。
  # 設定可能な値: 1-32文字の文字列
  # 注意: 作成後の変更不可（Forces new resource）
  # 関連機能: IAM Identity Center パーミッションセット
  #   パーミッションセットは名前で識別され、ユーザーやグループへの割り当てに使用されます。
  #   - https://docs.aws.amazon.com/singlesignon/latest/userguide/howtocreatepermissionset.html
  name = "ExamplePermissionSet"

  # instance_arn (Required, Forces new resource)
  # 設定内容: パーミッションセットを作成するIAM Identity CenterインスタンスのARNを指定します。
  # 設定可能な値: 有効なIAM Identity CenterインスタンスのARN
  # 注意: 作成後の変更不可（Forces new resource）
  # 参考: aws_ssoadmin_instancesデータソースを使用してインスタンスARNを取得できます
  instance_arn = "arn:aws:sso:::instance/ssoins-1234567890abcdef"

  # description (Optional)
  # 設定内容: パーミッションセットの説明を指定します。
  # 設定可能な値: 1-700文字の文字列
  # 省略時: 説明なし
  # 用途: パーミッションセットの目的や用途を明確にするために使用
  description = "Example permission set for developers"

  #-------------------------------------------------------------
  # リソースID設定
  #-------------------------------------------------------------

  # id (Optional, Computed)
  # 設定内容: リソースIDを指定します。
  # 設定可能な値: パーミッションセットARNとインスタンスARNをカンマで区切った文字列
  # 省略時: Terraformが自動的に生成します（通常は省略を推奨）
  # 注意: 通常はこの属性を明示的に設定する必要はありません。
  #       Terraformが自動的に管理します。
  id = null

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
  # セッション設定
  #-------------------------------------------------------------

  # session_duration (Optional)
  # 設定内容: アプリケーションユーザーセッションの有効期間をISO-8601標準形式で指定します。
  # 設定可能な値: ISO-8601期間形式（例: PT1H=1時間、PT2H=2時間、PT8H=8時間、PT12H=12時間）
  # 省略時: PT1H（1時間）
  # 関連機能: パーミッションセット セッション期間
  #   セッション期間を設定することで、ユーザーセッションの長さを制御できます。
  #   セキュリティ目的で適切な期間を設定することが推奨されます。
  #   - https://docs.aws.amazon.com/singlesignon/latest/userguide/permissionsets.html
  # 注意: 最小値はPT1H（1時間）、最大値はPT12H（12時間）です
  session_duration = "PT2H"

  # relay_state (Optional)
  # 設定内容: フェデレーション認証プロセス中にユーザーをリダイレクトするために使用されるリレー状態URLを指定します。
  # 設定可能な値: 有効なURL（例: https://console.aws.amazon.com/s3、https://s3.console.aws.amazon.com/s3/home）
  # 省略時: リレー状態なし（ユーザーはAWS Management Consoleのホームページにリダイレクトされます）
  # 関連機能: パーミッションセット リレー状態
  #   ユーザーがIAM Identity Centerポータルからサインインした後、
  #   特定のAWSコンソールページに自動的にリダイレクトするために使用されます。
  #   - https://docs.aws.amazon.com/singlesignon/latest/userguide/howtocreatepermissionset.html
  relay_state = "https://s3.console.aws.amazon.com/s3/home?region=us-east-1#"

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-permission-set"
    Environment = "production"
    Team        = "platform"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーのdefault_tagsから継承されたタグを含む、すべてのタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: tagsとプロバイダーのdefault_tagsがマージされた値が自動的に設定されます
  # 注意: 通常はこの属性を明示的に設定する必要はありません。
  #       Terraformが自動的にtagsとdefault_tagsをマージして管理します。
  # 関連機能: AWSリソースタグ付け
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags_all = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # update (Optional)
    # 設定内容: パーミッションセットの更新操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "10m"=10分、"1h"=1時間）
    # 省略時: デフォルトのタイムアウト値を使用
    # 注意: パーミッションセットの更新は、すべての割り当てられたアカウントへの
    #       自動プロビジョニングを含むため、時間がかかる場合があります。
    update = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: パーミッションセットのAmazon Resource Name (ARN)
#
# - id: パーミッションセットとIAM Identity CenterインスタンスのAmazon Resource Name (ARN)を
#       カンマ（,）で区切った文字列
#
# - created_date: パーミッションセットが作成された日時（RFC3339形式）
#       例: 2023-01-01T00:00:00Z
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
