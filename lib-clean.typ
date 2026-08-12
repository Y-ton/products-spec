// ============================================================
// PCBA 规格书组件库 — 简洁 · 工程可读
// 克制用色，但保留硬件规格书该有的信息密度与结构
// 用法：#import "lib-clean.typ": *
// ============================================================

#let ink = rgb("#1a1a1a")   // 标题、强调
#let body-cl = rgb("#3d3d3d")   // 正文、表格内容
#let mute = rgb("#5c5c5c")   // 二级标题、表头
#let faint = rgb("#949494")
#let rule = rgb("#e0e0e0")
#let wash = rgb("#f8f9fa")
#let accent = rgb("#2563eb")
#let caution-cl = rgb("#ca8a04")
#let mono = ("Menlo", "PT Mono", "Courier New", "PingFang SC")

#let hairline() = line(length: 100%, stroke: 0.4pt + rule)

// 单元格内强制换行（可写在同一行：…#br()续行内容）
#let br = linebreak

#let pin-text(body) = text(font: mono, size: 8.5pt, fill: body-cl)[#body]
#let sig-text(body) = text(font: mono, size: 8.5pt, weight: "medium", fill: body-cl)[#body]

// ── 提示框 — 红 / 蓝 / 琥珀 三档 ─────────────────────────────
#let callout(title: none, accent: ink, body) = block(
  width: 100%,
  inset: (left: 12pt, y: 6pt),
  stroke: (left: 2pt + accent, rest: none),
)[
  #if title != none [
    #text(size: 9pt, weight: "bold", fill: accent)[#title]
    #v(3pt)
  ]
  #par(leading: 0.68em)[#text(size: 9.5pt, fill: mute)[#body]]
]

#let warn(body) = callout(title: "警告", accent: rgb("#dc2626"), body)
#let note(body) = callout(title: "注意", accent: accent, body)
#let caution(body) = block(
  width: 100%,
  fill: rgb("#fffbeb"),
  inset: (left: 12pt, y: 6pt, right: 0pt),
  stroke: (left: 2pt + caution-cl, rest: none),
)[
  #text(size: 9pt, weight: "bold", fill: caution-cl)[提示]
  #v(3pt)
  #par(leading: 0.68em)[#text(size: 9.5pt, fill: mute)[#body]]
]

#let ph(desc, h: 170pt) = block(
  width: 100%,
  height: h,
  stroke: 0.35pt + rule,
  inset: 0pt,
)[
  #align(center + horizon)[
    #text(size: 9pt, fill: faint)[#desc]
  ]
]

// ── 表格 — 全文档统一列宽，同类型表格纵向对齐 ────────────────
#let col-2 = (1.1fr, 2.9fr)
#let col-4 = (0.55fr, 0.75fr, 2.2fr, 0.7fr)
#let col-5 = (0.7fr, 1.15fr, 0.55fr, 0.95fr, 1.65fr)  // 位号/Pin · 名称/信号 · 数量/方向 · 类型/电平 · 功能/说明
#let col-6 = (1.15fr, 0.68fr, 0.68fr, 0.68fr, 0.68fr, 0.68fr)

#let tbl(headers, cols: auto, align-cols: none, ..rows) = {
  let n = headers.len()
  let widths = if cols == auto {
    if n == 2 { col-2 } else if n == 4 { col-4 } else if n == 5 { col-5 } else if n == 6 { col-6 } else { (1fr,) * n }
  } else { cols }
  // 统一顶对齐：多行单元格时，同行其他列与首行水平齐平
  let cell-align = if align-cols != none { align-cols } else { top + left }
  let cell(c) = table.cell(align: cell-align, {
    set par(leading: 0.66em)
    set text(size: 9pt, fill: body-cl)
    c
  })
  block(width: 100%, {
    table(
      columns: widths,
      stroke: (x, y) => (
        top: none,
        bottom: if y == 0 { 0.5pt + ink } else { 0.35pt + rule },
        left: none,
        right: none,
      ),
      inset: (x: 5.5pt, y: 5.5pt),
      align: cell-align,
      table.header(..headers.map(h => table.cell(align: cell-align, text(
        size: 8pt,
        weight: "bold",
        fill: mute,
        tracking: 0.2pt,
      )[#h]))),
      ..rows
        .pos()
        .map(r => {
          if type(r) == array {
            r.map(c => cell(c))
          } else {
            cell(r)
          }
        }),
    )
  })
}

#let spec-tbl(..rows) = tbl(
  ("参数", "规格"),
  cols: col-2,
  align-cols: top + left,
  ..rows,
)

// 关键参数 — 要点列表（行距紧凑）
#let key-points(..items) = block(width: 100%, {
  for item in items.pos() {
    grid(
      columns: (0.55em, 1fr),
      column-gutter: 0.45em,
      align: top,
      text(size: 10pt, fill: faint)[-], par(leading: 0.62em)[#text(size: 10pt, fill: body-cl)[#item]],
    )
    v(0.28em)
  }
})

#let conn-list-tbl(..rows) = tbl(
  ("位号", "名称", "Pin 数", "类型", "功能"),
  cols: col-5,
  ..rows,
)

