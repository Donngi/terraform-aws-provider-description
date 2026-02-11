################################################################################
# AWS S3 Bucket Request Payment Configuration
################################################################################
# 用途: S3バケットのRequester Pays設定を管理するリソース
#
# Requester Pays機能により、バケット所有者ではなくリクエスト者がリクエストと
# データダウンロードのコストを負担するように設定できます。
# 大規模なデータセットを共有する際に、所有者が課金されることなく他のユーザーが
# アクセスできるようにする場合に有用です。
#
# 重要な注意事項:
# - このリソースを削除すると、バケットのpayerはS3のデフォルト値（バケット所有者）に
#   リセットされます
# - S3 Directory Bucketsでは使用できません
# - Requester Paysバケットは匿名アクセスをサポートせず、全てのリクエストに
#   認証が必要です
# - リクエスト者は、課金を受け入れることを示すために、APIリクエストに
#   'x-amz-request-payer: requester'ヘッダーを含める必要があります
#
# 関連リソース:
# - aws_s3_bucket: 基となるS3バケット
# - aws_s3_bucket_policy: Requester Paysアクセスを制御するポリシー
#
# 参考:
# - https://docs.aws.amazon.com/AmazonS3/latest/userguide/RequesterPaysBuckets.html
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_request_payment_configuration
################################################################################

resource "aws_s3_bucket_request_payment_configuration" "example" {
  ################################################################################
  # 必須パラメータ
  ################################################################################

  # bucket - S3バケット名 (必須)
  #
  # Requester Pays設定を適用するバケットの名前またはARNを指定します。
  #
  # 注意事項:
  # - この値を変更すると新しいリソースが作成されます (Forces new resource)
  # - バケット名は既存のS3バケットと一致する必要があります
  # - aws_s3_bucket.example.idまたはaws_s3_bucket.example.bucketで参照可能
  #
  # 例:
  # - バケット名: "my-bucket"
  # - バケットID参照: aws_s3_bucket.example.id
  #
  # 型: string
  bucket = "example-bucket-name"

  # payer - リクエストとダウンロードの料金負担者 (必須)
  #
  # リクエストとデータダウンロードの料金を誰が支払うかを指定します。
  #
  # 有効な値:
  # - "BucketOwner": バケット所有者が料金を支払う（デフォルトの動作）
  # - "Requester": リクエスト者が料金を支払う（Requester Pays機能を有効化）
  #
  # Requester Paysを有効にする場合の考慮事項:
  # - リクエスト者は認証された認証情報を持つ必要があります
  # - リクエスト者はリクエストに'x-amz-request-payer: requester'を含める必要があります
  # - IAMロールを使用する場合、関連するアカウントに課金されます
  # - 匿名アクセスは許可されません
  # - AccessDeniedエラーを返すリクエストはバケット所有者に課金されます
  #
  # 使用例:
  # - 大規模な公開データセットの提供
  # - データ共有コストを利用者に転嫁する場合
  # - 外部ユーザーとのデータ共有
  #
  # 型: string
  # デフォルト: なし（明示的な指定が必須）
  payer = "Requester"

  ################################################################################
  # オプションパラメータ
  ################################################################################

  # expected_bucket_owner - 予期されるバケット所有者のアカウントID (オプション)
  #
  # セキュリティのために、バケットの所有者として予期されるAWSアカウントIDを
  # 指定します。このパラメータを設定すると、指定されたアカウントがバケットを
  # 所有していない場合、リクエストは失敗します。
  #
  # 用途:
  # - 誤ったバケットへの設定適用を防止
  # - セキュリティ要件が厳しい環境での検証
  # - 複数のAWSアカウントを管理する場合の安全性向上
  #
  # 注意事項:
  # - この値を変更すると新しいリソースが作成されます (Forces new resource)
  # - 12桁のAWSアカウントIDを指定
  # - 指定したアカウントIDとバケット所有者が一致しない場合、エラーが発生します
  #
  # 例: "123456789012"
  #
  # 型: string
  # デフォルト: なし
  # expected_bucket_owner = "123456789012"

  # region - リソースを管理するリージョン (オプション)
  #
  # このリソースが管理されるAWSリージョンを明示的に指定します。
  #
  # 動作:
  # - 指定しない場合、プロバイダー設定のリージョンが使用されます
  # - バケット自体のリージョンとは独立した設定です
  # - クロスリージョン管理が必要な場合に使用します
  #
  # 使用例:
  # - マルチリージョン環境での明示的なリージョン指定
  # - デフォルトプロバイダーと異なるリージョンでの管理
  # - 特定のリージョナルエンドポイントの使用
  #
  # 例: "us-west-2", "ap-northeast-1", "eu-central-1"
  #
  # 型: string
  # デフォルト: プロバイダー設定のリージョン
  # computed: true（指定しない場合は自動的に設定される）
  # region = "us-east-1"

  ################################################################################
  # 読み取り専用属性（Computed Attributes）
  ################################################################################

  # id - リソースの識別子 (読み取り専用)
  #
  # このリソースの一意の識別子です。以下の形式で自動的に生成されます:
  # - expected_bucket_ownerが指定されている場合: "bucket,expected_bucket_owner"
  # - expected_bucket_ownerが指定されていない場合: "bucket"
  #
  # 例:
  # - "my-bucket"
  # - "my-bucket,123456789012"
  #
  # 用途:
  # - 他のリソースからの参照
  # - Terraformの状態管理
  #
  # 型: string
  # computed: true
  # 参照方法: aws_s3_bucket_request_payment_configuration.example.id
}

