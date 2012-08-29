//
//  TBGrayscaleProgressImageView.m
//  TREEbook
//
//  Created by Saul Mora on 8/28/12.
//  Copyright (c) 2012 Magical Panda Software, LLC. All rights reserved.
//

#import "MGPProgressImageView.h"
#import <QuartzCore/QuartzCore.h>

@interface UIImage (MagicalPandaAdditions)

- (UIImage *) mgp_greyscaleImage;

@end

@interface MGPProgressImageView ()

@property (nonatomic, strong) CALayer *grayImageLayer;
@property (nonatomic, strong) CALayer *imageLayer;

@end


@implementation MGPProgressImageView

- (void) awakeFromNib;
{
    self.autoresizesSubviews = NO;
    self.direction = MGPGrayscaleProgressDirectionBottomToTop;
    self.progress = 0;
}

- (void) setImage:(UIImage *)image;
{
    [super setImage:image];

    if (self.grayImageLayer == nil)
    {
        CALayer *imageLayer = [CALayer layer];
        imageLayer.frame = self.bounds;
        imageLayer.contents = (id)[image mgp_greyscaleImage].CGImage;
        imageLayer.contentsGravity = kCAGravityResizeAspect;
        imageLayer.backgroundColor = [UIColor clearColor].CGColor;
        imageLayer.opaque = YES;
        self.imageLayer = imageLayer;

        CALayer *containerLayer = [CALayer layer];

        containerLayer.anchorPoint = CGPointZero;
        containerLayer.masksToBounds = YES;
        containerLayer.frame = self.layer.bounds;
        [containerLayer addSublayer:imageLayer];
        [self.layer addSublayer:containerLayer];

        self.grayImageLayer = containerLayer;
    }
}

- (CGPoint) anchorPointForDirection:(MGPProgressImageViewDirection)direction;
{
    CGPoint anchorPoint = CGPointZero;
    switch (self.direction)
    {
        case MGPGrayscaleProgressDirectionRightToLeft:
        {
            anchorPoint = CGPointMake(1.0, 0);
            break;
        }
        case MGPGrayscaleProgressDirectionTopToBottom:
        {
            anchorPoint = CGPointMake(0, 1.0);
            break;
        }
        case MGPGrayscaleProgressDirectionLeftToRight:
        case MGPGrayscaleProgressDirectionBottomToTop:
        case MGPGrayscaleProgressDirectionUnknown:
        default:
            break;
    }
    return anchorPoint;
}

- (CGRect) frameForProgress:(CGFloat)progress inDirection:(MGPProgressImageViewDirection)direction;
{
    CGRect frame = self.bounds;
    switch (direction)
    {
        case MGPGrayscaleProgressDirectionLeftToRight:
        {
            frame.size.width *= progress;
            break;
        }
        case MGPGrayscaleProgressDirectionBottomToTop:
        {
            frame.size.height *= progress;
            break;
        }
        case MGPGrayscaleProgressDirectionRightToLeft:
        {
            frame.size.width *= progress;
            frame.origin.y = 0;
            frame.origin.x = self.bounds.size.width - frame.size.width;
            break;
        }
        case MGPGrayscaleProgressDirectionTopToBottom:
        {
            frame.size.height *= progress;
            frame.origin.x = 0;
            frame.origin.y = self.bounds.size.height - frame.size.height;
            break;
        }
        case MGPGrayscaleProgressDirectionUnknown:
        default:
            break;
    }

    //    NSLog(@"Rect: %@", NSStringFromCGRect(frame));

    return frame;
}

- (CGRect) imageFrameForParentRect:(CGRect)contentFrame inDirection:(MGPProgressImageViewDirection)direction;
{
    CGRect frame = self.bounds;
    switch (direction)
    {
        case MGPGrayscaleProgressDirectionRightToLeft:
        {
            frame.origin.x -= contentFrame.origin.x;
            break;
        }
        case MGPGrayscaleProgressDirectionTopToBottom:
        {
            frame.origin.y -= contentFrame.origin.y;
            break;
        }
        case MGPGrayscaleProgressDirectionLeftToRight:
        case MGPGrayscaleProgressDirectionBottomToTop:
        default:
            break;
    }
    return frame;
}

- (void) renderCurrentProgressAndDirection;
{
    if (self.progress > 0)
    {
        if ([self.grayImageLayer superlayer] == nil)
        {
            [self.layer addSublayer:self.grayImageLayer];
        }
    }

    self.grayImageLayer.anchorPoint = [self anchorPointForDirection:self.direction];
    CGRect contentFrame = [self frameForProgress:(1.0 - self.progress) inDirection:self.direction];
    self.grayImageLayer.frame = contentFrame;
    self.imageLayer.frame = [self imageFrameForParentRect:contentFrame inDirection:self.direction];

    if (_progress == 1.0)
    {
        [self.grayImageLayer removeFromSuperlayer];
    }
}

- (void) setDirection:(MGPProgressImageViewDirection)direction;
{
    [self willChangeValueForKey:@"direction"];
    _direction = direction;
    [self didChangeValueForKey:@"direction"];

    [self renderCurrentProgressAndDirection];
}

- (void) setProgress:(CGFloat)progress;
{
    NSAssert(0 <= progress, @"Progress cannot be less than 0");
    NSAssert(progress <= 1, @"Progress cannot be greater than 1");
    
    [self willChangeValueForKey:@"progress"];
    _progress = progress;
    [self didChangeValueForKey:@"progress"];

    [self renderCurrentProgressAndDirection];
}

@end


@implementation UIImage (MagicalPandaAdditions)

- (UIImage *) mgp_greyscaleImage;
{
    UIImage *inputImage = self;

    UIGraphicsBeginImageContextWithOptions(inputImage.size, YES, 1.0);
    CGRect imageRect = CGRectMake(0, 0, inputImage.size.width, inputImage.size.height);
    
    [inputImage drawInRect:imageRect blendMode:kCGBlendModeLuminosity alpha:1.0];
    
    UIImage *filteredImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return filteredImage;
}

@end