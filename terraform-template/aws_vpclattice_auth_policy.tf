#---------------------------------------------------------------
# AWS VPC Lattice Auth Policy
#---------------------------------------------------------------
#
# Amazon VPC Latticeの認証ポリシー（Auth Policy）をプロビジョニングするリソースです。
# 認証ポリシーは、VPC Latticeサービスネットワークまたはサービスへのアクセスを制御するために
# 使用されます。IAMポリシーと同様の構文を使用し、プリンシパル、エフェクト、アクション、
# リソース、条件などの要素を含みます。
#
# AWS公式ドキュメント:
#   - VPC Lattice Auth Policies: https://docs.aws.amazon.com/vpc-lattice/latest/ug/auth-policies.html
#   - VPC Latticeアクセス管理: https://docs.aws.amazon.com/vpc-lattice/latest/ug/access-management-overview.html
#   - PutAuthPolicy API: https://docs.aws.amazon.com/vpc-lattice/latest/APIReference/API_PutAuthPolicy.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpclattice_auth_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpclattice_auth_policy" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # resource_identifier (Required)
  # 設定内容: ポリシーを作成するサービスネットワークまたはサービスのIDまたはARNを指定します。
  # 設定可能な値:
  #   - サービスネットワークのID（例: sn-1234567890abcdef0）
  #   - サービスネットワークのARN（例: arn:aws:vpc-lattice:ap-northeast-1:123456789012:servicenetwork/sn-1234567890abcdef0）
  #   - サービスのID（例: svc-1234567890abcdef0）
  #   - サービスのARN（例: arn:aws:vpc-lattice:ap-northeast-1:123456789012:service/svc-1234567890abcdef0）
  # 関連機能: VPC Lattice Auth Policies
  #   認証ポリシーはサービスネットワークレベルまたはサービスレベルで適用できます。
  #   サービスネットワークレベルでは粗いアクセス制御、サービスレベルでは細かいアクセス制御が可能です。
  #   - https://docs.aws.amazon.com/vpc-lattice/latest/ug/auth-policies.html
  resource_identifier = aws_vpclattice_service.example.arn

  #-------------------------------------------------------------
  # ポリシー設定
  #-------------------------------------------------------------

  # policy (Required)
  # 設定内容: 認証ポリシーをJSON形式で指定します。
  # 設定可能な値: IAMポリシーと同様の構文を持つJSON文字列
  # 注意: ポリシー文字列に改行や空白行を含めてはいけません。
  # 関連機能: VPC Lattice Auth Policies
  #   認証ポリシーはIAMポリシーと同様の構文を使用し、以下の要素を含みます:
  #   - Principal: アクセスを許可または拒否する対象
  #   - Effect: Allow または Deny
  #   - Action: vpc-lattice-svcs:Invoke 等のアクション
  #   - Resource: サービスARNとパス
  #   - Condition: 条件キー（vpc-lattice-svcs:Port, vpc-lattice-svcs:RequestMethod,
  #     vpc-lattice-svcs:RequestPath, vpc-lattice-svcs:SourceVpc 等）
  #   - https://docs.aws.amazon.com/vpc-lattice/latest/ug/auth-policies.html
  # 参考: jsonencode関数を使用して可読性の高い形式でポリシーを記述することを推奨
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "*"
        Effect    = "Allow"
        Principal = "*"
        Resource  = "*"
        Condition = {
          StringNotEqualsIgnoreCase = {
            "aws:PrincipalType" = "anonymous"
          }
        }
      }
    ]
  })

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
  # 状態設定
  #-------------------------------------------------------------

  # state (Optional)
  # 設定内容: 認証ポリシーの状態を指定します。
  # 設定可能な値:
  #   - "Active": ポリシーがアクティブで、認証と認可の判断に使用される
  #   - "Inactive": ポリシーが非アクティブ
  # 注意: 認証ポリシーは、サービスまたはサービスネットワークの認証タイプが
  #       AWS_IAMに設定されている場合にのみアクティブになります。
  #       認証タイプがNONEの場合、指定したポリシーは非アクティブのままとなります。
  # 関連機能: VPC Lattice認証タイプ
  #   サービスまたはサービスネットワークの作成時にauth_typeをAWS_IAMに設定すると、
  #   認証ポリシーに基づいて認証と認可が行われます。
  #   - https://docs.aws.amazon.com/vpc-lattice/latest/ug/service-access.html
  state = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  # 用途: 長時間かかる操作のタイムアウト時間をカスタマイズする場合に使用
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30m", "1h"）
    create = null

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30m", "1h"）
    update = null

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30m", "1h"）
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: サービスネットワークまたはサービスのIDまたはARN。
#       resource_identifierと同じ値になります。
#
# - policy: 認証ポリシー。JSON形式の文字列。
#
# - state: 認証ポリシーの状態。認証タイプがAWS_IAMに設定されている場合は"Active"、
#          認証タイプがNONEの場合は"Inactive"となります。
#---------------------------------------------------------------
