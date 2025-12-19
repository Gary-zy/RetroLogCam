import { CameraViewModel } from '../viewmodel/CameraViewModel'
import { AppColors, TimerMode, AppSizes } from '../common/constants/Constants'
import { cameraService } from '../services/CameraService'
import { ImageProcessor } from '../services/ImageProcessor'
import { SoundService } from '../services/SoundService'
import { vibrator } from '@kit.SensorServiceKit'
import { camera } from '@kit.CameraKit'
import { abilityAccessCtrl, common, Permissions } from '@kit.AbilityKit'
import { image } from '@kit.ImageKit'
import { BusinessError } from '@kit.BasicServicesKit'
import { photoAccessHelper } from '@kit.MediaLibraryKit'

// 组件导入
import { TopBar } from '../components/TopBar'
import { ControlBar } from '../components/ControlBar'
import { OSDLayer } from '../components/OSDLayer'
import { CameraPreview, FilterOverlay } from '../components/CameraPreview'
import { RetroViewfinderMask } from '../components/AspectMask'
import { SettingsOverlay } from '../components/SettingsMenu'

@Entry
@Component
struct Index {
  // ==================== 状态管理 ====================
  @State viewModel: CameraViewModel = new CameraViewModel()
  // 相机 Surface ID
  @State surfaceId: string = ''
  // 是否已获取权限
  @State hasPermission: boolean = false
  // Toast 消息
  @State toastMessage: string = ''
  @State showToast: boolean = false
  // 最近照片 URI
  @State lastPhotoUri: string = ''
  // 倒计时定时器 ID
  private countdownTimerId: number = -1
  // ISO 模拟更新定时器 ID
  private isoUpdateTimerId: number = -1
  // 录像时长计时器 ID
  private recordingTimerId: number = -1
  // 应用上下文
  private context: common.UIAbilityContext | null = null

  // ==================== 生命周期 ====================
  aboutToAppear(): void {
    this.context = getContext(this) as common.UIAbilityContext
    // 请求相机权限
    this.requestCameraPermission()
    // 启动 ISO 模拟更新
    this.startISOSimulation()
  }

  aboutToDisappear(): void {
    // 停止相机预览
    cameraService.stopPreview()
    // 清理定时器
    if (this.countdownTimerId !== -1) {
      clearInterval(this.countdownTimerId)
    }
    if (this.isoUpdateTimerId !== -1) {
      clearInterval(this.isoUpdateTimerId)
    }
    if (this.recordingTimerId !== -1) {
      clearInterval(this.recordingTimerId)
    }
  }

  // ==================== 权限处理 ====================
  async requestCameraPermission(): Promise<void> {
    const permissions: Permissions[] = [
      'ohos.permission.CAMERA',
      'ohos.permission.MICROPHONE',
      'ohos.permission.WRITE_IMAGEVIDEO',
      'ohos.permission.READ_IMAGEVIDEO'
    ]

    try {
      const atManager = abilityAccessCtrl.createAtManager()
      const result = await atManager.requestPermissionsFromUser(this.context!, permissions)

      // 检查所有权限是否都已授予
      const allGranted = result.authResults.every(r => r === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED)

      if (allGranted) {
        this.hasPermission = true
        console.info('Index: All permissions granted')
        // 初始化相机
        await this.initializeCamera()
      } else {
        this.showToastMessage('需要相机和存储权限才能使用')
        console.error('Index: Some permissions denied')
      }
    } catch (error) {
      const err = error as BusinessError
      console.error(`Index: Request permissions failed, error: ${err.message}`)
    }
  }

  // ==================== 相机初始化 ====================
  async initializeCamera(): Promise<void> {
    if (!this.context) return

    const success = await cameraService.initialize(this.context)
    if (success) {
      console.info('Index: Camera initialized')
      // 初始化音效服务
      await SoundService.initialize(this.context)
      // 注册拍照回调
      this.setupPhotoCallback()
      // 注册对焦状态监听
      this.setupFocusStateListener()
    } else {
      this.showToastMessage('相机初始化失败')
    }
  }

  // ==================== 拍照回调设置 ====================
  setupPhotoCallback(): void {
    cameraService.onPhotoAvailable(async (photoAsset: photoAccessHelper.PhotoAsset) => {
      console.info('Index: Photo captured')

      try {
        // 获取图片数据 - 从 photoAsset 创建 PixelMap
        if (photoAsset && this.context) {
          // 使用 getThumbnail 获取原始尺寸的 PixelMap
          // 传入一个足够大的尺寸来获取高质量图片
          const thumbnailSize: image.Size = { width: 4096, height: 4096 }
          const pixelMap: image.PixelMap = await photoAsset.getThumbnail(thumbnailSize)

          if (pixelMap) {
            // 处理并保存图片
            const photoUri = await ImageProcessor.processAndSave(
              this.context,
              pixelMap,
              this.viewModel.currentFilter,
              this.viewModel.dateStampEnabled
            )

            if (photoUri) {
              // 更新缩略图 URI
              this.lastPhotoUri = photoUri
              this.showToastMessage('照片已保存')
              this.triggerVibration()
              console.info(`Index: Photo saved, URI updated: ${photoUri}`)
            } else {
              this.showToastMessage('保存失败')
            }
          }
        }

        this.viewModel.isCapturing = false
      } catch (error) {
        const err = error as BusinessError
        console.error(`Index: Process photo failed, error: ${err.message}`)
        this.viewModel.isCapturing = false
        this.showToastMessage('处理照片失败')
      }
    })
  }

