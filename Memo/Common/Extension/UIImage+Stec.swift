//
//  UIImage+Stec.swift
//  JFoundation
//
//  Created by XuAzen on 16/7/4.
//  Copyright © 2016年 st. All rights reserved.
//

import Foundation
import UIKit

public extension UIImage {
    
    public func largestCenteredSquareImage() -> UIImage {
        let scale = self.scale
        
        let originalWidth  = self.size.width * scale
        let originalHeight = self.size.height * scale
        
        let edge: CGFloat
        if originalWidth > originalHeight {
            edge = originalHeight
        } else {
            edge = originalWidth
        }
        
        let posX = (originalWidth  - edge) / 2.0
        let posY = (originalHeight - edge) / 2.0
        
        let cropSquare = CGRectMake(posX, posY, edge, edge)
        
        let imageRef = CGImageCreateWithImageInRect(self.CGImage, cropSquare)!
        
        return UIImage(CGImage: imageRef, scale: scale, orientation: self.imageOrientation)
    }
    
    public func resizeToTargetSize(targetSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = targetSize.width  / self.size.width
        let heightRatio = targetSize.height / self.size.height
        
        let scale = UIScreen.mainScreen().scale
        let newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSizeMake(scale * floor(size.width * heightRatio), scale * floor(size.height * heightRatio))
        } else {
            newSize = CGSizeMake(scale * floor(size.width * widthRatio), scale * floor(size.height * widthRatio))
        }
        
        let rect = CGRectMake(0, 0, floor(newSize.width), floor(newSize.height))
        
        //println("size: \(size), newSize: \(newSize), rect: \(rect)")
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    public func scaleToMinSideLength(sideLength: CGFloat) -> UIImage {
        
        let pixelSideLength = sideLength * UIScreen.mainScreen().scale
        
        //println("pixelSideLength: \(pixelSideLength)")
        //println("size: \(size)")
        
        let pixelWidth = size.width * scale
        let pixelHeight = size.height * scale
        
        //println("pixelWidth: \(pixelWidth)")
        //println("pixelHeight: \(pixelHeight)")
        
        let newSize: CGSize
        
        if pixelWidth > pixelHeight {
            
            guard pixelHeight > pixelSideLength else {
                return self
            }
            
            let newHeight = pixelSideLength
            let newWidth = (pixelSideLength / pixelHeight) * pixelWidth
            newSize = CGSize(width: floor(newWidth), height: floor(newHeight))
            
        } else {
            
            guard pixelWidth > pixelSideLength else {
                return self
            }
            
            let newWidth = pixelSideLength
            let newHeight = (pixelSideLength / pixelWidth) * pixelHeight
            newSize = CGSize(width: floor(newWidth), height: floor(newHeight))
        }
        
        if scale == UIScreen.mainScreen().scale {
            let newSize = CGSize(width: floor(newSize.width / scale), height: floor(newSize.height / scale))
            //println("A scaleToMinSideLength newSize: \(newSize)")
            
            UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
            let rect = CGRectMake(0, 0, newSize.width, newSize.height)
            self.drawInRect(rect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            if let image = newImage {
                return image
            }
            
            return self
            
        } else {
            //println("B scaleToMinSideLength newSize: \(newSize)")
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            let rect = CGRectMake(0, 0, newSize.width, newSize.height)
            self.drawInRect(rect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            if let image = newImage {
                return image
            }
            
            return self
        }
    }
    
    public func fixRotation() -> UIImage {
        if self.imageOrientation == .Up {
            return self
        }
        
        let width = self.size.width
        let height = self.size.height
        
        var transform = CGAffineTransformIdentity
        
        switch self.imageOrientation {
        case .Down, .DownMirrored:
            transform = CGAffineTransformTranslate(transform, width, height)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI))
            
        case .Left, .LeftMirrored:
            transform = CGAffineTransformTranslate(transform, width, 0)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2))
            
