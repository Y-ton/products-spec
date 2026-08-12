#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SITE="$ROOT/site"
cd "$ROOT"

rm -rf "$SITE"
mkdir -p "$SITE"

specs=()
for spec_dir in specs/*/; do
  [ -d "$spec_dir" ] || continue
  name="$(basename "$spec_dir")"
  typ="$spec_dir${name}.typ"
  if [ ! -f "$typ" ]; then
    echo "skip $name: missing $typ" >&2
    continue
  fi
  specs+=("$name")
  mkdir -p "$SITE/$name"
  echo "compile $typ"
  typst compile "$typ" "$SITE/$name/${name}.pdf" --root "$ROOT" --font-path "$ROOT/fonts"
  cat > "$SITE/$name/index.html" <<EOF
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${name} 规格书</title>
  <style>
    html, body { margin: 0; height: 100%; background: #f4f4f5; }
    iframe { border: 0; width: 100%; height: 100%; }
  </style>
</head>
<body>
  <iframe src="./${name}.pdf" title="${name} PDF"></iframe>
</body>
</html>
EOF
done

{
  echo '<!DOCTYPE html>'
  echo '<html lang="zh-CN"><head><meta charset="utf-8">'
  echo '<meta name="viewport" content="width=device-width, initial-scale=1">'
  echo '<title>PCBA 规格书预览</title>'
  echo '<style>
    body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
           max-width: 720px; margin: 48px auto; padding: 0 20px; color: #18181b; }
    h1 { font-size: 22px; font-weight: 650; }
    p { color: #52525b; line-height: 1.6; }
    a { color: #2563eb; }
    ul { padding-left: 1.2em; }
    li { margin: 10px 0; }
  </style></head><body>'
  echo '<h1>PCBA 规格书预览</h1>'
  echo '<p>每次推送到 GitHub 后自动编译。Notion 可嵌入下方 PDF 链接。</p>'
  echo '<ul>'
  for name in "${specs[@]}"; do
    echo "<li><a href=\"./${name}/\">${name}</a> · <a href=\"./${name}/${name}.pdf\">PDF</a></li>"
  done
  echo '</ul></body></html>'
} > "$SITE/index.html"

echo "built ${#specs[@]} spec(s) -> $SITE"