  // ==================== 对焦状态监听设置 ====================
  setupFocusStateListener(): void {
    cameraService.onFocusStateChange((focusState: camera.FocusState) => {
      console.info(`Index: Focus state changed: ${focusState}`)
      
      // 根据对焦状态更新 ViewModel
      switch (focusState) {
        case camera.FocusState.FOCUS_STATE_SCAN:
          // 对焦中
          this.viewModel.focusState = 'focusing'
          break
        case camera.FocusState.FOCUS_STATE_FOCUSED:
          // 对焦成功
          this.viewModel.setFocusResult(true)
          // 播放对焦成功音效
          if (this.viewModel.soundEnabled) {
            SoundService.playFocusSound()
          }
          break
        case camera.FocusState.FOCUS_STATE_UNFOCUSED:
          // 对焦失败
          this.viewModel.setFocusResult(false)
          break
        default:
          break
      }
    })
  }

  // ==================== 相机预览启动 ====================
  async startCameraPreview(surfaceId: string): Promise<void> {
    try {
      this.surfaceId = surfaceId

      if (!this.hasPermission) {
        console.warn('Index: No permission to start preview')
        return
      }

      const success = await cameraService.startPreview(surfaceId, this.viewModel.isFrontCamera)
      if (success) {
        console.info('Index: Preview started')
        // 设置默认对焦模式
        await cameraService.setFocusMode(camera.FocusMode.FOCUS_MODE_CONTINUOUS_AUTO)
      } else {
        this.showToastMessage('启动预览失败')
      }
    } catch (error) {
      const err = error as BusinessError
      console.error(`Index: Start preview failed, error: ${err.message}`)
      this.showToastMessage('启动预览失败')
    }
  }

  // ==================== 拍照功能 ====================
  async takePhoto(): Promise<void> {
    if (this.viewModel.isCapturing) return

    // 检查是否需要倒计时
    if (this.viewModel.timerMode !== TimerMode.OFF) {
      this.startCountdown()
      return
    }

    // 直接拍照
    await this.capturePhoto()
  }

  // 开始倒计时
  startCountdown(): void {
    this.viewModel.startCountdown()
    this.triggerVibration()

    this.countdownTimerId = setInterval(() => {
      this.viewModel.decrementCountdown()
      this.triggerVibration()

      if (this.viewModel.countdownSeconds <= 0) {
        clearInterval(this.countdownTimerId)
        this.countdownTimerId = -1
        // 执行拍照
        this.capturePhoto()
      }
    }, 1000)
  }

  // 执行拍照
  async capturePhoto(): Promise<void> {
    this.viewModel.isCapturing = true

    // 触发震动反馈（模拟快门）
    this.triggerVibration()

    // 播放快门声
    if (this.viewModel.soundEnabled) {
      await SoundService.playShutterSound()
    }

    // 设置闪光灯
    await cameraService.setFlashMode(this.viewModel.flashMode)

    // 拍照
    const success = await cameraService.capturePhoto()
    if (!success) {
      this.viewModel.isCapturing = false
      this.showToastMessage('拍照失败')
    }
  }

  // ==================== 对焦功能 ====================
  async handleFocus(x: number, y: number): Promise<void> {
    this.triggerVibration()
    this.viewModel.setFocusPosition(x, y)
    await cameraService.setFocusPoint(x, y)
  }

  // ==================== 变焦功能 ====================
  async handleZoom(ratio: number): Promise<void> {
    await cameraService.setZoomRatio(ratio)
  }

  // ==================== 曝光补偿功能 ====================
  async handleExposure(ev: number): Promise<void> {
    await cameraService.setExposureBias(ev)
  }

  // ==================== 切换摄像头 ====================
  async switchCamera(): Promise<void> {
    this.viewModel.toggleCamera()
    this.triggerVibration()

    if (this.surfaceId) {
      await cameraService.switchCamera()
    }
  }

  // ==================== 震动反馈 ====================
  triggerVibration(): void {
    if (!this.viewModel.vibrationEnabled) return

    try {
      let effect: vibrator.VibrateTime = {
        type: 'time',
        duration: 30
      }
      let attribute: vibrator.VibrateAttribute = {
        id: 0,
        usage: 'touch'
      }
      vibrator.startVibration(effect, attribute)
    } catch (error) {
      const err = error as BusinessError
      console.warn(`Index: Vibration not available, error: ${err.message}`)
    }
  }

  // ==================== Toast 消息 ====================
  showToastMessage(message: string): void {
    this.toastMessage = message
    this.showToast = true

    setTimeout(() => {
      this.showToast = false
    }, 2000)
  }

