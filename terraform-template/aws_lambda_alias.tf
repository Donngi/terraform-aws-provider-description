#---------------------------------------------------------------
# AWS Lambda Alias
#---------------------------------------------------------------
#
# Lambda 関数のエイリアスを管理するリソースです。
# エイリアスはバージョンに対する名前付きポインターであり、
# 関数コードを変更せずにトラフィックを異なるバージョンに
# ルーティングするために使用します。
#
# NOTE: エイリアスを使用することで、"prod" や "dev" といった
#       論理的な名前で特定のバージョンを参照でき、デプロイ管理を
#       簡素化できます。routing_config を使用すると、カナリアリリース
#       やブルーグリーンデプロイが実現できます。
#
# AWS公式ドキュメント:
#   - Lambda エイリアス: https://docs.aws.amazon.com/lambda/latest/dg/configuration-aliases.html
#   - トラフィックシフト: https://docs.aws.amazon.com/lambda/latest/dg/lambda-traffic-shifting-using-aliases.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_alias
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lambda_alias" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: エイリアスの名前を指定します。
  # 設定可能な値: 英数字、ハイフン、アンダースコアを含む文字列 (最大64文字)
  # 注意: 同じ Lambda 関数に対してエイリアス名は一意である必要があります。
  #       "$LATEST" はエイリアス名として使用できません。
  name = "example"

  # function_name (Required)
  # 設定内容: エイリアスを作成する Lambda 関数の名前または ARN を指定します。
  # 設定可能な値:
  #   - 関数名: "my-function"
  #   - 関数 ARN: "arn:aws:lambda:ap-northeast-1:123456789012:function:my-function"
  # 注意: 指定した関数が存在しない場合、リソースの作成は失敗します。
  function_name = aws_lambda_function.example.function_name

  # function_version (Required)
  # 設定内容: エイリアスが指し示す Lambda 関数のバージョンを指定します。
  # 設定可能な値:
  #   - バージョン番号: "1", "2", "42" など
  #   - "$LATEST": 最新の公開されていないバージョン（本番環境での使用は非推奨）
  # 注意: "$LATEST" は変更可能なため、予期しない動作を防ぐために
  #       本番環境では固定バージョン番号の使用を推奨します。
  function_version = "$LATEST"

  #-------------------------------------------------------------
  # メタデータ
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: エイリアスの説明を指定します。
  # 設定可能な値: 任意の文字列 (最大256文字)
  # 省略時: 説明なしで作成されます。
  description = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード (例: ap-northeast-1, us-east-1)
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # トラフィックルーティング設定
  #-------------------------------------------------------------

  # routing_config (Optional)
  # 設定内容: エイリアスのトラフィックをルーティングする設定を指定します。
  # 関連機能: カナリアリリース / ブルーグリーンデプロイ
  #   追加バージョンへのトラフィック割合を設定することで、
  #   段階的なデプロイを実現できます。
  # 参考: https://docs.aws.amazon.com/lambda/latest/dg/lambda-traffic-shifting-using-aliases.html
  routing_config {
    # additional_version_weights (Optional)
    # 設定内容: 追加バージョンへのトラフィック重みを指定します。
    #           バージョン番号をキー、トラフィック割合を値とするマップです。
    # 設定可能な値: バージョン番号（文字列）と0.0〜1.0の数値のマップ
    #   例: {"2" = 0.1} の場合、10% のトラフィックをバージョン2に送信し
    #       残り90% は function_version で指定したバージョンに送信されます。
    # 省略時: トラフィックは function_version のみに送信されます。
    # 注意: 指定できるバージョンは1つのみで、重みの合計は1.0未満にする必要があります。
    additional_version_weights = {}
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: エイリアスの ARN
#   形式: "arn:aws:lambda:region:account-id:function:function-name:alias-name"
#
# - invoke_arn: API Gateway からの呼び出し用 ARN
#   形式: "arn:aws:apigateway:region:lambda:path/.../functions/arn:.../invocations"
#
# - id: Terraform のリソース識別子（エイリアスの ARN と同じ値）
#---------------------------------------------------------------
# resource "aws_lambda_alias" "prod" {
#   name             = "prod"
#   function_name    = aws_lambda_function.example.function_name
#   function_version = aws_lambda_function.example.version
#   routing_config {
#     additional_version_weights = {
#       (aws_lambda_function.example_v2.version) = 0.1
#     }
#   }
# }
#---------------------------------------------------------------
