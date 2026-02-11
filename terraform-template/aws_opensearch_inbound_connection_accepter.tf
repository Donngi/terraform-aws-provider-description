# ================================================================================
# AWS OpenSearch Inbound Connection Accepter
# ================================================================================
# リソース概要:
# Amazon OpenSearch Service のクロスクラスタ検索接続の受信側承認を管理します。
# 送信元ドメインからの接続リクエストを受信側ドメインで承認するために使用します。
#
# 主な用途:
# - クロスアカウント/クロスリージョンでの OpenSearch ドメイン間接続の承認
# - 異なる AWS アカウント間での OpenSearch データアクセスの確立
# - クロスクラスタ検索を有効化するための接続受け入れ
#
# 公式ドキュメント:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearch_inbound_connection_accepter
# https://docs.aws.amazon.com/opensearch-service/latest/APIReference/API_AcceptInboundConnection.html
#
# 前提条件:
# - 送信元ドメインから aws_opensearch_outbound_connection が作成されていること
# - 両方のドメインで fine-grained access control が有効であること
# - 両方のドメインで node-to-node encryption が有効であること
# - 受信側ドメインのアクセスポリシーで es:ESCrossClusterGet 権限が設定されていること
#
# 制約事項:
# - 1つのドメインあたり最大20の受信接続と送信接続が可能
# - 送信元ドメインのバージョンは受信側ドメインと同じかそれ以上である必要がある
# - Elasticsearch ドメインは OpenSearch ドメインに接続できない
# - M3 または Burstable インスタンスはサポートされない
# ================================================================================

resource "aws_opensearch_inbound_connection_accepter" "example" {
  # ================================================================================
  # 必須パラメータ
  # ================================================================================

  # --------------------------------------------------------------------------------
  # connection_id - 接続ID
  # --------------------------------------------------------------------------------
  # 説明: 承認する OpenSearch クロスクラスタ接続の一意な識別子
  # 型: string (必須, Forces new resource)
  #
  # 取得方法:
  # - aws_opensearch_outbound_connection リソースの id 属性から取得
  # - 送信元アカウントで作成された接続リクエストの ID
  #
  # 形式:
  # - パターン: [a-z][a-z0-9\-]+
  # - 長さ: 10〜256文字
  #
  # 注意事項:
  # - この値を変更すると新しいリソースが作成されます (Forces new resource)
  # - 受信側アカウントで作成する場合、送信元の接続 ID が必要
  # - 接続 ID が無効な場合、ResourceNotFoundException が発生
  #
  # 例:
  # connection_id = aws_opensearch_outbound_connection.example.id
  # connection_id = "c-abc123def456ghi78"
  # --------------------------------------------------------------------------------
  connection_id = aws_opensearch_outbound_connection.example.id


  # ================================================================================
  # オプションパラメータ
  # ================================================================================

  # --------------------------------------------------------------------------------
  # region - リージョン
  # --------------------------------------------------------------------------------
  # 説明: このリソースが管理されるリージョンを指定
  # 型: string (オプション, Computed)
  # デフォルト: プロバイダー設定のリージョン
  #
  # 使用ケース:
  # - クロスリージョン接続の場合に明示的に指定
  # - 受信側ドメインが存在するリージョンを指定する必要がある
  # - マルチリージョン構成での管理を明確化
  #
  # 注意事項:
  # - 省略した場合、プロバイダーのデフォルトリージョンが使用される
  # - 受信側ドメインのリージョンと一致させる必要がある
  # - クロスアカウント接続では特に重要
  #
  # 例:
  # region = "us-west-2"
  # region = "ap-northeast-1"
  # --------------------------------------------------------------------------------
  # region = "us-west-2"


  # ================================================================================
  # Timeouts
  # ================================================================================
  # 説明: リソース作成・削除時のタイムアウト設定
  #
  # サポートされる操作:
  # - create: 接続承認の完了を待つ時間 (デフォルト: 5分)
  # - delete: 接続削除の完了を待つ時間 (デフォルト: 5分)
  #
  # 推奨設定:
  # - 通常は 5〜10分で十分
  # - 大規模ドメインや複雑な構成では長めに設定
  # - ネットワーク遅延が予想される場合は余裕を持たせる
  # ================================================================================
  timeouts {
    # create = "5m"  # 接続承認完了までの待機時間
    # delete = "5m"  # 接続削除完了までの待機時間
  }
}