  // ==================== ISO 模拟 ====================
  startISOSimulation(): void {
    this.isoUpdateTimerId = setInterval(() => {
      this.viewModel.updateSimulatedISO()
    }, 3000)
  }

  // ==================== 录像功能 ====================
  async handleRecordingToggle(): Promise<void> {
    if (this.viewModel.isRecording) {
      await this.handleStopRecording()
    } else {
      await this.handleStartRecording()
    }
  }

  async handleStartRecording(): Promise<void> {
    this.triggerVibration()
    this.showToastMessage('正在启动录像...')

    // 播放录像开始音效
    if (this.viewModel.soundEnabled) {
      await SoundService.playRecordStartSound()
    }

    // 启动录像（根据用户设置控制是否录音）
    const success = await cameraService.startRecording(this.viewModel.soundEnabled)
    if (success) {
      this.viewModel.startRecording()
      // 启动录像计时器
      this.recordingTimerId = setInterval(() => {
        this.viewModel.incrementRecordingDuration()
      }, 1000)
      this.showToastMessage('录像中')
    } else {
      this.showToastMessage('启动录像失败')
    }
  }

  async handleStopRecording(): Promise<void> {
    this.triggerVibration()
    
    // 播放录像结束音效
    if (this.viewModel.soundEnabled) {
      await SoundService.playRecordStopSound()
    }
    
    // 停止录像计时器
    if (this.recordingTimerId !== -1) {
      clearInterval(this.recordingTimerId)
      this.recordingTimerId = -1
    }

    const videoPath = await cameraService.stopRecording()
    this.viewModel.stopRecording()
    
    if (videoPath) {
      this.showToastMessage('视频已保存')
    } else {
      this.showToastMessage('保存视频失败')
    }
  }

  // ==================== 相册跳转功能 ====================
  async handleGalleryPress(): Promise<void> {
    try {
      // TODO: 实现相册跳转功能
      // 当前版本暂时使用 Toast 提示
      // 后续可以使用 PhotoViewPicker 或 Want 跳转到系统相册
      this.showToastMessage('点击查看最新照片')
      console.info('Index: Gallery button pressed')
    } catch (error) {
      const err = error as BusinessError
      console.error(`Index: Gallery action failed, error: ${err.message}`)
    }
  }

  // ==================== 主界面构建 ====================
  build() {
    Stack() {
      // ==================== Layer 0: 相机预览 ====================
      CameraPreview({
        viewModel: this.viewModel,
        onSurfaceCreated: (surfaceId: string) => {
          this.startCameraPreview(surfaceId)
        },
        onTapFocus: (x: number, y: number) => {
          this.handleFocus(x, y)
        },
        onZoom: (ratio: number) => {
          this.handleZoom(ratio)
        },
        onExposure: (ev: number) => {
          this.handleExposure(ev)
        }
      })
      .width('100%')
      .height('100%')

      // ==================== Layer 1: 遮罩层 (取景框) ====================
      // RetroViewfinderMask({
      //   containerWidth: AppSizes.SCREEN_WIDTH,
      //   containerHeight: AppSizes.SCREEN_HEIGHT
      // })

      // ==================== Layer 2: 滤镜效果叠加 ====================
      // if (this.viewModel.currentFilter !== FilterType.STANDARD) {
      //   FilterOverlay({
      //     filterType: this.viewModel.currentFilter
      //   })
      // }

      // ==================== Layer 3: OSD 信息层 (上层/下层) ====================
      // OSDLayer({
      //   viewModel: this.viewModel
      // })

      // ==================== Layer 4: 顶部控制栏 (设置/闪光灯/格线) ====================
      // TopBar({
      //   viewModel: this.viewModel,
      //   onSettingsPress: () => {
      //     this.viewModel.showSettings = true
      //   }
      // })

      // ==================== Layer 5: 底部控制栏 (快门/回放/滤镜) ====================
      // ControlBar({
      //   viewModel: this.viewModel,
      //   lastPhotoUri: this.lastPhotoUri,
      //   onShutterPress: () => {
      //     this.takePhoto()
      //   },
      //   onLongPressShutter: () => {
      //     this.handleRecordingToggle()
      //   },
      //   onGalleryPress: () => {
      //     this.handleGalleryPress()
      //   }
      // })

      // ==================== Layer 6: 设置菜单 ====================
      // SettingsOverlay({
      //   viewModel: this.viewModel,
      //   onVibrate: () => {
      //     this.triggerVibration()
      //   }
      // })

      // Toast 提示
      if (this.showToast) {
        Column() {
          Text(this.toastMessage)
            .fontSize(AppSizes.FONT_NORMAL)
            .fontColor(AppColors.WHITE)
            .backgroundColor('#99000000')
            .padding({
              left: 16,
              right: 16,
              top: 8,
              bottom: 8
            })
            .borderRadius(20)
        }
        .position({ x: '50%', y: '85%' })
        .translate({ x: '-50%' })
        .hitTestBehavior(HitTestMode.None)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(AppColors.PRIMARY_BG)
  }
}

