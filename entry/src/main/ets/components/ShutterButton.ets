/**
 * ShutterButton - 快门按钮组件 - 极简复古版
 * 黄色金属外环 + 黑色内芯
 * 支持长按触发录像功能
 */

import { AppColors, AppSizes } from '../common/constants/Constants'
import { AppGlowEffects, LightThemeShadows } from '../common/styles/Styles'

@Component
export struct ShutterButton {
  // 点击回调（拍照）
  onShutterPress: () => void = () => {}
  // 长按回调（录像）
  onLongPress: () => void = () => {}
  // 按下状态
  @State private isPressed: boolean = false
  // 是否禁用
  @Prop isDisabled: boolean = false
  // 是否正在录像
  @Prop isRecording: boolean = false

  build() {
    Stack() {
      // 外环发光效果 - 极简复古风 / 录像时红色
      Circle()
        .width(AppSizes.SHUTTER_OUTER_SIZE + 4)
        .height(AppSizes.SHUTTER_OUTER_SIZE + 4)
        .fill('transparent')
        .border({
          width: 2,
          color: this.isRecording ? AppColors.REC_RED :
                 (this.isPressed ? AppColors.WARM_YELLOW : AppColors.LIGHT_BORDER)
        })
        .shadow(LightThemeShadows.BUTTON)
        .animation({
          duration: 150,
          curve: Curve.EaseOut
        })

      // 外环 - 暖黄色 / 录像时红色
      Circle()
        .width(AppSizes.SHUTTER_OUTER_SIZE)
        .height(AppSizes.SHUTTER_OUTER_SIZE)
        .fill(this.isRecording ? '#FF0000' : AppColors.WARM_YELLOW)
        .shadow({
          radius: 12,
          color: this.isRecording ? '#40FF0000' : '#40000000',
          offsetX: 2,
          offsetY: 4
        })
        .scale({ x: this.isPressed ? 0.95 : 1.0, y: this.isPressed ? 0.95 : 1.0 })
        .animation({
          duration: 100,
          curve: Curve.EaseInOut
        })

      // 内圈装饰 - 深灰色
      Circle()
        .width(AppSizes.SHUTTER_OUTER_SIZE - 8)
        .height(AppSizes.SHUTTER_OUTER_SIZE - 8)
        .fill('#2A2A2A')

      // 内芯 - 录像时显示红色圆形
      Circle()
        .width(this.isPressed ? AppSizes.SHUTTER_INNER_SIZE * 0.88 : AppSizes.SHUTTER_INNER_SIZE)
        .height(this.isPressed ? AppSizes.SHUTTER_INNER_SIZE * 0.88 : AppSizes.SHUTTER_INNER_SIZE)
        .fill(this.isRecording ? AppColors.REC_RED : AppColors.BLACK)
        .shadow({
          radius: 6,
          color: this.isRecording ? '#80FF0000' : '#80000000',
          offsetX: 0,
          offsetY: 3
        })
        .animation({
          duration: 100,
          curve: Curve.EaseInOut
        })

      // 内芯高光
      Circle()
        .width(AppSizes.SHUTTER_INNER_SIZE - 12)
        .height(AppSizes.SHUTTER_INNER_SIZE - 12)
        .fill('#20FFFFFF')
        .opacity(0.25)
        .scale({
          x: this.isPressed ? 0.88 : 1.0,
          y: this.isPressed ? 0.88 : 1.0
        })
        .animation({
          duration: 100,
          curve: Curve.EaseInOut
        })

      // 装饰点 - 录像时红色，普通时黄色
      Circle()
        .width(8)
        .height(8)
        .fill(this.isRecording ? AppColors.REC_RED : AppColors.WARM_YELLOW)
        .position({ x: AppSizes.SHUTTER_OUTER_SIZE / 2 - 4, y: 10 })
        .opacity(this.isPressed ? 1.0 : 0.9)
        .animation({
          duration: 100,
          curve: Curve.EaseInOut
        })
    }
    .width(AppSizes.SHUTTER_OUTER_SIZE + 4)
    .height(AppSizes.SHUTTER_OUTER_SIZE + 4)
    .opacity(this.isDisabled ? 0.5 : 1.0)
    .onTouch((event: TouchEvent) => {
      if (this.isDisabled) return

      if (event.type === TouchType.Down) {
        this.isPressed = true
      } else if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
        this.isPressed = false
        if (event.type === TouchType.Up) {
          this.onShutterPress()
        }
      }
    })
    .gesture(
      LongPressGesture({ repeat: false, duration: 500 })
        .onAction(() => {
          // 长按触发录像功能
          console.info('ShutterButton: Long press detected - triggering recording')
          this.onLongPress()
        })
    )
  }
}

/**
 * 小型快门按钮 - 用于切换摄像头等
 */
@Component
export struct MiniShutterButton {
  // 点击回调
  onPress: () => void = () => {}
  // 图标
  @Prop icon: Resource | undefined = undefined
  // 是否选中
  @Prop isSelected: boolean = false
  // 按下状态
  @State private isPressed: boolean = false

  build() {
    Stack() {
      // 外环
      Circle()
        .width(44)
        .height(44)
        .fill(this.isSelected ? AppColors.OFF_WHITE_BG : AppColors.CREAM_BG)
        .border({
          width: 2,
          color: this.isSelected ? AppColors.WARM_YELLOW : AppColors.LIGHT_BORDER
        })
        .opacity(this.isPressed ? 0.7 : 1.0)
        .animation({
          duration: 100,
          curve: Curve.EaseInOut
        })

      // 图标
      if (this.icon) {
        Image(this.icon)
          .width(24)
          .height(24)
          .fillColor(this.isSelected ? AppColors.WARM_YELLOW : AppColors.DARK_TEXT)
      }
    }
    .width(44)
    .height(44)
    .onTouch((event: TouchEvent) => {
      if (event.type === TouchType.Down) {
        this.isPressed = true
      } else if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
        this.isPressed = false
        if (event.type === TouchType.Up) {
          this.onPress()
        }
      }
    })
  }
}
