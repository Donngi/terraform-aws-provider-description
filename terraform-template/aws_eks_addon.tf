#---------------------------------------------------------------
# Amazon EKS Add-on
#---------------------------------------------------------------
#
# Amazon EKS クラスターに追加機能 (Add-on) を管理するためのリソースです。
# EKS Add-on は、オペレーショナルソフトウェア (ネットワーキング、オブザーバビリティ、
# セキュリティなど) を簡単にインストール・管理できる機能です。
#
# 主なAdd-onの例:
#   - vpc-cni: Amazon VPC CNI プラグイン (Pod ネットワーキング)
#   - kube-proxy: Kubernetes ネットワークプロキシ
#   - coredns: クラスタ内DNSサービス
#   - aws-ebs-csi-driver: EBS ボリュームのプロビジョニング
#   - aws-efs-csi-driver: EFS ボリュームのプロビジョニング
#
# AWS公式ドキュメント:
#   - EKS Add-ons 概要: https://docs.aws.amazon.com/eks/latest/userguide/eks-add-ons.html
#   - 利用可能なAdd-on一覧: https://docs.aws.amazon.com/eks/latest/userguide/workloads-add-ons-available-eks.html
#   - EKS API リファレンス: https://docs.aws.amazon.com/eks/latest/APIReference/API_CreateAddon.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_eks_addon" "example" {
  #-------------------------------------------------------------
  # 必須パラメータ
  #-------------------------------------------------------------

  # cluster_name (Required)
  # 設定内容: Add-on をインストールするEKSクラスター名を指定します。
  # 設定可能な値: 有効なEKSクラスター名
  # 用途: Add-on を関連付けるクラスターの識別
  # 関連機能: Amazon EKS Cluster
  #   クラスター内で動作するKubernetesコンポーネントを管理します。
  #   - https://docs.aws.amazon.com/eks/latest/userguide/clusters.html
  cluster_name = "my-eks-cluster"

  # addon_name (Required)
  # 設定内容: インストールするAdd-on の名前を指定します。
  # 設定可能な値: サポートされているAdd-on名 (例: vpc-cni, kube-proxy, coredns, aws-ebs-csi-driver など)
  # 注意: 利用可能なAdd-on名は describe-addon-versions コマンドで確認できます
  # 関連機能: Amazon EKS Add-ons
  #   - AWS CLI: aws eks describe-addon-versions --kubernetes-version 1.29
  #   - https://docs.aws.amazon.com/eks/latest/userguide/workloads-add-ons-available-eks.html
  addon_name = "vpc-cni"

  #-------------------------------------------------------------
  # バージョン管理
  #-------------------------------------------------------------

  # addon_version (Optional, Computed)
  # 設定内容: インストールするAdd-on のバージョンを指定します。
  # 設定可能な値: 有効なAdd-onバージョン (例: v1.16.0-eksbuild.1)
  # 省略時: クラスターのKubernetesバージョンに対応する最新バージョンが使用されます
  # 注意: 利用可能なバージョンは describe-addon-versions コマンドで確認できます
  # 関連機能: Amazon EKS Add-on バージョニング
  #   各Add-onはクラスターのKubernetesバージョンとの互換性があります。
  #   - https://docs.aws.amazon.com/eks/latest/userguide/managing-add-ons.html
  addon_version = null

  #-------------------------------------------------------------
  # 設定とカスタマイズ
  #-------------------------------------------------------------

  # configuration_values (Optional, Computed)
  # 設定内容: Add-on のカスタム設定値をJSON文字列で指定します。
  # 設定可能な値: Add-onのJSONスキーマに準拠したJSON文字列
  # 省略時: Add-onのデフォルト設定が使用されます
  # 注意: 設定スキーマは describe-addon-configuration コマンドで確認できます
  # 関連機能: Amazon EKS Add-on 設定
  #   Add-on の動作をカスタマイズするための設定値。
  #   - AWS CLI: aws eks describe-addon-configuration --addon-name vpc-cni --addon-version v1.16.0-eksbuild.1
  #   - https://docs.aws.amazon.com/eks/latest/userguide/add-ons-configuration.html
  configuration_values = null

  #-------------------------------------------------------------
  # 競合解決
  #-------------------------------------------------------------

  # resolve_conflicts_on_create (Optional)
  # 設定内容: セルフマネージドAdd-onからAmazon EKS Add-onへの移行時にフィールド値の競合を解決する方法を指定します。
  # 設定可能な値:
  #   - "NONE": 競合がある場合はエラーを返します
  #   - "OVERWRITE": EKS Add-on の値でセルフマネージドAdd-onの値を上書きします
  # 省略時: "NONE" として動作します
  # 用途: 既存のセルフマネージドAdd-onをEKSマネージドAdd-onに移行する際に使用
  # 関連機能: Amazon EKS Add-on 移行
  #   - https://docs.aws.amazon.com/eks/latest/APIReference/API_CreateAddon.html
  resolve_conflicts_on_create = null

  # resolve_conflicts_on_update (Optional)
  # 設定内容: Add-on 更新時にフィールド値の競合を解決する方法を指定します。
  # 設定可能な値:
  #   - "NONE": 競合がある場合はエラーを返します
  #   - "OVERWRITE": EKS Add-on の新しい値で既存の値を上書きします
  #   - "PRESERVE": 既存の値を保持し、新しい値を無視します
  # 省略時: "NONE" として動作します
  # 用途: Add-on 更新時に既存の設定を保護または上書きする際に使用
  # 関連機能: Amazon EKS Add-on 更新
  #   - https://docs.aws.amazon.com/eks/latest/APIReference/API_UpdateAddon.html
  resolve_conflicts_on_update = null

  #-------------------------------------------------------------
  # IAM ロール設定
  #-------------------------------------------------------------

  # service_account_role_arn (Optional)
  # 設定内容: Add-on のサービスアカウントにバインドする既存のIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールのARN
  # 省略時: ノードIAMロールに割り当てられた権限を使用します
  # 注意: IAMロールを指定するには、クラスターにIAM OIDC プロバイダーを作成する必要があります
  # 関連機能: IAM Roles for Service Accounts (IRSA)
  #   Podに直接IAMロールを関連付けてAWSリソースへのアクセスを管理します。
  #   - https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html
  #   - https://docs.aws.amazon.com/eks/latest/userguide/enable-iam-roles-for-service-accounts.html
  service_account_role_arn = null

  #-------------------------------------------------------------
  # Pod Identity 関連付け
  #-------------------------------------------------------------

  # pod_identity_association (Optional)
  # 設定内容: EKS Pod Identity の設定を指定します。
  # 用途: Pod Identity エージェントを使用してPodにIAMクレデンシャルを提供
  # 注意: Pod Identity は IRSA (service_account_role_arn) の代替機能です
  # 関連機能: Amazon EKS Pod Identity
  #   Pod Identity エージェントが自動的にIAMクレデンシャルを管理します。
  #   - https://docs.aws.amazon.com/eks/latest/userguide/pod-identities.html
  # pod_identity_association {
  #   # role_arn (Required)
  #   # 設定内容: サービスアカウントに関連付けるIAMロールのARNを指定します。
  #   # 設定可能な値: 有効なIAMロールのARN
  #   # 用途: Pod Identity エージェントがこのロールを引き受けてアプリケーションにクレデンシャルを提供
  #   # 関連機能: EKS Pod Identity Agent
  #   #   - https://docs.aws.amazon.com/eks/latest/userguide/pod-id-agent-setup.html
  #   role_arn = "arn:aws:iam::123456789012:role/eks-pod-identity-role"
  #
  #   # service_account (Required)
  #   # 設定内容: IAMクレデンシャルを関連付けるKubernetesサービスアカウント名を指定します。
  #   # 設定可能な値: クラスター内に存在するKubernetesサービスアカウント名
  #   # 用途: このサービスアカウントを使用するPodがIAMロールのクレデンシャルを取得
  #   # 関連機能: Kubernetes Service Accounts
  #   #   - https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/
  #   service_account = "my-service-account"
  # }

  #-------------------------------------------------------------
  # 削除時の保持設定
  #-------------------------------------------------------------

  # preserve (Optional)
  # 設定内容: EKS Add-on を削除する際に、作成されたリソースを保持するかどうかを指定します。
  # 設定可能な値:
  #   - true: Add-on 削除時にリソースを保持 (セルフマネージドに戻す)
  #   - false: Add-on 削除時にリソースも削除
  # 省略時: false として動作します
  # 用途: EKSマネージドAdd-onからセルフマネージドAdd-onに戻す際に使用
  # 関連機能: Amazon EKS Add-on 削除
  #   - https://docs.aws.amazon.com/eks/latest/APIReference/API_DeleteAddon.html
  preserve = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
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
  #   - https://docs.aws.amazon.com/eks/latest/userguide/eks-using-tags.html
  tags = {
    Name        = "vpc-cni-addon"
    Environment = "production"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーのdefault_tagsから継承されるタグを含む全タグのマップ
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  tags_all = null

  # id (Optional, Computed)
  # 設定内容: リソースのID。クラスター名とAdd-on名をコロン (:) で結合した形式
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  id = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------
  # timeouts {
  #   # create (Optional)
  #   # 設定内容: Add-on 作成のタイムアウト時間を指定します。
  #   # 設定可能な値: 時間文字列 (例: "20m", "1h")
  #   # 省略時: デフォルトのタイムアウト値を使用
  #   create = "20m"
  #
  #   # update (Optional)
  #   # 設定内容: Add-on 更新のタイムアウト時間を指定します。
  #   # 設定可能な値: 時間文字列 (例: "20m", "1h")
  #   # 省略時: デフォルトのタイムアウト値を使用
  #   update = "20m"
  #
  #   # delete (Optional)
  #   # 設定内容: Add-on 削除のタイムアウト時間を指定します。
  #   # 設定可能な値: 時間文字列 (例: "40m", "1h")
  #   # 省略時: デフォルトのタイムアウト値を使用
  #   delete = "40m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: EKS Add-on のAmazon Resource Name (ARN)
#
# - id: EKSクラスター名とAdd-on名をコロン (:) で区切った形式
#   形式: <cluster_name>:<addon_name>
#
# - status: EKS Add-on のステータス
#   可能な値: CREATING, ACTIVE, UPDATING, DELETING, CREATE_FAILED, UPDATE_FAILED, DELETE_FAILED
#
# - created_at: EKS Add-on が作成された日時 (RFC3339形式)
#
# - modified_at: EKS Add-on が最後に更新された日時 (RFC3339形式)
#
#---------------------------------------------------------------
