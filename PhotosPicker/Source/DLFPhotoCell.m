//
//  DLFPhotoCell.m
//  PhotosPicker
//
//  Created by  on 11/26/14.
//  Copyright (c) 2014 Delightful. All rights reserved.
//

#import "DLFPhotoCell.h"

@interface DLFPhotoCell ()

@property (nonatomic, weak) UIView *highlightedView;

@end

@implementation DLFPhotoCell

- (void)setThumbnailImage:(UIImage *)thumbnailImage {
    if (_thumbnailImage != thumbnailImage) {
        _thumbnailImage = thumbnailImage;
        self.imageView.image = thumbnailImage;
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    if (!self.highlightedView) {
        UIView *view = [[UIView alloc] initWithFrame:self.imageView.frame];
        [view setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.5]];
        [view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [view.layer setBorderColor:[UIColor redColor].CGColor];
        [view.layer setBorderWidth:5];
        view.hidden = YES;
        [self.contentView addSubview:view];
        self.highlightedView = view;
    }
    [self.highlightedView setHidden:!highlighted];
}

@end
