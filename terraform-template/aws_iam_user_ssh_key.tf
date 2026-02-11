#---------------------------------------------------------------
# IAM User SSH Key
#---------------------------------------------------------------
#
# IAMユーザーにSSH公開鍵をアップロードして関連付けるリソース。
# 主にAWS CodeCommitリポジトリへのSSH接続認証に使用される。
#
# AWS公式ドキュメント:
#   - UploadSSHPublicKey API: https://docs.aws.amazon.com/IAM/latest/APIReference/API_UploadSSHPublicKey.html
#   - SSHPublicKey Data Type: https://docs.aws.amazon.com/IAM/latest/APIReference/API_SSHPublicKey.html
#   - IAMUserSSHKeys Managed Policy: https://docs.aws.amazon.com/aws-managed-policy/latest/reference/IAMUserSSHKeys.html
#   - CodeCommit SSH Setup: https://docs.aws.amazon.com/codecommit/latest/userguide/setting-up-without-cli.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_ssh_key
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_user_ssh_key" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # username - IAMユーザー名
  # SSH公開鍵を関連付ける対象のIAMユーザーの名前を指定します。
  # このユーザーは事前に作成されている必要があります。
  #
  # 制約:
  #   - 長さ: 1-64文字
  #   - パターン: [\w+=,.@-]+
  #
  # 例: "test-user", "developer-john"
  username = "example-user"

  # encoding - エンコーディング形式
  # レスポンスで返される公開鍵のエンコーディング形式を指定します。
  #
  # 有効な値:
  #   - "SSH": ssh-rsa形式で公開鍵を取得
  #   - "PEM": PEM形式で公開鍵を取得
  #
  # 注意: この値はAWSへの公開鍵の保存形式ではなく、API応答の
  #       フォーマット指定です。public_keyはどちらの形式でも
  #       アップロード可能です。
  encoding = "SSH"

  # public_key - SSH公開鍵本体
  # アップロードするSSH公開鍵の内容を指定します。
  # ssh-rsa形式またはPEM形式で指定できます。
  #
  # 制約:
  #   - 長さ: 1-16384文字
  #   - 形式: ssh-rsa または PEM
  #
  # 使用例:
  #   - ssh-rsaで始まる鍵: "ssh-rsa AAAAB3NzaC1yc2E... user@host"
  #   - PEM形式: "-----BEGIN PUBLIC KEY-----\n...\n-----END PUBLIC KEY-----"
  #
  # 注意:
  #   - 公開鍵のみを指定します（秘密鍵は含めないでください）
  #   - 同じ鍵の重複アップロードは DuplicateSSHPublicKey エラーとなります
  #   - 不正な形式の場合は InvalidPublicKey エラーとなります
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 mytest@mydomain.com"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # status - SSH公開鍵のステータス
  # SSH公開鍵に割り当てるステータスを指定します。
  #
  # 有効な値:
  #   - "Active": 鍵が認証に使用可能（デフォルト）
  #   - "Inactive": 鍵が認証に使用不可
  #
  # デフォルト値: "Active"
  #
  # 用途:
  #   - 鍵のローテーション時に古い鍵をInactiveに設定
  #   - 一時的にアクセスを無効化したい場合
  #   - セキュリティインシデント発生時の緊急対応
  #
  # 注意: "Inactive"に設定しても鍵は削除されません。
  #       後から"Active"に戻すことが可能です。
  status = "Active"

  # id - リソース識別子（オプション）
  # Terraformのリソース識別子として使用されます。
  #
  # 通常は指定不要です。指定しない場合、Terraformが自動的に
  # 適切な値を計算します。
  #
  # Computed: true（自動計算される）
  # Optional: true（明示的に指定も可能）
  #
  # 注意: 特別な理由がない限り、このパラメータは省略することを推奨します。
  # id = "example-user:APKA..."
}

