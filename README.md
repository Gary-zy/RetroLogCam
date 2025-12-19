# RetroLogCam

> 📷 **复古 CCD 数码相机模拟器** - 专为 HarmonyOS 打造

[![HarmonyOS](https://img.shields.io/badge/HarmonyOS-5.0-blue)](https://www.harmonyos.com)
[![API Level](https://img.shields.io/badge/API-12-green)]()
[![License](https://img.shields.io/badge/License-MIT-yellow)]()

---

## ✨ 项目简介

**RetroLogCam** 是一款模拟千禧年代 CCD 数码相机的 HarmonyOS 应用。它完美复刻了经典相机的色彩科学、操作手感和视觉美学，同时融合了现代专业摄影的 Log 模式，让您的手机摄影重返 2000 年代的黄金时代。

### 🎯 核心特色

- 🎨 **7 种专业复古滤镜**：从 D-Log 到 Cyber 2000，涵盖多种经典风格
- 📽️ **电影级 Log 模式**：D-Log 提供最大动态范围，适合后期调色
- 📷 **真实 CCD 操作体验**：触控对焦、滑动曝光、双指变焦
- 🖼️ **多画幅支持**：4:3 经典、16:9 电影、1:1 方形
- 📅 **破坏性日期水印**：橙色发光日期戳，不可移除的复古感
- 🎬 **滤镜视频录制**：支持带滤镜效果的视频拍摄
- 🎵 **沉浸式反馈**：快门声、震动反馈、OSD 显示

---

## 📸 功能预览

### 滤镜系统

| 滤镜 | 特色 | 适用场景 |
|------|------|---------|
| **Standard** | 原片直出，轻微锐化 | 日常记录 |
| **D-Log** | 电影级灰片，保留动态范围 | 专业后期 |
| **Classic S** | 索尼 CCD 风格，冷蓝调 | 街拍 |
| **Vintage C** | 佳能复古，暖黄肤色 | 人像 |
| **Mono CCD** | 黑白高反差，颗粒感 | 黑白摄影 |
| **Cyber 2000** | 赛博冷绿调 | 创意摄影 |
| **Soft Dream** | 柔光梦幻，高光溢出 | 艺术创作 |

### 相机控制

- ✅ **触控对焦**：点击画面任意位置对焦
- ✅ **曝光补偿**：上下滑动调节 EV (-2.0 到 +2.0)
- ✅ **数字变焦**：双指捏合缩放 (1.0x - 4.0x)
- ✅ **闪光灯**：OFF / AUTO / ON / TORCH 四种模式
- ✅ **画幅比例**：4:3 / 16:9 / 1:1
- ✅ **倒计时**：3s / 10s 延时拍摄

### 视频录制

- 🎬 支持所有滤镜实时应用
- 🎤 音频开关控制
- ⏱️ 录制时长显示 (MM:SS)
- 💾 自动保存到相册

---

## 🚀 快速开始

### 环境要求

- **DevEco Studio** 5.0.0+
- **HarmonyOS SDK** API 12
- **Node.js** 18.x+
- **HarmonyOS 设备**（或模拟器）

### 安装使用

```bash
# 1. 克隆项目
git clone <repository-url>
cd RetroLogCam

# 2. 安装依赖
npm install

# 3. 构建应用
hvigor assembleHap --mode release

# 4. 部署到设备
hdc install -r entry/build/default/outputs/default/entry-default-signed.hap
```

### 快速体验

1. **启动应用** → 点击图标，授予相机权限
2. **选择滤镜** → 底部左右滑动选择
3. **对焦拍摄** → 点击画面，点击快门
4. **查看照片** → 自动保存到系统相册

---

## 📁 项目结构

```
RetroLogCam/
├── entry/src/main/ets/
│   ├── pages/
│   │   └── Index.ets              # 主页面 (@Entry)
│   ├── components/                # UI 组件
│   │   ├── CameraPreview.ets      # 相机预览
│   │   ├── ControlBar.ets         # 底部控制栏
│   │   ├── TopBar.ets             # 顶部工具栏
│   │   ├── OSDLayer.ets           # OSD 信息层
│   │   └── SettingsMenu.ets       # 设置面板
│   ├── services/                  # 业务逻辑
│   │   ├── CameraService.ets      # 相机硬件服务
│   │   ├── ImageProcessor.ets     # 图像处理服务
│   │   ├── FilterService.ets      # 滤镜配置服务
│   │   └── SoundService.ets       # 音效服务
│   ├── viewmodel/                 # 状态管理
│   │   └── CameraViewModel.ets    # 响应式状态
│   └── common/constants/
│       └── Constants.ets          # 枚举与常量
├── AppScope/                      # 应用资源
└── oh-package.json5              # 项目配置
```

---

## 🛠️ 技术栈

- **语言**: ArkTS (TypeScript for HarmonyOS)
- **UI 框架**: ArkUI (声明式 UI)
- **相机 API**: CameraKit
- **图像处理**: ImageKit (PixelMap)
- **媒体存储**: MediaLibraryKit
- **构建工具**: Hvigor

### 架构模式

```
View (UI) → ViewModel (State) → Service (Business Logic) → HarmonyOS API
```

---

## 📖 文档

- **[完整使用指南](./COMPLETE_USAGE_GUIDE.md)** - 详细的功能说明和使用教程
- **[技术架构规格书](./技术架构规格书RetroLogCam.md)** - 产品需求与技术规格
- **[项目功能文档](./README_RetroLogCam.md)** - 技术架构详解
- **[用户手册](./USAGE_GUIDE.md)** - 基础使用说明

---

## 🎨 滤镜算法示例

### D-Log 矩阵（电影级 Log）

```typescript
const D_LOG_MATRIX: ColorMatrix = [
  0.75, 0.15, 0.10, 0.0, 0.08,  // 红通道：-25% 饱和，+8% 亮度
  0.15, 0.70, 0.15, 0.0, 0.08,  // 绿通道：-30% 饱和，+8% 亮度
  0.10, 0.15, 0.75, 0.0, 0.08,  // 蓝通道：-25% 饱和，+8% 亮度
  0.0,  0.0,  0.0,  1.0, 0.0    // Alpha 通道不变
]
```

**效果**：饱和度 -40%，对比度 -30%，阴影 +20%，保留最大动态范围

---

## 🔧 扩展开发

### 添加新滤镜

只需 3 步：

1. 在 `Constants.ets` 添加枚举
2. 在 `FilterService.ets` 定义矩阵和配置
3. 在 `FilterService.getAllFilterTypes()` 中注册

### 示例：添加"富士胶片"滤镜

```typescript
// FilterService.ets
const FUJI_MATRIX: ColorMatrix = [
  1.1, 0.0, 0.0, 0.0, 0.02,
  0.0, 1.05, 0.05, 0.0, 0.01,
  0.0, 0.05, 0.95, 0.0, -0.02,
  0.0, 0.0, 0.0, 1.0, 0.0
]

// 在 getConfig() 中添加 case
case FilterType.FUJI:
  return {
    name: 'Fuji Film',
    matrix: FUJI_MATRIX,
    contrast: 1.1,
    saturation: 1.05,
    brightness: 0.0,
    sharpness: 0.15,
    grain: 0.12,
    warmth: 0.1
  }
```

---

## 📊 性能特点

- ✅ **低功耗**：实时预览使用 CSS 混合模式，不消耗 GPU
- ✅ **快速响应**：拍照到保存 < 1 秒
- ✅ **内存安全**：及时释放 PixelMap 资源
- ✅ **兼容性**：支持 HarmonyOS API 12+ 设备

---

## 🎯 使用场景

| 场景 | 推荐滤镜 | 技巧 |
|-----|---------|------|
| 城市夜景 | Cyber 2000 | EV -0.5，变焦 2.0x |
| 人像摄影 | Vintage C | 自然光，开启日期水印 |
| 黑白创作 | Mono CCD | 强对比光线 |
| 专业后期 | D-Log | 正常曝光，后期调色 |
| 街头快照 | Classic S | 快速抓拍，自动对焦 |
| 梦幻人像 | Soft Dream | 逆光拍摄 |

---

## 🐛 常见问题

**Q: 照片和预览看起来不同？**
A: 这是正常的。最终照片会经过完整的像素级处理，包括滤镜、颗粒、水印，比预览更精细。

**Q: 视频如何录制声音？**
A: 在设置中开启"声音开关"，并授予麦克风权限。

**Q: 照片保存在哪里？**
A: 系统相册的 `RetroLogCam` 文件夹中。

**Q: 如何关闭日期水印？**
A: 点击⚙️ → 关闭"日期水印"开关。

---

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

---

## 📄 许可证

MIT License © 2025 RetroLogCam

---

## 💡 致谢

- 灵感来源于经典 CCD 数码相机（Sony, Canon, Fuji）
- 基于 HarmonyOS CameraKit 和 ImageKit
- 专为摄影爱好者打造

---

## 🌟 Star History

[![Star History Chart](https://api.star-history.com/svg?repos=yourusername/RetroLogCam&type=Date)](https://star-history.com/#yourusername/RetroLogCam&Date)

---

**开始您的复古摄影之旅吧！** 📸✨

---

## 快速联系

- 📧 问题反馈：通过 GitHub Issues
- 📖 详细文档：[COMPLETE_USAGE_GUIDE.md](./COMPLETE_USAGE_GUIDE.md)
- 🔧 技术规格：[技术架构规格书](./技术架构规格书RetroLogCam.md)