# ================================================================================
# 出力属性 (Attributes)
# ================================================================================
# このリソースは以下の属性を出力します:
#
# id
# - 説明: 承認された接続の一意な識別子
# - 型: string
# - 用途: 他のリソースでの参照、データソースでの検索
# - 例: aws_opensearch_inbound_connection_accepter.example.id
#
# connection_status
# - 説明: 接続リクエストのステータス
# - 型: string
# - 可能な値:
#   * PENDING_ACCEPTANCE - 承認待ち
#   * APPROVED - 承認済み
#   * PROVISIONING - プロビジョニング中
#   * ACTIVE - アクティブ (使用可能)
#   * REJECTING - 拒否処理中
#   * REJECTED - 拒否済み
#   * DELETING - 削除中
#   * DELETED - 削除済み
# - 用途: 接続の現在の状態を確認、条件分岐
# - 例: aws_opensearch_inbound_connection_accepter.example.connection_status
# ================================================================================


# ================================================================================
# 使用例: 同一アカウント内でのクロスクラスタ接続
# ================================================================================
# data "aws_caller_identity" "current" {}
# data "aws_region" "current" {}
#
# # 送信元ドメイン
# resource "aws_opensearch_domain" "source" {
#   domain_name    = "source-domain"
#   engine_version = "OpenSearch_2.11"
#
#   cluster_config {
#     instance_type = "t3.small.search"
#   }
#
#   ebs_options {
#     ebs_enabled = true
#     volume_size = 10
#   }
#
#   node_to_node_encryption {
#     enabled = true
#   }
#
#   encrypt_at_rest {
#     enabled = true
#   }
#
#   advanced_security_options {
#     enabled                        = true
#     internal_user_database_enabled = true
#     master_user_options {
#       master_user_name     = "admin"
#       master_user_password = "YourStrongPassword123!"
#     }
#   }
# }
#
# # 受信側ドメイン
# resource "aws_opensearch_domain" "destination" {
#   domain_name    = "destination-domain"
#   engine_version = "OpenSearch_2.11"
#
#   cluster_config {
#     instance_type = "t3.small.search"
#   }
#
#   ebs_options {
#     ebs_enabled = true
#     volume_size = 10
#   }
#
#   node_to_node_encryption {
#     enabled = true
#   }
#
#   encrypt_at_rest {
#     enabled = true
#   }
#
#   advanced_security_options {
#     enabled                        = true
#     internal_user_database_enabled = true
#     master_user_options {
#       master_user_name     = "admin"
#       master_user_password = "YourStrongPassword123!"
#     }
#   }
#
#   # クロスクラスタ検索を許可するアクセスポリシー
#   access_policies = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = {
#           AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
#         }
#         Action   = "es:ESCrossClusterGet"
#         Resource = "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/destination-domain/*"
#       }
#     ]
#   })
# }
#
# # 送信側接続 (送信元ドメインから作成)
# resource "aws_opensearch_outbound_connection" "example" {
#   connection_alias = "source-to-destination"
#
#   local_domain_info {
#     owner_id    = data.aws_caller_identity.current.account_id
#     region      = data.aws_region.current.name
#     domain_name = aws_opensearch_domain.source.domain_name
#   }
#
#   remote_domain_info {
#     owner_id    = data.aws_caller_identity.current.account_id
#     region      = data.aws_region.current.name
#     domain_name = aws_opensearch_domain.destination.domain_name
#   }
# }
#
# # 受信側接続承認 (受信側ドメインで承認)
# resource "aws_opensearch_inbound_connection_accepter" "example" {
#   connection_id = aws_opensearch_outbound_connection.example.id
# }
# ================================================================================


