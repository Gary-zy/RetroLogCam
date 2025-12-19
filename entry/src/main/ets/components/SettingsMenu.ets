/**
 * SettingsMenu - 设置菜单组件 - 极简复古版
 * 半屏弹出的设置面板，采用奶油白浅色主题
 */

import { AppColors, AppSizes } from '../common/constants/Constants'
import { CameraViewModel } from '../viewmodel/CameraViewModel'
import { SettingToggleItemParams, QuickToggleParams } from '../common/types/ComponentTypes'
import { AppAnimations, AppBorders, AppShadows, AppGlowEffects, LightThemeShadows } from '../common/styles/Styles'

@Component
export struct SettingsMenu {
  @ObjectLink viewModel: CameraViewModel
  // 关闭回调
  onClose: () => void = () => {}
  // 震动回调
  onVibrate: () => void = () => {}

  build() {
    Column() {
      // ==================== 标题栏 - 极简复古风 ====================
      Row() {
        // 黄色装饰圆点
        Circle()
          .width(12)
          .height(12)
          .fill(AppColors.WARM_YELLOW)
          .margin({ right: 10 })

        Text('设置')
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .fontColor(AppColors.DARK_TEXT)

        Blank()

        // 关闭按钮
        Image($r('app.media.ic_close'))
          .width(24)
          .height(24)
          .fillColor(AppColors.MEDIUM_TEXT)
          .onClick(() => {
            this.onClose()
          })
      }
      .width('100%')
      .padding({ left: 24, right: 24, top: 24, bottom: 16 })

      // ==================== 分隔线 ====================
      Divider()
        .color(AppColors.DIVIDER_LIGHT)
        .margin({ left: 24, right: 24 })

      // ==================== 设置选项列表 ====================
      Scroll() {
        Column({ space: 0 }) {
          // 声音开关
          this.SettingToggleItem({
            title: '快门声音',
            subtitle: '模拟机械快门和对焦声',
            isOn: this.viewModel.soundEnabled,
            onChange: (value: boolean) => {
              this.viewModel.soundEnabled = value
              this.onVibrate()
            }
          })

          // 震动反馈
          this.SettingToggleItem({
            title: '震动反馈',
            subtitle: '切换滤镜和对焦时的触感',
            isOn: this.viewModel.vibrationEnabled,
            onChange: (value: boolean) => {
              this.viewModel.vibrationEnabled = value
              if (value) {
                this.onVibrate()
              }
            }
          })

          // 构图线
          this.SettingToggleItem({
            title: '构图九宫格',
            subtitle: '显示三分法构图辅助线',
            isOn: this.viewModel.gridEnabled,
            onChange: (value: boolean) => {
              this.viewModel.gridEnabled = value
              this.onVibrate()
            }
          })

          // 日期水印
          this.SettingToggleItem({
            title: '日期水印',
            subtitle: '在照片右下角烧录橙色日期',
            isOn: this.viewModel.dateStampEnabled,
            onChange: (value: boolean) => {
              this.viewModel.dateStampEnabled = value
              this.onVibrate()
            }
          })

          // 前置镜像
          this.SettingToggleItem({
            title: '前置镜像',
            subtitle: '前置摄像头拍摄时镜像翻转',
            isOn: this.viewModel.frontMirror,
            onChange: (value: boolean) => {
              this.viewModel.frontMirror = value
              this.onVibrate()
            }
          })

          // 分隔线
          Divider()
            .color(AppColors.DIVIDER_LIGHT)
            .margin({ left: 24, right: 24, top: 16, bottom: 16 })

          // 关于部分
          this.AboutSection()
        }
        .width('100%')
        .padding({ bottom: 40 })
      }
      .width('100%')
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('60%')
    .backgroundColor(AppColors.CREAM_BG)
    .border({
      width: { top: 1 },
      color: AppColors.LIGHT_BORDER
    })
    .borderRadius({ topLeft: 28, topRight: 28 })
    .shadow(LightThemeShadows.PANEL)
    .transition(
      TransitionEffect.translate({ y: 300 })
        .animation({ duration: 300, curve: Curve.EaseOut })
    )
  }

  /**
   * 设置开关项 Builder
   */
  @Builder
  SettingToggleItem(params: SettingToggleItemParams) {
    Row() {
      Column({ space: 4 }) {
        Text(params.title)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor(AppColors.DARK_TEXT)

        Text(params.subtitle)
          .fontSize(12)
          .fontColor(AppColors.MEDIUM_TEXT)
      }
      .alignItems(HorizontalAlign.Start)

      Blank()

      // 自定义开关 - 暖黄色主题
      Toggle({ type: ToggleType.Switch, isOn: params.isOn })
        .width(50)
        .height(30)
        .selectedColor(AppColors.WARM_YELLOW)
        .switchPointColor(AppColors.WHITE)
        .onChange((isOn: boolean) => {
          params.onChange(isOn)
        })
    }
    .width('100%')
    .padding({ left: 24, right: 24, top: 16, bottom: 16 })
  }

  /**
   * 关于部分 Builder
   */
  @Builder
  AboutSection() {
    Column({ space: 12 }) {
      // App Logo 和名称 - 添加黄色装饰圆
      Stack() {
        // 背景装饰圆
        Circle()
          .width(80)
          .height(80)
          .fill(AppColors.WARM_YELLOW)
          .opacity(0.2)

        Image($r('app.media.ic_camera_logo'))
          .width(50)
          .height(50)
          .fillColor(AppColors.DARK_TEXT)
      }

      Text('RetroLog Cam')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor(AppColors.DARK_TEXT)
        .margin({ top: 8 })

      Text('Version 1.0.0')
        .fontSize(12)
        .fontColor(AppColors.MEDIUM_TEXT)

      // 描述
      Text('复古 CCD 数码相机 · D-Log 电影模式')
        .fontSize(12)
        .fontColor(AppColors.MEDIUM_TEXT)
        .textAlign(TextAlign.Center)
        .margin({ top: 8 })

      // 版权信息
      Text('© 2024 RetroLog Cam')
        .fontSize(10)
        .fontColor(AppColors.LIGHT_TEXT)
        .margin({ top: 16 })
    }
    .width('100%')
    .alignItems(HorizontalAlign.Center)
    .padding({ top: 24, bottom: 24 })
  }
}

/**
 * 设置菜单容器 - 包含背景遮罩
 */
@Component
export struct SettingsOverlay {
  @ObjectLink viewModel: CameraViewModel
  // 震动回调
  onVibrate: () => void = () => {}

