/**
 * OSDLayer - On-Screen Display 复古参数显示层 - 极简复古版
 * 模拟老式 DV 机的屏幕参数显示效果
 */

import { AppColors, AppSizes } from '../common/constants/Constants'
import { CameraViewModel } from '../viewmodel/CameraViewModel'
import { 
  FocusFrameParams, 
  FocusState, 
  GridLinesParams 
} from '../common/types/ComponentTypes'
import { AppGlowEffects, LightThemeShadows, AppOpacity } from '../common/styles/Styles'

/**
 * 九宫格构图线 Builder (本地定义)
 */
@Builder
function GridLinesBuilder(params?: GridLinesParams) {
  const opacity = params?.opacity ?? AppOpacity.GUIDE_LINE
  const color = params?.color ?? AppColors.WHITE

  Stack() {
    // 垂直线 1
    Line()
      .width(1)
      .height('100%')
      .backgroundColor(color)
      .opacity(opacity)
      .position({ x: '33.33%', y: 0 })

    // 垂直线 2
    Line()
      .width(1)
      .height('100%')
      .backgroundColor(color)
      .opacity(opacity)
      .position({ x: '66.66%', y: 0 })

    // 水平线 1
    Line()
      .width('100%')
      .height(1)
      .backgroundColor(color)
      .opacity(opacity)
      .position({ x: 0, y: '33.33%' })

    // 水平线 2
    Line()
      .width('100%')
      .height(1)
      .backgroundColor(color)
      .opacity(opacity)
      .position({ x: 0, y: '66.66%' })
  }
  .width('100%')
  .height('100%')
}

/**
 * 对焦框 Builder (本地定义)
 */
@Builder
function FocusFrameBuilder(params: FocusFrameParams) {
  const size = params.size
  const focusColor = params.color
  const showCenterCross = params.state === 'success'

  Stack() {
    // 左上角
    Column() {
      Row()
        .width(20)
        .height(3)
        .backgroundColor(focusColor)
      Row()
        .width(3)
        .height(17)
        .backgroundColor(focusColor)
    }
    .alignItems(HorizontalAlign.Start)
    .position({ x: 0, y: 0 })

    // 右上角
    Column() {
      Row()
        .width(20)
        .height(3)
        .backgroundColor(focusColor)
      Row()
        .width(3)
        .height(17)
        .backgroundColor(focusColor)
    }
    .alignItems(HorizontalAlign.End)
    .position({ x: size - 20, y: 0 })

    // 左下角
    Column() {
      Row()
        .width(3)
        .height(17)
        .backgroundColor(focusColor)
      Row()
        .width(20)
        .height(3)
        .backgroundColor(focusColor)
    }
    .alignItems(HorizontalAlign.Start)
    .position({ x: 0, y: size - 20 })

    // 右下角
    Column() {
      Row()
        .width(3)
        .height(17)
        .backgroundColor(focusColor)
      Row()
        .width(20)
        .height(3)
        .backgroundColor(focusColor)
    }
    .alignItems(HorizontalAlign.End)
    .position({ x: size - 20, y: size - 20 })

    // 中心十字 (对焦成功时显示)
    if (showCenterCross) {
      // 水平线
      Row()
        .width(16)
        .height(2)
        .backgroundColor(focusColor)
        .position({ x: (size - 16) / 2, y: (size - 2) / 2 })

      // 垂直线
      Row()
        .width(2)
        .height(16)
        .backgroundColor(focusColor)
        .position({ x: (size - 2) / 2, y: (size - 16) / 2 })
    }
  }
  .width(size)
  .height(size)
  .position({
    x: params.x - size / 2,
    y: params.y - size / 2
  })
  .animation({
    duration: 200,
    curve: Curve.EaseOut
  })
}

@Component
export struct OSDLayer {
  @ObjectLink viewModel: CameraViewModel
  // REC 指示灯闪烁定时器 ID
  private recBlinkTimerId: number = -1

  aboutToAppear(): void {
    // 启动 REC 指示灯闪烁效果
    this.startRecBlink()
  }

  aboutToDisappear(): void {
    // 清理定时器
    if (this.recBlinkTimerId !== -1) {
      clearInterval(this.recBlinkTimerId)
    }
  }

  private startRecBlink(): void {
    this.recBlinkTimerId = setInterval(() => {
      this.viewModel.toggleRecIndicator()
    }, 800)
  }

