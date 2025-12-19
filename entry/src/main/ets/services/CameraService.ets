/**
 * CameraService - 相机硬件调用服务
 * 封装鸿蒙相机 API，提供拍照、预览、录像、对焦等功能
 */

import { camera } from '@kit.CameraKit'
import { image } from '@kit.ImageKit'
import { media } from '@kit.MediaKit'
import { photoAccessHelper } from '@kit.MediaLibraryKit'
import { fileIo } from '@kit.CoreFileKit'
import { BusinessError } from '@kit.BasicServicesKit'
import { FlashMode, AspectRatio } from '../common/constants/Constants'

// 定义接口以支持 focusStateChange 事件监听
interface FocusCapableSession {
  on(type: 'focusStateChange', callback: (state: camera.FocusState) => void): void
}

export class CameraService {
  private cameraManager: camera.CameraManager | undefined
  private cameraInput: camera.CameraInput | undefined
  private previewOutput: camera.PreviewOutput | undefined
  private photoOutput: camera.PhotoOutput | undefined
  private cameraSession: camera.PhotoSession | undefined
  private currentCameraDevice: camera.CameraDevice | undefined
  private surfaceId: string = ''

  // 相机是否已初始化
  private isInitialized: boolean = false
  // 是否使用前置摄像头
  private isFrontCamera: boolean = false

  // ==================== 录像相关属性 ====================
  private videoOutput: camera.VideoOutput | undefined
  private videoSession: camera.VideoSession | undefined
  private avRecorder: media.AVRecorder | undefined
  private videoSurfaceId: string = ''
  private isRecordingActive: boolean = false
  private videoFilePath: string = ''
  private appContext: Context | undefined

  /**
   * 初始化相机管理器
   * @param context 应用上下文
   */
  async initialize(context: Context): Promise<boolean> {
    try {
      this.appContext = context
      this.cameraManager = camera.getCameraManager(context)
      if (!this.cameraManager) {
        console.error('CameraService: Failed to get camera manager')
        return false
      }

      console.info('CameraService: Camera manager initialized')
      return true
    } catch (error) {
      const err = error as BusinessError
      console.error(`CameraService: Initialize failed, error code: ${err.code}, message: ${err.message}`)
      return false
    }
  }

  /**
   * 获取可用的相机设备列表
   */
  async getCameraDevices(): Promise<camera.CameraDevice[]> {
    if (!this.cameraManager) {
      console.error('CameraService: Camera manager not initialized')
      return []
    }

    try {
      const cameras = this.cameraManager.getSupportedCameras()
      console.info(`CameraService: Found ${cameras.length} cameras`)
      return cameras
    } catch (error) {
      const err = error as BusinessError
      console.error(`CameraService: Get cameras failed, error code: ${err.code}`)
      return []
    }
  }

  /**
   * 创建相机会话并开始预览
   * @param surfaceId XComponent 的 surfaceId
   * @param useFrontCamera 是否使用前置摄像头
   */
  async startPreview(surfaceId: string, useFrontCamera: boolean = false): Promise<boolean> {
    if (!this.cameraManager) {
      console.error('CameraService: Camera manager not initialized')
      return false
    }

    this.surfaceId = surfaceId
    this.isFrontCamera = useFrontCamera

    try {
      // 获取相机设备
      const cameras = await this.getCameraDevices()
      if (cameras.length === 0) {
        console.error('CameraService: No camera device found')
        return false
      }

      // 选择前置或后置摄像头
      this.currentCameraDevice = cameras.find(cam =>
        useFrontCamera
          ? cam.cameraPosition === camera.CameraPosition.CAMERA_POSITION_FRONT
          : cam.cameraPosition === camera.CameraPosition.CAMERA_POSITION_BACK
      ) || cameras[0]

      console.info(`CameraService: Using camera: ${this.currentCameraDevice.cameraId}`)

      // 创建相机输入
      this.cameraInput = this.cameraManager.createCameraInput(this.currentCameraDevice)
      await this.cameraInput.open()

      // 获取支持的输出能力
      const outputCapability = this.cameraManager.getSupportedOutputCapability(this.currentCameraDevice, camera.SceneMode.NORMAL_PHOTO)
      if (!outputCapability) {
        console.error('CameraService: No output capability')
        return false
      }

      // 创建预览输出
      const previewProfiles = outputCapability.previewProfiles
      if (previewProfiles.length > 0) {
        // 选择最佳预览分辨率 (优先选择 4:3)
        const profile = this.selectBestPreviewProfile(previewProfiles)
        this.previewOutput = this.cameraManager.createPreviewOutput(profile, surfaceId)
      }

      // 创建拍照输出
      const photoProfiles = outputCapability.photoProfiles
      if (photoProfiles.length > 0) {
        const profile = this.selectBestPhotoProfile(photoProfiles)
        this.photoOutput = this.cameraManager.createPhotoOutput(profile)
      }

      // 创建相机会话
      this.cameraSession = this.cameraManager.createSession(camera.SceneMode.NORMAL_PHOTO) as camera.PhotoSession

      // 配置会话
      this.cameraSession.beginConfig()
      this.cameraSession.addInput(this.cameraInput)
      if (this.previewOutput) {
        this.cameraSession.addOutput(this.previewOutput)
      }
      if (this.photoOutput) {
        this.cameraSession.addOutput(this.photoOutput)
      }
      await this.cameraSession.commitConfig()

      // 启动会话
      await this.cameraSession.start()

      this.isInitialized = true
      console.info('CameraService: Preview started successfully')
      return true
    } catch (error) {
      const err = error as BusinessError
      console.error(`CameraService: Start preview failed, error code: ${err.code}, message: ${err.message}`)
      return false
    }
  }

