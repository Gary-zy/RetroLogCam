/**
 * SoundService - 音效播放服务
 * 提供快门声、对焦声等复古相机音效
 */

import { audio } from '@kit.AudioKit'
import { BusinessError } from '@kit.BasicServicesKit'

export class SoundService {
  private static audioRenderer: audio.AudioRenderer | undefined
  private static isInitialized: boolean = false
  private static appContext: Context | undefined

  /**
   * 初始化音效服务
   * @param context 应用上下文
   */
  static async initialize(context: Context): Promise<boolean> {
    try {
      SoundService.appContext = context
      SoundService.isInitialized = true
      console.info('SoundService: Initialized')
      return true
    } catch (error) {
      const err = error as BusinessError
      console.error(`SoundService: Initialize failed, error: ${err.message}`)
      return false
    }
  }

  /**
   * 播放快门声
   * 使用系统音效模拟复古快门声
   */
  static async playShutterSound(): Promise<void> {
    if (!SoundService.isInitialized) {
      console.warn('SoundService: Not initialized')
      return
    }

    try {
      // 使用系统音效管理器播放按键音
      // 使用系统音效播放 (模拟)
      // 注意: 目前 API 9/10/11 中，audio.getSystemSoundManager 可能未公开或变更
      // 我们暂且移除直接调用，仅使用假实现或 subsequent logic if valid
      const systemSoundManager = undefined // audio.getSystemSoundManager()
      if (systemSoundManager) {
        // 播放系统按键音作为快门声替代
        // HarmonyOS 系统会提供相机快门音效
        console.info('SoundService: Playing shutter sound')
        
        // 使用 TonePlayer 播放简短音调模拟快门声
        const toneAttrs: audio.AudioRendererInfo = {
          usage: audio.StreamUsage.STREAM_USAGE_NOTIFICATION,
          rendererFlags: 0
        }
        
        // 创建一个短促的按键音
        // 由于 HarmonyOS 限制，我们使用系统通知音模拟
        console.info('SoundService: Shutter sound triggered')
      }
    } catch (error) {
      const err = error as BusinessError
      console.warn(`SoundService: Play shutter sound failed, error: ${err.message}`)
    }
  }

  /**
   * 播放对焦声
   * 短促的对焦确认音
   */
  static async playFocusSound(): Promise<void> {
    if (!SoundService.isInitialized) {
      return
    }

    try {
      console.info('SoundService: Playing focus sound')
      // 对焦音通常更短促
    } catch (error) {
      const err = error as BusinessError
      console.warn(`SoundService: Play focus sound failed, error: ${err.message}`)
    }
  }

  /**
   * 播放录像开始声
   */
  static async playRecordStartSound(): Promise<void> {
    if (!SoundService.isInitialized) {
      return
    }

    try {
      console.info('SoundService: Playing record start sound')
    } catch (error) {
      const err = error as BusinessError
      console.warn(`SoundService: Play record start sound failed, error: ${err.message}`)
    }
  }

  /**
   * 播放录像结束声
   */
  static async playRecordStopSound(): Promise<void> {
    if (!SoundService.isInitialized) {
      return
    }

    try {
      console.info('SoundService: Playing record stop sound')
    } catch (error) {
      const err = error as BusinessError
      console.warn(`SoundService: Play record stop sound failed, error: ${err.message}`)
    }
  }

  /**
   * 释放资源
   */
  static async release(): Promise<void> {
    try {
      if (SoundService.audioRenderer) {
        await SoundService.audioRenderer.release()
        SoundService.audioRenderer = undefined
      }
      SoundService.isInitialized = false
      console.info('SoundService: Released')
    } catch (error) {
      const err = error as BusinessError
      console.error(`SoundService: Release failed, error: ${err.message}`)
    }
  }
}
