//
//  ViewController.swift
//  DrawCircleSwift
//
//  Created by liangzhimy on 2017/9/27.
//  Copyright © 2017年 laig. All rights reserved.
//

import Cocoa

extension Double {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
}

class ViewController: NSViewController {

    @IBOutlet weak var imageView: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var process = 0.0
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { (timer) in
            process += 0.01
            if let image = self.__renderCircleImage(radius: 150, process: CGFloat(process), strokeWidth: 2) {
                self.imageView.image = image
            }
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func __renderCircleImage(radius: CGFloat, process: CGFloat, strokeWidth: CGFloat) -> NSImage? {
        let imageSize = NSMakeSize(radius * 2, radius * 2)
        let offscreenRep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: Int(imageSize.width), pixelsHigh: Int(imageSize.height), bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: NSColorSpaceName.deviceRGB, bitmapFormat: NSBitmapImageRep.Format.alphaFirst, bytesPerRow: 0, bitsPerPixel: 0)
        let g = NSGraphicsContext(bitmapImageRep: offscreenRep!)
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = g
        let ctx = g?.cgContext
        if (strokeWidth > 0.0) {
            ctx?.setLineWidth(strokeWidth)
            ctx?.addArc(center: CGPoint(x: radius, y: radius), radius: radius - strokeWidth * 0.5, startAngle: 0, endAngle:  CGFloat(360.degreesToRadians), clockwise: true)
            ctx?.drawPath(using: CGPathDrawingMode.stroke)
        }
        
        ctx?.move(to: CGPoint(x: radius, y: radius))
        let endAngle = CGFloat(Double(90 - process * 360.0).degreesToRadians)
        let startAngle = CGFloat(Double(90).degreesToRadians)
        ctx?.addArc(center: CGPoint(x: radius, y: radius), radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        ctx?.drawPath(using: CGPathDrawingMode.fill)
        
        NSGraphicsContext.restoreGraphicsState()
        if let data = offscreenRep?.representation(using: NSBitmapImageRep.FileType.png, properties: [:]) {
            return NSImage(data: data)
        }
        
        return nil
    }

}

