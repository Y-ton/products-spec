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
  subtitle: [分离式CX677XK载板组合套件],
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

*#PRODUCT* 为主控板与CX677XK载板组合方案。MBB 负责核心处理与Wi-Fi/GNSS通信，CBB主要是CX677XK载板，两块板通过板间连接器配套使用；其组合尺寸为63*65mm，支持终端设备通过2.4GHz WiFi接入网络。同时可支持北斗/GPS定位，非常适合于便携应用。

== 产品外观

#figure(
  ph("产品外观总览 — MBB + CBB 组合（待补充实拍或渲染图）", h: 200pt),
  caption: [产品外观总览（MBB + CBB）],
)

== 主要特征

#key-points(
  [支持宸芯CX677XK系列模块],
  [板载500mW 2.4GHz WiFi],
  [支持北斗/GPS定位],
  [网口、UART 等通信接口],

  [小面积63*65mm，便于集成到各类终端设备中],
)

== 系统框图

#plate-fig(
  "/specs/SHT1MBB-SHT1CBB-V1/assets/system-block.svg",
  [系统功能框图 — MBB 主控、CBB 载板],
  max-height: 180pt,
)

#pagebreak()

= 技术规格

== 基础参数

#spec-tbl(
  [天线类型], [1 x WiFi MMCX 天线接口#br()1 x 北斗/GPS MMCX 天线接口],
  [宸芯模块], [1 x 串口+无线通信状态指示灯（10 pin 1.0 mm 间距连接器）#br()1 x USB（4 pin 1.0 mm 间距连接器）],
  [以太网口], [2 x 100 Mbps 以太网口（8 pin 1.0 mm 间距连接器）],
  [其他接口], [1 x 上电开关 + 2 x 指示灯（5 pin 1.0 mm 间距连接器）#br()1 x 音频接口（7 pin 1.0 mm 间距连接器）#br()1 x 5 个 GPIO 接口（7 pin 1.0 mm 间距连接器）#br()1 x 调试串口 + 1 x TTL UART + 1 x RS232 UART（9 pin 1.0 mm 间距连接器）],
  [指示灯], [2 x 宸芯模块通信网口指示灯#br()3 x 宸芯模块无线通信状态指示灯（红 / 绿 / 蓝）],
  [按键], [1 x 宸芯模块复位 #br()1 x 宸芯模块下载#br()1 x 宸芯模块开机],
  [供电方式], [9-48 V（1.0 mm 间距 6 Pin 插座）],
  [组合尺寸], [63 mm × 65 mm × 19 mm],
  [温度范围], [存储温度：-40 °C ～ +85 °C#br()工作温度：-20 °C ～ +65 °C],
)

== 无线参数

#spec-tbl(
  [工作频率], [Wi-Fi：2412-2462 MHz#br()北斗/GPS：1559-1577 MHz],
  [信道带宽], [Wi-Fi：20 MHz],
  [输出功率], [Wi-Fi：0.5 W],
  [接收灵敏度], [Wi-Fi：-90 dBm],
  [调制方式], [OFDM BPSK / QPSK / 16-QAM / 64-QAM],
  [传输速率], [Wi-Fi：最大 40 Mbps],
  [模块无线参数], [见宸芯模块规格书],
)

== 软件特性

#spec-tbl(
  [Bootloader], [U-Boot],
  [Linux 内核], [3.18.19],
  [有线网络], [IP 地址可配置#br()子网掩码可配置],
  [Wi-Fi 特性], [输出功率可调节；支持 AP 模式；ESSID 可配置；支持自适应速率模式；支持 WMM/802.11e QoS；支持距离优化；支持 MAC 地址过滤；连接状态显示；WPA/WPA2/WEP 加密；隐藏 ESSID],
  [北斗/GPS], [支持网络透传北斗/GPS 原始定位数据],
  [管理特征], [支持网页管理；支持 SSH 安全管理；导入/导出配置信息；恢复出厂配置；在线更新固件],
)

= 接口定义

== 主控板连接器总览

// 以下总览与引脚表为模板占位；请按实际 CBB/MBB 接口修改，并在 SVG 中标注对应 conn- id。
#iface-list-tbl(
  [PWR], [6], [1.00 mm 1×4], [供电],
  [SW/LED], [5], [1.00 mm 1×5], [上电控制 · 指示灯],
  [UART], [9], [1.00 mm 1×9], [调试串口 · TTL UART · RS232 UART],
  [ETH], [8], [1.00 mm 1×8], [以太网口],
  [GPIO], [7], [1.00 mm 1×7], [GPIO],
  [AUDIO], [7], [1.00 mm 1×7], [音频接口],
  [ANT  Wi-Fi & GNSS], [1], [MMCX], [Wi-Fi 和 北斗/GPS 天线],
)

== 载板连接器总览

// 以下总览与引脚表为模板占位；请按实际 CBB/MBB 接口修改，并在 SVG 中标注对应 conn- id。
#iface-list-tbl(
  [UART LED], [10], [1.00 mm 1×10], [UART · LED],
  [USB], [4], [1.00 mm 1×4], [USB],
  [ANT], [2], [MMCX], [载板天线],
  [功放控制], [3], [MMCX · I-PEX], [载板外接射频功放控制],
)
==

#conn-section(
  id: "mbb-pwr",
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
  id: "mbb-sw",
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
  id: "mbb-uart",
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
  id: "mbb-eth",
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
  id: "mbb-gpio",
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
  id: "mbb-audio",
  name: [AUDIO 接口],
  fig-desc: [AUDIO 区域局部特写],
  svg-paths: BOARD-SVGS,
  [1], [MIC_IN], [I], [模拟（2.475 V 偏置）], [MIC 输入],
  [2], [AGND], [—], [—], [模拟信号地],
  [3], [HS_OUT], [O], [模拟], [耳机输出],
  [4], [SPK+], [O], [模拟（BTL）], [扬声器 +],
  [5], [SPK-], [O], [模拟（BTL）], [扬声器 - ，*不可接地*],
  [6], [PTT_CTRL], [I], [3.3 V], [PTT 收发切换],
  [7], [AGND], [—], [—], [模拟信号地],
)

#conn-section(
  id: "cbb-muart",
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
  id: "cbb-usb",
  name: [模块 USB 接口],
  fig-desc: [模块 USB 区域局部特写],
  svg-paths: BOARD-SVGS,
  [1], [USB_5V], [I], [5 V], [模块 USB 5V],
  [2], [USB_D-], [I/O], [USB 2.0 差分], [模块 USB2.0 D-],
  [3], [USB_D+], [I/O], [USB 2.0 差分], [模块 USB2.0 D+],
  [4], [USB_GND], [—], [—], [模块 USB 地],
)

#ant-section(
  id: "mbb-rf",
  name: [北斗/GPS 天线接口],
  fig-desc: [天线区域局部特写],
  svg-paths: BOARD-SVGS,
  group: true,
  [Wi-Fi], [MMCX], [50 Ω], [2412-2462 MHz], [MMCX 内孔形式],
  [GNSS], [MMCX], [50 Ω], [1559-1577 MHz], [MMCX 内孔形式，3.3 V 有源馈电],
)

