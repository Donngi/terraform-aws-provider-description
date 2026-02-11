#---------------------------------------------------------------
# AWS IAM Access Analyzer Archive Rule
#---------------------------------------------------------------
#
# AWS IAM Access Analyzerのアーカイブルールをプロビジョニングするリソースです。
# アーカイブルールは、定義された条件に基づいて新しい検出結果を自動的に
# アーカイブします。これにより、既知の想定されるアクセスパターンを
# フィルタリングし、重要な検出結果に集中することができます。
#
# AWS公式ドキュメント:
#   - Access Analyzer概要: https://docs.aws.amazon.com/IAM/latest/UserGuide/what-is-access-analyzer.html
#   - アーカイブルール: https://docs.aws.amazon.com/IAM/latest/UserGuide/access-analyzer-archive-rules.html
#   - フィルターキーリファレンス: https://docs.aws.amazon.com/IAM/latest/UserGuide/access-analyzer-reference-filter-keys.html
#   - CreateArchiveRule API: https://docs.aws.amazon.com/access-analyzer/latest/APIReference/API_CreateArchiveRule.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/accessanalyzer_archive_rule
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_accessanalyzer_archive_rule" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # analyzer_name (Required)
  # 設定内容: このアーカイブルールを適用するアナライザーの名前を指定します。
  # 設定可能な値: 既存のAccess Analyzerアナライザーの名前
  # 注意: この値を変更すると新しいリソースが作成されます（Forces new resource）
  # 参考: https://docs.aws.amazon.com/IAM/latest/UserGuide/access-analyzer-getting-started.html
  analyzer_name = "example-analyzer"

  # rule_name (Required)
  # 設定内容: アーカイブルールの名前を指定します。
  # 設定可能な値: 1-255文字の文字列。パターン: [A-Za-z][A-Za-z0-9_.-]*
  # 注意: この値を変更すると新しいリソースが作成されます（Forces new resource）
  rule_name = "archive-known-access"

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
  # フィルター設定
  #-------------------------------------------------------------

  # filter (Required, Set)
  # 設定内容: アーカイブルールの条件を定義するフィルターを指定します。
  # 最小要件: 最低1つのfilterブロックが必要
  # 注意: 複数のfilterブロックを指定した場合、すべての条件に一致する検出結果がアーカイブされます（AND条件）
  # 参考: https://docs.aws.amazon.com/IAM/latest/UserGuide/access-analyzer-reference-filter-keys.html

  filter {
    # criteria (Required)
    # 設定内容: フィルター条件として使用するプロパティキーを指定します。
    # 設定可能な値:
    #   - resource: リソースのARN
    #   - resourceType: リソースタイプ（例: AWS::S3::Bucket, AWS::IAM::Role）
    #   - resourceOwnerAccount: リソース所有者のAWSアカウントID
    #   - isPublic: パブリックアクセスの有無（Boolean）
    #   - findingType: 検出結果のタイプ（ExternalAccess, UnusedIAMRole等）
    #   - error: エラー情報
    #   - principal.AWS: AWSアカウントまたはプリンシパルARN
    #   - principal.Federated: フェデレーテッドユーザーのARN
    #   - condition.aws:PrincipalArn: プリンシパルARN条件
    #   - condition.aws:PrincipalOrgID: 組織ID条件
    #   - condition.aws:SourceIp: ソースIP条件
    #   - condition.aws:UserId: ユーザーID条件
    #   - その他多数の条件キー
    # 参考: https://docs.aws.amazon.com/IAM/latest/UserGuide/access-analyzer-reference-filter-keys.html
    criteria = "resourceType"

    # eq (Optional, Computed)
    # 設定内容: 指定した値と等しい場合にマッチする条件を設定します（Equals比較演算子）。
    # 設定可能な値: 文字列のリスト（1-20項目）
    # 省略時: この比較演算子は適用されません
    # 注意: contains, eq, exists, neqのいずれか1つ以上を指定する必要があります
    # 参考: https://docs.aws.amazon.com/access-analyzer/latest/APIReference/API_Criterion.html
    eq = ["AWS::S3::Bucket"]

    # contains (Optional, Computed)
    # 設定内容: 指定した値を含む場合にマッチする条件を設定します（Contains比較演算子）。
    # 設定可能な値: 文字列のリスト（1-20項目）
    # 省略時: この比較演算子は適用されません
    # 用途: 部分一致検索が必要な場合に使用
    # 参考: https://docs.aws.amazon.com/access-analyzer/latest/APIReference/API_Criterion.html
    contains = null

    # exists (Optional, Computed)
    # 設定内容: 指定したプロパティが存在するかどうかをチェックする条件を設定します（Exists比較演算子）。
    # 設定可能な値:
    #   - "true": プロパティが存在する場合にマッチ
    #   - "false": プロパティが存在しない場合にマッチ
    # 省略時: この比較演算子は適用されません
    # 用途: errorフィールドの有無などをチェックする場合に使用
    # 参考: https://docs.aws.amazon.com/access-analyzer/latest/APIReference/API_Criterion.html
    exists = null

    # neq (Optional, Computed)
    # 設定内容: 指定した値と等しくない、または存在しない場合にマッチする条件を設定します（Not Equals比較演算子）。
    # 設定可能な値: 文字列のリスト（1-20項目）
    # 省略時: この比較演算子は適用されません
    # 注意: 値が存在しない場合もマッチします
    # 参考: https://docs.aws.amazon.com/access-analyzer/latest/APIReference/API_Criterion.html
    neq = null
  }

  # 複数のフィルター条件を追加する例
  filter {
    criteria = "isPublic"
    eq       = ["false"]
  }

  filter {
    criteria = "principal.AWS"
    eq       = ["arn:aws:iam::123456789012:root"]
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースID。形式: analyzer_name/rule_name
#
#---------------------------------------------------------------