#let pin-tbl(..rows) = tbl(
  ("Pin", "信号", "方向", "电平", "说明"),
  cols: col-5,
  ..rows
    .pos()
    .map(r => {
      if type(r) == array and r.len() >= 5 {
        (
          pin-text(r.at(0)),
          sig-text(r.at(1)),
          text(size: 9pt, fill: body-cl)[#r.at(2)],
          pin-text(r.at(3)),
          text(size: 9pt, fill: body-cl)[#r.at(4)],
        )
      } else if type(r) == array {
        r.map(c => text(size: 9pt, fill: body-cl)[#c])
      } else { r }
    }),
)

#let elec-tbl(..rows) = tbl(
  ("参数", "符号", "最小", "典型", "最大", "单位"),
  cols: col-6,
  ..rows,
)

// ── 连接器区块：标题 → 局部特写（高亮）→ Pin 表 ──────────────
#let conn-badge(ref) = text(font: mono, size: 9pt, weight: "bold", fill: ink)[#ref]

#let conn-cid(target-id) = if str(target-id).starts-with("conn-") {
  str(target-id)
} else {
  "conn-" + str(target-id)
}

#let svg-has-id(svg-text, target-id) = {
  svg-text.contains("id=\"" + conn-cid(target-id) + "\"")
}

// 在一张 SVG 里按优先级找连接器 id（不含 conn- 前缀）
#let first-conn-id(svg-text, ids) = {
  let found = none
  for id in ids {
    if found == none and svg-has-id(svg-text, id) {
      found = id
    }
  }
  found
}

// 将板图 SVG 中 id="conn-*" 高亮目标连接器；其余设为透明（不挡图纸）
// 兼容 fill="#rrggbb" 属性，以及 style="fill:#rrggbb;..."（可写在 id 前）
#let highlight-svg(svg-text, target-id, hi: "2563eb", hi-opacity: "0.38") = {
  let want = conn-cid(target-id)
  let is-target(cid) = cid == want or cid.starts-with(want + "-")
  let step1 = svg-text.replace(
    regex("style=\"([^\"]*?)fill:#([0-9A-Fa-f]{6})([^\"]*)\"(\\s+)id=\"(conn-[\\w-]+)\""),
    m => {
      let cid = m.captures.at(4)
      let before = m.captures.at(0)
      let after = m.captures.at(2)
      // 去掉原有 fill-opacity，按是否高亮重写
      let after2 = after.replace(regex(";?fill-opacity:[\\d.]+"), "")
      let before2 = before.replace(regex(";?fill-opacity:[\\d.]+"), "")
      let (color, op) = if is-target(cid) {
        (hi, hi-opacity)
      } else {
        ("000000", "0")
      }
      (
        "style=\""
          + before2
          + "fill:#"
          + color
          + ";fill-opacity:"
          + op
          + after2
          + "\""
          + m.captures.at(3)
          + "id=\""
          + cid
          + "\""
      )
    },
  )
  step1.replace(
    regex("id=\"(conn-[\\w-]+)\"([^>]*?)fill=\"#([0-9A-Fa-f]{6})\""),
    m => {
      let cid = m.captures.at(0)
      let pre = m.captures.at(1)
      if is-target(cid) {
        "id=\"" + cid + "\"" + pre + "fill=\"#" + hi + "\" fill-opacity=\"" + hi-opacity + "\""
      } else {
        "id=\"" + cid + "\"" + pre + "fill=\"none\" fill-opacity=\"0\""
      }
    },
  )
}

