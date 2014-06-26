//
//  ARCollectionViewMasonryLayout.h
//  Artsy
//
//  Created by Orta on 11/07/2013.
//  Copyright (c) 2013 Art.sy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ARCollectionViewMasonryLayout;

@protocol ARCollectionViewMasonryLayoutDelegate <UICollectionViewDelegateFlowLayout>

/// If you have a vertical direction then this is the height
/// and width for horizontal.

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(ARCollectionViewMasonryLayout *)collectionViewLayout variableDimensionForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

typedef NS_ENUM(NSInteger, ARCollectionViewMasonryLayoutDirection){
    ARCollectionViewMasonryLayoutDirectionVertical,
    ARCollectionViewMasonryLayoutDirectionHorizontal
};

/// The ARCollectionViewMasonryLayout is a collectionview layout that can
/// lay out items in a horizontal or vertical layout in a way that flows all
/// the content edge to edge in lines

@interface ARCollectionViewMasonryLayout : UICollectionViewFlowLayout

/// Create a layout with a direction
- (instancetype)initWithDirection:(enum ARCollectionViewMasonryLayoutDirection)direction;

- (instancetype)init __attribute__((unavailable("Invoke the designated initializer initWithDirection: instead.")));

/// Direction of the collection view layout. Set in the initializer. 
@property (nonatomic, readonly) enum ARCollectionViewMasonryLayoutDirection direction;

/// How many columns when vertical or rows when horizontal.
/// defaults to 2.
@property (nonatomic, assign) NSUInteger rank;

/// Width for every column when horizontal, or row when vertical,
@property (nonatomic, assign) CGFloat dimensionLength;

/// The margins used that can be used of offset content
/// without this content will be centered veritcally, or horizontally.
@property (nonatomic, assign) UIEdgeInsets contentInset;

/// The margins between items and between lines of items
@property (nonatomic, assign) CGSize itemMargins;

/// Use this function to use the same layouting engine but
/// without needing to have a collectionview. Useful for
/// getting dimensions in advance for tableview cells.
- (CGFloat)longestDimensionWithLengths:(NSArray *)variableDimensions withOppositeDimension:(CGFloat)staticDimension;

@end
