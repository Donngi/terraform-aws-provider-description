#---------------------------------------------------------------
# AWS CloudFront Field Level Encryption Config
#---------------------------------------------------------------
#
# Amazon CloudFrontのフィールドレベル暗号化設定をプロビジョニングするリソースです。
# フィールドレベル暗号化は、HTTPSによるエンドツーエンド暗号化に加えて、
# POSTリクエスト内の特定のフィールド（クレジットカード番号など）を
# エッジで追加暗号化し、オリジンアプリケーション全体を通じて保護する機能です。
#
# AWS公式ドキュメント:
#   - フィールドレベル暗号化概要: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/field-level-encryption.html
#   - CloudFrontでの機密データ暗号化: https://docs.aws.amazon.com/whitepapers/latest/secure-content-delivery-amazon-cloudfront/using-cloudfront-to-encrypt-sensitive-data-at-the-edge.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_field_level_encryption_config
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cloudfront_field_level_encryption_config" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # comment (Optional)
  # 設定内容: フィールドレベル暗号化設定に関するコメントを指定します。
  # 設定可能な値: 任意の文字列
  # 用途: 設定の目的や用途を記録するために使用
  comment = "Field level encryption config for sensitive form data"

  #-------------------------------------------------------------
  # コンテンツタイププロファイル設定 (Required)
  #-------------------------------------------------------------
  # コンテンツタイプに基づいて、どのプロファイルを使用して暗号化するかを指定します。
  # リクエストのコンテンツタイプが認識されない場合の動作も設定できます。

  content_type_profile_config {
    # forward_when_content_type_is_unknown (Required)
    # 設定内容: 不明なコンテンツタイプが提供された場合の動作を指定します。
    # 設定可能な値:
    #   - true: コンテンツタイプが不明な場合、データを暗号化せずにオリジンに転送
    #   - false: コンテンツタイプが不明な場合、エラーを返す
    # 関連機能: CloudFront フィールドレベル暗号化
    #   コンテンツタイプがconfigurationに設定されていない場合の振る舞いを制御します。
    #   セキュリティを重視する場合はfalseを推奨。
    #   - https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/field-level-encryption.html
    forward_when_content_type_is_unknown = false

    # content_type_profiles (Required)
    # 設定内容: フィールドレベル暗号化のコンテンツタイププロファイルマッピングのリストを指定します。
    content_type_profiles {
      # items (Required, 1つ以上必要)
      # 設定内容: 個々のコンテンツタイププロファイルマッピングを指定します。
      items {
        # content_type (Required)
        # 設定内容: フィールドレベル暗号化のコンテンツタイプを指定します。
        # 設定可能な値: "application/x-www-form-urlencoded"
        # 注意: 現在サポートされているコンテンツタイプはこの値のみです。
        content_type = "application/x-www-form-urlencoded"

        # format (Required)
        # 設定内容: フィールドレベル暗号化のフォーマットを指定します。
        # 設定可能な値: "URLEncoded"
        # 注意: 現在サポートされているフォーマットはこの値のみです。
        format = "URLEncoded"

        # profile_id (Optional)
        # 設定内容: このコンテンツタイプマッピングに使用するプロファイルIDを指定します。
        # 設定可能な値: aws_cloudfront_field_level_encryption_profileリソースのID
        # 省略時: プロファイルが指定されていない場合、CloudFrontはそのコンテンツタイプの
        #         リクエストを暗号化せずにオリジンに転送します。
        # 関連機能: CloudFront フィールドレベル暗号化プロファイル
        #   暗号化するフィールドと使用する公開鍵を定義するプロファイルを参照します。
        profile_id = aws_cloudfront_field_level_encryption_profile.example.id
      }
    }
  }

  #-------------------------------------------------------------
  # クエリ引数プロファイル設定 (Required)
  #-------------------------------------------------------------
  # URLのクエリ引数（fle-profile）で指定されたプロファイルを使用した
  # 暗号化の動作を設定します。

  query_arg_profile_config {
    # forward_when_query_arg_profile_is_unknown (Required)
    # 設定内容: クエリ引数で指定されたプロファイルが存在しない場合の動作を指定します。
    # 設定可能な値:
    #   - true: 指定されたプロファイルが不明な場合、データを暗号化せずにオリジンに転送
    #   - false: 指定されたプロファイルが不明な場合、エラーを返す
    # 関連機能: CloudFront フィールドレベル暗号化クエリ引数
    #   URLのfle-profileクエリ引数でプロファイルを動的に指定できます。
    #   例: https://d1234.cloudfront.net?fle-profile=SampleProfile
    #   - https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/field-level-encryption.html
    forward_when_query_arg_profile_is_unknown = false

    # query_arg_profiles (Optional)
    # 設定内容: クエリ引数とプロファイルのマッピングリストを指定します。
    # 省略時: クエリ引数によるプロファイルのオーバーライドは無効になります。
    # 注意: 最大5つのクエリ引数マッピングを作成できます。
    query_arg_profiles {
      # items (Optional)
      # 設定内容: 個々のクエリ引数プロファイルマッピングを指定します。
      items {
        # profile_id (Required)
        # 設定内容: このクエリ引数マッピングに使用するプロファイルIDを指定します。
        # 設定可能な値: aws_cloudfront_field_level_encryption_profileリソースのID
        profile_id = aws_cloudfront_field_level_encryption_profile.example.id

        # query_arg (Required)
        # 設定内容: fle-profileクエリ引数に指定する値を定義します。
        # 設定可能な値: 最大128文字。英数字および - . _ * + % が使用可能。スペースは不可。
        # 用途: URLでhttps://d1234.cloudfront.net?fle-profile=Arg1のように使用し、
        #       リクエストごとに使用するプロファイルを動的に指定できます。
        query_arg = "Arg1"
      }
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: フィールドレベル暗号化設定のAmazon Resource Name (ARN)
#
# - caller_reference: CloudFrontが将来の更新を許可するために使用する内部値
#
# - etag: フィールドレベル暗号化設定の現在のバージョン
#         例: E2QWRUHAPOMQZL
#
# - id: フィールドレベル暗号化設定の識別子
#       例: K3D5EWEUDCCXON
#---------------------------------------------------------------
