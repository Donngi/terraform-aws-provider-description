#---------------------------------------------------------------
# AWS Redshift Data Share Consumer Association
#---------------------------------------------------------------
#
# Amazon Redshiftのデータ共有（Datashare）をコンシューマー側でアカウントまたは
# 特定の名前空間に関連付けるリソースです。
# プロデューサーが共有したデータシェアをコンシューマーが利用できるようにします。
# アカウント全体、特定のリージョン、または特定の名前空間（ARN指定）に関連付けられます。
#
# AWS公式ドキュメント:
#   - AssociateDataShareConsumer APIリファレンス: https://docs.aws.amazon.com/redshift/latest/APIReference/API_AssociateDataShareConsumer.html
#   - 別アカウントからのデータシェア関連付け: https://docs.aws.amazon.com/redshift/latest/dg/writes-associating.html
#   - データ共有に関する考慮事項: https://docs.aws.amazon.com/redshift/latest/dg/datashare-considerations.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_data_share_consumer_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_redshift_data_share_consumer_association" "example" {
  #-------------------------------------------------------------
  # データシェア識別設定
  #-------------------------------------------------------------

  # data_share_arn (Required)
  # 設定内容: コンシューマーがアカウントまたは名前空間で使用するデータシェアのARNを指定します。
  # 設定可能な値: 有効なRedshift DatashareのARN文字列
  #   例: "arn:aws:redshift:us-east-1:123456789012:datashare:b3bfde75-73fd-408b-9086-d6fccfd6d588/example"
  # 参考: https://docs.aws.amazon.com/redshift/latest/APIReference/API_AssociateDataShareConsumer.html
  data_share_arn = "arn:aws:redshift:us-east-1:123456789012:datashare:b3bfde75-73fd-408b-9086-d6fccfd6d588/example"

  #-------------------------------------------------------------
  # 関連付け対象設定
  #-------------------------------------------------------------

  # associate_entire_account (Optional)
  # 設定内容: データシェアをアカウント全体に関連付けるかどうかを指定します。
  # 設定可能な値:
  #   - true: アカウント全体（現在および将来のすべての名前空間）に関連付けます
  #   - false (省略時): アカウント全体への関連付けは行いません
  # 注意: consumer_arn および consumer_region と排他的です（同時指定不可）
  # 参考: https://docs.aws.amazon.com/redshift/latest/dg/writes-associating.html
  associate_entire_account = null

  # consumer_arn (Optional)
  # 設定内容: データシェアに関連付けるコンシューマーの名前空間ARNを指定します。
  # 設定可能な値: 有効なRedshift名前空間のARN文字列
  #   例: "arn:aws:redshift:us-east-1:123456789012:namespace:00000000-0000-0000-0000-000000000000"
  # 注意: associate_entire_account および consumer_region と排他的です（同時指定不可）
  consumer_arn = null

  # consumer_region (Optional)
  # 設定内容: コンシューマーアカウントで、指定したAWSリージョン内の既存および将来の
  #           すべての名前空間にデータシェアを関連付けます。
  # 設定可能な値: 有効なAWSリージョンコード（例: "us-east-1", "ap-northeast-1"）
  # 注意: associate_entire_account および consumer_arn と排他的です（同時指定不可）
  # 参考: https://docs.aws.amazon.com/redshift/latest/dg/across-region.html
  consumer_region = null

  #-------------------------------------------------------------
  # 書き込み権限設定
  #-------------------------------------------------------------

  # allow_writes (Optional)
  # 設定内容: データシェアに対して書き込み操作を許可するかどうかを指定します。
  # 設定可能な値:
  #   - true: 書き込み操作を許可します（プロデューサー側で書き込み権限を付与済みの場合）
  #   - false (省略時): 書き込み操作を許可しません（読み取り専用）
  # 注意: コンシューマーが書き込みを許可するには、プロデューサー側でも書き込み権限の
  #       付与（authorize-data-share）が必要です
  # 参考: https://docs.aws.amazon.com/redshift/latest/dg/datashare-considerations.html
  allow_writes = false

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: "ap-northeast-1", "us-east-1"）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: data_share_arn と associate_entire_account、consumer_arn、consumer_region を
#        カンマ区切りで連結した文字列（指定されなかった後者3引数は空文字となります）
#
# - managed_by: データシェアを管理するエンティティの識別子
#
# - producer_arn: データシェアのプロデューサーのARN
#---------------------------------------------------------------
