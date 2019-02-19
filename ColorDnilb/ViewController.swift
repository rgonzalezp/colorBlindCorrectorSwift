//
//  ViewController.swift
//  ColorDnilb
//
//  Created by Federico Gonzalez on 2/13/19.
//  Copyright © 2019 Ricardo Gonzalez. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    struct RGBAPixel {
        public init (rawVal : UInt32) {
            raw = rawVal
        }
        public var raw: UInt32
        public var red: UInt8 {
            get { return UInt8(raw & 0xFF)}
            set{ raw = UInt32(newValue << 24) | (raw & 0xFFFFFF00)}
        }
        public var green: UInt8 {
            get {   return UInt8((raw & 0xFF00) >> 8)}
            set{ raw = UInt32(newValue << 24) | (raw & 0xFFFF00FF)}
        }
        public var blue: UInt8 {
            get { return UInt8((raw & 0xFF0000) >> 16)}
            set{ raw = UInt32(newValue << 24) | (raw & 0xFF00FFFF)}
        }
        public var alpha: UInt8 {
            get { return UInt8((raw & 0xFF000000) >> 24)}
            set{ raw = UInt32(newValue << 24) | (raw & 0x00FFFFFF)}
        }
        
        public mutating func change (red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
            let red   = UInt32(red)
            let green = UInt32(green)
            let blue  = UInt32(blue)
            let alpha = UInt32(alpha)
            raw = (red << 24) | (green << 16) | (blue << 8) | (alpha << 0)
        }
    }
    

    
    @IBOutlet weak var imgView: UIImageView!
    
    private var originalImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalImage = imgView.image
        // Do any additional setup after loading the view, typically from a nib.
    }

     func applyTritanopia(_ sender: Any) {
        
        
        var image = imgView.image
        
        
        let height = Int((image?.size.height)!)
        
        let width = Int((image?.size.width)!)
        let bitsPerComponent = Int(8)
        let bytesPerRow = 4 * width
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let rawData = UnsafeMutablePointer<RGBAPixel>.allocate(capacity: (width * height))
        let bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue
        let CGPointZero = CGPoint(x: 0, y: 0)
        let rect = CGRect(origin: CGPointZero, size: (image?.size)!)
        let imageContext = CGContext(data: rawData, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
        imageContext?.draw(image!.cgImage!, in: rect)
        
        let pixels = UnsafeMutableBufferPointer<RGBAPixel>(start: rawData, count: width * height)
        
        for y in 0 ..< height {
            for x in 0 ..< width {
                
                
                var p = pixels[x+y*width]
                
                let R : Double = Double (p.red)
                let G : Double = Double (p.green)
                let B : Double = Double (p.blue)
                
                let L = (17.8824 * R) + (43.5161 * G) + (4.11935 * B)
                let M = (3.45565 * R) + (27.1554 * G) + (3.86714 * B)
                let S = (0.0299566 * R) + (0.184309 * G) + (1.46709 * B)
                
                let Lp = L
                let Mp =  M
                let Sp =  (-0.395913 * L) + (0.801109 *  M)
                
                let Rp = (0.0809444479 * Lp) + (-0.130504409 * Mp) + (0.116721066 * Sp)
                let Gp = (   -0.0102485335 * Lp) + (    0.0540193266 * Mp) + (  -0.113614708    * Sp)
                let Bp = (-0.000365296938 * Lp) + (-0.0041261469 * Mp) + (0.693511405 * Sp)
                
                let Rdif = R - Rp
                let Gdif = G - Gp
                let Bdif = B - Bp
                
                let nuevR  = Rdif + (0.7 * Bdif)
                let nuevG  = (0.7 * Bdif) + Gdif
                let nuevB  = 0.0
                
                var wa = (R + nuevR)
                var wb = (G + nuevG)
                var wc = (B + nuevB)
                
                if (wa>255) {
                    wa = 255
                }
                
                if (wb>255) {
                    wb = 255
                }
                if (wc>255) {
                    wc = 255
                }
                
                if (wa<0) {
                    wa = 0
                }
                
                if (wb<0) {
                    wb = 0
                }
                if (wc<0) {
                    wc = 0
                }
                
                p.change(red: UInt8(wa),green: UInt8(wb),blue: UInt8(wc),alpha: UInt8(0xFF))
                
                pixels[x+y*width] = p
                
                
            }
        }
        let outContext = CGContext(data: pixels.baseAddress, width: width, height: height, bitsPerComponent: bitsPerComponent,bytesPerRow: bytesPerRow,space: colorSpace,bitmapInfo: bitmapInfo,releaseCallback: nil,releaseInfo: nil)
        
        imgView.image = UIImage(cgImage: outContext!.makeImage()!)
    }
    
    func applyDeuteranopia(_ sender: Any) {
        
        var image = imgView.image
        
        
        let height = Int((image?.size.height)!)
        
        let width = Int((image?.size.width)!)
        let bitsPerComponent = Int(8)
        let bytesPerRow = 4 * width
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let rawData = UnsafeMutablePointer<RGBAPixel>.allocate(capacity: (width * height))
        let bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue
        let CGPointZero = CGPoint(x: 0, y: 0)
        let rect = CGRect(origin: CGPointZero, size: (image?.size)!)
        let imageContext = CGContext(data: rawData, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
        imageContext?.draw(image!.cgImage!, in: rect)
        
        let pixels = UnsafeMutableBufferPointer<RGBAPixel>(start: rawData, count: width * height)
        
        for y in 0 ..< height {
            for x in 0 ..< width {
                
                
                var p = pixels[x+y*width]
                let R : Double = Double (p.red)
                let G : Double = Double (p.green)
                let B : Double = Double (p.blue)
                
                let L = (17.8824 * R) + (43.5161 * G) + (4.11935 * B)
                _ = (3.45565 * R) + (27.1554 * G) + (3.86714 * B)
                let S = (0.0299566 * R) + (0.184309 * G) + (1.46709 * B)
                
                let Lp = L
                let Mp =  (0.49421 * L) + (1.24827 *  S)
                let Sp =  S
                
                let Rp = (0.0809444479 * Lp) + (-0.130504409 * Mp) + (0.116721066 * Sp)
                let Gp = (   -0.0102485335 * Lp) + (    0.0540193266 * Mp) + (  -0.113614708    * Sp)
                let Bp = (-0.000365296938 * Lp) + (-0.0041261469 * Mp) + (0.693511405 * Sp)
                
                let Rdif = R - Rp
                let Gdif = G - Gp
                let Bdif = B - Bp
                
                let nuevR  = Rdif + (0.7 * Gdif)
                let nuevG  = 0.0
                let nuevB  = (0.7 * Gdif) + Bdif
                
                var wa = (R + nuevR)
                var wb = (G + nuevG)
                var wc = (B + nuevB)
                
                if (wa>255) {
                    wa = 255
                }
                
                if (wb>255) {
                    wb = 255
                }
                if (wc>255) {
                    wc = 255
                }
                
                if (wa<0) {
                    wa = 0
                }
                
                if (wb<0) {
                    wb = 0
                }
                if (wc<0) {
                    wc = 0
                }
                
                p.change(red: UInt8(wa),green: UInt8(wb),blue: UInt8(wc),alpha: UInt8(0xFF))
                
                pixels[x+y*width] = p
                
                
            }
        }
        let outContext = CGContext(data: pixels.baseAddress, width: width, height: height, bitsPerComponent: bitsPerComponent,bytesPerRow: bytesPerRow,space: colorSpace,bitmapInfo: bitmapInfo,releaseCallback: nil,releaseInfo: nil)
        
        imgView.image = UIImage(cgImage: outContext!.makeImage()!)
        
        

    }
    
     func applyProtanopia(_ sender: Any) {
        
        var image = imgView.image
        
        let height = Int((image?.size.height)!)
        
        let width = Int((image?.size.width)!)
        let bitsPerComponent = Int(8)
        let bytesPerRow = 4 * width
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let rawData = UnsafeMutablePointer<RGBAPixel>.allocate(capacity: (width * height))
        let bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue
        let CGPointZero = CGPoint(x: 0, y: 0)
        let rect = CGRect(origin: CGPointZero, size: (image?.size)!)
        let imageContext = CGContext(data: rawData, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
        imageContext?.draw(image!.cgImage!, in: rect)
        
        let pixels = UnsafeMutableBufferPointer<RGBAPixel>(start: rawData, count: width * height)
        
        for y in 0 ..< height {
            for x in 0 ..< width {
                
                
                var p = pixels[x+y*width]
                let R : Double = Double (p.red)
                let G : Double = Double (p.green)
                let B : Double = Double (p.blue)
                
                let L = (17.8824 * R) + (43.5161 * G) + (4.11935 * B)
                let M = (3.45565 * R) + (27.1554 * G) + (3.86714 * B)
                let S = (0.0299566 * R) + (0.184309 * G) + (1.46709 * B)
                
                let Lp = (2.02344 * M) + (-2.52581 *  S)
                let Mp =  M
                let Sp =  S
                
                let Rp = (0.0809444479 * Lp) + (-0.130504409 * Mp) + (0.116721066 * Sp)
                let Gp = (   -0.0102485335 * Lp) + (    0.0540193266 * Mp) + (  -0.113614708    * Sp)
                let Bp = (-0.000365296938 * Lp) + (-0.0041261469 * Mp) + (0.693511405 * Sp)
                
                let Rdif = R - Rp
                let Gdif = G - Gp
                let Bdif = B - Bp
                
                let nuevR  = 0.0
                let nuevG  =  Gdif + (0.7 * Rdif)
                let nuevB  = (0.7 * Rdif) + Bdif
                
                var wa = (R + nuevR)
                var wb = (G + nuevG)
                var wc = (B + nuevB)
                
                if (wa>255) {
                    wa = 255
                }
                
                if (wb>255) {
                    wb = 255
                }
                if (wc>255) {
                    wc = 255
                }
                
                if (wa<0) {
                    wa = 0
                }
                
                if (wb<0) {
                    wb = 0
                }
                if (wc<0) {
                    wc = 0
                }
                
                p.change(red: UInt8(wa),green: UInt8(wb),blue: UInt8(wc),alpha: UInt8(0xFF))
                
                pixels[x+y*width] = p
                
                
            }
        }
        let outContext = CGContext(data: pixels.baseAddress, width: width, height: height, bitsPerComponent: bitsPerComponent,bytesPerRow: bytesPerRow,space: colorSpace,bitmapInfo: bitmapInfo,releaseCallback: nil,releaseInfo: nil)
        
        imgView.image = UIImage(cgImage: outContext!.makeImage()!)
    }
    
    @IBAction func applyFilt(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Filter", message:"Choose a filter", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Protanopia", style: .default , handler: {(action: UIAlertAction) in
            self.applyProtanopia((Any).self)
        }
        ))
        
        
        actionSheet.addAction(UIAlertAction(title: "Deuteranopia", style: .default , handler: {(action: UIAlertAction) in
            self.applyDeuteranopia((Any).self)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Tritanopia", style: .default , handler: {(action: UIAlertAction) in
            self.applyTritanopia((Any).self)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "cancel", style: .cancel , handler: nil))
        
        self.present(actionSheet, animated:true, completion: nil)
        
    }
    @IBAction func chooseImg(_ sender: Any) {
        
        let imagePick = UIImagePickerController()
        
        imagePick.delegate = self
        let actionSheet = UIAlertController(title: "Photo source", message:"Choose a source", preferredStyle: .actionSheet)
        
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default , handler: {(action: UIAlertAction) in if(UIImagePickerController.isSourceTypeAvailable(.camera)) { imagePick.sourceType = .camera
            self.present(imagePick, animated:true, completion: nil)}
        }
        ))
        
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default , handler: {(action: UIAlertAction) in imagePick.sourceType = .photoLibrary
            self.present(imagePick, animated:true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler: nil))
        
        self.present(actionSheet, animated:true, completion: nil)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imgView.image = image
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    @IBAction func clear(_ sender: Any) {
       imgView.image = originalImage
    }
}

