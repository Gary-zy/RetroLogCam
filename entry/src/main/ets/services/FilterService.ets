/**
 * FilterService - 滤镜服务
 * 提供各种复古风格的颜色矩阵和滤镜算法
 */

import { FilterType } from '../common/constants/Constants'

/**
 * 颜色矩阵类型定义
 * 4x5 矩阵用于颜色变换
 * [R, G, B, A, Offset] x 4 行
 */
export type ColorMatrix = number[]

/**
 * 滤镜配置接口
 */
export interface FilterConfig {
  name: string
  matrix: ColorMatrix
  contrast: number      // 对比度 0.0 - 2.0
  saturation: number    // 饱和度 0.0 - 2.0
  brightness: number    // 亮度 -1.0 - 1.0
  sharpness: number     // 锐度 0.0 - 1.0
  grain: number         // 颗粒度 0.0 - 1.0
  warmth: number        // 色温 -1.0 (冷) - 1.0 (暖)
}

// 标准滤镜矩阵 (单位矩阵)
const STANDARD_MATRIX: ColorMatrix = [
  1.0, 0.0, 0.0, 0.0, 0.0,
  0.0, 1.0, 0.0, 0.0, 0.0,
  0.0, 0.0, 1.0, 0.0, 0.0,
  0.0, 0.0, 0.0, 1.0, 0.0
]

// D-Log 滤镜矩阵 - 饱和度 -40%, 对比度 -30%, 阴影亮度 +20%
const D_LOG_MATRIX: ColorMatrix = [
  0.75, 0.15, 0.10, 0.0, 0.08,
  0.15, 0.70, 0.15, 0.0, 0.08,
  0.10, 0.15, 0.75, 0.0, 0.08,
  0.0,  0.0,  0.0,  1.0, 0.0
]

// Classic S 滤镜矩阵 - 色温偏冷, 蓝色通道增强
const CLASSIC_S_MATRIX: ColorMatrix = [
  0.95, 0.0,  0.05, 0.0, -0.02,
  0.0,  0.95, 0.05, 0.0, -0.02,
  0.05, 0.10, 1.10, 0.0,  0.05,
  0.0,  0.0,  0.0,  1.0,  0.0
]

// Vintage C 滤镜矩阵 - 色温偏暖, 洋红
const VINTAGE_C_MATRIX: ColorMatrix = [
  1.10, 0.05, 0.0,  0.0, 0.03,
  0.05, 0.98, 0.02, 0.0, 0.02,
  0.0,  0.02, 0.90, 0.0, -0.02,
  0.0,  0.0,  0.0,  1.0, 0.0
]

// Mono CCD 滤镜矩阵 - 黑白高反差
const MONO_CCD_MATRIX: ColorMatrix = [
  0.40, 0.40, 0.20, 0.0, 0.0,
  0.40, 0.40, 0.20, 0.0, 0.0,
  0.40, 0.40, 0.20, 0.0, 0.0,
  0.0,  0.0,  0.0,  1.0, 0.0
]

// Cyber 2000 滤镜矩阵 - 偏冷绿色调
const CYBER_2000_MATRIX: ColorMatrix = [
  0.80, 0.10, 0.10, 0.0, -0.05,
  0.15, 1.10, 0.10, 0.0,  0.05,
  0.10, 0.15, 0.85, 0.0, -0.05,
  0.0,  0.0,  0.0,  1.0,  0.0
]

// Soft Dream 滤镜矩阵 - 柔光梦幻
const SOFT_DREAM_MATRIX: ColorMatrix = [
  1.05, 0.05, 0.05, 0.0, 0.10,
  0.05, 1.05, 0.05, 0.0, 0.10,
  0.05, 0.05, 1.00, 0.0, 0.08,
  0.0,  0.0,  0.0,  1.0, 0.0
]

