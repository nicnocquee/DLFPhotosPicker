//
//  PhotosSelectionManager.h
//  PhotosPicker
//
//  Created by  on 11/27/14.
//  Copyright (c) 2014 Delightful. All rights reserved.
//

@import UIKit;
@import Photos;

@interface DLFPhotosSelectionView : UIView

@property (nonatomic, strong, readonly) UIButton *clearSelectionButton;

@end

@interface DLFPhotosSelectionManager : NSObject

+ (id)sharedManager;

- (void)addSelectedAsset:(PHAsset *)asset;

- (void)removeAsset:(PHAsset *)asset;

- (BOOL)containsAsset:(PHAsset *)asset;

- (int)count;

- (void)removeAllAssets;

- (NSArray *)selectedAssets;

- (void)addSelectionViewToView:(UIView *)view;

@property (nonatomic, strong, readonly) DLFPhotosSelectionView *selectedPhotosView;

@end