#ant-section(
  id: "cbb-mant",
  name: [模块 RF 天线接口],
  fig-desc: [天线区域局部特写],
  svg-paths: BOARD-SVGS,
  group: true,
  [ANT_1], [MMCX], [50 Ω], [1420-1529 MHz，566-678 MHz], [MAIN ANT，MMCX 内孔形式],
  [ANT_2], [MMCX], [50 Ω], [1420-1529 MHz，566-678 MHz], [SUB ANT，MMCX 内孔形式],
)

#ctl-section(
  id: "cbb-ctl",
  name: [模块外接功放控制接口],
  fig-desc: [功放控制区域局部特写],
  svg-paths: BOARD-SVGS,
  group: true,
  [CTL_H], [MMCX/I-PEX], [O], [1.8 V], [输出高电平使能 PA，低电平使能 LNA，*连接器二选一*],
  [CTL_L], [MMCX], [O], [1.8 V], [输出低电平使能 PA，高电平使能 LNA],
)

#pagebreak()

= 机械尺寸

// 机械图 — 在下方 #mech-plate-set 里按本产品调整（各规格书互不影响，改 lib.typ 不必动）：
//   layout: "row"      俯视/底视一排并列（不写 layout 时 lib 默认也是 row）
//   layout: "stack"    各图一行
//   scale: 0.9        在本 .typ 写缩放；不写 scale 则用 lib 默认（row→1.0，stack→0.88）
//   max-height: 260pt  单图最大高度（可选）
//   侧视 — 不要：不写 side；占位：side-placeholder: true；有图：side: "路径"

//== 组合总成

// 两板扣合后的总高度与侧向轮廓 → assets/mech_assy_side.svg
// 仅侧视一张图时 layout 无效，自动单列显示
#mech-plate-set(
  side-placeholder: false,
  side-caption: [组合侧视图 — MBB 与 CBB 配套安装],
  side-ph: [组合侧视图 — 扣合后剖面，替换 assets/mech_assy_side.svg],
//  side: "/specs/SHT1MBB-SHT1CBB-V1/assets/mech_assy_side.svg",
)

== MBB 主控板

#mech-plate-set(
  top: "/specs/SHT1MBB-SHT1CBB-V1/assets/mech_mbb_top.svg",
  bottom: "/specs/SHT1MBB-SHT1CBB-V1/assets/mech_mbb_bottom.svg",
  layout: "row",
//  layout: "stack",
//  scale: 0.9,
//  max-height: 260pt,
  top-caption: [MBB 俯视图],
  bottom-caption: [MBB 底视图],
//  side-placeholder: true,
  side-caption: [MBB 侧视图],
  side-ph: [MBB 侧视图 — assets/mech_mbb_side.svg],
//  side: "/specs/SHT1MBB-SHT1CBB-V1/assets/mech_mbb_side.svg",
)


== CBB 载板

#mech-plate-set(
  top: "/specs/SHT1MBB-SHT1CBB-V1/assets/mech_cbb_top.svg",
  bottom: "/specs/SHT1MBB-SHT1CBB-V1/assets/mech_cbb_bottom.svg",
  layout: "row",
//  layout: "stack",
//  scale: 0.9,
//  max-height: 260pt,
  top-caption: [CBB 俯视图],
  bottom-caption: [CBB 底视图],
//  side-placeholder: true,
  side-caption: [CBB 侧视图],
  side-ph: [CBB 侧视图 — assets/mech_cbb_side.svg],
//  side: "/specs/SHT1MBB-SHT1CBB-V1/assets/mech_cbb_side.svg",
)

#pagebreak()

= 使用须知

+ *组合使用*：MBB 与 CBB 须配套连接后上电，请勿单独对 CBB 加载非设计工况。
+ *供电*：推荐 15W 以上适配器。
+ *ESD*：接口已加 TVS 保护，操作时仍建议佩戴防静电手环。
+ *散热*：漏铜区域应使用散热片或散热器，以保证设备稳定安全运行，否则可能导致设备损坏。

#v(1.5em)
#hairline()
#v(0.5em)
#text(size: 8pt, fill: faint)[
  本文档参数基于设计目标及典型测试条件，实际产品可能因批次略有差异。
  #COMPANY 保留修改规格的权利，恕不另行通知。
]
