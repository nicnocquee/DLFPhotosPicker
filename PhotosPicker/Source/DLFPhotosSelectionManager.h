//
//  PhotosSelectionManager.h
//  PhotosPicker
//
//  Created by  on 11/27/14.
//  Copyright (c) 2014 Delightful. All rights reserved.
//

@import UIKit;

@interface DLFPhotosSelectionView : UIView

@property (nonatomic, strong, readonly) UIButton *clearSelectionButton;

@end

@interface DLFPhotosSelectionManager : NSObject

- (id)initWithView:(UIView *)view;

- (void)addSelectedImage:(UIImage *)assetImage atIndexPath:(NSIndexPath *)indexPath;

- (void)removeAssetAtIndexPath:(NSIndexPath *)indexPath;

- (void)removeAllAssets;

@property (nonatomic, strong, readonly) DLFPhotosSelectionView *selectedPhotosView;

@end
