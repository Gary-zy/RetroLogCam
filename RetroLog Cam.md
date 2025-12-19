# **产品需求文档 (PRD) \- RetroLog Cam (鸿蒙 HarmonyOS 版)**

## **1\. 产品概述 (Overview)**

* **产品名称**: RetroLog Cam (复古CCD数码相机)  
* **目标平台**: HarmonyOS NEXT (API 11+)  
* **开发语言**: ArkTS, ArkUI  
* **核心理念**: 还原千禧年CCD相机的独特噪点与色彩科学，同时引入类似电影工业的 "Log" 模式，提供高动态范围的扁平色彩，兼顾复古直出与专业后期。  
* **设计风格**: **Y2K 工业复古 (Industrial Retro)**。结合 2000 年代早期数码相机的“银色塑料感”与现代极简主义。

## **2\. 用户界面 (UI) 与 交互设计 (UX)**

### **2.1 整体布局逻辑 (Layout Structure)**

采用 **Z轴层叠布局 (Stack Layout)**。

* **底层 (Layer 0\)**: 相机取景器 (Viewfinder)，铺满屏幕。  
* **中间层 (Layer 1\)**: 遮罩层。如果用户选择 4:3 或 1:1 画幅，使用纯黑色遮罩挡住取景器多余部分，模拟电子取景器 (EVF) 边缘。  
* **顶层 (Layer 2\)**: 操作UI层 (HUD)，包含顶部工具栏和底部控制区。

### **2.2 详细页面与组件设计 (Button-Level Specs)**

#### **A. 主拍摄界面 (Main Camera View)**

**1\. 顶部工具栏 (Top Bar)**

