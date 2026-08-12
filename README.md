# PCBA 规格书模板

Typst 组件库 + 按产品分目录的规格书。源码进 GitHub，PDF 上 Pages，Notion 只嵌 PDF 链接。

```
lib.typ                    # 通用组件（封面、表格、连接器特写）
fonts/                     # Noto Sans CJK SC
scripts/build-preview.sh   # 本地 / CI 编译 site/
specs/
  SHT1UBA-V1/              # 单板示例
  SHT1MBB-SHT1CBB-V1/      # MBB + CBB 组合示例
.github/workflows/         # push 后自动编译并发布 Pages
.vscode/                   # Tinymist 预览配置
```

## 在哪里编辑？

| 环节 | 做什么 | 用什么 |
|------|--------|--------|
| **写规格书（推荐）** | 改 `.typ`、换 SVG、边改边看 | **Cursor / VS Code + Tinymist** 打开本仓库 |
| **存档 / 协作** | 提交、Review、历史版本 | **GitHub** |
| **对外预览** | 看 PDF，给同事 / 客户 | **Notion embed** → Pages 上的 PDF 固定 URL |
| **不要在这里改** | Notion、GitHub 网页直接改正文 | 改的是 PDF 或看不了 `.typ`，不是源文件 |

**源文件唯一真相在 Git 仓库本地（或 Codespaces）。** 流程：本地编辑 → `git push` → Actions 编译 PDF → Notion 刷新 embed。

## 本地编辑与预览

1. 克隆仓库，用 Cursor 打开根目录
2. 安装扩展 **Tinymist Typst**（`.vscode/extensions.json` 会提示）
3. 打开对应规格书，例如 `specs/SHT1MBB-SHT1CBB-V1/SHT1MBB-SHT1CBB-V1.typ`
4. `Cmd+K V` 打开实时预览

命令行编译：

```bash
typst compile specs/SHT1MBB-SHT1CBB-V1/SHT1MBB-SHT1CBB-V1.typ \
  --root . --font-path fonts
```

## SVG 资源命名

路径均在 `specs/<产品>/assets/`，`BOARD-SVGS` 里用仓库根路径（以 `/` 开头）。

**单板（1 块板）— 4 个 SVG**

| 文件 | 用途 |
|------|------|
| `<型号>-top.svg` | 板图正面（连接器 conn-* 标注） |
| `<型号>-bottom.svg` | 板图背面 |
| `mech_top.svg` | 机械尺寸俯视图 |
| `mech_bottom.svg` | 机械尺寸底视图 |

**组合板（N 块板）— 每块板 4 个，共 4×N 个**

例：MBB + CBB → **8 个 SVG**

| 文件 | 用途 |
|------|------|
| `SHT1MBB-top.svg` / `SHT1MBB-bottom.svg` | MBB 板图正反面 |
| `SHT1CBB-top.svg` / `SHT1CBB-bottom.svg` | CBB 板图正反面 |
| `mech_mbb_top.svg` / `mech_mbb_bottom.svg` | MBB 机械图 |
| `mech_cbb_top.svg` / `mech_cbb_bottom.svg` | CBB 机械图 |

`.typ` 里 `BOARD-SVGS` 只列**板图**四张（组合板把每块板的 top/bottom 都写上）；机械图在正文里 `#image` 引用。连接器在哪张 SVG 里，库会自动从那张提取特写。

Inkscape 导出：每个连接器用 `<rect id="conn-xxx">` 标记；成组接口用 `conn-base` + `conn-base-*` 子 id。

## GitHub Pages 预览

GitHub **不能直接预览 `.typ`**。推送到 `main` / `master` 后，Actions 编译 PDF 并发布。

1. 仓库 **Settings → Pages → Source** 选 **GitHub Actions**
2. 推送后访问：

```
https://<user>.github.io/<repo>/
https://<user>.github.io/<repo>/SHT1MBB-SHT1CBB-V1/SHT1MBB-SHT1CBB-V1.pdf
```

`specs/` 下每个含 `<目录名>.typ` 的子目录都会自动编译。

## Notion 预览

1. Notion 输入 `/embed`
2. 粘贴 Pages PDF 地址，例如：

```
https://<user>.github.io/<repo>/SHT1MBB-SHT1CBB-V1/SHT1MBB-SHT1CBB-V1.pdf
```

推送后约 1–2 分钟 CI 更新同一 URL，Notion 里刷新 embed 即可。Notion **只读 PDF**，规格修改请在本地改 `.typ` 再 push。

## 新增规格书

1. 复制 `specs/SHT1UBA-V1/`（单板）或 `specs/SHT1MBB-SHT1CBB-V1/`（组合）
2. 改 `.typ` 中的公司 / 型号 / 参数 / `BOARD-SVGS`
3. 按上表替换 `assets/` 中 SVG
4. `#import "../../lib.typ": *` 不要改

组合板目录名建议 `型号A-型号B-V1`，封面产品名可用 `型号A + 型号B`。
