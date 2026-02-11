#---------------------------------------------------------------
# Amazon OpenSearch Serverless Security Policy
#---------------------------------------------------------------
#
# Amazon OpenSearch Serverlessのセキュリティポリシーを管理するためのリソースです。
# 1つ以上のOpenSearch Serverlessコレクションに対してセキュリティポリシーを作成します。
#
# セキュリティポリシーのタイプ:
# - encryption: 暗号化ポリシー（KMSキーを使用した保存時の暗号化を制御）
# - network: ネットワークポリシー（パブリックネットワークまたはVPCエンドポイントからのアクセスを制御）
#
# 暗号化ポリシー:
# コレクションの保存時の暗号化を管理し、AWS所有のキーまたはカスタマー管理型KMSキーを
# 使用するかを設定できます。コレクション作成前に暗号化ポリシーが必要です。
#
# ネットワークポリシー:
# コレクションエンドポイントとOpenSearch Dashboardsエンドポイントへのネットワーク
# アクセスを制御します。パブリックアクセスまたはVPCエンドポイント経由のプライベート
# アクセスを設定できます。
#
# AWS公式ドキュメント:
#   - セキュリティ概要: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/serverless-security.html
#   - 暗号化ポリシー: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/serverless-encryption.html
#   - ネットワークポリシー: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/serverless-network.html
#   - CreateSecurityPolicy API: https://docs.aws.amazon.com/opensearch-service/latest/ServerlessAPIReference/API_CreateSecurityPolicy.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/opensearchserverless_security_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-02
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 例1: 暗号化ポリシー - AWS所有キー（単一コレクション）
#---------------------------------------------------------------

resource "aws_opensearchserverless_security_policy" "encryption_single_aws_key" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: セキュリティポリシーの名前を指定します。
  # 設定可能な値: 文字列（3～32文字）
  # 注意:
  #   - 名前は小文字で始まり、小文字、数字、ハイフンのみを含む必要があります
  #   - アカウントとリージョン内で一意である必要があります
  name = "example-encryption-policy"

  # type (Required)
  # 設定内容: セキュリティポリシーのタイプを指定します。
  # 設定可能な値:
  #   - "encryption": 保存時の暗号化を制御
  #   - "network": ネットワークアクセスを制御
  type = "encryption"

  # description (Optional)
  # 設定内容: ポリシーの説明を指定します。
  # 設定可能な値: 文字列
  # 用途: ポリシーで定義された権限や目的を文書化するために使用
  description = "AWS所有キーを使用したサンプルコレクションの暗号化ポリシー"

  #-------------------------------------------------------------
  # ポリシー定義（暗号化ポリシー）
  #-------------------------------------------------------------

  # policy (Required)
  # 設定内容: 新しいポリシーのコンテンツとして使用するJSONポリシードキュメントを指定します。
  #
  # 暗号化ポリシーの構造:
  #   - Rules: ルールの配列
  #     - Resource: コレクション名/パターンの配列（"collection/<name|pattern>"形式）
  #     - ResourceType: "collection"（現在唯一のオプション）
  #   - AWSOwnedKey: AWS所有キーを使用する場合はtrue、カスタマー管理型キーの場合はfalse
  #   - KmsARN: (Optional) カスタマー管理型KMSキーのARN（AWSOwnedKeyがfalseの場合必須）
  #
  # 注意事項:
  #   - 一意のKMSキーを持つコレクションはOCU（OpenSearch Compute Units）を共有できません
  #   - 一意のキーを持つ各コレクションには最低4 OCUが必要です
  policy = jsonencode({
    Rules = [
      {
        Resource = [
          "collection/example-collection"
        ],
        ResourceType = "collection"
      }
    ],
    AWSOwnedKey = true
  })

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# 例2: 暗号化ポリシー - ワイルドカードで複数コレクション
#---------------------------------------------------------------

