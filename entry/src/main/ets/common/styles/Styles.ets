/**
 * 阴影配置接口
 */
export interface ShadowConfig {
  radius: number
  color: string
  offsetX: number
  offsetY: number
}

/**
 * 动画配置常量
 * 统一管理应用内所有动画的时长和曲线
 */
export class AppAnimations {
  // 快速动画 - 用于按钮点击、开关切换等即时反馈
  static readonly DURATION_FAST: number = 100
  // 正常动画 - 用于面板展开、滤镜切换等
  static readonly DURATION_NORMAL: number = 200
  // 慢速动画 - 用于页面转场、大面积元素变化
  static readonly DURATION_SLOW: number = 300
  // 超慢动画 - 用于复杂转场效果
  static readonly DURATION_EXTRA_SLOW: number = 500
}

/**
 * 阴影配置常量
 * 统一管理应用内各种阴影效果
 */
export class AppShadows {
  // 按钮阴影 - 悬浮感较轻
  static readonly BUTTON: ShadowConfig = {
    radius: 8,
    color: '#40000000',
    offsetX: 0,
    offsetY: 4
  }

  // 面板阴影 - 底部弹出面板使用
  static readonly PANEL: ShadowConfig = {
    radius: 20,
    color: '#80000000',
    offsetX: 0,
    offsetY: -4
  }

  // 快门按钮阴影
  static readonly SHUTTER: ShadowConfig = {
    radius: 8,
    color: '#40000000',
    offsetX: 0,
    offsetY: 4
  }

  // 卡片阴影 - 通用卡片元素
  static readonly CARD: ShadowConfig = {
    radius: 12,
    color: '#30000000',
    offsetX: 0,
    offsetY: 2
  }

  // 发光效果 - 用于指示灯等发光元素
  static readonly GLOW: ShadowConfig = {
    radius: 6,
    color: '#FF0000',
    offsetX: 0,
    offsetY: 0
  }
}

/**
 * 发光效果配置
 * 用于创建科技感等离子发光效果
 */
export class AppGlowEffects {
  // 青色发光 - 主要科技感强调
  static readonly CYAN: ShadowConfig = {
    radius: 10,
    color: '#00FFFF',
    offsetX: 0,
    offsetY: 0
  }

  // 紫色发光 - 次要科技感强调
  static readonly PURPLE: ShadowConfig = {
    radius: 10,
    color: '#9966FF',
    offsetX: 0,
    offsetY: 0
  }

  // 绿色发光 - 对焦成功
  static readonly GREEN: ShadowConfig = {
    radius: 8,
    color: '#00FF00',
    offsetX: 0,
    offsetY: 0
  }

  // 橙色发光 - 日期戳
  static readonly ORANGE: ShadowConfig = {
    radius: 8,
    color: '#FF5500',
    offsetX: 0,
    offsetY: 0
  }

  // 红色发光 - REC 指示灯
  static readonly RED: ShadowConfig = {
    radius: 8,
    color: '#FF0000',
    offsetX: 0,
    offsetY: 0
  }

  // 白色柔和发光 - 通用高亮
  static readonly WHITE_SOFT: ShadowConfig = {
    radius: 6,
    color: '#60FFFFFF',
    offsetX: 0,
    offsetY: 0
  }
}

/**
 * 边框圆角配置常量
 */
export class AppBorders {
  // 小圆角 - 用于按钮、标签等
  static readonly RADIUS_SMALL: number = 8
  // 中等圆角 - 用于卡片、面板等
  static readonly RADIUS_MEDIUM: number = 12
  // 大圆角 - 用于底部弹出面板、Toast 等
  static readonly RADIUS_LARGE: number = 24
  // 全圆角 - 用于圆形按钮
  static readonly RADIUS_FULL: number = 9999
}

/**
 * 常用渐变配置
 */
export class AppGradients {
  // 金属质感渐变 (快门按钮外环)
  static readonly METAL: [string, number][] = [
    ['#E0E0E0', 0.0],
    ['#808080', 1.0]
  ]

  // 半透明黑色渐变 (控制栏背景)
  static readonly DARK_PANEL: [string, number][] = [
    ['#1A1A1A', 0.0],
    ['#1D1D1D', 0.3],
    ['#1A1A1A', 0.6],
    ['#181818', 1.0]
  ]

  // 高光渐变 (按钮高光效果)
  static readonly HIGHLIGHT: [string, number][] = [
    ['#30FFFFFF', 0.0],
    ['#00FFFFFF', 0.5]
  ]
}

/**
 * 透明度常量
 */
export class AppOpacity {
  // 禁用状态
  static readonly DISABLED: number = 0.5
  // 非激活文字
  static readonly INACTIVE: number = 0.6
  // 按压状态
  static readonly PRESSED: number = 0.7
  // 遮罩层
  static readonly OVERLAY: number = 0.5
  // 辅助线条
  static readonly GUIDE_LINE: number = 0.3
}

/**
 * 间距常量
 */
export class AppSpacing {
  // 极小间距
  static readonly XS: number = 4
  // 小间距
  static readonly SM: number = 8
  // 中等间距
  static readonly MD: number = 16
  // 大间距
  static readonly LG: number = 24
  // 超大间距
  static readonly XL: number = 40
}

/**
 * 浅色主题阴影配置
 * 用于极简复古风格的柔和阴影
 */
export class LightThemeShadows {
  // 柔和卡片阴影 - 用于面板、卡片等
  static readonly CARD: ShadowConfig = {
    radius: 16,
    color: '#15000000',
    offsetX: 0,
    offsetY: 4
  }

  // 按钮阴影 - 用于交互按钮
  static readonly BUTTON: ShadowConfig = {
    radius: 8,
    color: '#10000000',
    offsetX: 0,
    offsetY: 2
  }

  // 面板阴影 - 底部弹出面板
  static readonly PANEL: ShadowConfig = {
    radius: 24,
    color: '#20000000',
    offsetX: 0,
    offsetY: -4
  }

  // 开关阴影
  static readonly TOGGLE: ShadowConfig = {
    radius: 4,
    color: '#15000000',
    offsetX: 0,
    offsetY: 1
  }
}
