#---------------------------------------------------------------
# AWS DynamoDB Resource Policy
#---------------------------------------------------------------
#
# Amazon DynamoDB テーブルまたはストリームにリソースベースポリシーを
# アタッチするためのリソースです。
# リソースベースポリシーにより、どの IAM プリンシパルが各リソースに
# アクセスでき、実行可能なアクションを指定することができます。
# クロスアカウントアクセスの制御を簡素化し、IAM Access Analyzer や
# Block Public Access (BPA) 機能との統合をサポートします。
#
# NOTE: ポリシーの最大サイズは 20 KB です（空白文字も含む）。
#
# NOTE: ポリシーの更新が成功した後、15秒間は同じリソースへの
#       後続のポリシー更新がブロックされます。
#
# NOTE: グローバルテーブル (version 2017.11.29 Legacy) のレプリカでは
#       リソースベースポリシーはサポートされていません。
#
# NOTE: AWS マネージドキーで暗号化されたテーブルでは、
#       クロスアカウントアクセスはサポートされていません。
#
# AWS公式ドキュメント:
#   - リソースベースポリシー概要: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/access-control-resource-based.html
#   - ポリシー例: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/rbac-examples.html
#   - 考慮事項: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/rbac-considerations.html
#   - ベストプラクティス: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/rbac-best-practices.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_resource_policy
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_dynamodb_resource_policy" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # resource_arn (Required, Forces new resource)
  # 設定内容: ポリシーをアタッチする DynamoDB リソースの ARN を指定します。
  # 設定可能な値:
  #   - テーブル ARN: arn:aws:dynamodb:region:account-id:table/table-name
  #   - ストリーム ARN: arn:aws:dynamodb:region:account-id:table/table-name/stream/timestamp
  #   - インデックス ARN: arn:aws:dynamodb:region:account-id:table/table-name/index/index-name
  # 注意:
  #   - インデックスの権限はベーステーブルのポリシーで制御できます。
  #   - テーブルとインデックスに同じ権限レベルを指定する場合、
  #     ポリシードキュメントの Resource フィールドに両方の ARN を指定できます。
  #   - 異なる権限を指定する場合、複数の Statement を定義できます。
  resource_arn = aws_dynamodb_table.example.arn

  # policy (Required)
  # 設定内容: AWS リソースベースポリシードキュメントを JSON 形式で指定します。
  # 設定可能な値: JSON 形式のポリシードキュメント（最大 20 KB）
  # 注意:
  #   - DynamoDB は空白文字もサイズ制限にカウントします。
  #   - ポリシーアタッチ時の考慮事項:
  #     https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/rbac-considerations.html
  # 推奨: data.aws_iam_policy_document を使用してポリシーを定義してください。
  policy = data.aws_iam_policy_document.example.json

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # confirm_remove_self_resource_access (Optional)
  # 設定内容: リソースのポリシーを変更する自分の権限を削除することを確認します。
  # 設定可能な値:
  #   - true: 将来このリソースのポリシーを変更する権限を削除することを確認
  #   - false: 確認しない（デフォルト）
  # 注意:
  #   - このパラメータを true に設定すると、自分自身のアクセス権限を
  #     失う可能性があるため、慎重に使用してください。
  #   - 削除後は、他の管理者がポリシーを変更する必要があります。
  # confirm_remove_self_resource_access = false

  # region (Optional)
  # 設定内容: このリソースが管理されるリージョンを指定します。
  # 設定可能な値: AWS リージョンコード（例: us-east-1, ap-northeast-1）
  # デフォルト: プロバイダー設定で指定されたリージョン
  # 注意:
  #   - グローバルテーブルの場合、レプリカごとに異なるリージョンで
  #     ポリシーを管理できますが、CloudFormation での制約があります。
  # region = "us-east-1"
}

#---------------------------------------------------------------
# 補足: ポリシードキュメント例
#---------------------------------------------------------------

# 例1: 基本的なテーブルアクセス許可
data "aws_iam_policy_document" "example" {
  statement {
    sid    = "AllowReadAccess"
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::111122223333:user/username",
        "arn:aws:iam::111122223333:role/role-name"
      ]
    }

    actions = [
      "dynamodb:GetItem",
      "dynamodb:BatchGetItem",
      "dynamodb:Query",
      "dynamodb:Scan"
    ]

    resources = [
      aws_dynamodb_table.example.arn
    ]
  }
}

# 例2: クロスアカウントアクセス（特定の項目と属性のみ）
# data "aws_iam_policy_document" "cross_account" {
#   statement {
#     sid    = "CrossAccountTablePolicy"
#     effect = "Allow"
#
#     principals {
#       type        = "AWS"
#       identifiers = ["arn:aws:iam::111111111111:user/John"]
#     }
#
#     actions = [
#       "dynamodb:GetItem"
#     ]
#
#     resources = [
#       aws_dynamodb_table.example.arn
#     ]
#
#     # 特定のパーティションキーのみアクセス許可
#     condition {
#       test     = "ForAllValues:StringEquals"
#       variable = "dynamodb:LeadingKeys"
#       values   = ["specific-key-value"]
#     }
#
#     # 特定の属性のみ取得許可
#     condition {
#       test     = "ForAllValues:StringEquals"
#       variable = "dynamodb:Attributes"
#       values   = ["Attribute1", "Attribute2"]
#     }
#
#     # SPECIFIC_ATTRIBUTES を指定して属性を制限
#     condition {
#       test     = "StringEquals"
#       variable = "dynamodb:Select"
#       values   = ["SPECIFIC_ATTRIBUTES"]
#     }
#   }
# }