  /**
   * 选择最佳预览配置
   */
  private selectBestPreviewProfile(profiles: camera.Profile[]): camera.Profile {
    // 优先选择 1920x1440 或 1280x960 (4:3)
    const preferred = profiles.find(p =>
      (p.size.width === 1920 && p.size.height === 1440) ||
      (p.size.width === 1280 && p.size.height === 960)
    )
    if (preferred) return preferred

    // 其次选择最高分辨率
    return profiles.reduce((best, current) => {
      const bestPixels = best.size.width * best.size.height
      const currentPixels = current.size.width * current.size.height
      return currentPixels > bestPixels ? current : best
    })
  }

  /**
   * 选择最佳拍照配置
   */
  private selectBestPhotoProfile(profiles: camera.Profile[]): camera.Profile {
    // 选择最高分辨率
    return profiles.reduce((best, current) => {
      const bestPixels = best.size.width * best.size.height
      const currentPixels = current.size.width * current.size.height
      return currentPixels > bestPixels ? current : best
    })
  }

  /**
   * 停止预览并释放资源
   */
  async stopPreview(): Promise<void> {
    try {
      if (this.cameraSession) {
        await this.cameraSession.stop()
        this.cameraSession.release()
        this.cameraSession = undefined
      }

      if (this.previewOutput) {
        this.previewOutput.release()
        this.previewOutput = undefined
      }

      if (this.photoOutput) {
        this.photoOutput.release()
        this.photoOutput = undefined
      }

      if (this.cameraInput) {
        await this.cameraInput.close()
        this.cameraInput = undefined
      }

      this.isInitialized = false
      console.info('CameraService: Preview stopped')
    } catch (error) {
      const err = error as BusinessError
      console.error(`CameraService: Stop preview failed, error code: ${err.code}`)
    }
  }

  /**
   * 切换前后摄像头
   */
  async switchCamera(): Promise<boolean> {
    if (!this.surfaceId) {
      console.error('CameraService: No surface ID')
      return false
    }

    await this.stopPreview()
    return await this.startPreview(this.surfaceId, !this.isFrontCamera)
  }

  /**
   * 拍照
   * @param callback 拍照完成回调
   */
  async capturePhoto(): Promise<boolean> {
    if (!this.photoOutput || !this.cameraSession) {
      console.error('CameraService: Photo output not ready')
      return false
    }

    try {
      // 设置拍照参数
      const captureSettings: camera.PhotoCaptureSetting = {
        quality: camera.QualityLevel.QUALITY_LEVEL_HIGH,
        rotation: camera.ImageRotation.ROTATION_0
      }

      // 执行拍照
      await this.photoOutput.capture(captureSettings)
      console.info('CameraService: Photo captured')
      return true
    } catch (error) {
      const err = error as BusinessError
      console.error(`CameraService: Capture failed, error code: ${err.code}, message: ${err.message}`)
      return false
    }
  }

  /**
   * 注册拍照回调
   * @param callback 图片数据回调，接收 PhotoAsset
   */
  onPhotoAvailable(callback: (photoAsset: photoAccessHelper.PhotoAsset) => void): void {
    if (this.photoOutput) {
      // 使用 photoAssetAvailable 事件
      this.photoOutput.on('photoAssetAvailable', (err, photoAsset) => {
        if (err) {
          console.error(`CameraService: Photo error: ${err.message}`)
          return
        }
        // 直接传递 PhotoAsset
        if (photoAsset) {
          callback(photoAsset)
        }
      })
    }
  }