  build() {
    if (this.viewModel.showSettings) {
      Stack() {
        // 背景遮罩
        Column()
          .width('100%')
          .height('100%')
          .backgroundColor('#80000000')
          .onClick(() => {
            this.viewModel.toggleSettings()
          })
          .transition(
            TransitionEffect.opacity(1)
              .animation({ duration: 200 })
          )

        // 设置菜单 (底部弹出)
        Column() {
          Blank()

          SettingsMenu({
            viewModel: this.viewModel,
            onClose: () => {
              this.viewModel.toggleSettings()
            },
            onVibrate: this.onVibrate
          })
        }
        .width('100%')
        .height('100%')
      }
      .width('100%')
      .height('100%')
    }
  }
}

/**
 * 快捷设置按钮组 - 用于顶部工具栏快速访问
 */
@Component
export struct QuickSettings {
  @ObjectLink viewModel: CameraViewModel
  onVibrate: () => void = () => {}

  build() {
    Row({ space: 16 }) {
      // 九宫格开关
      this.QuickToggle({
        icon: $r('app.media.ic_grid'),
        isActive: this.viewModel.gridEnabled,
        onToggle: () => {
          this.viewModel.gridEnabled = !this.viewModel.gridEnabled
          this.onVibrate()
        }
      })

      // 日期水印开关
      this.QuickToggle({
        icon: $r('app.media.ic_calendar'),
        isActive: this.viewModel.dateStampEnabled,
        onToggle: () => {
          this.viewModel.dateStampEnabled = !this.viewModel.dateStampEnabled
          this.onVibrate()
        }
      })

      // 声音开关
      this.QuickToggle({
        icon: this.viewModel.soundEnabled ? $r('app.media.ic_volume_on') : $r('app.media.ic_volume_off'),
        isActive: this.viewModel.soundEnabled,
        onToggle: () => {
          this.viewModel.soundEnabled = !this.viewModel.soundEnabled
          this.onVibrate()
        }
      })
    }
    .padding({ left: 16, right: 16 })
  }

  @Builder
  QuickToggle(params: QuickToggleParams) {
    Image(params.icon)
      .width(24)
      .height(24)
      .fillColor(params.isActive ? AppColors.WHITE : AppColors.TEXT_INACTIVE)
      .padding(4) // Adjust padding since image is larger than text
      .backgroundColor(params.isActive ? '#30FFFFFF' : 'transparent')
      .borderRadius(8)
      .onClick(params.onToggle)
  }
}
