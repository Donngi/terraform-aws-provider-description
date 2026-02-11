#---------------------------------------------------------------
# AWS Inspector Classic Assessment Target
#---------------------------------------------------------------
#
# AWS Inspector Classicの評価ターゲット(Assessment Target)をプロビジョニングするリソースです。
# 評価ターゲットは、セキュリティ評価の対象となるEC2インスタンスのコレクションを定義します。
# リソースグループ(タグベース)を使用してインスタンスを指定するか、リージョン内の
# すべてのEC2インスタンスを対象とすることができます。
#
# 重要な注意事項:
#   Amazon Inspector Classicは廃止予定のサービスで、2026年5月20日にサポートが終了します。
#   新規アカウントや過去6ヶ月間に評価を実施していないアカウントでは利用できません。
#   新しいワークロードには、Amazon Inspector v2の使用を推奨します。
#
# AWS公式ドキュメント:
#   - Inspector Classic評価ターゲット: https://docs.aws.amazon.com/inspector/v1/userguide/inspector_applications.html
#   - Inspector ClassicのARN構造: https://docs.aws.amazon.com/inspector/v1/userguide/inspector-arns-resources.html
#   - Inspector Classicサポート終了通知: https://docs.aws.amazon.com/inspector/latest/user/classic-end-of-support.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/inspector_assessment_target
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_inspector_assessment_target" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: 評価ターゲットの名前を指定します。
  # 設定可能な値: 1文字以上の文字列
  # 注意: わかりやすく、目的を表す名前を設定してください。
  #       評価ターゲットはアカウントとリージョンごとに最大50個まで作成可能です。
  # 例:
  #   - "production-web-servers"
  #   - "qa-environment-assessment"
  #   - "security-compliance-target"
  name = "example-assessment-target"

  #-------------------------------------------------------------
  # リソースグループ設定
  #-------------------------------------------------------------

  # resource_group_arn (Optional)
  # 設定内容: 評価対象のEC2インスタンスを特定するためのリソースグループのARNを指定します。
  # 設定可能な値: aws_inspector_resource_groupリソースのARN
  # 省略時: 現在のAWSアカウントとリージョン内のすべてのEC2インスタンスが対象となります。
  # 関連機能: リソースグループとタグベースの選択
  #   リソースグループは、EC2インスタンスにアタッチされたタグのキーと値のペアの
  #   コレクションとして定義されます。評価ターゲットはこれらのタグに基づいて
  #   評価対象のインスタンスを自動的に選択します。
  #   - タグの変更は動的に反映され、評価ターゲットの対象インスタンスも自動更新されます
  #   - インスタンスには事前にInspector Agentのインストールが必要です
  #   - https://docs.aws.amazon.com/inspector/v1/userguide/inspector_applications.html
  # 例:
  #   resource_group_arn = aws_inspector_resource_group.example.arn
  #   resource_group_arn = "arn:aws:inspector:us-east-1:123456789012:resourcegroup/0-abc123"
  resource_group_arn = aws_inspector_resource_group.example.arn

  # 例: リソースグループを使用しない場合（全インスタンスを対象）
  # resource_group_arn = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: Amazon Inspector Classicはリージョナルサービスです。
  #       評価ターゲットとEC2インスタンスは同じリージョンに存在する必要があります。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 例:
  #   region = "us-east-1"
  #   region = "eu-west-1"
  #   region = "ap-northeast-1"
  # region = null
}

#---------------------------------------------------------------
# 関連リソース例: リソースグループの定義
#---------------------------------------------------------------
# 評価ターゲットで使用するリソースグループの例です。
# リソースグループは、タグに基づいてEC2インスタンスを選択します。

resource "aws_inspector_resource_group" "example" {
  tags = {
    Name        = "Inspector-Target"
    Environment = "Production"
    Application = "WebApp"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: 評価ターゲットのAmazon Resource Name (ARN)
#        形式: arn:aws:inspector:region:account-id:target/ID
#        例: "arn:aws:inspector:us-east-1:123456789012:target/0-abc123"
#
# - id: リソース識別子（ARNと同じ値）
#
# 使用例:
#   output "assessment_target_arn" {
#     value = aws_inspector_assessment_target.example.arn
#   }
#---------------------------------------------------------------

#---------------------------------------------------------------
# 補足情報
#---------------------------------------------------------------
#
# 1. Inspector Classic のワークフロー:
#    a. リソースグループを作成（タグベースでEC2インスタンスを選択）
#    b. 評価ターゲットを作成（このリソース）
#    c. 評価テンプレートを作成（aws_inspector_assessment_template）
#    d. 評価を実行して脆弱性やベストプラクティス違反を検出
#
# 2. サービス連携ロール:
#    評価ターゲットの作成時に、必要に応じてAWSが自動的に
#    サービス連携ロール（AWSServiceRoleForAmazonInspector）を作成および登録します。
#    このロールにより、InspectorがEC2インスタンスにアクセスして評価を実行できます。
#
# 3. 評価ターゲットの制限:
#    - アカウントあたり最大50個の評価ターゲット
#    - 同時に実行可能なエージェント数は最大500個
#
# 4. 削除の影響:
#    評価ターゲットを削除すると、関連するすべての評価テンプレート、評価実行、
#    検出結果、レポートも削除されます。本番環境では注意が必要です。
#
# 5. Inspector v2 への移行:
#    Amazon Inspector v2は、より包括的で自動化されたセキュリティ評価を提供します。
#    - エージェント不要（AWS Systems Managerを使用）
#    - 継続的なスキャン
#    - コンテナイメージのスキャン対応
#    - より広範な脆弱性データベース
#    Inspector Classicは2026年5月20日にサポートが終了するため、
#    新しいワークロードではInspector v2の使用を推奨します。
#
# 6. タグベースのターゲット選択:
#    リソースグループのタグに一致するすべてのEC2インスタンスが自動的に
#    評価対象に含まれます。インスタンスのタグを変更すると、評価ターゲットの
#    対象インスタンスも自動的に更新されます。
#
# 7. Inspector Agentの要件:
#    - 評価対象のEC2インスタンスにはInspector Agentのインストールが必要
#    - インスタンスには適切なIAMロールが必要（Inspector通信用）
#    - ネットワークアクセスがInspectorエンドポイントとの通信を許可する必要あり
#
# 8. コスト管理:
#    - Inspector Classicはエージェント評価ごとに課金されます
#    - リソースグループ内のインスタンス数を監視してください
#    - タグを使用して評価に含まれるインスタンスを制御できます
#
# 9. セキュリティコンプライアンス:
#    - 評価ターゲットを使用して定期的なセキュリティ評価を実施
#    - AWS Security Hubと統合して検出結果を一元管理
#    - 評価テンプレートを使用して自動評価スケジュールを設定
#
#---------------------------------------------------------------
