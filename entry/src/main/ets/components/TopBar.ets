/**
 * TopBar - 顶部工具栏组件 - 极简复古版
 * 包含闪光灯、画幅比例、倒计时、切换摄像头、设置按钮
 */

import { AppColors, AppSizes, FlashMode, TimerMode } from '../common/constants/Constants'
import { CameraViewModel } from '../viewmodel/CameraViewModel'
import { IconButtonParams, TextButtonParams, IconTextButtonParams } from '../common/types/ComponentTypes'
import { AppAnimations, AppBorders, AppGlowEffects, LightThemeShadows } from '../common/styles/Styles'

@Component
export struct TopBar {
  @ObjectLink viewModel: CameraViewModel
  // 震动反馈
  onVibrate: () => void = () => {}

  build() {
    Row() {
      // ==================== 左侧按钮组 ====================
      Row({ space: 8 }) {
        // 闪光灯按钮
        this.IconButton({
          icon: this.getFlashIcon(),
          color: this.getFlashColor(),
          onClick: () => {
            this.viewModel.toggleFlashMode()
            this.onVibrate()
          }
        })

        // 画幅比例按钮
        this.TextButton({
          text: this.viewModel.getCurrentAspectRatioName(),
          onClick: () => {
            this.viewModel.toggleAspectRatio()
            this.onVibrate()
          }
        })

        // 倒计时按钮
        this.IconTextButton({
          icon: $r('app.media.ic_timer'),
          text: this.viewModel.getTimerModeText(),
          isActive: this.viewModel.timerMode !== TimerMode.OFF,
          onClick: () => {
            this.viewModel.toggleTimerMode()
            this.onVibrate()
          }
        })
      }

      Blank()

      // ==================== 右侧按钮组 ====================
      Row({ space: 8 }) {
        // 切换摄像头按钮
        this.IconButton({
          icon: $r('app.media.ic_switch_camera'),
          color: AppColors.WHITE,
          onClick: () => {
            this.viewModel.toggleCamera()
            this.onVibrate()
          }
        })

        // 设置按钮
        this.IconButton({
          icon: $r('app.media.ic_settings'),
          color: AppColors.WHITE,
          onClick: () => {
            this.viewModel.toggleSettings()
            this.onVibrate()
          }
        })
      }
    }
    .width('100%')
    .height(AppSizes.TOP_BAR_HEIGHT)
    .padding({ left: 16, right: 16 })
    .backgroundColor('transparent')
  }

  /**
   * 获取闪光灯图标
   */
  private getFlashIcon(): Resource {
    switch (this.viewModel.flashMode) {
      case FlashMode.OFF:
        return $r('app.media.ic_flash_off')
      case FlashMode.AUTO:
        return $r('app.media.ic_flash_auto')
      case FlashMode.ON:
        return $r('app.media.ic_flash_on')
      case FlashMode.TORCH:
        return $r('app.media.ic_flash_on') // 使用开启图标代替手电筒
      default:
        return $r('app.media.ic_flash_off')
    }
  }

  /**
   * 获取闪光灯图标颜色 - 浅色主题
   */
  private getFlashColor(): string {
    switch (this.viewModel.flashMode) {
      case FlashMode.OFF:
        return AppColors.MEDIUM_TEXT
      case FlashMode.AUTO:
        return AppColors.DARK_TEXT
      case FlashMode.ON:
        return AppColors.WARM_YELLOW
      case FlashMode.TORCH:
        return AppColors.WARM_YELLOW
      default:
        return AppColors.MEDIUM_TEXT
    }
  }

  /**
   * 图标按钮 Builder - 极简复古版
   */
  @Builder
  IconButton(params: IconButtonParams) {
    Button() {
      Image(params.icon)
        .width(24)
        .height(24)
        .fillColor(params.color)
    }
    .width(AppSizes.ICON_BUTTON_SIZE)
    .height(AppSizes.ICON_BUTTON_SIZE)
    .backgroundColor(AppColors.LIGHT_GLASS_BG)
    .border({
      width: 1,
      color: AppColors.LIGHT_BORDER
    })
    .borderRadius(AppSizes.ICON_BUTTON_SIZE / 2)
    .shadow(LightThemeShadows.BUTTON)
    .onClick(params.onClick)
    .stateStyles({
      pressed: {
        .backgroundColor(AppColors.OFF_WHITE_BG)
        .scale({ x: 0.95, y: 0.95 })
      }
    })
    .animation({
      duration: 150,
      curve: Curve.EaseOut
    })
  }

  /**
   * 文字按钮 Builder - 极简复古版
   */
  @Builder
  TextButton(params: TextButtonParams) {
    Button() {
      Text(params.text)
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .fontColor(AppColors.DARK_TEXT)
        .letterSpacing(1)
    }
    .height(AppSizes.ICON_BUTTON_SIZE)
    .padding({ left: 14, right: 14 })
    .backgroundColor(AppColors.LIGHT_GLASS_BG)
    .border({
      width: 1,
      color: AppColors.WARM_YELLOW
    })
    .borderRadius(AppSizes.ICON_BUTTON_SIZE / 2)
    .shadow(LightThemeShadows.BUTTON)
    .onClick(params.onClick)
    .stateStyles({
      pressed: {
        .backgroundColor(AppColors.OFF_WHITE_BG)
        .scale({ x: 0.95, y: 0.95 })
      }
    })
    .animation({
      duration: 150,
      curve: Curve.EaseOut
    })
  }

  /**
   * 图标文字组合按钮 Builder - 极简复古版
   */
  @Builder
  IconTextButton(params: IconTextButtonParams) {
    Button() {
      Row({ space: 4 }) {
        Image(params.icon)
          .width(20)
          .height(20)
          .fillColor(params.isActive ? AppColors.WARM_YELLOW : AppColors.DARK_TEXT)

        Text(params.text)
          .fontSize(12)
          .fontWeight(FontWeight.Bold)
          .fontColor(params.isActive ? AppColors.WARM_YELLOW : AppColors.DARK_TEXT)
          .letterSpacing(1)
      }
    }
    .height(AppSizes.ICON_BUTTON_SIZE)
    .padding({ left: 12, right: 12 })
    .backgroundColor(params.isActive ? '#20FFCC00' : AppColors.LIGHT_GLASS_BG)
    .border({
      width: params.isActive ? 1.5 : 1,
      color: params.isActive ? AppColors.WARM_YELLOW : AppColors.LIGHT_BORDER
    })
    .borderRadius(AppSizes.ICON_BUTTON_SIZE / 2)
    .shadow(LightThemeShadows.BUTTON)
    .onClick(params.onClick)
    .stateStyles({
      pressed: {
        .backgroundColor(AppColors.OFF_WHITE_BG)
        .scale({ x: 0.95, y: 0.95 })
      }
    })
    .animation({
      duration: 150,
      curve: Curve.EaseOut
    })
  }
}