        case .Right, .RightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, height)
            transform = CGAffineTransformRotate(transform, CGFloat(-M_PI_2))
            
        default:
            break
        }
        
        switch self.imageOrientation {
        case .UpMirrored, .DownMirrored:
            transform = CGAffineTransformTranslate(transform, width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            
        case .LeftMirrored, .RightMirrored:
            transform = CGAffineTransformTranslate(transform, height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            
        default:
            break
        }
        
        let selfCGImage = self.CGImage
        let context = CGBitmapContextCreate(nil, Int(width), Int(height), CGImageGetBitsPerComponent(selfCGImage), 0, CGImageGetColorSpace(selfCGImage), CGImageGetBitmapInfo(selfCGImage).rawValue);
        
        CGContextConcatCTM(context, transform)
        
        switch self.imageOrientation {
        case .Left, .LeftMirrored, .Right, .RightMirrored:
            CGContextDrawImage(context, CGRectMake(0,0, height, width), selfCGImage)
            
        default:
            CGContextDrawImage(context, CGRectMake(0,0, width, height), selfCGImage)
        }
        
        let cgImage = CGBitmapContextCreateImage(context)!
        return UIImage(CGImage: cgImage)
    }
}

public extension UIImage {
    
    public func imageWithGradientTintColor(tintColor: UIColor) -> UIImage {
        
        return imageWithTintColor(tintColor, blendMode: CGBlendMode.Overlay)
    }
    
    public func imageWithTintColor(tintColor: UIColor, blendMode: CGBlendMode) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        tintColor.setFill()
        
        let bounds = CGRect(origin: CGPointZero, size: size)
        
        UIRectFill(bounds)
        
        self.drawInRect(bounds, blendMode: blendMode, alpha: 1)
        
        if blendMode != CGBlendMode.DestinationIn {
            self.drawInRect(bounds, blendMode: CGBlendMode.DestinationIn, alpha: 1)
        }
        
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return tintedImage
    }
}

// MARK: - Decode
public extension UIImage {
    
    public func decodedImage() -> UIImage {
        return decodedImage(scale: scale)
    }
    
    func decodedImage(scale scale: CGFloat) -> UIImage {
        let imageRef = CGImage
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue)
        let context = CGBitmapContextCreate(nil, CGImageGetWidth(imageRef), CGImageGetHeight(imageRef), 8, 0, colorSpace, bitmapInfo.rawValue)
        
        if let context = context {
            let rect = CGRectMake(0, 0, CGFloat(CGImageGetWidth(imageRef)), CGFloat(CGImageGetHeight(imageRef)))
            CGContextDrawImage(context, rect, imageRef)
            let decompressedImageRef = CGBitmapContextCreateImage(context)!
            
            return UIImage(CGImage: decompressedImageRef, scale: scale, orientation: imageOrientation) ?? self
        }
        
        return self
    }
}

// MARK: Resize
public extension UIImage {
    
    public func resizeToSize(size: CGSize, withTransform transform: CGAffineTransform, drawTransposed: Bool, interpolationQuality: CGInterpolationQuality) -> UIImage? {
        
        let newRect = CGRectIntegral(CGRect(origin: CGPointZero, size: size))
        let transposedRect = CGRect(origin: CGPointZero, size: CGSize(width: size.height, height: size.width))
        
        let bitmapContext = CGBitmapContextCreate(nil, Int(newRect.width), Int(newRect.height), CGImageGetBitsPerComponent(CGImage), 0, CGImageGetColorSpace(CGImage), CGImageGetBitmapInfo(CGImage).rawValue)
        
        CGContextConcatCTM(bitmapContext, transform)
        
        CGContextSetInterpolationQuality(bitmapContext, interpolationQuality)
        
        CGContextDrawImage(bitmapContext, drawTransposed ? transposedRect : newRect, CGImage)
        
        let newCGImage = CGBitmapContextCreateImage(bitmapContext)!
        let newImage = UIImage(CGImage: newCGImage)
        
        return newImage
    }
    
    public func transformForOrientationWithSize(size: CGSize) -> CGAffineTransform {
        var transform = CGAffineTransformIdentity
        
        switch imageOrientation {
        case .Down, .DownMirrored:
            transform = CGAffineTransformTranslate(transform, size.width, size.height)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI))
            
