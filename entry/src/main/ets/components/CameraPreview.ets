/**
 * CameraPreview - 相机预览组件
 * 使用 XComponent 显示相机预览流
 * 支持触控对焦、双指缩放、滑动曝光补偿
 */

import { AppColors, AppSizes } from '../common/constants/Constants'
import { CameraViewModel } from '../viewmodel/CameraViewModel'

@Component
export struct CameraPreview {
  @ObjectLink viewModel: CameraViewModel
  // XComponent 控制器
  private xComponentController: XComponentController = new XComponentController()
  // Surface ID 回调
  onSurfaceCreated: (surfaceId: string) => void = () => {}
  // 对焦回调 (重命名避免与基类冲突)
  onTapFocus: (x: number, y: number) => void = () => {}
  // 变焦回调
  onZoom: (ratio: number) => void = () => {}
  // 曝光补偿回调
  onExposure: (ev: number) => void = () => {}
  // 震动回调
  onVibrate: () => void = () => {}

  // 手势状态
  @State private lastPinchScale: number = 1.0
  @State private lastPanY: number = 0

  build() {
    Stack() {
      // ==================== 相机预览 (XComponent) ====================
      XComponent({
        id: 'cameraPreview',
        type: XComponentType.SURFACE,
        controller: this.xComponentController
      })
        .width('100%')
        .height('100%')
        .onLoad(() => {
          // 获取 Surface ID 并回调
          const surfaceId = this.xComponentController.getXComponentSurfaceId()
          console.info(`CameraPreview: Surface created, id = ${surfaceId}`)
          this.onSurfaceCreated(surfaceId)
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(AppColors.PRIMARY_BG)
    // ==================== 手势处理 ====================
    .onClick((event: ClickEvent) => {
      // 触控对焦
      this.handleTapToFocus(event)
    })
    .gesture(
      GestureGroup(
        GestureMode.Parallel,
        // 双指缩放手势 (变焦)
        PinchGesture({ fingers: 2, distance: 1 })
          .onActionStart(() => {
            this.lastPinchScale = this.viewModel.zoomRatio
          })
          .onActionUpdate((event: GestureEvent) => {
            this.handlePinchZoom(event)
          }),

        // 上下滑动手势 (曝光补偿)
        PanGesture({ direction: PanDirection.Vertical })
          .onActionStart((event: GestureEvent) => {
            this.lastPanY = event.offsetY
          })
          .onActionUpdate((event: GestureEvent) => {
            this.handlePanExposure(event)
          })
      )
    )
  }

  /**
   * 处理触控对焦
   */
  private handleTapToFocus(event: ClickEvent): void {
    const x = event.x
    const y = event.y

    // 显示对焦框
    this.viewModel.setFocusPosition(x, y)

    // 触发震动反馈
    this.onVibrate()

    // 回调对焦位置 (归一化坐标)
    // 注意：实际项目中需要获取组件的实际宽高
    const normalizedX = x / 400 // 需要替换为实际宽度
    const normalizedY = y / 600 // 需要替换为实际高度
    this.onTapFocus(Math.max(0, Math.min(1, normalizedX)), Math.max(0, Math.min(1, normalizedY)))

    // 模拟对焦过程
    setTimeout(() => {
      this.viewModel.setFocusResult(true)
    }, 500)

    // 2秒后隐藏对焦框
    setTimeout(() => {
      this.viewModel.hideFocusFrame()
    }, 2000)
  }

  /**
   * 处理双指缩放 (变焦)
   */
  private handlePinchZoom(event: GestureEvent): void {
    const scale = event.scale || 1.0
    const newZoom = this.lastPinchScale * scale

    // 限制变焦范围 1.0x - 4.0x
    const clampedZoom = Math.max(1.0, Math.min(4.0, newZoom))

    // 更新 ViewModel
    this.viewModel.setZoomRatio(clampedZoom)

    // 回调
    this.onZoom(clampedZoom)
  }

  /**
   * 处理上下滑动 (曝光补偿)
   */
  private handlePanExposure(event: GestureEvent): void {
    const deltaY = event.offsetY - this.lastPanY

    // 每滑动 50 像素，调整 0.1 EV
    const deltaEV = -deltaY / 500

    const newEV = this.viewModel.evValue + deltaEV
    const clampedEV = Math.max(-2.0, Math.min(2.0, newEV))

    // 更新 ViewModel
    this.viewModel.setExposureValue(clampedEV)

    // 回调
    this.onExposure(clampedEV)

    this.lastPanY = event.offsetY
  }

  /**
   * 获取 Surface ID
   */
  getSurfaceId(): string {
    return this.xComponentController.getXComponentSurfaceId()
  }
}

/**
 * 滤镜预览叠加层 - 用于实时滤镜效果展示
 * 注意：真正的滤镜效果需要通过 GPU 渲染实现
 * 这里提供一个简化的颜色叠加层作为视觉反馈
 */
@Component
export struct FilterOverlay {
  @ObjectLink viewModel: CameraViewModel

  build() {
    // 根据当前滤镜类型显示不同的颜色叠加效果
    // 这是一个简化的视觉反馈，真正的滤镜需要在图像处理阶段应用
    Stack()
      .width('100%')
      .height('100%')
      .backgroundColor(this.getOverlayColor())
      .opacity(this.getOverlayOpacity())
      .hitTestBehavior(HitTestMode.Transparent) // 允许点击穿透
      .blendMode(BlendMode.MULTIPLY)
  }

  /**
   * 根据滤镜类型获取叠加颜色
   */
  private getOverlayColor(): string {
    switch (this.viewModel.currentFilter) {
      case 0: // STANDARD
        return 'transparent'
      case 1: // D_LOG
        return '#808080' // 灰色
      case 2: // CLASSIC_S
        return '#E0E8FF' // 冷蓝
      case 3: // VINTAGE_C
        return '#FFF5E0' // 暖黄
      case 4: // MONO_CCD
        return '#808080' // 灰色
      case 5: // CYBER_2000
        return '#E0FFE0' // 冷绿
      case 6: // SOFT_DREAM
        return '#FFF0F5' // 柔粉
      default:
        return 'transparent'
    }
  }

  /**
   * 获取叠加层透明度
   */
  private getOverlayOpacity(): number {
    switch (this.viewModel.currentFilter) {
      case 0: // STANDARD
        return 0
      case 1: // D_LOG
        return 0.15
      case 2: // CLASSIC_S
        return 0.1
      case 3: // VINTAGE_C
        return 0.1
      case 4: // MONO_CCD
        return 0.4
      case 5: // CYBER_2000
        return 0.1
      case 6: // SOFT_DREAM
        return 0.1
      default:
        return 0
    }
  }
}
