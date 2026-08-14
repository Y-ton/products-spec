// ============================================================
// PCBA 规格书组件库 — 简洁 · 工程可读
// 克制用色，但保留硬件规格书该有的信息密度与结构
// 用法：#import "../../lib.typ": *
// ============================================================

#let ink = rgb("#1a1a1a")   // 标题、强调
#let body-cl = rgb("#3d3d3d")   // 正文、表格内容
#let mute = rgb("#5c5c5c")   // 二级标题、表头
#let faint = rgb("#949494")
#let rule = rgb("#e0e0e0")
#let wash = rgb("#f8f9fa")
#let accent = rgb("#2563eb")
#let caution-cl = rgb("#ca8a04")
// DejaVu Sans Mono 随 Typst 内置，放首位保证本地预览与 CI 出的 PDF 字体一致
#let mono = ("DejaVu Sans Mono", "Menlo", "PT Mono", "Courier New", "PingFang SC")

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

#let svg-board-bounds(svg-text) = {
  let m = svg-text.match(regex("viewBox=\"0 0 ([\\d.]+) ([\\d.]+)\""))
  if m != none {
    (w: float(m.captures.at(0)), h: float(m.captures.at(1)))
  } else {
    none
  }
}

// ── 图纸类插图（机械尺寸、系统框图）───────────────────────────
// scale：相对版心宽度比例；高度随图自适应，超过 max-height 时按高压缩并居中。
// ref-path：与另一张图对齐 PCB 显示尺寸（底视图 viewBox 常比俯视图宽，需单独放大）。
#let plate-fig(path, caption-text, max-height: 200pt, scale: 1.0, ref-path: none) = {
  let effective-scale = scale
  if ref-path != none {
    let ref-vb = svg-board-bounds(read(ref-path))
    let vb = svg-board-bounds(read(path))
    if ref-vb != none and vb != none {
      effective-scale = scale * vb.w / ref-vb.w
    }
  }
  figure(
    layout(size => {
      let w = size.width * effective-scale
      let natural = measure(image(path, width: w)).height
      if natural > max-height {
        align(center, image(path, height: max-height))
      } else {
        align(center, image(path, width: w))
      }
    }),
    caption: caption-text,
  )
}

// 机械尺寸：俯视 / 底视 / 侧视。侧视默认不输出；占位或 SVG 由规格书 #mech-plate-set 开启。
// layout / scale / max-height 等显示参数请在各规格书 .typ 里写；此处仅为未写时的默认值。
//   layout 默认 "row"；scale 默认 none（row→1.0，stack→0.88，相对列宽或版心）
#let mech-plate-set(
  top: none,
  bottom: none,
  side: none,
  side-placeholder: false,
  ref-top: none,
  top-caption: [俯视图尺寸],
  bottom-caption: [底视图尺寸],
  side-caption: [侧视图尺寸],
  side-ph: [侧视图 — Allegro 3D 剖面或 STEP 导出后，替换对应 mech\_side.svg],
  layout: "row",
  max-height: 240pt,
  side-max-height: 180pt,
  scale: none,
  column-gutter: 14pt,
) = {
  let ref = if ref-top != none { ref-top } else { top }
  let show-side = side != none or side-placeholder
  let scale-use = if scale != none {
    scale
  } else if layout == "row" {
    1.0
  } else {
    0.88
  }
  let side-block = if side != none {
    plate-fig(side, side-caption, max-height: side-max-height, scale: scale-use, ref-path: ref)
  } else if side-placeholder {
    figure(
      ph(side-ph, h: 140pt),
      caption: side-caption,
    )
  }

  let n = (if top != none { 1 } else { 0 }) + (if bottom != none { 1 } else { 0 }) + (if show-side { 1 } else { 0 })

  if layout == "row" and n >= 2 {
    grid(
      columns: (1fr,) * n,
      column-gutter: column-gutter,
      ..if top != none {
        (plate-fig(top, top-caption, max-height: max-height, scale: scale-use),)
      } else { () },
      ..if bottom != none {
        (plate-fig(bottom, bottom-caption, max-height: max-height, scale: scale-use, ref-path: ref),)
      } else { () },
      ..if show-side { (side-block,) } else { () },
    )
  } else {
    if top != none {
      plate-fig(top, top-caption, max-height: max-height, scale: scale-use)
      if bottom != none or show-side { v(1em) }
    }
    if bottom != none {
      plate-fig(bottom, bottom-caption, max-height: max-height, scale: scale-use, ref-path: ref)
      if show-side { v(1em) }
    }
    if show-side {
      side-block
    }
  }
}

