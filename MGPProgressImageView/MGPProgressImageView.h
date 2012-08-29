//
//  MGPGrayscaleProgressImageView.h
//  TREEbook
//
//  Created by Saul Mora on 8/28/12.
//  Copyright (c) 2012 Magical Panda Software, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    MGPGrayscaleProgressDirectionUnknown         =       0,
    MGPGrayscaleProgressDirectionLeftToRight     =       1,
    MGPGrayscaleProgressDirectionRightToLeft     =       2,
    MGPGrayscaleProgressDirectionTopToBottom     =       3,
    MGPGrayscaleProgressDirectionBottomToTop     =       4
} MGPProgressImageViewDirection;

@interface MGPProgressImageView : UIImageView

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) MGPProgressImageViewDirection direction;

@end
