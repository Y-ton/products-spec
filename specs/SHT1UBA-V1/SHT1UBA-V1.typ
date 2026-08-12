// ============================================================
// SHT1UBA-V1 产品规格书
// 编译：typst compile specs/SHT1UBA-V1/SHT1UBA-V1.typ
// ============================================================
#import "../../lib.typ": *

#let COMPANY = "无锡星汉电子技术有限公司"
#let PRODUCT = "SHT1UBA"
#let DOC_NO  = "SHT1UBA"
#let HW_VER  = "HW V1.0"
#let DOC_VER = "Rev A"

// 板图池（路径相对仓库根，以 / 开头）。连接器在哪张图里，就从哪张自动提取。
#let BOARD-SVGS = (
  "/specs/SHT1UBA-V1/assets/SHT1UBA-top.svg",
  "/specs/SHT1UBA-V1/assets/SHT1UBA-bottom.svg",
)

#cover(
  company: COMPANY,
  product: PRODUCT,
  subtitle: "一体化CX677XK载板",
  doc-no: DOC_NO,
  hw-version: HW_VER,
  doc-version: DOC_VER,
  date: "2026-08-06",
  summary: [

  ],
  //highlights: (
    //("主控", "CX677XK"),
    //("供电", "USB-C 5 V"),
  //("IO 电平", "3.3 V LVTTL"),
    //("尺寸", "115 × 62 mm"),
  //)
)

#show: body => setup-clean(
  company: COMPANY,
  product: PRODUCT,
  version: DOC_VER,
  body,
)

//#revision-tbl(
//  [Rev A], [2026-08-06], [初始版本发布], [Ton],
//)

#pagebreak()

= 产品概述

== 功能简介

*#PRODUCT* 此产品为高集成度、高性能网络处理载板，集成宸芯 CX677XK 系列模块，尺寸仅为 110×65 mm，并支持手机、电脑等终端设备通过 2.4GHz WiFi 接入网络。同时可支持北斗/GPS 定位，双百兆网口。

== 产品外观

#figure(
  image("/specs/SHT1UBA-V1/assets/product-overview.jpg", width: 70%),
  caption: [产品外观总览],
)

== 主要特征

#key-points(
  [支持宸芯CX677XK系列模块],
  [板载 2.4GHz WiFi],
  [支持北斗/GPS定位],
  [网口、UART等通信接口],
  [音频接口],
)

== 系统框图

#let block-diagram-frame(path, caption-text) = figure(
  block(
    width: 100%,
    height: 220pt,
    align(center + horizon, image(path, width: 100%, height: 100%, fit: "contain")),
  ),
  caption: caption-text,
)

#block-diagram-frame(
  "/specs/SHT1UBA-V1/assets/system-block.svg",
  [系统功能框图 — 主芯片/模块与对外通信接口],
)

//== 技术参数

//#spec-tbl(
  //[无线协议], [Wi-Fi 802.11 b/g/n + BLE 5.0],
  //[Flash / SRAM], [4 MB / 400 KB],
  //[供电方式], [USB-C 5 V，或外部 3.3～5.5 V],
  //[IO 电平], [3.3 V LVTTL，单 Pin ≤ 12 mA],
  //[工作温度], [−20 °C ～ +70 °C（商业级）],
  //[PCB], [2 层 FR-4，1.6 mm 厚],
  //[尺寸], [25.4 mm × 48.3 mm × 8.5 mm（含 USB-C）],
//)


//= 外观与接口

//#grid(
  //columns: (1fr, 1fr),
  //gutter: 14pt,
  //figure(ph("正面视图 — USB-C · 天线 · GPIO", h: 155pt), caption: [正面视图]),
  //figure(ph("背面视图 — Flash · LDO · 接地", h: 155pt), caption: [背面视图]),
//)

//#figure(
  //ph("接口分布图 — 标注 J1～J4 位置（SVG 连接器高亮）", h: 175pt),
  //caption: [接口分布],
//)

= 机械尺寸

//== 外形尺寸

#let mech-frame(path, caption-text) = figure(
  block(
    width: 100%,
    height: 200pt,
    align(center + horizon, image(path, width: 100%, height: 100%, fit: "contain")),
  ),
  caption: caption-text,
)

#grid(
  columns: (1fr, 1fr),
  gutter: 14pt,
  mech-frame("/specs/SHT1UBA-V1/assets/mech_top.svg", [俯视图尺寸]),
  mech-frame("/specs/SHT1UBA-V1/assets/mech_bottom.svg", [底视图尺寸]),
)

//#spec-tbl(
  //[PCB 长度 (L)], [48.3 mm ± 0.2 mm],
  //[PCB 宽度 (W)], [25.4 mm ± 0.2 mm],
  //[PCB 厚度], [1.6 mm ± 0.15 mm],
  //[最高高度 (H)], [8.5 mm（USB-C 连接器）],
  //[GPIO 排针间距], [2.54 mm（2×10）],
  //[重量], [约 8 g（含排针）],
