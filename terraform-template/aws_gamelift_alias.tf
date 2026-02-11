#---------------------------------------------------------------
# GameLift Alias
#---------------------------------------------------------------
#
# GameLiftフリートの抽象化レイヤーとして機能するエイリアスをプロビジョニングします。
# エイリアスを使用すると、ゲームクライアントのコードを変更せずにプレイヤートラフィックを
# あるフリートから別のフリートにリダイレクトできます。これはゲームビルドの更新時などに有用です。
#
# AWS公式ドキュメント:
#   - CreateAlias API: https://docs.aws.amazon.com/gameliftservers/latest/apireference/API_CreateAlias.html
#   - RoutingStrategy: https://docs.aws.amazon.com/gameliftservers/latest/apireference/API_RoutingStrategy.html
#   - エイリアスの概要: https://docs.aws.amazon.com/gameliftservers/latest/developerguide/aliases-intro.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/gamelift_alias
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_gamelift_alias" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # (必須) エイリアスの名前
  # エイリアスIDの代わりに使用できる分かりやすい識別子です。
  # エイリアス名は一意である必要はありません。
  # 制約: 1〜1024文字、空白文字のみは不可
  name = "example-alias"

  #---------------------------------------------------------------
  # ルーティング設定 (必須ブロック)
  #---------------------------------------------------------------

  # (必須) エイリアスのルーティング設定を指定します。
  # SIMPLEまたはTERMINALの2種類のルーティング戦略があります。
  routing_strategy {
    # (必須) ルーティング戦略のタイプ
    # 指定可能な値:
    #   - SIMPLE: エイリアスが特定のフリートに解決されます。アクティブなフリートへのルーティングに使用します。
    #   - TERMINAL: エイリアスはフリートに解決されず、代わりにユーザーにメッセージを表示します。
    #               ゲームバージョンがサポート終了した場合などにアップグレードサイトへの誘導に使用します。
    type = "SIMPLE"

    # (オプション) エイリアスが指すGameLiftフリートのID
    # typeが"SIMPLE"の場合に指定します。
    # フリートARNではなくフリートIDを指定する必要があります。
    # 制約: 1〜128文字、パターン: ^[a-z]*fleet-[a-zA-Z0-9\-]+
    # 各SIMPLEエイリアスは1つのフリートのみを指すことができますが、1つのフリートは複数のエイリアスを持つことができます。
    fleet_id = "fleet-12345678-1234-1234-1234-123456789012"

    # (オプション) TERMINALルーティング戦略で使用するメッセージテキスト
    # typeが"TERMINAL"の場合に指定します。
    # プレイヤーに表示されるメッセージやURLへのリンクなどを設定します。
    # message = "このゲームバージョンはサポートされていません。新しいバージョンにアップグレードしてください。"
  }

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # (オプション) エイリアスの説明
  # エイリアスの目的や用途を記述する人間が読める説明文です。
  # 制約: 1〜1024文字
  description = "Example GameLift alias for routing player traffic"

  # (オプション) このリソースを管理するAWSリージョン
  # 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用されます。
  # フリートとエイリアスは同じリージョンに存在する必要があります。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-west-2"

  # (オプション) リソースタグのキーバリューマップ
  # リソース管理、アクセス管理、コスト配分に有用です。
  # プロバイダーのdefault_tags設定ブロックと併用可能で、キーが重複する場合はこちらが優先されます。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  tags = {
    Name        = "example-gamelift-alias"
    Environment = "production"
    Game        = "example-game"
  }

  # (オプション) リソースに割り当てられたタグのマップ（プロバイダーのdefault_tagsから継承されたものを含む）
  # 通常、Terraformによって自動管理されるため、明示的な指定は不要です。
  # tags_all = {}
}

#---------------------------------------------------------------
# Attributes Reference (出力専用属性)
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です。入力パラメータとしては使用できません。
#
# - id: エイリアスID（例: alias-12345678-1234-1234-1234-123456789012）
# - arn: エイリアスのAmazon Resource Name（例: arn:aws:gamelift:us-west-2:123456789012:alias/alias-12345678-1234-1234-1234-123456789012）
# - tags_all: プロバイダーのdefault_tagsから継承されたタグを含む、リソースに割り当てられた全タグのマップ
#---------------------------------------------------------------

# 出力例:
# output "gamelift_alias_id" {
#   description = "The ID of the GameLift alias"
#   value       = aws_gamelift_alias.example.id
# }
#
# output "gamelift_alias_arn" {
#   description = "The ARN of the GameLift alias"
#   value       = aws_gamelift_alias.example.arn
# }
