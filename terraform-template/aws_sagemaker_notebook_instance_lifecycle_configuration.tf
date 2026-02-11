################################################################################
# AWS SageMaker Notebook Instance Lifecycle Configuration
# Version: AWS Provider 6.28.0
# Reference: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_notebook_instance_lifecycle_configuration
################################################################################

# リソース概要:
# SageMaker Notebook Instanceのライフサイクル設定を管理するリソースです。
# ノートブックインスタンスの作成時や起動時に実行されるシェルスクリプトを定義でき、
# パッケージのインストール、環境変数の設定、ネットワーク構成などのカスタマイズが可能です。

resource "aws_sagemaker_notebook_instance_lifecycle_configuration" "example" {
  # ==============================================================================
  # 基本設定
  # ==============================================================================

  # name - (Optional) ライフサイクル設定の名前（一意である必要があります）
  # 省略した場合、Terraformがランダムで一意な名前を割り当てます
  #
  # 制約事項:
  # - 最大63文字
  # - 英数字、ハイフン(-)、アンダースコア(_)のみ使用可能
  #
  # 使用例:
  # name = "my-notebook-lifecycle-config"
  name = "example-lifecycle-config"

  # ==============================================================================
  # ライフサイクルスクリプト設定
  # ==============================================================================

  # on_create - (Optional) ノートブックインスタンスが作成された時に一度だけ実行されるシェルスクリプト
  # Base64エンコードされた文字列として指定する必要があります
  #
  # 実行環境:
  # - rootユーザーとして実行
  # - ノートブックインスタンスのIAM実行ロールの権限を持つ
  # - $PATH環境変数: /sbin:bin:/usr/sbin:/usr/bin
  #
  # 制約事項:
  # - 最大16384文字（エンコード前）
  # - 実行時間は5分まで
  # - CloudWatch Logsグループ: /aws/sagemaker/NotebookInstances
  #
  # ベストプラクティス:
  # - スクリプト内に機密情報を含めない
  # - conda環境を使用してパッケージをインストール
  # - すべてのconda環境はデフォルトフォルダに保存
  #
  # 使用例:
  # on_create = base64encode(<<-EOF
  #   #!/bin/bash
  #   set -e
  #
  #   # Install additional packages
  #   sudo -u ec2-user -i <<'CONDA'
  #   conda install -y scikit-learn pandas
  #   CONDA
  #
  #   # Configure environment
  #   echo "export MY_VAR=value" >> /home/ec2-user/.bashrc
  # EOF
  # )
  on_create = base64encode(<<-EOF
    #!/bin/bash
    set -e

    # Install additional Python packages
    sudo -u ec2-user -i <<'CONDA'
    conda install -y -n python3 numpy scipy
    CONDA

    echo "Notebook instance creation script completed"
  EOF
  )

  # on_start - (Optional) ノートブックインスタンスが起動するたびに実行されるシェルスクリプト
  # Base64エンコードされた文字列として指定する必要があります
  # 作成時にも実行されます
  #
  # 実行環境: on_createと同様
  # 制約事項: on_createと同様
  #
  # 一般的な使用例:
  # - 一時ファイルのクリーンアップ
  # - AWS CLIの設定更新
  # - Git リポジトリの同期
  # - 環境変数の設定
  # - 依存関係の更新チェック
  #
  # 使用例:
  # on_start = base64encode(<<-EOF
  #   #!/bin/bash
  #   set -e
  #
  #   # Update Git repository
  #   cd /home/ec2-user/SageMaker
  #   git pull origin main
  #
  #   # Clean up temporary files
  #   rm -rf /tmp/*
  # EOF
  # )
  on_start = base64encode(<<-EOF
    #!/bin/bash
    set -e

    # Configure AWS CLI region
    sudo -u ec2-user -i <<'AWS'
    aws configure set default.region us-east-1
    AWS

    echo "Notebook instance start script completed"
  EOF
  )

  # ==============================================================================
  # リージョン設定
  # ==============================================================================

  # region - (Optional) リソースを管理するリージョン
  # 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用されます
  #
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  #
  # 使用例:
  # region = "us-west-2"
  # region = "ap-northeast-1"

  # ==============================================================================
  # タグ設定
  # ==============================================================================

  # tags - (Optional) リソースに割り当てるタグのマップ
  # プロバイダーのdefault_tags設定ブロックと統合されます
  #
  # ベストプラクティス:
  # - Environment (例: dev, staging, prod)
  # - Project (プロジェクト名)
  # - Owner (所有者/チーム)
  # - CostCenter (コストセンター)
  #
  # 使用例:
  # tags = {
  #   Environment = "production"
  #   Project     = "ml-platform"
  #   ManagedBy   = "terraform"
  # }
  tags = {
    Name        = "example-lifecycle-config"
    Environment = "development"
    ManagedBy   = "terraform"
  }

  # tags_all - (Computed) すべてのタグ（プロバイダーのdefault_tagsを含む）
  # このパラメータは自動的に計算されるため、設定不要です
}

################################################################################
# 出力値
################################################################################

# arn - ライフサイクル設定のARN
output "lifecycle_config_arn" {
  description = "The ARN of the SageMaker Notebook Instance Lifecycle Configuration"
  value       = aws_sagemaker_notebook_instance_lifecycle_configuration.example.arn
}

