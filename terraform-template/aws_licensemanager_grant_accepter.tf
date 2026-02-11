################################################################################
# AWS License Manager Grant Accepter
################################################################################

# リソース概要:
# AWS License Manager Grant Accepter は、他の AWS アカウントから配布されたライセンス
# のグラントを受け入れるためのリソースです。グラントは、ライセンス管理者が
# 他のアカウントに対してソフトウェアライセンスの使用権（エンタイトルメント）を
# 配布する仕組みです。
#
# 主な用途:
# - 組織内の他のアカウントから配布されたライセンスの受け入れ
# - AWS Marketplace または AWS Data Exchange からのライセンスグラントの受理
# - クロスアカウントでのライセンス管理の実現
#
# 重要な注意点:
# - グラントを受け入れた後は、別途アクティベーション（有効化）が必要です
# - 同じ製品の複数のライセンスを同時にアクティブにすることはできません
# - 組織の管理アカウントからのグラントは自動受け入れを設定可能です
# - グラントの状態は PENDING_ACCEPT → DISABLED (受け入れ済み) → ACTIVE (有効化済み) と遷移します
#
# 参考ドキュメント:
# - Grant acceptance: https://docs.aws.amazon.com/license-manager/latest/userguide/grant-acceptance.html
# - AcceptGrant API: https://docs.aws.amazon.com/license-manager/latest/APIReference/API_AcceptGrant.html
# - Granted licenses: https://docs.aws.amazon.com/license-manager/latest/userguide/granted-licenses.html

resource "aws_licensemanager_grant_accepter" "example" {
  ################################################################################
  # 必須パラメータ
  ################################################################################

  # grant_arn - (必須) 受け入れるグラントの Amazon Resource Name (ARN)
  #
  # グラントは、ライセンス管理者が他のアカウントに対してライセンスの使用権を
  # 配布するための仕組みです。このARNは、グラントの作成者から提供されます。
  #
  # ARN形式: arn:aws:license-manager::123456789012:grant:g-1cf9fba4ba2f42dcab11c686c4b4d329
  #
  # 注意事項:
  # - このARNは、グラントの送信者から提供される必要があります
  # - ARNの最大長は2048文字です
  # - グラントは、受け入れる前にステータスが "PENDING_ACCEPT" である必要があります
  # - 受け入れ後、グラントのステータスは "DISABLED" に変わります
  # - グラントをアクティブにするには、別途 CreateGrantVersion API を使用する必要があります
  #
  # 使用例:
  # - 組織内の管理アカウントから配布されたライセンスグラント
  # - AWS Marketplace の Private Offer として提供されたライセンス
  # - ソフトウェアベンダーから直接配布されたライセンス
  #
  # 関連する AWS CLI コマンド:
  # - aws license-manager list-received-grants
  # - aws license-manager accept-grant --grant-arn <value>
  #
  # Type: string (required)
  grant_arn = "arn:aws:license-manager::123456789012:grant:g-1cf9fba4ba2f42dcab11c686c4b4d329"

  ################################################################################
  # オプションパラメータ
  ################################################################################

  # region - (オプション) リソースを管理するリージョン
  #
  # このパラメータを指定すると、特定のリージョンでグラントを受け入れることができます。
  # 指定しない場合は、プロバイダー設定のリージョンが使用されます。
  #
  # 注意事項:
  # - グラントのホームリージョンと一致する必要があります
  # - クロスリージョンでのライセンス管理を行う場合、適切なリージョン設定が重要です
  # - グラントのホームリージョンは、グラント作成時に決定されます
  #
  # 使用例:
  # - マルチリージョン展開におけるライセンス管理
  # - 特定リージョンでのみ使用可能なライセンスの受け入れ
  #
  # Type: string (optional, computed)
  # region = "us-east-1"

  ################################################################################
  # Computed (読み取り専用) 属性
  ################################################################################

  # 以下の属性は Terraform によって自動的に計算され、読み取り専用です。
  # これらの値は、リソース作成後に参照可能になります。

  # id - グラントARN（grant_arn と同じ値）
  # グラントの一意識別子として使用されます。

  # allowed_operations - グラントで許可されている操作のセット
  #
  # このグラントで許可されているライセンス操作のリストです。
  # 一般的な操作には以下が含まれます:
  # - CreateGrant: サブグラントの作成
  # - CheckoutLicense: ライセンスのチェックアウト
  # - CheckoutBorrowLicense: 一時的なライセンスの借用
  # - CheckInLicense: ライセンスのチェックイン
  # - ExtendConsumptionLicense: ライセンス消費の延長
  # - ListPurchasedLicenses: 購入済みライセンスのリスト表示
  #
  # 例: ["CheckoutLicense", "CheckInLicense", "ExtendConsumptionLicense"]
  # Type: set(string) (computed)

  # license_arn - グラントに関連付けられたライセンスの ARN
  #
  # このグラントが参照する元のライセンスの ARN です。
  # ライセンスには、ソフトウェアの使用条件、数量、有効期限などの
  # 詳細情報が含まれています。
  #
  # ARN形式: arn:aws:license-manager::123456789012:license:l-1234567890abcdef0
  # Type: string (computed)

  # name - グラントの名前
  #
  # グラント作成時に指定された名前です。
  # グラントを識別しやすくするための人間が読める名前です。
  #
  # Type: string (computed)

  # principal - グラントの受取人（grantee）の ARN
  #
  # このグラントを受け取る AWS アカウント、組織、または組織単位（OU）の ARN です。
  #
  # 可能な形式:
  # - AWS アカウント: arn:aws:iam::123456789012:root
  # - 組織: arn:aws:organizations::123456789012:organization/o-123456789
  # - 組織単位: arn:aws:organizations::123456789012:ou/o-123456789/ou-1234-12345678
  #
  # Type: string (computed)

  # home_region - グラントのホームリージョン
  #
  # グラントが作成された元のリージョンです。
  # クロスリージョンレプリケーションを使用する場合、このリージョンが
  # グラントのマスターレコードが保存されている場所を示します。
  #
  # 例: "us-east-1", "eu-west-1"
  # Type: string (computed)

  # parent_arn - 親 ARN
  #
  # このグラントが派生元となった親グラントまたはライセンスの ARN です。
  # グラント階層において、このグラントの上位に位置するリソースを示します。
  #
  # Type: string (computed)

  # status - グラントの現在のステータス
  #
  # グラントのライフサイクル状態を示します。
  #
  # 可能な値:
  # - PENDING_WORKFLOW: ワークフロー処理中
  # - PENDING_ACCEPT: 受け入れ待ち（このリソースで受け入れ可能）
  # - REJECTED: 拒否済み
  # - ACTIVE: アクティブ（使用可能）
  # - DISABLED: 受け入れ済みだが無効（アクティベーション待ち）
  # - FAILED_WORKFLOW: ワークフロー失敗
  # - DELETED: 削除済み
  # - PENDING_DELETE: 削除処理中
  # - WORKFLOW_COMPLETED: ワークフロー完了
  #
  # このリソースで受け入れた直後は通常 "DISABLED" になり、
  # 別途アクティベーションが必要です。
  #
  # Type: string (computed)

  # version - グラントのバージョン
  #
  # グラントのバージョン文字列です。グラントが更新されるたびに
  # バージョンが変更されます。
  #
  # Type: string (computed)
}