# ================================================================================
# 使用例: クロスアカウント接続 (受信側アカウント)
# ================================================================================
# # 受信側アカウントでの設定
# #
# # 前提: 送信元アカウントで aws_opensearch_outbound_connection が既に作成済み
# #
# # ステップ:
# # 1. 送信元アカウントから接続 ID を取得
# # 2. 受信側アカウントで接続を承認
#
# provider "aws" {
#   alias  = "destination_account"
#   region = "us-west-2"
#   # 受信側アカウントの認証情報を設定
# }
#
# # 受信側ドメイン (別アカウント)
# resource "aws_opensearch_domain" "remote" {
#   provider       = aws.destination_account
#   domain_name    = "remote-domain"
#   engine_version = "OpenSearch_2.11"
#
#   cluster_config {
#     instance_type = "r6g.large.search"
#   }
#
#   ebs_options {
#     ebs_enabled = true
#     volume_size = 100
#   }
#
#   node_to_node_encryption {
#     enabled = true
#   }
#
#   encrypt_at_rest {
#     enabled = true
#   }
#
#   advanced_security_options {
#     enabled                        = true
#     internal_user_database_enabled = true
#     master_user_options {
#       master_user_name     = "admin"
#       master_user_password = "YourStrongPassword123!"
#     }
#   }
#
#   # 送信元アカウントからのアクセスを許可
#   access_policies = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = {
#           AWS = "arn:aws:iam::111111111111:root"  # 送信元アカウントID
#         }
#         Action   = "es:ESCrossClusterGet"
#         Resource = "arn:aws:es:us-west-2:222222222222:domain/remote-domain/*"
#       }
#     ]
#   })
# }
#
# # 受信側での接続承認
# resource "aws_opensearch_inbound_connection_accepter" "cross_account" {
#   provider      = aws.destination_account
#   connection_id = "c-xxxxxxxxxxxxx"  # 送信元アカウントから取得した接続ID
# }
# ================================================================================


# ================================================================================
# 使用例: 接続ステータスの出力と監視
# ================================================================================
# output "connection_id" {
#   description = "承認された接続の ID"
#   value       = aws_opensearch_inbound_connection_accepter.example.id
# }
#
# output "connection_status" {
#   description = "接続の現在のステータス"
#   value       = aws_opensearch_inbound_connection_accepter.example.connection_status
# }
#
# # 接続が ACTIVE になるまで待機する例
# resource "null_resource" "wait_for_active" {
#   depends_on = [aws_opensearch_inbound_connection_accepter.example]
#
#   provisioner "local-exec" {
#     command = <<-EOT
#       while true; do
#         STATUS=$(aws opensearch describe-inbound-connections \
#           --filters Name=connection-id,Values=${aws_opensearch_inbound_connection_accepter.example.id} \
#           --query 'Connections[0].ConnectionStatus.StatusCode' \
#           --output text)
#         if [ "$STATUS" = "ACTIVE" ]; then
#           echo "Connection is active"
#           break
#         fi
#         echo "Waiting for connection to become active (current: $STATUS)..."
#         sleep 30
#       done
#     EOT
#   }
# }
# ================================================================================