#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------------------------------
#
# このリソースが作成された後、以下の属性を参照できます。
# これらは computed 属性であり、Terraform設定では指定できません。
#
# - ssh_public_key_id (string)
#     SSH公開鍵の一意な識別子
#     例: "APKAEIBAERJR2EXAMPLE"
#     制約: 20-128文字、パターン: [\w]+
#
#     使用例:
#       output "ssh_key_id" {
#         value = aws_iam_user_ssh_key.example.ssh_public_key_id
#       }
#
# - fingerprint (string)
#     SSH公開鍵のMD5メッセージダイジェスト
#     例: "12:34:56:78:90:ab:cd:ef:12:34:56:78:90:ab:cd:ef"
#     固定長: 48文字
#     パターン: [:\w]+
#
#     使用例:
#       output "ssh_key_fingerprint" {
#         value = aws_iam_user_ssh_key.example.fingerprint
#       }
#
# - id (string)
#     リソースの識別子（自動計算）
#     形式: "{username}:{ssh_public_key_id}"
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------
#
# 例1: IAMユーザーとSSH鍵の基本的な作成
#
# resource "aws_iam_user" "developer" {
#   name = "developer-john"
#   path = "/developers/"
# }
#
# resource "aws_iam_user_ssh_key" "developer_key" {
#   username   = aws_iam_user.developer.name
#   encoding   = "SSH"
#   public_key = file("~/.ssh/id_rsa.pub")
# }
#
# 例2: ファイルから公開鍵を読み込む場合
#
# resource "aws_iam_user_ssh_key" "from_file" {
#   username   = aws_iam_user.developer.name
#   encoding   = "SSH"
#   public_key = file("${path.module}/keys/developer.pub")
# }
#
# 例3: 複数の鍵を管理する場合
#
# resource "aws_iam_user_ssh_key" "primary_key" {
#   username   = aws_iam_user.developer.name
#   encoding   = "SSH"
#   public_key = file("${path.module}/keys/primary.pub")
#   status     = "Active"
# }
#
# resource "aws_iam_user_ssh_key" "backup_key" {
#   username   = aws_iam_user.developer.name
#   encoding   = "SSH"
#   public_key = file("${path.module}/keys/backup.pub")
#   status     = "Inactive"
# }
#
# 例4: 鍵情報の出力
#
# output "ssh_key_details" {
#   value = {
#     key_id      = aws_iam_user_ssh_key.developer_key.ssh_public_key_id
#     fingerprint = aws_iam_user_ssh_key.developer_key.fingerprint
#     username    = aws_iam_user_ssh_key.developer_key.username
#     status      = aws_iam_user_ssh_key.developer_key.status
#   }
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# IAM Policy要件
#---------------------------------------------------------------
#
# このリソースを使用するには、以下のIAM権限が必要です:
#
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Action": [
#         "iam:UploadSSHPublicKey",
#         "iam:GetSSHPublicKey",
#         "iam:ListSSHPublicKeys",
#         "iam:UpdateSSHPublicKey",
#         "iam:DeleteSSHPublicKey"
#       ],
#       "Resource": "arn:aws:iam::*:user/*"
#     }
#   ]
# }
#
# AWSマネージドポリシー:
#   - IAMUserSSHKeys: ユーザーが自分のSSH鍵を管理するためのポリシー
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 重要な注意事項
#---------------------------------------------------------------
#
# 1. CodeCommit専用
#    - このSSH鍵はAWS CodeCommitリポジトリへの認証にのみ使用されます
#    - EC2インスタンスへのSSH接続などには使用できません
#
# 2. 鍵の上限
#    - 1つのIAMユーザーにつき最大5つのSSH公開鍵を登録可能
#    - 上限を超えると LimitExceeded エラーが発生します
#
# 3. セキュリティベストプラクティス
#    - 秘密鍵は絶対にTerraform設定やバージョン管理システムに含めない
#    - 公開鍵のみをアップロードする
#    - 定期的に鍵をローテーションする
#    - 不要になった鍵は削除する
#    - 退職者のアカウントは即座に無効化する
#
# 4. 鍵の形式
#    - 対応形式: ssh-rsa, PEM
#    - 非対応の形式を使用すると UnrecognizedPublicKeyEncoding エラー
#    - 不正な鍵データは InvalidPublicKey エラー
#
# 5. 鍵の重複
#    - 同じ公開鍵を同じユーザーに複数回アップロードすることはできません
#    - 重複した場合は DuplicateSSHPublicKey エラーが発生します
#
# 6. ステータス管理
#    - status = "Inactive" にしても鍵は削除されません
#    - 後から "Active" に戻すことが可能です
#    - 完全に削除したい場合はリソースを destroy してください
#
# 7. インポート
#    - 既存のSSH鍵はインポート可能です
#    - インポート形式: {username}:{ssh_public_key_id}
#    - 例: terraform import aws_iam_user_ssh_key.example john:APKAEXAMPLE
#
#---------------------------------------------------------------
