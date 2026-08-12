// ============================================================
// PCBA 规格书 — 极简工程版
// 编译：typst compile spec-clean.typ
// ============================================================
#import "lib-clean.typ": *

#let COMPANY = "无锡星汉电子技术有限公司"
#let PRODUCT = "SHT1UBA"
#let DOC_NO = "SHT1UBA"
#let HW_VER = "HW V1.0"
#let DOC_VER = "Rev A"

// 板图池：正面 / 背面各一张。连接器在哪张图里，就从哪张自动提取。
#let BOARD-SVGS = (
  "SHT1UBA-V1.svg",
  // "SHT1UBA-V1-back.svg",
)

#cover(
  company: COMPANY,
  product: PRODUCT,
  subtitle: "高集成CX677XK系列载板",
  doc-no: DOC_NO,
  hw-version: HW_VER,
  doc-version: DOC_VER,
  date: "2026-08-06",
  summary: [

  ],
  //highlights: (
  //("主控", "CX677XK"),
  //("供电", "USB-C 5 V"),∏
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
//)˚

#pagebreak()

= 产品概述

== 功能简介

*#PRODUCT*此产品为高集成度、高性能网络处理载板，集成宸芯CX677XK系列模块，尺寸仅为115*62mm，并支持手机、电脑等终端设备通过2.4GHz WiFi接入网络。同时可支持北斗/GPS定位，非常适合于便携应用。

==

#figure(
  ph("产品总览图 — 标注 USB-C、天线、GPIO 排针及主要元件", h: 200pt),
  caption: [产品外观总览],
)

== 主要特征

#key-points(
  [支持宸芯CX677XK系列模块],
  [板载 2.4GHz WiFi],
  [支持北斗/GPS定位],
  [网口、UART等接口],
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

#grid(
  columns: (1.1fr, 0.9fr),
  gutter: 16pt,
  figure(
    ph("PCB 俯视图尺寸标注\n长 48.3 mm × 宽 25.4 mm", h: 200pt),
    caption: [俯视图尺寸],
  ),
  figure(
    ph("侧视图尺寸标注\n最高元件 8.5 mm（USB-C）", h: 200pt),
    caption: [侧视图尺寸],
  ),
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
  [天线类型],
  [1 x WiFi IPEX 天线接口#br()1 x 北斗/GPS IPEX 天线接口],
  [宸芯模块接口],
  [1 x 100 Mbps 以太网口，1 x TTL UART 接口，1 x 复位信号，3 x 指示灯信号，电源（BTB 形式连接器）],
  [以太网口],
  [2 x 100 Mbps 以太网口（8 pin 1.0 mm 间距连接器）],
  [其他接口],
  [1 x 上电开关 + 2 x 指示灯（5 pin 1.0 mm 间距连接器）#br()1 x 音频接口（7 pin 1.0 mm 间距连接器）#br()1 x 音频接口（7 pin 1.0 mm 间距连接器）#br()1 x 3 个 GPIO 接口（7 pin 1.0 mm 间距连接器）#br()1 x 调试串口 + 1 x TTL UART + 2 x GPIO（9 pin 1.0 mm 间距连接器）],
  [指示灯],
  [2 x UART 收发指示灯#br()3 x 宸芯模块指示灯（红 / 绿 / 蓝）],
  [供电方式],
  [9–48 V（1.0 mm 间距 4 Pin 插座）],
  [底板尺寸],
  [63 mm × 67 mm × 10 mm],
  [组合尺寸],
  [63 mm × 67 mm × 19 mm],
  [温度范围],
  [存储温度：−40 °C ～ +125 °C#br()工作温度：−20 °C ～ +65 °C],
)

== 无线参数

#spec-tbl(
  [工作频率],
  [Wi-Fi：2412–2462 MHz#br()北斗/GPS：1559–1577 MHz],
  [信道带宽],
  [Wi-Fi：20 MHz],
  [输出功率],
  [Wi-Fi：0.5 W],
  [接收灵敏度],
  [Wi-Fi：-90 dBm],
  [调制方式],
  [OFDM BPSK / QPSK / 16-QAM / 64-QAM],
  [传输速率],
  [Wi-Fi：最大 40 Mbps],
)

#pagebreak()

== 软件特性

#spec-tbl(
  [Bootloader],
  [U-Boot],
  [Linux 内核],
  [3.18.19],
  [有线网络],
  [IP 地址可配置#br()子网掩码可配置],
  [Wi-Fi 特性],
  [输出功率可调节；支持 AP 模式；ESSID 可配置；支持自适应速率模式；支持 WMM/802.11e QoS；支持距离优化；支持 MAC 地址过滤；连接状态显示；WPA/WPA2/WEP 加密；隐藏 ESSID],
  [北斗/GPS],
  [支持网络透传北斗/GPS 原始定位数据],
  [管理特征],
  [支持网页管理；支持 SSH 安全管理；导入/导出配置信息；恢复出厂配置；在线更新固件],
)

#pagebreak()

= 接口定义

== 连接器总览

#conn-list-tbl(
  [J1],
  [USB-C],
  [16],
  [Type-C SMT],
  [供电 · 烧录 · 串口调试],
  [J2],
  [GPIO 排针],
  [20],
  [2.54 mm 2×10],
  [通用 IO / ADC / SPI / I2C],
  [J3],
  [UART 烧录],
  [6],
  [2.54 mm 1×6],
  [无 USB 时的备用烧录],
  [J4],
  [天线],
  [1],
  [IPEX 1 代],
  [外接天线（与板载二选一）],
)

#conn-section(
  id: "gpio",
  name: [GPIO 接口],
  fig-desc: [GPIO 区域局部特写],
  svg-paths: BOARD-SVGS,

  [A4/B9],
  [VBUS],
  [In],
  [5 V],
  [USB 总线供电，经 LDO 降压至 3.3 V],
  [A6/B6],
  [D+],
  [I/O],
  [3.3 V],
  [USB 2.0 数据 +，经 CP2102N 转 UART],
  [A7/B7],
  [D−],
  [I/O],
  [3.3 V],
  [USB 2.0 数据 −],
  [A5/B5],
  [CC1/CC2],
  [I/O],
  [—],
  [方向检测，5.1 kΩ 下拉],
  [A1/B12],
  [GND],
  [—],
  [—],
  [信号地 / 屏蔽],
)

#pagebreak()

#conn-section(
  id: "eth",
  name: [以太网接口],
  fig-desc: [以太网区域局部特写],
  svg-paths: BOARD-SVGS,
  [1],
  [3V3],
  [Out],
  [3.3 V],
  [对外 3.3 V 供电，≤ 500 mA],
  [2],
  [GND],
  [—],
  [—],
  [信号地],
  [3],
  [GPIO0],
  [I/O],
  [3.3 V],
  [Boot 选择；上电拉低进入下载模式],
  [4],
  [GPIO1],
  [I/O],
  [3.3 V],
  [ADC1_CH0],
  [5],
  [GPIO2],
  [I/O],
  [3.3 V],
  [ADC1_CH1 / 板载 LED],
  [8],
  [GPIO5],
  [I/O],
  [3.3 V],
  [I2C SCL],
  [16],
  [GPIO20],
  [I/O],
  [3.3 V],
  [UART0 RX],
  [17],
  [GPIO21],
  [I/O],
  [3.3 V],
  [UART0 TX],
  [18],
  [EN],
  [In],
  [3.3 V],
  [芯片使能，低电平复位，10 kΩ 上拉],
  [20],
  [GND],
  [—],
  [—],
  [信号地],
)