export class FilterService {
  /**
   * 获取指定滤镜的颜色矩阵
   * @param type 滤镜类型
   * @returns 颜色矩阵
   */
  static getMatrix(type: FilterType): ColorMatrix {
    switch (type) {
      case FilterType.STANDARD:
        return STANDARD_MATRIX
      case FilterType.D_LOG:
        return D_LOG_MATRIX
      case FilterType.CLASSIC_S:
        return CLASSIC_S_MATRIX
      case FilterType.VINTAGE_C:
        return VINTAGE_C_MATRIX
      case FilterType.MONO_CCD:
        return MONO_CCD_MATRIX
      case FilterType.CYBER_2000:
        return CYBER_2000_MATRIX
      case FilterType.SOFT_DREAM:
        return SOFT_DREAM_MATRIX
      default:
        return STANDARD_MATRIX
    }
  }

  /**
   * 获取指定滤镜的完整配置
   * @param type 滤镜类型
   * @returns 滤镜配置
   */
  static getConfig(type: FilterType): FilterConfig {
    switch (type) {
      case FilterType.STANDARD:
        return {
          name: 'Standard',
          matrix: STANDARD_MATRIX,
          contrast: 1.0,
          saturation: 1.0,
          brightness: 0.0,
          sharpness: 0.1,
          grain: 0.0,
          warmth: 0.0
        }
      case FilterType.D_LOG:
        return {
          name: 'D-Log',
          matrix: D_LOG_MATRIX,
          contrast: 0.7,
          saturation: 0.6,
          brightness: 0.2,
          sharpness: 0.0,
          grain: 0.05,
          warmth: 0.0
        }
      case FilterType.CLASSIC_S:
        return {
          name: 'Classic S',
          matrix: CLASSIC_S_MATRIX,
          contrast: 1.1,
          saturation: 1.0,
          brightness: 0.0,
          sharpness: 0.3,
          grain: 0.1,
          warmth: -0.3
        }
      case FilterType.VINTAGE_C:
        return {
          name: 'Vintage C',
          matrix: VINTAGE_C_MATRIX,
          contrast: 0.95,
          saturation: 1.1,
          brightness: 0.05,
          sharpness: 0.0,
          grain: 0.15,
          warmth: 0.3
        }
      case FilterType.MONO_CCD:
        return {
          name: 'Mono CCD',
          matrix: MONO_CCD_MATRIX,
          contrast: 1.2,
          saturation: 0.0,
          brightness: 0.0,
          sharpness: 0.2,
          grain: 0.5,
          warmth: 0.0
        }
      case FilterType.CYBER_2000:
        return {
          name: 'Cyber 2000',
          matrix: CYBER_2000_MATRIX,
          contrast: 1.25,
          saturation: 0.9,
          brightness: -0.05,
          sharpness: 0.25,
          grain: 0.2,
          warmth: -0.2
        }
      case FilterType.SOFT_DREAM:
        return {
          name: 'Soft Dream',
          matrix: SOFT_DREAM_MATRIX,
          contrast: 0.85,
          saturation: 0.95,
          brightness: 0.15,
          sharpness: -0.3,
          grain: 0.05,
          warmth: 0.1
        }
      default:
        return {
          name: 'Standard',
          matrix: STANDARD_MATRIX,
          contrast: 1.0,
          saturation: 1.0,
          brightness: 0.0,
          sharpness: 0.1,
          grain: 0.0,
          warmth: 0.0
        }
    }
  }

  /**
   * 生成饱和度调整矩阵
   * @param saturation 饱和度值 0.0 - 2.0
   * @returns 颜色矩阵
   */
  static createSaturationMatrix(saturation: number): ColorMatrix {
    const s = saturation
    const sr = (1 - s) * 0.3086
    const sg = (1 - s) * 0.6094
    const sb = (1 - s) * 0.0820

    return [
      sr + s, sg, sb, 0, 0,
      sr, sg + s, sb, 0, 0,
      sr, sg, sb + s, 0, 0,
      0, 0, 0, 1, 0
    ]
  }

  /**
   * 生成对比度调整矩阵
   * @param contrast 对比度值 0.0 - 2.0
   * @returns 颜色矩阵
   */
  static createContrastMatrix(contrast: number): ColorMatrix {
    const t = (1 - contrast) / 2

    return [
      contrast, 0, 0, 0, t,
      0, contrast, 0, 0, t,
      0, 0, contrast, 0, t,
      0, 0, 0, 1, 0
    ]
  }

