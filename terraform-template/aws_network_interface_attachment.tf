#---------------------------------------------------------------
# AWS Network Interface Attachment
#---------------------------------------------------------------
#
# EC2 インスタンスに Elastic Network Interface (ENI) をアタッチするリソースです。
# ネットワークインターフェースアタッチメントにより、インスタンスに追加の
# ネットワークインターフェースを接続し、複数のネットワーク設定を実現できます。
# 複数のネットワークカードをサポートするインスタンスタイプでは、
# 各ネットワークカードに複数のインターフェースをアタッチ可能です。
#
# 主な機能:
#   - EC2 インスタンスに追加のネットワークインターフェースをアタッチ
#   - デバイスインデックスとネットワークカードインデックスを指定
#   - 実行中、停止中、起動時のいずれかの状態でアタッチ可能
#   - セカンダリネットワークインターフェースは実行中または停止中にデタッチ可能
#
# NOTE: プライマリネットワークインターフェース（デバイスインデックス0）は
#       インスタンスの起動時に自動的に作成され、インスタンスの削除時まで
#       デタッチできません。このリソースはセカンダリインターフェースの
#       アタッチメント管理に使用します。
#
# AWS公式ドキュメント:
#   - Network Interface Attachments: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/network-interface-attachments.html
#   - Using ENI: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-eni.html
#   - API Reference: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_AttachNetworkInterface.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface_attachment
#
# Provider Version: 6.28.0
# Generated: 2026-02-02
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_network_interface_attachment" "example" {
  #-------------------------------------------------------------
  # 必須パラメータ
  #-------------------------------------------------------------

  # instance_id (Required)
  # 設定内容: ネットワークインターフェースをアタッチする EC2 インスタンスの ID を指定します。
  # 設定可能な値: 有効なインスタンス ID（例: i-1234567890abcdef0）
  # 注意:
  #   - インスタンスは実行中、停止中、起動中のいずれかの状態である必要があります。
  #   - インスタンスタイプによってアタッチ可能なネットワークインターフェースの
  #     数が異なります。各インスタンスタイプの制限を確認してください。
  #   - アタッチメント後、インスタンスを再起動する必要がある場合があります。
  # AWS参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-eni.html#AvailableIpPerENI
  instance_id = "i-1234567890abcdef0"

  # network_interface_id (Required)
  # 設定内容: アタッチするネットワークインターフェース（ENI）の ID を指定します。
  # 設定可能な値: 有効なネットワークインターフェース ID（例: eni-1234567890abcdef0）
  # 注意:
  #   - ネットワークインターフェースは同じアベイラビリティーゾーンに
  #     存在する必要があります。
  #   - ネットワークインターフェースが既に別のインスタンスにアタッチ
  #     されていないことを確認してください。
  #   - インスタンスと同じ VPC に属している必要があります。
  # AWS参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-eni.html
  network_interface_id = "eni-1234567890abcdef0"

  # device_index (Required)
  # 設定内容: ネットワークインターフェースのデバイスインデックスを指定します。
  # 設定可能な値: 0 以上の整数
  # 注意:
  #   - デバイスインデックス 0 はプライマリネットワークインターフェース用に予約されています。
  #   - セカンダリネットワークインターフェースには 1 以上の値を指定します。
  #   - 同一インスタンス上で重複しないデバイスインデックスを使用してください。
  #   - インスタンスタイプによってサポートされるデバイスインデックスの
  #     最大値が異なります。
  # AWS参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-eni.html#network-cards
  device_index = 1

  #-------------------------------------------------------------
  # オプションパラメータ
  #-------------------------------------------------------------

  # network_card_index (Optional)
  # 設定内容: ネットワークカードのインデックスを指定します。
  # 設定可能な値: 0 以上の整数（デフォルト: 0）
  # 省略時: 0（プライマリネットワークカード）が使用されます。
  # 注意:
  #   - 複数のネットワークカードをサポートするインスタンスタイプでのみ
  #     0 より大きい値を指定できます。
  #   - 対応インスタンスタイプ: P4d、P3dn、G4dn など一部の高性能インスタンス
  #   - ネットワークカードごとに複数のネットワークインターフェースを
  #     アタッチできます。
  # AWS参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-eni.html#network-cards
  network_card_index = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースが管理されるリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定で指定されたリージョンがデフォルトとして使用されます。
  # 注意:
  #   - ネットワークインターフェースとインスタンスは同じリージョンに
  #     存在する必要があります。
  #   - クロスリージョンでのアタッチメントはサポートされていません。
  # AWS参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# アウトプット例
