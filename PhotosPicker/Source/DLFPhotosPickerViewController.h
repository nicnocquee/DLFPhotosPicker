//
//  DLFPhotosPickerViewController.h
//  PhotosPicker
//
//  Created by  on 11/28/14.
//  Copyright (c) 2014 Delightful. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DLFPhotosPickerViewController;

@protocol DLFPhotosPickerViewControllerDelegate <NSObject>

@optional
- (void)photosPicker:(DLFPhotosPickerViewController *)photosPicker didSelectPhotos:(NSArray *)photos;
- (void)photosPickerDidCancel:(DLFPhotosPickerViewController *)photosPicker;

@end

@interface DLFPhotosPickerViewController : UISplitViewController <UISplitViewControllerDelegate>

@property (nonatomic, weak) id<DLFPhotosPickerViewControllerDelegate> photosPickerDelegate;

@end
