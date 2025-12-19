/**
 * CameraViewModel - 相机状态管理
 * 使用 @Observed 装饰器实现响应式状态管理
 */

import {
  FlashMode,
  FilterType,
  AspectRatio,
  TimerMode,
  getFilterName,
  getAspectRatioName
} from '../common/constants/Constants'
import { FilterService } from '../services/FilterService'

@Observed
export class CameraViewModel {
  // ==================== 相机状态 ====================
  // 闪光灯模式
  flashMode: FlashMode = FlashMode.OFF
  // 当前滤镜
  currentFilter: FilterType = FilterType.STANDARD
  // 画幅比例
  aspectRatio: AspectRatio = AspectRatio.RATIO_4_3
  // 倒计时模式
  timerMode: TimerMode = TimerMode.OFF
  // 是否前置摄像头
  isFrontCamera: boolean = false

  // ==================== UI 状态 ====================
  // 是否显示对焦框
  showFocusFrame: boolean = false
  // 对焦框位置 X
  focusX: number = 0
  // 对焦框位置 Y
  focusY: number = 0
  // 对焦状态: 'focusing' | 'success' | 'failed'
  focusState: string = 'success'
  // 是否正在拍照
  isCapturing: boolean = false
  // 倒计时剩余秒数
  countdownSeconds: number = 0
  // 是否显示设置菜单
  showSettings: boolean = false
  // 是否正在录像
  isRecording: boolean = false
  // REC 指示灯闪烁状态
  recIndicatorVisible: boolean = true
  // 录像时长（秒）
  recordingDuration: number = 0

  // ==================== 设置选项 ====================
  // 声音开关
  soundEnabled: boolean = true
  // 震动反馈
  vibrationEnabled: boolean = true
  // 构图线 (九宫格)
  gridEnabled: boolean = false
  // 前置摄像头镜像
  frontMirror: boolean = true
  // 日期水印
  dateStampEnabled: boolean = true

  // ==================== 模拟数据 (复古感) ====================
  // 模拟 ISO 值
  isoValue: number = 400
  // 曝光补偿值
  evValue: number = 0.0
  // 变焦倍数
  zoomRatio: number = 1.0
  // 电池电量 (模拟)
  batteryLevel: number = 75

  // ==================== 方法 ====================

  /**
   * 切换闪光灯模式
   * 循环切换: OFF -> AUTO -> ON -> TORCH -> OFF
   */
  toggleFlashMode(): void {
    const modes: FlashMode[] = [FlashMode.OFF, FlashMode.AUTO, FlashMode.ON, FlashMode.TORCH]
    const currentIndex = modes.indexOf(this.flashMode)
    const nextIndex = (currentIndex + 1) % modes.length
    this.flashMode = modes[nextIndex]
  }

  /**
   * 设置闪光灯模式
   */
  setFlashMode(mode: FlashMode): void {
    this.flashMode = mode
  }

  /**
   * 切换滤镜
   * @param filter 滤镜类型
   */
  setFilter(filter: FilterType): void {
    this.currentFilter = filter
  }

  /**
   * 下一个滤镜
   */
  nextFilter(): void {
    const filters = FilterService.getAllFilterTypes()
    const currentIndex = filters.indexOf(this.currentFilter)
    const nextIndex = (currentIndex + 1) % filters.length
    this.currentFilter = filters[nextIndex]
  }

  /**
   * 上一个滤镜
   */
  previousFilter(): void {
    const filters = FilterService.getAllFilterTypes()
    const currentIndex = filters.indexOf(this.currentFilter)
    const prevIndex = (currentIndex - 1 + filters.length) % filters.length
    this.currentFilter = filters[prevIndex]
  }

  /**
   * 获取当前滤镜名称
   */
  getCurrentFilterName(): string {
    return getFilterName(this.currentFilter)
  }

  /**
   * 切换画幅比例
   * 循环切换: 4:3 -> 16:9 -> 1:1 -> 4:3
   */
  toggleAspectRatio(): void {
    const ratios: AspectRatio[] = [AspectRatio.RATIO_4_3, AspectRatio.RATIO_16_9, AspectRatio.RATIO_1_1]
    const currentIndex = ratios.indexOf(this.aspectRatio)
    const nextIndex = (currentIndex + 1) % ratios.length
    this.aspectRatio = ratios[nextIndex]
  }

