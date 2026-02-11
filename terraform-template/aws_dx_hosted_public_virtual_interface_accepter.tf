#---------------------------------------------------------------
# Direct Connect Hosted Public Virtual Interface Accepter
#---------------------------------------------------------------
#
# このリソースは、他のAWSアカウントによって作成されたDirect Connect
# ホステッドパブリック仮想インターフェースの所有権を受け入れる側を管理します。
#
# パブリック仮想インターフェースは、Amazon S3やDynamoDBなどのAWSパブリック
# サービスに接続するために使用されます。ホステッド仮想インターフェースは、
# Direct Connect接続の所有者が別のAWSアカウント用に作成し、そのアカウントが
# 受け入れることで利用可能になります。
#
# AWS公式ドキュメント:
#   - Accept a hosted virtual interface: https://docs.aws.amazon.com/directconnect/latest/UserGuide/accepthostedvirtualinterface.html
#   - Hosted virtual interfaces: https://docs.aws.amazon.com/directconnect/latest/UserGuide/hosted-vif.html
#   - ConfirmPublicVirtualInterface API: https://docs.aws.amazon.com/directconnect/latest/APIReference/API_ConfirmPublicVirtualInterface.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dx_hosted_public_virtual_interface_accepter
#
# Provider Version: 6.28.0
# Generated: 2026-01-25
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_dx_hosted_public_virtual_interface_accepter" "example" {

  #---------------------------------------------------------------
  # 必須パラメータ (Required)
  #---------------------------------------------------------------

  # virtual_interface_id - 受け入れるDirect Connect仮想インターフェースのID
  #
  # 他のAWSアカウントによって作成されたホステッドパブリック仮想インターフェースのIDを指定します。
  # このIDは、仮想インターフェースの作成者から提供される必要があります。
  # 通常、"dxvif-"で始まる一意の識別子です。
  #
  # 例: "dxvif-xxxxxxxx"
  #
  # Type: string (required)
  virtual_interface_id = "dxvif-xxxxxxxx"


  #---------------------------------------------------------------
  # オプションパラメータ (Optional)
  #---------------------------------------------------------------

  # region - リソースを管理するリージョン
  #
  # このリソースを管理するAWSリージョンを指定します。
  # 指定しない場合は、プロバイダー設定で指定されたリージョンがデフォルトで使用されます。
  # Direct Connectの仮想インターフェースは、リージョンに依存しますが、
  # 実際の物理接続は特定のDirect Connectロケーションに紐付いています。
  #
  # 例: "us-east-1", "ap-northeast-1"
  #
  # 公式ドキュメント:
  #   - AWS Regions and Endpoints: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  #
  # Type: string (optional)
  # Default: プロバイダー設定のリージョン
  region = null

  # tags - リソースに割り当てるタグのマップ
  #
  # 仮想インターフェース受け入れ側に割り当てるキーと値のペアのマップです。
  # タグを使用して、リソースの分類、管理、コスト配分を行うことができます。
  #
  # プロバイダーレベルでdefault_tagsが設定されている場合、
  # ここで指定したタグは、キーが一致するdefault_tagsを上書きします。
  #
  # 例:
  # tags = {
  #   Environment = "production"
  #   Side        = "Accepter"
  #   Project     = "network-infrastructure"
  #   ManagedBy   = "terraform"
  # }
  #
  # Type: map(string) (optional)
  # Default: null
  tags = null

}

#---------------------------------------------------------------
# Attributes Reference (参照可能な属性)
#---------------------------------------------------------------
#
# このリソースは以下の属性をエクスポートします。
# これらは terraform state で参照可能ですが、設定で指定することはできません。
#
# - id
#   仮想インターフェースのID。virtual_interface_idと同じ値です。
#
# - arn
#   仮想インターフェースのARN (Amazon Resource Name)。
#   形式: arn:aws:directconnect:region:account-id:dxvif/virtual-interface-id
#
# - tags_all
#   リソースに割り当てられたすべてのタグのマップ。
#   これには、tagsで指定したタグと、プロバイダーのdefault_tagsで
#   継承されたタグが含まれます。
#
# 使用例:
#   output "vif_id" {
#     value = aws_dx_hosted_public_virtual_interface_accepter.example.id
#   }
#
#   output "vif_arn" {
#     value = aws_dx_hosted_public_virtual_interface_accepter.example.arn
#   }
#
#---------------------------------------------------------------