        case .Left, .LeftMirrored:
            transform = CGAffineTransformTranslate(transform, size.width, 0)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2))
            
        case .Right, .RightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, size.height)
            transform = CGAffineTransformRotate(transform, CGFloat(-M_PI_2))
            
        default:
            break
        }
        
        switch imageOrientation {
        case .UpMirrored, .DownMirrored:
            transform = CGAffineTransformTranslate(transform, size.width, 0)
            transform = CGAffineTransformScale(transform, -1, 1)
            
        case .LeftMirrored, .RightMirrored:
            transform = CGAffineTransformTranslate(transform, size.height, 0)
            transform = CGAffineTransformScale(transform, -1, 1)
            
        default:
            break
        }
        
        return transform
    }
    
    public func resizeToSize(size: CGSize, withInterpolationQuality interpolationQuality: CGInterpolationQuality) -> UIImage? {
        
        let drawTransposed: Bool
        
        switch imageOrientation {
        case .Left, .LeftMirrored, .Right, .RightMirrored:
            drawTransposed = true
        default:
            drawTransposed = false
        }
        
        return resizeToSize(size, withTransform: transformForOrientationWithSize(size), drawTransposed: drawTransposed, interpolationQuality: interpolationQuality)
    }
}

// MARK: - circleImage
public extension UIImage {
    
    public func circleImage(radius radius: CGFloat, size: CGSize) -> UIImage {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.mainScreen().scale)
        CGContextAddPath(UIGraphicsGetCurrentContext(),
                         UIBezierPath(roundedRect: rect, byRoundingCorners: UIRectCorner.AllCorners,
                            cornerRadii: CGSize(width: radius, height: radius)).CGPath)
        CGContextClip(UIGraphicsGetCurrentContext())
        
        self.drawInRect(rect)
        CGContextDrawPath(UIGraphicsGetCurrentContext(), .FillStroke)
        let output = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        return output
    }
}

// MARK: - Alpha
public extension UIImage {
    
    // Returns true if the image has an alpha layer
    public func hasAlpha() -> Bool {
        let alpha: CGImageAlphaInfo = CGImageGetAlphaInfo(self.CGImage)
        switch alpha {
        case .First, .Last, .PremultipliedFirst, .PremultipliedLast:
            return true
        default:
            return false
        }
    }
    
    // Returns a copy of the given image, adding an alpha channel if it doesn't already have one
    public func imageWithAlpha() -> UIImage {
        if self.hasAlpha() {
            return self
        }
        
        let imageRef: CGImageRef = self.CGImage!
        let width = CGImageGetWidth(imageRef)
        let height = CGImageGetHeight(imageRef)
        
        // The bitsPerComponent and bitmapInfo values are hard-coded to prevent an "unsupported parameter combination" error
        let offscreenContext: CGContextRef = CGBitmapContextCreate(nil, width, height, 8, 0, CGImageGetColorSpace(imageRef), CGImageAlphaInfo.PremultipliedFirst.rawValue)!
        
        // Draw the image into the context and retrieve the new image, which will now have an alpha layer
        let rect = CGRectMake(0, 0, CGFloat(width), CGFloat(height))
        CGContextDrawImage(offscreenContext, rect, imageRef);
        let imageRefWithAlpha: CGImageRef = CGBitmapContextCreateImage(offscreenContext)!;
        let imageWithAlpha: UIImage = UIImage(CGImage: imageRefWithAlpha)
        // Clean up
        //CGContextRelease(offscreenContext);
        //CGImageRelease(imageRefWithAlpha);
        
        return imageWithAlpha;
    }
    
