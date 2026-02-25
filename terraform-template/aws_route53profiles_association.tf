#---------------------------------------
# aws_route53profiles_association
#
# Route53 プロファイルとVPCを関連付けるリソース。
# プロファイルに設定されたDNS設定（ゾーン、ルールなど）をVPCに適用できる。
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53profiles_association
#
# NOTE: このファイルはテンプレートです。実際の値に置き換えて使用してください。
#       必須属性は必ず設定し、不要な任意属性はコメントアウトまたは削除してください。
#---------------------------------------

resource "aws_route53profiles_association" "example" {

  #---------------------------------------
  # 基本設定
  #---------------------------------------

  # 設定内容: 関連付けの名前
  # 設定可能な値: 任意の文字列
  name = "example-association"

  # 設定内容: 関連付けるRoute53プロファイルのID
  # 設定可能な値: Route53プロファイルのID（aws_route53profiles_profile.example.idなど）
  profile_id = "rp-xxxxxxxxxxxxxxxxx"

  # 設定内容: プロファイルを関連付けるリソース（VPC）のID
  # 設定可能な値: VPCのID（aws_vpc.example.idなど）
  resource_id = "vpc-xxxxxxxxxxxxxxxxx"

  #---------------------------------------
  # タグ設定
  #---------------------------------------

  # 設定内容: リソースに付与するタグのマップ
  # 省略時: タグなし
  tags = {
    Name = "example-route53profiles-association"
  }

  #---------------------------------------
  # リージョン設定
  #---------------------------------------

  # 設定内容: リソースを管理するリージョン
  # 設定可能な値: "ap-northeast-1", "us-east-1" などのAWSリージョンコード
  # 省略時: プロバイダー設定のリージョンを使用
  region = null

  #---------------------------------------
  # タイムアウト設定
  #---------------------------------------

  timeouts {
    # 設定内容: 作成タイムアウト
    # 設定可能な値: "30s", "5m", "2h" のような期間文字列
    # 省略時: デフォルトタイムアウト
    create = "30m"

    # 設定内容: 更新タイムアウト
    # 設定可能な値: "30s", "5m", "2h" のような期間文字列
    # 省略時: デフォルトタイムアウト
    update = "30m"

    # 設定内容: 削除タイムアウト
    # 設定可能な値: "30s", "5m", "2h" のような期間文字列
    # 省略時: デフォルトタイムアウト
    delete = "30m"
  }
}

#---------------------------------------
# Attributes Reference
#
# id           - 関連付けのID
# arn          - 関連付けのARN
# owner_id     - 関連付けを所有するAWSアカウントID
# status       - 関連付けの状態（COMPLETE / PENDING / FAILED など）
# status_message - 状態の詳細メッセージ
# tags_all     - プロバイダーのデフォルトタグを含む全タグのマップ
#---------------------------------------
