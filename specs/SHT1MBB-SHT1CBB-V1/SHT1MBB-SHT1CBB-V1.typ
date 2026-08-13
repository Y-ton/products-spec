// ============================================================
// SHT1MBB + SHT1CBB 组合规格书（V1）
// 编译：typst compile specs/SHT1MBB-SHT1CBB-V1/SHT1MBB-SHT1CBB-V1.typ
// ============================================================
#import "../../lib.typ": *

#let COMPANY = "无锡星汉电子技术有限公司"
#let PRODUCT = "SHT1MBB + SHT1CBB"
#let DOC_NO  = "SHT1MBB-SHT1CBB"
#let HW_VER  = "HW V1.0"
#let DOC_VER = "Rev A"

// 板图池：每块板各正、反面 SVG，find-conn-hits 会自动搜到哪张用哪张
#let BOARD-SVGS = (
  "/specs/SHT1MBB-SHT1CBB-V1/assets/SHT1MBB-top.svg",
  "/specs/SHT1MBB-SHT1CBB-V1/assets/SHT1MBB-bottom.svg",
  "/specs/SHT1MBB-SHT1CBB-V1/assets/SHT1CBB-top.svg",
  "/specs/SHT1MBB-SHT1CBB-V1/assets/SHT1CBB-bottom.svg",
)

#cover(
  company: COMPANY,
  product: PRODUCT,
  subtitle: [MBB 主控板 + CBB 载板组合套件],
  doc-no: DOC_NO,
  hw-version: HW_VER,
  doc-version: DOC_VER,
  date: "2026-08-12",
  summary: [

  ],
)

#show: body => setup-clean(
  company: COMPANY,
  product: PRODUCT,
  version: DOC_VER,
  body,
)

#pagebreak()

= 产品概述

== 功能简介

*#PRODUCT* 为 MBB 主控板与 CBB 载板组合方案（HW V1.0）。MBB 负责核心处理与射频/通信，CBB 提供对外接口与机械安装；两块板通过板间连接器配套使用。

== 产品外观

#figure(
  ph("产品外观总览 — MBB + CBB 组合（待补充实拍或渲染图）", h: 200pt),
  caption: [产品外观总览（MBB + CBB）],
)

== 主要特征

#key-points(
  [MBB 主控板 + CBB 载板分体设计，便于维护与升级],
  [板间配套连接器，组合后形成完整对外接口],
  [接口定义见下文；板图 SVG 中标注 conn- 前缀 id 后自动生成局部特写],
)

== 系统框图

#plate-fig(
  "/specs/SHT1MBB-SHT1CBB-V1/assets/system-block.svg",
  [系统功能框图 — MBB 主控、CBB 载板与对外通信接口],
  max-height: 220pt,
)

#pagebreak()

= 技术规格

== 基础参数

#spec-tbl(
  [产品型号], [SHT1MBB（主控板）+ SHT1CBB（载板）],
  [硬件版本], [V1.0],
  [结构], [MBB 与 CBB 板间配套连接],
  [尺寸], [待补充],
  [温度范围], [待补充],
)

== 软件特性

#spec-tbl(
  [说明], [软件特性随 MBB 主控方案而定，待补充],
)

= 接口定义

== 连接器总览

// 以下总览与引脚表为模板占位；请按实际 CBB/MBB 接口修改，并在 SVG 中标注对应 conn- id。
#iface-list-tbl(
  [PWR], [6], [1.00 mm 1×4], [供电],
  [SW/LED], [5], [1.00 mm 1×5], [上电控制 · 指示灯],
  [UART], [9], [1.00 mm 1×9], [调试串口 · TTL UART · RS232 UART],
  [ETH], [8], [1.00 mm 1×8], [以太网口],
  [GPIO], [7], [1.00 mm 1×7], [GPIO],
  [AUDIO], [7], [1.00 mm 1×7], [音频接口],
  [UART LED - 模块], [10], [1.00 mm 1×10], [UART · LED],
  [USB - 模块], [4], [1.00 mm 1×4], [USB],
  [ANT - Wi-Fi & GNSS], [1], [MMCX], [Wi-Fi & 北斗/GPS 天线],
  [ANT - 模块RF], [2], [MMCX], [模块天线],
  [功放控制], [3], [MMCX · I-PEX], [模块外接射频功放控制],
)

#conn-section(
  id: "conn-pwr",
  name: [供电接口],
  fig-desc: [供电区域局部特写],
  svg-paths: BOARD-SVGS,
  [1], [V+], [I], [9-48 V], [供电电源正极],
  [2], [V+], [I], [9-48 V], [供电电源正极],
  [3], [V+], [I], [9-48 V], [供电电源正极],
  [4], [GND], [—], [—], [供电电源负极],
  [5], [GND], [—], [—], [供电电源负极],
  [6], [GND], [—], [—], [供电电源负极],
)

