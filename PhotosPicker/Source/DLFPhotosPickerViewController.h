//
//  DLFPhotosPickerViewController.h
//  PhotosPicker
//
//  Created by  on 11/28/14.
//  Copyright (c) 2014 Delightful. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Photos;

@class DLFPhotoCell;
@class DLFPhotosPickerViewController;
@class DLFDetailViewController;

@protocol DLFPhotosPickerViewControllerDelegate <NSObject>

@optional
- (void)photosPicker:(DLFPhotosPickerViewController *)photosPicker detailViewController:(DLFDetailViewController *)detailViewController didSelectPhotos:(NSArray *)photos;
- (void)photosPickerDidCancel:(DLFPhotosPickerViewController *)photosPicker;
- (void)photosPicker:(DLFPhotosPickerViewController *)photosPicker detailViewController:(DLFDetailViewController *)detailViewController  configureCell:(DLFPhotoCell *)cell indexPath:(NSIndexPath *)indexPath asset:(PHAsset *)asset;

@end

@interface DLFPhotosPickerViewController : UISplitViewController <UISplitViewControllerDelegate>

@property (nonatomic, weak) id<DLFPhotosPickerViewControllerDelegate> photosPickerDelegate;

@end
