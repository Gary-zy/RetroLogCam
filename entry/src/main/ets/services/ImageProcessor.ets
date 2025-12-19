/**
 * ImageProcessor - 图片处理服务
 * 负责滤镜应用、日期水印绘制、图片保存等功能
 */

import { image } from '@kit.ImageKit'
import { photoAccessHelper } from '@kit.MediaLibraryKit'
import { fileIo } from '@kit.CoreFileKit'
import { BusinessError } from '@kit.BasicServicesKit'
import { FilterType, AppColors } from '../common/constants/Constants'
import { FilterService, ColorMatrix } from './FilterService'

export class ImageProcessor {
  /**
   * 获取格式化的日期字符串 (复古格式)
   * 格式: 'YY MM DD
   */
  static getFormattedDate(): string {
    const now = new Date()
    const year = String(now.getFullYear()).slice(-2)
    const month = String(now.getMonth() + 1).padStart(2, '0')
    const day = String(now.getDate()).padStart(2, '0')
    return `'${year} ${month} ${day}`
  }

  /**
   * 获取格式化的时间字符串
   * 格式: HH:mm
   */
  static getFormattedTime(): string {
    const now = new Date()
    const hours = String(now.getHours()).padStart(2, '0')
    const minutes = String(now.getMinutes()).padStart(2, '0')
    return `${hours}:${minutes}`
  }

  /**
   * 应用颜色矩阵到像素数据
   * @param pixelMap 像素图
   * @param matrix 颜色矩阵
   */
  static async applyColorMatrix(pixelMap: image.PixelMap, matrix: ColorMatrix): Promise<void> {
    try {
      const imageInfo = await pixelMap.getImageInfo()
      const width = imageInfo.size.width
      const height = imageInfo.size.height

      // 读取像素数据
      const bufferSize = width * height * 4 // RGBA
      const buffer = new ArrayBuffer(bufferSize)
      await pixelMap.readPixelsToBuffer(buffer)

      const data = new Uint8Array(buffer)

      // 应用颜色矩阵变换
      for (let i = 0; i < data.length; i += 4) {
        const r = data[i] / 255
        const g = data[i + 1] / 255
        const b = data[i + 2] / 255
        const a = data[i + 3] / 255

        // 矩阵运算
        const newR = matrix[0] * r + matrix[1] * g + matrix[2] * b + matrix[3] * a + matrix[4]
        const newG = matrix[5] * r + matrix[6] * g + matrix[7] * b + matrix[8] * a + matrix[9]
        const newB = matrix[10] * r + matrix[11] * g + matrix[12] * b + matrix[13] * a + matrix[14]
        const newA = matrix[15] * r + matrix[16] * g + matrix[17] * b + matrix[18] * a + matrix[19]

        // 裁剪到 0-255
        data[i] = Math.max(0, Math.min(255, Math.round(newR * 255)))
        data[i + 1] = Math.max(0, Math.min(255, Math.round(newG * 255)))
        data[i + 2] = Math.max(0, Math.min(255, Math.round(newB * 255)))
        data[i + 3] = Math.max(0, Math.min(255, Math.round(newA * 255)))
      }

      // 写回像素数据
      await pixelMap.writeBufferToPixels(buffer)
    } catch (error) {
      const err = error as BusinessError
      console.error(`ImageProcessor: Apply color matrix failed, error: ${err.message}`)
    }
  }

  /**
   * 应用滤镜到图片
   * @param pixelMap 像素图
   * @param filterType 滤镜类型
   */
  static async applyFilter(pixelMap: image.PixelMap, filterType: FilterType): Promise<void> {
    if (filterType === FilterType.STANDARD) {
      // 原片模式，不做处理（或仅轻微锐化）
      return
    }

    const config = FilterService.getConfig(filterType)
    const compositeMatrix = FilterService.createCompositeMatrix(config)
    await ImageProcessor.applyColorMatrix(pixelMap, compositeMatrix)
  }