// 读取 conn-* 矩形几何；属性顺序不限。若父级有 matrix(-1,0,0,1,TX,0) 水平翻转，换算到可视坐标
#let conn-visual-box(svg-text, target-id) = {
  let cid = conn-cid(target-id)
  let parts = svg-text.split("id=\"" + cid + "\"")
  if parts.len() < 2 { return none }
  let before = parts.at(0)
  let after-head = parts.at(1).split(">").at(0)
  let tag = before.split("<").at(-1) + "id=\"" + cid + "\"" + after-head
  let get(attr) = {
    let m = tag.match(regex(attr + "=\"([\\d.-]+)\""))
    if m != none { float(m.captures.at(0)) } else { none }
  }
  let w = get("width")
  let h = get("height")
  let x = get("x")
  let y = get("y")
  if w == none or h == none or x == none or y == none { return none }

  let flip = before.match(regex("transform=\"matrix\\(-1,\\s*0,\\s*0,\\s*1,\\s*([\\d.]+),\\s*0\\)\""))
  let (vx, vy) = if flip != none {
    let tx = float(flip.captures.at(0))
    (tx - (x + w), y)
  } else {
    (x, y)
  }
  (x: vx, y: vy, w: w, h: h)
}

// 以高亮连接器为中心放大：改 viewBox，画面外裁掉，连接器本身留足边距不裁切
#let zoom-to-conn(svg-text, target-id, pad: 1.25, min-w: 95.0, min-h: 65.0, aspect: 1.65) = {
  let box = conn-visual-box(svg-text, target-id)
  if box == none { return svg-text }

  let margin = calc.max(box.w, box.h) * pad
  let vw = calc.max(box.w + 2 * margin, min-w)
  let vh = calc.max(box.h + 2 * margin, min-h)
  // 按画面比例扩展较短边，保持连接器居中
  if vw / vh < aspect {
    vw = vh * aspect
  } else if vw / vh > aspect {
    vh = vw / aspect
  }

  let cx = box.x + box.w / 2
  let cy = box.y + box.h / 2
  let vb-x = cx - vw / 2
  let vb-y = cy - vh / 2

  // 保证连接器完整落在 viewBox 内（含边距，不被裁切）
  let safe = calc.max(box.w, box.h) * 0.6
  if vb-x > box.x - safe { vb-x = box.x - safe }
  if vb-y > box.y - safe { vb-y = box.y - safe }
  if vb-x + vw < box.x + box.w + safe { vb-x = box.x + box.w + safe - vw }
  if vb-y + vh < box.y + box.h + safe { vb-y = box.y + box.h + safe - vh }

  let vb = str(vb-x) + " " + str(vb-y) + " " + str(vw) + " " + str(vh)
  // 同步根节点 width/height，避免仍按整板比例留白，导致高亮看起来不居中
  svg-text
    .replace(regex("viewBox=\"[^\"]*\""), "viewBox=\"" + vb + "\"")
    .replace(
      regex("id=\"svg1\"\\s+width=\"[^\"]*\"\\s+height=\"[^\"]*\""),
      "id=\"svg1\"\n   width=\"" + str(vw) + "\"\n   height=\"" + str(vh) + "\"",
    )
}

#let conn-closeup-svg(svg-text, target-id, hi: "2563eb", hi-opacity: "0.38") = {
  zoom-to-conn(highlight-svg(svg-text, target-id, hi: hi, hi-opacity: hi-opacity), target-id)
}

#let conn-fig-panel(svg-text, target-id, height: 200pt, label: none) = {
  block(
    width: 100%,
    {
      if label != none [
        #set text(size: 8pt, fill: faint)
        #label
        #v(4pt)
      ]
      block(
        width: 100%,
        height: height,
        fill: wash,
        stroke: 0.35pt + rule,
        inset: 8pt,
        align(center + horizon, image(
          bytes(conn-closeup-svg(svg-text, target-id)),
          width: 100%,
        )),
      )
    },
  )
}

#let conn-id-candidates(id) = (
  id + "-front",
  id + "-top",
  id + "-back",
  id + "-bottom",
  id + "-bot",
  id,
)

#let svg-side-label(path, found-id) = {
  let p = str(path)
  let fid = str(found-id)
  if (
    fid.ends-with("-back")
      or fid.ends-with("-bottom")
      or fid.ends-with("-bot")
      or p.contains("back")
      or p.contains("bot")
      or p.contains("Bottom")
  ) {
    [背面]
  } else if (
    fid.ends-with("-front") or fid.ends-with("-top") or p.contains("front") or p.contains("top") or p.contains("Top")
  ) {
    [正面]
  } else {
    none
  }
}

#let flatten-svg-paths(svg-paths, svg-path, svg-front, svg-back) = {
  let out = ()
  if svg-paths != none {
    let items = if type(svg-paths) == array { svg-paths } else { (svg-paths,) }
    for p in items {
      if p != none { out = out + (p,) }
    }
  }
  if svg-front != none { out = out + (svg-front,) }
  if svg-back != none { out = out + (svg-back,) }
  if svg-path != none { out = out + (svg-path,) }
  out
}

