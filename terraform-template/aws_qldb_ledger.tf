#---------------------------------------------------------------
# AWS QLDB Ledger (Amazon Quantum Ledger Database)
#---------------------------------------------------------------
#
# Amazon Quantum Ledger Database (QLDB) のレジャー（台帳）をプロビジョニングするリソースです。
# QLDB は透明性・不変性・暗号的検証可能なトランザクションログを提供するフルマネージドな
# 台帳データベースサービスです。PartiQL を使用したクエリと ACID トランザクションをサポートします。
#
# AWS公式ドキュメント:
#   - Amazon QLDB 開発者ガイド: https://docs.aws.amazon.com/qldb/latest/developerguide/what-is.html
#   - QLDB 機能: https://aws.amazon.com/qldb/features/
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/qldb_ledger
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_qldb_ledger" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Optional, Forces new resource)
  # 設定内容: QLDB レジャーのフレンドリー名を指定します。
  # 設定可能な値: 英数字とハイフンを含む文字列
  # 省略時: Terraform がランダムな一意の名前を生成します。
  name = "my-qldb-ledger"

  # permissions_mode (Required)
  # 設定内容: QLDB レジャーインスタンスのパーミッションモードを指定します。
  # 設定可能な値:
  #   - "ALLOW_ALL": レジャーのすべてのAPIコマンドへのアクセスを許可するレガシーモード。
  #                  テーブルレベルのアクセス制御は行われません。
  #   - "STANDARD": 推奨モード。IAM ポリシーと QLDB のパーミッションを組み合わせて
  #                 テーブルレベルのきめ細かいアクセス制御を実現します。
  # 参考: https://docs.aws.amazon.com/service-authorization/latest/reference/list_amazonqldb.html
  permissions_mode = "STANDARD"

  #-------------------------------------------------------------
  # 削除保護設定
  #-------------------------------------------------------------

  # deletion_protection (Optional)
  # 設定内容: QLDB レジャーの削除保護を有効にするかを指定します。
  # 設定可能な値:
  #   - true (デフォルト): 削除保護を有効化。Terraform で削除するには先にこの値を
  #                        false に変更して apply してから destroy を実行する必要があります。
  #   - false: 削除保護を無効化。Terraform destroy で直接削除可能になります。
  # 注意: デフォルト値が true のため、destroy 前に必ず false へ変更してください。
  deletion_protection = true

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # kms_key (Optional)
  # 設定内容: レジャーの保存データ暗号化に使用するKMSキーを指定します。
  # 設定可能な値:
  #   - "AWS_OWNED_KMS_KEY": AWSが所有・管理するKMSキーを使用します（デフォルト）。
  #   - 有効な対称カスタマーマネージドKMSキーのARN（例: arn:aws:kms:...）
  # 省略時: AWS所有のKMSキーが使用されます。
  # 参考: https://docs.aws.amazon.com/qldb/latest/developerguide/encryption-at-rest.html
  kms_key = "AWS_OWNED_KMS_KEY"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグは設定されません。
  # 注意: プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-qldb-ledger"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を設定するブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: レジャーの作成が完了するまで待機する最大時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウトが適用されます。
    create = "30m"

    # delete (Optional)
    # 設定内容: レジャーの削除が完了するまで待機する最大時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウトが適用されます。
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: QLDB レジャーの名前
# - arn: QLDB レジャーのARN
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
