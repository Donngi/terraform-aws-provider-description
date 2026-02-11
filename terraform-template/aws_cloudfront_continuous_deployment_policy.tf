#---------------------------------------------------------------
# AWS CloudFront Continuous Deployment Policy
#---------------------------------------------------------------
#
# Amazon CloudFront の継続的デプロイメントポリシーをプロビジョニングするリソースです。
# 継続的デプロイメントポリシーは、プライマリディストリビューションとステージング
# ディストリビューション間でトラフィックをルーティングする方法を制御し、
# 本番環境への変更を安全にテスト・デプロイするためのブルー/グリーンデプロイメントを
# 実現します。
#
# AWS公式ドキュメント:
#   - CloudFront継続的デプロイメント概要: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/continuous-deployment-workflow.html
#   - ステージングディストリビューションの操作: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/working-with-staging-distribution-continuous-deployment-policy.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_continuous_deployment_policy
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cloudfront_continuous_deployment_policy" "example" {
  #-------------------------------------------------------------
  # 有効化設定
  #-------------------------------------------------------------

  # enabled (Required)
  # 設定内容: 継続的デプロイメントポリシーを有効にするかを指定します。
  # 設定可能な値:
  #   - true: ポリシーを有効化。トラフィック設定に基づいてステージングディストリビューションへトラフィックをルーティングします
  #   - false: ポリシーを無効化。すべてのトラフィックがプライマリディストリビューションに送信されます
  # 関連機能: CloudFront 継続的デプロイメント
  #   本番トラフィックの一部をステージングディストリビューションにルーティングし、
  #   設定変更を安全にテストするための機能です。
  #   - https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/continuous-deployment-workflow.html
  enabled = true

  #-------------------------------------------------------------
  # ステージングディストリビューションDNS名設定
  #-------------------------------------------------------------

  # staging_distribution_dns_names (Required)
  # 設定内容: ステージングディストリビューションのCloudFrontドメイン名を指定します。
  # 関連機能: ステージングディストリビューション
  #   プライマリディストリビューションのコピーとして作成され、
  #   設定変更をテストするために使用されます。
  #   - https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/working-with-staging-distribution-continuous-deployment-policy.html
  staging_distribution_dns_names {
    # quantity (Required)
    # 設定内容: ステージングディストリビューションのCloudFrontドメイン名の数を指定します。
    # 設定可能な値: 整数値（通常は1）
    quantity = 1

    # items (Optional)
    # 設定内容: ステージングディストリビューションのCloudFrontドメイン名のリストを指定します。
    # 設定可能な値: CloudFrontドメイン名の配列（例: ["d111111abcdef8.cloudfront.net"]）
    # 注意: ステージングディストリビューションは staging = true で作成する必要があります
    items = ["d111111abcdef8.cloudfront.net"]
  }

  #-------------------------------------------------------------
  # トラフィック設定
  #-------------------------------------------------------------

  # traffic_config (Optional)
  # 設定内容: プライマリディストリビューションからステージングディストリビューションへの
  #          トラフィックルーティング方法を指定します。
  # 関連機能: トラフィックルーティング設定
  #   重み付けベース（SingleWeight）またはヘッダーベース（SingleHeader）の
  #   2種類のルーティング方法をサポートしています。
  #   - https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/understanding-continuous-deployment.html#understanding-continuous-deployment-routing
  traffic_config {
    # type (Required)
    # 設定内容: トラフィック設定のタイプを指定します。
    # 設定可能な値:
    #   - "SingleWeight": トラフィックの一定割合をステージングディストリビューションに送信
    #   - "SingleHeader": 特定のHTTPヘッダーを含むリクエストをステージングディストリビューションに送信
    # 注意: typeに応じてsingle_weight_configまたはsingle_header_configのいずれかを設定
    type = "SingleWeight"

    #-----------------------------------------------------------
    # 重み付けベース設定（SingleWeight使用時）
    #-----------------------------------------------------------

    # single_weight_config (Optional)
    # 設定内容: ステージングディストリビューションに送信するトラフィックの割合を指定します。
    # 注意: type = "SingleWeight" の場合に使用
    # 関連機能: 重み付けベースのトラフィックルーティング
    #   本番トラフィックの一定割合（最大15%）をステージングディストリビューションに
    #   ルーティングし、段階的なロールアウトを実現します。
    single_weight_config {
      # weight (Required)
      # 設定内容: ステージングディストリビューションに送信するトラフィックの割合を指定します。
      # 設定可能な値: 0から0.15の小数値（0%〜15%）
      # 例: 0.01 = 1%, 0.05 = 5%, 0.15 = 15%
      weight = 0.01

      # session_stickiness_config (Optional)
      # 設定内容: セッションスティッキネス（セッション固定）の設定を指定します。
      # 関連機能: セッションスティッキネス
      #   同一ビューアからの複数リクエストを単一セッションとして扱い、
      #   一貫したユーザーエクスペリエンスを提供します。セッション中は
      #   同じディストリビューション（プライマリまたはステージング）に
      #   リクエストがルーティングされます。
      #   - https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/understanding-continuous-deployment.html#understanding-continuous-deployment-sessions
      session_stickiness_config {
        # idle_ttl (Required)
        # 設定内容: リクエストが受信されなかった場合にセッションが終了するまでの時間（秒）を指定します。
        # 設定可能な値: 300〜3600（5分〜60分）
        # 注意: maximum_ttl以下の値を設定する必要があります
        idle_ttl = 300

        # maximum_ttl (Required)
        # 設定内容: ビューアからのリクエストを同一セッションと見なす最大時間（秒）を指定します。
        # 設定可能な値: 300〜3600（5分〜60分）
        # 注意: idle_ttl以上の値を設定する必要があります
        maximum_ttl = 600
      }
    }

    #-----------------------------------------------------------
    # ヘッダーベース設定（SingleHeader使用時）
    #-----------------------------------------------------------

    # single_header_config (Optional)
    # 設定内容: ステージングディストリビューションに送信するリクエストを判定するための
    #          HTTPヘッダーを指定します。
    # 注意: type = "SingleHeader" の場合に使用。single_weight_configとは排他的。
    # 関連機能: ヘッダーベースのトラフィックルーティング
    #   特定のHTTPヘッダーを含むリクエストのみをステージングディストリビューションに
    #   ルーティングします。内部テストや特定ユーザーグループのテストに有用です。
    # single_header_config {
    #   # header (Required)
    #   # 設定内容: ステージングディストリビューションに送信するリクエストを判定するためのヘッダー名を指定します。
    #   # 設定可能な値: "aws-cf-cd-"プレフィックスで始まる文字列
    #   # 例: "aws-cf-cd-staging", "aws-cf-cd-test"
    #   header = "aws-cf-cd-example"
    #
    #   # value (Required)
    #   # 設定内容: ヘッダーの値を指定します。
    #   # 設定可能な値: 任意の文字列
    #   # 注意: このヘッダーと値の組み合わせを持つリクエストがステージングディストリビューションにルーティングされます
    #   value = "example-value"
    # }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: 継続的デプロイメントポリシーのAmazon Resource Name (ARN)
#
# - etag: 継続的デプロイメントポリシーの現在のバージョン
#        ポリシーを更新する際のIf-Matchヘッダーに使用します
#
# - id: 継続的デプロイメントポリシーの識別子
#       プライマリディストリビューションのcontinuous_deployment_policy_idに設定します
#
# - last_modified_time: 継続的デプロイメントポリシーが最後に変更された日時
#---------------------------------------------------------------

#---------------------------------------------------------------
#
# # ステージングディストリビューション（staging = trueを設定）
# resource "aws_cloudfront_distribution" "staging" {
#   enabled = true
#   staging = true
#   # ... その他の設定 ...
# }
#
#---------------------------------------------------------------
