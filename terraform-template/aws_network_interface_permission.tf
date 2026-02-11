#---------------------------------------------------------------
# Network Interface Permission
#---------------------------------------------------------------
#
# クロスアカウントでElastic Network Interface (ENI)へのアクセス権限を
# 付与するリソース。他のAWSアカウントに対して、指定したENIをインスタンスに
# アタッチする権限、またはElastic IPアドレスを関連付ける権限を付与できる。
#
# 主なユースケース:
#   - 共有VPC環境で他アカウントへENIアタッチ権限を付与
#   - クロスアカウントでのElastic IP関連付けの許可
#   - マルチアカウント構成でのネットワークリソース共有
#
# AWS公式ドキュメント:
#   - CreateNetworkInterfacePermission API: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_CreateNetworkInterfacePermission.html
#   - NetworkInterfacePermission: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_NetworkInterfacePermission.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface_permission
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_network_interface_permission" "example" {
  #---------------------------------------------------------------
  # 必須引数 (Required Arguments)
  #---------------------------------------------------------------

  # network_interface_id (Required, string)
  #   権限を付与するネットワークインターフェースのID。
  #   このENIに対するアクセス権限が指定したAWSアカウントに付与される。
  #
  #   例: "eni-0123456789abcdef0"
  network_interface_id = aws_network_interface.example.id

  # aws_account_id (Required, string)
  #   権限を付与するAWSアカウントID（12桁）。
  #   このアカウントに対して指定したネットワークインターフェースへの
  #   アクセス権限が付与される。
  #
  #   例: "123456789012"
  aws_account_id = "123456789012"

  # permission (Required, string)
  #   付与する権限のタイプ。以下のいずれかを指定:
  #
  #   - "INSTANCE-ATTACH":
  #       指定したAWSアカウントがこのENIを自身のインスタンスにアタッチする
  #       ことを許可。共有VPC環境で他アカウントのEC2インスタンスに
  #       ENIをアタッチさせる場合に使用。
  #
  #   - "EIP-ASSOCIATE":
  #       指定したAWSアカウントがこのENIにElastic IPアドレスを関連付ける
  #       ことを許可。他アカウントが管理するEIPをこのENIに紐付ける
  #       場合に使用。
  permission = "INSTANCE-ATTACH"

  #---------------------------------------------------------------
  # オプション引数 (Optional Arguments)
  #---------------------------------------------------------------

  # region (Optional, string)
  #   このリソースを管理するAWSリージョン。
  #   指定しない場合、プロバイダー設定のリージョンがデフォルトで使用される。
  #   マルチリージョン構成で特定のリージョンを明示的に指定する場合に使用。
  #
  #   参照: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  #
  #   例: "us-east-1", "ap-northeast-1"
  # region = "ap-northeast-1"

  #---------------------------------------------------------------
  # タイムアウト設定 (Timeouts)
  #---------------------------------------------------------------
  # 各操作のタイムアウト時間を設定可能。
  # 値は "30s"（秒）、"5m"（分）、"2h"（時間）などの形式で指定。
  #
  # timeouts {
  #   # create (Optional, string)
  #   #   リソース作成時のタイムアウト。
  #   #   ネットワークインターフェースの権限作成が完了するまでの
  #   #   最大待機時間を指定。
  #   create = "10m"
  #
  #   # delete (Optional, string)
  #   #   リソース削除時のタイムアウト。
  #   #   権限の削除が完了するまでの最大待機時間を指定。
  #   #   削除操作がstate保存前に実行される場合のみ適用される。
  #   delete = "10m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# 以下の属性はリソース作成後にTerraformによって自動的に設定され、
# 他のリソースから参照可能。これらは設定ファイルでは指定できない。
#
# network_interface_permission_id:
#   - 作成されたENI権限の一意識別子
#   - 形式: "eni-perm-xxxxxxxxxxxxxxxxx"
#   - 参照例: aws_network_interface_permission.example.network_interface_permission_id
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: 共有VPCでの他アカウントへのENIアタッチ権限付与
#---------------------------------------------------------------
#
# # 共有用のネットワークインターフェースを作成
# resource "aws_network_interface" "shared" {
#   subnet_id       = aws_subnet.shared.id
#   private_ips     = ["10.0.1.50"]
#   security_groups = [aws_security_group.shared.id]
#
#   tags = {
#     Name = "shared-eni"
#   }
# }
#
# # 他のAWSアカウントにアタッチ権限を付与
# resource "aws_network_interface_permission" "allow_attach" {
#   network_interface_id = aws_network_interface.shared.id
#   aws_account_id       = "987654321098"  # 権限を付与するアカウント
#   permission           = "INSTANCE-ATTACH"
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 注意事項
#---------------------------------------------------------------
#
# 1. 権限の制限
#    - 一つのENIに対して、同じAWSアカウントに付与できる権限は
#      各タイプ（INSTANCE-ATTACH, EIP-ASSOCIATE）につき1つのみ
#    - 複数アカウントへの権限付与は、アカウントごとに別リソースを作成
#
# 2. セキュリティ考慮事項
#    - ENIアタッチ権限を付与すると、相手アカウントがそのENIを
#      自身のインスタンスにアタッチ可能になる
#    - セキュリティグループや関連するプライベートIPも含めて
#      アクセス可能になるため、権限付与は慎重に行う
#
# 3. クリーンアップ
#    - 権限を削除しても、既にアタッチされているENIは影響を受けない
#    - 完全な分離には、ENI自体のデタッチが必要
#
# 4. リージョン
#    - ENIと同じリージョンで権限を管理する必要がある
#    - クロスリージョンでの権限付与は不可
#
#---------------------------------------------------------------