//)

#pagebreak()

= 技术规格

== 基础参数

#spec-tbl(
  [天线类型], [1 x WiFi MMCX 天线接口#br()1 x 北斗/GPS MMCX 天线接口],
  [宸芯模块], [1 x 串口+无线通信状态指示灯（10 pin 1.0 mm 间距连接器）#br()1 x USB（4 pin 1.0 mm 间距连接器）],
  [以太网口], [2 x 100 Mbps 以太网口（8 pin 1.0 mm 间距连接器）],
  [其他接口], [1 x 上电开关 + 2 x 指示灯（5 pin 1.0 mm 间距连接器）#br()1 x 音频接口（7 pin 1.0 mm 间距连接器）#br()1 x 5 个 GPIO 接口（7 pin 1.0 mm 间距连接器）#br()1 x 调试串口 + 1 x TTL UART + 1 x RS232 UART（9 pin 1.0 mm 间距连接器）],
  [指示灯], [2 x 宸芯模块通信网口指示灯#br()3 x 宸芯模块指示灯（红 / 绿 / 蓝）],
  [按键], [1 x 宸芯模块复位 #br()1 x 宸芯模块下载#br()1 x 宸芯模块开机],
  [供电方式], [9-48 V（1.0 mm 间距 6 Pin 插座）],
  [尺寸], [110 mm × 65 mm × 9 mm],
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

== 连接器总览

#iface-list-tbl(
  [PWR], [6], [1.00 mm 1x4], [供电],
  [SW/LED], [5], [1.00 mm 1×5], [上电控制 · 指示灯],
  [UART], [9], [1.00 mm 1×9], [调试串口 · TTL UART · RS232 UART],
  [ETH], [8], [1.00 mm 1x8], [10/100Mbps以太网口],
  [GPIO], [7], [1.00 mm 1x7], [GPIO],
  [AUDIO], [7], [1.00 mm 1x7], [音频接口],
  [UART LED - 模块], [10], [1.00 mm 1x10], [UART · LED],
  [USB - 模块], [4], [1.00 mm 1x4], [USB],
  [ANT - Wi-Fi & GNSS], [1], [MMCX], [Wi-Fi &北斗/GPS 天线接口], 
  [ANT - 模块RF], [2], [MMCX], [模块天线接口],
  [功放控制], [3], [MMCX · I-PEX], [模块外接射频功放SW控制接口],
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
  fig-desc: [GPIO 区域局部特写],
  svg-paths: BOARD-SVGS,

  [1], [Enable], [O], [—], [电源使能，与pin2短接],
  [2], [Enable], [I], [—], [电源使能，与pin1短接],
  [3], [3.3V], [O], [3.3 V], [外接系统指示灯电源],
  [4], [GPIO22], [O], [3.3V], [系统指示灯],
  [5], [GPIO21], [O], [3.3V], [系统指示灯],
)

#conn-section(
  id: "conn-uart",
  name: [UART 接口],
  fig-desc: [UART 区域局部特写],
  svg-paths: BOARD-SVGS,
  [1], [UART_SIN], [I], [3.3 V], [主控调试串口RXD],
  [2], [UART_SOUT], [O], [3.3 V], [主控调试串口TXD],
  [3], [GND], [—], [—], [信号地],
  [4], [U_RXD_0], [I], [3.3 V], [USB转串口RXD - ttyUSB0],
  [5], [U_TXD_0], [O], [3.3 V], [USB转串口TXD - ttyUSB0],
  [6], [GND], [—], [—], [信号地],
  [7], [3.3V], [O], [3.3 V], [对外供电],
  [8], [U_RXD_2], [I], [±5.4V（RS-232）], [USB转串口RXD - ttyUSB2],
  [9], [U_TXD_2], [O], [±5.4V（RS-232）], [USB转串口TXD - ttyUSB2],
)

#conn-section(
  id: "conn-eth",
  name: [ETH 接口],
  fig-desc: [ETH 区域局部特写],
  svg-paths: BOARD-SVGS,
  [1], [ETH_RXD4+], [I], [IEEE 802.3标准], [以太网口RXD4+],
  [2], [ETH_RXD4-], [I], [IEEE 802.3标准], [以太网口RXD4-],
  [3], [ETH_TXD4+], [O], [IEEE 802.3标准], [以太网口TXD4+],
  [4], [ETH_TXD4-], [O], [IEEE 802.3标准], [以太网口TXD4-],
  [1], [ETH_RXD0+], [I], [IEEE 802.3标准], [以太网口RXD0+],
  [2], [ETH_RXD0-], [I], [IEEE 802.3标准], [以太网口RXD0-],
  [3], [ETH_TXD0+], [O], [IEEE 802.3标准], [以太网口TXD0+],
  [4], [ETH_TXD0-], [O], [IEEE 802.3标准], [以太网口TXD0-],
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
  [5], [GPIO16], [I/OD], [3.3 V], [GPIO16，内部上拉10K],
  [6], [GPIO17], [I/OD], [3.3 V], [GPIO17，内部无上拉],
)

#conn-section(
  id: "conn-audio",
  name: [AUDIO 接口],
  fig-desc: [AUDIO 区域局部特写],
  svg-paths: BOARD-SVGS,
  [1], [MIC_IN], [I], [模拟（2.475 V 偏置）], [MIC 输入，偏置源电流最大 2 mA],
  [2], [AGND], [—], [—], [模拟信号地],
  [3], [HS_OUT], [O], [模拟], [耳机输出],
  [4], [SPK+], [O], [模拟（BTL）], [扬声器 +，8 Ω 时 1.1 W（THD+N < 1%）],
  [5], [SPK-], [O], [模拟（BTL）], [扬声器 -，*不可接地*],
  [6], [PTT_CTRL], [I], [3.3 V], [PTT 收发切换：低电平为发话（MIC 使能、功放关闭），高电平为收听（MIC 静音、功放使能），默认为高电平],
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
  [4], [COM_UART_RX], [I], [3.3 V], [模块默认串口COMUART_RXD],
  [5], [COM_UART_TX], [O], [3.3 V], [模块默认串口COMUART_TXD],
  [6], [GND], [—], [—], [信号地],
  [7], [3.3V_TST], [O], [3.3 V], [模块独立电源，供外接LED指示灯使用],
  [8], [LED_VIBR], [O], [3.3 V], [模块逻辑中心节点建链接、信号强度指示灯，接蓝色],
  [9], [LED_SINKER], [O], [3.3 V], [模块异常指示灯，接红色],
  [10], [LED_VFLASH], [O], [3.3 V], [模块接入节点建链指示灯，接绿色],
)

#conn-section(
  id: "conn-musb",
  name: [模块 USB 接口],
  fig-desc: [模块 UART 区域局部特写],
  svg-paths: BOARD-SVGS,
  [1], [USB_5V], [I], [5 V], [模块USB 5V],
  [2], [USB_D-], [I/O], [USB 2.0 差分], [模块 USB2.0 D-],
  [3], [USB_D+], [I/O], [USB 2.0 差分], [模块 USB2.0 D+],
  [4], [USB_GND], [—], [—], [模块USB 地],
)