resource "aws_opensearchserverless_security_policy" "encryption_multiple_collections" {
  name        = "log-collections-encryption"
  type        = "encryption"
  description = "AWS所有キーを使用した全ログコレクションの暗号化ポリシー"

  # ワイルドカードパターンマッチング:
  #   - "collection/log-*" は log-production, log-staging, log-dev などにマッチ
  #   - より具体的なパターンが一般的なパターンよりも優先されます
  #   - 複数のポリシーがマッチする場合、最も具体的なパターンが使用されます
  #
  # パターンの例:
  #   - "collection/specific-name": 特定のコレクション名
  #   - "collection/prefix-*": プレフィックスマッチング
  #   - 複数のリソースパターンを1つのポリシーで指定可能
  policy = jsonencode({
    Rules = [
      {
        Resource = [
          "collection/log-*"
        ],
        ResourceType = "collection"
      }
    ],
    AWSOwnedKey = true
  })
}

#---------------------------------------------------------------
# 例3: 暗号化ポリシー - カスタマー管理型KMSキー
#---------------------------------------------------------------

resource "aws_opensearchserverless_security_policy" "encryption_customer_key" {
  name        = "customer-key-encryption"
  type        = "encryption"
  description = "カスタマー管理型KMSキーを使用した暗号化ポリシー"

  # カスタマー管理型キーの使用:
  #   - AWSOwnedKeyをfalseに設定
  #   - KmsARNパラメータでKMSキーのフルARNを指定
  #   - KMSキーポリシーでOpenSearch Serverlessに必要な権限を付与する必要があります
  #
  # 必要なKMSキー権限:
  #   - kms:DescribeKey
  #   - kms:CreateGrant
  #   - kms:Decrypt
  #   - kms:GenerateDataKey
  #
  # 重要な注意事項:
  #   - コレクション作成後は暗号化キーを変更できません
  #   - 異なるキーを使用する場合はコレクションを再作成する必要があります
  #   - AWSは自動キーローテーションの有効化を推奨しています
  policy = jsonencode({
    Rules = [
      {
        Resource = [
          "collection/secure-data-collection"
        ],
        ResourceType = "collection"
      }
    ],
    AWSOwnedKey = false
    KmsARN      = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  })
}

#---------------------------------------------------------------
# 例4: ネットワークポリシー - パブリックアクセス
#---------------------------------------------------------------

resource "aws_opensearchserverless_security_policy" "network_public_access" {
  name        = "public-access-policy"
  type        = "network"
  description = "コレクションとDashboardsエンドポイントへのパブリックアクセスを許可"

  # ネットワークポリシーの構造（JSON配列）:
  # 配列の各要素には以下が含まれます:
  #   - Description: ルールの説明
  #   - Rules: アクセスルールの配列
  #     - ResourceType: "collection"（APIエンドポイント）または "dashboard"（Dashboardsエンドポイント）
  #     - Resource: コレクション名/パターンの配列
  #   - AllowFromPublic: パブリックアクセスの場合true、プライベートアクセスの場合false
  #   - SourceVPCEs: (Optional) プライベートアクセス用のVPCエンドポイントIDの配列
  #   - SourceServices: (Optional) AWSサービス識別子の配列（例: "bedrock.amazonaws.com"）
  #
  # 注意: AllowFromPublicがtrueの場合、SourceVPCEsとSourceServicesは無視されます
  #
  # ユースケース:
  #   - 開発・テスト環境
  #   - パブリック向け検索アプリケーション
  #   - 追加のアクセス制御をデータアクセスポリシーで処理する場合
  policy = jsonencode([
    {
      Description = "コレクションとDashboardsエンドポイントへのパブリックアクセス"
      Rules = [
        {
          ResourceType = "collection"
          Resource = [
            "collection/example-collection"
          ]
        },
        {
          ResourceType = "dashboard"
          Resource = [
            "collection/example-collection"
          ]
        }
      ]
      AllowFromPublic = true
    }
  ])
}

#---------------------------------------------------------------
# 例5: ネットワークポリシー - VPCエンドポイントアクセス
#---------------------------------------------------------------

