import HTTP
import JSON
import Vapor

import Foundation
import Cairo
import CCairo

//import Silica

// Launch Web Server
// ━━━━━━━━━━━━━━━━━
let app = try Droplet()

// MARK: Test API
app.get("/cairotest") { (request:HTTP.Request) in

//    // Init
//    let frame = CGRect(origin: .zero, size: CGSize(width: 200, height: 200))
//    let surface = try! Surface.Image(format: .rgb24, width: Int(frame.width), height: Int(frame.height))
//    let context = try! Silica.CGContext(surface: surface, size: frame.size)
//
//    // Draw
//    context.fillColor = Silica.CGColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
//    context.strokeColor = Silica.CGColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0)
//    context.lineWidth = 10.0
//    context.addLine(to: CGPoint(x: 0.0, y: 0.0))
//    context.addLine(to: CGPoint(x: 200.0, y: 0.0))
//    context.strokePath()
//    context.addRect(CGRect(x: 30, y: 30, width: 100, height: 100))
//    context.drawPath()
//
//    // Draw String
//    context.setFont(CGFont(name:"Sans")!)
//    context.move(to: CGPoint(x: 0, y: 170))
//    context.show(toyText: "ABCDEFG")
//
//    // Export
//    let png = try! context.surface.writePNG()
//    
//    // Response
//    return HTTP.Response( status: .ok, headers: [HeaderKey("Content-Type") : "image/png"], body: png)
    
    let surface = try! Surface.Image(format: .rgb24, width: 200, height: 200)
    let context = Cairo.Context(surface: surface)
    
    // Setting
    context.setSource(color: (red: 1.0, green: 0.0, blue: 0.0))
    context.lineWidth = 6.0
    
    // Draw Rectangle
    context.addRectangle(x: 10, y: 10, width: 100, height: 100)
    context.stroke()
    //context.fill()
    
    // Draw String
    context.move(to: (x: 0, y: 120))
    var cairoTextMatrix = Matrix.identity
    cairoTextMatrix.scale(x: Double(40), y: Double(40))
    cairoTextMatrix.multiply(a: cairoTextMatrix, b: Matrix.identity )
    context.setFont(matrix: cairoTextMatrix)
    //context.setFont(face: (family: "Sans", slant: .normal, weight: .normal))
    context.show(text: "ABCDEFG")
    
    // Draw Line
    context.line(to: (x: 0, y: 120))
    context.line(to: (x: 200, y: 120))
    context.stroke()
    
    // Draw Arc
    context.newPath()
    context.addArc(center: (x: 100, y: 100), radius: 90, angle: (90, 180))
    context.stroke()
    
    // Draw Surface
    let pngData = try! Data(contentsOf: URL(string: "http://www.addli.co.jp/assets/images/+Li_Logo.png")!)
    let p_surf = try! Surface.Image(png: pngData)
    let pattern = Pattern(surface: p_surf)
    let rect = CGRect(x: 100, y: 100, width: 100, height: 100)
    let sourceRect = CGRect(x: 0, y: 0, width: CGFloat(p_surf.width), height: CGFloat(p_surf.height))
    var patternMatrix = Matrix.identity
    patternMatrix.translate(x: Double(rect.origin.x), y: Double(rect.origin.y))
    patternMatrix.scale(x: Double(rect.size.width / sourceRect.size.width),
                        y: Double(rect.size.height / sourceRect.size.height))
    patternMatrix.scale(x: 1, y: -1)
    patternMatrix.translate(x: 0, y: Double(-sourceRect.size.height))
    patternMatrix.invert()
    pattern.matrix = patternMatrix
    pattern.extend = .pad
    context.operator = CAIRO_OPERATOR_OVER
    context.source = pattern
    context.addRectangle(x: Double(rect.origin.x),
                         y: Double(rect.origin.y),
                         width: Double(rect.size.width),
                         height: Double(rect.size.height))
    context.fill()
    context.restore()
    
    // Draw TTF
    
    let png = try! context.surface.writePNG()
    
    return HTTP.Response( status: .ok, headers: [HeaderKey("Content-Type") : "image/png"], body: png)
}


import SwiftGD

app.get("/gdtest") { (request:HTTP.Request) in
    
    if let image = Image(width: 500, height: 500) {
        
        // flood from from X:250 Y:250 using red
        image.fill(from: Point(x: 250, y: 250), color: Color.red)
        
        // draw a filled blue ellipse in the center
        image.fillEllipse(center: Point(x: 250, y: 250), size: Size(width: 150, height: 150), color: Color.blue)
        
        // draw a filled green rectangle also in the center
        image.fillRectangle(topLeft: Point(x: 200, y: 200), bottomRight: Point(x: 300, y: 300), color: Color.green)
        
        // remove all the colors from the image
        //image.desaturate()
        
        // now apply a dark red tint
        //image.colorize(using: Color(red: 0.3, green: 0, blue: 0, alpha: 1))
        
        // Paste a image
        
        let png = try! image.export(as: .png)
        return HTTP.Response( status: .ok, headers: [HeaderKey("Content-Type") : "image/png"], body: png)
    } else{
        return HTTP.Response( status: .internalServerError )
    }
}

try app.run()

