#---------------------------------------------------------------
# AWS Mainframe Modernization Application
#---------------------------------------------------------------
#
# AWS Mainframe Modernization (AWS M2) アプリケーションリソースを作成します。
# AWS M2はメインフレームのワークロードをAWSに移行・近代化するためのサービスです。
# このリソースはBlu Age（Java変換）またはMicro Focus（エミュレーション）
# エンジンを使用してメインフレームアプリケーションをデプロイします。
#
# AWS公式ドキュメント:
#   - Applications in AWS Mainframe Modernization: https://docs.aws.amazon.com/m2/latest/userguide/applications-m2.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/m2_application
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_m2_application" "this" {
  #---------------------------------------------------------------
  # 必須引数 (Required Arguments)
  #---------------------------------------------------------------

  # name (必須, string)
  # アプリケーションの一意な識別子（名前）
  # AWS M2コンソールやAPIでアプリケーションを識別するために使用されます。
  name = "example-m2-application"

  # engine_type (必須, string)
  # アプリケーションを実行するエンジンタイプ
  # 許可される値:
  #   - "bluage"    : Blu Ageエンジン（COBOLからJavaへの自動変換）
  #   - "microfocus": Micro Focusエンジン（メインフレームエミュレーション）
  # Blu Ageはリファクタリングアプローチ、Micro Focusはリプラットフォームアプローチに適しています。
  engine_type = "bluage"

  #---------------------------------------------------------------
  # オプション引数 (Optional Arguments)
  #---------------------------------------------------------------

  # description (オプション, string)
  # アプリケーションの説明
  # アプリケーションの目的や内容を説明するテキストを設定します。
  description = null

  # kms_key_id (オプション, string)
  # アプリケーションデータの暗号化に使用するKMSキーのID
  # 指定しない場合はAWSマネージドキーが使用されます。
  # 例: "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  kms_key_id = null

  # region (オプション, string)
  # このリソースが管理されるAWSリージョン
  # 指定しない場合はプロバイダー設定のリージョンが使用されます。
  # 例: "us-east-1", "ap-northeast-1"
  region = null

  # role_arn (オプション, string)
  # アプリケーションがAWSリソースにアクセスするために使用するIAMロールのARN
  # このロールにはアプリケーションが必要とするAWSサービス（S3、CloudWatch等）への
  # アクセス権限が必要です。
  # 例: "arn:aws:iam::123456789012:role/M2ApplicationRole"
  role_arn = null

  # tags (オプション, map(string))
  # リソースに割り当てるタグのマップ
  # プロバイダーレベルの default_tags 設定がある場合、
  # 同じキーのタグはこちらの設定で上書きされます。
  tags = {
    Environment = "development"
    Project     = "mainframe-modernization"
  }

  #---------------------------------------------------------------
  # definition ブロック (オプション)
  #---------------------------------------------------------------
  # アプリケーション定義を指定します。
  # インラインJSONまたはS3バケットの場所を指定できます。
  # content と s3_location のいずれか一方を指定します（両方同時指定は不可）。

  definition {
    # content (オプション, string)
    # アプリケーション定義のインラインJSON
    # リスナー設定、アプリケーションの場所、ソースロケーションなどを定義します。
    # Blu Ageの場合はba-application、Micro Focusの場合はmf-applicationを使用します。
    # content または s3_location のいずれかを指定します。
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
      "app-location": "$${s3-source}/PlanetsDemo-v1.zip"
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

    # s3_location (オプション, string)
    # アプリケーション定義ファイルのS3ロケーション
    # JSONファイルをS3に配置している場合に使用します。
    # 形式: "s3://bucket-name/path/to/definition.json"
    # content または s3_location のいずれかを指定します。
    # s3_location = "s3://my-bucket/definitions/app-definition.json"
  }

  #---------------------------------------------------------------
  # timeouts ブロック (オプション)
  #---------------------------------------------------------------
  # リソース操作のタイムアウト時間を設定します。
  # 値は "30s"（秒）、"5m"（分）、"1h"（時間）の形式で指定します。

  timeouts {
    # create (オプション, string)
    # リソース作成のタイムアウト時間
    # アプリケーションの作成に時間がかかる場合に延長できます。
    create = null

    # update (オプション, string)
    # リソース更新のタイムアウト時間
    # アプリケーションの更新に時間がかかる場合に延長できます。
    update = null

    # delete (オプション, string)
    # リソース削除のタイムアウト時間
    # アプリケーションの削除に時間がかかる場合に延長できます。
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference（参照用属性）
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です（入力不可）:
#
# application_id - アプリケーションのID
# arn            - アプリケーションのARN
# current_version - デプロイされているアプリケーションの現在のバージョン
# id             - リソースのID
# tags_all       - プロバイダーのdefault_tagsから継承されたタグを含む、
#                  リソースに割り当てられた全タグのマップ
#---------------------------------------------------------------
