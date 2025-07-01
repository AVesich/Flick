//
//  NSImage+dominantColor.swift
//  Flick
//
//  Created by Austin Vesich on 6/16/25.
//

import AppKit
import CoreImage
import CoreImage.CIFilterBuiltins

extension NSImage {
    func dominantColor() -> NSColor {	
        guard let colorImage = self.getAverageColorAsCIImage(),
              let saturatedImage = boostSaturation(of: colorImage) else { return .black }
        
        let colorBitmap = getRGBComponentsForImage(saturatedImage)
        
        return NSColor(red: CGFloat(colorBitmap[0])/255.0,
                       green: CGFloat(colorBitmap[1])/255.0,
                       blue: CGFloat(colorBitmap[2])/255.0,
                       alpha: CGFloat(colorBitmap[3])/255.0)
    }
    
    
    private func getAverageColorAsCIImage() -> CIImage? {
        guard let image = self.asCIImage() else { return nil }
        
        // Get the average color of the image over its full CGRect
        let filter = CIFilter.areaAverage()
        filter.inputImage = image
        filter.extent = image.extent
        return filter.outputImage
    }
    
    private func boostSaturation(of image: CIImage) -> CIImage? {
        let filter = CIFilter.colorControls()
        filter.saturation = 6.0
        filter.inputImage = image
        return filter.outputImage
    }
    
    private func getRGBComponentsForImage(_ image: CIImage) -> [UInt8] {
        var colorBitmap = [UInt8](repeating: 0, count: 4)
        let renderer = CIContext()
        renderer.render(image,
                        toBitmap: &colorBitmap,
                        rowBytes: 4,
                        bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
                        format: .RGBA8,
                        colorSpace: CGColorSpaceCreateDeviceRGB())

        return colorBitmap
    }
    
    private func asCIImage() -> CIImage? {
        guard let data = self.tiffRepresentation else { return nil }
        return CIImage(data: data)
    }
}
