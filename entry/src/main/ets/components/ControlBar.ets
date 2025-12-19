/**
 * ControlBar - 底部控制栏组件 - 极简复古版
 * 包含滤镜选择器、快门按钮、相册预览
 * 背景: 奶油白色 (#FFFEF5)
 */

import { AppColors, AppSizes, FilterType, getFilterName } from '../common/constants/Constants'
import { CameraViewModel } from '../viewmodel/CameraViewModel'
import { ShutterButton } from './ShutterButton'
import { FilterService } from '../services/FilterService'
import { CircleButtonParams } from '../common/types/ComponentTypes'
import { AppAnimations, AppBorders, AppShadows, AppGradients, AppGlowEffects, LightThemeShadows } from '../common/styles/Styles'

@Component
export struct ControlBar {
  @ObjectLink viewModel: CameraViewModel
  // 快门点击回调（拍照）
  onShutterPress: () => void = () => {}
  // 长按回调（录像）
  onLongPress: () => void = () => {}
  // 相册点击回调
  onGalleryPress: () => void = () => {}
  // 震动反馈回调
  onVibrate: () => void = () => {}
  // 最近照片缩略图
  @Prop lastPhotoUri: string = ''
  // 滤镜列表
  private readonly filters: FilterType[] = FilterService.getAllFilterTypes()

  build() {
    Column() {
      // ==================== 滤镜选择器 - 极简复古风 ====================
      Row() {
        Swiper() {
          ForEach(this.filters, (filter: FilterType) => {
            Column() {
              Text(getFilterName(filter))
                .fontSize(this.viewModel.currentFilter === filter
                  ? AppSizes.FILTER_FONT_SELECTED + 4
                  : AppSizes.FILTER_FONT_UNSELECTED + 2)
                .fontWeight(this.viewModel.currentFilter === filter
                  ? FontWeight.Bold
                  : FontWeight.Normal)
                .fontColor(this.viewModel.currentFilter === filter
                  ? AppColors.WARM_YELLOW
                  : AppColors.MEDIUM_TEXT)
                .letterSpacing(this.viewModel.currentFilter === filter ? 2 : 1)
                .opacity(this.viewModel.currentFilter === filter ? 1.0 : 0.6)
                .animation({
                  duration: 200,
                  curve: Curve.EaseOut
                })
            }
            .width('100%')
            .justifyContent(FlexAlign.Center)
          })
        }
        .index(this.filters.indexOf(this.viewModel.currentFilter))
        .loop(true)
        .indicator(false)
        .displayCount(1)
        .prevMargin(60)
        .nextMargin(60)
        .onChange((index: number) => {
          if (this.filters[index] !== this.viewModel.currentFilter) {
            this.viewModel.setFilter(this.filters[index])
            this.onVibrate()
          }
        })
      }
      .width('100%')
      .height(50)
      .margin({ bottom: 16 })

      // ==================== 主控制区 ====================
      Row() {
        // 左侧 - 滤镜信息/切换按钮
        Column({ space: 4 }) {
          // 滤镜名称
          Text(this.viewModel.getCurrentFilterName())
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .fontColor(AppColors.DARK_TEXT)

          // 滤镜描述
          Text(FilterService.getFilterDescription(this.viewModel.currentFilter))
            .fontSize(10)
            .fontColor(AppColors.MEDIUM_TEXT)
            .maxLines(1)
        }
        .width(100)
        .alignItems(HorizontalAlign.Start)
        .onClick(() => {
          this.viewModel.nextFilter()
          this.onVibrate()
        })

        Blank()

        // 中间 - 快门按钮
        ShutterButton({
          onShutterPress: this.onShutterPress,
          onLongPress: this.onLongPress,
          isDisabled: this.viewModel.isCapturing,
          isRecording: this.viewModel.isRecording
        })

        Blank()

        // 右侧 - 相册预览
        this.GalleryPreview()
      }
      .width('100%')
      .padding({ left: 24, right: 24 })
    }
    .width('100%')
    .height(AppSizes.BOTTOM_CONTROL_HEIGHT)
    .padding({ top: 16, bottom: 24 })
    .backgroundColor(AppColors.CREAM_BG)
    .border({
      width: { top: 1 },
      color: AppColors.LIGHT_BORDER
    })
    .borderRadius({ topLeft: 28, topRight: 28 })
    .shadow(LightThemeShadows.PANEL)
  }

  /**
   * 相册预览缩略图 Builder
   */
  @Builder
  GalleryPreview() {
    Stack() {
      // 外框 - 浅灰边框
      Column()
        .width(56)
        .height(56)
        .border({
          width: 2,
          color: AppColors.LIGHT_BORDER
        })
        .borderRadius(12)
        .backgroundColor(AppColors.OFF_WHITE_BG)

      // 预览图或占位图标
      if (this.lastPhotoUri && this.lastPhotoUri.length > 0) {
        Image(this.lastPhotoUri)
          .width(52)
          .height(52)
          .borderRadius(10)
          .objectFit(ImageFit.Cover)
      } else {
        // 占位图标
        Column() {
          Image($r('app.media.ic_gallery_placeholder'))
            .width(24)
            .height(24)
            .fillColor(AppColors.MEDIUM_TEXT)
        }
        .width(52)
        .height(52)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      }
    }
    .width(56)
    .height(56)
    .onClick(() => {
      this.onGalleryPress()
    })
  }
}

/**
 * 简化版底部控制栏 - 仅快门和基本控制
 */
@Component
export struct SimpleControlBar {
  @ObjectLink viewModel: CameraViewModel
  // 快门点击回调
  onShutterPress: () => void = () => {}
  // 震动反馈回调
  onVibrate: () => void = () => {}

  build() {
    Row() {
      // 切换前后摄像头
      this.CircleButton({
        icon: $r('app.media.ic_switch_camera'),
        onClick: () => {
          this.viewModel.toggleCamera()
          this.onVibrate()
        }
      })

      Blank()

      // 快门按钮
      ShutterButton({
        onShutterPress: this.onShutterPress,
        isDisabled: this.viewModel.isCapturing
      })

      Blank()

      // 滤镜按钮
      this.CircleButton({
        icon: $r('app.media.ic_filter'),
        text: this.viewModel.getCurrentFilterName().slice(0, 3),
        onClick: () => {
          this.viewModel.nextFilter()
          this.onVibrate()
        }
      })
    }
    .width('100%')
    .height(100)
    .padding({ left: 40, right: 40 })
    .backgroundColor(AppColors.SECONDARY_BG)
  }

  @Builder
  CircleButton(params: CircleButtonParams) {
    Column({ space: 4 }) {
      Stack() {
        Circle()
          .width(50)
          .height(50)
          .fill('#252525')
          .border({
            width: 1.5,
            color: AppColors.METAL_SILVER
          })

        Image(params.icon)
          .width(24)
          .height(24)
          .fillColor(AppColors.WHITE)
      }

      if (params.text) {
        Text(params.text)
          .fontSize(10)
          .fontColor(AppColors.TEXT_INACTIVE)
          .fontFamily('monospace')
      }
    }
    .onClick(params.onClick)
  }
}