// ── 表格 — 全文档统一列宽，同类型表格纵向对齐 ────────────────
#let col-2 = (1.1fr, 2.9fr)
#let col-4 = (0.55fr, 0.75fr, 2.2fr, 0.7fr)
#let col-4-iface = (1.2fr, 0.55fr, 1.0fr, 1.85fr)  // 名称 · Pin 数 · 类型 · 功能（无位号）
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

// 连接器总览 — 无位号列（名称 · Pin 数 · 类型 · 功能）
#let iface-list-tbl(..rows) = tbl(
  ("名称", "Pin 数", "类型", "功能"),
  cols: col-4-iface,
  ..rows,
)

// 天线（射频）接口 — 不套引脚表：同轴无引脚编号，射频看阻抗/频段而非电平
// 列宽沿用 col-5，与引脚表逐列对齐
#let ant-tbl(..rows) = tbl(
  ("接口", "连接器", "阻抗", "工作频段", "说明"),
  cols: col-5,
  ..rows,
)

// 射频控制接口 — 同样是同轴座无引脚编号，但看的是方向和电平而非阻抗/频段
#let ctl-tbl(..rows) = tbl(
  ("接口", "连接器", "方向", "电平", "说明"),
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

// 连接器 id：.typ 里写什么，SVG 里就找什么（精确匹配）。
// 成组接口另含 id 以「base-」开头的子项（如 cbb-ctl → cbb-ctl-l）。
// conn-overlay-re 仅识别板图里的连接器高亮矩形，与查找 id 无关。
#let conn-overlay-re() = regex("id=\"((?:conn|mbb|cbb)-[\\w-]+)\"")

#let resolve-svg-id(svg-text, target-id) = {
  let want = str(target-id)
  if svg-text.contains("id=\"" + want + "\"") { want } else { none }
}

#let svg-has-id(svg-text, target-id) = {
  resolve-svg-id(svg-text, target-id) != none
}

#let conn-id-is-target(cid, target-id) = {
  let want = str(target-id)
  cid == want or cid.starts-with(want + "-")
}

// 在一张 SVG 里按优先级找连接器 id，返回 SVG 中的实际 id
#let first-conn-id(svg-text, ids) = {
  let found = none
  for id in ids {
    if found == none {
      found = resolve-svg-id(svg-text, id)
    }
  }
  found
}

// 将板图 SVG 中连接器 id 高亮目标；其余设为透明（不挡图纸）
#let highlight-svg(svg-text, target-id, hi: "2563eb", hi-opacity: "0.38") = {
  let is-target(cid) = conn-id-is-target(cid, target-id)
  let step1 = svg-text.replace(
    regex("style=\"([^\"]*?)fill:#([0-9A-Fa-f]{6})([^\"]*)\"(\\s+)id=\"((?:conn|mbb|cbb)-[\\w-]+)\""),
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
      "style=\"" + before2 + "fill:#" + color + ";fill-opacity:" + op + after2 + "\"" + m.captures.at(3) + "id=\"" + cid + "\""
    },
  )
  step1.replace(
    regex("id=\"((?:conn|mbb|cbb)-[\\w-]+)\"([^>]*?)fill=\"#([0-9A-Fa-f]{6})\""),
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

// 累加祖先 <g> 上的 transform。Inkscape 图层常带 translate，元素自身坐标并非可视坐标。
// 只统计目标元素之前仍未闭合的分组；已闭合的兄弟分组不影响它。
#let ancestor-transform(before) = {
  let stack = ()
  for m in before.matches(regex("<g\\b[^>]*>|</g\\s*>")) {
    if m.text.starts-with("</g") {
      if stack.len() > 0 { stack = stack.slice(0, stack.len() - 1) }
    } else if not m.text.ends-with("/>") {
      let t = m.text.match(regex("translate\\(\\s*(-?[\\d.]+)\\s*(?:[,\\s]\\s*(-?[\\d.]+))?\\s*\\)"))
      let f = m.text.match(regex("matrix\\(\\s*-1\\s*,\\s*0\\s*,\\s*0\\s*,\\s*1\\s*,\\s*(-?[\\d.]+)\\s*,\\s*0\\s*\\)"))
      stack = stack + ((
        tx: if t != none { float(t.captures.at(0)) } else { 0.0 },
        ty: if t != none and t.captures.at(1) != none { float(t.captures.at(1)) } else { 0.0 },
        flip: if f != none { float(f.captures.at(0)) } else { none },
      ),)
    }
  }
  let tx = 0.0
  let ty = 0.0
  let flip = none
  for g in stack {
    tx = tx + g.tx
    ty = ty + g.ty
    if g.flip != none { flip = g.flip }
  }
  (tx: tx, ty: ty, flip: flip)
}

