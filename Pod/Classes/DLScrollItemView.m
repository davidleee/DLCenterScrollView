//
//  DLScrollItemView.m
//  DLCenterHorizontalScrollView
//
//  Created by Lee on 1/4/15.
//  Copyright (c) 2015 Scau. All rights reserved.
//

#import "DLScrollItemView.h"

@implementation DLScrollItemView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    if (selected) {
        [UIView animateWithDuration:0.1f animations:^{
            self.transform = CGAffineTransformMakeScale(kSelectedXScale, kSelectedYScale);
        }];
    } else {
        [UIView animateWithDuration:0.1f animations:^{
            self.transform = CGAffineTransformIdentity;
        }];
    }
}

@end