#pagebreak()

#conn-section(
  id: "J3",
  ref: "J3",
  name: [UART 烧录接口],
  detail: [6 Pin · 2.54 mm 1×6 · 备用],
  fig-desc: [J3 局部放大特写 — UART 烧录口高亮，其余连接器置灰（待替换板图）],
  svg-paths: BOARD-SVGS,
  [1],
  [3V3],
  [Out],
  [3.3 V],
  [对外供电],
  [2],
  [EN],
  [In],
  [3.3 V],
  [芯片使能],
  [3],
  [GPIO0],
  [I/O],
  [3.3 V],
  [Boot 选择，烧录时拉低],
  [4],
  [TX],
  [Out],
  [3.3 V],
  [UART0_TX → GPIO21],
  [5],
  [RX],
  [In],
  [3.3 V],
  [UART0_RX → GPIO20],
  [6],
  [GND],
  [—],
  [—],
  [信号地],
)

#conn-section(
  id: "J4",
  ref: "J4",
  name: [天线接口],
  detail: [1 Pin · IPEX 1 代 · 与板载天线二选一],
  fig-desc: [J4 局部放大特写 — IPEX 天线口高亮，其余连接器置灰（待替换板图）],
  svg-paths: BOARD-SVGS,
  [1],
  [ANT],
  [—],
  [50 Ω],
  [外接天线端口，需断开 R_ANT 跳线],
)

= 使用须知

#warn[
  *GPIO0* 在上电时若被外部拉低，芯片将进入下载模式而非正常启动。
  除 Boot 按键外，请避免外部电路强制拉低该引脚。
]

#note[
  USB D+/D−（GPIO18/GPIO19）与 J1 内部相连，J2 排针上请勿同时使用这两个 GPIO。
]

#caution[
  外部 3.3 V 供电时纹波应 < 50 mV，且不得与 USB 同时供电。
]

+ *供电*：推荐 USB-C 5 V / 1 A 以上适配器。外部 3.3 V 供电时纹波 < 50 mV，且不得与 USB 同时供电。
+ *天线*：默认板载 PCB 天线。外接 IPEX 时断开 R_ANT 跳线（0 Ω），接至 J4。
+ *GPIO 限制*：单 Pin 最大 12 mA，合计不超过 80 mA；ADC 输入不得超过 3.3 V。
+ *烧录*：USB-C 直连即可；无 USB 时用 J3 + USB-TTL，烧录时拉低 GPIO0 上电。
+ *ESD*：接口已加 TVS 保护，操作时仍建议佩戴防静电手环。

#v(1.5em)
#hairline()
#v(0.5em)
#text(size: 8pt, fill: faint)[
  本文档参数基于设计目标及典型测试条件，实际产品可能因批次略有差异。
  #COMPANY 保留修改规格的权利，恕不另行通知。
]