// 读取 conn-* 矩形几何；属性顺序不限。叠加祖先分组的平移/水平翻转，换算到可视坐标
#let conn-visual-box(svg-text, target-id) = {
  let cid = resolve-svg-id(svg-text, target-id)
  if cid == none { return none }
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

  let tf = ancestor-transform(before)
  let (vx, vy) = if tf.flip != none {
    (tf.flip - (x + w) + tf.tx, y + tf.ty)
  } else {
    (x + tf.tx, y + tf.ty)
  }
  (x: vx, y: vy, w: w, h: h)
}

// Typst 的 str() 对负数用 U+2212 减号而非 ASCII '-'，直接拼进 SVG 会让属性解析失败，
// 渲染器静默退回默认视图。靠板子左/上边缘的连接器坐标为负，必然踩到。
#let svg-num(v) = str(v).replace("\u{2212}", "-")

// 同组的全部 id：conn-X 及 conn-X-*。Inkscape 复制对象会自动加 -7/-l 之类后缀，
// 天线这类由多个座子组成的接口天然是一组。
#let conn-group-ids(svg-text, base) = {
  let out = ()
  for m in svg-text.matches(conn-overlay-re()) {
    let cid = m.captures.at(0)
    if conn-id-is-target(cid, base) and not out.contains(cid) {
      out = out + (cid,)
    }
  }
  out
}

// 整组的外接矩形。highlight-svg 本来就按组高亮，缩放取整组才不会把同组的座子裁掉。
#let conn-group-box(svg-text, target-id) = {
  let boxes = ()
  for cid in conn-group-ids(svg-text, target-id) {
    let b = conn-visual-box(svg-text, cid)
    if b != none { boxes = boxes + (b,) }
  }
  if boxes.len() == 0 { return none }
  let x0 = boxes.at(0).x
  let y0 = boxes.at(0).y
  let x1 = boxes.at(0).x + boxes.at(0).w
  let y1 = boxes.at(0).y + boxes.at(0).h
  for b in boxes {
    x0 = calc.min(x0, b.x)
    y0 = calc.min(y0, b.y)
    x1 = calc.max(x1, b.x + b.w)
    y1 = calc.max(y1, b.y + b.h)
  }
  (x: x0, y: y0, w: x1 - x0, h: y1 - y0)
}