resource "aws_opensearchserverless_security_policy" "network_vpc_access" {
  name        = "vpc-access-policy"
  type        = "network"
  description = "コレクションとDashboardsへのVPCエンドポイントアクセスを許可"

  # プライベートアクセスの設定:
  #   - AllowFromPublicをfalseに設定
  #   - SourceVPCEs配列に1つ以上のVPCエンドポイントIDを指定
  #   - アクセスは指定されたVPCエンドポイントのみに制限されます
  #
  # 前提条件:
  #   - 事前にOpenSearch Serverless管理型VPCエンドポイントを作成する必要があります
  #   - VPCエンドポイントはコレクションと同じリージョンにある必要があります
  #
  # 注意:
  #   - AWSサービス（Bedrockなど）へのプライベートアクセスはコレクション
  #     エンドポイントにのみ適用され、Dashboardsエンドポイントには適用されません
  #
  # ユースケース:
  #   - ネットワーク分離が必要な本番環境
  #   - プライベートネットワークアクセスのコンプライアンス要件
  #   - バックエンドのみのOpenSearchアクセスを持つマルチティアアプリケーション
  policy = jsonencode([
    {
      Description = "セキュアコレクションへのVPCエンドポイントアクセス"
      Rules = [
        {
          ResourceType = "collection"
          Resource = [
            "collection/secure-collection"
          ]
        },
        {
          ResourceType = "dashboard"
          Resource = [
            "collection/secure-collection"
          ]
        }
      ]
      AllowFromPublic = false
      SourceVPCEs = [
        "vpce-050f79086ee71ac05"
      ]
    }
  ])
}

#---------------------------------------------------------------
# 例6: ネットワークポリシー - AWSサービスアクセス（Bedrock等）
#---------------------------------------------------------------

resource "aws_opensearchserverless_security_policy" "network_service_access" {
  name        = "bedrock-access-policy"
  type        = "network"
  description = "Amazon Bedrockのコレクションアクセスを許可"

  # AWSサービスアクセス:
  #   - SourceServices: AWSサービス識別子の配列
  #   - サービスアクセスはコレクションエンドポイントにのみ適用（Dashboardsには適用されません）
  #   - VPCエンドポイントアクセスと組み合わせて使用可能
  #
  # サポートされるサービスの例:
  #   - "bedrock.amazonaws.com": Amazon Bedrock
  #   - その他のAWSサービス識別子
  #
  # 注意事項:
  #   - ResourceTypeが"dashboard"の場合でも、AWSサービスはDashboardsにアクセスできません
  #   - サービスアクセスは常にコレクションエンドポイント（OpenSearch API）にのみ適用されます
  policy = jsonencode([
    {
      Description = "Bedrockのコレクションアクセスを許可"
      Rules = [
        {
          ResourceType = "collection"
          Resource = [
            "collection/ai-collection"
          ]
        }
      ]
      AllowFromPublic = false
      SourceServices = [
        "bedrock.amazonaws.com"
      ]
    }
  ])
}

#---------------------------------------------------------------
# 例7: ネットワークポリシー - 複数コレクションの混合アクセス
#---------------------------------------------------------------

resource "aws_opensearchserverless_security_policy" "network_mixed_access" {
  name        = "mixed-access-policy"
  type        = "network"
  description = "異なるコレクションパターンの混合アクセス"

  # ポリシー優先順位ルール:
  #   - ルールが重複する場合、パブリックアクセスがプライベートアクセスを上書きします
  #   - コレクションがパブリックとプライベートの両方のルールに含まれる場合、パブリックになります
  #   - 同じコレクションの複数のVPCエンドポイントは追加的に適用されます
  #
  # このポリシーの例:
  #   1. マーケティングコレクション用のVPCアクセス（APIとDashboardsの両方）
  #   2. ファイナンスコレクション用のパブリックアクセス（APIのみ、Dashboardsなし）
  #   3. ワイルドカードを使用した複数コレクションのマッチング
  #
  # 複雑なアクセス要件の管理:
  #   - 異なる環境（開発、ステージング、本番）で異なるアクセスパターン
  #   - 部門やチームごとの異なるセキュリティ要件
  #   - コレクションタイプに基づくアクセス制御
  policy = jsonencode([
    {
      Description = "マーケティングコレクション用のVPCアクセス"
      Rules = [
        {
          ResourceType = "collection"
          Resource = [
            "collection/marketing-*"
          ]
        },
        {
          ResourceType = "dashboard"
          Resource = [
            "collection/marketing-*"
          ]
        }
      ]
      AllowFromPublic = false
      SourceVPCEs = [
        "vpce-050f79086ee71ac05"
      ]
    },
    {
      Description = "ファイナンスコレクション用のパブリックAPIアクセス"
      Rules = [
        {
          ResourceType = "collection"
          Resource = [
            "collection/finance"
          ]
        }
      ]
      AllowFromPublic = true
    }
  ])
}

