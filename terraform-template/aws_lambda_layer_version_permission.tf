#---------------------------------------------------------------
# AWS Lambda Layer Version Permission
#---------------------------------------------------------------
#
# AWS Lambda レイヤーの特定バージョンに対するアクセス許可を管理するリソースです。
# このリソースにより、以下の対象にレイヤーバージョンへのアクセス権を付与できます:
#   1. 特定のAWSアカウント: アカウントIDを指定してアクセス許可
#   2. AWS Organizations内の全アカウント: 組織IDを指定してアクセス許可
#   3. 全てのAWSアカウント: principal に "*" を指定して公開アクセス許可
#
# 重要な制約:
#   - アクセス許可は単一のレイヤーバージョンにのみ適用されます
#   - 新しいバージョンごとに個別の許可設定が必要です
#   - セキュリティベストプラクティスとして、特定アカウントまたは組織への制限を推奨
#
# AWS公式ドキュメント:
#   - Lambda レイヤークロスアカウント許可: https://docs.aws.amazon.com/lambda/latest/dg/permissions-layer-cross-account.html
#   - Lambda レイヤー共有: https://docs.aws.amazon.com/lambda/latest/dg/configuration-layers.html#configuration-layers-permissions
#   - AddLayerVersionPermission API: https://docs.aws.amazon.com/lambda/latest/api/API_AddLayerVersionPermission.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_layer_version_permission
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lambda_layer_version_permission" "example" {
  #-------------------------------------------------------------
  # 基本設定 (必須)
  #-------------------------------------------------------------

  # layer_name (Required)
  # 設定内容: アクセス許可を付与するLambdaレイヤーの名前またはARNを指定します。
  # 設定可能な値:
  #   - レイヤー名: "my-layer"
  #   - レイヤーARN: "arn:aws:lambda:us-east-1:123456789012:layer:my-layer"
  # 関連機能: Lambda レイヤー管理
  #   レイヤー名またはARNのいずれかの形式で指定可能。ARNを使用すると
  #   リージョンとアカウントを明示的に指定できます。
  #   - https://docs.aws.amazon.com/lambda/latest/dg/configuration-layers.html
  layer_name = "my-layer"

  # version_number (Required)
  # 設定内容: アクセス許可を付与するレイヤーのバージョン番号を指定します。
  # 設定可能な値: 正の整数 (1, 2, 3, ...)
  # 注意: 各バージョンごとに個別の許可設定が必要です
  # 関連機能: Lambda レイヤーバージョン管理
  #   レイヤーを更新すると新しいバージョン番号が割り当てられます。
  #   各バージョンは不変であり、許可設定もバージョンごとに独立しています。
  #   - https://docs.aws.amazon.com/lambda/latest/dg/configuration-layers.html#configuration-layers-versions
  version_number = 1

  # statement_id (Required)
  # 設定内容: 許可ステートメントの一意な識別子を指定します。
  # 設定可能な値: 英数字とダッシュを含む文字列 (最大100文字)
  # 用途: ポリシー内で複数の許可ステートメントを区別するために使用
  # 注意: 同じレイヤーバージョン内で一意である必要があります
  # 関連機能: Lambda リソースベースポリシー
  #   複数のアカウントや組織に許可を与える場合、それぞれ異なる
  #   statement_idが必要です。
  #   - https://docs.aws.amazon.com/lambda/latest/dg/access-control-resource-based.html
  statement_id = "allow-account-123456789012"

  # action (Required)
  # 設定内容: 許可するアクションを指定します。
  # 設定可能な値:
  #   - "lambda:GetLayerVersion": レイヤーバージョンの取得を許可
  # 注意: 現在、レイヤーバージョン許可では "lambda:GetLayerVersion" のみサポート
  # 関連機能: Lambda IAMアクション
  #   このアクションにより、指定されたプリンシパルがレイヤーバージョンを
  #   ダウンロードし、Lambda関数で使用できるようになります。
  #   - https://docs.aws.amazon.com/lambda/latest/dg/lambda-api-permissions-ref.html
  action = "lambda:GetLayerVersion"

  # principal (Required)
  # 設定内容: アクセス許可を付与するプリンシパルを指定します。
  # 設定可能な値:
  #   - 特定アカウント: "123456789012" (12桁のAWSアカウントID)
  #   - 全アカウント: "*" (公開アクセス - セキュリティリスクあり)
  # 用途: 特定のアカウントにレイヤーへのアクセス権を付与
  # セキュリティ推奨事項: 可能な限り特定のアカウントIDまたは
  #   organization_idを使用し、"*" の使用は避けてください
  # 関連機能: Lambda クロスアカウントアクセス
  #   他のAWSアカウントがレイヤーを使用できるようにします。
  #   - https://docs.aws.amazon.com/lambda/latest/dg/permissions-layer-cross-account.html
  principal = "123456789012"

  #-------------------------------------------------------------
  # 組織レベルのアクセス許可 (オプション)
  #-------------------------------------------------------------

  # organization_id (Optional)
  # 設定内容: AWS Organizations内の全アカウントにアクセス許可を付与する場合、
  #           組織IDを指定します。
  # 設定可能な値: "o-" で始まる組織ID (例: "o-a1b2c3d4e5")
  # 用途: 組織内の全てのアカウントに一括でレイヤーアクセスを許可
  # 注意: organization_id を使用する場合、principal は "*" に設定する必要があります
  # 関連機能: AWS Organizations統合
  #   組織内の複数アカウントに対してレイヤーを共有する場合に便利。
  #   個別のアカウントごとに許可を追加する必要がありません。
  #   - https://docs.aws.amazon.com/lambda/latest/dg/permissions-layer-cross-account.html
  organization_id = null

  #-------------------------------------------------------------
  # リージョン設定 (オプション)
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: レイヤーはリージョンごとに独立しており、許可もリージョンごとに設定
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # ライフサイクル管理 (オプション)
  #-------------------------------------------------------------

  # skip_destroy (Optional)
  # 設定内容: Terraformのdestroyコマンド実行時に、このリソースの削除をスキップするか指定します。
  # 設定可能な値:
  #   - true: destroy時に許可を削除しない
  #   - false: destroy時に許可を削除 (デフォルト)
  # 用途: 他のインフラストラクチャで使用されているレイヤー許可を保護
  # 注意: trueに設定しても、レイヤーバージョン自体が削除されると許可も削除されます
  skip_destroy = false

  # id (Optional, Computed)
  # 設定内容: リソースのID。layer_name,version_number形式
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: レイヤー名とバージョン番号を結合した識別子
#   形式: "{layer_name},{version_number}"
#
# - policy: レイヤーバージョンに適用されたリソースベースポリシーのJSON文字列
#   このポリシーには、このリソースによって追加された許可ステートメントが含まれます
#
# - revision_id: 一意なリビジョンID
#   ポリシーが更新されるたびに変更されます。楽観的ロック制御に使用されます
#
# - region: このリソースが管理されているAWSリージョン
#---------------------------------------------------------------

#---------------------------------------------------------------
# resource "aws_lambda_layer_version_permission" "account_specific" {
#   layer_name       = aws_lambda_layer_version.example.layer_arn
#   version_number   = aws_lambda_layer_version.example.version
#   statement_id     = "allow-prod-account"
#   action           = "lambda:GetLayerVersion"
#   principal        = "111122223333"
# }
#---------------------------------------------------------------
