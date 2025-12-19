# RetroLogCam 项目功能文档

> **版本：** 1.0.0  
> **描述：** 一款主打复古 CCD 数码相机质感的 HarmonyOS 应用，提供实时滤镜、画幅比例切换及复古 OSD 显示功能。

## 1. 技术架构概览

项目采用 **MVVM (Model-View-ViewModel)** 模式构建，确保业务逻辑与 UI 解耦。

- **语言 / 环境：** ArkTS (HarmonyOS SDK 5.x), DevEco Studio (API 12/13)
- **底层技术：**
  - `CameraKit`: 负责相机硬件调用、预览流管理及原图捕获。
  - `ImageKit`: 负责 `PixelMap` 像素级图像处理。
  - `MediaLibraryKit`: 负责媒体资源保存与相册管理。
  - `SensorServiceKit`: 负责物理马达震动反馈。

## 2. 核心模块详解

### 2.1 CameraService (相机硬件层)

- **初始化：** `initialize(context)` 动态获取相机管理器，并检测硬件能力。
- **预览流管理：** `startPreview(surfaceId)` 支持多分辨率适配（优先 4:3），创建拍照输出（PhotoOutput）。
- **硬件控制：**
  - **对焦：** 支持 `setFocusPoint`（归一化坐标）和连续自动对焦模式。
  - **闪光灯：** 支持 `OFF` / `AUTO` / `ON` / `TORCH` 四种模式转换。
  - **变焦：** 支持 `setZoomRatio` (1.0x - 4.0x)。
  - **曝光：** 支持 `setExposureBias` (-2.0 EV 到 +2.0 EV)。
- **摄像头切换：** 释放当前会话并重新绑定前置/后置设备。

### 2.2 FilterService & ImageProcessor (图像处理层)

- **滤镜矩阵引擎：**
  - 预设经典滤镜：`D-Log` (高动态)、`Classic S` (冷蓝调)、`Vintage C` (暖黄调)、`Mono CCD` (高反差黑白)、`Cyber 2000` (冷绿调)、`Soft Dream` (柔光)。
  - 动态生成算法：基于 4x5 颜色矩阵进行饱和度、对比度、亮度及色温的综合计算。
- **后期处理流水线：**
  - **实时预览：** 使用 CSS `blend-mode` (Multiply) 在 UI 层进行低功耗颜色叠加渲染。
  - **破坏性合成 (Burn-in)：** 拍照后对 `PixelMap` 直接操作。
    - 滤镜应用：像素级颜色矩阵运算。
    - 模拟噪点：根据配置添加随机颗粒度。
    - 日期水印：右下角绘制复古风格（橙色发光）日期戳 `'YY MM DD`。

### 2.3 CameraViewModel (状态管理层)

- **响应式驱动：** 采用 `@Observed` 装饰器，管理闪光灯、比例、滤镜、倒计时等所有全局状态。
- **辅助功能：**
  - 震动开关、音频开关、九宫格辅助线状态维护。
  - 模拟 ISO 更新逻辑。
  - 格式化日期/时间字符串生成。

## 3. UI 交互设计

### 3.1 核心 UI 组件

- **CameraPreview:** 基于 `XComponent`。支持 **双指缩放** (Zoom)、**上下滑动** (EV 调节)、**点击对焦**。
- **ControlBar:** 奶油白复古设计。集成 `Swiper` 滤镜快速选择器及复古快门按钮。
- **OSDLayer (On-Screen Display):** 模拟 CCD 相机液晶屏显示（电池、ISO、分辨率、录制状态、对焦框）。
- **AspectMask:** 画幅比例遮罩（支持 4:3, 16:9, 1:1）。通过黑色块遮挡实现非裁切感的视觉体验。

### 3.2 复古细节增强

- **震动反馈：** 快门点击、对焦成功、模式切换时均伴随微弱触感震动（30ms）。
- **设计美学：** 采用奶油白 (`#FFFEF5`) 与深灰配色，结合柔和阴影与玻璃拟态（Glassmorphism）质感。

## 4. 后续 AI 扩展指南 (Prompt 建议)

当需要 AI 增加功能时，建议参考以下路径：

### A. 增加新滤镜

> "在 `FilterService.ets` 中定义一个新的 `ColorMatrix`。在 `FilterType` 枚举中增加类型，并在 `ImageProcessor.ets` 的描述中补充风格说明。目标风格：[描述风格，如：富士电影色彩]。"

### B. 实现录像功能

> "在 `CameraService.ets` 中添加 `VideoOutput` 配置，并创建 `startRecording` / `stopRecording` 方法。在 `Index.ets` 中通过 `viewModel.isRecording` 状态控制记录逻辑，并更新 `OSDLayer` 闪烁 REC 图标。"

### C. 增加 UI 设置项

> "在 `SettingsMenu.ets` 中增加一个 Switch 开关配置 [功能名]。将其通过 `viewModel` 进行双向绑定，并在 `Index.ets` 或相关服务类中应用该逻辑背景。"

---

_文档生成日期：2025-12-19_
