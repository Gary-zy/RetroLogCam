/**
 * 组件接口类型定义
 * 统一管理各组件的 Builder 参数接口
 */

// ==================== TopBar 相关接口 ====================

/**
 * 图标按钮参数接口
 */
export interface IconButtonParams {
  icon: Resource
  color: string | ResourceColor
  onClick: () => void
}

/**
 * 文字按钮参数接口
 */
export interface TextButtonParams {
  text: string
  onClick: () => void
}

/**
 * 图标文字组合按钮参数接口
 */
export interface IconTextButtonParams {
  icon: Resource
  text: string
  isActive: boolean
  onClick: () => void
}

// ==================== SettingsMenu 相关接口 ====================

/**
 * 设置开关项参数接口
 */
export interface SettingToggleItemParams {
  title: string
  subtitle: string
  isOn: boolean
  onChange: (value: boolean) => void
}

/**
 * 快捷开关参数接口
 */
export interface QuickToggleParams {
  icon: Resource
  isActive: boolean
  onToggle: () => void
}

// ==================== ControlBar 相关接口 ====================

/**
 * 圆形按钮参数接口
 */
export interface CircleButtonParams {
  icon: Resource
  text?: string
  onClick: () => void
}

// ==================== 公共 Builder 接口 ====================

/**
 * 对焦状态类型
 */
export type FocusState = 'focusing' | 'success' | 'failed'

/**
 * 对焦框参数接口
 */
export interface FocusFrameParams {
  state: FocusState
  x: number
  y: number
  size: number
  color: string
}

/**
 * 角落标记参数接口
 */
export interface CornerMarkersParams {
  color?: string
  lineWidth?: number
  lineLength?: number
}

/**
 * 网格线参数接口
 */
export interface GridLinesParams {
  opacity?: number
  color?: string
}

/**
 * 暗角效果参数接口
 */
export interface VignetteParams {
  radius?: string
  innerOpacity?: number
  outerOpacity?: number
}