    // Returns a copy of the image with a transparent border of the given size added around its edges.
    // If the image has no alpha layer, one will be added to it.
    public func transparentBorderImage(borderSize: CGFloat) -> UIImage {
        // If the image does not have an alpha layer, add one
        let image: UIImage = self.imageWithAlpha()
        
        let newRect: CGRect = CGRectMake(0, 0, image.size.width + borderSize * 2, image.size.height + borderSize * 2)
        
        // Build a context that's the same dimensions as the new size
        let bitmap: CGContextRef = CGBitmapContextCreate(nil,
                                                         Int(newRect.size.width),
                                                         Int(newRect.size.height),
                                                         CGImageGetBitsPerComponent(self.CGImage),
                                                         0,
                                                         CGImageGetColorSpace(self.CGImage),
                                                         CGImageGetBitmapInfo(self.CGImage).rawValue)!
        
        // Draw the image in the center of the context, leaving a gap around the edges
        let imageLocation: CGRect = CGRectMake(borderSize, borderSize, image.size.width, image.size.height)
        CGContextDrawImage(bitmap, imageLocation, self.CGImage)
        let borderImageRef: CGImageRef = CGBitmapContextCreateImage(bitmap)!
        
        // Create a mask to make the border transparent, and combine it with the image
        let maskImageRef: CGImageRef = self.newBorderMask(borderSize, size: newRect.size)
        let transparentBorderImageRef: CGImageRef = CGImageCreateWithMask(borderImageRef, maskImageRef)!
        let transparentBorderImage: UIImage = UIImage(CGImage: transparentBorderImageRef)
        
        // Clean up
        //CGContextRelease(bitmap);
        //CGImageRelease(borderImageRef);
        //CGImageRelease(maskImageRef);
        //CGImageRelease(transparentBorderImageRef);
        
        return transparentBorderImage;
    }
    
    // Creates a mask that makes the outer edges transparent and everything else opaque
    // The size must include the entire mask (opaque part + transparent border)
    // The caller is responsible for releasing the returned reference by calling CGImageRelease
    private func newBorderMask(borderSize: CGFloat, size: CGSize) -> CGImageRef {
        let colorSpace: CGColorSpaceRef = CGColorSpaceCreateDeviceGray()!;
        
        // Build a context that's the same dimensions as the new size
        let maskContext: CGContextRef = CGBitmapContextCreate(nil, Int(size.width), Int(size.height), 8, 0, colorSpace, CGImageAlphaInfo.PremultipliedFirst.rawValue)!
        
        // Start with a mask that's entirely transparent
        CGContextSetFillColorWithColor(maskContext, UIColor.blackColor().CGColor)
        CGContextFillRect(maskContext, CGRectMake(0, 0, size.width, size.height))
        
        // Make the inner part (within the border) opaque
        CGContextSetFillColorWithColor(maskContext, UIColor.whiteColor().CGColor)
        CGContextFillRect(maskContext, CGRectMake(borderSize, borderSize, size.width - borderSize * 2, size.height - borderSize * 2))
        
        // Get an image of the context
        let maskImageRef: CGImageRef = CGBitmapContextCreateImage(maskContext)!
        
        // Clean up
        //CGContextRelease(maskContext);
        //CGColorSpaceRelease(colorSpace);
        
        return maskImageRef;
    }
}



// MARK: - fixOrientation
public extension UIImage {
    
    public func toFixOrientation() -> UIImage {
    
        if (self.imageOrientation == .Up) {
            return self
        }
    
        var transform: CGAffineTransform = CGAffineTransformIdentity;
    
        switch (self.imageOrientation) {
        case .Down:
            fallthrough
        case .DownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI));
        break
        case .Left:
            fallthrough
        case .LeftMirrored:
        transform = CGAffineTransformTranslate(transform, self.size.width, 0);
        transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2));
        break
        
        case .Right:
            fallthrough
        case .RightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, CGFloat(-M_PI_2))
        break
        case .Up:
            fallthrough
        case .UpMirrored:
        break
        }
        
        switch (self.imageOrientation) {
        case .UpMirrored:
            fallthrough
        case .DownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
        break
        
        case .LeftMirrored:
            fallthrough
        case .RightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
        break
    //    case .Up:
    //    case .Down:
    //    case .Left:
    //    case .Right:
        default:
            break
        }
        
        let ctx: CGContextRef? = CGBitmapContextCreate(nil, Int(self.size.width), Int(self.size.height),
                                                      CGImageGetBitsPerComponent(self.CGImage), 0,
                                                      CGImageGetColorSpace(self.CGImage),
                                                      CGImageGetBitmapInfo(self.CGImage).rawValue)
        CGContextConcatCTM(ctx, transform)
        switch (self.imageOrientation) {
        case .Left:
            fallthrough
        case .LeftMirrored:
            fallthrough
        case .Right:
            fallthrough
        case .RightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage)
            break
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage)
            break
        }
    
        let cgimg: CGImageRef? = CGBitmapContextCreateImage(ctx)
        if let acgimg = cgimg{
            let img: UIImage = UIImage(CGImage: acgimg)
            return img
        }
        return self
    }
    