#---------------------------------------------------------------
# 例8: ネットワークポリシー - Dashboardsのみパブリックアクセス
#---------------------------------------------------------------

resource "aws_opensearchserverless_security_policy" "network_dashboard_only" {
  name        = "dashboard-only-access"
  type        = "network"
  description = "Dashboardsのみパブリックアクセス、プライベートAPIアクセス"

  # Dashboardsのみのアクセス:
  #   - パブリックアクセスルールに"dashboard" ResourceTypeのみを含める
  #   - コレクションエンドポイント（API）はプライベートのまま
  #   - ユーザーはDashboards経由でデータを表示/クエリできますが、直接API呼び出しはできません
  #
  # ユースケース:
  #   - データの可視化と分析にUIアクセスのみを提供したい場合
  #   - APIアクセスを内部システムに制限しつつ、Dashboardsを広く公開したい場合
  #   - セキュリティ層を追加して直接APIアクセスを防ぎたい場合
  policy = jsonencode([
    {
      Description = "パブリックDashboardsアクセス、直接APIアクセスなし"
      Rules = [
        {
          ResourceType = "dashboard"
          Resource = [
            "collection/analytics-*"
          ]
        }
      ]
      AllowFromPublic = true
    }
  ])
}

#---------------------------------------------------------------
# 例9: 暗号化ポリシー - 異なるパターンの複数コレクション
#---------------------------------------------------------------

resource "aws_opensearchserverless_security_policy" "encryption_multi_pattern" {
  name        = "multi-pattern-encryption"
  type        = "encryption"
  description = "様々なアプリケーションコレクションの暗号化ポリシー"

  # 1つのポリシーに複数のリソースパターン:
  #   - 正確なコレクション名を含めることができます
  #   - ワイルドカードパターンを含めることができます
  #   - 他の暗号化ポリシーのパターンと重複できません
  #   - 他のポリシーのより具体的なパターンが優先されます
  #
  # パターン重複のルール:
  #   - 同じ名前やプレフィックスを既に別のポリシーで使用している場合は使用できません
  #   - OpenSearch Serverlessは異なる暗号化ポリシーで同一のリソース
  #     パターンを設定しようとするとエラーを表示します
  #
  # パターン優先順位の例:
  #   - あるポリシーが "collection/log*" のルールを含み
  #   - 別のポリシーが "collection/logSpecial" を含む場合
  #   - 2番目のポリシーの暗号化キーが使用されます（より具体的なため）
  policy = jsonencode({
    Rules = [
      {
        Resource = [
          "collection/app-production",
          "collection/app-staging",
          "collection/analytics-*",
          "collection/logs-*"
        ],
        ResourceType = "collection"
      }
    ],
    AWSOwnedKey = true
  })
}

#---------------------------------------------------------------
# Attributes Reference（参照専用の属性）
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です（入力不可）:
#
# - id
#   セキュリティポリシーの名前（name属性と同じ値）
#
# - policy_version
#   ポリシーのバージョン番号
#   - ポリシーを更新するたびに自動的にインクリメントされます
#   - ポリシーの変更履歴を追跡するために使用
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 重要な注意事項
#---------------------------------------------------------------
#
# 【暗号化ポリシーの考慮事項】
#
# 1. 暗号化の必須要件:
#    - 保存時の暗号化はすべてのOpenSearch Serverlessコレクションで必須です
#    - コレクション作成前に暗号化ポリシーが必要です
#
#---------------------------------------------------------------