#---------------------------------------------------------------
#
# ネットワークインターフェースアタッチメントの情報を出力する場合の例:
#
# output "attachment_id" {
#   description = "ネットワークインターフェースアタッチメントの ID"
#   value       = aws_network_interface_attachment.example.attachment_id
# }
#
# output "instance_id" {
#   description = "アタッチメントが関連付けられているインスタンスの ID"
#   value       = aws_network_interface_attachment.example.instance_id
# }
#
# output "network_interface_id" {
#   description = "アタッチされたネットワークインターフェースの ID"
#   value       = aws_network_interface_attachment.example.network_interface_id
# }
#
# output "status" {
#   description = "ネットワークインターフェースアタッチメントのステータス"
#   value       = aws_network_interface_attachment.example.status
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 属性リファレンス
#---------------------------------------------------------------
#
# このリソースは以下の属性をエクスポートします:
#
# - id
#   説明: ネットワークインターフェースアタッチメントの ID
#   用途: Terraform でのリソース参照、依存関係の管理など
#
# - attachment_id
#   説明: ENI アタッチメント ID（AWS が割り当てる一意の識別子）
#   用途: AWS API での直接操作、デタッチメント操作など
#   例: eni-attach-1234567890abcdef0
#
# - instance_id
#   説明: アタッチメントが関連付けられているインスタンスの ID
#   用途: インスタンス情報の取得、クロスリファレンスなど
#
# - network_interface_id
#   説明: アタッチされたネットワークインターフェースの ID
#   用途: ENI 情報の取得、他のリソースでの参照など
#
# - status
#   説明: ネットワークインターフェースアタッチメントのステータス
#   用途: アタッチメント状態の監視、条件分岐など
#   可能な値: attaching, attached, detaching, detached
#
#---------------------------------------------------------------

