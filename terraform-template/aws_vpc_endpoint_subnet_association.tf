#---------------------------------------------------------------
# VPC エンドポイント サブネット アソシエーション
#---------------------------------------------------------------
#
# VPCエンドポイントとサブネット間の関連付けを作成します。
# Interface型のVPCエンドポイント（例：EC2、Lambda等のAWSサービス）を
# 特定のサブネットに配置する際に使用します。
#
# 注意事項:
#   - VPC Endpointリソースの`subnet_ids`属性と、このリソースで同一の
#     subnet_idを使用しないでください。関連付けが競合し、上書きされます。
#   - Interface型VPCエンドポイントでのみ使用可能です。
#     Gateway型エンドポイント（S3、DynamoDB）では使用できません。
#
# AWS公式ドキュメント:
#   - VPC エンドポイント: https://docs.aws.amazon.com/vpc/latest/privatelink/vpc-endpoints.html
#   - インターフェイスエンドポイント: https://docs.aws.amazon.com/vpc/latest/privatelink/vpce-interface.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_subnet_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpc_endpoint_subnet_association" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # vpc_endpoint_id (Required)
  # 設定内容: 関連付けを行うVPCエンドポイントのIDを指定します。
  # 設定可能な値: 有効なVPCエンドポイントID（Interface型のみ）
  # 注意: Interface型のVPCエンドポイントである必要があります。
  #       Gateway型エンドポイント（S3、DynamoDB）では使用できません。
  # 参考: https://docs.aws.amazon.com/vpc/latest/privatelink/vpce-interface.html
  vpc_endpoint_id = "vpce-xxxxxxxxxxxxxxxxx"

  # subnet_id (Required)
  # 設定内容: VPCエンドポイントに関連付けるサブネットのIDを指定します。
  # 設定可能な値: 有効なサブネットID
  # 関連機能: VPCエンドポイント ネットワークインターフェイス
  #   VPCエンドポイントのネットワークインターフェイス（ENI）が
  #   このサブネット内に作成されます。
  #   - https://docs.aws.amazon.com/vpc/latest/privatelink/vpce-interface.html#vpce-interface-availability-zones
  # 注意: サブネットは、VPCエンドポイントと同じVPC内である必要があります。
  #       サブネットに十分なIPアドレス空間があることを確認してください。
  subnet_id = "subnet-xxxxxxxxxxxxxxxxx"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "ap-northeast-1"

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース作成・削除時のタイムアウト値を設定します。
  # 省略時: デフォルト値が使用されます（通常は10分）
  # timeouts {
  #   # create (Optional)
  #   # 設定内容: VPCエンドポイントサブネット関連付けの作成処理の最大待機時間
  #   # 設定可能な値: 時間の文字列形式（例: "10m", "15m", "30m"）
  #   # 省略時: 10分
  #   create = "10m"
  #
  #   # delete (Optional)
  #   # 設定内容: VPCエンドポイントサブネット関連付けの削除処理の最大待機時間
  #   # 設定可能な値: 時間の文字列形式（例: "10m", "15m", "30m"）
  #   # 省略時: 10分
  #   delete = "10m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference（参照専用の出力属性）
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 関連付けのID。"{vpc_endpoint_id}_{subnet_id}"の形式で自動生成されます。
#       例: "vpce-0a1b2c3d4e5f6g7h8_subnet-0a1b2c3d4e5f6g7h8"
#
# 使用例:
#   output "association_id" {
#     value = aws_vpc_endpoint_subnet_association.example.id
#   }
#---------------------------------------------------------------
