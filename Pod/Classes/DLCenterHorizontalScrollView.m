//
//  DLCenterHorizontalScrollView.m
//  DLCenterHorizontalScrollView
//
//  Created by Lee on 1/4/15.
//  Copyright (c) 2015 Scau. All rights reserved.
//

#import "DLCenterHorizontalScrollView.h"

#define kTagOffset 1000

@interface DLCenterHorizontalScrollView() <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *scrollItems;
@property (nonatomic, assign) CGRect selectedViewFrame;
@property (nonatomic, assign) CGFloat distance;
@end

@implementation DLCenterHorizontalScrollView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupViews];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    self.clipsToBounds = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapInView:)];
    [self addGestureRecognizer:tap];
    
    [self setupScrollView];
}

- (void)setupScrollView
{
    self.scrollView = [UIScrollView new];
    self.scrollView.delegate = self;
    self.scrollView.clipsToBounds = NO;
    self.scrollView.backgroundColor = [UIColor darkGrayColor];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.scrollView];
    
    NSDictionary *views = @{@"scrollView" : self.scrollView};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[scrollView]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|" options:0 metrics:nil views:views]];
}

- (void)reloadView
{
    [self reloadViewWithItems:[self.scrollItems copy]];
}

- (void)reloadViewWithItems:(NSArray *)items
{
    if (![items count]) {
        return;
    }
    
    [[self.scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)]; // ???: Synchronously? Asynchronously?
    self.scrollItems = [[NSMutableArray alloc] initWithArray:items];
    
    DLScrollItemView *previousView;
    for (int i = 0; i < [items count]; i++) {
        DLScrollItemView *currentView = [[DLScrollItemView alloc] init];
        currentView.tag = kTagOffset + i;
        currentView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.scrollView addSubview:currentView];
        
        // current view height = current view width = scroll view height
        [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeHeight relatedBy:0 toItem:self.scrollView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
        [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeWidth relatedBy:0 toItem:self.scrollView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
        [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeCenterY relatedBy:0 toItem:self.scrollView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        if (i > 0) {
            // [previousView][currentView]
            [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:currentView
                                                                        attribute:NSLayoutAttributeLeading
                                                                        relatedBy:0
                                                                           toItem:previousView
                                                                        attribute:NSLayoutAttributeTrailing
                                                                       multiplier:1
                                                                         constant:0]];
        } else {
            // |[currentView]
            [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:currentView
                                                                        attribute:NSLayoutAttributeLeading
                                                                        relatedBy:0
                                                                           toItem:self.scrollView
                                                                        attribute:NSLayoutAttributeLeading
                                                                       multiplier:1
                                                                         constant:0]];
        }
        
        previousView = currentView;
    }
    // [currentView]|
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:previousView
                                                                attribute:NSLayoutAttributeTrailing
                                                                relatedBy:0
                                                                   toItem:self.scrollView
                                                                attribute:NSLayoutAttributeTrailing
                                                               multiplier:1
                                                                 constant:0]];
    
    [self selectItemAtIndex:0];
}

- (void)selectItemAtIndex:(int)index
{
    if (index >= [self.scrollItems count] || index < 0) {
        NSLog(@"[%@-%@] Invalid Index!", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        return;
    }
    
    NSArray *subviews = [self.scrollView subviews];
    for (UIView *v in subviews) {
        if ([v isKindOfClass:[DLScrollItemView class]]) {
            DLScrollItemView *itemView = (DLScrollItemView *)v;
            int tagOffset = (int)(itemView.tag - kTagOffset - index);
            itemView.alpha = 1 - (0.1 * abs(tagOffset));
            if (itemView.tag == index + kTagOffset) {
                itemView.selected = YES;
                self.selectedViewFrame = itemView.frame;
            } else {
                itemView.selected = NO;
            }
        }
    }
    
    [self centerlizeSelectedViewIfNeeded];
}

- (void)tapInView:(UITapGestureRecognizer *)tap
{
    CGPoint locationInView = [tap locationInView:self];
    CGFloat xOffset = locationInView.x + self.scrollView.contentOffset.x;
    int itemIndex = xOffset / self.scrollView.frame.size.height;
    [self selectItemAtIndex:itemIndex];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollView:didTapItemAtIndex:)]) {
        [self.delegate scrollView:self didTapItemAtIndex:itemIndex];
    }
}

- (void)centerlizeSelectedViewIfNeeded
{
    CGFloat centerX = self.scrollView.frame.size.width / 2 - (self.scrollView.frame.size.height * kSelectedXScale) / 2;
    CGFloat distance = self.selectedViewFrame.origin.x - centerX;
    [self.scrollView setContentOffset:CGPointMake(distance, 0) animated:YES];
    self.distance = distance;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    CGFloat leftEdge = 0;
    CGFloat rightEdge = self.scrollView.contentSize.width - self.scrollView.frame.size.width;
    
    if (self.distance <= leftEdge) {
        [self.scrollView setContentInset:UIEdgeInsetsMake(0, -self.distance, 0, 0)];
    } else if (self.distance > rightEdge){
        [self.scrollView setContentInset:UIEdgeInsetsMake(0, 0, 0, self.distance - rightEdge)];
    } else {
        [self.scrollView setContentInset:UIEdgeInsetsZero];
    }
}

@end
