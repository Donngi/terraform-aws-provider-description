#---------------------------------------------------------------
# AWS Redshift IDC Application
#---------------------------------------------------------------
#
# Amazon Redshift IAM Identity Center（IDC）アプリケーションを作成するための
# リソースです。RedshiftクラスターをIAM Identity Centerと統合し、
# シングルサインオン（SSO）による統一された認証・認可を実現します。
#
# AWS公式ドキュメント:
#   - Redshift IAM Identity Center統合: https://docs.aws.amazon.com/redshift/latest/mgmt/redshift-iam-access-control-identity-center.html
#   - IAM Identity Center概要: https://docs.aws.amazon.com/singlesignon/latest/userguide/what-is.html
#   - Redshiftセキュリティ: https://docs.aws.amazon.com/redshift/latest/mgmt/security.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_idc_application
#
# Provider Version: 6.28.0
# Generated: 2025-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_redshift_idc_application" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # redshift_idc_application_name (Required)
  # 設定内容: IAM Identity CenterにおけるRedshiftアプリケーションの名前を指定します。
  # 設定可能な値: 文字列
  # 用途: IAM Identity Center内でアプリケーションを識別するための名前
  redshift_idc_application_name = "my-redshift-idc-app"

  # idc_display_name (Required)
  # 設定内容: IAM Identity Centerアプリケーションインスタンスの表示名を指定します。
  # 設定可能な値: 文字列
  # 用途: ユーザーがIAM Identity Centerポータルで見る表示名
  idc_display_name = "My Redshift Application"

  # idc_instance_arn (Required)
  # 設定内容: Redshiftが新しいマネージドアプリケーションを作成する
  #           IAM Identity CenterインスタンスのARNを指定します。
  # 設定可能な値: IAM Identity CenterインスタンスのARN
  # 取得方法: data.aws_ssoadmin_instances.example.arns を使用
  # 例: tolist(data.aws_ssoadmin_instances.example.arns)[0]
  idc_instance_arn = "arn:aws:sso:::instance/ssoins-1234567890abcdef"

  # iam_role_arn (Required)
  # 設定内容: Amazon Redshift IAM Identity Centerアプリケーションインスタンスの
  #           IAMロールARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 用途: RedshiftがIAM Identity Centerと連携するために必要な権限を提供
  iam_role_arn = "arn:aws:iam::123456789012:role/RedshiftIDCRole"

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # identity_namespace (Optional)
  # 設定内容: Amazon Redshift IAM Identity Centerアプリケーションインスタンスの
  #           IDネームスペースを指定します。
  # 設定可能な値: 文字列
  # 用途: 複数のRedshiftクラスター間でユーザーIDを識別するための名前空間
  identity_namespace = "my-namespace"

  # application_type (Optional)
  # 設定内容: 作成されるアプリケーションのタイプを指定します。
  # 設定可能な値:
  #   - "None": 標準のRedshiftアプリケーション（デフォルト）
  #   - "Lakehouse": Lake Formationと統合するLakehouseアプリケーション
  # 用途: AWS Lake Formationとの統合が必要な場合は"Lakehouse"を指定
  application_type = "None"

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
  # authorized_token_issuer ブロック (Optional)
  #-------------------------------------------------------------
  # IAM Identity Centerと統合するための認可トークン発行者リストを定義します。
  # 信頼されたトークン発行者を設定して、外部IDプロバイダーとの統合を実現します。

  authorized_token_issuer {
    # trusted_token_issuer_arn (Required)
    # 設定内容: IAM Identity Centerと統合するための認可トークン発行者のARNを指定します。
    # 設定可能な値: 信頼されたトークン発行者のARN
    # 用途: 外部IDプロバイダーとの連携に使用
    trusted_token_issuer_arn = "arn:aws:sso::123456789012:trustedTokenIssuer/sso-tis-1234567890abcdef"

    # authorized_audiences_list (Required)
    # 設定内容: IAM Identity Centerと統合するための認可トークン発行者の
    #           対象オーディエンスリストを指定します。
    # 設定可能な値: オーディエンス識別子の文字列リスト
    # 用途: トークンの対象者を検証するためのオーディエンス値
    authorized_audiences_list = [
      "https://myapp.example.com",
      "https://myapp-dev.example.com"
    ]
  }

  #-------------------------------------------------------------
  # service_integration ブロック (Optional)
  #-------------------------------------------------------------
  # Redshift IAM Identity Centerアプリケーションのサービス統合コレクションを定義します。
  # Lake Formation、Redshift、S3 Access Grantsとの統合を設定できます。

  service_integration {
    #-----------------------------------------------------------
    # lake_formation ブロック (Optional)
    #-----------------------------------------------------------
    # AWS Lake Formation統合のスコープを設定します。

    lake_formation {
      # lake_formation_query ブロック (Optional)
      # Lake Formationクエリスコープを定義します。

      lake_formation_query {
        # authorization (Required)
        # 設定内容: クエリスコープを有効または無効にするかを指定します。
        # 設定可能な値:
        #   - "Enabled": Lake Formationクエリスコープを有効化
        #   - "Disabled": Lake Formationクエリスコープを無効化
        authorization = "Enabled"
      }
    }

    #-----------------------------------------------------------
    # redshift ブロック (Optional)
    #-----------------------------------------------------------
    # Amazon Redshift統合のスコープを設定します。

    redshift {
      # connect ブロック (Optional)
      # Amazon Redshift接続サービス統合スコープを定義します。

      connect {
        # authorization (Required)
        # 設定内容: 接続統合を有効または無効にするかを指定します。
        # 設定可能な値:
        #   - "Enabled": Redshift接続統合を有効化
        #   - "Disabled": Redshift接続統合を無効化
        # 用途: RedshiftへのSSO接続を制御
        authorization = "Enabled"
      }
    }

    #-----------------------------------------------------------
    # s3_access_grants ブロック (Optional)
    #-----------------------------------------------------------
    # AWS S3 Access Grants統合のスコープを設定します。

    s3_access_grants {
      # read_write_access ブロック (Optional)
      # S3 Access Grants読み取り/書き込み統合スコープを定義します。

      read_write_access {
        # authorization (Required)
        # 設定内容: 読み取り/書き込みスコープを有効または無効にするかを指定します。
        # 設定可能な値:
        #   - "Enabled": S3 Access Grants読み取り/書き込みアクセスを有効化
        #   - "Disabled": S3 Access Grants読み取り/書き込みアクセスを無効化
        # 用途: S3データへのきめ細かいアクセス制御を実現
        authorization = "Enabled"
      }
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - idc_managed_application_arn: Amazon Redshift IAM Identity Centerアプリケーションの
#                                ARN（IAM Identity Center側で管理されるARN）
#
# - redshift_idc_application_arn: IAM Identity CenterにおけるRedshiftアプリケーションの
#                                 ARN（Redshift側で管理されるARN）
#
# - id: Redshift IDCアプリケーションのユニークID
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: IAM Identity Centerインスタンスの取得
#---------------------------------------------------------------
# data "aws_ssoadmin_instances" "example" {}
#
# resource "aws_iam_role" "example" {
#   name = "redshift-idc-role"
#
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "redshift.amazonaws.com"
#         }
#       }
#     ]
#   })
# }
#
# resource "aws_redshift_idc_application" "example" {
#   iam_role_arn                  = aws_iam_role.example.arn
#   idc_display_name              = "example"
#   idc_instance_arn              = tolist(data.aws_ssoadmin_instances.example.arns)[0]
#   identity_namespace            = "example"
#   redshift_idc_application_name = "example"
# }
#---------------------------------------------------------------
