#---------------------------------------------------------------
# Amazon SageMaker AI Workteam
#---------------------------------------------------------------
#
# データのラベリングやヒューマンレビュージョブを実行するための
# ワークチーム（作業チーム）をプロビジョニングするリソースです。
# ワークチームは、Amazon CognitoユーザープールまたはOIDC Identity Provider
# を使用して作成されたワークフォースのメンバーで構成されます。
# Ground Truthのラベリングジョブや、Augmented AIのヒューマンレビュー
# タスクにワーカーを割り当てる際に使用します。
#
# AWS公式ドキュメント:
#   - CreateWorkteam API: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateWorkteam.html
#   - Workteam: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_Workteam.html
#   - Manage a Workforce (Console): https://docs.aws.amazon.com/sagemaker/latest/dg/sms-workforce-management-private-console.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_workteam
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sagemaker_workteam" "example" {
  #-------------------------------------------------------------
  # 基本設定 (Required)
  #-------------------------------------------------------------

  # workteam_name (Required)
  # 設定内容: ワークチームの名前を指定します。ワークチームを識別するために使用されます。
  # 設定可能な値: 英数字とハイフン（-）を使用した1〜63文字の文字列
  # パターン: [a-zA-Z0-9](-*[a-zA-Z0-9]){0,62}
  # 制約: アカウントとリージョン内で一意である必要があります
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateWorkteam.html
  workteam_name = "example-workteam"

  # description (Required)
  # 設定内容: ワークチームの説明を指定します。
  # 設定可能な値: 1〜200文字の文字列
  # 用途: ワークチームの目的や役割を説明するために使用します
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateWorkteam.html
  description = "Example workteam for data labeling tasks"

  #-------------------------------------------------------------
  # ID設定 (Optional)
  #-------------------------------------------------------------

  # id (Optional)
  # 設定内容: リソースの識別子を指定します。
  # 省略時: Terraformが自動的にワークチーム名を使用して設定します
  # 注意: 通常、この属性は明示的に設定する必要はありません。
  #       Terraformが自動的に管理します
  id = null

  #-------------------------------------------------------------
  # ワークフォース設定 (Optional)
  #-------------------------------------------------------------

  # workforce_name (Optional)
  # 設定内容: ワークフォースの名前を指定します。
  # 設定可能な値: 英数字とハイフン（-）を使用した1〜63文字の文字列
  # パターン: [a-zA-Z0-9]([a-zA-Z0-9\-]){0,62}
  # 用途: このワークチームが属するワークフォースを指定します
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateWorkteam.html
  workforce_name = null

  #-------------------------------------------------------------
  # メンバー定義 (Required)
  #-------------------------------------------------------------

  # member_definition (Required)
  # 設定内容: ワークチームを構成するワーカーを識別するメンバー定義のリストです。
  # 制約: 最小1個、最大10個のメンバー定義を指定可能
  # 用途: Amazon Cognitoユーザーグループ、またはOIDC IdPのユーザーグループを
  #       使用してワークチームのメンバーを定義します
  # 注意: cognito_member_definitionとoidc_member_definitionのいずれか一方のみを
  #       指定してください。両方を同時に指定することはできません
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateWorkteam.html
  member_definition {
    # cognito_member_definition (Optional)
    # 設定内容: ワークチームの一部であるAmazon Cognitoユーザーグループを指定します。
    # 制約: 最大1個まで指定可能
    # 用途: Amazon Cognitoを使用して作成されたプライベートワークフォースで使用します
    # 注意: 同一ワークチーム内のすべてのCognitoMemberDefinitionは、同じClientIdと
    #       UserPoolの値を持つ必要があります
    # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateWorkteam.html
    cognito_member_definition {
      # client_id (Required)
      # 設定内容: アプリケーションクライアントの識別子を指定します。
      # 用途: Amazon Cognitoを使用してアプリクライアントIDを作成する必要があります
      # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateWorkteam.html
      client_id = "example-client-id"

      # user_pool (Required)
      # 設定内容: ユーザープールの識別子を指定します。
      # 制約: ユーザープールは、呼び出しているサービスと同じリージョンに存在する必要があります
      # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateWorkteam.html
      user_pool = "us-east-1_example"

      # user_group (Required)
      # 設定内容: ユーザーグループの識別子を指定します。
      # 用途: Amazon Cognitoユーザープール内のユーザーグループを指定します
      # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateWorkteam.html
      user_group = "example-user-group"
    }

    # oidc_member_definition (Optional)
    # 設定内容: OIDC IdPに存在するユーザーグループのリストを指定します。
    # 制約: 最大1個まで指定可能
    # 用途: 独自のOIDC Identity Providerを使用して作成されたワークフォースで使用します
    # 注意: 1〜10個のグループを使用して単一のプライベートワークチームを作成できます
    # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateWorkteam.html
    # oidc_member_definition {
    #   # groups (Required)
    #   # 設定内容: OIDC IdPのユーザーグループを識別するカンマ区切りの文字列リストです。
    #   # 用途: 各ユーザーグループは、プライベートワーカーのグループで構成されます
    #   # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateWorkteam.html
    #   groups = ["example-group-1", "example-group-2"]
    # }
  }

  #-------------------------------------------------------------
  # 通知設定 (Optional)
  #-------------------------------------------------------------

  # notification_configuration (Optional)
  # 設定内容: 利用可能または期限切れ間近の作業項目に関するワーカーへの通知を設定します。
  # 制約: 最大1個まで指定可能
  # 用途: Amazon SNSトピックを使用して、ワーカーに新しいラベリングジョブが
  #       利用可能になったときや期限切れが近づいているときに通知します
  # 注意: Amazon SNS通知はGround Truthでサポートされており、Augmented AIでは
  #       サポートされていません
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateWorkteam.html
  notification_configuration {
    # notification_topic_arn (Optional)
    # 設定内容: 通知を発行するSNSトピックのARNを指定します。
    # 設定可能な値: 有効なAmazon SNSトピックARN
    # 用途: ワークチームのメンバーに通知を送信するためのSNSトピックを指定します
    # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateWorkteam.html
    notification_topic_arn = null
  }

  #-------------------------------------------------------------
  # ワーカーアクセス設定 (Optional)
  #-------------------------------------------------------------

  # worker_access_configuration (Optional)
  # 設定内容: IPアドレスに基づいてAmazon S3リソースへのアクセスを制約するための設定です。
  # 制約: 最大1個まで指定可能
  # 用途: サポートされているIAMグローバル条件キーを使用して、Amazon S3リソースへの
  #       アクセスを制約します。Amazon S3リソースは、ワーカーポータルでAmazon S3
  #       事前署名URLを使用してアクセスされます
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateWorkteam.html
  worker_access_configuration {
    # s3_presign (Optional)
    # 設定内容: Amazon S3リソース制約を定義します。
    # 制約: 最大1個まで指定可能
    # 用途: Amazon S3事前署名URLの生成に使用されるIAMポリシー条件を設定します
    # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateWorkteam.html
    s3_presign {
      # iam_policy_constraints (Optional)
      # 設定内容: 許可されたリクエストソースを指定するために使用します。
      # 制約: 最大1個まで指定可能
      # 用途: SourceIPまたはVpcSourceIpのいずれかをソースとして指定できます
      # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateWorkteam.html
      iam_policy_constraints {
        # source_ip (Optional)
        # 設定内容: ワーカーポータルでタスクがレンダリングされる際のワーカーのIPアドレスを
        #           IAMポリシーに条件として追加するかどうかを指定します。
        # 設定可能な値: "Enabled" または "Disabled"
        # 用途: Amazon S3事前署名URLを生成する際に使用される条件として、
        #       ワーカーのIPアドレスを追加します。Amazon S3はこのIPアドレスを
        #       チェックし、一致する必要があります
        # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateWorkteam.html
        source_ip = null

        # vpc_source_ip (Optional)
        # 設定内容: VPC内のプライベートワーカーポータルでタスクがレンダリングされる際の
        #           ワーカーのIPアドレスをIAMポリシーに条件として追加するかどうかを指定します。
        # 設定可能な値: "Enabled" または "Disabled"
        # 用途: Amazon S3事前署名URLを生成する際に使用される条件として、
        #       ワーカーのIPアドレスを追加します。タスクを正常にレンダリングするには、
        #       Amazon S3は事前署名URLがAmazon S3 VPCエンドポイント経由でアクセスされ、
        #       ワーカーのIPアドレスがIAMポリシーのIPアドレスと一致することを確認します
        # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/samurai-vpc-worker-portal.html
        vpc_source_ip = null
      }
    }
  }

  #-------------------------------------------------------------
  # タグ設定 (Optional)
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ（最大50個）
  # 用途: リソースの分類、コスト追跡、アクセス制御などに使用します
  # 注意: プロバイダーのdefault_tags設定ブロックと一致するキーを持つタグは、
  #       プロバイダーレベルで定義されたタグを上書きします
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Environment = "production"
    Team        = "data-science"
  }

  # tags_all (Optional)
  # 設定内容: プロバイダーのdefault_tagsから継承されたタグを含む、
  #           リソースに割り当てられたすべてのタグのマップです。
  # 注意: この属性は通常、明示的に設定する必要はありません。
  #       Terraformが自動的に管理します
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags_all = {}

  #-------------------------------------------------------------
  # リージョン設定 (Optional)
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースが管理されるリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定で設定されたリージョンがデフォルトで使用されます
  # 用途: プロバイダーのデフォルトリージョンとは異なるリージョンでリソースを
  #       管理する必要がある場合に使用します
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: AWSによってこのワークチームに割り当てられたAmazon Resource Name (ARN)
#        ワークチームの識別に使用できます
#
# - id: ワークチームの名前（workteam_nameと同じ値）
#
# - subdomain: OIDC Identity Providerのサブドメイン
#              OIDC IdPを使用している場合にのみ設定されます
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたタグのマップ
#---------------------------------------------------------------
