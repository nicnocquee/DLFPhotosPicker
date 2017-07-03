//
//  DLFAssetsLayout.m
//  PhotosPicker
//
//  Created by  on 11/26/14.
//  Copyright (c) 2014 Delightful. All rights reserved.
//

#import "DLFAssetsLayout.h"

@implementation DLFAssetsLayout

- (void)applyPinchToLayoutAttributes:(UICollectionViewLayoutAttributes *)attributes {
    if (self.pinchedCellPath) {
        if ([attributes.indexPath isEqual:self.pinchedCellPath]) {
            attributes.transform3D = CATransform3DMakeScale(self.pinchedCellScale, self.pinchedCellScale, 1.0);
            attributes.center = self.pinchedCellCenter;
            attributes.zIndex = 1;
        }
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attr = [super layoutAttributesForItemAtIndexPath:indexPath];
    [self applyPinchToLayoutAttributes:attr];
    return attr;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    NSArray *allAttributesInRect = [super layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes *attr in allAttributesInRect) {
        [self applyPinchToLayoutAttributes:attr];
        
    }
    return allAttributesInRect;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

#pragma mark - Setters

- (void)setPinchedCellCenter:(CGPoint)pinchedCellCenter {
    _pinchedCellCenter = pinchedCellCenter;
    [self invalidateLayout];
}

- (void)setPinchedCellScale:(CGFloat)pinchedCellScale {
    _pinchedCellScale = pinchedCellScale;
    [self invalidateLayout];
}

@end