// 连接器特写裁切，按 PCB 实际尺寸自适应。优先级：
// 1. 连接器完整露出  2. PCB 铺满图框（定比例）  3. 尽量露出最近板边
#let zoom-to-conn(
  svg-text,
  target-id,
  pad: 2.8,
  min-w: 95.0,
  aspect: 3.4,
  group: false,
) = {
  let box = if group {
    conn-group-box(svg-text, target-id)
  } else {
    conn-visual-box(svg-text, target-id)
  }
  if box == none { return svg-text }
  let board = svg-board-bounds(svg-text)
  let conn-r = box.x + box.w
  let conn-b = box.y + box.h
  let cx = box.x + box.w / 2
  let cy = box.y + box.h / 2

  // 画幅：优先整板宽度铺满图框；座子比这更大时才放大画幅（仍保持比例）
  let vw = if board != none { board.w } else { calc.max(box.w, min-w) }
  let vh = vw / aspect
  if box.h > vh {
    vh = box.h
    vw = vh * aspect
  }
  if box.w > vw {
    vw = box.w
    vh = vw / aspect
  }

  let vb-x = 0.0
  let vb-y = 0.0
  if board != none {
    // 水平：能铺满则贴左（左右板边都在画幅里）；画幅更宽时仍保证座子完整
    vb-x = if vw <= board.w {
      0.0
    } else if cx < board.w / 2 {
      0.0
    } else {
      calc.max(conn-r - vw, board.w - vw)
    }
    if box.x < vb-x { vb-x = box.x }
    if conn-r > vb-x + vw { vb-x = conn-r - vw }

    // 垂直：先贴最近的顶/底边；若会裁掉座子再平移，座子完整优先于板边
    if cy > board.h / 2 {
      vb-y = board.h - vh
    } else {
      vb-y = 0.0
    }
    if box.y < vb-y { vb-y = box.y }
    if conn-b > vb-y + vh { vb-y = conn-b - vh }
    if vh <= board.h {
      if vb-y < 0.0 { vb-y = 0.0 }
      if vb-y + vh > board.h { vb-y = board.h - vh }
      if box.y < vb-y { vb-y = box.y }
      if conn-b > vb-y + vh { vb-y = conn-b - vh }
    } else if vb-y > 0.0 {
      vb-y = 0.0
    }
  } else {
    vb-x = cx - vw / 2
    vb-y = box.y
  }

  let vb = svg-num(vb-x) + " " + svg-num(vb-y) + " " + svg-num(vw) + " " + svg-num(vh)
  svg-text
    .replace(regex("viewBox=\"[^\"]*\""), "viewBox=\"" + vb + "\"")
    .replace(
      regex("id=\"svg1\"\\s+width=\"[^\"]*\"\\s+height=\"[^\"]*\""),
      "id=\"svg1\"\n   width=\"" + svg-num(vw) + "\"\n   height=\"" + svg-num(vh) + "\"",
    )
}

#let conn-closeup-svg(svg-text, target-id, hi: "2563eb", hi-opacity: "0.38", group: false) = {
  zoom-to-conn(
    highlight-svg(svg-text, target-id, hi: hi, hi-opacity: hi-opacity),
    target-id,
    group: group,
  )
}

// 统一框高：单接口图固定 200pt；成组宽扁图按宽度自然高度收紧，避免下方大片空白
#let conn-fig-panel(svg-text, target-id, height: 200pt, label: none, group: false) = {
  let svg = bytes(conn-closeup-svg(svg-text, target-id, group: group))
  block(
    width: 100%,
    {
      if label != none [
        #set text(size: 8pt, fill: faint)
        #label
        #v(4pt)
      ]
      layout(size => {
        let inset = 8pt
        let natural = measure(image(svg, width: size.width - 2 * inset)).height + 2 * inset
        block(
          width: 100%,
          height: if natural < height { auto } else { height },
          fill: wash,
          stroke: 0.35pt + rule,
          inset: inset,
          align(center + horizon, image(svg, width: 100%)),
        )
      })
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
  if fid.ends-with("-back") or fid.ends-with("-bottom") or fid.ends-with("-bot") or p.contains("back") or p.contains("bot") or p.contains("Bottom") {
    [背面]
  } else if fid.ends-with("-front") or fid.ends-with("-top") or p.contains("front") or p.contains("top") or p.contains("Top") {
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

// 在多张板图里查找连接器：哪张含有该 id，就从哪张提取。
// 路径相对 lib.typ；跨目录请用仓库根路径（以 / 开头）。
#let find-conn-hits(id, paths, group: false) = {
  let hits = ()
  let seen = ()
  for path in paths {
    let text = read(path)
    // 成组时 base 允许是"虚"的：SVG 里只有 conn-base-* 子项、没有同名元素也算命中，
    // 否则 Inkscape 里只建了子项就整张图都找不着
    let found-id = if group and conn-group-ids(text, id).len() > 0 {
      id
    } else {
      first-conn-id(text, conn-id-candidates(id))
    }
    if found-id != none {
      let key = path + "::" + found-id
      if not seen.contains(key) {
        seen = seen + (key,)
        hits = hits + ((
          path: path,
          text: text,
          id: found-id,
          label: svg-side-label(path, found-id),
        ),)
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
  group: false,
) = {
  let caption = if title != none [
    #title 局部特写
  ] else if desc != none [
    #desc
  ] else [
    局部特写
  ]

  let paths = flatten-svg-paths(svg-paths, svg-path, svg-front, svg-back)
  let hits = find-conn-hits(id, paths, group: group)
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
        group: group,
      )),
    )
  } else if hits.len() == 1 {
    conn-fig-panel(hits.at(0).text, hits.at(0).id, height: height, group: group)
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
          #text(size: 10.5pt, weight: "bold", fill: ink)[#name]
          #if detail != none [
            #h(0.15em)
            #text(size: 9pt, fill: faint)[#detail]
          ]
        ],
      )
    } else [
      #text(size: 10.5pt, weight: "bold", fill: ink)[#name]
      #if detail != none [
        #h(0.15em)
        #text(size: 9pt, fill: faint)[#detail]
      ]
    ]
  ]
}

