################################################################################
# aws_ec2_subnet_cidr_reservation
################################################################################
# Terraform AWS Provider リソーステンプレート
#
# リソース: aws_ec2_subnet_cidr_reservation
# 説明: サブネット内のIPアドレス範囲を予約するリソース。
#       AWSが自動的にネットワークインターフェイスに割り当てることを防ぎ、
#       IPv4またはIPv6 CIDRブロック（プレフィックス）を用途に応じて予約できます。
#
# 生成日: 2026-01-23
# Provider version: 6.28.0
#
# 注意:
#   - このテンプレートは生成時点の情報に基づいています
#   - 最新の仕様は公式ドキュメントを確認してください
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_subnet_cidr_reservation
#   - https://docs.aws.amazon.com/vpc/latest/userguide/subnet-cidr-reservation.html
#
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
################################################################################

resource "aws_ec2_subnet_cidr_reservation" "example" {
  #-------------------------------------------------------------
  # 必須パラメータ
  #-------------------------------------------------------------

  # cidr_block (Required)
  # 設定内容: 予約するCIDRブロック。
  # 設定可能な値: サブネット内の有効なIPv4またはIPv6 CIDR範囲
  #               例: "10.0.0.16/28" (IPv4) または "2600:1f13:925:d240:3a1b::/80" (IPv6)
  # 用途: サブネット内の特定のIPアドレス範囲を予約し、AWSによる自動割り当てを防止します。
  # 注意事項:
  #   - 既に使用中のIPアドレスを含むことも可能ですが、予約を作成しても使用中のIPアドレスは割り当て解除されません
  #   - 複数のCIDR範囲を予約できますが、同一VPC内で重複することはできません
  # 参考: https://docs.aws.amazon.com/vpc/latest/userguide/subnet-cidr-reservation.html
  cidr_block = "10.0.0.16/28"

  # reservation_type (Required)
  # 設定内容: 予約タイプ。予約したIPアドレスの使用方法を決定します。
  # 設定可能な値:
  #   - "prefix": プレフィックスを単一のネットワークインターフェイスに割り当てることを許可します。
  #              プレフィックスデリゲーション用途で使用され、予約作成時に利用可能なIPアドレス数が即座に減少します。
  #              詳細: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-prefix-eni.html
  #   - "explicit": 個別のIPアドレスを単一のネットワークインターフェイスに手動で割り当てることを許可します。
  #                IPアドレスが実際に割り当てられた時点で利用可能なIPアドレス数が減少します。
  # 用途: プレフィックスデリゲーションまたは明示的なIP割り当てのどちらかを選択します。
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_CreateSubnetCidrReservation.html
  reservation_type = "prefix"

  # subnet_id (Required)
  # 設定内容: 予約を作成するサブネットのID。
  # 設定可能な値: 有効なサブネットID（例: subnet-12345678）
  # 用途: このサブネット内で指定されたCIDRブロックが予約されます。
  subnet_id = "subnet-12345678"

  #-------------------------------------------------------------
  # オプションパラメータ
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: 予約の簡潔な説明。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  # 用途: 予約の目的や用途を識別するための説明を記載できます。
  description = "Example CIDR reservation for prefix delegation"

  # id (Optional)
  # 設定内容: CIDR予約のID。
  # 設定可能な値: CIDR予約ID（例: scr-044f977c4e12345678）
  # 省略時: AWS側で自動生成されます
  # 用途: 通常はTerraformで明示的に設定する必要はありません。
  #       AWS側で自動生成され、computed属性として取得できます。
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_SubnetCidrReservation.html
  id = null

  # region (Optional)
  # 設定内容: このリソースが管理されるリージョン。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定で指定されたリージョンがデフォルトで使用されます
  # 用途: マルチリージョン構成で明示的にリージョンを指定する場合に使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  #       https://registry.terraform.io/providers/hashicorp/aws/latest/docs#aws-configuration-reference
  region = null

  #-------------------------------------------------------------
  # 読み取り専用属性 (Computed Only - テンプレートには含めない)
  #-------------------------------------------------------------
  # 以下の属性はAWS側で自動的に設定されるため、Terraformコードでは指定できません。
  # terraform apply後にstate内で参照可能です。
  #
  # owner_id (Computed)
  # 説明: このCIDR予約を所有するAWSアカウントのID
  # Type: string
  #-------------------------------------------------------------
}

################################################################################
# 補足情報
################################################################################
#
# サブネットCIDR予約のルール:
#
# 1. 予約作成時にIPアドレスが既に使用中でも問題なし
#    - 既に使用中のIPアドレスが含まれていても予約を作成できます
#    - 予約を作成しても、既に使用中のIPアドレスは割り当て解除されません
#
# 2. サブネットごとに複数のCIDR範囲を予約可能
#    - 同一VPC内で予約する場合、CIDR範囲は重複できません
#
# 3. プレフィックスデリゲーション用の複数予約
#    - サブネット内にプレフィックスデリゲーション用の複数の範囲を予約でき、
#      自動割り当てが設定されている場合、ランダムに選択されます
#
# 4. 予約削除時の動作
#    - 予約を削除すると、未使用のIPアドレスがAWSによる割り当て対象として利用可能になります
#    - 削除しても、使用中のIPアドレスは割り当て解除されません
#
# 5. 利用可能IPアドレス数への影響
#    - reservation_type = "prefix": 予約作成時に即座にカウントが減少
#    - reservation_type = "explicit": IPアドレスが実際に割り当てられた時点でカウントが減少
#
# 関連リソース:
#   - aws_subnet: サブネットの作成
#   - aws_vpc: VPCの作成
#   - aws_network_interface: ネットワークインターフェイスの管理
#
# 公式ドキュメント:
#   - Terraform: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_subnet_cidr_reservation
#   - AWS VPC User Guide: https://docs.aws.amazon.com/vpc/latest/userguide/subnet-cidr-reservation.html
#   - AWS API Reference: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_CreateSubnetCidrReservation.html
#   - SubnetCidrReservation: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_SubnetCidrReservation.html
#   - Prefix ENI: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-prefix-eni.html
#
################################################################################
