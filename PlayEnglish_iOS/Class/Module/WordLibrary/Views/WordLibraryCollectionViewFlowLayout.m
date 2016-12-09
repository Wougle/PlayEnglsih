//
//  WordLibraryCollectionViewFlowLayout.m
//  PlayEnglish_iOS
//
//  Created by KentonYu on 16/10/15.
//  Copyright © 2016年 DMT. All rights reserved.
//

#import "WordLibraryCollectionViewFlowLayout.h"

static CGFloat const ETKSearchETKHelpCollectionViewFlowLayoutItemHRate = 0.45f;

@implementation WordLibraryCollectionViewFlowLayout

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    CGFloat itemH = self.collectionView.height * ETKSearchETKHelpCollectionViewFlowLayoutItemHRate;
    CGFloat itemW = itemH * 0.95f;
    self.itemSize = CGSizeMake(itemW, itemH);
    
    // 设置内边距
    CGFloat insetX    = (self.collectionView.width - itemW) / 2.f;
    CGFloat insetY    = (self.collectionView.height - itemH) / 2.f;
    self.sectionInset = UIEdgeInsetsMake(insetY, insetX, insetY, insetX);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *array = [[super layoutAttributesForElementsInRect:rect] copy];
    
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    for (UICollectionViewLayoutAttributes *attrs in array) {
        CGFloat delta = ABS(centerX - attrs.center.x);
        // 利用差距计算出缩放比例（成反比）
        CGFloat scale   = 1.0f - delta / (self.collectionView.frame.size.width + self.itemSize.width);
        attrs.transform = CGAffineTransformMakeScale(scale, scale);
    }
    
    return array;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    // 计算最终的可见范围
    CGRect rect;
    rect.origin = proposedContentOffset;
    rect.size   = self.collectionView.frame.size;
    
    NSArray *array = [[super layoutAttributesForElementsInRect:rect] copy];
    
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width / 2.f;
    
    CGFloat minDetal = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attrs in array) {
        if (ABS(minDetal) > ABS(attrs.center.x - centerX)) {
            minDetal = attrs.center.x - centerX;
        }
    }
    
    CGFloat offsetX = proposedContentOffset.x + minDetal;
    offsetX         = offsetX < 0 ? 0 : offsetX;
    offsetX         = offsetX > self.collectionView.contentSize.width ? self.collectionView.contentSize.width : offsetX;
    
    // 在原有offset的基础上进行微调
    return CGPointMake(offsetX, proposedContentOffset.y);
}


@end
