//
//  SampleViewController.h
//  PhotosPicker
//
//  Created by  on 11/28/14.
//  Copyright (c) 2014 Delightful. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SampleViewController : UIViewController

@property (weak) IBOutlet UISegmentedControl *selectionTypeSelector;
@property (weak) IBOutlet UIScrollView *scrollView;

- (IBAction)didTapPickPhotos:(id)sender;

@end