#ant-section(
  id: "conn-rf",
  name: [北斗/GPS 天线接口],
  fig-desc: [天线区域局部特写],
  svg-paths: BOARD-SVGS,
  [Wi-Fi], [MMCX], [50 Ω], [2412-2462 MHz], [MMCX内孔形式],
  [GNSS], [MMCX], [50 Ω], [1559-1577 MHz], [MMCX内孔形式，3.3V有源馈电，GNSS与主控IC的UART1进行通信],
)

//#note[
  //北斗/GPS 口已通过馈电电感在射频线上叠加 3.3 V 直流，可直接驱动有源天线内置 LNA。
 // 接无源天线不会损坏，但灵敏度会明显下降。
//]


#ant-section(
  id: "conn-mant",
  name: [模块RF天线接口],
  fig-desc: [天线区域局部特写],
  svg-paths: BOARD-SVGS,
  [ANT_1], [MMCX], [50 Ω], [1420-1529 MHz，566-678 MHz], [MAIN ANT，MMCX内孔形式],
  [ANT_2], [MMCX], [50 Ω], [1420-1529 MHz，566-678 MHz], [SUB ANT，MMCX内孔形式],
)

#ctl-section(
  id: "conn-ctl",
  name: [模块外接功放控制接口],
  fig-desc: [功放控制区域局部特写],
  svg-paths: BOARD-SVGS,
  [CTL_H], [MMCX/I-PEX], [O], [1.8 V], [输出高电平使能功放PA，低电平使能功放LNA，MMCX内孔形式，*连接器二选一*],
  [CTL_L], [MMCX], [O], [1.8 V], [输出低电平使能功放PA，高电平使能功放LNA，MMCX内孔形式],
)

= 使用须知

//#warn[
//  *GPIO0* 在上电时若被外部拉低，芯片将进入下载模式而非正常启动。
//  除 Boot 按键外，请避免外部电路强制拉低该引脚。
//]

//#note[
//  USB D+/D−（GPIO18/GPIO19）与 J1 内部相连，J2 排针上请勿同时使用这两个 GPIO。
//]

//#caution[
//  外部 3.3 V 供电时纹波应 < 50 mV，且不得与 USB 同时供电。
//]

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
