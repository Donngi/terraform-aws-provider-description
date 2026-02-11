#---------------------------------------------------------------
# AWS Route 53 Profiles Association
#---------------------------------------------------------------
#
# Route 53 ProfileとVPC（Virtual Private Cloud）を関連付けるリソースです。
# Route 53 Profilesは、複数のVPC間でDNS設定（プライベートホストゾーン、
# Resolverルール、DNS Firewallルールグループなど）を一元管理するための
# 機能です。1つのProfileは最大5000個のVPCに関連付けることができますが、
# 1つのVPCには1つのProfileしか関連付けることができません。
#
# 主な用途:
#   - マルチVPC環境でのDNS設定の一元管理
#   - 複数アカウント間でのDNSガバナンスの統一
#   - プライベートホストゾーンやResolverルールの効率的な共有
#   - Interface VPC EndpointのDNS設定の簡素化
#
# AWS公式ドキュメント:
#   - Route 53 Profiles概要: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/profile-high-level-steps.html
#   - ProfileとVPCの関連付け: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/profile-associate-vpcs.html
#   - AssociateProfile API: https://docs.aws.amazon.com/Route53/latest/APIReference/API_route53profiles_AssociateProfile.html
#   - GetProfileAssociation API: https://docs.aws.amazon.com/Route53/latest/APIReference/API_route53profiles_GetProfileAssociation.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53profiles_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_route53profiles_association" "example" {
  #-------------------------------------------------------------
  # 必須パラメータ
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: Profile関連付けの名前を指定します。
  # 設定可能な値: 英数字、ハイフン、アンダースコア、アポストロフィ（最大64文字）
  # パターン: (?!^[0-9]+$)([a-zA-Z0-9\-_' ']+)
  # 用途: Profile関連付けを識別するための分かりやすい名前を設定します。
  #       例: "production-vpc-profile", "dev-environment-dns"
  # 参考: https://docs.aws.amazon.com/Route53/latest/APIReference/API_route53profiles_AssociateProfile.html
  name = "example-profile-association"

  # profile_id (Required)
  # 設定内容: 関連付けるRoute 53 ProfileのIDを指定します。
  # 設定可能な値: Route 53 ProfileのリソースID（rp-xxxxxxxxxxxxxxxxx形式）
  # 用途: VPCに適用したいDNS設定（プライベートホストゾーン、Resolverルール、
  #       DNS Firewallルールグループなど）を含むProfileを指定します。
  # 制約: 1つのProfileは最大5000個のVPCに関連付けることができます。
  # 参考: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/profile-high-level-steps.html
  profile_id = "rp-1234567890abcdef0"

  # resource_id (Required)
  # 設定内容: Profileを関連付けるVPCのIDを指定します。
  # 設定可能な値: VPCリソースID（vpc-xxxxxxxxxxxxxxxxx形式）
  # 用途: Route 53 ProfileのDNS設定を適用したいVPCを指定します。
  # 制約: 1つのVPCには1つのProfileしか関連付けることができません。
  #       すでにProfileが関連付けられているVPCに別のProfileを関連付けると
  #       エラーが発生します。
  # 参考: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/profile-associate-vpcs.html
  resource_id = "vpc-1234567890abcdef0"

  #-------------------------------------------------------------
  # オプションパラメータ
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: AWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定で指定されたリージョンが使用されます。
  # 用途: 特定のリージョンでProfile関連付けを管理する必要がある場合に使用します。
  #       通常は省略してプロバイダーのデフォルト設定を使用することが推奨されます。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # tags (Optional)
  # 設定内容: Profile関連付けに付与するタグを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 用途: リソースの分類、コスト管理、アクセス制御などに使用します。
  # タイムアウト設定 (Optional)
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: 特定の操作のタイムアウト時間を設定します。
  # 用途: デフォルトのタイムアウト時間を変更する必要がある場合に使用します。
  #       大規模な環境や複雑なDNS設定を含むProfile関連付けの場合、
  #       作成や更新に時間がかかる可能性があります。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30s", "5m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が適用されます
    # 参考: https://pkg.go.dev/time#ParseDuration
    create = null

    # update (Optional)
    # 設定内容: リソース更新操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30s", "5m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が適用されます
    update = null

    # delete (Optional)
    # 設定内容: リソース削除操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30s", "5m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が適用されます
    # 注意: 削除操作は状態に変更が保存される場合にのみ適用されます。
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Profile関連付けの一意の識別子
#       形式: rpassoc-xxxxxxxxxxxxxxxxx
#       用途: 他のリソースやデータソースからこの関連付けを参照する際に使用
#
# - arn: Profile関連付けのAmazon Resource Name (ARN)
#       形式: arn:aws:route53profiles:region:account-id:profile-association/id
#       用途: IAMポリシーやCloudTrailログでリソースを識別する際に使用
#
# - owner_id: Profile関連付けを所有するAWSアカウントID
#       用途: クロスアカウント環境でのリソース所有者の確認に使用
#
# - status: Profile関連付けの現在のステータス
#       設定可能な値:
#         - COMPLETE: 関連付けが正常に完了
#         - CREATING: 関連付けを作成中
#         - UPDATING: 関連付けを更新中
#         - DELETING: 関連付けを削除中
#         - DELETED: 関連付けが削除済み
#         - FAILED: 関連付けが失敗
#       用途: 関連付けの進行状況を確認する際に使用
#---------------------------------------------------------------
