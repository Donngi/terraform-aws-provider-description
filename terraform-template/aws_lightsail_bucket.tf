#---------------------------------------------------------------
# Amazon Lightsail Bucket
#---------------------------------------------------------------
#
# Amazon Lightsailのオブジェクトストレージバケットをプロビジョニングするリソースです。
# Lightsailバケットは、ファイル、画像、その他のデータをLightsailに保存および管理するための
# オブジェクトストレージを提供します。Amazon S3インフラストラクチャを基盤としており、
# Webスケールのコンピューティングを開発者にとってより簡単にします。
#
# AWS公式ドキュメント:
#   - Lightsailオブジェクトストレージの概要: https://docs.aws.amazon.com/lightsail/latest/userguide/buckets-in-amazon-lightsail.html
#   - Lightsailバケットの作成: https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-creating-buckets.html
#   - バケット命名ルール: https://docs.aws.amazon.com/lightsail/latest/userguide/bucket-naming-rules-in-amazon-lightsail.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_bucket
#
# Provider Version: 6.28.0
# Generated: 2026-01-31
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lightsail_bucket" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: バケットの名前を指定します。
  # 設定可能な値:
  #   - 3〜54文字の小文字英数字とハイフンのみ
  #   - 先頭と末尾は文字または数字である必要があります
  #   - ハイフンを連続して使用することはできません
  #   - aws パーティション内（Amazon S3バケットを含む）で一意である必要があります
  #   - 特定のプレフィックス（amzn-s3-demo-、sthree-、sthree-configurator等）で開始できません
  #   - -s3alias サフィックスで終了できません
  # 注意: バケット名はURLの一部となり、作成後は変更できません
  # 関連機能: バケット命名規則
  #   バケット名は一意性とセキュリティのため、厳格な命名規則に従う必要があります。
  #   - https://docs.aws.amazon.com/lightsail/latest/userguide/bucket-naming-rules-in-amazon-lightsail.html
  name = "example-bucket"

  # bundle_id (Required)
  # 設定内容: バケットに使用するバンドルIDを指定します。
  # 設定可能な値: バケットバンドルは、バケットの月額料金、ストレージスペース、
  #              データ転送クォータを指定します。
  #   利用可能なバンドルIDの例:
  #   - "small_1_0": 3 USD/月、25 GB ストレージ、25 GB 転送
  #   - "medium_1_0": 5 USD/月、100 GB ストレージ、100 GB 転送
  #   - "large_1_0": 10 USD/月、250 GB ストレージ、250 GB 転送
  # 注意: 正確なバンドルIDリストを取得するには、AWS CLI コマンド
  #      `aws lightsail get-bucket-bundles` を使用してください。
  #      バケットのプランは月次のAWS請求サイクル内で1回のみ変更可能です。
  # 関連機能: バケットストレージプラン
  #   ストレージプランはバケットの月額コスト、ストレージスペース、データ転送クォータを
  #   指定します。使用状況に応じて長期的な戦略としてプランを変更できます。
  #   - https://docs.aws.amazon.com/cli/latest/reference/lightsail/get-bucket-bundles.html
  bundle_id = "small_1_0"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用します
  # 関連機能: リージョン選択
  #   レイテンシ最適化、コスト最小化、規制要件への対応のためにリージョンを選択できます。
  #   AWSリージョンに保存されたオブジェクトは、明示的に別のリージョンに転送しない限り、
  #   そのリージョンから移動しません。
  #   - https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # 削除設定
  #-------------------------------------------------------------

  # force_delete (Optional)
  # 設定内容: terraform destroyで空でないバケットを強制削除するかを指定します。
  # 設定可能な値:
  #   - true: バケットが空でない場合でも削除します
  #   - false (デフォルト): バケットが空でない場合は削除しません
  # 省略時: false
  # 注意: AWSはデフォルトで空でないバケットを削除しません。これはバケットデータの損失を
  #      防止し、Lightsailの他のリソースへの影響を回避するためです。
  #      force_deleteをtrueに設定すると、バケットが空でない場合でも削除されます。
  force_delete = false

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値:
  #   - キーと値のペアのマップ
  #   - キーのみのタグを作成する場合は、空文字列を値として使用します
  # 省略時: タグなし
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-bucket"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Lightsailバケットのアマゾンリソースネーム（ARN）
#
# - availability_zone: アベイラビリティーゾーン
#                     形式: us-east-2a（大文字小文字を区別）
#
# - created_at: バケットが作成された日時
#
# - id: バケットに使用される名前（nameと一致）
#
# - support_code: リソースのサポートコード。Lightsailのリソースに関する質問を
#                サポートに送信する際に、このコードをメールに含めてください。
#                このコードにより、サポートチームがLightsail情報をより簡単に
#                検索できます。
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#            リソースに割り当てられたすべてのタグのマップ
#
# - url: バケットのURL
#---------------------------------------------------------------