  /**
   * 设置对焦点
   * @param x 对焦点 X 坐标 (0-1)
   * @param y 对焦点 Y 坐标 (0-1)
   */
  async setFocusPoint(x: number, y: number): Promise<boolean> {
    if (!this.cameraSession) {
      console.error('CameraService: Camera session not ready')
      return false
    }

    try {
      const point: camera.Point = { x, y }
      this.cameraSession.setFocusPoint(point)
      console.info(`CameraService: Focus point set to (${x}, ${y})`)
      return true
    } catch (error) {
      const err = error as BusinessError
      console.error(`CameraService: Set focus point failed, error code: ${err.code}`)
      return false
    }
  }

  /**
   * 设置对焦模式
   * @param mode 对焦模式
   */
  async setFocusMode(mode: camera.FocusMode): Promise<boolean> {
    if (!this.cameraSession) {
      return false
    }

    try {
      this.cameraSession.setFocusMode(mode)
      return true
    } catch (error) {
      const err = error as BusinessError
      console.error(`CameraService: Set focus mode failed, error code: ${err.code}`)
      return false
    }
  }

  /**
   * 注册对焦状态变化监听
   * @param callback 对焦状态回调函数
   */
  onFocusStateChange(callback: (state: camera.FocusState) => void): void {
    if (this.cameraSession) {
      // 使用自定义接口规避类型定义缺失问题，避免使用 any
      let session = this.cameraSession as Object as FocusCapableSession
      session.on('focusStateChange', (focusState: camera.FocusState) => {
        console.info(`CameraService: Focus state changed to ${focusState}`)
        callback(focusState)
      })
    }
  }

  /**
   * 设置闪光灯模式
   * @param mode 闪光灯模式
   */
  async setFlashMode(mode: FlashMode): Promise<boolean> {
    if (!this.cameraSession) {
      return false
    }

    try {
      let cameraFlashMode: camera.FlashMode
      switch (mode) {
        case FlashMode.OFF:
          cameraFlashMode = camera.FlashMode.FLASH_MODE_CLOSE
          break
        case FlashMode.AUTO:
          cameraFlashMode = camera.FlashMode.FLASH_MODE_AUTO
          break
        case FlashMode.ON:
          cameraFlashMode = camera.FlashMode.FLASH_MODE_ALWAYS_OPEN
          break
        case FlashMode.TORCH:
          cameraFlashMode = camera.FlashMode.FLASH_MODE_ALWAYS_OPEN
          break
        default:
          cameraFlashMode = camera.FlashMode.FLASH_MODE_CLOSE
      }

      this.cameraSession.setFlashMode(cameraFlashMode)
      console.info(`CameraService: Flash mode set to ${mode}`)
      return true
    } catch (error) {
      const err = error as BusinessError
      console.error(`CameraService: Set flash mode failed, error code: ${err.code}`)
      return false
    }
  }

  /**
   * 设置变焦倍数
   * @param ratio 变焦倍数 (1.0 - 4.0)
   */
  async setZoomRatio(ratio: number): Promise<boolean> {
    if (!this.cameraSession) {
      return false
    }

    try {
      this.cameraSession.setZoomRatio(ratio)
      console.info(`CameraService: Zoom ratio set to ${ratio}`)
      return true
    } catch (error) {
      const err = error as BusinessError
      console.error(`CameraService: Set zoom ratio failed, error code: ${err.code}`)
      return false
    }
  }

  /**
   * 设置曝光补偿
   * @param ev 曝光补偿值
   */
  async setExposureBias(ev: number): Promise<boolean> {
    if (!this.cameraSession) {
      return false
    }

    try {
      this.cameraSession.setExposureBias(ev)
      console.info(`CameraService: Exposure bias set to ${ev}`)
      return true
    } catch (error) {
      const err = error as BusinessError
      console.error(`CameraService: Set exposure bias failed, error code: ${err.code}`)
      return false
    }
  }

  /**
   * 检查相机是否已初始化
   */
  isReady(): boolean {
    return this.isInitialized
  }

  /**
   * 获取当前是否为前置摄像头
   */
  isFront(): boolean {
    return this.isFrontCamera
  }

  // ==================== 录像功能 ====================

