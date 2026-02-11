# ============================================================
# AWS CloudFormation Stack - Annotated Template
# ============================================================
# 生成日: 2026-01-18
# Provider: hashicorp/aws v6.28.0
# リソース: aws_cloudformation_stack
#
# 注意事項:
# - このテンプレートは生成時点(2026-01-18)の情報に基づいています
# - 最新の仕様や詳細は AWS 公式ドキュメントを確認してください
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack
# ============================================================

resource "aws_cloudformation_stack" "example" {
  # ============================================================
  # 必須パラメータ
  # ============================================================

  # name - (必須) スタック名
  # CloudFormation スタックの一意の名前を指定します。
  # この名前はリージョン内で一意である必要があります。
  # 参考: https://docs.aws.amazon.com/AWSCloudFormation/latest/APIReference/API_CreateStack.html
  name = "example-stack"

  # ============================================================
  # テンプレート関連パラメータ
  # ============================================================

  # template_body - (オプション) テンプレート本体
  # CloudFormation テンプレートを JSON または YAML 形式の文字列として指定します。
  # 最大サイズ: 51,200 バイト
  # template_url との併用不可。どちらか一方を指定する必要があります。
  # 参考: https://docs.aws.amazon.com/AWSCloudFormation/latest/APIReference/API_CreateStack.html
  template_body = jsonencode({
    Parameters = {
      VPCCidr = {
        Type        = "String"
        Default     = "10.0.0.0/16"
        Description = "VPC CIDR block"
      }
    }
    Resources = {
      myVpc = {
        Type = "AWS::EC2::VPC"
        Properties = {
          CidrBlock = {
            "Ref" = "VPCCidr"
          }
        }
      }
    }
  })

  # template_url - (オプション) テンプレートの URL
  # S3 バケットに保存された CloudFormation テンプレートの URL を指定します。
  # 最大サイズ: 460,800 バイト
  # template_body との併用不可。どちらか一方を指定する必要があります。
  # S3 URL の形式: https://s3.amazonaws.com/bucket-name/template.json
  # 参考: https://docs.aws.amazon.com/AWSCloudFormation/latest/APIReference/API_CreateStack.html
  # template_url = "https://s3.amazonaws.com/my-bucket/my-template.json"

  # ============================================================
  # パラメータとポリシー
  # ============================================================

  # parameters - (オプション) スタックパラメータ
  # CloudFormation テンプレートで定義されたパラメータに値を渡すための
  # キー・バリューペアのマップです。
  # 参考: https://docs.aws.amazon.com/AWSCloudFormation/latest/APIReference/API_CreateStack.html
  parameters = {
    VPCCidr = "10.0.0.0/16"
  }

  # policy_body - (オプション) スタックポリシー本体
  # スタックリソースの更新を制御するポリシーを JSON 形式で指定します。
  # policy_url との併用不可。
  # スタックポリシーは、スタック内の特定のリソースに対する更新操作を
  # 許可または拒否するために使用されます。
  # 参考: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/protect-stack-resources.html
  # policy_body = jsonencode({
  #   Statement = [
  #     {
  #       Effect    = "Allow"
  #       Principal = "*"
  #       Action    = "Update:*"
  #       Resource  = "*"
  #     }
  #   ]
  # })

  # policy_url - (オプション) スタックポリシーの URL
  # S3 バケットに保存されたスタックポリシーファイルの URL を指定します。
  # policy_body との併用不可。
  # 参考: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/protect-stack-resources.html
  # policy_url = "https://s3.amazonaws.com/my-bucket/stack-policy.json"

  # ============================================================
  # 権限と実行制御
  # ============================================================

  # capabilities - (オプション) スタックの機能
  # CloudFormation スタックが IAM リソースやカスタムリソース名を作成することを
  # 明示的に承認するために使用します。
  # 有効な値:
  #   - CAPABILITY_IAM: テンプレートが IAM リソースを作成する場合に必要
  #   - CAPABILITY_NAMED_IAM: テンプレートがカスタム名を持つ IAM リソースを作成する場合に必要
  #   - CAPABILITY_AUTO_EXPAND: テンプレートにマクロや入れ子スタックが含まれる場合に必要
  # 参考: https://docs.aws.amazon.com/AWSCloudFormation/latest/APIReference/API_CreateStack.html
  capabilities = ["CAPABILITY_IAM"]

  # iam_role_arn - (オプション) IAM ロール ARN
  # CloudFormation がスタック操作を実行する際に使用する IAM ロールの ARN を指定します。
  # 指定しない場合、CloudFormation はユーザー認証情報から生成された
  # 一時セッションを使用します。
  # 参考: https://docs.aws.amazon.com/AWSCloudFormation/latest/APIReference/API_CreateStack.html
  # iam_role_arn = "arn:aws:iam::123456789012:role/CloudFormationRole"

  # ============================================================
  # 障害処理とタイムアウト
  # ============================================================

  # disable_rollback - (オプション) ロールバックの無効化
  # スタック作成が失敗した場合にロールバックを無効にするかどうかを指定します。
  # true に設定すると、失敗時にロールバックされません。
  # on_failure パラメータとの併用不可。
  # デフォルト: false
  # 参考: https://docs.aws.amazon.com/AWSCloudFormation/latest/APIReference/API_CreateStack.html
  # disable_rollback = false

  # on_failure - (オプション) 失敗時のアクション
  # スタック作成が失敗した場合に実行するアクションを指定します。
  # 有効な値:
  #   - DO_NOTHING: 失敗したリソースをそのまま残す
  #   - ROLLBACK: 作成されたリソースをロールバックする (デフォルト)
  #   - DELETE: スタック全体を削除する
  # disable_rollback パラメータとの併用不可。
  # 参考: https://docs.aws.amazon.com/AWSCloudFormation/latest/APIReference/API_CreateStack.html
  # on_failure = "ROLLBACK"

  # timeout_in_minutes - (オプション) タイムアウト時間
  # スタックステータスが CREATE_FAILED になるまでの待機時間を分単位で指定します。
  # この時間内にスタック作成が完了しない場合、スタック作成は失敗します。
  # 参考: https://docs.aws.amazon.com/AWSCloudFormation/latest/APIReference/API_CreateStack.html
  # timeout_in_minutes = 30

  # ============================================================
  # 通知とリージョン
  # ============================================================

  # notification_arns - (オプション) 通知先 SNS トピック ARN
  # スタック関連イベントを発行する SNS トピック ARN のリストを指定します。
  # スタックの作成、更新、削除などのイベントが指定されたトピックに送信されます。
  # 参考: https://docs.aws.amazon.com/AWSCloudFormation/latest/APIReference/API_CreateStack.html
  # notification_arns = [
  #   "arn:aws:sns:us-east-1:123456789012:my-topic"
  # ]

  # region - (オプション) リージョン
  # このリソースが管理されるリージョンを指定します。
  # 指定しない場合、プロバイダー設定で設定されたリージョンが使用されます。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # ============================================================
  # タグ
  # ============================================================

  # tags - (オプション) リソースタグ
  # スタックに関連付けるリソースタグのマップです。
  # プロバイダーの default_tags 設定ブロックと一緒に使用される場合、
  # キーが一致するタグはプロバイダーレベルで定義されたタグを上書きします。
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # ============================================================
  # Timeouts ブロック
  # ============================================================
  # CloudFormation スタックの作成、更新、削除操作のタイムアウトを
  # カスタマイズできます。

  timeouts {
    # create - (オプション) 作成タイムアウト
    # スタック作成操作のタイムアウト時間を指定します。
    # デフォルト: 30m
    create = "30m"

    # update - (オプション) 更新タイムアウト
    # スタック更新操作のタイムアウト時間を指定します。
    # デフォルト: 30m
    update = "30m"

    # delete - (オプション) 削除タイムアウト
    # スタック削除操作のタイムアウト時間を指定します。
    # デフォルト: 30m
    delete = "30m"
  }
}

# ============================================================
# 出力値 (Computed Attributes)
# ============================================================
# 以下の属性は Terraform によって自動的に計算され、
# 他のリソースやモジュールで参照できます。

# id - スタックの一意識別子
# output "stack_id" {
#   value = aws_cloudformation_stack.example.id
# }

# outputs - スタックからの出力値のマップ
# CloudFormation テンプレートの Outputs セクションで定義された値が含まれます。
# output "stack_outputs" {
#   value = aws_cloudformation_stack.example.outputs
# }

# tags_all - すべてのタグのマップ
# リソースに割り当てられたすべてのタグ (プロバイダーの default_tags から
# 継承されたタグを含む) のマップです。
# output "all_tags" {
#   value = aws_cloudformation_stack.example.tags_all
# }
