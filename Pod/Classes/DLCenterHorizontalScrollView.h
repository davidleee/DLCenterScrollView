//
//  DLCenterHorizontalScrollView.h
//  DLCenterHorizontalScrollView
//
//  Created by Lee on 1/4/15.
//  Copyright (c) 2015 Scau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLScrollItemView.h"

@class DLCenterHorizontalScrollView;
@protocol DLCenterHorizontalScrollViewDelegate <NSObject>

- (void)scrollView:(DLCenterHorizontalScrollView *)scrollView didTapItemAtIndex:(int)index;

@end

@interface DLCenterHorizontalScrollView : UIView
@property (nonatomic, weak) id<DLCenterHorizontalScrollViewDelegate> delegate;

- (void)reloadView;
- (void)reloadViewWithItems:(NSArray *)items;
- (void)selectItemAtIndex:(int)index;
@end
