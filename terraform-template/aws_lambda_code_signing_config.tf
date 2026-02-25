#---------------------------------------------------------------
# AWS Lambda Code Signing Config
#---------------------------------------------------------------
#
# AWS Lambda のコード署名設定をプロビジョニングするリソースです。
# Lambda 関数のコードの整合性と信頼性を確保するため、許可された署名プロファイルと
# デプロイメント検証失敗時のポリシーを定義します。
#
# AWS公式ドキュメント:
#   - Lambda コード署名の設定: https://docs.aws.amazon.com/lambda/latest/dg/configuration-codesigning.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_code_signing_config
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lambda_code_signing_config" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: コード署名設定の説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  description = "Lambda 関数のコード署名設定"

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
  # 許可された署名プロファイル設定
  #-------------------------------------------------------------

  # allowed_publishers (Required)
  # 設定内容: このコード署名設定で許可された署名プロファイルを定義するブロックです。
  # 関連機能: AWS Signer
  #   Lambda 関数のコードに署名するための信頼できる署名プロファイルを指定します。
  #   - https://docs.aws.amazon.com/lambda/latest/dg/configuration-codesigning.html
  allowed_publishers {

    # signing_profile_version_arns (Required)
    # 設定内容: 許可する署名プロファイルバージョンのARNセットを指定します。
    # 設定可能な値: 有効な AWS Signer 署名プロファイルバージョンのARNのセット。最大20個まで指定可能
    signing_profile_version_arns = [
      "arn:aws:signer:ap-northeast-1:123456789012:/signing-profiles/example_profile/version1",
    ]
  }

  #-------------------------------------------------------------
  # コード署名ポリシー設定
  #-------------------------------------------------------------

  # policies (Optional)
  # 設定内容: 検証チェックが失敗した場合に実行するアクションを定義するポリシーブロックです。
  # 関連機能: Lambda コード署名ポリシー
  #   署名検証失敗時の動作（デプロイをブロックするか、警告のみにするか）を設定します。
  #   - https://docs.aws.amazon.com/lambda/latest/dg/configuration-codesigning.html
  policies {

    # untrusted_artifact_on_deployment (Required)
    # 設定内容: デプロイメント検証失敗時のコード署名設定ポリシーを指定します。
    # 設定可能な値:
    #   - "Enforce": 署名検証チェックが失敗した場合、デプロイメントリクエストをブロックします
    #   - "Warn": デプロイメントを許可し、CloudWatch Logs に検証失敗を記録します
    # 省略時: デフォルト値は "Warn"
    untrusted_artifact_on_deployment = "Enforce"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-code-signing-config"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: コード署名設定のAmazon Resource Name (ARN)
# - config_id: コード署名設定の一意の識別子
# - last_modified: コード署名設定が最後に変更された日時
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
