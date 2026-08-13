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
      "style=\"" + before2 + "fill:#" + color + ";fill-opacity:" + op + after2 + "\"" + m.captures.at(3) + "id=\"" + cid + "\""
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
  let want = conn-cid(base)
  let out = ()
  for m in svg-text.matches(regex("id=\"(conn-[\\w-]+)\"")) {
    let cid = m.captures.at(0)
    if (cid == want or cid.starts-with(want + "-")) and not out.contains(cid) {
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

// 以高亮座子为准裁切
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
  let multi = group and conn-group-ids(svg-text, target-id).len() > 1
  let board = svg-board-bounds(svg-text)

  let near-top = board != none and box.y < board.h * 0.12
  let near-bottom = board != none and (box.y + box.h > board.h * 0.82)
  let near-left = board != none and box.x < board.w * 0.20
  let at-right-edge = board != none and (box.x + box.w > board.w * 0.85)
  let in-right-region = board != none and (box.x > board.w * 0.60)
  // 露出板子左缘；贴顶左侧成组座子仍按整幅 pad 取边距，放大倍率与底部接口一致
  let show-left-edge = board != none and (
    near-left or (near-top and box.x < board.w * 0.50)
  )
  let tight-group = multi and near-top and box.x < board.w * 0.50

  // 横跨大半块板的成组接口宽度本身已够大，减半边距免得画幅过宽；
  // 贴顶左侧的窄成组接口用整幅 pad，viewBox 宽度才与单接口特写落在同一档
  let margin = calc.min(box.w, box.h) * (
    if multi and not tight-group { pad / 2 } else { pad }
  )

  // 贴板边时 padding 往板内偏，避免 viewBox 落到板外大片空白
  let top-pad = if near-top {
    calc.min(margin, box.h * 0.35)
  } else if near-bottom {
    calc.max(margin, box.h * 1.8)
  } else {
    calc.min(margin, box.h * 0.45)
  }
  let bottom-pad = if near-bottom {
    calc.min(margin * 0.15, 4.0)
  } else if near-top {
    calc.max(margin, box.h * 1.2)
  } else {
    calc.max(margin, box.h * 0.55)
  }
  let side-pad = margin
  // 贴右缘座子：右侧 padding 不超出板边，避免 viewBox 右侧留白导致画面偏左
  let pad-left = side-pad
  let pad-right = if board != none and at-right-edge {
    calc.max(3.0, calc.min(side-pad, board.w - (box.x + box.w) + 3.0))
  } else {
    side-pad
  }
  if board != none and show-left-edge {
    pad-left = calc.max(3.0, box.x + 2.0)
  } else if board != none and near-left {
    pad-left = calc.max(3.0, calc.min(side-pad, box.x + 3.0))
  }

  // 统一画幅比例 → 图框等高；宽度由座子尺寸决定
  let mut-vw = calc.max(box.w + pad-left + pad-right, min-w)
  let mut-vh = mut-vw / aspect
  let need-h = box.h + top-pad + bottom-pad
  if mut-vh < need-h {
    mut-vh = need-h
    mut-vw = mut-vh * aspect
  }

  // 锚定高亮区；贴左/贴右时往板内偏，中间座子水平居中
  let cx = box.x + box.w / 2
  let mut-vb-x = if show-left-edge {
    0.0
  } else if near-left {
    calc.max(0.0, box.x - pad-left)
  } else if at-right-edge or in-right-region {
    calc.max(0.0, board.w - mut-vw)
  } else {
    cx - mut-vw / 2
  }
  let mut-vb-y = if near-top {
    calc.max(0.0, box.y - top-pad)
  } else if near-bottom {
    calc.max(0.0, box.y - top-pad)
  } else {
    box.y - top-pad
  }

  // 高亮区必须完整落在 viewBox 内
  if not show-left-edge and box.x - pad-left < mut-vb-x {
    mut-vb-x = calc.max(0.0, box.x - pad-left)
  }
  if box.x + box.w + pad-right > mut-vb-x + mut-vw {
    mut-vw = box.x + box.w + pad-right - mut-vb-x
    mut-vh = mut-vw / aspect
  }
  if box.y - top-pad < mut-vb-y {
    mut-vb-y = calc.max(0.0, box.y - top-pad)
  }
  if box.y + box.h + bottom-pad > mut-vb-y + mut-vh {
    mut-vh = box.y + box.h + bottom-pad - mut-vb-y
    mut-vw = calc.max(mut-vw, mut-vh * aspect)
  }

  // 只压住负原点；右/下允许超出板边留白
  if board != none {
    if mut-vb-x < 0.0 { mut-vb-x = 0.0 }
    if mut-vb-y < 0.0 { mut-vb-y = 0.0 }
    if not show-left-edge and box.x - pad-left < mut-vb-x {
      mut-vb-x = calc.max(0.0, box.x - pad-left)
    }
    if box.y - top-pad < mut-vb-y {
      mut-vb-y = calc.max(0.0, box.y - top-pad)
    }
    if box.x + box.w + pad-right > mut-vb-x + mut-vw {
      mut-vw = box.x + box.w + pad-right - mut-vb-x
    }
    if box.y + box.h + bottom-pad > mut-vb-y + mut-vh {
      mut-vh = box.y + box.h + bottom-pad - mut-vb-y
    }
    if near-bottom and board != none {
      let max-y = board.h + bottom-pad
      if mut-vb-y + mut-vh > max-y {
        mut-vb-y = calc.max(0.0, max-y - mut-vh)
      }
    }
    if mut-vw / mut-vh < aspect {
      mut-vw = mut-vh * aspect
    } else if mut-vw / mut-vh > aspect {
      mut-vh = mut-vw / aspect
    }
    // aspect 调整后再定位一次，避免只往右扩宽导致贴右座子看起来偏左
    if show-left-edge {
      mut-vb-x = 0.0
    } else if near-left {
      mut-vb-x = calc.max(0.0, box.x - pad-left)
    } else if at-right-edge or in-right-region {
      mut-vb-x = calc.max(0.0, board.w - mut-vw)
      if box.x - pad-left < mut-vb-x {
        mut-vb-x = calc.max(0.0, box.x - pad-left)
      }
    } else {
      mut-vb-x = cx - mut-vw / 2
    }
    if box.x + box.w + pad-right > mut-vb-x + mut-vw {
      mut-vw = box.x + box.w + pad-right - mut-vb-x
      mut-vh = mut-vw / aspect
      if at-right-edge or in-right-region {
        mut-vb-x = calc.max(0.0, board.w - mut-vw)
        if box.x - pad-left < mut-vb-x {
          mut-vb-x = calc.max(0.0, box.x - pad-left)
        }
      }
    }
    if not show-left-edge and box.x - pad-left < mut-vb-x {
      mut-vb-x = calc.max(0.0, box.x - pad-left)
    }
    if box.y + box.h + bottom-pad > mut-vb-y + mut-vh {
      mut-vb-y = calc.max(0.0, box.y + box.h + bottom-pad - mut-vh)
    }
  }

  let vb-x = mut-vb-x
  let vb-y = mut-vb-y
  let vw = mut-vw
  let vh = mut-vh

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
      conn-cid(id)
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