#conn-section(
  id: "conn-sw",
  name: [SW/LED 接口],
  fig-desc: [SW/LED 区域局部特写],
  svg-paths: BOARD-SVGS,
  [1], [Enable], [O], [—], [电源使能，与 pin2 短接],
  [2], [Enable], [I], [—], [电源使能，与 pin1 短接],
  [3], [3.3V], [O], [3.3 V], [外接系统指示灯电源],
  [4], [GPIO22], [O], [3.3 V], [系统指示灯],
  [5], [GPIO21], [O], [3.3 V], [系统指示灯],
)

#conn-section(
  id: "conn-uart",
  name: [UART 接口],
  fig-desc: [UART 区域局部特写],
  svg-paths: BOARD-SVGS,
  [1], [UART_SIN], [I], [3.3 V], [主控调试串口 RXD],
  [2], [UART_SOUT], [O], [3.3 V], [主控调试串口 TXD],
  [3], [GND], [—], [—], [信号地],
  [4], [U_RXD_0], [I], [3.3 V], [USB 转串口 RXD - ttyUSB0],
  [5], [U_TXD_0], [O], [3.3 V], [USB 转串口 TXD - ttyUSB0],
  [6], [GND], [—], [—], [信号地],
  [7], [3.3V], [O], [3.3 V], [对外供电],
  [8], [U_RXD_2], [I], [±5.4 V（RS-232）], [USB 转串口 RXD - ttyUSB2],
  [9], [U_TXD_2], [O], [±5.4 V（RS-232）], [USB 转串口 TXD - ttyUSB2],
)

#conn-section(
  id: "conn-eth",
  name: [ETH 接口],
  fig-desc: [ETH 区域局部特写],
  svg-paths: BOARD-SVGS,
  [1], [ETH_RXD4+], [I], [IEEE 802.3], [以太网口 RXD4+],
  [2], [ETH_RXD4-], [I], [IEEE 802.3], [以太网口 RXD4-],
  [3], [ETH_TXD4+], [O], [IEEE 802.3], [以太网口 TXD4+],
  [4], [ETH_TXD4-], [O], [IEEE 802.3], [以太网口 TXD4-],
  [1], [ETH_RXD0+], [I], [IEEE 802.3], [以太网口 RXD0+],
  [2], [ETH_RXD0-], [I], [IEEE 802.3], [以太网口 RXD0-],
  [3], [ETH_TXD0+], [O], [IEEE 802.3], [以太网口 TXD0+],
  [4], [ETH_TXD0-], [O], [IEEE 802.3], [以太网口 TXD0-],
)

#conn-section(
  id: "conn-gpio",
  name: [GPIO 接口],
  fig-desc: [GPIO 区域局部特写],
  svg-paths: BOARD-SVGS,
  [1], [GPIO13], [I/O], [3.3 V], [GPIO13],
  [2], [GPIO14], [I/O], [3.3 V], [GPIO14],
  [3], [GPIO15], [I/O], [3.3 V], [GPIO15],
  [4], [GND], [—], [—], [信号地],
  [5], [GPIO16], [I/OD], [3.3 V], [GPIO16，内部上拉 10K],
  [6], [GPIO17], [I/OD], [3.3 V], [GPIO17，内部无上拉],
)

#conn-section(
  id: "conn-audio",
  name: [AUDIO 接口],
  fig-desc: [AUDIO 区域局部特写],
  svg-paths: BOARD-SVGS,
  [1], [MIC_IN], [I], [模拟（2.475 V 偏置）], [MIC 输入],
  [2], [AGND], [—], [—], [模拟信号地],
  [3], [HS_OUT], [O], [模拟], [耳机输出],
  [4], [SPK+], [O], [模拟（BTL）], [扬声器 +],
  [5], [SPK-], [O], [模拟（BTL）], [扬声器 -，*不可接地*],
  [6], [PTT_CTRL], [I], [3.3 V], [PTT 收发切换],
  [7], [AGND], [—], [—], [模拟信号地],
)