  /**
   * 添加颗粒噪点效果
   * @param pixelMap 像素图
   * @param intensity 强度 0.0 - 1.0
   */
  static async addGrain(pixelMap: image.PixelMap, intensity: number): Promise<void> {
    if (intensity <= 0) return

    try {
      const imageInfo = await pixelMap.getImageInfo()
      const width = imageInfo.size.width
      const height = imageInfo.size.height

      const bufferSize = width * height * 4
      const buffer = new ArrayBuffer(bufferSize)
      await pixelMap.readPixelsToBuffer(buffer)

      const data = new Uint8Array(buffer)
      const grainAmount = intensity * 30 // 最大30的噪点偏移

      for (let i = 0; i < data.length; i += 4) {
        const noise = (Math.random() - 0.5) * grainAmount

        data[i] = Math.max(0, Math.min(255, data[i] + noise))
        data[i + 1] = Math.max(0, Math.min(255, data[i + 1] + noise))
        data[i + 2] = Math.max(0, Math.min(255, data[i + 2] + noise))
      }

      await pixelMap.writeBufferToPixels(buffer)
    } catch (error) {
      const err = error as BusinessError
      console.error(`ImageProcessor: Add grain failed, error: ${err.message}`)
    }
  }

  /**
   * 7段数码管字符映射表
   * 每个字符用 7x5 的点阵表示 (简化版)
   */
  private static readonly DIGIT_PATTERNS: Map<string, number[][]> = new Map([
    ['0', [
      [1, 1, 1, 1, 1],
      [1, 0, 0, 0, 1],
      [1, 0, 0, 0, 1],
      [1, 0, 0, 0, 1],
      [1, 0, 0, 0, 1],
      [1, 0, 0, 0, 1],
      [1, 1, 1, 1, 1]
    ]],
    ['1', [
      [0, 0, 1, 0, 0],
      [0, 1, 1, 0, 0],
      [0, 0, 1, 0, 0],
      [0, 0, 1, 0, 0],
      [0, 0, 1, 0, 0],
      [0, 0, 1, 0, 0],
      [0, 1, 1, 1, 0]
    ]],
    ['2', [
      [1, 1, 1, 1, 1],
      [0, 0, 0, 0, 1],
      [0, 0, 0, 0, 1],
      [1, 1, 1, 1, 1],
      [1, 0, 0, 0, 0],
      [1, 0, 0, 0, 0],
      [1, 1, 1, 1, 1]
    ]],
    ['3', [
      [1, 1, 1, 1, 1],
      [0, 0, 0, 0, 1],
      [0, 0, 0, 0, 1],
      [1, 1, 1, 1, 1],
      [0, 0, 0, 0, 1],
      [0, 0, 0, 0, 1],
      [1, 1, 1, 1, 1]
    ]],
    ['4', [
      [1, 0, 0, 0, 1],
      [1, 0, 0, 0, 1],
      [1, 0, 0, 0, 1],
      [1, 1, 1, 1, 1],
      [0, 0, 0, 0, 1],
      [0, 0, 0, 0, 1],
      [0, 0, 0, 0, 1]
    ]],
    ['5', [
      [1, 1, 1, 1, 1],
      [1, 0, 0, 0, 0],
      [1, 0, 0, 0, 0],
      [1, 1, 1, 1, 1],
      [0, 0, 0, 0, 1],
      [0, 0, 0, 0, 1],
      [1, 1, 1, 1, 1]
    ]],
    ['6', [
      [1, 1, 1, 1, 1],
      [1, 0, 0, 0, 0],
      [1, 0, 0, 0, 0],
      [1, 1, 1, 1, 1],
      [1, 0, 0, 0, 1],
      [1, 0, 0, 0, 1],
      [1, 1, 1, 1, 1]
    ]],
    ['7', [
      [1, 1, 1, 1, 1],
      [0, 0, 0, 0, 1],
      [0, 0, 0, 0, 1],
      [0, 0, 0, 1, 0],
      [0, 0, 1, 0, 0],
      [0, 1, 0, 0, 0],
      [0, 1, 0, 0, 0]
    ]],
    ['8', [
      [1, 1, 1, 1, 1],
      [1, 0, 0, 0, 1],
      [1, 0, 0, 0, 1],
      [1, 1, 1, 1, 1],
      [1, 0, 0, 0, 1],
      [1, 0, 0, 0, 1],
      [1, 1, 1, 1, 1]
    ]],
    ['9', [
      [1, 1, 1, 1, 1],
      [1, 0, 0, 0, 1],
      [1, 0, 0, 0, 1],
      [1, 1, 1, 1, 1],
      [0, 0, 0, 0, 1],
      [0, 0, 0, 0, 1],
      [1, 1, 1, 1, 1]
    ]],
    [' ', [
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0]
    ]],
    ['\'', [
      [0, 1, 0, 0, 0],
      [0, 1, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0]
    ]]
  ])

  /**
   * 在图片上绘制日期水印 (真实字符版本)
   * 使用破坏性合成 (Burn-in)
   * @param pixelMap 像素图
   * @param dateText 日期文本 (格式: 'YY MM DD)
   */
  static async drawDateStamp(pixelMap: image.PixelMap, dateText: string): Promise<void> {
    try {
      const imageInfo = await pixelMap.getImageInfo()
      const width = imageInfo.size.width
      const height = imageInfo.size.height

      const bufferSize = width * height * 4
      const buffer = new ArrayBuffer(bufferSize)
      await pixelMap.readPixelsToBuffer(buffer)

      const data = new Uint8Array(buffer)

      // 橙色 #FF5500
      const orangeR = 255
      const orangeG = 85
      const orangeB = 0

      // 计算字符尺寸和位置
      const pixelSize = Math.max(2, Math.floor(width / 400)) // 根据图片宽度自适应像素大小
      const charWidth = 5 * pixelSize
      const charHeight = 7 * pixelSize
      const charSpacing = 2 * pixelSize
      
      // 计算总宽度
      const totalWidth = dateText.length * (charWidth + charSpacing)
      
      // 右下角位置
      const startX = width - totalWidth - Math.floor(width * 0.03)
      const startY = height - charHeight - Math.floor(height * 0.03)

      // 绘制每个字符
      let currentX = startX
      for (let i = 0; i < dateText.length; i++) {
        const char = dateText[i]
        const pattern = ImageProcessor.DIGIT_PATTERNS.get(char)
        
        if (pattern) {
          // 绘制字符本体
          for (let py = 0; py < 7; py++) {
            for (let px = 0; px < 5; px++) {
              if (pattern[py][px] === 1) {
                // 绘制像素块 (放大到 pixelSize x pixelSize)
                for (let dy = 0; dy < pixelSize; dy++) {
                  for (let dx = 0; dx < pixelSize; dx++) {
                    const x = currentX + px * pixelSize + dx
                    const y = startY + py * pixelSize + dy
                    
                    if (x >= 0 && x < width && y >= 0 && y < height) {
                      const idx = (y * width + x) * 4
                      
                      // 主体像素 - 完全不透明
                      data[idx] = orangeR
                      data[idx + 1] = orangeG
                      data[idx + 2] = orangeB
                    }
                  }
                }
                
                // 添加发光效果 - 在字符周围绘制半透明橙色
                const glowRadius = pixelSize
                for (let gy = -glowRadius; gy <= glowRadius; gy++) {
                  for (let gx = -glowRadius; gx <= glowRadius; gx++) {
                    const distance = Math.sqrt(gx * gx + gy * gy)
                    if (distance > 0 && distance <= glowRadius) {
                      for (let dy = 0; dy < pixelSize; dy++) {
                        for (let dx = 0; dx < pixelSize; dx++) {
                          const x = currentX + px * pixelSize + dx + gx
                          const y = startY + py * pixelSize + dy + gy
                          
                          if (x >= 0 && x < width && y >= 0 && y < height) {
                            const idx = (y * width + x) * 4
                            
                            // 发光强度随距离衰减
                            const glowAlpha = (1 - distance / glowRadius) * 0.3
                            
                            data[idx] = Math.min(255, Math.round(data[idx] * (1 - glowAlpha) + orangeR * glowAlpha))
                            data[idx + 1] = Math.min(255, Math.round(data[idx + 1] * (1 - glowAlpha) + orangeG * glowAlpha))
                            data[idx + 2] = Math.min(255, Math.round(data[idx + 2] * (1 - glowAlpha) + orangeB * glowAlpha))
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
        
        currentX += charWidth + charSpacing
      }

      await pixelMap.writeBufferToPixels(buffer)
      console.info(`ImageProcessor: Date stamp added - ${dateText}`)
    } catch (error) {
      const err = error as BusinessError
      console.error(`ImageProcessor: Draw date stamp failed, error: ${err.message}`)
    }
  }

  /**
   * 保存图片到媒体库
   * @param context 应用上下文
   * @param pixelMap 像素图
   * @returns 保存成功返回图片 URI，失败返回 undefined
   */
  static async saveToGallery(context: Context, pixelMap: image.PixelMap): Promise<string | undefined> {
    try {
      // 获取 PhotoAccessHelper
      const phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context)

      // 创建图片资源
      const createOptions: photoAccessHelper.CreateOptions = {
        title: `RetroLogCam_${Date.now()}`
      }

      const photoUri = await phAccessHelper.createAsset(
        photoAccessHelper.PhotoType.IMAGE,
        'jpg',
        createOptions
      )

      // 打开文件并写入数据
      const file = await fileIo.open(photoUri, fileIo.OpenMode.READ_WRITE)

      // 创建 ImagePacker 并打包图片
      const imagePacker = image.createImagePacker()
      const packOptions: image.PackingOption = {
        format: 'image/jpeg',
        quality: 95
      }

      const packedData = await imagePacker.packing(pixelMap, packOptions)
      await fileIo.write(file.fd, packedData)
      await fileIo.close(file.fd)

      console.info(`ImageProcessor: Photo saved to ${photoUri}`)
      return photoUri // 返回 URI 而不是 true
    } catch (error) {
      const err = error as BusinessError
      console.error(`ImageProcessor: Save to gallery failed, error code: ${err.code}, message: ${err.message}`)
      return undefined // 返回 undefined 而不是 false
    }
  }

  /**
   * 完整的图片处理流程
   * @param context 应用上下文
   * @param pixelMap 原始像素图
   * @param filterType 滤镜类型
   * @param addDateStamp 是否添加日期水印
   * @returns 保存成功返回图片 URI，失败返回 undefined
   */
  static async processAndSave(
    context: Context,
    pixelMap: image.PixelMap,
    filterType: FilterType,
    addDateStamp: boolean = true
  ): Promise<string | undefined> {
    try {
      // 1. 应用滤镜
      await ImageProcessor.applyFilter(pixelMap, filterType)

      // 2. 获取滤镜配置，添加颗粒效果
      const config = FilterService.getConfig(filterType)
      if (config.grain > 0) {
        await ImageProcessor.addGrain(pixelMap, config.grain)
      }

      // 3. 添加日期水印
      if (addDateStamp) {
        const dateText = ImageProcessor.getFormattedDate()
        await ImageProcessor.drawDateStamp(pixelMap, dateText)
      }

      // 4. 保存到媒体库并返回 URI
      return await ImageProcessor.saveToGallery(context, pixelMap)
    } catch (error) {
      const err = error as BusinessError
      console.error(`ImageProcessor: Process and save failed, error: ${err.message}`)
      return undefined
    }
  }
}
