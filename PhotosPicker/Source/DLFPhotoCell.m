//
//  DLFPhotoCell.m
//  PhotosPicker
//
//  Created by  on 11/26/14.
//  Copyright (c) 2014 Delightful. All rights reserved.
//

#import "DLFPhotoCell.h"

@interface DLFPhotoCell ()
@property (strong) IBOutlet UIImageView *imageView;
@end

@implementation DLFPhotoCell

- (void)setThumbnailImage:(UIImage *)thumbnailImage {
    _thumbnailImage = thumbnailImage;
    self.imageView.image = thumbnailImage;
}


@end