#conn-section(
  id: "conn-muart",
  name: [模块 UART · LED 接口],
  fig-desc: [模块 UART 区域局部特写],
  svg-paths: BOARD-SVGS,
  [1], [UART0_RXD], [I], [3.3 V], [模块串口 UART0_RXD],
  [2], [UART1_TXD], [O], [3.3 V], [模块串口 UART0_TXD],
  [3], [GND], [—], [—], [信号地],
  [4], [COM_UART_RX], [I], [3.3 V], [模块默认串口 RXD],
  [5], [COM_UART_TX], [O], [3.3 V], [模块默认串口 TXD],
  [6], [GND], [—], [—], [信号地],
  [7], [3.3V_TST], [O], [3.3 V], [模块独立电源，供外接 LED],
  [8], [LED_VIBR], [O], [3.3 V], [链路/信号强度指示灯，蓝色],
  [9], [LED_SINKER], [O], [3.3 V], [异常指示灯，红色],
  [10], [LED_VFLASH], [O], [3.3 V], [建链指示灯，绿色],
)

#conn-section(
  id: "conn-musb",
  name: [模块 USB 接口],
  fig-desc: [模块 USB 区域局部特写],
  svg-paths: BOARD-SVGS,
  [1], [USB_5V], [I], [5 V], [模块 USB 5V],
  [2], [USB_D-], [I/O], [USB 2.0 差分], [模块 USB2.0 D-],
  [3], [USB_D+], [I/O], [USB 2.0 差分], [模块 USB2.0 D+],
  [4], [USB_GND], [—], [—], [模块 USB 地],
)

#ant-section(
  id: "conn-rf",
  name: [北斗/GPS 天线接口],
  fig-desc: [天线区域局部特写],
  svg-paths: BOARD-SVGS,
  [Wi-Fi], [MMCX], [50 Ω], [2412-2462 MHz], [MMCX 内孔形式],
  [GNSS], [MMCX], [50 Ω], [1559-1577 MHz], [MMCX 内孔形式，3.3 V 有源馈电],
)

#ant-section(
  id: "conn-mant",
  name: [模块 RF 天线接口],
  fig-desc: [天线区域局部特写],
  svg-paths: BOARD-SVGS,
  [ANT_1], [MMCX], [50 Ω], [1420-1529 MHz，566-678 MHz], [MAIN ANT，MMCX 内孔形式],
  [ANT_2], [MMCX], [50 Ω], [1420-1529 MHz，566-678 MHz], [SUB ANT，MMCX 内孔形式],
)

#ctl-section(
  id: "conn-ctl",
  name: [模块外接功放控制接口],
  fig-desc: [功放控制区域局部特写],
  svg-paths: BOARD-SVGS,
  [CTL_H], [MMCX/I-PEX], [O], [1.8 V], [输出高电平使能 PA，低电平使能 LNA，*连接器二选一*],
  [CTL_L], [MMCX], [O], [1.8 V], [输出低电平使能 PA，高电平使能 LNA],
)

#pagebreak()

= 机械尺寸

== 组合总成

// 两板扣合后的总高度与侧向轮廓 → assets/mech_assy_side.svg
#mech-plate-set(
  side-placeholder: true,
  side-caption: [组合侧视图 — MBB 与 CBB 配套安装],
  side-ph: [组合侧视图 — 扣合后剖面，替换 assets/mech_assy_side.svg],
)

== MBB 主控板

#mech-plate-set(
  top: "/specs/SHT1MBB-SHT1CBB-V1/assets/mech_mbb_top.svg",
  bottom: "/specs/SHT1MBB-SHT1CBB-V1/assets/mech_mbb_bottom.svg",
  side-placeholder: true,
  top-caption: [MBB 俯视图（待更新）],
  bottom-caption: [MBB 底视图（待更新）],
  side-caption: [MBB 侧视图（待更新）],
  side-ph: [MBB 侧视图 — 替换 assets/mech_mbb_side.svg],
)

== CBB 载板

#mech-plate-set(
  top: "/specs/SHT1MBB-SHT1CBB-V1/assets/mech_cbb_top.svg",
  bottom: "/specs/SHT1MBB-SHT1CBB-V1/assets/mech_cbb_bottom.svg",
  side-placeholder: true,
  top-caption: [CBB 俯视图（待更新）],
  bottom-caption: [CBB 底视图（待更新）],
  side-caption: [CBB 侧视图（待更新）],
  side-ph: [CBB 侧视图 — 替换 assets/mech_cbb_side.svg],
)

= 使用须知

+ *组合使用*：MBB 与 CBB 须配套连接后上电，请勿单独对 CBB 加载非设计工况。
+ *供电*：按 CBB 载板标注电压与功率选用适配器。
+ *ESD*：操作时建议佩戴防静电手环。

#v(1.5em)
#hairline()
#v(0.5em)
#text(size: 8pt, fill: faint)[
  本文档参数基于设计目标及典型测试条件，实际产品可能因批次略有差异。
  #COMPANY 保留修改规格的权利，恕不另行通知。
]
