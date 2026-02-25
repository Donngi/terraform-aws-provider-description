#---------------------------------------------------------------
# Amazon Redshift IAM Identity Center Application
#---------------------------------------------------------------
#
# Amazon RedshiftをAWS IAM Identity Center（IDC）と統合するための
# マネージドアプリケーションをプロビジョニングするリソースです。
# このリソースにより、RedshiftクラスターやServerlessワークグループでの
# シングルサインオン（SSO）や信頼されたアイデンティティ伝播が実現できます。
# Lake Formation、S3 Access Grants、Redshift Connect等のサービス統合も設定可能です。
#
# AWS公式ドキュメント:
#   - AWS IAM Identity CenterとAmazon Redshiftの統合設定: https://docs.aws.amazon.com/redshift/latest/mgmt/redshift-iam-access-control-idp-connect-console.html
#   - Redshift IAM Identity Centerとの接続（SSO）: https://docs.aws.amazon.com/redshift/latest/mgmt/redshift-iam-access-control-idp-connect.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_idc_application
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
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
  # 設定内容: IAM Identity Center内のRedshiftアプリケーションの名前を指定します。
  # 設定可能な値: 文字列（一意の名前）
  redshift_idc_application_name = "example-redshift-idc-app"

  # idc_display_name (Required)
  # 設定内容: Amazon Redshift IAM Identity Centerアプリケーションインスタンスの
  #           表示名を指定します。IAM Identity Centerコンソールに表示される名前です。
  # 設定可能な値: 文字列
  idc_display_name = "Example Redshift Application"

  # idc_instance_arn (Required)
  # 設定内容: Redshiftが新しいマネージドアプリケーションを作成するIAM Identity Center
  #           インスタンスのARNを指定します。
  # 設定可能な値: 有効なIAM Identity CenterインスタンスのARN
  # 参考: data.aws_ssoadmin_instances を使用してARNを取得することが一般的です。
  idc_instance_arn = "arn:aws:sso:::instance/ssoins-12345678901234567"

  # iam_role_arn (Required)
  # 設定内容: Amazon Redshift IAM Identity Centerアプリケーションインスタンスに
  #           使用するIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 注意: このロールには、IAM Identity CenterのアプリケーションおよびインスタンスのDescribe権限と
  #       IDプロバイダーエントリの作成権限が必要です。
  iam_role_arn = "arn:aws:iam::123456789012:role/redshift-idc-role"

  #-------------------------------------------------------------
  # アプリケーション種別設定
  #-------------------------------------------------------------

  # application_type (Optional)
  # 設定内容: 作成するアプリケーションの種別を指定します。
  # 設定可能な値:
  #   - "None": 通常のRedshift IDCアプリケーション
  #   - "Lakehouse": Amazon Redshiftレイクハウスフェデレーテッドパーミッションを有効化するタイプ
  # 省略時: AWSが自動的に設定します。
  application_type = "None"

  #-------------------------------------------------------------
  # アイデンティティ設定
  #-------------------------------------------------------------

  # identity_namespace (Optional)
  # 設定内容: Amazon Redshift IAM Identity Centerアプリケーションインスタンスの
  #           ネームスペースを指定します。組織のユーザーIDプレフィックスとして使用されます。
  # 設定可能な値: 組織固有のネームスペース文字列
  # 省略時: AWSが自動的に設定します。
  identity_namespace = "EXAMPLE"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # 認証済みトークン発行者設定
  #-------------------------------------------------------------

  # authorized_token_issuer (Optional)
  # 設定内容: RedshiftとIAM Identity Centerを統合するための認証済みトークン発行者の
  #           リストを指定する設定ブロックです。
  # 関連機能: 信頼されたトークン発行者（Trusted Token Issuer）
  #   外部IDプロバイダーとの信頼関係を設定し、信頼されたアイデンティティ伝播を実現します。
  #   - https://docs.aws.amazon.com/redshift/latest/mgmt/redshift-iam-access-control-idp-connect.html
  authorized_token_issuer {

    # trusted_token_issuer_arn (Optional)
    # 設定内容: IAM Identity CenterとRedshiftを統合するための信頼されたトークン発行者の
    #           ARNを指定します。
    # 設定可能な値: 有効な信頼済みトークン発行者ARN
    trusted_token_issuer_arn = "arn:aws:sso:::trustedTokenIssuer/ssoins-12345678901234567/tti-12345678901234567"

    # authorized_audiences_list (Optional)
    # 設定内容: IAM Identity CenterとRedshiftを統合するための認証済みオーディエンスの
    #           リストを指定します。
    # 設定可能な値: オーディエンス識別子の文字列リスト
    authorized_audiences_list = ["https://signin.aws.amazon.com/platform/oauth2/v1/token"]
  }

  #-------------------------------------------------------------
  # サービス統合設定
  #-------------------------------------------------------------

  # service_integration (Optional)
  # 設定内容: Redshift IAM Identity Centerアプリケーションのサービス統合設定を指定します。
  #           Lake Formation、S3 Access Grants、Redshift Connectの統合スコープを定義します。
  # 関連機能: Redshift サービス統合
  #   IAM Identity Center経由でLake Formation、S3 Access Grants等のサービスへの
  #   アクセス権限を一元管理します。
  #   - https://docs.aws.amazon.com/redshift/latest/mgmt/redshift-iam-access-control-idp-connect.html
  service_integration {

    #-----------------------------------------------------------
    # Lake Formation統合設定
    #-----------------------------------------------------------

    # lake_formation (Optional)
    # 設定内容: Lake Formation統合のスコープリストを設定するブロックです。
    lake_formation {

      # lake_formation_query (Optional)
      # 設定内容: Lake Formationクエリスコープの設定ブロックです。
      lake_formation_query {

        # authorization (Required)
        # 設定内容: Lake Formationクエリスコープの有効・無効を指定します。
        # 設定可能な値:
        #   - "Enabled": Lake Formationクエリスコープを有効化
        #   - "Disabled": Lake Formationクエリスコープを無効化
        authorization = "Enabled"
      }
    }

    #-----------------------------------------------------------
    # Redshift Connect統合設定
    #-----------------------------------------------------------

    # redshift (Optional)
    # 設定内容: Redshift Connect統合のスコープリストを設定するブロックです。
    redshift {

      # connect (Optional)
      # 設定内容: Amazon Redshift Connectサービス統合のスコープ設定ブロックです。
      connect {

        # authorization (Required)
        # 設定内容: Redshift Connect統合の有効・無効を指定します。
        # 設定可能な値:
        #   - "Enabled": Redshift Connect統合を有効化
        #   - "Disabled": Redshift Connect統合を無効化
        authorization = "Enabled"
      }
    }

    #-----------------------------------------------------------
    # S3 Access Grants統合設定
    #-----------------------------------------------------------

    # s3_access_grants (Optional)
    # 設定内容: S3 Access Grants統合のスコープリストを設定するブロックです。
    # 関連機能: Amazon S3 Access Grants連携
    #   IAM Identity Center経由でS3 Access Grantsを使用した細かいアクセス制御が可能です。
    #   - https://aws.amazon.com/blogs/big-data/simplify-enterprise-data-access-using-the-amazon-redshift-integration-with-amazon-s3-access-grants/
    s3_access_grants {

      # read_write_access (Optional)
      # 設定内容: S3 Access Grantsの読み書きアクセス権限スコープ設定ブロックです。
      read_write_access {

        # authorization (Required)
        # 設定内容: S3 Access Grantsの読み書きスコープの有効・無効を指定します。
        # 設定可能な値:
        #   - "Enabled": 読み書きスコープを有効化
        #   - "Disabled": 読み書きスコープを無効化
        authorization = "Enabled"
      }
    }
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  tags = {
    Name        = "example-redshift-idc-app"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - idc_managed_application_arn: Amazon Redshift IAM Identity Center
#                                アプリケーションのARN。
#
# - redshift_idc_application_arn: IAM Identity Center内のRedshift
#                                  アプリケーションのARN。
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