//    - (UIImage *)fixOrientationWithImageOrientation:(UIImageOrientation)imageOrientation {
//    // No-op if the orientation is already correct
//    if (imageOrientation == UIImageOrientationUp) return self;
//    
//    // We need to calculate the proper transformation to make the image upright.
//    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
//    CGAffineTransform transform = CGAffineTransformIdentity;
//    
//    switch (imageOrientation) {
//    case UIImageOrientationDown:
//    case UIImageOrientationDownMirrored:
//    transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
//    transform = CGAffineTransformRotate(transform, M_PI);
//    break;
//    
//    case UIImageOrientationLeft:
//    case UIImageOrientationLeftMirrored:
//    transform = CGAffineTransformTranslate(transform, self.size.width, 0);
//    transform = CGAffineTransformRotate(transform, M_PI_2);
//    break;
//    
//    case UIImageOrientationRight:
//    case UIImageOrientationRightMirrored:
//    transform = CGAffineTransformTranslate(transform, 0, self.size.height);
//    transform = CGAffineTransformRotate(transform, -M_PI_2);
//    break;
//    case UIImageOrientationUp:
//    case UIImageOrientationUpMirrored:
//    break;
//    }
//    
//    switch (imageOrientation) {
//    case UIImageOrientationUpMirrored:
//    case UIImageOrientationDownMirrored:
//    transform = CGAffineTransformTranslate(transform, self.size.width, 0);
//    transform = CGAffineTransformScale(transform, -1, 1);
//    break;
//    
//    case UIImageOrientationLeftMirrored:
//    case UIImageOrientationRightMirrored:
//    transform = CGAffineTransformTranslate(transform, self.size.height, 0);
//    transform = CGAffineTransformScale(transform, -1, 1);
//    break;
//    case UIImageOrientationUp:
//    case UIImageOrientationDown:
//    case UIImageOrientationLeft:
//    case UIImageOrientationRight:
//    break;
//    }
//    
//    CGContextRef ctx;
//    ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
//    CGImageGetBitsPerComponent(self.CGImage), 0,
//    CGImageGetColorSpace(self.CGImage),
//    CGImageGetBitmapInfo(self.CGImage));
//    // Now we draw the underlying CGImage into a new context, applying the transform
//    // calculated above.
//    
//    CGContextConcatCTM(ctx, transform);
//    switch (imageOrientation) {
//    case UIImageOrientationLeft:
//    case UIImageOrientationLeftMirrored:
//    case UIImageOrientationRight:
//    case UIImageOrientationRightMirrored:
//    // Grr...
//    CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
//    break;
//    
//    default:
//    CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
//    break;
//    }
//    
//    // And now we just create a new UIImage from the drawing context
//    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
//    UIImage *img = [UIImage imageWithCGImage:cgimg];
//    CGContextRelease(ctx);
//    CGImageRelease(cgimg);
//    return img;
//    }

    public func clip(from rect:CGRect) -> UIImage {
        let imageRef: CGImageRef? = self.toFixOrientation().CGImage
        let imageRefRect: CGImageRef? = CGImageCreateWithImageInRect(imageRef, rect)
        if let aimageRefRect = imageRefRect {
            return UIImage(CGImage: aimageRefRect)
        }else {
            return self
        }
    }
}
