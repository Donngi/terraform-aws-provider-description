#---------------------------------------------------------------
# AWS Mainframe Modernization Application
#---------------------------------------------------------------
#
# AWS Mainframe Modernization (M2) のアプリケーションをプロビジョニングするリソースです。
# メインフレームのワークロードをAWSクラウドに移行・モダナイズするためのアプリケーションを定義します。
# Blu Age（自動リファクタリング）またはMicro Focus（リプラットフォーム）エンジンを選択できます。
#
# AWS公式ドキュメント:
#   - アプリケーションの作成: https://docs.aws.amazon.com/m2/latest/userguide/applications-m2-create.html
#   - アプリケーションのデプロイ: https://docs.aws.amazon.com/m2/latest/userguide/applications-m2-deploy.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/m2_application
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_m2_application" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: アプリケーションの一意な識別子名を指定します。
  # 設定可能な値: 文字列（英数字、ハイフン、アンダースコア）
  name = "example-m2-application"

  # engine_type (Required)
  # 設定内容: アプリケーションで使用するエンジンタイプを指定します。
  # 設定可能な値:
  #   - "bluage": 自動リファクタリング用エンジン（Blu Age）。COBOLをJavaに変換するアプローチ向け
  #   - "microfocus": リプラットフォーム用エンジン（Micro Focus）。既存のコードベースを保持しながらクラウドへ移行するアプローチ向け
  # 参考: https://docs.aws.amazon.com/m2/latest/userguide/applications-m2-create.html
  engine_type = "bluage"

  # description (Optional)
  # 設定内容: アプリケーションの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  description = "Example Mainframe Modernization application"

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
  # 権限設定
  #-------------------------------------------------------------

  # role_arn (Optional)
  # 設定内容: アプリケーションがAWSリソースにアクセスするために使用するIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 省略時: アプリケーションにIAMロールが関連付けられません
  role_arn = "arn:aws:iam::123456789012:role/m2-application-role"

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # kms_key_id (Optional)
  # 設定内容: アプリケーションデータの暗号化に使用するKMSキーのIDまたはARNを指定します。
  # 設定可能な値: 有効なKMSキーID、ARN、エイリアス、またはエイリアスARN
  # 省略時: AWSマネージドキーで暗号化されます
  # 参考: https://docs.aws.amazon.com/m2/latest/userguide/applications-m2-create.html
  kms_key_id = "arn:aws:kms:ap-northeast-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  #-------------------------------------------------------------
  # アプリケーション定義設定
  #-------------------------------------------------------------

  # definition (Optional)
  # 設定内容: アプリケーション定義を指定するブロックです。インラインJSONまたはS3バケットのロケーションを指定できます。
  # 注意: content と s3_location はどちらか一方のみ指定してください
  definition {

    # content (Optional)
    # 設定内容: アプリケーション定義をインラインJSONとして指定します。
    # 設定可能な値: 有効なアプリケーション定義JSON文字列
    # 省略時: s3_location を使用してS3からアプリケーション定義を参照します
    content = <<EOF
{
  "definition": {
    "listeners": [
      {
        "port": 8196,
        "type": "http"
      }
    ],
    "ba-application": {
      "app-location": "${s3-source}/PlanetsDemo-v1.zip"
    }
  },
  "source-locations": [
    {
      "source-id": "s3-source",
      "source-type": "s3",
      "properties": {
        "s3-bucket": "example-bucket",
        "s3-key-prefix": "v1"
      }
    }
  ],
  "template-version": "2.0"
}
EOF

    # s3_location (Optional)
    # 設定内容: S3バケット上のアプリケーション定義ファイルのURIを指定します。
    # 設定可能な値: 有効なS3 URI（例: s3://bucket-name/path/to/definition.json）
    # 省略時: content を使用してインラインでアプリケーション定義を指定します
    # s3_location = "s3://example-bucket/m2-app-definition/definition.json"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 参考: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-m2-application"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {

    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間単位のサフィックス付き文字列（例: "30s", "5m", "2h"）
    #   有効な時間単位: "s"（秒）、"m"（分）、"h"（時間）
    # 省略時: デフォルトのタイムアウトが適用されます
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: 時間単位のサフィックス付き文字列（例: "30s", "5m", "2h"）
    #   有効な時間単位: "s"（秒）、"m"（分）、"h"（時間）
    # 省略時: デフォルトのタイムアウトが適用されます
    update = "30m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: 時間単位のサフィックス付き文字列（例: "30s", "5m", "2h"）
    #   有効な時間単位: "s"（秒）、"m"（分）、"h"（時間）
    # 省略時: デフォルトのタイムアウトが適用されます
    # 注意: Deleteのタイムアウトは、destroyが実行される前に変更がstateに保存された場合にのみ適用されます
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - application_id: アプリケーションのID
# - arn: アプリケーションのAmazon Resource Name (ARN)
# - current_version: 現在デプロイされているアプリケーションのバージョン番号
# - id: アプリケーションのID（application_idと同じ値）
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
