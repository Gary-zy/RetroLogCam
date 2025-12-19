/**
 * FilterSelector - 滤镜选择器组件 - 极简复古版
 * 模拟物理拨轮的横向滚动选择器
 */

import { AppColors, AppSizes, FilterType, getFilterName } from '../common/constants/Constants'
import { CameraViewModel } from '../viewmodel/CameraViewModel'
import { FilterService } from '../services/FilterService'

@Component
export struct FilterSelector {
  @ObjectLink viewModel: CameraViewModel
  // 震动反馈回调
  onVibrate: () => void = () => {}
  // 滤镜列表
  private readonly filters: FilterType[] = FilterService.getAllFilterTypes()
  // Swiper 控制器
  private swiperController: SwiperController = new SwiperController()

  build() {
    Column() {
      // 滤镜名称显示
      Swiper(this.swiperController) {
          ForEach(this.filters, (filter: FilterType) => {
            Column() {
              // 滤镜名称
              Text(getFilterName(filter))
                .fontSize(this.viewModel.currentFilter === filter
                  ? AppSizes.FILTER_FONT_SELECTED + 2
                  : AppSizes.FILTER_FONT_UNSELECTED)
                .fontWeight(this.viewModel.currentFilter === filter
                  ? FontWeight.Bold
                  : FontWeight.Normal)
                .fontColor(this.viewModel.currentFilter === filter
                  ? AppColors.WARM_YELLOW
                  : AppColors.MEDIUM_TEXT)
                .textAlign(TextAlign.Center)
                .animation({
                  duration: 200,
                  curve: Curve.EaseOut
                })

              // 滤镜描述 (选中时显示)
              if (this.viewModel.currentFilter === filter) {
                Text(FilterService.getFilterDescription(filter))
                  .fontSize(10)
                  .fontColor(AppColors.MEDIUM_TEXT)
                  .margin({ top: 4 })
                  .textAlign(TextAlign.Center)
                  .maxLines(1)
              }
            }
            .width('100%')
            .justifyContent(FlexAlign.Center)
          })
      }
      .index(this.filters.indexOf(this.viewModel.currentFilter))
      .loop(true)
      .indicator(false)
      .displayCount(1)
      .prevMargin(80)
      .nextMargin(80)
      .onChange((index: number) => {
        if (this.filters[index] !== this.viewModel.currentFilter) {
          this.viewModel.setFilter(this.filters[index])
          this.onVibrate()
        }
      })
    }
    .width('100%')
    .height(60)
  }
}

/**
 * 紧凑型滤镜选择器 - 用于底部控制栏
 */
@Component
export struct CompactFilterSelector {
  @ObjectLink viewModel: CameraViewModel
  // 震动反馈回调
  onVibrate: () => void = () => {}

  build() {
    Row({ space: 8 }) {
      // 左箭头
      Text('◀')
        .fontSize(16)
        .fontColor(AppColors.MEDIUM_TEXT)
        .onClick(() => {
          this.viewModel.previousFilter()
          this.onVibrate()
        })

      // 当前滤镜名称
      Column({ space: 2 }) {
        Text(this.viewModel.getCurrentFilterName())
          .fontSize(AppSizes.FILTER_FONT_SELECTED)
          .fontWeight(FontWeight.Bold)
          .fontColor(AppColors.WARM_YELLOW)
          .textAlign(TextAlign.Center)
      }
      .width(100)

      // 右箭头
      Text('▶')
        .fontSize(16)
        .fontColor(AppColors.MEDIUM_TEXT)
        .onClick(() => {
          this.viewModel.nextFilter()
          this.onVibrate()
        })
    }
    .padding({ left: 8, right: 8 })
    .height(50)
    .justifyContent(FlexAlign.Center)
    .gesture(
      SwipeGesture({ direction: SwipeDirection.Horizontal })
        .onAction((event: GestureEvent) => {
          if (event.angle > 0) {
            // 向右滑动，上一个滤镜
            this.viewModel.previousFilter()
          } else {
            // 向左滑动，下一个滤镜
            this.viewModel.nextFilter()
          }
          this.onVibrate()
        })
    )
  }
}

/**
 * 滤镜转盘选择器 - 仿真物理转盘效果
 */
@Component
export struct FilterWheel {
  @ObjectLink viewModel: CameraViewModel
  // 震动反馈回调
  onVibrate: () => void = () => {}
  // 滤镜列表
  private readonly filters: FilterType[] = FilterService.getAllFilterTypes()

  build() {
    Column() {
      // 模拟转盘效果的列表
      List({ space: 0 }) {
        ForEach(this.filters, (filter: FilterType) => {
          ListItem() {
            Row() {
              // 选中指示器 - 暖黄色
              if (this.viewModel.currentFilter === filter) {
                Row()
                  .width(3)
                  .height(16)
                  .backgroundColor(AppColors.WARM_YELLOW)
                  .borderRadius(1.5)
                  .margin({ right: 8 })
              }

              // 滤镜名称
              Text(getFilterName(filter))
                .fontSize(this.viewModel.currentFilter === filter ? 14 : 12)
                .fontWeight(this.viewModel.currentFilter === filter
                  ? FontWeight.Bold
                  : FontWeight.Normal)
                .fontColor(this.viewModel.currentFilter === filter
                  ? AppColors.DARK_TEXT
                  : AppColors.MEDIUM_TEXT)
            }
            .width('100%')
            .height(36)
            .padding({ left: 16, right: 16 })
            .justifyContent(FlexAlign.Start)
            .alignItems(VerticalAlign.Center)
          }
          .onClick(() => {
            this.viewModel.setFilter(filter)
            this.onVibrate()
          })
        })
      }
      .width('100%')
      .height(180)
      .scrollBar(BarState.Off)
      .friction(0.7)
    }
    .width(140)
    .backgroundColor(AppColors.CREAM_BG)
    .border({ width: 1, color: AppColors.LIGHT_BORDER })
    .borderRadius(16)
    .padding({ top: 8, bottom: 8 })
  }
}
