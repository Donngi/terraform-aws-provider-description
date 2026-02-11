#---------------------------------------------------------------
# AWS Elastic IP Association
#---------------------------------------------------------------
#
# Elastic IP（EIP）とEC2インスタンスまたはElastic Network Interface（ENI）との
# 関連付けを管理するリソースです。EIPは静的IPv4アドレスで、動的なクラウド
# コンピューティング環境でも変わらないIPアドレスを提供します。
#
# AWS公式ドキュメント:
#   - Elastic IPアドレス: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html
#   - EIPの関連付け: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html#using-instance-addressing-eips-associating
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip_association
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_eip_association" "example" {
  #-------------------------------------------------------------
  # EIP識別子設定
  #-------------------------------------------------------------

  # allocation_id (Optional)
  # 設定内容: VPC内のElastic IPのAllocation IDを指定します。
  # 設定可能な値: EIPのAllocation ID（eipalloc-で始まる文字列）
  # 注意: public_ipと排他的（どちらか一方のみ指定可能）
  # 関連機能: VPC Elastic IP
  #   VPC内で使用するEIPを識別するためのID。aws_eipリソースの
  #   idまたはallocation_id属性から取得可能。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html
  allocation_id = "eipalloc-12345678"

  # public_ip (Optional)
  # 設定内容: EC2-Classic環境またはデフォルトVPCでのElastic IPのパブリックIPアドレスを指定します。
  # 設定可能な値: パブリックIPv4アドレス
  # 注意: allocation_idと排他的（どちらか一方のみ指定可能）
  # 関連機能: EC2-Classic Elastic IP
  #   EC2-Classic環境またはデフォルトVPCで使用するEIPのIPアドレス。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html
  public_ip = null

  #-------------------------------------------------------------
  # 関連付け対象設定
  #-------------------------------------------------------------

  # instance_id (Optional)
  # 設定内容: EIPを関連付けるEC2インスタンスのIDを指定します。
  # 設定可能な値: インスタンスID（i-で始まる文字列）
  # 注意: network_interface_idと排他的（どちらか一方のみ指定可能）
  # 関連機能: EC2インスタンスへのEIP関連付け
  #   EC2インスタンスに直接EIPを関連付ける場合に使用。
  #   インスタンスのプライマリネットワークインターフェースに関連付けられます。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html#using-instance-addressing-eips-associating
  instance_id = "i-1234567890abcdef0"

  # network_interface_id (Optional)
  # 設定内容: EIPを関連付けるネットワークインターフェースのIDを指定します。
  # 設定可能な値: ネットワークインターフェースID（eni-で始まる文字列）
  # 注意: instance_idと排他的（どちらか一方のみ指定可能）
  # 関連機能: ENIへのEIP関連付け
  #   Elastic Network Interfaceに直接EIPを関連付ける場合に使用。
  #   より細かいネットワーク制御が可能。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-eni.html
  network_interface_id = null

  # private_ip_address (Optional)
  # 設定内容: ネットワークインターフェース上で関連付けるプライベートIPアドレスを指定します。
  # 設定可能な値: ネットワークインターフェースに割り当てられたプライベートIPv4アドレス
  # 省略時: ネットワークインターフェースのプライマリプライベートIPアドレスが使用されます
  # 注意: network_interface_idが指定されている場合にのみ関連
  # 関連機能: セカンダリプライベートIPへの関連付け
  #   ENIに複数のプライベートIPアドレスが割り当てられている場合、
  #   特定のプライベートIPにEIPを関連付けることができます。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/MultipleIP.html
  private_ip_address = null

  #-------------------------------------------------------------
  # 関連付けオプション
  #-------------------------------------------------------------

  # allow_reassociation (Optional)
  # 設定内容: EIPが既に関連付けられている場合に、再関連付けを許可するかを指定します。
  # 設定可能な値:
  #   - true: 既存の関連付けを解除して、新しいリソースに再関連付け可能
  #   - false (デフォルト): 既に関連付けられているEIPの再関連付けを拒否
  # 注意: EC2-ClassicおよびデフォルトVPCのEIPでは必須
  # 関連機能: EIPの再関連付け
  #   EIPが既に他のリソースに関連付けられている場合の動作を制御。
  #   trueにすると、既存の関連付けを自動的に解除して新しいリソースに
  #   関連付けます。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html#using-instance-addressing-eips-associating
  allow_reassociation = false

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # 内部識別子（通常は指定不要）
  #-------------------------------------------------------------

  # id (Optional)
  # 設定内容: リソースの内部識別子（通常はTerraformが自動管理）
  # 設定可能な値: 文字列
  # 注意: 通常、このフィールドを明示的に設定する必要はありません
  id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# 本リソースには、上記で設定した属性以外の読み取り専用属性は
# エクスポートされません。設定した全ての属性が参照可能です。
#---------------------------------------------------------------
