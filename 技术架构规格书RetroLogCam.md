# 产品需求文档 & 技术架构规格书 - RetroLog Cam

> 版本: 3.0 (全功能详解版)
>
> 核心变更: 补全了详细的功能需求列表 (FRD)，明确了每一个按钮的交互逻辑、状态变化及业务规则，确保 AI 知道不仅要画出按钮，还要实现什么功能。

## 1. 产品概述 (Overview)

- **产品名称**: RetroLog Cam
- **核心价值**: 模拟千禧年 CCD 数码相机的色彩科学与操作手感，提供“电影级 Log 模式”作为专业差异化卖点。
- **目标用户**: 追求复古质感的 Gen-Z、摄影爱好者。

## 2. 功能需求说明书 (Functional Requirements) - **核心**

此章节定义了 App 必须具备的具体功能。请在开发时将此列表发送给 AI，要求它逐一实现。

### 2.1 拍摄核心功能 (Shooting Core)

| **功能模块** | **子功能**   | **详细逻辑说明 (Logic)**                                     | **优先级** |
| ------------ | ------------ | ------------------------------------------------------------ | ---------- |
| **对焦系统** | **触控对焦** | 点击取景框任意位置，显示绿色十字框，触发 `cameraSession.focus()`。对焦成功框变实心，失败闪烁。 | P0         |
|              | **自动对焦** | 启动时默认连续自动对焦 (Continuous AF)。                     | P0         |
| **曝光控制** | **曝光补偿** | 上下滑动屏幕可调整 EV (Exposure Value) 值，范围 -2.0 到 +2.0。 | P1         |
| **变焦系统** | **数字变焦** | 双指捏合 (Pinch) 进行缩放，最大支持 4.0x 数字变焦。          | P1         |
| **闪光灯**   | **模式切换** | 按钮点击循环切换状态： 1. **Off** (图标灰色) 2. **Auto** (图标白色) 3. **On** (图标黄色，强制开启) 4. **Torch** (手电筒常亮，用于暗光取景) | P1         |
| **画幅比例** | **遮罩切换** | 按钮点击循环切换： 1. **4:3** (默认，经典CCD全画幅) 2. **16:9** (电影感，上下加黑边遮罩) 3. **1:1** (正方形，左右加黑边遮罩) | P1         |
| **倒计时**   | **延时拍摄** | 切换：Off -> 3s -> 10s。 触发快门后，OSD 区域显示倒数数字，伴随“滴-滴-滴”倒计时音效。 | P2         |

### 2.2 滤镜与色彩系统 (Filter & Color System)

这是本 App 的灵魂。AI 需要为每一种模式配置不同的 `ColorMatrix` 或着色器。

- **Mode 0: Standard (原片)**
  - 无滤镜，仅添加轻微的锐化 (Sharpness +10%)。
- **Mode 1: D-Log (核心卖点)**
  - **逻辑**: 饱和度 -40%, 对比度 -30%, 阴影亮度 +20%。
  - **用途**: 灰片风格，保留最大宽容度，适合导入 LR/VSCO 后期。
- **Mode 2: Classic S (索尼风)**
  - **逻辑**: 色温偏冷 (7000K), 蓝色通道增强, 红色通道略减。高锐度。
- **Mode 3: Vintage C (佳能风)**
  - **逻辑**: 色温偏暖 (5500K), 洋红 (Magenta) +10% (肤色优化), 柔光效果。
- **Mode 4: Mono CCD (黑白)**
  - **逻辑**: 灰度处理, 颗粒度 (Noise) +50%, 对比度 +20% (高反差)。

### 2.3 后期合成与存储 (Processing & Storage)