#---------------------------------------------------------------
#
# EC2 インスタンスにセカンダリネットワークインターフェースを
# アタッチする基本的な例:
#
# # VPC とサブネット
# resource "aws_vpc" "main" {
#   cidr_block = "10.0.0.0/16"
# }
#
# resource "aws_subnet" "main" {
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = "10.0.1.0/24"
#   availability_zone = "us-east-1a"
# }
#
# # セキュリティグループ
# resource "aws_security_group" "allow_all" {
#   name        = "allow_all"
#   description = "Allow all inbound traffic"
#   vpc_id      = aws_vpc.main.id
#
#   ingress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }
#
# # EC2 インスタンス
# resource "aws_instance" "test" {
#   ami           = "ami-0c55b159cbfafe1f0"
#   instance_type = "t3.micro"
#   subnet_id     = aws_subnet.main.id
# }
#
# # セカンダリネットワークインターフェース
# resource "aws_network_interface" "test" {
#   subnet_id       = aws_subnet.main.id
#   security_groups = [aws_security_group.allow_all.id]
#   private_ips     = ["10.0.1.100"]
# }
#
# # アタッチメント
# resource "aws_network_interface_attachment" "test" {
#   instance_id          = aws_instance.test.id
#   network_interface_id = aws_network_interface.test.id
#   device_index         = 1
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
#
# 複数のネットワークカードをサポートするインスタンスタイプ
# （例: p4d.24xlarge）で複数の ENI をアタッチする例:
#
# resource "aws_instance" "multi_card" {
#   ami           = "ami-0c55b159cbfafe1f0"
#   instance_type = "p4d.24xlarge"
#   subnet_id     = aws_subnet.main.id
# }
#
# # ネットワークカード 0 のセカンダリインターフェース
# resource "aws_network_interface" "card0_secondary" {
#   subnet_id   = aws_subnet.main.id
#   private_ips = ["10.0.1.101"]
# }
#
# resource "aws_network_interface_attachment" "card0_secondary" {
#   instance_id          = aws_instance.multi_card.id
#   network_interface_id = aws_network_interface.card0_secondary.id
#   device_index         = 1
#   network_card_index   = 0
# }
#
# # ネットワークカード 1 のプライマリインターフェース
# resource "aws_network_interface" "card1_primary" {
#   subnet_id   = aws_subnet.main.id
#   private_ips = ["10.0.1.102"]
# }
#
# resource "aws_network_interface_attachment" "card1_primary" {
#   instance_id          = aws_instance.multi_card.id
#   network_interface_id = aws_network_interface.card1_primary.id
#   device_index         = 1
#   network_card_index   = 1
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
#
# フェイルオーバー時に ENI を別のインスタンスに移行する例:
#
# # プライマリインスタンス
# resource "aws_instance" "primary" {
#   ami           = "ami-0c55b159cbfafe1f0"
#   instance_type = "t3.micro"
#   subnet_id     = aws_subnet.main.id
# }
#
# # スタンバイインスタンス
# resource "aws_instance" "standby" {
#   ami           = "ami-0c55b159cbfafe1f0"
#   instance_type = "t3.micro"
#   subnet_id     = aws_subnet.main.id
# }
#
# # 共有ネットワークインターフェース（VIP用など）
# resource "aws_network_interface" "shared" {
#   subnet_id   = aws_subnet.main.id
#   private_ips = ["10.0.1.200"]
# }
#
# # 変数でアタッチ先を切り替え
# variable "active_instance" {
#   description = "Active instance for ENI attachment"
#   type        = string
#   default     = "primary"  # または "standby"
# }
#
# resource "aws_network_interface_attachment" "shared" {
#   instance_id = var.active_instance == "primary" ?
#                 aws_instance.primary.id :
#                 aws_instance.standby.id
#   network_interface_id = aws_network_interface.shared.id
#   device_index         = 1
# }
#
# # フェイルオーバー時は変数を変更して terraform apply
#
#---------------------------------------------------------------

#---------------------------------------------------------------
#
# 1. デバイスインデックスの管理
#    - デバイスインデックス 0 はプライマリ ENI 用に予約
#    - セカンダリ ENI には 1 から順番に割り当て
#    - インスタンスタイプの制限を事前に確認
#
# 2. ネットワーク設計
#    - 各 ENI を異なるセキュリティグループに関連付けて役割を分離
#    - 管理用、データ用、バックアップ用などトラフィックを分離
#    - 同一サブネット内の複数 ENI は通信の問題を引き起こす可能性あり
#
# 3. 高可用性
#    - ENI はフェイルオーバー時に別インスタンスに移行可能
#    - VIP（仮想IP）の実装に ENI を活用
#    - depends_on を使用して適切な順序でリソース作成
#
# 4. セキュリティ
#    - 各 ENI に適切なセキュリティグループを適用
#    - ソース/デスティネーションチェックの設定を確認
#    - プライベート IP の適切な管理（IP アドレスの枯渇を防ぐ）
#
# 5. パフォーマンス
#    - 複数ネットワークカード対応インスタンスでは適切に分散
#    - Enhanced Networking が有効なインスタンスタイプを選択
#    - ネットワーク帯域幅の制限を考慮
#
# 6. 依存関係管理
#    - インスタンスと ENI の作成順序を depends_on で制御
#    - アタッチメント前に両リソースが作成完了していることを確認
#
# 7. ライフサイクル管理
#    - デタッチ時は attachment_id を使用
#    - delete_on_termination 属性に注意（ENI 側で設定）
#    - インスタンス削除時の ENI の動作を理解する
#
# 8. トラブルシューティング
#    - status 属性でアタッチメント状態を監視
#    - OS レベルでのネットワーク設定が必要な場合あり
#    - アタッチ後、インスタンス内で ip link show で確認
#
# 9. インポート
#    - 既存のアタッチメントは以下でインポート可能:
#      terraform import aws_network_interface_attachment.example eni-attach-1234567890abcdef0
#
#---------------------------------------------------------------
