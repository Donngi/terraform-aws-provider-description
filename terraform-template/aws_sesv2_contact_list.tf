#---------------------------------------------------------------
# AWS SESv2 Contact List
#---------------------------------------------------------------
#
# Amazon SES (Simple Email Service) v2の連絡先リストをプロビジョニングするリソースです。
# 連絡先リストは、メール受信者（連絡先）を管理するコンテナであり、
# 各連絡先が購読・配信停止できるトピックを定義します。
# メールマーケティングや通知メールの配信管理に使用します。
#
# AWS公式ドキュメント:
#   - 連絡先リストの概要: https://docs.aws.amazon.com/ses/latest/dg/managing-contacts.html
#   - CreateContactList API: https://docs.aws.amazon.com/ses/latest/APIReference-V2/API_CreateContactList.html
#   - トピックの管理: https://docs.aws.amazon.com/ses/latest/dg/contact-list-topics.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sesv2_contact_list
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sesv2_contact_list" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # contact_list_name (Required)
  # 設定内容: 連絡先リストの名前を指定します。
  # 設定可能な値: AWSアカウントおよびリージョン内で一意の文字列
  # 注意: アカウント内で一意である必要があります。
  # 参考: https://docs.aws.amazon.com/ses/latest/APIReference-V2/API_CreateContactList.html
  contact_list_name = "my-contact-list"

  # description (Optional)
  # 設定内容: 連絡先リストの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  description = "マーケティングメール用の連絡先リスト"

  #-------------------------------------------------------------
  # トピック設定
  #-------------------------------------------------------------

  # topic (Optional)
  # 設定内容: 連絡先リストに関連付けるトピックを定義します。
  # トピックはメール受信者が個別に購読・配信停止できるカテゴリです。
  # 複数のtopicブロックを定義することで、複数のトピックを設定できます。
  # 省略時: トピックなし
  topic {
    # topic_name (Required)
    # 設定内容: トピックの内部識別名を指定します。
    # 設定可能な値: 英数字とハイフンのみ使用可能な一意の文字列
    topic_name = "marketing"

    # display_name (Required)
    # 設定内容: 受信者に表示されるトピックの表示名を指定します。
    # 設定可能な値: 任意の文字列
    display_name = "マーケティングメール"

    # default_subscription_status (Required)
    # 設定内容: 新しい連絡先がリストに追加された際のデフォルトの購読ステータスを指定します。
    # 設定可能な値:
    #   - "OPT_IN":  デフォルトで購読済み（メール受信可）
    #   - "OPT_OUT": デフォルトで配信停止済み（メール受信しない）
    default_subscription_status = "OPT_IN"

    # description (Optional)
    # 設定内容: トピックの説明を指定します。
    # 設定可能な値: 任意の文字列
    # 省略時: 説明なし
    description = "製品のプロモーションや特別オファーに関するメール"
  }

  topic {
    topic_name                  = "notifications"
    display_name                = "通知メール"
    default_subscription_status = "OPT_IN"
    description                 = "アカウントや取引に関する重要な通知"
  }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
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
  tags = {
    Name        = "my-contact-list"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: 連絡先リストのAmazon Resource Name (ARN)
#
# - created_timestamp: 連絡先リストが作成された日時（ISO 8601形式）
#
# - id: 連絡先リスト名（contact_list_nameと同じ値）
#
# - last_updated_timestamp: 連絡先リストが最後に更新された日時（ISO 8601形式）
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