// 在多张板图里查找连接器：哪张含有该 id，就从哪张提取
#let find-conn-hits(id, paths) = {
  let hits = ()
  let seen = ()
  for path in paths {
    let text = read(path)
    let found-id = first-conn-id(text, conn-id-candidates(id))
    if found-id != none {
      let key = path + "::" + found-id
      if not seen.contains(key) {
        seen = seen + (key,)
        hits = (
          hits
            + (
              (
                path: path,
                text: text,
                id: found-id,
                label: svg-side-label(path, found-id),
              ),
            )
        )
      }
    }
  }
  hits
}

#let conn-fig(
  id: "",
  desc: none,
  svg-path: none,
  svg-front: none,
  svg-back: none,
  svg-paths: none,
  height: 200pt,
  fig-no: none,
  title: none,
) = {
  let caption = if title != none [
    #title 局部特写
  ] else if desc != none [
    #desc
  ] else [
    局部特写
  ]

  let paths = flatten-svg-paths(svg-paths, svg-path, svg-front, svg-back)
  let hits = find-conn-hits(id, paths)
  let show-labels = hits.len() > 1

  let body = if hits.len() >= 2 {
    grid(
      columns: (1fr,) * hits.len(),
      gutter: 12pt,
      ..hits.map(hit => conn-fig-panel(
        hit.text,
        hit.id,
        height: height,
        label: if show-labels { hit.label },
      )),
    )
  } else if hits.len() == 1 {
    conn-fig-panel(hits.at(0).text, hits.at(0).id, height: height)
  } else {
    ph(
      if desc != none { desc } else [
        局部放大特写 — 当前连接器高亮，其余置灰
      ],
      h: height,
    )
  }
  figure(body, caption: caption)
}

#let conn-header(ref: none, name: [], detail: none) = {
  v(0.8em)
  block(width: 100%, inset: (y: 4pt))[
    #if ref != none {
      grid(
        columns: (2.2em, 1fr),
        column-gutter: 0.6em,
        align: (left, left),
        conn-badge(ref),
        [
          #text(size: 11pt, weight: "bold", fill: ink)[#name]
          #if detail != none [
            #h(0.15em)
            #text(size: 9pt, fill: faint)[#detail]
          ]
        ],
      )
    } else [
      #text(size: 11pt, weight: "bold", fill: ink)[#name]
      #if detail != none [
        #h(0.15em)
        #text(size: 9pt, fill: faint)[#detail]
      ]
    ]
  ]
}

#let conn-section(
  id: "",
  ref: none,
  name: [],
  detail: none,
  fig-desc: none,
  fig-no: none,
  svg-path: none,
  svg-front: none,
  svg-back: none,
  svg-paths: none,
  ..pin-rows,
) = {
  conn-header(ref: ref, name: name, detail: detail)
  conn-fig(
    id: id,
    desc: fig-desc,
    svg-path: svg-path,
    svg-front: svg-front,
    svg-back: svg-back,
    svg-paths: svg-paths,
    fig-no: fig-no,
    title: name,
  )
  pin-tbl(..pin-rows)
  v(0.5em)
}

