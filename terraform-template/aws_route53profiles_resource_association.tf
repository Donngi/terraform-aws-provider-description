#---------------------------------------------------------------
# AWS Route 53 Profiles Resource Association
#---------------------------------------------------------------
#
# Amazon Route 53 ProfilesのResource Associationをプロビジョニングするリソースです。
# Route 53プロファイルに対してDNSリソース（Route 53ホストゾーンなど）を
# 関連付けることで、プロファイルを通じてDNSクエリルーティングを管理します。
#
# AWS公式ドキュメント:
#   - Route 53 Profiles API: https://docs.aws.amazon.com/Route53/latest/APIReference/API_route53profiles_Profile.html
#   - リージョナルエンドポイント: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53profiles_resource_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_route53profiles_resource_association" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: プロファイルリソースアソシエーションの名前を指定します。
  # 設定可能な値: 文字列
  # 用途: このリソースアソシエーションを識別するための名前
  # 参考: https://docs.aws.amazon.com/Route53/latest/APIReference/API_route53profiles_Profile.html
  name = "example"

  # profile_id (Required)
  # 設定内容: VPCに関連付けられるプロファイルのIDを指定します。
  # 設定可能な値: Route 53プロファイルのID（例: aws_route53profiles_profile.example.id）
  # 用途: リソースを関連付ける対象のプロファイルを指定
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53profiles_profile
  profile_id = "rp-1234567890abcdef0"

  # resource_arn (Required)
  # 設定内容: プロファイルに関連付けるリソースのARNを指定します。
  # 設定可能な値: AWSリソースのARN（例: Route 53ホストゾーンのARN）
  # 用途: プロファイルと関連付けるDNSリソースを指定
  # 参考: https://docs.aws.amazon.com/Route53/latest/APIReference/API_route53profiles_Profile.html
  resource_arn = "arn:aws:route53:::hostedzone/Z1234567890ABC"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  #       https://registry.terraform.io/providers/hashicorp/aws/latest/docs#aws-configuration-reference
  region = null

  #-------------------------------------------------------------
  # リソースプロパティ設定
  #-------------------------------------------------------------

  # resource_properties (Optional)
  # 設定内容: プロファイルに関連付けるリソースのプロパティを指定します。
  # 設定可能な値: JSON形式の文字列
  # 省略時: リソースプロパティは設定されません
  # 用途: リソース固有の設定を行う場合に使用
  # 参考: https://docs.aws.amazon.com/Route53/latest/APIReference/API_route53profiles_Profile.html
  resource_properties = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30s", "5m", "2h"）
    # 省略時: デフォルトのタイムアウト値を使用
    # 参考: https://pkg.go.dev/time#ParseDuration
    create = "30m"

    # read (Optional)
    # 設定内容: リソース読み込み時のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30s", "5m", "2h"）
    # 省略時: デフォルトのタイムアウト値を使用
    # 用途: refresh操作やプランニング操作中の読み込み時に適用
    # 参考: https://pkg.go.dev/time#ParseDuration
    read = "20m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30s", "5m", "2h"）
    # 省略時: デフォルトのタイムアウト値を使用
    # 注意: delete操作のタイムアウトは、destroy操作の前に変更がstateに保存される場合のみ適用されます
    # 参考: https://pkg.go.dev/time#ParseDuration
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: プロファイルリソースアソシエーションのID
#
# - owner_id: プロファイルリソースアソシエーションを所有するAWSアカウントID
#
# - resource_type: プロファイルに関連付けられたリソースのタイプ
#
# - status: プロファイルアソシエーションのステータス
#           有効な値については以下を参照:
#           https://docs.aws.amazon.com/Route53/latest/APIReference/API_route53profiles_Profile.html
#
# - status_message: プロファイルリソースアソシエーションのステータスメッセージ
#---------------------------------------------------------------
