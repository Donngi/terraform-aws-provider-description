#---------------------------------------------------------------
# Amazon S3 Bucket ACL
#---------------------------------------------------------------
#
# Amazon S3バケットのアクセスコントロールリスト（ACL）をプロビジョニングするリソースです。
# ACLを使用して、AWSアカウントや定義済みグループに対するバケットへの
# 基本的な読み取り/書き込み権限を管理できます。
#
# 注意事項:
# - terraform destroyを実行してもS3バケットACLは削除されず、Terraform stateから削除されるのみです
# - このリソースはS3ディレクトリバケットでは使用できません
# - 現代のユースケースではACLの使用は推奨されず、ポリシーによるアクセス制御が推奨されます
# - S3 Object Ownershipが"Bucket owner enforced"に設定されている場合、ACLは無効化されます
#
# AWS公式ドキュメント:
#   - ACL概要: https://docs.aws.amazon.com/AmazonS3/latest/userguide/acl-overview.html
#   - ACLの管理: https://docs.aws.amazon.com/AmazonS3/latest/userguide/managing-acls.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl
#
# Provider Version: 6.36.0
# Generated: 2026-03-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3_bucket_acl" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # bucket (Required, Forces new resource)
  # 設定内容: ACLを適用するバケットの名前またはARNを指定します。
  # 設定可能な値: 既存のS3バケット名またはARN
  # 注意: この値を変更すると、新しいリソースが作成されます（既存のリソースは削除されます）
  bucket = "my-bucket-name"

  # expected_bucket_owner (Optional, Forces new resource, Deprecated)
  # 設定内容: バケットの予期される所有者のAWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  # 用途: バケット所有者の検証を行い、意図しないバケットへの操作を防止します
  # 注意: この属性は非推奨です。指定したアカウントIDとバケットの実際の所有者が異なる場合、エラーが発生します
  expected_bucket_owner = null

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # ACL設定（aclまたはaccess_control_policyのいずれか一方を指定）
  #-------------------------------------------------------------

  # acl (Optional, aclまたはaccess_control_policyのいずれか一方が必須)
  # 設定内容: バケットに適用する定義済みACL（Canned ACL）を指定します。
  # 設定可能な値:
  #   - "private" (デフォルト): 所有者がFULL_CONTROLを持ち、他のユーザーはアクセス権なし
  #   - "public-read": 所有者がFULL_CONTROL、AllUsersグループがREADアクセス権を持つ
  #   - "public-read-write": 所有者がFULL_CONTROL、AllUsersグループがREADとWRITEアクセス権を持つ（非推奨）
  #   - "aws-exec-read": 所有者がFULL_CONTROL、Amazon EC2がAMIバンドル取得のためのREADアクセス権を持つ
  #   - "authenticated-read": 所有者がFULL_CONTROL、AuthenticatedUsersグループがREADアクセス権を持つ
  #   - "bucket-owner-read": オブジェクト所有者がFULL_CONTROL、バケット所有者がREADアクセス権を持つ
  #   - "bucket-owner-full-control": オブジェクト所有者とバケット所有者の両方がFULL_CONTROLを持つ
  #   - "log-delivery-write": LogDeliveryグループがWRITEとREAD_ACP権限を持つ（サーバーアクセスログ用）
  # 注意: access_control_policyと排他的（どちらか一方のみ指定可能）
  # 関連機能: Canned ACL
  #   定義済みの権限セットを簡単に適用できる機能。各Canned ACLには
  #   特定の権限受領者と権限が事前定義されています。
  #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/acl-overview.html#canned-acl
  acl = "private"

  #-------------------------------------------------------------
  # カスタムACL設定（aclまたはaccess_control_policyのいずれか一方を指定）
  #-------------------------------------------------------------

  # access_control_policy (Optional, aclまたはaccess_control_policyのいずれか一方が必須)
  # 設定内容: オブジェクトごとの権限受領者に対してACL権限を設定するための設定ブロックです。
  # 注意: aclと排他的（どちらか一方のみ指定可能）
  # 用途: Canned ACLでは実現できない細かい権限制御が必要な場合に使用
  access_control_policy {
    # owner (Required)
    # 設定内容: バケット所有者の表示名とIDを設定します。
    owner {
      # id (Required)
      # 設定内容: 所有者のCanonical User IDを指定します。
      # 設定可能な値: AWSアカウントに関連付けられたCanonical User ID（長い文字列）
      # 参考: Canonical User IDの確認方法
      #   - https://docs.aws.amazon.com/accounts/latest/reference/manage-acct-identifiers.html#FindCanonicalId
      id = "79a59df900b949e55d96a1e698fbacedfd6e09d98eacf8f8d5218e7cd47ef2be"

      # display_name (Optional, Deprecated)
      # 設定内容: 所有者の表示名を指定します。
      # 注意: この属性は非推奨であり、オプションのcomputed属性です
      display_name = null
    }

    # grant (Required)
    # 設定内容: 権限受領者（grantee）とその権限（permission）を定義するセット型ブロックです。
    # 注意: 複数のgrantブロックを指定できます（ACLは最大100個のgrantを持つことができます）
    grant {
      # permission (Required)
      # 設定内容: 権限受領者に付与するログ権限を指定します。
      # 設定可能な値:
      #   - "FULL_CONTROL": READ、WRITE、READ_ACP、WRITE_ACPの全権限
      #   - "WRITE": バケットに新しいオブジェクトを作成する権限
      #   - "WRITE_ACP": バケットのACLを書き込む権限
      #   - "READ": バケット内のオブジェクトを一覧表示する権限
      #   - "READ_ACP": バケットのACLを読み取る権限
      # 関連機能: ACL権限
      #   各権限の詳細な意味については以下を参照してください。
      #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/acl-overview.html#permissions
      permission = "READ"

      # grantee (Required)
      # 設定内容: 権限を付与される対象（個人またはグループ）を設定します。
      grantee {
        # type (Required)
        # 設定内容: 権限受領者のタイプを指定します。
        # 設定可能な値:
        #   - "CanonicalUser": AWSアカウントのCanonical User IDで指定
        #   - "AmazonCustomerByEmail": AWSアカウントのメールアドレスで指定
        #   - "Group": Amazon S3定義済みグループのURIで指定
        # 注意: IAMユーザーは権限受領者として指定できません（AWSアカウントのみ）
        type = "CanonicalUser"

        # id (Optional)
        # 設定内容: 権限受領者のCanonical User IDを指定します。
        # 設定可能な値: 権限受領者のCanonical User ID
        # 用途: typeが"CanonicalUser"の場合に使用
        id = "79a59df900b949e55d96a1e698fbacedfd6e09d98eacf8f8d5218e7cd47ef2be"

        # email_address (Optional)
        # 設定内容: 権限受領者のメールアドレスを指定します。
        # 設定可能な値: 有効なメールアドレス
        # 用途: typeが"AmazonCustomerByEmail"の場合に使用
        # 注意: この引数をサポートするリージョンについては以下を参照
        # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#s3_region
        email_address = null

        # uri (Optional)
        # 設定内容: 権限受領者グループのURIを指定します。
        # 設定可能な値:
        #   - "http://acs.amazonaws.com/groups/global/AuthenticatedUsers": 認証済みユーザーグループ（全AWSアカウント）
        #   - "http://acs.amazonaws.com/groups/global/AllUsers": 全ユーザーグループ（匿名アクセス含む）
        #   - "http://acs.amazonaws.com/groups/s3/LogDelivery": ログ配信グループ（サーバーアクセスログ用）
        # 用途: typeが"Group"の場合に使用
        # 注意: AllUsersグループへのWRITE、WRITE_ACP、FULL_CONTROL権限の付与は非推奨
        # 関連機能: Amazon S3定義済みグループ
        #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/acl-overview.html#specifying-grantee
        uri = null
      }
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: bucket、expected_bucket_owner（設定されている場合）、acl（設定されている場合）を
#       カンマ（,）で区切った文字列
#---------------------------------------------------------------
