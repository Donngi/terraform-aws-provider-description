#-----------------------------------------------------------------------
# AWS Elasticsearch Domain Policy
#-----------------------------------------------------------------------
# Amazon Elasticsearchドメインに対するアクセスポリシーを管理するリソース
# ドメイン属性（ARNなど）を参照しながらポリシーを設定できる
# 注意: Elasticsearch Serviceは後継のOpenSearch Serviceに移行が推奨されている
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
#
# NOTE: Elasticsearch Serviceは非推奨となり、OpenSearch Serviceへの移行が推奨される
#
# 関連ドキュメント:
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/elasticsearch_domain_policy
# https://docs.aws.amazon.com/elasticsearch-service/latest/developerguide/es-gsg.html
#-----------------------------------------------------------------------

#-----------------------------------------------
# リソース定義
#-----------------------------------------------
resource "aws_elasticsearch_domain_policy" "example" {
  #-----------------------------------------------
  # 基本設定
  #-----------------------------------------------
  # 設定内容: ポリシーを適用するElasticsearchドメインの名前
  # 注意事項: 既存のaws_elasticsearch_domainリソースのdomain_nameを参照することが推奨される
  domain_name = "example-domain"

  # 設定内容: Elasticsearchドメインに適用するIAMポリシードキュメント（JSON形式）
  # 注意事項: IAMポリシーのバージョンは通常2012-10-17を使用する
  # 設定例: 特定IPアドレスからのアクセスを許可する、特定AWSアカウントからのアクセスを許可する、など
  access_policies = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action   = "es:*"
        Resource = "arn:aws:es:ap-northeast-1:123456789012:domain/example-domain/*"
        Condition = {
          IpAddress = {
            "aws:SourceIp" = ["203.0.113.0/24"]
          }
        }
      }
    ]
  })

  #-----------------------------------------------
  # リージョン設定（オプション）
  #-----------------------------------------------
  # 設定内容: このリソースを管理するAWSリージョン
  # 省略時: プロバイダー設定のリージョンが使用される
  # 注意事項: 通常は指定不要（プロバイダー設定のリージョンを使用）
  region = "ap-northeast-1"

  #-----------------------------------------------
  # タイムアウト設定（オプション）
  #-----------------------------------------------
  timeouts {
    # 設定内容: ポリシー更新時のタイムアウト時間
    # 省略時: 180m（3時間）
    # update = "180m"

    # 設定内容: ポリシー削除時のタイムアウト時間
    # 省略時: 90m（90分）
    # delete = "90m"
  }
}

#-----------------------------------------------------------------------
# Attributes Reference（参照可能な属性）
#-----------------------------------------------------------------------
# このリソースでは以下の属性が参照可能:
#
# - id: ドメイン名
#-----------------------------------------------------------------------
