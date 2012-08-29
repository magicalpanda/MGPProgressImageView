//
//  MGPViewController.m
//  Grayscale View Test
//
//  Created by Saul Mora on 8/28/12.
//  Copyright (c) 2012 Magical Panda Software. All rights reserved.
//

#import "MGPViewController.h"
#import "MGPProgressImageView.h"

@interface MGPViewController ()

@property IBOutlet UISegmentedControl *directionSegment;
@property IBOutlet UISlider *progressSlider;

@property IBOutlet MGPProgressImageView *progressImageView;

@end


@implementation MGPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    self.progressImageView.image = [UIImage imageNamed:@"MagicalPanda"];
    [self directionChanged:self.directionSegment];
    [self progressChanged:self.progressSlider];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) progressChanged:(id)sender;
{
    UISlider *slider = (UISlider *)sender;
    self.progressImageView.progress = slider.value;
}

- (IBAction) directionChanged:(id)sender;
{
    UISegmentedControl *segmentControl = (UISegmentedControl *)sender;
    self.progressImageView.direction =    segmentControl.selectedSegmentIndex + 1;
}
@end