# name - ライフサイクル設定の名前
output "lifecycle_config_name" {
  description = "The name of the SageMaker Notebook Instance Lifecycle Configuration"
  value       = aws_sagemaker_notebook_instance_lifecycle_configuration.example.name
}

################################################################################
# 使用上の注意事項
################################################################################

# 1. セキュリティ考慮事項:
#    - スクリプトはrootユーザーとして実行されるため、信頼できるプリンシパルにのみ
#      この権限を付与してください
#    - スクリプト内に機密情報（パスワード、APIキーなど）を含めないでください
#    - 機密情報はAWS Secrets ManagerやSystems Manager Parameter Storeを使用
#
# 2. スクリプトのデバッグ:
#    - CloudWatch Logsグループ /aws/sagemaker/NotebookInstances でログを確認
#    - スクリプトに set -e を含めてエラー時に即座に停止
#    - echo文を使用して進捗をログ出力
#
# 3. パッケージインストール:
#    - conda環境を使用してPythonパッケージをインストール
#    - sudo -u ec2-user を使用してec2-userとして実行
#    - デフォルトのconda環境にインストール
#
# 4. 実行時間制限:
#    - 各スクリプトは5分以内に完了する必要があります
#    - 長時間かかる処理は別の方法（Lambda、Step Functionsなど）を検討
#
# 5. 文字数制限:
#    - 各スクリプトは16384文字以内（Base64エンコード前）
#    - 長いスクリプトはS3に保存して取得する方法を検討
#
# 6. ライフサイクル設定の更新:
#    - 既存の設定を更新すると、その設定を使用するすべてのノートブックインスタンスが
#      次回起動時に影響を受けます
#    - 重要な変更前にテスト環境で検証することを推奨
#
# 7. on_createとon_startの使い分け:
#    - on_create: 初回セットアップ、大規模なパッケージインストール
#    - on_start: 設定の更新、軽量な環境チェック、Git同期
#
# 8. 関連リソース:
#    - aws_sagemaker_notebook_instance: このライフサイクル設定を使用するノートブックインスタンス
#    - aws_iam_role: ノートブックインスタンスの実行ロール
#    - aws_cloudwatch_log_group: スクリプトのログを保存するロググループ
#
# 9. 公開リポジトリ:
#    - AWSが管理する一般的なLCCスクリプトの公開リポジトリが利用可能
#    - 参考: https://github.com/aws-samples/amazon-sagemaker-notebook-instance-lifecycle-config-samples
#
# 10. ベストプラクティス:
#     - エラーハンドリングを適切に実装
#     - 冪等性を考慮したスクリプト設計
#     - 適切なログ出力で問題のトラブルシューティングを容易に
#     - スクリプトをバージョン管理システムで管理

################################################################################
# 実践的な使用例
################################################################################

# 例1: カスタムPython環境のセットアップ
# resource "aws_sagemaker_notebook_instance_lifecycle_configuration" "custom_python" {
#   name = "custom-python-env"
#
#   on_create = base64encode(<<-EOF
#     #!/bin/bash
#     set -e
#
#     sudo -u ec2-user -i <<'CONDA'
#     # Create custom conda environment
#     conda create -y -n custom_env python=3.9
#
#     # Activate and install packages
#     source activate custom_env
#     conda install -y jupyter ipykernel
#     conda install -y numpy pandas scikit-learn matplotlib
#     pip install sagemaker boto3
#
#     # Add kernel to Jupyter
#     python -m ipykernel install --user --name custom_env --display-name "Custom Python 3.9"
#     CONDA
#   EOF
#   )
#
#   tags = {
#     Purpose = "Custom Python Environment"
#   }
# }

# 例2: Gitリポジトリの自動同期
# resource "aws_sagemaker_notebook_instance_lifecycle_configuration" "git_sync" {
#   name = "git-sync-config"
#
#   on_start = base64encode(<<-EOF
#     #!/bin/bash
#     set -e
#
#     sudo -u ec2-user -i <<'GIT'
#     cd /home/ec2-user/SageMaker
#
#     # Clone repository if not exists
#     if [ ! -d "my-project" ]; then
#       git clone https://github.com/my-org/my-project.git
#     else
#       cd my-project
#       git pull origin main
#     fi
#     GIT
#   EOF
#   )
#
#   tags = {
#     Purpose = "Git Repository Sync"
#   }
# }

# 例3: AWS CLIとログ設定
# resource "aws_sagemaker_notebook_instance_lifecycle_configuration" "aws_config" {
#   name = "aws-config-setup"
#
#   on_create = base64encode(<<-EOF
#     #!/bin/bash
#     set -e
#
#     sudo -u ec2-user -i <<'AWS'
#     # Configure AWS CLI
#     aws configure set default.region us-east-1
#     aws configure set default.output json
#
#     # Install additional AWS tools
#     pip install awscli --upgrade
#     pip install aws-sam-cli
#     AWS
#   EOF
#   )
#
#   on_start = base64encode(<<-EOF
#     #!/bin/bash
#     set -e
#
#     # Log instance start
#     echo "Instance started at $(date)" >> /home/ec2-user/SageMaker/instance_starts.log
#   EOF
#   )
#
#   tags = {
#     Purpose = "AWS Configuration"
#   }
# }