# ================================================================================
# トラブルシューティング
# ================================================================================
#
# 1. ResourceNotFoundException
#    原因: 指定された connection_id が存在しない
#    対処:
#    - 送信元の aws_opensearch_outbound_connection が正しく作成されているか確認
#    - connection_id の値が正しいか確認
#    - 受信側アカウント/リージョンが正しいか確認
#
# 2. DisabledOperationException
#    原因: ドメインで必要な機能が無効になっている
#    対処:
#    - fine-grained access control が有効か確認
#    - node-to-node encryption が有効か確認
#    - ドメインのバージョンが Elasticsearch 7.10 以降または OpenSearch か確認
#
# 3. LimitExceededException
#    原因: 接続数が上限 (20接続) に達している
#    対処:
#    - 既存の不要な接続を削除
#    - 接続の統合を検討
#
# 4. 接続が PENDING_ACCEPTANCE から進まない
#    原因: 受信側でまだ承認されていない、またはネットワークの問題
#    対処:
#    - 受信側アカウントで aws_opensearch_inbound_connection_accepter を実行
#    - 両ドメイン間のネットワーク接続を確認
#    - セキュリティグループとネットワークACLを確認
#
# 5. バージョン互換性エラー
#    原因: 送信元ドメインのバージョンが受信側より低い
#    対処:
#    - 送信元ドメインを受信側と同じかそれ以上のバージョンにアップグレード
#
# 6. アクセス拒否エラー
#    原因: 受信側ドメインのアクセスポリシーが不適切
#    対処:
#    - 受信側ドメインに es:ESCrossClusterGet 権限を追加
#    - 送信元アカウント/ロールに適切な Principal を設定
#
# 7. 削除時の問題
#    注意: 削除後も 15日間 DELETED ステータスで表示される
#    - これは正常な動作
#    - 再作成する場合は異なる接続エイリアスを使用することを推奨
# ================================================================================


# ================================================================================
# ベストプラクティス
# ================================================================================
#
# 1. セキュリティ設定
#    - 必ず fine-grained access control を有効化
#    - node-to-node encryption を有効化
#    - 最小権限の原則に従ったアクセスポリシーを設定
#    - IAM ロールベースのアクセス制御を推奨
#
# 2. バージョン管理
#    - 送信元と受信側のドメインバージョンを統一
#    - 定期的なバージョンアップグレード計画を策定
#    - バージョン互換性を事前に確認
#
# 3. 接続管理
#    - 接続のエイリアスには分かりやすい命名規則を使用
#    - 不要な接続は定期的に削除してリソースを最適化
#    - 接続数の上限 (20) を考慮した設計
#
# 4. モニタリング
#    - connection_status を定期的に監視
#    - CloudWatch メトリクスで接続の健全性を確認
#    - アラート設定で接続の問題を早期検知
#
# 5. クロスアカウント構成
#    - Terraform の provider エイリアスを使用して明示的に管理
#    - 接続 ID の受け渡しには AWS Systems Manager Parameter Store を活用
#    - 両アカウントでの変更を調整
#
# 6. ネットワーク設計
#    - VPC エンドポイント経由の接続を検討
#    - データ転送コストを考慮したリージョン選択
#    - ネットワーク遅延を最小化する配置
#
# 7. ドキュメント化
#    - 接続の目的と用途を明確に記録
#    - クロスアカウント構成の責任範囲を文書化
#    - 緊急時の連絡先と手順を整備
#
# 8. テスト
#    - 接続確立後、クロスクラスタ検索の動作を確認
#    - フェイルオーバーテストの実施
#    - 接続削除と再作成の手順を検証
# ================================================================================


# ================================================================================
# 関連リソース
# ================================================================================
# - aws_opensearch_domain: OpenSearch ドメインの作成
# - aws_opensearch_outbound_connection: 送信側接続の作成
# - aws_opensearch_domain_policy: ドメインアクセスポリシーの管理
# - aws_opensearch_domain_saml_options: SAML 認証の設定
# ================================================================================


# ================================================================================
# 参考リンク
# ================================================================================
# - Terraform AWS Provider:
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearch_inbound_connection_accepter
#
# - AWS API Reference:
#   https://docs.aws.amazon.com/opensearch-service/latest/APIReference/API_AcceptInboundConnection.html
#
# - Cross-cluster Search Guide:
#   https://docs.aws.amazon.com/opensearch-service/latest/developerguide/cross-cluster-search.html
#
# - Cross-Region and Cross-Account Access:
#   https://docs.aws.amazon.com/opensearch-service/latest/developerguide/application-cross-cluster-search.html
#
# - Fine-grained Access Control:
#   https://docs.aws.amazon.com/opensearch-service/latest/developerguide/fgac.html
# ================================================================================