################################################################################
# 補足情報
################################################################################

# Requester Pays機能の詳細:
#
# 1. 料金体系:
#    - GET、HEAD、POSTリクエスト: リクエスト者が課金される
#    - データ転送: リクエスト者が課金される
#    - ストレージコスト: バケット所有者が課金される
#
# 2. リクエスト要件:
#    - 全てのリクエストに認証が必要
#    - リクエストヘッダーに'x-amz-request-payer: requester'を含める必要がある
#    - SDKを使用する場合、RequestPayerパラメータを設定
#
# 3. 制限事項:
#    - SOAPリクエストには対応していません
#    - 匿名リクエストには対応していません
#    - ログ記録の対象バケットとして使用できません
#    - BitTorrentには対応していません
#    - Directory Bucketsには対応していません
#
# 4. IAMポリシーの考慮事項:
#    - リクエスト者には s3:GetObject などの適切な権限が必要
#    - バケットポリシーでRequester Paysアクセスを制御可能
#
# 5. 設定の反映:
#    - 設定変更は数分で反映されます
#    - 即座には反映されない可能性があります
#
# 6. 署名付きURLの考慮事項:
#    - 署名付きURLを発行する場合、バケット所有者の認証情報が使用されます
#    - リクエスト者がURLを使用するたびに、所有者に課金されます
#    - Requester Paysバケットで署名付きURLを使用する際は注意が必要

# AWS CLIでの使用例:
#
# Requester Paysバケットからオブジェクトを取得:
# aws s3api get-object \
#   --bucket my-bucket \
#   --key my-object \
#   --request-payer requester \
#   output-file.txt

# 設定の確認:
# aws s3api get-bucket-request-payment --bucket my-bucket

# 設定例の詳細パターン:
#
# 例1: 基本的なRequester Pays設定
# resource "aws_s3_bucket" "data_sharing" {
#   bucket = "shared-dataset-bucket"
# }
#
# resource "aws_s3_bucket_request_payment_configuration" "data_sharing" {
#   bucket = aws_s3_bucket.data_sharing.id
#   payer  = "Requester"
# }
#
# 例2: セキュリティ強化版（expected_bucket_owner使用）
# resource "aws_s3_bucket_request_payment_configuration" "secure" {
#   bucket                = aws_s3_bucket.example.id
#   expected_bucket_owner = data.aws_caller_identity.current.account_id
#   payer                 = "Requester"
# }
#
# data "aws_caller_identity" "current" {}
#
# 例3: クロスリージョン管理
# resource "aws_s3_bucket_request_payment_configuration" "cross_region" {
#   bucket = aws_s3_bucket.example.id
#   payer  = "Requester"
#   region = "us-west-2"
# }
#
# 例4: デフォルト設定に戻す
# resource "aws_s3_bucket_request_payment_configuration" "default" {
#   bucket = aws_s3_bucket.example.id
#   payer  = "BucketOwner"
# }

# インポート:
#
# 既存のS3バケットのRequester Pays設定をインポートできます:
#
# terraform import aws_s3_bucket_request_payment_configuration.example my-bucket
#
# expected_bucket_ownerを指定している場合:
# terraform import aws_s3_bucket_request_payment_configuration.example my-bucket,123456789012

# トラブルシューティング:
#
# 1. "Access Denied" エラー:
#    - バケット所有者に適切な権限があることを確認
#    - s3:PutBucketRequestPayment 権限が必要
#
# 2. リクエスト者がアクセスできない:
#    - リクエスト時に 'x-amz-request-payer: requester' を含めているか確認
#    - リクエスト者が認証されているか確認
#    - バケットポリシーで適切な権限が付与されているか確認
#
# 3. 予期しない課金:
#    - payer設定が意図した値（"Requester"または"BucketOwner"）になっているか確認
#    - 署名付きURLの使用状況を確認
#    - AccessDeniedエラーは常にバケット所有者に課金される点に注意
