# RetroLogCam 完整使用与功能文档

> **版本：** v1.0.0
> **最后更新：** 2025-12-19
> **项目名称：** RetroLogCam - 复古CCD相机模拟应用
> **平台：** HarmonyOS (API 12+)

---

## 📋 目录

1. [项目概述](#项目概述)
2. [完整功能清单](#完整功能清单)
3. [安装与运行](#安装与运行)
4. [用户使用指南](#用户使用指南)
5. [技术架构详解](#技术架构详解)
6. [开发与扩展](#开发与扩展)
7. [常见问题](#常见问题)

---

## 项目概述

**RetroLogCam** 是一款专为 HarmonyOS 平台打造的复古 CCD 数码相机模拟应用。它完美复刻了千禧年代 CCD 相机的色彩科学、操作手感和视觉美学，同时融合了现代专业摄影的 Log 模式，为摄影爱好者提供独特的创作体验。

### 核心特色

- 🎨 **7 种专业复古滤镜**：从 D-Log 到 Cyber 2000，涵盖多种经典风格
- 📽️ **电影级 Log 模式**：D-Log 提供最大动态范围，适合后期调色
- 📷 **真实 CCD 操作体验**：触控对焦、滑动曝光、双指变焦
- 🖼️ **多画幅支持**：4:3 经典、16:9 电影、1:1 方形
- 📅 **破坏性日期水印**：橙色发光日期戳，不可移除的复古感
- 🎬 **滤镜视频录制**：支持带滤镜效果的视频拍摄
- 🎵 **沉浸式反馈**：快门声、震动反馈、OSD 显示

---

## 完整功能清单

### 📸 拍摄核心功能

| 功能类别 | 子功能 | 详细说明 |
|---------|--------|----------|
| **对焦系统** | 触控对焦 | 点击画面任意位置，显示绿色对焦框，支持成功/失败反馈 |
| | 自动连续对焦 | 启动时默认开启，保持持续对焦状态 |
| **曝光控制** | EV 补偿 | 上下滑动屏幕，范围 -2.0 到 +2.0 EV |
| | 自动曝光 | 基于场景光线自动调整 |
| **变焦系统** | 数字变焦 | 双指捏合缩放，支持 1.0x - 4.0x 变焦 |
| **闪光灯** | 4 种模式 | OFF(关闭) / AUTO(自动) / ON(强制开启) / TORCH(手电筒) |
| **画幅比例** | 4:3 | 经典 CCD 全画幅（默认） |
| | 16:9 | 电影感宽屏，上下黑边遮罩 |
| | 1:1 | 正方形构图，左右黑边遮罩 |
| **倒计时** | 3s / 10s | 触发快门后倒数，伴随滴答音效 |

### 🎨 滤镜与色彩系统

| 滤镜名称 | 滤镜代码 | 色彩特征 | 适用场景 |
|---------|---------|---------|---------|
| **Standard** | `FilterType.STANDARD` | 原片直出，轻微锐化 (+10%) | 日常记录，自然色彩 |
| **D-Log** | `FilterType.D_LOG` | 饱和度 -40%, 对比度 -30%, 阴影 +20% | 专业拍摄，后期调色 |
| **Classic S** | `FilterType.CLASSIC_S` | 冷蓝调，高锐度，索尼风格 | 街拍，冷色调场景 |
| **Vintage C** | `FilterType.VINTAGE_C` | 暖黄调，洋红肤色，佳能风格 | 人像，温馨场景 |
| **Mono CCD** | `FilterType.MONO_CCD` | 黑白高反差，颗粒 +50% | 黑白摄影，光影创作 |
| **Cyber 2000** | `FilterType.CYBER_2000` | 冷绿色调，赛博朋克 | 创意摄影，未来感 |
| **Soft Dream** | `FilterType.SOFT_DREAM` | 柔光梦幻，高光溢出 | 梦幻人像，艺术创作 |

### 🎬 视频录制功能

- **支持滤镜**：所有 7 种滤镜均可应用于视频录制
- **音频控制**：可在设置中开启/关闭麦克风录音
- **实时预览**：录制过程中实时显示滤镜效果
- **时长显示**：OSD 层显示 REC 状态和录制时长（MM:SS）
- **保存格式**：MP4，自动保存到系统相册

### ⚙️ 设置选项

| 设置项 | 功能说明 | 默认值 |
|-------|---------|--------|
| **声音开关** | 控制快门声、对焦声、倒计时音效 | 开启 |
| **震动反馈** | 所有交互操作的触感反馈（30ms） | 开启 |
| **日期水印** | 照片右下角添加橙色发光日期戳 | 开启 |
| **构图线** | 九宫格辅助线 | 关闭 |
| **前置镜像** | 前置摄像头是否镜像显示 | 开启 |

### 🖼️ OSD 信息显示

模拟真实 CCD 相机屏幕，显示以下信息：

- **左上角**：`[🔴 REC]` - 录制状态指示灯（闪烁）
- **右上角**：`[🔋 ||| ]` - 电池电量图标（模拟）
- **左下角**：`[ISO 400]` - 模拟 ISO 值（随机变化）
- **右下角**：`['24 12 19]` - 橙色日期戳（格式：`'YY MM DD`）

---

## 安装与运行

### 环境要求

- **DevEco Studio**：5.0.0 或更高版本
- **HarmonyOS SDK**：API 12 (5.0.0)
- **Node.js**：18.x 或更高版本
- **ArkTS**：TypeScript 5.0+

### 构建步骤

```bash
# 1. 克隆项目
git clone <repository-url>
cd HarmonyOS/RetroLogCam

# 2. 安装依赖
npm install

# 3. 构建 HAP 包
hvigor assembleHap --mode release

# 或构建 debug 版本
hvigor assembleHap --mode debug

# 4. 清理构建（可选）
hvigor clean
```

### 部署到设备

#### 方式一：使用 DevEco Studio

1. 打开 DevEco Studio
2. 导入项目 `HarmonyOS/RetroLogCam`
3. 连接 HarmonyOS 设备（开启 USB 调试）
4. 点击 **Run** 按钮或按 `Shift + F10`

#### 方式二：使用 hdc 命令行

```bash
# 安装 HAP
hdc install -r entry/build/default/outputs/default/entry-default-signed.hap

# 启动应用
hdc shell aa start -a EntryAbility -b com.retrologcam.example

# 查看应用日志
hdc shell hilog -r | grep RetroLogCam
```

### 权限配置

应用需要以下权限（首次启动时会自动请求）：

- `ohos.permission.CAMERA` - 相机硬件访问
- `ohos.permission.MICROPHONE` - 麦克风（视频录制）
- `ohos.permission.WRITE_IMAGEVIDEO` - 写入媒体文件
- `ohos.permission.READ_IMAGEVIDEO` - 读取媒体文件

---

## 用户使用指南

### 基础操作流程

#### 1. 启动应用
- 点击应用图标启动
- 首次使用会请求相机和存储权限，点击"允许"

#### 2. 拍照
```
① 选择滤镜 → 底部左右滑动滤镜选择器
② 对焦 → 点击画面任意位置
③ 调整曝光 → 上下滑动屏幕（观察 EV 值变化）
④ 调整变焦 → 双指捏合缩放
⑤ 拍照 → 点击中央快门按钮
```

#### 3. 录像
```
① 长按快门按钮（约 0.5 秒）
② 观察 OSD 层 REC 图标开始闪烁
③ 录制中，屏幕显示时长（如 00:15）
④ 松开快门按钮停止录制
⑤ 视频自动保存到相册
```

#### 4. 切换功能

**闪光灯**（顶部左侧按钮）：
```
OFF (灰色) → AUTO (白色) → ON (黄色) → TORCH (常亮) → OFF
```

**画幅比例**（顶部中间按钮）：
```
4:3 (默认) → 16:9 (上下黑边) → 1:1 (左右黑边) → 4:3
```

**摄像头切换**（底部右侧按钮）：
- 点击切换前后摄像头

**设置菜单**（顶部右侧⚙️）：
- 点击打开设置面板
- 可开关：声音、震动、日期水印、构图线

### 高级技巧

#### 1. 使用 D-Log 模式拍摄
- **目的**：保留最大动态范围，适合后期调色
- **操作**：选择 D-Log 滤镜，正常曝光拍摄
- **后期**：导入 Lightroom/VSCO，调整曝光和对比度

#### 2. 模拟老式相机体验
- 开启日期水印
- 使用 Vintage C 或 Classic S 滤镜
- 关闭声音，只保留震动反馈
- 在光线充足的环境下拍摄

#### 3. 创意拍摄建议

| 场景 | 推荐滤镜 | 参数建议 |
|-----|---------|---------|
| 城市夜景 | Cyber 2000 | EV -0.5，变焦 2.0x |
| 人像 | Vintage C | 自然光，EV 0 |
| 黑白摄影 | Mono CCD | 强对比光线 |
| 电影感 | D-Log | 后期调色 |
| 梦幻人像 | Soft Dream | 逆光拍摄 |

---

## 技术架构详解

### 系统架构图

```
┌─────────────────────────────────────────────────────────────┐
│                        View Layer                           │
│  Index.ets (主页面) + UI 组件                               │
│  - CameraPreview (XComponent 相机预览)                      │
│  - ControlBar (快门、滤镜选择器)                            │
│  - TopBar (闪光灯、画幅、设置)                              │
│  - OSDLayer (屏幕显示信息)                                  │
│  - SettingsMenu (设置面板)                                  │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                   ViewModel Layer                           │
│  CameraViewModel.ets - 响应式状态管理                       │
│  - @Observed 装饰器                                         │
│  - 相机设置：flashMode, currentFilter, aspectRatio          │
│  - UI 状态：focusState, isRecording, countdownSeconds       │
│  - 用户偏好：soundEnabled, vibrationEnabled                 │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                      Service Layer                          │
│  ┌──────────────────┐  ┌──────────────────┐                │
│  │  CameraService   │  │ ImageProcessor   │                │
│  │  - 相机硬件访问   │  │ - 滤镜矩阵运算    │                │
│  │  - 预览/拍照/录像 │  │ - 像素级处理      │                │
│  │  - 对焦/变焦/曝光 │  │ - 日期水印绘制    │                │
│  └──────────────────┘  │ - 保存到相册      │                │
│                        └──────────────────┘                │
│  ┌──────────────────┐  ┌──────────────────┐                │
│  │  FilterService   │  │   SoundService   │                │
│  │  - 7 种滤镜矩阵   │  │ - 快门/对焦音效   │                │
│  │  - 矩阵运算工具   │  │ - 录制音效        │                │
│  └──────────────────┘  └──────────────────┘                │
└─────────────────────────────────────────────────────────────┘
```

### 核心服务详解

#### 1. CameraService (`services/CameraService.ets`)

**职责**：管理 HarmonyOS 相机硬件

**主要方法**：
```typescript
// 初始化相机
async initialize(context: Context): Promise<boolean>

// 开始预览
async startPreview(surfaceId: string, useFrontCamera: boolean): Promise<boolean>

// 拍照
async capturePhoto(): Promise<boolean>

// 录像
async startRecording(enableAudio: boolean): Promise<boolean>
async stopRecording(): Promise<string | undefined>

// 硬件控制
async setFocusPoint(x: number, y: number): Promise<boolean>
async setFlashMode(mode: FlashMode): Promise<boolean>
async setZoomRatio(ratio: number): Promise<boolean>
async setExposureBias(ev: number): Promise<boolean>
```

**技术细节**：
- 使用 `CameraKit` API
- 支持 4:3 优先的预览分辨率选择
- 通过 `photoAssetAvailable` 事件获取拍照数据
- 录像使用 `AVRecorder` + `VideoOutput` 双通道

#### 2. ImageProcessor (`services/ImageProcessor.ets`)

**职责**：像素级图像处理与合成

**处理流程**：
```
原始 PixelMap
    ↓
1. 应用颜色矩阵 (4x5 变换)
    ↓
2. 添加颗粒噪点 (随机噪声)
    ↓
3. 绘制日期水印 (像素绘制 + 发光效果)
    ↓
4. 打包为 JPEG
    ↓
5. 保存到媒体库
```

**核心算法**：
```typescript
// 颜色矩阵变换
for (let i = 0; i < data.length; i += 4) {
  const r = data[i] / 255
  const g = data[i+1] / 255
  const b = data[i+2] / 255

  // 矩阵运算
  newR = matrix[0]*r + matrix[1]*g + matrix[2]*b + matrix[3]*a + matrix[4]
  newG = matrix[5]*r + matrix[6]*g + matrix[7]*b + matrix[8]*a + matrix[9]
  newB = matrix[10]*r + matrix[11]*g + matrix[12]*b + matrix[13]*a + matrix[14]

  // 裁剪到 0-255
  data[i] = Math.max(0, Math.min(255, Math.round(newR * 255)))
}
```

#### 3. FilterService (`services/FilterService.ets`)

**职责**：定义所有滤镜的色彩矩阵和配置

**7 种滤镜矩阵**：

| 滤镜 | 矩阵特点 | 参数配置 |
|-----|---------|---------|
| **Standard** | 单位矩阵 + 轻微锐化 | contrast: 1.0, saturation: 1.0, grain: 0.0 |
| **D-Log** | 低饱和低对比，高阴影 | contrast: 0.7, saturation: 0.6, grain: 0.05 |
| **Classic S** | 蓝色通道增强 | warmth: -0.3, sharpness: 0.3, grain: 0.1 |
| **Vintage C** | 洋红肤色优化 | warmth: 0.3, saturation: 1.1, grain: 0.15 |
| **Mono CCD** | 灰度矩阵 | saturation: 0.0, contrast: 1.2, grain: 0.5 |
| **Cyber 2000** | 绿色通道增强 | warmth: -0.2, contrast: 1.25, grain: 0.2 |
| **Soft Dream** | 高亮度低锐度 | brightness: 0.15, sharpness: -0.3, grain: 0.05 |

**矩阵工具函数**：
```typescript
// 生成饱和度矩阵
static createSaturationMatrix(saturation: number): ColorMatrix

// 生成对比度矩阵
static createContrastMatrix(contrast: number): ColorMatrix

// 矩阵乘法（合并多个变换）
static multiplyMatrices(m1: ColorMatrix, m2: ColorMatrix): ColorMatrix
```

#### 4. CameraViewModel (`viewmodel/CameraViewModel.ets`)

**职责**：状态管理与业务逻辑

**响应式状态**：
```typescript
// 相机设置
flashMode: FlashMode = FlashMode.OFF
currentFilter: FilterType = FilterType.STANDARD
aspectRatio: AspectRatio = AspectRatio.RATIO_4_3

// UI 状态
showFocusFrame: boolean = false
focusState: string = 'success'
isCapturing: boolean = false
isRecording: boolean = false

// 用户偏好
soundEnabled: boolean = true
vibrationEnabled: boolean = true
dateStampEnabled: boolean = true

// 模拟数据
isoValue: number = 400
evValue: number = 0.0
zoomRatio: number = 1.0
```

**状态切换方法**：
```typescript
toggleFlashMode(): void          // OFF → AUTO → ON → TORCH → OFF
nextFilter(): void               // 下一个滤镜
toggleAspectRatio(): void        // 4:3 → 16:9 → 1:1 → 4:3
toggleTimerMode(): void          // OFF → 3s → 10s → OFF
```

---

## 开发与扩展

### 项目结构

```
RetroLogCam/
├── AppScope/                    # 应用级资源
│   ├── app.json5               # 应用元数据
│   └── resources/
│       ├── base/element/string.json  # 本地化字符串
│       └── base/media/         # 应用图标
│
├── entry/                       # 主模块
│   ├── src/main/ets/
│   │   ├── pages/
│   │   │   └── Index.ets       # 主页面（@Entry）
│   │   │
│   │   ├── components/         # UI 组件
│   │   │   ├── CameraPreview.ets      # 相机预览组件
│   │   │   ├── ControlBar.ets         # 底部控制栏
│   │   │   ├── TopBar.ets             # 顶部工具栏
│   │   │   ├── OSDLayer.ets           # OSD 信息层
│   │   │   ├── SettingsMenu.ets       # 设置面板
│   │   │   └── AspectMask.ets         # 画幅遮罩
│   │   │
│   │   ├── services/            # 业务逻辑层
│   │   │   ├── CameraService.ets      # 相机硬件服务
│   │   │   ├── ImageProcessor.ets     # 图像处理服务
│   │   │   ├── FilterService.ets      # 滤镜配置服务
│   │   │   └── SoundService.ets       # 音效服务
│   │   │
│   │   ├── viewmodel/           # 状态管理层
│   │   │   └── CameraViewModel.ets    # 响应式状态管理
│   │   │
│   │   ├── common/              # 公共定义
│   │   │   ├── constants/
│   │   │   │   └── Constants.ets      # 枚举、常量
│   │   │   └── utils/           # 工具函数
│   │   │
│   │   └── EntryAbility.ets     # 应用入口
│   │
│   ├── build-profile.json5      # 构建配置
│   ├── hvigorfile.ts           # 构建脚本
│   └── oh-package.json5        # 依赖管理
│
├── hvigor/                      # 构建系统配置
├── oh-package.json5            # 项目依赖
├── build-profile.json5         # 产品配置
├── hvigorfile.ts              # 根构建脚本
│
└── 文档文件：
    ├── README_RetroLogCam.md
    ├── 技术架构规格书RetroLogCam.md
    ├── USAGE_GUIDE.md
    └── COMPLETE_USAGE_GUIDE.md (本文档)
```

### 添加新滤镜

#### 步骤 1：定义滤镜类型

在 `entry/src/main/ets/common/constants/Constants.ets` 添加：

```typescript
export enum FilterType {
  // ... 现有滤镜
  NEW_FILTER = 7,  // 新增滤镜
}
```

#### 步骤 2：定义颜色矩阵

在 `entry/src/main/ets/services/FilterService.ets` 添加：

```typescript
// 新滤镜矩阵
const NEW_FILTER_MATRIX: ColorMatrix = [
  1.0, 0.0, 0.0, 0.0, 0.0,
  0.0, 1.0, 0.0, 0.0, 0.0,
  0.0, 0.0, 1.0, 0.0, 0.0,
  0.0, 0.0, 0.0, 1.0, 0.0
]
```

#### 步骤 3：更新 FilterService

```typescript
static getMatrix(type: FilterType): ColorMatrix {
  switch (type) {
    // ... 现有 case
    case FilterType.NEW_FILTER:
      return NEW_FILTER_MATRIX
    default:
      return STANDARD_MATRIX
  }
}

static getConfig(type: FilterType): FilterConfig {
  switch (type) {
    // ... 现有 case
    case FilterType.NEW_FILTER:
      return {
        name: 'New Filter',
        matrix: NEW_FILTER_MATRIX,
        contrast: 1.0,
        saturation: 1.0,
        brightness: 0.0,
        sharpness: 0.0,
        grain: 0.1,
        warmth: 0.0
      }
    // ...
  }
}

static getFilterDescription(type: FilterType): string {
  switch (type) {
    // ... 现有 case
    case FilterType.NEW_FILTER:
      return '新滤镜描述'
    // ...
  }
}
```

#### 步骤 4：更新滤镜列表

在 `getAllFilterTypes()` 中添加新类型。

### 添加新功能示例

#### 示例：添加 HDR 模式

**Prompt 给 AI：**
```
请在 RetroLogCam 中添加 HDR 拍照功能：

1. 在 CameraViewModel 中添加 isHDRMode: boolean 状态
2. 在 CameraService 中实现 HDR 拍照逻辑：
   - 连续拍摄 3 张不同曝光的照片（-1EV, 0EV, +1EV）
   - 使用 ImageProcessor 合成 HDR 图像
   - 保存最终结果
3. 在 ControlBar 添加 HDR 开关按钮
4. 在 SettingsMenu 添加 HDR 设置选项

技术要点：
- 使用 camera.setExposureBias() 控制曝光
- 使用 Promise.all() 并行处理多张照片
- HDR 合成算法：加权平均或拉普拉斯金字塔
```

#### 示例：添加人脸识别美颜

**Prompt 给 AI：**
```
在 ImageProcessor 中添加人脸美颜功能：

1. 集成 HarmonyOS 的人脸检测 API
2. 实现磨皮算法（高斯模糊 + 边缘保持）
3. 实现肤色优化（基于 HSV 色彩空间）
4. 在 SettingsMenu 添加美颜强度滑块（0-100%）

技术要点：
- 使用 @kit.ImageKit 中的人脸检测
- 仅对人脸区域应用美颜
- 保持边缘清晰度
```

### 性能优化建议

#### 1. 图像处理优化
```typescript
// 使用 Worker 处理像素数据，避免阻塞主线程
const worker = new Worker('pages/image-worker.js')

// 分块处理大图片
const chunkSize = 1024 * 1024  // 1MB
for (let offset = 0; offset < buffer.byteLength; offset += chunkSize) {
  // 处理数据块
}
```

#### 2. 内存管理
```typescript
// 及时释放 PixelMap
async processImage(pixelMap: image.PixelMap) {
  try {
    // 处理逻辑
  } finally {
    pixelMap.release()  // 释放资源
  }
}
```

#### 3. 相机会话复用
```typescript
// 避免频繁创建/销毁会话
// 切换摄像头时复用配置
```

---

## 常见问题 (FAQ)

### Q1: 为什么拍摄的照片和预览看起来不同？

**A**: 应用会对最终照片进行完整的像素级处理：
1. 应用 4x5 颜色矩阵变换
2. 添加模拟胶片颗粒
3. 绘制破坏性日期水印
4. 这些处理比实时预览更精细，确保最佳复古质感

### Q2: 视频录制如何保存声音？

**A**:
1. 在设置菜单中开启"声音开关"
2. 确保应用有 `ohos.permission.MICROPHONE` 权限
3. 手机未处于静音/免打扰模式
4. 录制时长按快门，松开停止

### Q3: 照片保存在哪里？

**A**: 照片和视频自动保存到系统相册：
- 路径：`/storage/media/Pictures/RetroLogCam/`
- 文件名：`RetroLogCam_<时间戳>.jpg`
- 视频：`VID_<时间戳>.mp4`

### Q4: 如何获得最佳拍摄效果？

**A**:
1. **光线充足**：CCD 滤镜在明暗对比强的环境下效果最佳
2. **适当曝光**：尝试轻微调低 EV（负值），色彩更浓郁
3. **开启日期水印**：增强复古感
4. **选择合适滤镜**：
   - 日常：Standard
   - 专业后期：D-Log
   - 街拍：Classic S
   - 人像：Vintage C

### Q5: 应用闪退或相机无法启动？

**A**:
1. 检查权限是否全部授予
2. 确认设备支持 HarmonyOS API 12+
3. 尝试重启应用或设备
4. 查看日志：`hdc shell hilog -r | grep RetroLogCam`

### Q6: 如何自定义滤镜？

**A**:
1. 修改 `FilterService.ets` 中的颜色矩阵
2. 调整 `FilterConfig` 参数（饱和度、对比度等）
3. 重新编译应用
4. 或使用 AI 辅助生成新滤镜矩阵

### Q7: 录像时长有限制吗？

**A**:
- 理论上无时长限制，受设备存储空间约束
- 建议单次录制不超过 10 分钟（避免内存溢出）
- 长时间录制建议使用系统相机

### Q8: 前置摄像头镜像如何关闭？

**A**:
1. 点击顶部⚙️打开设置
2. 找到"前置摄像头镜像"选项
3. 关闭开关
4. 前置拍摄将不再镜像

---

## 附录

### A. 快捷操作表

| 操作 | 手势 | 反馈 |
|-----|------|------|
| 对焦 | 点击屏幕 | 绿色对焦框 + 震动 |
| 曝光补偿 | 上下滑动 | EV 值变化 |
| 变焦 | 双指捏合 | 1.0x - 4.0x 变化 |
| 拍照 | 点击快门 | 快门声 + 震动 |
| 录像 | 长按快门 | REC 闪烁 + 震动 |
| 切换滤镜 | 左右滑动 | 滤镜名称变化 |
| 切换闪光灯 | 点击图标 | 图标颜色变化 |
| 切换画幅 | 点击图标 | 遮罩变化 |
| 切换摄像头 | 点击图标 | 预览翻转 |

### B. 颜色矩阵参考

#### 4x5 颜色矩阵格式
```
[R G B A Offset]  ← 红色输出
[R G B A Offset]  ← 绿色输出
[R G B A Offset]  ← 蓝色输出
[R G B A Offset]  ← Alpha 输出
```

#### 单位矩阵（无变换）
```
1.0, 0.0, 0.0, 0.0, 0.0,
0.0, 1.0, 0.0, 0.0, 0.0,
0.0, 0.0, 1.0, 0.0, 0.0,
0.0, 0.0, 0.0, 1.0, 0.0
```

### C. 版本历史

| 版本 | 日期 | 主要变更 |
|-----|------|---------|
| v1.0.0 | 2025-12-19 | 初始版本，完整功能实现 |

---

## 联系与支持

- **项目地址**：`/Users/zhangyang/code/HarmonyOS/RetroLogCam`
- **文档维护**：本文档随代码同步更新
- **问题反馈**：请通过 GitHub Issues 或项目内反馈

---

**© 2025 RetroLogCam Project. All rights reserved.**

*Designed for HarmonyOS photography enthusiasts.*
