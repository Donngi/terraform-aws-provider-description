#---------------------------------------------------------------
# Amazon EBS Volume
#---------------------------------------------------------------
#
# Amazon Elastic Block Store (EBS) ボリュームをプロビジョニングします。
# EBSは、EC2インスタンスにアタッチ可能な永続的なブロックレベルストレージを提供します。
# 各ボリュームは自動的に可用性ゾーン内でレプリケートされ、障害から保護されます。
#
# AWS公式ドキュメント:
#   - Amazon EBS ボリュームタイプ: https://docs.aws.amazon.com/ebs/latest/userguide/ebs-volume-types.html
#   - Amazon EBS 暗号化の仕組み: https://docs.aws.amazon.com/ebs/latest/userguide/how-ebs-encryption-works.html
#   - Amazon EBS マルチアタッチ: https://docs.aws.amazon.com/ebs/latest/userguide/ebs-volumes-multi.html
#   - Amazon EBS ボリュームの初期化: https://docs.aws.amazon.com/ebs/latest/userguide/initalize-volume.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_volume
#
# Provider Version: 6.28.0
# Generated: 2026-01-31
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ebs_volume" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # availability_zone (Required)
  # 設定内容: EBSボリュームが作成される可用性ゾーンを指定します。
  # 設定可能な値: 有効なAWSアベイラビリティゾーン（例: us-west-2a, ap-northeast-1a）
  # 注意: EC2インスタンスにアタッチする場合は、インスタンスと同じAZを指定する必要があります。
  availability_zone = "us-west-2a"

  #---------------------------------------------------------------
  # ボリュームサイズとスナップショット
  #---------------------------------------------------------------

  # size (Optional)
  # 設定内容: ボリュームのサイズをGiBで指定します。
  # 設定可能な値: 1〜64,000 GiB（ボリュームタイプにより異なる）
  # 省略時: snapshot_idから作成する場合はスナップショットと同じサイズになります。
  # 注意: sizeまたはsnapshot_idの少なくとも一方が必須です。
  #       snapshot_idから作成する場合、sizeを指定する場合はスナップショットサイズ以上である必要があります。
  #       サイズ、IOPS、またはタイプを変更する際には考慮事項があります。
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/considerations.html
  size = 40

  # snapshot_id (Optional)
  # 設定内容: ボリュームを作成する際のベースとなるスナップショットIDを指定します。
  # 設定可能な値: 有効なEBSスナップショットID（例: snap-049df61146c4d7901）
  # 省略時: 空のボリュームが作成されます。
  # 注意: sizeまたはsnapshot_idの少なくとも一方が必須です。
  snapshot_id = null

  #---------------------------------------------------------------
  # ボリュームタイプとパフォーマンス
  #---------------------------------------------------------------

  # type (Optional)
  # 設定内容: EBSボリュームのタイプを指定します。
  # 設定可能な値:
  #   - "standard": 旧世代のマグネティックボリューム
  #   - "gp2": 汎用SSD（バースト可能、コスト効率的）
  #   - "gp3": 汎用SSD（最新世代、パフォーマンスを独立してスケール可能、gp2より低価格）
  #   - "io1": プロビジョンドIOPS SSD（99.8-99.9%耐久性）
  #   - "io2": プロビジョンドIOPS SSD（99.999%耐久性、io1より高性能）
  #   - "sc1": Cold HDD（最低コスト、アクセス頻度の低いワークロード向け）
  #   - "st1": スループット最適化HDD（頻繁にアクセスされるスループット集約型ワークロード向け）
  # 省略時: "gp2"（デフォルト）
  # 関連機能: Amazon EBS ボリュームタイプ
  #   SSD系ボリューム（standard, gp2, gp3, io1, io2）はトランザクション型ワークロードに適し、
  #   HDD系ボリューム（sc1, st1）はスループット集約型ワークロードに適します。
  #   gp3は最新世代でIOPSとスループットを独立して設定可能です。
  #   - https://aws.amazon.com/ebs/volume-types/
  #   - https://docs.aws.amazon.com/ebs/latest/userguide/ebs-volume-types.html
  type = null

  # iops (Optional)
  # 設定内容: ボリュームにプロビジョニングするIOPSの量を指定します。
  # 設定可能な値:
  #   - io1: 100〜64,000 IOPS（最大50:1の比率、IOPS:サイズ GiB）
  #   - io2: 100〜256,000 IOPS（最大500:1の比率、IOPS:サイズ GiB）
  #   - gp3: 3,000〜16,000 IOPS
  # 省略時: gp3の場合は3,000 IOPS、io1/io2の場合はサイズに基づいて計算されます。
  # 注意: typeが "io1", "io2", "gp3" の場合にのみ有効です。
  iops = null

  # throughput (Optional)
  # 設定内容: ボリュームがサポートするスループットをMiB/s単位で指定します。
  # 設定可能な値: 125〜1,000 MiB/s
  # 省略時: 125 MiB/s（デフォルト）
  # 注意: typeが "gp3" の場合にのみ有効です。
  # 関連機能: gp3パフォーマンス設定
  #   gp3ボリュームではIOPSとスループットを独立して設定可能です。
  #   - https://docs.aws.amazon.com/ebs/latest/userguide/general-purpose.html
  throughput = null

  #---------------------------------------------------------------
  # 暗号化設定
  #---------------------------------------------------------------

  # encrypted (Optional)
  # 設定内容: ボリュームを暗号化するかどうかを指定します。
  # 設定可能な値:
  #   - true: ボリュームを暗号化します
  #   - false: ボリュームを暗号化しません
  # 省略時: false（ただし、アカウントレベルでEBS暗号化がデフォルトで有効な場合は自動的に暗号化されます）
  # 関連機能: Amazon EBS 暗号化
  #   暗号化されたボリュームは、AWS KMSを使用してデータの暗号化・復号化を行います。
  #   データは保管時および転送時に暗号化されます。
  #   - https://docs.aws.amazon.com/ebs/latest/userguide/how-ebs-encryption-works.html
  # 注意: kms_key_idを指定する場合は、encryptedをtrueに設定する必要があります。
  encrypted = null

  # kms_key_id (Optional)
  # 設定内容: ボリュームの暗号化に使用するKMS暗号化キーのARNを指定します。
  # 設定可能な値: 有効なKMSキーARN（例: arn:aws:kms:us-west-2:111122223333:key/1234abcd-12ab-34cd-56ef-1234567890ab）
  # 省略時: デフォルトのAWS管理キー（aws/ebs）が使用されます。
  # 関連機能: Amazon EBS 暗号化とAWS KMS
  #   カスタマー管理のKMSキーを使用することで、暗号化キーの管理と
  #   アクセス制御をより細かく制御できます。
  #   - https://docs.aws.amazon.com/kms/latest/developerguide/services-ebs.html
  # 注意: kms_key_idを指定する場合は、encryptedをtrueに設定する必要があります。
  #       Terraformは、GenerateDataKeyWithoutPlaintext権限を持つ認証情報で実行する必要があります。
  kms_key_id = null

  #---------------------------------------------------------------
  # 高度な機能
  #---------------------------------------------------------------

  # multi_attach_enabled (Optional)
  # 設定内容: Amazon EBS マルチアタッチを有効にするかどうかを指定します。
  # 設定可能な値:
  #   - true: マルチアタッチを有効にします
  #   - false: マルチアタッチを無効にします
  # 省略時: false（デフォルト）
  # 関連機能: Amazon EBS マルチアタッチ
  #   単一のボリュームを同じアベイラビリティゾーン内の最大16個のEC2インスタンスに
  #   同時にアタッチできる機能です。アプリケーションの可用性を高め、
  #   並行書き込み操作を管理するアプリケーションに有用です。
  #   - https://docs.aws.amazon.com/ebs/latest/userguide/ebs-volumes-multi.html
  # 注意: io1およびio2ボリュームでのみサポートされます。ブートボリュームには使用できません。
  multi_attach_enabled = null

  # outpost_arn (Optional)
  # 設定内容: AWS Outpostsにボリュームを作成する場合、OutpostのAmazon Resource Name (ARN)を指定します。
  # 設定可能な値: 有効なOutpost ARN（例: arn:aws:outposts:us-west-2:123456789012:outpost/op-1234567890abcdef0）
  # 省略時: 標準のAWSリージョンにボリュームが作成されます。
  # 関連機能: AWS Outposts上のEBS
  #   Outpostsでは、gp2ボリュームタイプがサポートされており、
  #   オンプレミスでの低レイテンシーストレージを提供します。
  #   - https://docs.aws.amazon.com/whitepapers/latest/aws-outposts-high-availability-design/storage.html
  outpost_arn = null

  # volume_initialization_rate (Optional)
  # 設定内容: Amazon S3からボリュームにスナップショットブロックをダウンロードする際の
  #           プロビジョンドレートをMiB/s単位で指定します。
  # 設定可能な値: 最大300 MiB/s
  # 省略時: デフォルトの初期化レートが使用されます。
  # 関連機能: Amazon EBS プロビジョンドレートでのボリューム初期化
  #   ボリューム作成時の初期化速度を向上させることで、
  #   複数のボリュームを同時に作成する場合や初期化時間を短縮したい場合に有用です。
  #   料金は、スナップショットデータサイズと指定レートに基づいて課金されます。
  #   - https://docs.aws.amazon.com/ebs/latest/userguide/initalize-volume.html
  # 注意: この引数は、snapshot_idが指定されている場合にのみ設定できます。
  volume_initialization_rate = null

  # final_snapshot (Optional)
  # 設定内容: ボリューム削除前にスナップショットを作成するかどうかを指定します。
  # 設定可能な値:
  #   - true: ボリューム削除前にスナップショットを作成します
  #   - false: ボリューム削除前にスナップショットを作成しません
  # 省略時: false（デフォルト）
  # 注意: ボリュームに付けられたタグは、スナップショットに移行されます。
  final_snapshot = null

  #---------------------------------------------------------------
  # リージョン設定
  #---------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースが管理されるAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-west-2, ap-northeast-1）
  # 省略時: プロバイダー設定で設定されたリージョンがデフォルトで使用されます。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #---------------------------------------------------------------
  # タグ設定
  #---------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name = "example-ebs-volume"
  }

  # tags_all (Optional)
  # 設定内容: プロバイダーのdefault_tagsから継承されたタグを含む、
  #           リソースに割り当てられた全てのタグのマップです。
  # 省略時: tagsとdefault_tagsがマージされます。
  # 注意: このパラメータは通常、Terraformによって自動的に管理されるため、
  #       明示的に設定する必要はありません。
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags_all = null

  #---------------------------------------------------------------
  # リソースID（通常は設定不要）
  #---------------------------------------------------------------

  # id (Optional)
  # 設定内容: リソースのIDを指定します。
  # 省略時: 作成時に自動的に生成されます（通常の動作）。
  # 注意: この属性は主にTerraformのインポート機能で使用されます。
  #       新規リソース作成時には設定する必要はありません。
  #       作成後はボリュームID（例: vol-049df61146c4d7901）が自動的に割り当てられます。
  id = null

  #---------------------------------------------------------------
  # タイムアウト設定
  #---------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: ボリュームの作成操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "10m", "1h"）
    # 省略時: 5分（デフォルト）
    create = null

    # update (Optional)
    # 設定内容: ボリュームの更新操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "10m", "1h"）
    # 省略時: 5分（デフォルト）
    update = null

    # delete (Optional)
    # 設定内容: ボリュームの削除操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "10m", "1h"）
    # 省略時: 5分（デフォルト）
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ボリュームのAmazon Resource Name (ARN)
#        例: "arn:aws:ec2:us-east-1:123456789012:volume/vol-049df61146c4d7901"
#
# - id: ボリュームID
#       例: "vol-049df61146c4d7901"
#
# - create_time: ボリューム作成が開始されたタイムスタンプ
#                例: "2023-01-15T12:34:56Z"
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたものを含む、
#             リソースに割り当てられたすべてのタグのマップ
#
#---------------------------------------------------------------