  /**
   * 初始化录像器
   * @param enableAudio 是否启用音频录制
   * @returns 是否初始化成功
   */
  async initVideoRecorder(enableAudio: boolean = true): Promise<boolean> {
    if (!this.cameraManager || !this.appContext) {
      console.error('CameraService: Camera manager or context not ready')
      return false
    }

    try {
      // 创建 AVRecorder
      this.avRecorder = await media.createAVRecorder()
      console.info('CameraService: AVRecorder created')

      // 生成视频文件路径
      const timestamp = new Date().getTime()
      this.videoFilePath = `${this.appContext.filesDir}/VID_${timestamp}.mp4`

      // 配置 AVRecorder
      const avConfig: media.AVRecorderConfig = {
        videoSourceType: media.VideoSourceType.VIDEO_SOURCE_TYPE_SURFACE_YUV,
        profile: {
          fileFormat: media.ContainerFormatType.CFT_MPEG_4,
          videoBitrate: 8000000,
          videoCodec: media.CodecMimeType.VIDEO_AVC,
          videoFrameWidth: 1920,
          videoFrameHeight: 1080,
          videoFrameRate: 30
        },
        url: `fd://${await this.createVideoFd()}`
      }

      // 根据参数决定是否添加音频配置
      if (enableAudio) {
        avConfig.audioSourceType = media.AudioSourceType.AUDIO_SOURCE_TYPE_MIC
        avConfig.profile.audioBitrate = 128000
        avConfig.profile.audioChannels = 2
        avConfig.profile.audioCodec = media.CodecMimeType.AUDIO_AAC
        avConfig.profile.audioSampleRate = 48000
        console.info('CameraService: Audio recording enabled')
      } else {
        console.info('CameraService: Audio recording disabled')
      }

      await this.avRecorder.prepare(avConfig)

      // 获取视频输入 surfaceId
      this.videoSurfaceId = await this.avRecorder.getInputSurface()
      console.info(`CameraService: Video surface ID: ${this.videoSurfaceId}`)

      return true
    } catch (error) {
      const err = error as BusinessError
      console.error(`CameraService: Init video recorder failed, error: ${err.message}`)
      return false
    }
  }

  /**
   * 创建视频文件描述符
   */
  private async createVideoFd(): Promise<number> {
    const timestamp = new Date().getTime()
    this.videoFilePath = `${this.appContext!.filesDir}/VID_${timestamp}.mp4`

    const file = fileIo.openSync(this.videoFilePath, fileIo.OpenMode.CREATE | fileIo.OpenMode.READ_WRITE)
    return file.fd
  }

  /**
   * 开始录像
   * @param enableAudio 是否启用音频录制
   * @returns 是否开始成功
   */
  async startRecording(enableAudio: boolean = true): Promise<boolean> {
    if (!this.cameraManager || !this.currentCameraDevice) {
      console.error('CameraService: Camera not ready for recording')
      return false
    }

    try {
      // 先停止拍照会话
      await this.stopPreview()

      // 初始化录像器（传递音频参数）
      const initSuccess = await this.initVideoRecorder(enableAudio)
      if (!initSuccess) {
        // 恢复拍照预览
        await this.startPreview(this.surfaceId, this.isFrontCamera)
        return false
      }

      // 重新创建相机输入
      this.cameraInput = this.cameraManager.createCameraInput(this.currentCameraDevice)
      await this.cameraInput.open()

      // 获取视频输出能力
      const outputCapability = this.cameraManager.getSupportedOutputCapability(
        this.currentCameraDevice,
        camera.SceneMode.NORMAL_VIDEO
      )
      if (!outputCapability) {
        console.error('CameraService: No video output capability')
        return false
      }

      // 创建预览输出
      const previewProfiles = outputCapability.previewProfiles
      if (previewProfiles.length > 0) {
        const profile = this.selectBestPreviewProfile(previewProfiles)
        this.previewOutput = this.cameraManager.createPreviewOutput(profile, this.surfaceId)
      }

      // 创建视频输出
      const videoProfiles = outputCapability.videoProfiles
      if (videoProfiles.length > 0) {
        // 选择 1080p 配置
        const videoProfile = videoProfiles.find(p =>
          p.size.width === 1920 && p.size.height === 1080
        ) || videoProfiles[0]

        this.videoOutput = this.cameraManager.createVideoOutput(videoProfile, this.videoSurfaceId)
      }

      // 创建视频会话
      this.videoSession = this.cameraManager.createSession(camera.SceneMode.NORMAL_VIDEO) as camera.VideoSession

      // 配置会话
      this.videoSession.beginConfig()
      this.videoSession.addInput(this.cameraInput)
      if (this.previewOutput) {
        this.videoSession.addOutput(this.previewOutput)
      }
      if (this.videoOutput) {
        this.videoSession.addOutput(this.videoOutput)
      }
      await this.videoSession.commitConfig()

      // 启动会话
      await this.videoSession.start()

      // 开始视频输出
      if (this.videoOutput) {
        await this.videoOutput.start()
      }

      // 开始录像
      if (this.avRecorder) {
        await this.avRecorder.start()
      }

      this.isRecordingActive = true
      console.info('CameraService: Recording started')
      return true
    } catch (error) {
      const err = error as BusinessError
      console.error(`CameraService: Start recording failed, error: ${err.message}`)
      // 恢复拍照预览
      await this.startPreview(this.surfaceId, this.isFrontCamera)
      return false
    }
  }