# 例3: IP アドレス制限付きアクセス
# data "aws_iam_policy_document" "ip_restricted" {
#   statement {
#     sid    = "AllowFromSpecificIP"
#     effect = "Allow"
#
#     principals {
#       type        = "AWS"
#       identifiers = ["arn:aws:iam::111122223333:user/username"]
#     }
#
#     actions = [
#       "dynamodb:*"
#     ]
#
#     resources = [
#       aws_dynamodb_table.example.arn
#     ]
#
#     # 特定の IP アドレスからのアクセスのみ許可
#     condition {
#       test     = "IpAddress"
#       variable = "aws:SourceIp"
#       values = [
#         "54.240.143.0/24",
#         "2001:DB8:1234:5678::/64"
#       ]
#     }
#   }
# }

# 例4: VPC エンドポイント経由のアクセスのみ許可
# data "aws_iam_policy_document" "vpce_only" {
#   statement {
#     sid       = "DenyAccessExceptFromVPCE"
#     effect    = "Deny"
#     principals {
#       type        = "*"
#       identifiers = ["*"]
#     }
#
#     actions = [
#       "dynamodb:*"
#     ]
#
#     resources = [
#       aws_dynamodb_table.example.arn
#     ]
#
#     # 特定の VPC エンドポイント以外からのアクセスを拒否
#     condition {
#       test     = "StringNotEquals"
#       variable = "aws:sourceVpce"
#       values   = ["vpce-1a2b3c4d"]
#     }
#   }
# }

# 例5: ストリームへのアクセス許可
# data "aws_iam_policy_document" "stream_access" {
#   statement {
#     sid    = "AllowStreamAccess"
#     effect = "Allow"
#
#     principals {
#       type = "AWS"
#       identifiers = [
#         "arn:aws:iam::111122223333:user/username"
#       ]
#     }
#
#     actions = [
#       "dynamodb:DescribeStream",
#       "dynamodb:GetRecords",
#       "dynamodb:GetShardIterator"
#     ]
#
#     resources = [
#       "${aws_dynamodb_table.example.arn}/stream/*"
#     ]
#   }
# }

# 例6: IAM ロールによる全アクセス許可
# data "aws_iam_policy_document" "role_access" {
#   statement {
#     sid    = "AllowRoleFullAccess"
#     effect = "Allow"
#
#     principals {
#       type        = "AWS"
#       identifiers = ["arn:aws:iam::111122223333:role/role-name"]
#     }
#
#     actions = [
#       "dynamodb:*"
#     ]
#
#     resources = [
#       aws_dynamodb_table.example.arn,
#       "${aws_dynamodb_table.example.arn}/*"  # すべてのインデックスを含む
#     ]
#   }
# }

#---------------------------------------------------------------
# 出力例
#---------------------------------------------------------------

# revision_id (Attribute)
# 説明: ポリシーのリビジョン ID を表す一意の文字列。
# 用途: リビジョン ID を比較する場合は、必ず文字列比較ロジックを使用してください。
# output "policy_revision_id" {
#   description = "DynamoDB リソースポリシーのリビジョン ID"
#   value       = aws_dynamodb_resource_policy.example.revision_id
# }

#---------------------------------------------------------------
# 使用上の注意とベストプラクティス
#---------------------------------------------------------------
#
# 1. ポリシーサイズ制限
#    - ポリシードキュメントの最大サイズは 20 KB です。
#    - 空白文字もカウントされるため、不要な空白は削除してください。
#
# 2. 更新間隔
#    - ポリシー更新成功後、15秒間は同じリソースへの
#      後続のポリシー更新がブロックされます。
#
# 3. グローバルテーブル
#    - version 2017.11.29 (Legacy) のレプリカでは
#      リソースベースポリシーはサポートされていません。
#    - DynamoDB サービスリンクロール (SLR) のアクションを拒否すると、
#      レプリカの追加/削除が失敗します。
#
# 4. クロスアカウントアクセス
#    - AWS マネージドキーで暗号化されたテーブルでは
#      クロスアカウントアクセスはサポートされていません。
#    - クロスアカウントアクセスには、リソースベースポリシーと
#      ID ベースポリシーの両方が必要です。
#
# 5. CloudFormation
#    - リソースベースポリシーはドリフト検出をサポートしていません。
#    - テンプレート外での変更は、テンプレート内にポリシーが
#      追加されない限り上書きされません。
#
# 6. ストリームポリシー
#    - 現在、既存のストリームにのみポリシーをアタッチできます。
#    - ストリーム作成時にはポリシーをアタッチできません。
#
# 7. セキュリティベストプラクティス
#    - 最小権限の原則に従ってください。
#    - 可能な限り具体的な条件を使用してください。
#    - IAM Access Analyzer を使用してクロスアカウントアクセスを監視してください。
#    - Block Public Access (BPA) を有効にしてパブリックアクセスを防止してください。
#
# 8. サポートされる API オペレーション
#    - すべての DynamoDB API がリソースベースポリシーでサポート
#      されているわけではありません。
#    - 詳細: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/rbac-iam-actions.html
#
# 9. 権限の削除
#    - confirm_remove_self_resource_access を true に設定すると、
#      自分自身のポリシー変更権限を削除する可能性があります。
#    - 慎重に使用してください。
#
# 10. テスト
#     - ポリシーを本番環境に適用する前に、必ずテスト環境で
#       動作を確認してください。
#     - IAM Policy Simulator を使用してポリシーをテストできます。
#
#---------------------------------------------------------------
