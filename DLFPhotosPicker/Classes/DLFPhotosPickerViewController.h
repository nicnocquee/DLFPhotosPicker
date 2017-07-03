//
//  DLFPhotosPickerViewController.h
//  PhotosPicker
//
//  Created by  on 11/28/14.
//  Copyright (c) 2014 Delightful. All rights reserved.
//

#import <UIKit/UIKit.h>

@import Photos;
@class DLFDetailViewController;
@class DLFMasterViewController;
@class DLFPhotoCell;
@class DLFPhotosPickerViewController;

@protocol DLFPhotosPickerViewControllerDelegate <NSObject>

@optional
/**
 *  This method is called when `multipleSelections` is NO.
 *
 *  @param photosPicker         Instance of Photos Picker
 *  @param detailViewController Detail View Controller that shows the photos
 *  @param photo                Selected Photo
 */
- (void)photosPicker:(DLFPhotosPickerViewController *)photosPicker detailViewController:(DLFDetailViewController *)detailViewController didSelectPhoto:(PHAsset *)photo;

/**
 *  This method is called when `multipleSelections` is YES.
 *
 *  @param photosPicker         Instance of Photos Picker
 *  @param detailViewController Detail View Controller that shows the photos
 *  @param photos               Selected Photos
 */
- (void)photosPicker:(DLFPhotosPickerViewController *)photosPicker detailViewController:(DLFDetailViewController *)detailViewController didSelectPhotos:(NSArray *)photos;

/**
 *  This method is called when user taps Cancel button
 *
 *  @param photosPicker Instance of Photos Picker
 */
- (void)photosPickerDidCancel:(DLFPhotosPickerViewController *)photosPicker;

/**
 *  Implement this method if you want to customize the cell showing the asset.
 *
 *  @param photosPicker         Instance of photos picker
 *  @param detailViewController Instance of detail view controller which is showing the assets
 *  @param cell                 Cell you want to customize
 *  @param indexPath            Index path of this cell
 *  @param asset                Asset of this cell
 */
- (void)photosPicker:(DLFPhotosPickerViewController *)photosPicker detailViewController:(DLFDetailViewController *)detailViewController  configureCell:(DLFPhotoCell *)cell indexPath:(NSIndexPath *)indexPath asset:(PHAsset *)asset;

@end

/**
 *  DLFPhotosPickerViewController is Photos picker for iOS using iOS 8 Photos framework. It uses UISplitViewController to show assets and albums. Check https://github.com/nicnocquee/DLFPhotosPicker for more information.
 */

@interface DLFPhotosPickerViewController : UIViewController <UISplitViewControllerDelegate>

/**
 *  The split view controller that is used to show the assets and albums. View controller that is used to show assets is instance of DLFDetailViewController class. View controller that is used to show albums is instance of DLFMasterViewController class.
 */
@property (nonatomic, strong, readonly) UISplitViewController *splitVC;

/**
 *  See DLFPhotosPickerViewControllerDelegate.
 */
@property (nonatomic, weak) id<DLFPhotosPickerViewControllerDelegate> photosPickerDelegate;

/**
 *  Set to NO to disable multiple selections. Default YES.
 */
@property (nonatomic, assign) BOOL multipleSelections;

@end
