#---------------------------------------------------------------
# AWS Shield Application Layer Automatic Response
#---------------------------------------------------------------
#
# AWS Shield AdvancedのアプリケーションレイヤーDDoS自動緩和機能を
# 管理するリソースです。Amazon CloudFrontディストリビューションまたは
# Application Load Balancer（ALB）に対して、レイヤー7（HTTP/HTTPS）
# DDoS攻撃を自動的に検出・緩和する設定を有効にします。
#
# 前提条件:
#   - AWS Shield Advancedのサブスクリプションが有効であること
#   - 対象リソースにaws_shield_protectionが設定されていること
#   - 対象リソースにAWS WAFウェブACLが関連付けられていること
#
# 対応リソース:
#   - Amazon CloudFrontディストリビューション
#   - Application Load Balancer (ALB)
#
# AWS公式ドキュメント:
#   - Shield AdvancedのL7自動緩和機能: https://docs.aws.amazon.com/waf/latest/developerguide/ddos-automatic-app-layer-response.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/shield_application_layer_automatic_response
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_shield_application_layer_automatic_response" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # resource_arn (Required)
  # 設定内容: 自動緩和を有効にする対象リソースのARNを指定します。
  # 設定可能な値: 以下のリソースタイプの有効なARN
  #   - Amazon CloudFrontディストリビューション:
  #       arn:aws:cloudfront::account-id:distribution/distribution-id
  #   - Application Load Balancer (ALB):
  #       arn:aws:elasticloadbalancing:region:account-id:loadbalancer/app/...
  # 注意: 対象リソースには事前にaws_shield_protectionとAWS WAFウェブACLの
  #       関連付けが必要です。CloudFrontはus-east-1リージョンのARNを使用します。
  resource_arn = "arn:aws:cloudfront::123456789012:distribution/EXAMPLE123456"

  # action (Required)
  # 設定内容: DDoS攻撃検出時に自動緩和機能が実行するアクションを指定します。
  # 設定可能な値:
  #   - "COUNT"  : 攻撃トラフィックをカウントするのみで遮断しない（監視・テスト用）
  #   - "BLOCK"  : 攻撃トラフィックを自動的に遮断する（本番運用推奨）
  # 省略時: 省略不可（必須項目）
  # 注意: COUNTはAWS WAFルールを新しく展開する際やルールの影響を確認する際に
  #       使用します。本番環境での実際の保護にはBLOCKを使用してください。
  action = "COUNT"

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h" などの期間文字列（s=秒, m=分, h=時間）
    # 省略時: プロバイダーのデフォルト値が使用されます。
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h" などの期間文字列（s=秒, m=分, h=時間）
    # 省略時: プロバイダーのデフォルト値が使用されます。
    update = "30m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h" などの期間文字列（s=秒, m=分, h=時間）
    # 省略時: プロバイダーのデフォルト値が使用されます。
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 保護対象リソースのARN（resource_arnと同値）
#---------------------------------------------------------------
