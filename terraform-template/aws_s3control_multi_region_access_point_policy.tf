#---------------------------------------------------------------
# AWS S3 Control Multi-Region Access Point Policy
#---------------------------------------------------------------
#
# S3マルチリージョンアクセスポイントのアクセス制御ポリシーを管理するリソースです。
# マルチリージョンアクセスポイントに対するアクセス権限をIAMポリシーとして定義し、
# 複数のリージョンにまたがるS3バケットへの統一されたアクセス制御を実現します。
#
# AWS公式ドキュメント:
#   - マルチリージョンアクセスポイント権限: https://docs.aws.amazon.com/AmazonS3/latest/userguide/MultiRegionAccessPointPermissions.html
#   - マルチリージョンアクセスポイント概要: https://docs.aws.amazon.com/AmazonS3/latest/userguide/MultiRegionAccessPoints.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3control_multi_region_access_point_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3control_multi_region_access_point_policy" "example" {
  #-------------------------------------------------------------
  # アカウント設定
  #-------------------------------------------------------------

  # account_id (Optional, Computed)
  # 設定内容: マルチリージョンアクセスポイントの所有者のAWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  # 省略時: Terraform AWSプロバイダーのアカウントIDが自動的に決定されます
  # 用途: 通常は省略可能ですが、クロスアカウント管理を行う場合に明示的に指定します
  account_id = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースが管理されるリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # ポリシー詳細設定 (Required)
  #-------------------------------------------------------------

  # details (Required)
  # 設定内容: マルチリージョンアクセスポイントのポリシー詳細を含む設定ブロック。
  # 用途: アクセスポイント名とポリシードキュメントを定義します
  # 最小/最大項目数: 1 (必須かつ単一のブロック)
  details {
    # name (Required)
    # 設定内容: マルチリージョンアクセスポイントの名前を指定します。
    # 設定可能な値: アクセスポイント名 (通常は aws_s3control_multi_region_access_point リソースから取得)
    # 注意: aws_s3control_multi_region_access_point リソースのIDは "account_id:name" 形式のため、
    #       通常は element(split(":", aws_s3control_multi_region_access_point.example.id), 1) で取得します
    name = "example-mrap-name"

    # policy (Required)
    # 設定内容: マルチリージョンアクセスポイントに関連付ける有効なJSONポリシードキュメントを指定します。
    # 設定可能な値: IAMポリシードキュメント (JSON形式)
    # 重要な注意事項:
    #   - 一度適用されたポリシーは編集可能ですが、削除はできません
    #   - ポリシーを更新すると、最初に「提案されたポリシー(proposed)」として表示されます
    #   - すべてのリージョンで更新が完了すると、「確定ポリシー(established)」として表示されます
    #   - 両方のポリシーのバージョン番号が同じ場合、提案ポリシーが確定ポリシーです
    # 関連機能: マルチリージョンアクセスポイント権限
    #   ポリシーでアクセス制御を定義します。Principal、Action、Resource、Effect を含みます。
    #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/MultiRegionAccessPointPermissions.html
    #
    # ポリシードキュメントの構成要素:
    #   - Version: ポリシー言語のバージョン (通常は "2012-10-17")
    #   - Statement: ポリシーステートメントの配列
    #     - Sid: ステートメントID (オプション)
    #     - Effect: "Allow" または "Deny"
    #     - Principal: アクセスを許可/拒否するプリンシパル (AWS アカウント、IAMユーザー、ロールなど)
    #     - Action: 許可/拒否するS3アクション (例: s3:GetObject, s3:PutObject)
    #     - Resource: アクセス対象のリソースARN
    #
    # リソースARN形式:
    #   arn:{partition}:s3::{account_id}:accesspoint/{mrap_alias}/object/*
    #   - {partition}: aws, aws-cn, aws-us-gov など
    #   - {account_id}: AWSアカウントID
    #   - {mrap_alias}: マルチリージョンアクセスポイントのエイリアス
    #
  # タイムアウト設定 (Optional)
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: 特定の操作のタイムアウト時間を設定します。
  # 用途: デフォルトのタイムアウト時間を変更する必要がある場合に使用します
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列 (例: "15m", "1h")
    # 省略時: デフォルトのタイムアウト時間 (15分) が適用されます
    create = null

    # update (Optional)
    # 設定内容: リソース更新操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列 (例: "15m", "1h")
    # 省略時: デフォルトのタイムアウト時間 (15分) が適用されます
    update = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: マルチリージョンアクセスポイントポリシーの識別子
#       形式: {account_id}:{access_point_name}
#       例: "123456789012:example-mrap-name"
#
# - established: マルチリージョンアクセスポイントの最後に確定されたポリシー
#       説明: すべてのリージョンでポリシー更新が完了した状態のポリシードキュメント (JSON文字列)
#
# - proposed: マルチリージョンアクセスポイントの提案されたポリシー
#       説明: ポリシー更新中にまだ確定していないポリシードキュメント (JSON文字列)
#---------------------------------------------------------------

#---------------------------------------------------------------
# 完全な使用例
#---------------------------------------------------------------
# 以下は、マルチリージョンアクセスポイントとそのポリシーを作成する完全な例です:
#
# # 現在のAWSアカウント情報を取得
# data "aws_caller_identity" "current" {}
#
# # 現在のパーティション情報を取得 (aws, aws-cn, aws-us-gov)
#---------------------------------------------------------------