- **日期水印 (Date Stamp)**
  - **开关**: 在设置中可开启/关闭。
  - **格式**: `'YY MM DD` (如 `'24 05 20`) 或 `HH:mm`。
  - **样式**: 橙色 (#FF5500) 发光字体，模拟老式数码相机在胶片上打印日期的效果。
  - **合成**: 必须是**破坏性合成** (Burn-in)，即保存后的 JPG 图片自带水印，不可移除。
- **Exif 信息保留**
  - 保存图片时，需保留拍摄时间、焦距等基础 Exif 信息。

### 2.4 设置选项 (Settings Menu)

- **声音开关**: 开启/关闭 模拟快门声、对焦声。
- **震动反馈**: 开启/关闭 触感反馈。
- **构图线**: 开启/关闭 九宫格。
- **前置摄像头镜像**: 开启/关闭。

## 3. 用户界面 (UI) 详细设计 (UI Specifications)

### 3.1 布局层级 (Z-Index Stack)

```
[Layer 4 - Top]  Toast提示 / 倒计时大数字
[Layer 3]        设置菜单面板 (半屏 Sheet)
[Layer 2]        HUD 操作层 (顶部栏 + 底部控制栏 + OSD文字)
[Layer 1]        画幅遮罩 (纯黑 View，用于遮挡 16:9/1:1 之外的区域)
[Layer 0 - Btm]  XComponent (相机预览流 Surface)
```

### 3.2 关键组件视觉规范

#### **A. 底部控制台 (The Deck)**

- **背景**: `#1A1A1A` (黑灰色)，带噪点纹理。
- **快门键 (Shutter)**:
  - 尺寸: 72vp。
  - 样式: 银色金属外环 (渐变 #E0E0E0 -> #999999)，黑色内芯。
  - 交互: 按下时内芯缩小 10%，恢复时弹起。
- **滤镜转盘 (Filter Wheel)**:
  - 交互: 类似 iOS 的日期选择器，横向滚动。
  - 选中态: 文字白色，字号 16fp，加粗。
  - 非选中态: 文字灰色，字号 12fp，透明度 50%。

#### **B. OSD (On-Screen Display)**

- **字体**: 强制使用等宽字体 (Monospace) 或引入 `Digital-7` 字体文件。
- **布局**:
  - 左上: `[🔴 REC]` (录像模式下红点闪烁，拍照模式常亮或隐藏)。
  - 右上: `[🔋 ||| ]` (电池电量图标)。
  - 左下: `[ISO 400]` (根据光线自动跳变数值，可做假数据模拟复古感)。
  - 右下: `['24 05 20]` (橙色日期)。

## 4. 系统架构设计 (System Architecture)

### 4.1 MVVM 架构图

- **View (UI)**: `Index.ets`, `ControlBar.ets`
  - 监听 `@State` 变化刷新界面。
  - 所有的点击事件 -> 调用 ViewModel 方法。
- **ViewModel (State)**: `CameraViewModel.ts`
  - 持有状态: `flashMode`, `currentFilter`, `isRatio16_9`。
  - 业务逻辑: `switchFlash()`, `capturePhoto()`.
- **Model (Service)**: `CameraService.ts`, `ImageProcessor.ts`
  - 调用鸿蒙原生 API (`camera`, `image`, `effectKit`)。

### 4.2 目录结构 (Directory Structure)

```
/entry/src/main/ets
├── /common
│   ├── /assets          # 图片资源 (快门图标, 噪点纹理)
│   └── /constants       # FilterConstants.ts (存放滤镜矩阵数组)
├── /components
│   ├── CameraPreview.ets
│   ├── ShutterButton.ets
│   ├── FilterSelector.ets
│   └── OSDLayer.ets     # 各种复古参数文字
├── /viewmodel
│   └── CameraViewModel.ts # 核心状态管理
├── /services
│   ├── CameraService.ts   # 硬件调用
│   └── FilterService.ts   # 滤镜算法与水印绘制
└── /pages
    └── Index.ets
```

## 5. 针对 AI 的开发指令 (AI Prompts)

**请按顺序复制以下指令给 AI，确保它实现具体的“功能”而非仅实现“界面”。**

**Prompt 1: 建立功能枚举与状态**

> "请在 common/constants 目录下定义枚举：FlashMode (OFF, ON, AUTO, TORCH), FilterType (ORIGINAL, D_LOG, VINTAGE, MONO)。
>
> 并在 viewmodel/CameraViewModel.ts 中创建类，使用 @Observed 装饰，包含这些状态字段，并提供修改它们的方法（如 toggleFlashMode）。"

**Prompt 2: 实现滤镜矩阵逻辑**

> "请编写 services/FilterService.ts。我需要一个静态只读数组 FILTER_MATRICES。
>
> 请为 'D-Log' 模式配置一个 ColorMatrix，降低 40% 饱和度。
>
> 为 'Vintage' 模式配置一个偏黄的 Matrix。
>
> 并提供一个方法 getMatrix(type: FilterType) 返回对应的数组。"

**Prompt 3: 实现快门与水印逻辑**

> "在 CameraService 中实现拍照功能。
>
> 需求：
>
> 1. 调用 `photoOutput.capture()` 拿到图片。
> 2. 将图片传给 `ImageProcessor`。
> 3. 使用 `OffscreenCanvas` 在图片右下角绘制橙色的日期文字（文字内容为当前日期）。
> 4. 将处理后的图片保存到媒体库 (PhotoAccessHelper)。"

**Prompt 4: 实现 UI 交互**

> "编写 `ControlBar.ets` 组件。
>
> 1. 放置一个 `Swiper` 组件作为滤镜选择器，绑定 ViewModel 中的 `currentFilter`。
> 2. 放置一个自定义的快门按钮，点击时调用 `viewModel.takePhoto()`。
> 3. 确保切换滤镜时，调用 `vibrator` 触发轻微震动。"