  /**
   * 生成亮度调整矩阵
   * @param brightness 亮度值 -1.0 - 1.0
   * @returns 颜色矩阵
   */
  static createBrightnessMatrix(brightness: number): ColorMatrix {
    return [
      1, 0, 0, 0, brightness,
      0, 1, 0, 0, brightness,
      0, 0, 1, 0, brightness,
      0, 0, 0, 1, 0
    ]
  }

  /**
   * 生成色温调整矩阵
   * @param warmth 色温值 -1.0 (冷) - 1.0 (暖)
   * @returns 颜色矩阵
   */
  static createWarmthMatrix(warmth: number): ColorMatrix {
    return [
      1 + warmth * 0.1, 0, 0, 0, warmth * 0.05,
      0, 1, 0, 0, 0,
      0, 0, 1 - warmth * 0.1, 0, -warmth * 0.05,
      0, 0, 0, 1, 0
    ]
  }

  /**
   * 矩阵乘法 - 合并两个颜色矩阵
   * @param m1 第一个矩阵
   * @param m2 第二个矩阵
   * @returns 合并后的矩阵
   */
  static multiplyMatrices(m1: ColorMatrix, m2: ColorMatrix): ColorMatrix {
    const result: number[] = new Array(20).fill(0)

    for (let i = 0; i < 4; i++) {
      for (let j = 0; j < 5; j++) {
        let sum = 0
        for (let k = 0; k < 4; k++) {
          sum += m1[i * 5 + k] * m2[k * 5 + j]
        }
        if (j === 4) {
          sum += m1[i * 5 + 4]
        }
        result[i * 5 + j] = sum
      }
    }

    return result
  }

  /**
   * 生成复合滤镜矩阵
   * @param config 滤镜配置
   * @returns 合并后的颜色矩阵
   */
  static createCompositeMatrix(config: FilterConfig): ColorMatrix {
    let result = config.matrix

    // 应用饱和度
    if (config.saturation !== 1.0) {
      const satMatrix = FilterService.createSaturationMatrix(config.saturation)
      result = FilterService.multiplyMatrices(result, satMatrix)
    }

    // 应用对比度
    if (config.contrast !== 1.0) {
      const contrastMatrix = FilterService.createContrastMatrix(config.contrast)
      result = FilterService.multiplyMatrices(result, contrastMatrix)
    }

    // 应用亮度
    if (config.brightness !== 0.0) {
      const brightnessMatrix = FilterService.createBrightnessMatrix(config.brightness)
      result = FilterService.multiplyMatrices(result, brightnessMatrix)
    }

    // 应用色温
    if (config.warmth !== 0.0) {
      const warmthMatrix = FilterService.createWarmthMatrix(config.warmth)
      result = FilterService.multiplyMatrices(result, warmthMatrix)
    }

    return result
  }

  /**
   * 获取所有滤镜类型列表
   */
  static getAllFilterTypes(): FilterType[] {
    return [
      FilterType.STANDARD,
      FilterType.D_LOG,
      FilterType.CLASSIC_S,
      FilterType.VINTAGE_C,
      FilterType.MONO_CCD,
      FilterType.CYBER_2000,
      FilterType.SOFT_DREAM
    ]
  }

  /**
   * 获取滤镜预览描述
   */
  static getFilterDescription(type: FilterType): string {
    switch (type) {
      case FilterType.STANDARD:
        return '原片直出，轻微锐化'
      case FilterType.D_LOG:
        return '电影级灰片，保留最大动态范围'
      case FilterType.CLASSIC_S:
        return '索尼CCD风格，偏冷蓝调'
      case FilterType.VINTAGE_C:
        return '佳能复古，暖黄肤色优化'
      case FilterType.MONO_CCD:
        return '高反差黑白，浓郁颗粒感'
      case FilterType.CYBER_2000:
        return '黑客帝国，赛博冷绿调'
      case FilterType.SOFT_DREAM:
        return '柔光梦幻，高光溢出'
      default:
        return ''
    }
  }
}
