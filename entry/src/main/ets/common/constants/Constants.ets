/**
 * RetroLog Cam 常量定义
 * 定义所有枚举类型和常量值
 */

// 闪光灯模式
export enum FlashMode {
  OFF = 0,      // 关闭 (图标灰色)
  AUTO = 1,     // 自动 (图标白色)
  ON = 2,       // 强制开启 (图标黄色)
  TORCH = 3     // 手电筒常亮 (用于暗光取景)
}

// 滤镜类型
export enum FilterType {
  STANDARD = 0,   // 原片 - 无滤镜，轻微锐化
  D_LOG = 1,      // 电影级 Log 模式 - 低饱和度，低对比度
  CLASSIC_S = 2,  // 索尼 CCD 风格 - 偏冷，高锐度
  VINTAGE_C = 3,  // 佳能风格 - 偏暖，洋红肤色优化
  MONO_CCD = 4,   // 黑白高反差 - 颗粒感
  CYBER_2000 = 5, // 黑客帝国风格 - 偏冷绿色调
  SOFT_DREAM = 6  // 柔光梦幻 - 高光溢出
}

// 画幅比例
export enum AspectRatio {
  RATIO_4_3 = 0,  // 4:3 经典CCD全画幅
  RATIO_16_9 = 1, // 16:9 电影感
  RATIO_1_1 = 2   // 1:1 正方形
}

// 倒计时模式
export enum TimerMode {
  OFF = 0,
  SECONDS_3 = 3,
  SECONDS_10 = 10
}

// 滤镜名称映射 - 使用函数代替 Record
export function getFilterName(filter: FilterType): string {
  switch (filter) {
    case FilterType.STANDARD:
      return 'Standard'
    case FilterType.D_LOG:
      return 'D-Log'
    case FilterType.CLASSIC_S:
      return 'Classic S'
    case FilterType.VINTAGE_C:
      return 'Vintage C'
    case FilterType.MONO_CCD:
      return 'Mono CCD'
    case FilterType.CYBER_2000:
      return 'Cyber 2K'
    case FilterType.SOFT_DREAM:
      return 'Soft Dream'
    default:
      return 'Standard'
  }
}

// 为了兼容性保留 FilterNames 对象风格访问
export const FilterNames: Map<FilterType, string> = new Map([
  [FilterType.STANDARD, 'Standard'],
  [FilterType.D_LOG, 'D-Log'],
  [FilterType.CLASSIC_S, 'Classic S'],
  [FilterType.VINTAGE_C, 'Vintage C'],
  [FilterType.MONO_CCD, 'Mono CCD'],
  [FilterType.CYBER_2000, 'Cyber 2K'],
  [FilterType.SOFT_DREAM, 'Soft Dream']
])

// 画幅比例名称映射 - 使用函数
export function getAspectRatioName(ratio: AspectRatio): string {
  switch (ratio) {
    case AspectRatio.RATIO_4_3:
      return '4:3'
    case AspectRatio.RATIO_16_9:
      return '16:9'
    case AspectRatio.RATIO_1_1:
      return '1:1'
    default:
      return '4:3'
  }
}

// 颜色常量 - Y2K 工业复古风格 + 科技感增强
export class AppColors {
  // 主背景色 (机身黑)
  static readonly PRIMARY_BG: string = '#121212'
  // 次级背景色 (面板灰)
  static readonly SECONDARY_BG: string = '#1A1A1A'
  // 深灰面板
  static readonly PANEL_GRAY: string = '#2C2C2C'
  // 指示灯橙 (日期、警告)
  static readonly ACCENT_ORANGE: string = '#FF5500'
  // 对焦绿 (标准复古数码绿)
  static readonly FOCUS_GREEN: string = '#00FF00'
  // 金属银 (按钮边框、高亮文字)
  static readonly METAL_SILVER: string = '#D1D5DB'
  // 金属渐变起始色
  static readonly METAL_GRADIENT_START: string = '#E0E0E0'
  // 金属渐变结束色
  static readonly METAL_GRADIENT_END: string = '#808080'
  // 非激活文字
  static readonly TEXT_INACTIVE: string = '#6B7280'
  // REC 红色
  static readonly REC_RED: string = '#FF0000'
  // 闪光灯黄色
  static readonly FLASH_YELLOW: string = '#FFD700'
  // 白色
  static readonly WHITE: string = '#FFFFFF'
  // 黑色
  static readonly BLACK: string = '#000000'
  // 半透明黑
  static readonly SEMI_TRANSPARENT_BLACK: string = '#80000000'

  // ==================== 科技感发光色 ====================
  // 青色发光 (主要科技感强调色)
  static readonly GLOW_CYAN: string = '#00FFFF'
  // 紫色发光 (次要科技感强调色)
  static readonly GLOW_PURPLE: string = '#9966FF'
  // 霾虹绿发光
  static readonly GLOW_NEON_GREEN: string = '#39FF14'
  // 电子蓝
  static readonly ELECTRIC_BLUE: string = '#0080FF'
  // 品红科技感
  static readonly TECH_MAGENTA: string = '#FF00FF'

  // ==================== 玻璃效果色 ====================
  // 玻璃边框色
  static readonly GLASS_BORDER: string = '#40FFFFFF'
  // 玻璃背景色
  static readonly GLASS_BG: string = '#1A1A1ACC'
  // 激活状态玻璃背景
  static readonly GLASS_BG_ACTIVE: string = '#30FFFFFF'

  // ==================== 浅色极简复古主题 ====================
  // 奶油白背景 (主背景)
  static readonly CREAM_BG: string = '#FFFEF5'
  // 米白背景 (次级背景)
  static readonly OFF_WHITE_BG: string = '#FAF9F6'
  // 暖黄强调色 (开关、选中状态)
  static readonly WARM_YELLOW: string = '#FFCC00'
  // 琥珀黄 (按钮hover)
  static readonly AMBER_YELLOW: string = '#FFB800'
  // 深灰文字 (主要文字)
  static readonly DARK_TEXT: string = '#1A1A1A'
  // 中灰文字 (次要文字)
  static readonly MEDIUM_TEXT: string = '#6B6B6B'
  // 浅灰文字 (辅助文字)
  static readonly LIGHT_TEXT: string = '#9CA3AF'
  // 浅灰边框
  static readonly LIGHT_BORDER: string = '#E5E5E5'
  // 分隔线颜色
  static readonly DIVIDER_LIGHT: string = '#EBEBEB'
  // 浅色玻璃背景
  static readonly LIGHT_GLASS_BG: string = '#FFFFFFCC'
}

// 尺寸常量
export class AppSizes {
  // 顶部工具栏高度
  static readonly TOP_BAR_HEIGHT: number = 48
  // 底部控制区高度
  static readonly BOTTOM_CONTROL_HEIGHT: number = 180
  // 快门按钮外环直径
  static readonly SHUTTER_OUTER_SIZE: number = 72
  // 快门按钮内芯直径
  static readonly SHUTTER_INNER_SIZE: number = 50
  // 图标按钮大小
  static readonly ICON_BUTTON_SIZE: number = 44
  // 图标大小
  static readonly ICON_SIZE: number = 24
  // 滤镜选择器字体大小 (选中)
  static readonly FILTER_FONT_SELECTED: number = 16
  // 滤镜选择器字体大小 (未选中)
  static readonly FILTER_FONT_UNSELECTED: number = 12
  // OSD 字体大小
  static readonly OSD_FONT_SIZE: number = 14
  // 对焦框大小
  static readonly FOCUS_FRAME_SIZE: number = 80
  // 标准字体大小
  static readonly FONT_NORMAL: number = 14
}
