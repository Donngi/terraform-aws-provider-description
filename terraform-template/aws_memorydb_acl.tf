# aws_memorydb_acl
# Provider Version: 6.28.0
# Generated: 2026-02-17
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/memorydb_acl
# NOTE: このファイルはAnnotated Templateです。実際の利用時は不要なコメントを削除してください。

# MemoryDB ACL (Access Control List) リソース
# MemoryDB クラスターへのアクセス制御を行うACLを管理する
# ACLにユーザーを関連付けることでクラスターへの接続権限を制御できる
# 参考: https://docs.aws.amazon.com/memorydb/latest/devguide/clusters.acls.html

resource "aws_memorydb_acl" "example" {

  #---------------------------------------
  # 識別子設定
  #---------------------------------------

  # ACL名
  # 設定内容: ACLの一意な名前（name と name_prefix は同時指定不可）
  # 設定可能な値: 英数字、ハイフン（1〜40文字）
  # 省略時: Terraform がランダムな一意名を自動生成する
  name = "my-acl"

  # ACL名プレフィックス
  # 設定内容: 指定したプレフィックスから始まる一意な名前を自動生成する（name と競合するため、どちらか一方のみ指定）
  # 設定可能な値: 文字列プレフィックス
  # 省略時: 使用しない
  name_prefix = null

  #---------------------------------------
  # ユーザー設定
  #---------------------------------------

  # ACLに含めるユーザー名のセット
  # 設定内容: このACLに関連付けるMemoryDBユーザー名の一覧
  # 設定可能な値: aws_memorydb_user リソースで定義されたユーザー名のセット
  # 省略時: ユーザーなし（空のACL）
  user_names = ["my-user-1", "my-user-2"]

  #---------------------------------------
  # リージョン設定
  #---------------------------------------

  # リソースを管理するAWSリージョン
  # 設定内容: このリソースをデプロイするリージョン
  # 設定可能な値: 有効なAWSリージョンコード（例: "us-east-1", "ap-northeast-1"）
  # 省略時: プロバイダー設定のリージョンを使用する
  region = null

  #---------------------------------------
  # タグ設定
  #---------------------------------------

  # リソースに付与するタグ
  # 設定内容: キーと値のペアでリソースを分類・管理するためのメタデータ
  # 設定可能な値: 文字列キーと文字列値のマップ
  # 省略時: タグなし
  tags = {
    Name = "my-acl"
  }
}

#---------------------------------------
# Attributes Reference
#---------------------------------------
# id                    - ACLのID（nameと同じ値）
# arn                   - ACLのARN
# minimum_engine_version - このACLがサポートする最小エンジンバージョン
# tags_all              - プロバイダーのdefault_tagsを含む全タグのマップ
