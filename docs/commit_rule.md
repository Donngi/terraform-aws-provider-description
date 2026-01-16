# Commit Rule

このリポジトリでは [Conventional Commits](https://www.conventionalcommits.org/) を基本としたコミットルールを採用しています。

## コミットメッセージの形式

```
<type>(<scope>): <subject>

[body]

[footer]
```

### Type（必須）

| Type | 説明 |
|------|------|
| `feat` | 新機能の追加 |
| `fix` | バグ修正 |
| `docs` | ドキュメントのみの変更 |
| `style` | コードの意味に影響しない変更（空白、フォーマット等） |
| `refactor` | バグ修正や機能追加を伴わないコード変更 |
| `test` | テストの追加・修正 |
| `chore` | ビルドプロセスやツールの変更 |

### Scope（任意）

変更対象のスコープを指定します。

| Scope | 説明 |
|-------|------|
| `skill` | スキル定義（SKILL.md, references/） |
| `template` | 生成されたテンプレート（terraform-template/） |
| `docs` | ドキュメント（docs/） |

### Subject（必須）

- 命令形で記述（例: `add`, `fix`, `update`）
- 先頭は小文字
- 末尾にピリオドを付けない
- 50文字以内

### Body（任意）

- 変更の動機や背景を記述
- 72文字で折り返し

### Footer（任意）

- Breaking Changeの記述
- Issue参照

## 例

```
feat(skill): add schema validation step

terraform providers schema -json を使用してプロパティの抜け漏れを検証する
ステップを追加。

Refs #123
```

```
feat(template): add aws_cloudwatch_log_group template

Provider Version 6.28.0 に対応した aws_cloudwatch_log_group の
解説付きテンプレートを追加。
```

```
docs: add commit rule

Conventional Commits を基本としたコミットルールを追加。
```

```
fix(skill): correct attribute classification logic

computed only 属性の判定ロジックを修正。
```