// 各类接口段只有配的表不同，标题和特写图的组装完全一样
#let conn-section-body(
  make-tbl,
  id,
  ref,
  name,
  detail,
  fig-desc,
  fig-no,
  svg-path,
  svg-front,
  svg-back,
  svg-paths,
  group,
  rows,
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
    group: group,
  )
  // 图注与紧随其后的 Pin 表拉开距离，否则图注上下留白接近，看着像属于表格
  v(0.7em)
  make-tbl(..rows)
  v(0.5em)
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
  group: false,
  ..pin-rows,
) = conn-section-body(
  pin-tbl, id, ref, name, detail, fig-desc, fig-no,
  svg-path, svg-front, svg-back, svg-paths, group, pin-rows,
)

// 天线接口：与 conn-section 同构，但配天线表而非引脚表
#let ant-section(
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
  group: true,
  ..ant-rows,
) = conn-section-body(
  ant-tbl, id, ref, name, detail, fig-desc, fig-no,
  svg-path, svg-front, svg-back, svg-paths, group, ant-rows,
)

// 射频控制接口：配方向/电平表
#let ctl-section(
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
  group: true,
  ..ctl-rows,
) = conn-section-body(
  ctl-tbl, id, ref, name, detail, fig-desc, fig-no,
  svg-path, svg-front, svg-back, svg-paths, group, ctl-rows,
)

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
  #set text(font: ("Noto Sans CJK SC", "PingFang SC", "Helvetica Neue", "Arial"))
  #let meta-cols = (1fr, 1fr, 1fr, 1fr)

  // 顶栏 — 与底部元数据同色
  #grid(
    columns: (1fr, auto),
    align: horizon,
    text(size: 9pt, weight: "medium", fill: ink)[#company],
    text(size: 9pt, weight: "medium", fill: ink)[产品规格书],
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
        column-gutter: 1.4em,
        align: horizon,
        ..highlights.map(((k, val)) => stack(
          spacing: 0.28cm,
          text(size: 7.5pt, fill: faint)[#k],
          text(font: mono, size: 10pt, weight: "medium", fill: ink)[#val],
        )),
      )
    ]
  ]

  #v(1.35fr)

  // 文档元数据 — 各栏按自身宽度排列，中间以 1fr 撑开：间距相等且两端贴齐版心。
  // 等宽列会让末栏内容短时右侧空出一块，故不用 meta-cols。
  #let meta-items = (
    ("文档编号", doc-no),
    ("硬件版本", hw-version),
    ("文档版本", doc-version),
    ("发布日期", date),
  )
  #let meta-cell(k, val) = stack(
    spacing: 0.26cm,
    text(size: 7.5pt, fill: faint, tracking: 0.08em)[#k],
    text(font: mono, size: 9.5pt, weight: "medium", fill: ink)[#val],
  )
  #hairline()
  #v(0.5cm)
  #grid(
    columns: (auto, 1fr) * (meta-items.len() - 1) + (auto,),
    ..meta-items.map(it => meta-cell(it.at(0), it.at(1))).intersperse([]),
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
    font: ("Noto Sans CJK SC", "PingFang SC", "Helvetica Neue", "Arial"),
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
          [#product 产品规格书], [#version],
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
          [#company], [第 #counter(page).display() 页],
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
  // == 与上方的间距明显大于与下方，保持「标题归属下文」的分组感
  show heading.where(level: 2): it => {
    block(width: 100%, above: 1.9em, below: 0.85em, sticky: false)[
      #text(size: 10.5pt, weight: "bold", fill: ink)[#it.body]
    ]
  }
  set figure(numbering: "1", supplement: [图])
  set figure.caption(separator: [  ])
  // 图注居中：图片多为居中或分栏摆放，左对齐会让说明文字脱离图本身
  show figure.caption: it => {
    set align(center)
    set text(size: 8.5pt, fill: faint)
    v(3pt)
    it
  }
  body
}
