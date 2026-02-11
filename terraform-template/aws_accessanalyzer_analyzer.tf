#---------------------------------------------------------------
# AWS IAM Access Analyzer
#---------------------------------------------------------------
#
# AWS IAM Access Analyzerのアナライザーをプロビジョニングするリソースです。
# Access Analyzerは、組織やアカウント内のリソースへのアクセスを分析し、
# 外部エンティティと共有されているリソース、内部アクセス、未使用アクセスを
# 特定するのに役立ちます。
#
# AWS公式ドキュメント:
#   - IAM Access Analyzer概要: https://docs.aws.amazon.com/IAM/latest/UserGuide/what-is-access-analyzer.html
#   - サポートされるリソースタイプ: https://docs.aws.amazon.com/IAM/latest/UserGuide/access-analyzer-resources.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/accessanalyzer_analyzer
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_accessanalyzer_analyzer" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # analyzer_name (Required)
  # 設定内容: アナライザーの名前を指定します。
  # 設定可能な値: 1文字以上の文字列
  # 注意: リソース作成後の変更はできません（Forces new resource）
  analyzer_name = "example-analyzer"

  # type (Optional)
  # 設定内容: アナライザーのタイプを指定します。アナライザーの信頼ゾーンまたはスコープを表します。
  # 設定可能な値:
  #   - "ACCOUNT" (デフォルト): アカウントレベルの外部アクセス分析
  #   - "ORGANIZATION": 組織レベルの外部アクセス分析
  #   - "ACCOUNT_INTERNAL_ACCESS": アカウント内の内部アクセス分析
  #   - "ORGANIZATION_INTERNAL_ACCESS": 組織内の内部アクセス分析
  #   - "ACCOUNT_UNUSED_ACCESS": アカウントレベルの未使用アクセス分析
  #   - "ORGANIZATION_UNUSED_ACCESS": 組織レベルの未使用アクセス分析
  # 省略時: "ACCOUNT"
  # 関連機能: IAM Access Analyzerタイプ
  #   外部アクセス、内部アクセス、未使用アクセスの3つの分析タイプを提供。
  #   各タイプは異なるユースケースに対応しています。
  #   - https://docs.aws.amazon.com/IAM/latest/UserGuide/what-is-access-analyzer.html
  type = "ACCOUNT"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-analyzer"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # アナライザー設定
  #-------------------------------------------------------------

  # configuration (Optional)
  # 設定内容: アナライザーの設定を指定するブロックです。
  # 注意: internal_accessまたはunused_accessのどちらか一方を指定します。
  configuration {
    #-----------------------------------------------------------
    # 内部アクセス設定 (internal_access)
    #-----------------------------------------------------------
    # AWS組織またはアカウントの内部アクセスアナライザーの設定を指定します。
    # この設定により、AWS環境内のアクセスをアナライザーがどのように評価するかが決まります。
    # 注意: typeが "ACCOUNT_INTERNAL_ACCESS" または "ORGANIZATION_INTERNAL_ACCESS" の場合に使用
    internal_access {
      # analysis_rule (Optional)
      # 設定内容: 内部アクセスアナライザーの分析ルールに関する情報です。
      #          これらのルールは、どのリソースとアクセスパターンが分析されるかを決定します。
      analysis_rule {
        # inclusion (Optional)
        # 設定内容: 分析に含める基準を含む内部アクセスアナライザーのルールリストです。
        #          ルール基準を満たすリソースのみが検出結果を生成します。
        # 注意: 複数のinclusionブロックを指定できます
        inclusion {
          # account_ids (Optional)
          # 設定内容: 内部アクセス分析ルール基準に適用するAWSアカウントIDのリストです。
          # 設定可能な値: AWSアカウントIDの配列
          # 注意: アカウントIDは、組織レベルのアナライザーの分析ルール基準にのみ適用できます
          account_ids = ["123456789012"]

          # resource_arns (Optional)
          # 設定内容: 内部アクセス分析ルール基準に適用するリソースARNのリストです。
          # 設定可能な値: ARNの配列
          # 注意: アナライザーは、これらのARNに一致するリソースに対してのみ検出結果を生成します
          resource_arns = ["arn:aws:s3:::my-example-bucket"]

          # resource_types (Optional)
          # 設定内容: 内部アクセス分析ルール基準に適用するリソースタイプのリストです。
          # 設定可能な値: リソースタイプの配列（例: "AWS::S3::Bucket", "AWS::RDS::DBSnapshot"）
          # 注意: アナライザーは、これらのタイプのリソースに対してのみ検出結果を生成します
          # 参考: https://docs.aws.amazon.com/access-analyzer/latest/APIReference/API_InternalAccessAnalysisRuleCriteria.html
          resource_types = [
            "AWS::S3::Bucket",
            "AWS::RDS::DBSnapshot",
            "AWS::DynamoDB::Table",
          ]
        }
      }
    }

    #-----------------------------------------------------------
    # 未使用アクセス設定 (unused_access)
    #-----------------------------------------------------------
    # AWS組織またはアカウントの未使用アクセスアナライザーの設定を指定します。
    # 注意: typeが "ACCOUNT_UNUSED_ACCESS" または "ORGANIZATION_UNUSED_ACCESS" の場合に使用
    # unused_access {
    #   # unused_access_age (Optional)
    #   # 設定内容: 未使用アクセスの検出結果を生成するための、指定されたアクセス経過日数です。
    #   # 設定可能な値: 正の整数（日数）
    #   # 省略時: デフォルト値が適用されます
    #   unused_access_age = 180
    #
    #   # analysis_rule (Optional)
    #   # 設定内容: アナライザーの分析ルールに関する情報です。
    #   #          分析ルールは、定義した基準に基づいてどのエンティティが検出結果を生成するかを決定します。
    #   analysis_rule {
    #     # exclusion (Optional)
    #     # 設定内容: 分析から除外する基準を含むアナライザーのルールリストです。
    #     #          ルール基準を満たすエンティティは検出結果を生成しません。
    #     # 注意: 複数のexclusionブロックを指定できます
    #     exclusion {
    #       # account_ids (Optional)
    #       # 設定内容: 分析ルール基準に適用するAWSアカウントIDのリストです。
    #       # 設定可能な値: AWSアカウントIDの配列
    #       # 注意: アカウントには組織アナライザー所有者アカウントを含めることはできません。
    #       #       アカウントIDは、組織レベルのアナライザーの分析ルール基準にのみ適用できます。
    #       account_ids = [
    #         "123456789012",
    #         "234567890123",
    #       ]
    #     }
    #
    #     exclusion {
    #       # resource_tags (Optional)
    #       # 設定内容: 分析から除外するリソースタグのキーと値のペアのリストです。
    #       # 設定可能な値: タグのマップのリスト
    #       resource_tags = [
    #         { key1 = "value1" },
    #         { key2 = "value2" },
    #       ]
    #     }
    #   }
    # }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: アナライザーのAmazon Resource Name (ARN)
#
# - id: アナライザーの名前
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