  build() {
    Stack() {
      // ==================== 左上角: REC 指示器 - 极简复古风 ====================
      Row({ space: 6 }) {
        // 红色圆点
        Circle()
          .width(10)
          .height(10)
          .fill(AppColors.REC_RED)
          .opacity(this.viewModel.isRecording ? 
                   (this.viewModel.recIndicatorVisible ? 1.0 : 0.3) : 0.3)
          .animation({
            duration: 200,
            curve: Curve.EaseOut
          })

        // 录像时显示时长，否则显示 REC
        Text(this.viewModel.isRecording ? 
             `REC ${this.viewModel.getFormattedDuration()}` : 'REC')
          .fontSize(AppSizes.OSD_FONT_SIZE)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.viewModel.isRecording ? 
                     AppColors.REC_RED : 
                     (this.viewModel.recIndicatorVisible ? AppColors.DARK_TEXT : AppColors.MEDIUM_TEXT))
          .letterSpacing(2)
          .backgroundColor(this.viewModel.isRecording ? 
                          '#FFCCCC' : 
                          (this.viewModel.recIndicatorVisible ? '#FFFEF5CC' : 'transparent'))
          .padding({ left: 4, right: 4 })
          .borderRadius(4)
      }
      .position({ x: 16, y: 16 })

      // ==================== 右上角: 电池图标 ====================
      Row({ space: 4 }) {
        // 电池图标 (简化版)
        Row() {
          // 电池主体
          Row() {
            // 电量条
            Row()
              .width(`${this.viewModel.batteryLevel}%`)
              .height('100%')
              .backgroundColor(this.getBatteryColor())
              .borderRadius(2)
          }
          .width(24)
          .height(12)
          .border({ width: 1.5, color: AppColors.DARK_TEXT })
          .borderRadius(3)
          .padding(2)

          // 电池头
          Row()
            .width(3)
            .height(6)
            .backgroundColor(AppColors.DARK_TEXT)
            .borderRadius({ topRight: 2, bottomRight: 2 })
        }

        // 电量百分比
        Text(`${this.viewModel.batteryLevel}%`)
          .fontSize(12)
          .fontColor(AppColors.DARK_TEXT)
          .backgroundColor('#FFFEF5CC')
          .padding({ left: 4, right: 4 })
          .borderRadius(4)
      }
      .position({ x: '100%', y: 16 })
      .translate({ x: -80 })

      // ==================== 左下角: ISO 数值 - 极简复古风 ====================
      Column({ space: 4 }) {
        Text('ISO')
          .fontSize(10)
          .fontColor(AppColors.WARM_YELLOW)
          .letterSpacing(1)
          .backgroundColor('#FFFEF5CC')
          .padding({ left: 4, right: 4 })
          .borderRadius(4)

        Text(`${this.viewModel.isoValue}`)
          .fontSize(AppSizes.OSD_FONT_SIZE + 2)
          .fontWeight(FontWeight.Bold)
          .fontColor(AppColors.DARK_TEXT)
          .letterSpacing(2)
          .backgroundColor('#FFFEF5CC')
          .padding({ left: 6, right: 6 })
          .borderRadius(4)
      }
      .alignItems(HorizontalAlign.Start)
      .position({ x: 16, y: '100%' })
      .translate({ y: -60 })

      // ==================== EV 曝光补偿 (如果不为0) ====================
      if (this.viewModel.evValue !== 0) {
        Text(`EV ${this.viewModel.evValue > 0 ? '+' : ''}${this.viewModel.evValue.toFixed(1)}`)
          .fontSize(12)
          .fontColor(AppColors.DARK_TEXT)
          .backgroundColor('#FFFEF5CC')
          .padding({ left: 6, right: 6 })
          .borderRadius(4)
          .position({ x: 16, y: '100%' })
          .translate({ y: -100 })
      }

      // ==================== 变焦倍数 (如果不为1.0x) ====================
      if (this.viewModel.zoomRatio > 1.0) {
        Text(`${this.viewModel.zoomRatio.toFixed(1)}x`)
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor(AppColors.DARK_TEXT)
          .backgroundColor('#FFFEF5CC')
          .padding({ left: 8, right: 8, top: 4, bottom: 4 })
          .borderRadius(6)
          .position({ x: '50%', y: 16 })
          .translate({ x: -20 })
      }

      // ==================== 右下角: 日期戳 - 极简复古风 ====================
      Text(this.viewModel.getFormattedDate())
        .fontSize(AppSizes.OSD_FONT_SIZE)
        .fontWeight(FontWeight.Bold)
        .fontColor(AppColors.WARM_YELLOW)
        .backgroundColor('#1A1A1ACC')
        .padding({ left: 8, right: 8, top: 4, bottom: 4 })
        .borderRadius(4)
        .position({ x: '100%', y: '100%' })
        .translate({ x: -110, y: -40 })

      // ==================== 时间显示 ====================
      Text(this.viewModel.getFormattedTime())
        .fontSize(12)
        .fontColor(AppColors.WARM_YELLOW)
        .opacity(0.8)
        .backgroundColor('#1A1A1ACC')
        .padding({ left: 6, right: 6, top: 2, bottom: 2 })
        .borderRadius(4)
        .position({ x: '100%', y: '100%' })
        .translate({ x: -85, y: -65 })

      // ==================== 倒计时数字 (大号) ====================
      if (this.viewModel.countdownSeconds > 0) {
        Text(`${this.viewModel.countdownSeconds}`)
          .fontSize(120)
          .fontWeight(FontWeight.Bold)
          .fontColor(AppColors.WARM_YELLOW)
          .opacity(0.9)
          .shadow({
            radius: 20,
            color: '#00000040',
            offsetX: 0,
            offsetY: 4
          })
      }

      // ==================== 构图九宫格线 ====================
      if (this.viewModel.gridEnabled) {
        GridLinesBuilder()
      }

      // ==================== 对焦框 ====================
      if (this.viewModel.showFocusFrame) {
        FocusFrameBuilder({
          state: this.viewModel.focusState as FocusState,
          x: this.viewModel.focusX,
          y: this.viewModel.focusY,
          size: AppSizes.FOCUS_FRAME_SIZE,
          color: this.getFocusColor()
        })
      }
    }
    .width('100%')
    .height('100%')
    .hitTestBehavior(HitTestMode.Transparent) // 允许点击穿透
  }
  /**
   * 获取对焦框颜色
   */
  private getFocusColor(): string {
    switch (this.viewModel.focusState) {
      case 'focusing':
        return AppColors.WHITE
      case 'success':
        return AppColors.FOCUS_GREEN
      case 'failed':
        return AppColors.REC_RED
      default:
        return AppColors.FOCUS_GREEN
    }
  }

  /**
   * 获取电池颜色
   */
  private getBatteryColor(): string {
    if (this.viewModel.batteryLevel > 50) {
      return AppColors.FOCUS_GREEN
    } else if (this.viewModel.batteryLevel > 20) {
      return AppColors.FLASH_YELLOW
    } else {
      return AppColors.REC_RED
    }
  }
}