  /**
   * 获取当前画幅比例名称
   */
  getCurrentAspectRatioName(): string {
    return getAspectRatioName(this.aspectRatio)
  }

  /**
   * 切换倒计时模式
   * 循环切换: OFF -> 3s -> 10s -> OFF
   */
  toggleTimerMode(): void {
    const modes: TimerMode[] = [TimerMode.OFF, TimerMode.SECONDS_3, TimerMode.SECONDS_10]
    const currentIndex = modes.indexOf(this.timerMode)
    const nextIndex = (currentIndex + 1) % modes.length
    this.timerMode = modes[nextIndex]
  }

  /**
   * 获取倒计时显示文本
   */
  getTimerModeText(): string {
    switch (this.timerMode) {
      case TimerMode.OFF:
        return 'OFF'
      case TimerMode.SECONDS_3:
        return '3s'
      case TimerMode.SECONDS_10:
        return '10s'
      default:
        return 'OFF'
    }
  }

  /**
   * 切换前后摄像头
   */
  toggleCamera(): void {
    this.isFrontCamera = !this.isFrontCamera
  }

  /**
   * 设置对焦位置
   */
  setFocusPosition(x: number, y: number): void {
    this.focusX = x
    this.focusY = y
    this.showFocusFrame = true
    this.focusState = 'focusing'
  }

  /**
   * 设置对焦结果
   */
  setFocusResult(success: boolean): void {
    this.focusState = success ? 'success' : 'failed'
  }

  /**
   * 隐藏对焦框
   */
  hideFocusFrame(): void {
    this.showFocusFrame = false
  }

  /**
   * 设置曝光补偿
   * @param ev EV值，范围 -2.0 到 +2.0
   */
  setExposureValue(ev: number): void {
    this.evValue = Math.max(-2.0, Math.min(2.0, ev))
  }

  /**
   * 设置变焦倍数
   * @param ratio 变焦倍数，范围 1.0 到 4.0
   */
  setZoomRatio(ratio: number): void {
    this.zoomRatio = Math.max(1.0, Math.min(4.0, ratio))
  }

  /**
   * 更新模拟 ISO 值 (根据光线随机变化，增加复古感)
   */
  updateSimulatedISO(): void {
    const isoValues: number[] = [100, 200, 400, 800, 1600]
    const randomIndex = Math.floor(Math.random() * isoValues.length)
    this.isoValue = isoValues[randomIndex]
  }

  /**
   * 开始倒计时
   */
  startCountdown(): void {
    if (this.timerMode !== TimerMode.OFF) {
      this.countdownSeconds = this.timerMode
    }
  }

  /**
   * 减少倒计时
   */
  decrementCountdown(): void {
    if (this.countdownSeconds > 0) {
      this.countdownSeconds--
    }
  }

  /**
   * 切换设置菜单
   */
  toggleSettings(): void {
    this.showSettings = !this.showSettings
  }

  /**
   * 开始录像
   */
  startRecording(): void {
    this.isRecording = true
    this.recordingDuration = 0
  }

  /**
   * 停止录像
   */
  stopRecording(): void {
    this.isRecording = false
    this.recordingDuration = 0
  }

  /**
   * 增加录像时长
   */
  incrementRecordingDuration(): void {
    if (this.isRecording) {
      this.recordingDuration++
    }
  }

  /**
   * 获取格式化的录像时长
   * 格式: "MM:SS"
   */
  getFormattedDuration(): string {
    const minutes = Math.floor(this.recordingDuration / 60)
    const seconds = this.recordingDuration % 60
    return `${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}`
  }

  /**
   * 切换 REC 指示灯
   */
  toggleRecIndicator(): void {
    this.recIndicatorVisible = !this.recIndicatorVisible
  }

  /**
   * 获取格式化的日期字符串 (复古格式)
   * 格式: 'YY MM DD
   */
  getFormattedDate(): string {
    const now = new Date()
    const year = String(now.getFullYear()).slice(-2)
    const month = String(now.getMonth() + 1).padStart(2, '0')
    const day = String(now.getDate()).padStart(2, '0')
    return `'${year} ${month} ${day}`
  }

  /**
   * 获取格式化的时间字符串
   * 格式: HH:mm
   */
  getFormattedTime(): string {
    const now = new Date()
    const hours = String(now.getHours()).padStart(2, '0')
    const minutes = String(now.getMinutes()).padStart(2, '0')
    return `${hours}:${minutes}`
  }
}
