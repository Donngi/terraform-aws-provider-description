#---------------------------------------------------------------
# Security Hub Standards Control Association
#---------------------------------------------------------------
#
# Security Hubのセキュリティ標準内で個別のコントロールの有効化/無効化状態を管理する
# リソース。このリソースはTerraformが新規作成するのではなく、既存のコントロール関連付け
# を「採用」して管理対象とする特殊な動作をします。削除時はTerraformの管理から外すのみで、
# AWS側のコントロール状態は変更されません。
#
# ユースケース:
#   - 特定の標準（CIS、NIST等）内で不要なコントロールを無効化
#   - コンプライアンス要件に応じたコントロールの選択的有効化
#   - 複数の標準で同一コントロールを個別に管理
#
# AWS公式ドキュメント:
#   - StandardsControlAssociationUpdate API: https://docs.aws.amazon.com/securityhub/1.0/APIReference/API_StandardsControlAssociationUpdate.html
#   - StandardsControlAssociationDetail API: https://docs.aws.amazon.com/securityhub/1.0/APIReference/API_StandardsControlAssociationDetail.html
#   - コントロールの有効化/無効化: https://docs.aws.amazon.com/securityhub/latest/userguide/controls-configure.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_standards_control_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_securityhub_standards_control_association" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # association_status - (必須) 標準内でのコントロールの有効化状態
  #
  # 指定可能な値:
  #   - ENABLED  : コントロールを有効化し、セキュリティチェックを実行
  #   - DISABLED : コントロールを無効化し、セキュリティチェックをスキップ
  #
  # 使用例:
  #   - 特定のコントロールが環境に適用不可の場合にDISABLEDを設定
  #   - コンプライアンス要件で必須のコントロールをENABLEDに設定
  #
  # 注意事項:
  #   - DISABLEDに設定する場合、updated_reasonパラメータの指定が必須
  #   - 状態変更は監査ログに記録されるため、適切な理由の記載が推奨される
  association_status = "ENABLED"

  # security_control_id - (必須) 有効化状態を更新するセキュリティコントロールの一意識別子
  #
  # フォーマット:
  #   - 標準に依存しない形式: "サービス名.番号" (例: IAM.1, EC2.2, S3.8)
  #   - AWS サービスと番号の組み合わせで構成される
  #
  # 使用例:
  #   - "IAM.1"     : ルートアカウントの使用に関するコントロール
  #   - "EC2.2"     : VPCのデフォルトセキュリティグループに関するコントロール
  #   - "S3.8"      : S3バケットのブロックパブリックアクセス設定に関するコントロール
  #   - "Lambda.1"  : Lambda関数のトレーシング設定に関するコントロール
  #
  # 確認方法:
  #   - Security Hubコンソールの「コントロール」セクションで利用可能なIDを確認
  #   - aws securityhub describe-standards-controls コマンドで一覧取得
  security_control_id = "IAM.1"

  # standards_arn - (必須) コントロールの有効化状態を更新する標準のARN
  #
  # フォーマット:
  #   arn:aws:securityhub:<region>::<account-id>:subscription/<標準識別子>
  #   または
  #   arn:aws:securityhub:::ruleset/<標準名>/<バージョン>
  #
  # 主な標準のARN例:
  #   - CIS AWS Foundations Benchmark v1.2.0:
  #     "arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.2.0"
  #   - CIS AWS Foundations Benchmark v1.4.0:
  #     "arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.4.0"
  #   - AWS Foundational Security Best Practices:
  #     "arn:aws:securityhub:<region>::<account-id>:subscription/aws-foundational-security-best-practices/v/1.0.0"
  #   - PCI DSS v3.2.1:
  #     "arn:aws:securityhub:<region>::<account-id>:subscription/pci-dss/v/3.2.1"
  #   - NIST SP 800-53 Rev. 5:
  #     "arn:aws:securityhub:<region>::<account-id>:subscription/nist-800-53/v/5.0.0"
  #
  # 注意事項:
  #   - 標準が有効化されている必要がある（aws_securityhub_standards_subscriptionで管理）
  #   - リージョン・アカウントIDはプロバイダー設定から自動的に解決される形式も利用可能
  #   - depends_onを使用して標準サブスクリプションリソースへの依存関係を明示することを推奨
  standards_arn = "arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.2.0"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # region - (オプション) このリソースを管理するAWSリージョン
  #
  # デフォルト動作:
  #   - 指定しない場合、プロバイダー設定のリージョンが使用される
  #
  # 使用例:
  #   - マルチリージョン環境で特定リージョンのコントロール関連付けを管理する場合
  #   - プロバイダーのデフォルトリージョンと異なるリージョンで管理する場合
  #
  # 注意事項:
  #   - 指定したリージョンでSecurity Hubが有効化されている必要がある
  #   - コントロールの利用可能性はリージョンによって異なる場合がある
  #
  # region = "us-east-1"

  # updated_reason - (オプション) 標準内でのコントロール有効化状態を更新する理由
  #
  # 必須条件:
  #   - association_status を "DISABLED" に設定する場合は必須
  #
  # 使用例:
  #   - "Not applicable to our environment"
  #   - "Covered by alternative security controls"
  #   - "Excepted by security policy for development accounts"
  #   - "Causes false positives in our infrastructure"
  #
  # ベストプラクティス:
  #   - 監査証跡として明確な理由を記載
  #   - 組織のセキュリティポリシー参照番号を含める
  #   - 期限付きの例外の場合は有効期限を記載
  #
  # 注意事項:
  #   - この情報はAWS CloudTrailログに記録される
  #   - コンプライアンス監査時の証跡として重要
  #   - 空文字列は指定不可（パターン: .*\S.* で非空白文字が必須）
  #
  # updated_reason = "Not needed for development environment"
}

#---------------------------------------------------------------
# Attributes Reference (参照専用属性)
#---------------------------------------------------------------
#
# このリソースは以下の属性をエクスポートします:
#
# - id
#     リソースの一意識別子。Terraform内部管理用。
#     形式: 自動生成される値
#     用途: インポート、状態管理、参照時の識別子として使用
