/**
 * AspectMask - 画幅遮罩组件
 * 根据选择的画幅比例在取景器上显示黑色遮罩
 * 模拟电子取景器 (EVF) 边缘效果
 */

import { AppColors, AspectRatio } from '../common/constants/Constants'
import { CameraViewModel } from '../viewmodel/CameraViewModel'
import { 
  CornerMarkersParams, 
  VignetteParams 
} from '../common/types/ComponentTypes'
import { AppAnimations } from '../common/styles/Styles'

/**
 * 四角装饰标记 Builder (本地定义)
 */
@Builder
function CornerMarkersBuilder(params?: CornerMarkersParams) {
  const color = params?.color ?? '#60FFFFFF'
  const lineLength = params?.lineLength ?? 20
  const lineWidth = params?.lineWidth ?? 2

  Stack() {
    // 左上角
    Stack() {
      Row()
        .width(lineLength)
        .height(lineWidth)
        .backgroundColor(color)

      Column()
        .width(lineWidth)
        .height(lineLength)
        .backgroundColor(color)
    }
    .width(lineLength)
    .height(lineLength)
    .alignContent(Alignment.TopStart)
    .position({ x: 16, y: 16 })

    // 右上角
    Stack() {
      Row()
        .width(lineLength)
        .height(lineWidth)
        .backgroundColor(color)

      Column()
        .width(lineWidth)
        .height(lineLength)
        .backgroundColor(color)
    }
    .width(lineLength)
    .height(lineLength)
    .alignContent(Alignment.TopEnd)
    .position({ x: '100%', y: 16 })
    .translate({ x: -36, y: 0 })

    // 左下角
    Stack() {
      Row()
        .width(lineLength)
        .height(lineWidth)
        .backgroundColor(color)

      Column()
        .width(lineWidth)
        .height(lineLength)
        .backgroundColor(color)
    }
    .width(lineLength)
    .height(lineLength)
    .alignContent(Alignment.BottomStart)
    .position({ x: 16, y: '100%' })
    .translate({ x: 0, y: -36 })

    // 右下角
    Stack() {
      Row()
        .width(lineLength)
        .height(lineWidth)
        .backgroundColor(color)

      Column()
        .width(lineWidth)
        .height(lineLength)
        .backgroundColor(color)
    }
    .width(lineLength)
    .height(lineLength)
    .alignContent(Alignment.BottomEnd)
    .position({ x: '100%', y: '100%' })
    .translate({ x: -36, y: -36 })
  }
  .width('100%')
  .height('100%')
}

/**
 * 暗角效果 Builder (本地定义)
 */
@Builder
function VignetteEffectBuilder(params?: VignetteParams) {
  // 使用黑色半透明实现暗角效果
  Stack()
    .width('100%')
    .height('100%')
    .backgroundColor('#20000000')
}

@Component
export struct AspectMask {
  @ObjectLink viewModel: CameraViewModel
  // 预览区域宽度
  @Prop previewWidth: number = 0
  // 预览区域高度
  @Prop previewHeight: number = 0

  build() {
    Stack() {
      // 根据画幅比例显示不同的遮罩
      if (this.viewModel.aspectRatio === AspectRatio.RATIO_16_9) {
        // 16:9 - 上下黑边
        this.HorizontalMask()
      } else if (this.viewModel.aspectRatio === AspectRatio.RATIO_1_1) {
        // 1:1 - 左右黑边
        this.VerticalMask()
      }
      // 4:3 默认不需要遮罩
    }
    .width('100%')
    .height('100%')
    .hitTestBehavior(HitTestMode.Transparent) // 允许点击穿透
  }

  /**
   * 水平遮罩 (上下黑边) - 用于 16:9
   */
  @Builder
  HorizontalMask() {
    Column() {
      // 计算 16:9 在当前画面中需要裁切的高度
      // 假设原始是 4:3，需要从上下各裁切部分
      // 4:3 = 1.333... , 16:9 = 1.777...
      // 裁切比例 = (1 - 1.333/1.777) / 2 ≈ 12.5%

      // 顶部遮罩
      Row()
        .width('100%')
        .height('12.5%')
        .backgroundColor(AppColors.BLACK)

      Blank()

      // 底部遮罩
      Row()
        .width('100%')
        .height('12.5%')
        .backgroundColor(AppColors.BLACK)
    }
    .width('100%')
    .height('100%')
    .animation({
      duration: 300,
      curve: Curve.EaseInOut
    })
  }

  /**
   * 垂直遮罩 (左右黑边) - 用于 1:1
   */
  @Builder
  VerticalMask() {
    Row() {
      // 计算 1:1 在当前画面中需要裁切的宽度
      // 假设原始是 4:3，要变成 1:1
      // 需要从左右各裁切 (4/3 - 1) / 2 / (4/3) ≈ 12.5%

      // 左侧遮罩
      Column()
        .width('12.5%')
        .height('100%')
        .backgroundColor(AppColors.BLACK)

      Blank()

      // 右侧遮罩
      Column()
        .width('12.5%')
        .height('100%')
        .backgroundColor(AppColors.BLACK)
    }
    .width('100%')
    .height('100%')
    .animation({
      duration: 300,
      curve: Curve.EaseInOut
    })
  }
}

/**
 * 带圆角和装饰的高级遮罩
 * 模拟复古 CCD 相机的取景框效果
 */
@Component
export struct RetroViewfinderMask {
  @ObjectLink viewModel: CameraViewModel

  build() {
    Stack() {
      // 基础遮罩
      AspectMask({ viewModel: this.viewModel })

      // 四角装饰 - 复古取景框标记
      CornerMarkersBuilder()

      // 边缘渐变暗角效果 (模拟镜头暗角)
      VignetteEffectBuilder()
    }
    .width('100%')
    .height('100%')
    .hitTestBehavior(HitTestMode.Transparent)
  }
}

/**
 * 画幅比例指示器
 * 显示当前画幅的可视化预览
 */
@Component
export struct AspectRatioIndicator {
  @Prop currentRatio: AspectRatio = AspectRatio.RATIO_4_3

  build() {
    Row({ space: 8 }) {
      // 4:3 指示
      this.RatioIcon(AspectRatio.RATIO_4_3, 24, 18)

      // 16:9 指示
      this.RatioIcon(AspectRatio.RATIO_16_9, 28, 16)

      // 1:1 指示
      this.RatioIcon(AspectRatio.RATIO_1_1, 18, 18)
    }
  }

  @Builder
  RatioIcon(ratio: AspectRatio, width: number, height: number) {
    Column()
      .width(width)
      .height(height)
      .border({
        width: this.currentRatio === ratio ? 2 : 1,
        color: this.currentRatio === ratio ? AppColors.WHITE : AppColors.TEXT_INACTIVE
      })
      .borderRadius(2)
      .backgroundColor(this.currentRatio === ratio ? '#20FFFFFF' : 'transparent')
  }
}
