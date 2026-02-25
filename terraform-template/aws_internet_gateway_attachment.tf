#---------------------------------------------------------------
# AWS Internet Gateway Attachment
#---------------------------------------------------------------
#
# VPC（Virtual Private Cloud）にインターネットゲートウェイをアタッチする
# リソースです。インターネットゲートウェイをアタッチすることで、VPC内の
# リソースがインターネットと通信できるようになります。
# 既存のインターネットゲートウェイを特定のVPCに関連付ける際に使用します。
#
# AWS公式ドキュメント:
#   - インターネットゲートウェイのアタッチ (API): https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_AttachInternetGateway.html
#   - インターネットゲートウェイ添付 (API型): https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_InternetGatewayAttachment.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway_attachment
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_internet_gateway_attachment" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # internet_gateway_id (Required)
  # 設定内容: アタッチするインターネットゲートウェイのIDを指定します。
  # 設定可能な値: 有効なインターネットゲートウェイID（例: igw-xxxxxxxxxxxxxxxxx）
  internet_gateway_id = "igw-xxxxxxxxxxxxxxxxx"

  # vpc_id (Required)
  # 設定内容: インターネットゲートウェイをアタッチする対象のVPC IDを指定します。
  # 設定可能な値: 有効なVPC ID（例: vpc-xxxxxxxxxxxxxxxxx）
  vpc_id = "vpc-xxxxxxxxxxxxxxxxx"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: "60s", "5m", "2h" などのGo duration文字列
    # 省略時: プロバイダーのデフォルトタイムアウトを使用します。
    create = null

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: "60s", "5m", "2h" などのGo duration文字列
    # 省略時: プロバイダーのデフォルトタイムアウトを使用します。
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: VPC IDとインターネットゲートウェイIDをコロンで連結した文字列
#       （例: vpc-xxxxxxxxxxxxxxxxx:igw-xxxxxxxxxxxxxxxxx）
#---------------------------------------------------------------
