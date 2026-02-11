#---------------------------------------------------------------
# EC2インスタンス状態管理
#---------------------------------------------------------------
#
# EC2インスタンスの電源状態（running/stopped）を管理するリソース。
# インスタンスの起動・停止を制御し、コスト最適化やメンテナンス時の
# 状態管理に使用します。
#
# 重要な注意事項:
# - AWS APIには、インスタンスがユーザーデータの処理を完了したかを
#   判定する機能がありません。そのため、ユーザーデータスクリプトの
#   実行中にインスタンスを停止してしまう可能性があります。
# - force = true による強制停止では、ファイルシステムのキャッシュや
#   メタデータがフラッシュされないため、その後のファイルシステム
#   チェックと修復が必要になります。Windows インスタンスでは非推奨。
#
# AWS公式ドキュメント:
#   - EC2インスタンスのライフサイクル: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-lifecycle.html
#   - インスタンスの停止と起動: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/how-ec2-instance-stop-start-works.html
#   - インスタンスの状態: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_InstanceState.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_instance_state
#
# Provider Version: 6.28.0
# Generated: 2026-01-31
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ec2_instance_state" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # EC2インスタンスのID
  #
  # 状態を管理する対象のインスタンスIDを指定します。
  #
  # 例: "i-1234567890abcdef0"
  instance_id = "REPLACE_WITH_INSTANCE_ID"

  # インスタンスの目標状態
  #
  # インスタンスを設定したい状態を指定します。
  #
  # 有効な値:
  #   - "running"  : インスタンスを起動状態にする
  #   - "stopped"  : インスタンスを停止状態にする
  #
  # 状態遷移:
  #   - stopped → running: インスタンスが起動され、課金が開始されます
  #   - running → stopped: インスタンスが停止され、インスタンス課金が停止します
  #                        (ただし、アタッチされたEBSボリュームの課金は継続)
  #
  # 注意事項:
  #   - 停止したインスタンスは、起動時に新しいホストコンピュータに
  #     移行される場合があります
  #   - 停止時、インスタンスストアボリュームのデータは失われます
  #   - 停止時、プライベートIPv4アドレスとElastic IPアドレスは保持されますが、
  #     パブリックIPv4アドレスは解放されます（起動時に新しいアドレスが割り当て）
  state = "stopped"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # 強制停止フラグ
  #
  # state が "stopped" の場合に、強制停止をリクエストするかどうかを指定します。
  # state が "running" の場合は無視されます。
  #
  # デフォルト: false
  #
  # true の場合の動作:
  #   - インスタンスは即座に停止されます
  #   - ファイルシステムのキャッシュやメタデータがフラッシュされません
  #   - 再起動後、ファイルシステムのチェックと修復が必要になる場合があります
  #
  # 注意事項:
  #   - Windowsインスタンスでは推奨されません
  #   - データ損失のリスクがあるため、通常は false を推奨
  #   - 応答しないインスタンスを停止する必要がある場合のみ使用を検討
  # force = false

  # リージョン
  #
  # このリソースが管理されるAWSリージョンを指定します。
  #
  # デフォルト: プロバイダー設定で指定されたリージョン
  #
  # 例: "ap-northeast-1", "us-east-1"
  #
  # 用途:
  #   - マルチリージョン構成で、特定のリージョンのリソースを
  #     明示的に指定する場合に使用
  #   - 通常はプロバイダーのデフォルト設定を使用することを推奨
  #
  # 参考:
  #   - リージョナルエンドポイント: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  #   - プロバイダー設定: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#aws-configuration-reference
  # region = "ap-northeast-1"

  #---------------------------------------------------------------
  # タイムアウト設定
  #---------------------------------------------------------------

  # 各操作のタイムアウト時間を設定します。
  # デフォルト値は、ほとんどの場合で十分ですが、大規模な環境や
  # 特殊な要件がある場合は調整が必要になることがあります。
  #
  # 形式: "60m" (分), "1h" (時間), "10s" (秒) など
  # timeouts {
  #   # 作成時のタイムアウト
  #   # インスタンスを目標状態にするまでの待機時間
  #   # create = "10m"
  #
  #   # 更新時のタイムアウト
  #   # 状態変更が完了するまでの待機時間
  #   # update = "10m"
  #
  #   # 削除時のタイムアウト
  #   # リソース削除が完了するまでの待機時間
  #   # delete = "10m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (参照専用属性)
#---------------------------------------------------------------
#
# このリソースから参照可能な属性:
#
# - id
#     インスタンスのID（instance_id と同じ値）
#
#     使用例:
#       output "instance_state_id" {
#         value = aws_ec2_instance_state.example.id
#       }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------
#
# 例1: インスタンスを停止状態で管理
#
# resource "aws_instance" "app_server" {
#   ami           = "ami-0c55b159cbfafe1f0"
#   instance_type = "t3.micro"
#
#   tags = {
#     Name = "AppServer"
#   }
# }
#
# resource "aws_ec2_instance_state" "app_server_state" {
#   instance_id = aws_instance.app_server.id
#   state       = "stopped"
# }
#
# 例2: 開発環境を営業時間外に自動停止
#
# resource "aws_ec2_instance_state" "dev_instance" {
#   instance_id = aws_instance.dev_server.id
#   state       = var.business_hours ? "running" : "stopped"
# }
#
# 例3: 特定リージョンのインスタンス状態管理
#
# resource "aws_ec2_instance_state" "tokyo_instance" {
#   instance_id = aws_instance.tokyo_server.id
#   state       = "running"
#   region      = "ap-northeast-1"
# }
#
#---------------------------------------------------------------