* **布局**: 位于屏幕顶部安全区，高度 48vp。  
* **背景**: 透明。  
* **FlashBtn (闪光灯)**:  
  * *Icon*: ⚡️ (线条风格)。  
  * *State*: 开启时图标变为黄色 (\#FFD700)。  
* **RatioBtn (画幅)**: 点击切换遮罩。  
* **SettingsBtn (设置)**: 齿轮图标。

**2\. 中央取景器 (Viewfinder HUD \- 关键复古元素)**

* **OSD (On-Screen Display) 信息**: 在取景画面四角显示的参数，模拟老DV机。  
  * *左上*: "REC" (红色圆点闪烁 \+ 白色文字)。  
  * *右上*: 电池图标 (绿色分段)。  
  * *左下*: ISO 数值 (动态显示，如 "ISO 400")。  
  * *右下*: 日期戳 (橙色 '02 12 11)。  
* **FocusArea (对焦框)**:  
  * *样式*: 绿色粗线条 \[\#00FF00\] 的 "\[ \+ \]" 形状。  
  * *动画*: 点击屏幕时，框体从大变小并变色锁定。

**3\. 底部控制区 (Bottom Control Area)**

* **背景**: **深灰色磨砂质感 (\#1A1A1A)**，带有轻微的噪点纹理（如果技术允许）。高度占屏幕 25%-30%。  
* **FilterWheel (滤镜转盘 \- 左侧)**  
  * *样式*: 模拟物理拨轮。当前选中的文字高亮，两侧文字变暗且缩小。  
  * *Haptics*: **必须加入震动反馈**。每切换一个滤镜，触发一次 hapticFeedback.slide，模拟机械齿轮感。  
* **ShutterBtn (快门 \- 中间)**  
  * *外环*: 银色金属渐变 (LinearGradient: \#E0E0E0 \-\> \#808080)。  
  * *内芯*: 纯黑色圆形。  
  * *按下状态*: 内芯缩小，外环变暗，模拟物理按压行程。  
* **PlaybackBtn (回放 \- 右侧)**  
  * *样式*: 简单的矩形框，带有“PLAY”小三角图标。

#### **B. 扩展滤镜库 (Filter Logic)**

除了 Log 模式，增加更多具体的复古风格：

1. **D-Log (Cine Flat)**: **(核心)** 极低饱和度(-40%)，低对比度(-30%)，提亮阴影。直方图集中在中间。适合用户导入到LR/VSCO后期。  
2. **Classic S (Sony CCD)**: 偏冷洋红 (Magenta) 倾向。高锐度，天空更蓝。  
3. **Warm 90s (Kodak Gold)**: 暖黄色调，高光微红，模拟胶卷。  
4. **Cyber 2000 (Matrix)**: 偏冷绿色调，高对比度，模拟黑客帝国时期的数码感。  
5. **Soft Dream (Pro-Mist)**: 降低清晰度 (Blur)，高光溢出 (Bloom)，模拟柔光镜，适合人像。  
6. **Mono Noir (High Grain)**: 黑白，极高对比度，添加大量噪点。

## **3\. UI 设计规范 (Design System for AI)**

**将此章节直接喂给 AI，它能生成更符合预期的样式代码。**

### **3.1 色彩系统 (Color Palette)**

* **Primary Background (机身黑)**: \#121212 (不是纯黑，是深灰黑)  
* **Secondary Background (面板灰)**: \#2C2C2C  
* **Accent Color (指示灯橙)**: \#FF5500 (用于日期、警告)  
* **Accent Color (对焦绿)**: \#00FF00 (标准的复古数码绿)  
* **Metal Texture (金属银)**: \#D1D5DB (用于按钮边框、文字高亮)  
* **Text (Inactive)**: \#6B7280 (未选中的文字颜色)

### **3.2 字体排印 (Typography)**

* **Display Font (OSD参数)**: 寻找 Digital 或 Monospace 字体。如果是系统字体，强制使用 fontFamily: 'HarmonyOS Sans SC', monospace 并加粗。  
* **UI Font**: HarmonyOS Sans，字重 300 (Light)，极简风格。

### **3.3 组件材质 (Component Effects)**

* **Glassmorphism (磨砂玻璃)**: 用于设置菜单背景。  
  * backgroundBlurStyle: BlurStyle.Thin  
  * backgroundColor: \#80000000 (半透黑)  
* **Metallic Button (金属按钮模拟)**:  
  * 使用 LinearGradient 模拟金属光泽。  
  * 给按钮添加 shadow (阴影) 增加立体感: radius: 4, type: ShadowType.CIRCLE, color: '\#80000000', offsetY: 2。

## **4\. 技术实现与 Prompt 指南**

### **4.1 核心 Prompt 示例 (可以直接复制给 AI)**

**场景：编写底部控制栏 UI**

"使用 ArkUI 实现一个相机的底部控制栏。  
设计要求：

1. 背景色为 \#1A1A1A，高度 180vp。  
2. 中间是一个'快门按钮'：由一个直径 70vp 的外圆（银色金属渐变色 \#E0E0E0 到 \#909090）和一个直径 50vp 的内圆（纯黑色）组成。  
3. 左侧是一个'滤镜选择器'：显示当前滤镜名称（如 'D-Log'），字体颜色为白色，左右两侧有箭头。  
4. 右侧是'相册预览'：圆角矩形，边框为 2px 银色。  
5. 按钮点击时要有缩放动画（scale 0.9）来模拟物理按压感。"

**场景：实现 OSD 复古界面**

"我需要在相机预览层之上覆盖一层 OSD (On-Screen Display) 信息层。  
要求：

1. 使用 RelativeContainer 或 Stack 布局。  
2. 左上角显示红点🔴和文字 'REC'。  
3. 右下角显示橙色 (\#FF5500) 的日期文字 '02 12 11'，使用等宽字体 (Monospace)。  
4. 中间有一个绿色的十字对焦框，默认隐藏，点击屏幕时显示。"

### **4.2 滤镜算法提示 (ColorMatrix)**

**场景：让 AI 写 Log 滤镜**

"请使用 ArkTS 的 image 模块或者 ColorMatrix 来实现一个 'D-Log' 风格的滤镜。  
参数参考：

1. 对比度 (Contrast): 0.7 (降低)  
2. 饱和度 (Saturation): 0.6 (降低)  
3. 亮度 (Brightness): 1.1 (稍微提亮暗部)  
   目标是让画面看起来灰蒙蒙的，保留最大动态范围。"

## **5\. 开发路线图 (Roadmap)**

1. **Phase 1 (骨架)**: 完成相机预览 \+ 基础拍照功能 (无滤镜)。  
2. **Phase 2 (UI/UX)**: 按照上述设计规范，实现黑/银配色的复古界面，添加震动反馈。  
3. **Phase 3 (核心滤镜)**: 重点调试 **D-Log** 和 **Classic S** 两款滤镜，确保差异化明显。  
4. **Phase 4 (后期处理)**: 实现 Canvas 绘制日期水印功能。