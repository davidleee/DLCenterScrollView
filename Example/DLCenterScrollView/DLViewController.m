//
//  DLViewController.m
//  DLCenterScrollView
//
//  Created by Lee9272 on 08/04/2015.
//  Copyright (c) 2015 Lee9272. All rights reserved.
//

#import "DLViewController.h"
#import <DLCenterScrollView/DLCenterHorizontalScrollView.h>

@interface DLViewController () <DLCenterHorizontalScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet DLCenterHorizontalScrollView *dateSelector;
@end

@implementation DLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.dateSelector.delegate = self;
    [self.dateSelector reloadViewWithItems:@[@"", @"", @"", @"", @"", @"", @""]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)reloadAction:(id)sender
{
    self.dateLabel.text = @"0";
    [self.dateSelector reloadView];
}

- (void)scrollView:(DLCenterScrollView *)scrollView didTapItemAtIndex:(int)index
{
    self.dateLabel.text = [NSString stringWithFormat:@"%d", index];
}

@end
