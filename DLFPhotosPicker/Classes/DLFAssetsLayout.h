//
//  DLFAssetsLayout.h
//  PhotosPicker
//
//  Created by  on 11/26/14.
//  Copyright (c) 2014 Delightful. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DLFAssetsLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) CGFloat pinchedCellScale;
@property (nonatomic, assign) CGPoint pinchedCellCenter;
@property (nonatomic, strong) NSIndexPath *pinchedCellPath;

@end
