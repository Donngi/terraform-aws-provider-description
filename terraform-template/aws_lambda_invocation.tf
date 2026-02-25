#---------------------------------------------------------------
# AWS Lambda Invocation
#---------------------------------------------------------------
#
# Terraform のリソースライフサイクルに連動して Lambda 関数を
# 呼び出すリソースです。リソースの作成・更新・削除タイミングに
# 合わせて関数を実行し、インフラ構築と処理の連携を実現します。
#
# NOTE: このリソースは Terraform の apply/destroy 時に Lambda 関数を
#       直接呼び出します。関数の実行結果は result 属性で参照でき、
#       後続リソースへの入力として利用できます。
#       lifecycle_scope の設定によって呼び出しタイミングを制御できます。
#
# AWS公式ドキュメント:
#   - Lambda 呼び出し: https://docs.aws.amazon.com/lambda/latest/dg/API_Invoke.html
#   - Lambda 関数の呼び出しタイプ: https://docs.aws.amazon.com/lambda/latest/dg/invocation-sync.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_invocation
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lambda_invocation" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # function_name (Required)
  # 設定内容: 呼び出す Lambda 関数の名前または ARN を指定します。
  # 設定可能な値:
  #   - 関数名: "my-function"
  #   - 関数 ARN: "arn:aws:lambda:ap-northeast-1:123456789012:function:my-function"
  #   - パーシャル ARN: "123456789012:function:my-function"
  # 注意: 指定した関数が存在しない場合、実行は失敗します。
  function_name = aws_lambda_function.example.function_name

  # input (Required)
  # 設定内容: Lambda 関数に渡す JSON 形式の入力ペイロードを指定します。
  # 設定可能な値: 有効な JSON 文字列
  # 注意: jsonencode() を使用して Terraform 変数から JSON を生成すると
  #       管理しやすくなります。空の JSON を渡す場合は "{}" を指定します。
  input = jsonencode({
    key = "value"
  })

  #-------------------------------------------------------------
  # バージョン・エイリアス設定
  #-------------------------------------------------------------

  # qualifier (Optional)
  # 設定内容: 呼び出す Lambda 関数のバージョンまたはエイリアスを指定します。
  # 設定可能な値:
  #   - バージョン番号: "1", "2", "42" など
  #   - エイリアス名: "prod", "staging" など
  #   - "$LATEST": 最新の未公開バージョン
  # 省略時: "$LATEST" として扱われます。
  qualifier = null

  #-------------------------------------------------------------
  # ライフサイクル制御設定
  #-------------------------------------------------------------

  # lifecycle_scope (Optional)
  # 設定内容: Lambda 関数を呼び出す Terraform ライフサイクルのスコープを指定します。
  # 設定可能な値:
  #   - "CREATE_ONLY": リソース作成時のみ呼び出す
  #   - "CRUD": 作成・更新・削除時に呼び出す（input または triggers が変更された場合も含む）
  # 省略時: "CREATE_ONLY" として扱われます。
  # 注意: "CRUD" を指定した場合、Terraform の destroy 時にも関数が呼び出されます。
  #       削除時の呼び出しでは tf_action="delete" がペイロードに追加されます。
  lifecycle_scope = null

  # terraform_key (Optional)
  # 設定内容: lifecycle_scope が "CRUD" の場合にペイロードに追加される
  #           Terraform アクション情報のキー名を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: "tf" として扱われます。
  # 注意: lifecycle_scope が "CRUD" のとき、ペイロードには
  #       {terraform_key: {action: "create"|"update"|"delete"}} が追加されます。
  terraform_key = null

  # triggers (Optional)
  # 設定内容: 変更を検知してリソースの再実行をトリガーする任意のマップを指定します。
  # 設定可能な値: 文字列キーと文字列値のマップ
  # 省略時: トリガーは設定されません。
  # 注意: このマップ内のいずれかの値が変更されると、Lambda 関数が再呼び出しされます。
  #       外部リソースの変更を検知するためのタイムスタンプや設定ハッシュなどを利用します。
  triggers = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード (例: ap-northeast-1, us-east-1)
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # tenant_id (Optional)
  # 設定内容: マルチテナント環境での Lambda 呼び出しに使用するテナント ID を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: テナント ID は設定されません。
  tenant_id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Terraform のリソース識別子
#
# - result: Lambda 関数の実行結果を JSON 文字列で返します。
#   jsondecode(aws_lambda_invocation.example.result) で Terraform
#   オブジェクトに変換して後続リソースで参照できます。
#
#---------------------------------------------------------------