  /**
   * 停止录像
   * @returns 保存的视频文件路径，失败返回 undefined
   */
  async stopRecording(): Promise<string | undefined> {
    if (!this.isRecordingActive) {
      console.error('CameraService: Not recording')
      return undefined
    }

    try {
      // 停止录像
      if (this.avRecorder) {
        await this.avRecorder.stop()
      }

      // 停止视频输出
      if (this.videoOutput) {
        await this.videoOutput.stop()
      }

      // 停止视频会话
      if (this.videoSession) {
        await this.videoSession.stop()
        this.videoSession.release()
        this.videoSession = undefined
      }

      // 释放视频输出
      if (this.videoOutput) {
        this.videoOutput.release()
        this.videoOutput = undefined
      }

      // 释放预览输出
      if (this.previewOutput) {
        this.previewOutput.release()
        this.previewOutput = undefined
      }

      // 释放相机输入
      if (this.cameraInput) {
        await this.cameraInput.close()
        this.cameraInput = undefined
      }

      // 释放录像器
      await this.releaseVideoRecorder()

      this.isRecordingActive = false
      console.info(`CameraService: Recording stopped, saved to: ${this.videoFilePath}`)

      // 保存视频到相册
      await this.saveVideoToGallery()

      // 恢复拍照预览
      await this.startPreview(this.surfaceId, this.isFrontCamera)

      return this.videoFilePath
    } catch (error) {
      const err = error as BusinessError
      console.error(`CameraService: Stop recording failed, error: ${err.message}`)
      // 尝试恢复
      await this.startPreview(this.surfaceId, this.isFrontCamera)
      return undefined
    }
  }

  /**
   * 释放录像器资源
   */
  private async releaseVideoRecorder(): Promise<void> {
    if (this.avRecorder) {
      try {
        await this.avRecorder.release()
        this.avRecorder = undefined
        console.info('CameraService: AVRecorder released')
      } catch (error) {
        const err = error as BusinessError
        console.error(`CameraService: Release AVRecorder failed, error: ${err.message}`)
      }
    }
  }

  /**
   * 保存视频到相册
   */
  private async saveVideoToGallery(): Promise<boolean> {
    if (!this.appContext || !this.videoFilePath) {
      return false
    }

    try {
      const helper = photoAccessHelper.getPhotoAccessHelper(this.appContext)
      const uri = await helper.createAsset(photoAccessHelper.PhotoType.VIDEO, 'mp4')

      // 读取视频文件
      const srcFile = fileIo.openSync(this.videoFilePath, fileIo.OpenMode.READ_ONLY)
      const destFile = fileIo.openSync(uri, fileIo.OpenMode.WRITE_ONLY)

      // 复制文件内容
      const stat = fileIo.statSync(this.videoFilePath)
      const buffer = new ArrayBuffer(stat.size)
      fileIo.readSync(srcFile.fd, buffer)
      fileIo.writeSync(destFile.fd, buffer)

      fileIo.closeSync(srcFile)
      fileIo.closeSync(destFile)

      // 删除临时文件
      fileIo.unlinkSync(this.videoFilePath)

      console.info('CameraService: Video saved to gallery')
      return true
    } catch (error) {
      const err = error as BusinessError
      console.error(`CameraService: Save video to gallery failed, error: ${err.message}`)
      return false
    }
  }

  /**
   * 检查是否正在录像
   */
  isRecording(): boolean {
    return this.isRecordingActive
  }
}

// 导出单例
export const cameraService = new CameraService()
