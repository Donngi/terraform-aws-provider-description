#---------------------------------------------------------------
# IAM Instance Profile
#---------------------------------------------------------------
#
# IAMインスタンスプロファイルは、IAMロールをEC2インスタンスに渡すための
# コンテナです。インスタンスプロファイルにロールを含めることで、
# EC2インスタンス起動時にロールの情報を渡すことができます。
#
# インスタンスプロファイルには1つのIAMロールのみを含めることができますが、
# 同じロールを複数のインスタンスプロファイルに含めることは可能です。
#
# AWS公式ドキュメント:
#   - Use instance profiles: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2_instance-profiles.html
#   - IAM roles for Amazon EC2: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html
#   - IAM Identifiers: https://docs.aws.amazon.com/IAM/latest/UserGuide/Using_Identifiers.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_instance_profile" "example" {
  #---------------------------------------------------------------
  # 基本設定
  #---------------------------------------------------------------

  # name - (Optional) インスタンスプロファイルの名前
  # 省略した場合、Terraformがランダムでユニークな名前を割り当てます。
  # name_prefixと競合するため、どちらか一方のみを指定してください。
  #
  # 使用可能な文字: 大文字・小文字の英数字と以下の特殊文字
  #   _, +, =, ,, ., @, -
  # スペースは使用できません。
  #
  # 重要: nameは常にユニークである必要があります。roleやpathが異なっていても、
  # 既存のインスタンスプロファイルと同じnameを使用すると
  # EntityAlreadyExistsエラーが発生します。
  #
  # Type: string
  # Forces new resource
  # Conflicts with: name_prefix
  name = "example-instance-profile"

  # name_prefix - (Optional) 指定されたプレフィックスで始まるユニークな名前を生成
  # nameと競合するため、どちらか一方のみを指定してください。
  #
  # nameまたはname_prefixのいずれかを使用してインスタンスプロファイル名を管理します。
  # name_prefixを使用すると、Terraformが自動的にユニークな名前を生成するため、
  # 名前の衝突を避けることができます。
  #
  # Type: string
  # Forces new resource
  # Conflicts with: name
  # name_prefix = "example-"

  # path - (Optional) インスタンスプロファイルへのパス
  # デフォルト: "/"
  #
  # IAMリソースを論理的にグループ化するために使用します。
  # パスは以下のルールに従う必要があります:
  #   - 単一のフォワードスラッシュ(/)のみ、または
  #   - フォワードスラッシュで始まりフォワードスラッシュで終わる文字列
  #   - !(\\u0021)からDEL文字(\\u007F)までのASCII文字を含めることができます
  #     (ほとんどの句読点文字、数字、大文字・小文字を含む)
  #
  # 例:
  #   - "/" (デフォルト)
  #   - "/application/production/"
  #   - "/division/department/application/"
  #
  # Type: string
  path = "/"

  # role - (Optional) プロファイルに追加するロールの名前
  #
  # このインスタンスプロファイルに関連付けるIAMロールの名前を指定します。
  # インスタンスプロファイルには1つのロールのみを含めることができます。
  #
  # ロールを変更する場合:
  #   1. 既存のロールを削除
  #   2. 新しいロールを追加
  #   3. 変更がAWS全体に反映されるまで待機が必要(結果整合性)
  #   4. 変更を強制するには、インスタンスプロファイルの関連付けを解除して
  #      再度関連付けるか、インスタンスを停止して再起動する必要があります
  #
  # 注意: インスタンスのアクセス許可を更新するには、インスタンスプロファイルを
  # 置き換えることを推奨します。ロールをインスタンスプロファイルから削除すると、
  # 変更が有効になるまで最大1時間の遅延が発生する可能性があります。
  #
  # Type: string
  role = "example-role-name"

  #---------------------------------------------------------------
  # タグ
  #---------------------------------------------------------------

  # tags - (Optional) リソースタグのマップ
  #
  # IAMインスタンスプロファイルにタグを付けて、識別、整理、
  # アクセス制御を行うことができます。
  #
  # provider default_tagsとの統合:
  # プロバイダーレベルでdefault_tagsブロックが設定されている場合、
  # 一致するキーを持つタグはここで定義されたものが優先されます。
  #
  # Type: map(string)
  tags = {
    Name        = "example-instance-profile"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # tags_all - (Optional) リソースに割り当てられたすべてのタグのマップ
  #
  # プロバイダーのdefault_tagsから継承されたタグを含む、
  # リソースに割り当てられたすべてのタグのマップです。
  #
  # 通常、このフィールドは明示的に設定する必要はありません。
  # Terraformが自動的にtagsとdefault_tagsをマージします。
  #
  # Type: map(string)
  # Computed
  # tags_all = {}

  # id - (Optional) インスタンスプロファイルのID
  #
  # このフィールドは通常、Terraformによって自動的に管理されます。
  # 明示的に設定する必要はありません。
  #
  # 注意: 明示的に設定した場合でも、AWS側で生成される値が優先される可能性があります。
  # 通常はこのフィールドを省略することを推奨します。
  #
  # Type: string
  # Computed
  # id = null
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
#
# 以下の属性はリソース作成後に参照可能です(computed only):
#
# - arn
#   Type: string
#   AWSによって割り当てられたインスタンスプロファイルのARN
#   例: arn:aws:iam::123456789012:instance-profile/example-instance-profile
#
# - create_date
#   Type: string
#   インスタンスプロファイルの作成タイムスタンプ
#   ISO 8601形式で返されます
#   例: 2026-01-27T12:34:56Z
#
# - unique_id
#   Type: string
#   AWSによって割り当てられたユニークID
#   IAMによって生成される一意の識別子です
#   例: AIPAI23HZ27SI6FQMGNQ2
#
#---------------------------------------------------------------

# 出力例
# output "instance_profile_arn" {
#   description = "インスタンスプロファイルのARN"
#   value       = aws_iam_instance_profile.example.arn
# }
#
# output "instance_profile_id" {
#   description = "インスタンスプロファイルのID"
#   value       = aws_iam_instance_profile.example.id
# }
#
# output "instance_profile_unique_id" {
#   description = "インスタンスプロファイルのユニークID"
#   value       = aws_iam_instance_profile.example.unique_id
# }
#
# output "instance_profile_create_date" {
#   description = "インスタンスプロファイルの作成日時"
#   value       = aws_iam_instance_profile.example.create_date
# }