// ── 封面 ─────────────────────────────────────────────────────
#let cover(
  company: "",
  product: "",
  subtitle: "",
  doc-no: "",
  hw-version: "",
  doc-version: "",
  date: "",
  summary: "",
  highlights: (),
) = page(
  margin: (top: 2.2cm, bottom: 2cm, left: 2.4cm, right: 2.4cm),
  header: none,
  footer: none,
)[
  #set text(font: ("PingFang SC", "Noto Sans CJK SC", "Helvetica Neue", "Arial"))
  #let meta-cols = (1.45fr, 1fr, 0.85fr, 1fr)

  // 顶栏
  #grid(
    columns: (1fr, auto),
    align: horizon,
    text(size: 9pt, fill: faint)[#company], text(size: 9pt, fill: mute)[产品规格书],
  )
  #v(8pt)
  #block(width: 100%, height: 1.2pt, fill: ink)

  #v(1fr)

  // 主标题
  #text(font: mono, size: 26pt, weight: "bold", fill: ink, tracking: -0.6pt)[#product]
  #if subtitle != "" [
    #v(0.4cm)
    #text(size: 12pt, fill: mute)[#subtitle]
  ]
  #if summary != "" [
    #v(0.9cm)
    #block(width: 82%)[
      #set par(leading: 0.9em)
      #text(size: 10pt, fill: mute)[#summary]
    ]
  ]

  // 关键参数 — 紧跟简介
  #if highlights.len() > 0 [
    #v(1.4cm)
    #block(
      width: 100%,
      fill: wash,
      inset: (x: 16pt, y: 16pt),
    )[
      #grid(
        columns: meta-cols,
        column-gutter: 1.1em,
        ..highlights.map(((k, val)) => stack(
          spacing: 0.28cm,
          text(size: 7.5pt, fill: faint)[#k],
          text(font: mono, size: 10pt, weight: "medium", fill: ink)[#val],
        )),
      )
    ]
  ]

  #v(1.35fr)

  // 文档元数据 — 与上方参数列宽对齐
  #hairline()
  #v(0.55cm)
  #grid(
    columns: meta-cols,
    column-gutter: 1.1em,
    stack(
      spacing: 0.22cm,
      text(size: 7.5pt, fill: faint)[文档编号],
      text(font: mono, size: 9pt, fill: ink)[#doc-no],
    ),
    stack(
      spacing: 0.22cm,
      text(size: 7.5pt, fill: faint)[硬件版本],
      text(font: mono, size: 9pt, fill: ink)[#hw-version],
    ),
    stack(
      spacing: 0.22cm,
      text(size: 7.5pt, fill: faint)[文档版本],
      text(font: mono, size: 9pt, fill: ink)[#doc-version],
    ),
    stack(
      spacing: 0.22cm,
      text(size: 7.5pt, fill: faint)[发布日期],
      text(font: mono, size: 9pt, fill: ink)[#date],
    ),
  )
]

// ── 文档信息条 — 与封面参数区同风格 ───────────────────────────
#let doc-info(..items) = {
  v(0.6em)
  hairline()
  v(0.45em)
  grid(
    columns: (1fr,) * calc.min(items.pos().len(), 4),
    column-gutter: 1.2em,
    ..items
      .pos()
      .map(((k, val)) => stack(
        spacing: 0.08cm,
        text(size: 8pt, fill: faint)[#k],
        text(size: 9.5pt, fill: ink)[#val],
      )),
  )
  v(0.8em)
}

// ── 修订记录 ─────────────────────────────────────────────────
#let revision-tbl(..rows) = {
  heading(level: 1)[修订记录]
  tbl(("版本", "日期", "变更说明", "作者"), cols: col-4, ..rows)
  v(0.8em)
}

// ── 正文样式 ─────────────────────────────────────────────────
#let setup-clean(
  company: "",
  product: "",
  version: "",
  body,
) = {
  set text(
    font: ("PingFang SC", "Noto Sans CJK SC", "Helvetica Neue", "Arial"),
    size: 10.5pt,
    fill: body-cl,
    lang: "zh",
  )
  set par(justify: true, leading: 0.76em, spacing: 0.5em)
  set page(
    paper: "a4",
    margin: (top: 2.3cm, bottom: 2.1cm, left: 2.6cm, right: 2.6cm),
    header: context {
      if counter(page).get().first() > 1 [
        #set text(size: 8pt, fill: faint)
        #grid(
          columns: (1fr, auto),
          [#company · #product], [#version],
        )
        #v(5pt)
        #hairline()
      ]
    },
    footer: context {
      if counter(page).get().first() > 1 [
        #hairline()
        #v(5pt)
        #set text(size: 8pt, fill: faint)
        #grid(
          columns: (1fr, auto),
          [#product 产品规格书], [第 #counter(page).display() 页],
        )
      ]
    },
  )
  set heading(numbering: none)
  // 用 block 的 above/below：相邻时取较大值，且不会被 weak 间距吃掉
  // 避免「= 后紧跟 ==」打印时贴在一起
  show heading.where(level: 1): it => {
    block(width: 100%, above: 1.8em, below: 1.15em, sticky: false)[
      #text(size: 13pt, weight: "bold", fill: ink)[#it.body]
    ]
  }
  // == 与上方拉开、与下方内容收紧，形成「标题贴着表格」的分组感
  show heading.where(level: 2): it => {
    block(width: 100%, above: 1.75em, below: 0.3em, sticky: false)[
      #text(size: 10.5pt, weight: "bold", fill: mute)[#it.body]
    ]
  }
  set figure(numbering: "1", supplement: [图])
  set figure.caption(separator: [  ])
  show figure.caption: it => {
    set align(left)
    set text(size: 8.5pt, fill: faint)
    v(3pt)
    it
  }
  body
}