################################################################################
# 出力例
################################################################################

# グラントの受け入れ後に参照できる値の例
output "grant_accepter_id" {
  description = "受け入れたグラントの ID"
  value       = aws_licensemanager_grant_accepter.example.id
}

output "grant_status" {
  description = "グラントの現在のステータス"
  value       = aws_licensemanager_grant_accepter.example.status
}

output "grant_license_arn" {
  description = "グラントに関連付けられたライセンスの ARN"
  value       = aws_licensemanager_grant_accepter.example.license_arn
}

output "grant_allowed_operations" {
  description = "グラントで許可されている操作"
  value       = aws_licensemanager_grant_accepter.example.allowed_operations
}

output "grant_home_region" {
  description = "グラントのホームリージョン"
  value       = aws_licensemanager_grant_accepter.example.home_region
}

################################################################################
# 使用例: マルチアカウント環境でのライセンス管理
################################################################################

# 例1: 組織内の別アカウントから配布されたグラントの受け入れ
resource "aws_licensemanager_grant_accepter" "org_grant" {
  grant_arn = "arn:aws:license-manager::111111111111:grant:g-abc123def456"
}

# 例2: 特定リージョンでグラントを受け入れる
resource "aws_licensemanager_grant_accepter" "regional_grant" {
  grant_arn = "arn:aws:license-manager::222222222222:grant:g-xyz789ghi012"
  region    = "eu-west-1"
}

################################################################################
# ベストプラクティスと注意事項
################################################################################

# 1. グラント受け入れのワークフロー:
#    a. list-received-grants コマンドで受信したグラントを確認
#    b. aws_licensemanager_grant_accepter リソースでグラントを受け入れ
#    c. status が "DISABLED" になったことを確認
#    d. CreateGrantVersion API でグラントをアクティベート（Terraform外）
#    e. status が "ACTIVE" になったことを確認

# 2. 自動受け入れの設定:
#    組織の管理アカウントからのグラントを自動的に受け入れるには、
#    License Manager コンソールの設定ページで組織アカウントをリンクします。

# 3. 競合するライセンスの管理:
#    同じ製品の複数のライセンスをアクティブにすることはできません。
#    新しいグラントをアクティブにする前に、既存のアクティブなグラントを
#    無効化する必要があります。

# 4. クロスリージョン管理:
#    グラントのホームリージョンと、リソースを管理するリージョンを
#    適切に設定することで、マルチリージョン展開が可能です。

# 5. IAM 権限:
#    このリソースを使用するには、以下の IAM 権限が必要です:
#    - license-manager:AcceptGrant
#    - license-manager:GetGrant
#    - license-manager:ListReceivedGrants

# 6. エラーハンドリング:
#    - AccessDeniedException: IAM権限を確認
#    - InvalidParameterValueException: grant_arn の形式を確認
#    - RateLimitExceededException: API呼び出しレートを調整
#    - ResourceLimitExceededException: アカウントのリソース制限を確認

# 7. ライフサイクル管理:
#    グラントを削除する場合、依存するリソース（EC2インスタンスなど）が
#    そのライセンスを使用していないことを確認してください。

# 8. コスト管理:
#    License Manager 自体は無料ですが、グラントで配布されるライセンスには
#    関連するコストが発生する可能性があります。

# 9. コンプライアンス:
#    グラントを受け入れることで、ライセンス条項に同意することになります。
#    組織のコンプライアンス要件を確認してください。

# 10. モニタリング:
#     CloudWatch と AWS Config を使用して、グラントの状態変更を
#     監視することをお勧めします。
