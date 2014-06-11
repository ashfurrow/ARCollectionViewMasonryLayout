//
//  ARCollectionViewMasonryLayout.m
//  Artsy
//
//  Created by Orta on 11/07/2013.
//  Copyright (c) 2013 Art.sy. All rights reserved.
//
//  A Forked re-write from UICollectionViewWaterfallLayout

#import "ARCollectionViewMasonryLayout.h"

@interface ARCollectionViewMasonryLayout()
@property (nonatomic, assign) enum ARCollectionViewMasonryLayoutDirection direction;

@property (nonatomic, assign) NSInteger itemCount;
@property (nonatomic, strong) NSMutableArray *internalDimensions;

@property (nonatomic, strong) NSMutableArray *itemAttributes;

// Provide quick lookups for heights
@property (nonatomic, assign) NSInteger shortestDimensionIndex;
@property (nonatomic, assign) NSInteger longestDimensionIndex;

// Provide quick lookups for min/max heights
@property (nonatomic, assign) CGFloat shortestDimensionLength;
@property (nonatomic, assign) CGFloat longestDimensionLength;

// The offset used on the non-main direction to ensure centering
@property (nonatomic, assign) CGFloat centeringOffset;

@end

@implementation ARCollectionViewMasonryLayout

- (instancetype)initWithDirection:(enum ARCollectionViewMasonryLayoutDirection)direction
{
    self = [super init];
    if (!self) return nil;

    _direction = direction;
    _rank = 2;
    _dimensionLength = 120;
    _contentInset = UIEdgeInsetsZero;
    _itemMargins = CGSizeZero;
    
    return self;
}

#pragma mark - Life cycle

- (void)dealloc
{
    [_internalDimensions removeAllObjects];
    _internalDimensions = nil;

    [_itemAttributes removeAllObjects];
    _itemAttributes = nil;
}

#pragma mark - Custom Accessors that Invalidate layout

- (void)setRank:(NSUInteger)rank
{
    if (_rank != rank) {
        _rank = rank;
        [self invalidateLayout];
    }
}

- (void)setDimensionLength:(CGFloat)dimensionLength
{
    if (_dimensionLength != dimensionLength) {
        _dimensionLength = dimensionLength;
        [self invalidateLayout];
    }
}

- (void)setContentInset:(UIEdgeInsets)contentInset
{
    if (!UIEdgeInsetsEqualToEdgeInsets(_contentInset, contentInset)) {
        _contentInset = contentInset;
        [self invalidateLayout];
    }
}

- (void)setItemMargins:(CGSize)itemMargins
{
    if (!CGSizeEqualToSize(_itemMargins, itemMargins)) {
        _itemMargins = itemMargins;
        [self invalidateLayout];
    }
}

#pragma mark - Layout

- (void)prepareLayout
{
    [super prepareLayout];

    if ([self collectionView]) {
        
        NSAssert(self.delegate != nil, @"Delegate is nil, most likely because the collection view's delegate does not conform to ARCollectionViewMasonryLayoutDelegate.");
        
        // We need to pre-load the heights and the widths from the collectionview
        // and our delegate in order to pass these through to setupLayoutWithWidth

        NSInteger itemCount = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:0];

        NSMutableArray *heights = [NSMutableArray arrayWithCapacity:itemCount];
        CGFloat dimension = [self isHorizontal]? self.collectionView.frame.size.height : self.collectionView.frame.size.width;

        // Ask delegates for all the dimensions
        for (int i = 0; i < itemCount; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];

            CGFloat length = [self.delegate collectionView:self.collectionView layout:self variableDimensionForItemAtIndexPath:indexPath];

            [heights addObject:@(length)];
        }

        [self setupLayoutWithWidth:dimension andHeights:heights];
    }
}

- (id<ARCollectionViewMasonryLayoutDelegate>)delegate
{
    id<ARCollectionViewMasonryLayoutDelegate> delegate = nil;
    if ([self.collectionView.delegate conformsToProtocol:@protocol(ARCollectionViewMasonryLayoutDelegate)]) {
        delegate = (id<ARCollectionViewMasonryLayoutDelegate>)(self.collectionView.delegate);
    }
    return delegate;
}

- (CGFloat)longestDimensionWithLengths:(NSArray *)lengths withOppositeDimension:(CGFloat)oppositeDimension
{
    [self setupLayoutWithWidth:oppositeDimension andHeights:lengths];

    if ([self isHorizontal]) {
        return  [self collectionViewContentSize].width;
    } else {
        return  [self collectionViewContentSize].height;
    }
}

- (void)setupLayoutWithWidth:(CGFloat)width andHeights:(NSArray *)lengths {
    NSAssert(_rank > 0, @"Rank for ARCollectionViewMasonryLayout should be greater than 0.");
    
    self.dimensionLength = ceilf(self.dimensionLength);
    self.itemCount = lengths.count;
    self.itemAttributes = [NSMutableArray array];
    self.internalDimensions = [NSMutableArray array];
    self.centeringOffset = [self generateCenteringOffsetWithMainDimension:width];

    BOOL isHorizontal = [self isHorizontal];
    BOOL hasContentInset = !UIEdgeInsetsEqualToEdgeInsets(self.contentInset, UIEdgeInsetsZero);
    
    CGFloat leadingInset = 0;
    CGFloat orthogonalInset = 0;
    CGFloat trailingInset = 0;

    if ([self isHorizontal]) {
        if (hasContentInset) {
            leadingInset = self.contentInset.left;
            trailingInset = self.contentInset.right;
            orthogonalInset = self.contentInset.top;
        } else {
            leadingInset = self.itemMargins.width;
            trailingInset = leadingInset;
            orthogonalInset = self.itemMargins.height;
        }
    } else {
        if (hasContentInset) {
            leadingInset = self.contentInset.top;
            orthogonalInset = self.contentInset.left;
            trailingInset = self.contentInset.bottom;
        } else {
            leadingInset = self.itemMargins.height;
            trailingInset = leadingInset;
            orthogonalInset = self.itemMargins.width;
        }
    }

    // Add an optional header.
    NSIndexPath *indexPathZero = [NSIndexPath indexPathForItem:0 inSection:0];
    CGFloat headerLength = [self headerDimensionWithIndexPath:indexPathZero];
    if (headerLength != NSNotFound) {
        [self setupHeaderWithIndexPath:indexPathZero length:headerLength];
        leadingInset += headerLength;
    }
    
    // Start all the dimensions with the content inset.
    for (NSInteger index = 0; index < self.rank; index++) {
        [self.internalDimensions addObject:@(leadingInset)];
    }
   
    // Simple rule of thumb, find the shortest column and throw
    // the current object into that.

    [lengths enumerateObjectsUsingBlock:^(NSNumber *length, NSUInteger index, BOOL *stop) {

        // Generate the new shortest & longest
        // after changes from adding the last object
        
        // TODO: this should be incremental in the loop
        [self updateLongestAndShortestDimensions];

        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        CGFloat itemAlternateDimension = ceilf([length floatValue]);
        NSUInteger columnIndex = self.shortestDimensionIndex;

        // Where would it be without any manipulation
        CGFloat edgeX = (self.dimensionLength + [self mainItemMargin]) * columnIndex;

        // Apply centering
        CGFloat xOffset = orthogonalInset + self.centeringOffset + edgeX;
        CGFloat yOffset = [self.internalDimensions[columnIndex] floatValue];

        CGPoint itemCenter = (CGPoint) {
            xOffset + (self.dimensionLength / 2),
            yOffset + (itemAlternateDimension/2)
        };

        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

        if (isHorizontal) {
            attributes.size = CGSizeMake(itemAlternateDimension, self.dimensionLength);
            itemCenter = (CGPoint){ itemCenter.y, itemCenter.x };
        } else {
            attributes.size = CGSizeMake(self.dimensionLength, itemAlternateDimension);
        }

        attributes.center = itemCenter;
        attributes.frame = CGRectIntegral(attributes.frame);
        [self.itemAttributes addObject:attributes];

        // Ensure an extra margin is not applied
        CGFloat totalDimension = yOffset + itemAlternateDimension;
        if (index != lengths.count - 1) {
            totalDimension += [self alternateItemMargin];
        }

        self.internalDimensions[columnIndex] = @( roundf (totalDimension) );
    }];

    // add the Trailing offset to the dimensions
    for (NSInteger index = 0; index < self.rank; index++) {
        self.internalDimensions[index] = @( [self.internalDimensions[index] floatValue] + trailingInset );
    }

    [self updateLongestAndShortestDimensions];

    // Add an optional footer.
    CGFloat footerLength = [self footerDimensionWithIndexPath:indexPathZero];
    if (footerLength != NSNotFound) {
        [self setupFooterWithIndexPath:indexPathZero length:footerLength];
    }
}

- (CGFloat)headerDimensionWithIndexPath:(NSIndexPath *)indexPath
{
    id<ARCollectionViewMasonryLayoutDelegate> delegate = self.delegate;
    if (delegate && [delegate respondsToSelector:@selector(collectionView:layout:dimensionForHeaderAtIndexPath:)]) {
        return [delegate collectionView:self.collectionView layout:self dimensionForHeaderAtIndexPath:indexPath];
    } else {
        return NSNotFound;
    }
}

- (CGFloat)footerDimensionWithIndexPath:(NSIndexPath *)indexPath
{
    id<ARCollectionViewMasonryLayoutDelegate> delegate = self.delegate;
    if (delegate && [delegate respondsToSelector:@selector(collectionView:layout:dimensionForFooterAtIndexPath:)]) {
        return [delegate collectionView:self.collectionView layout:self dimensionForFooterAtIndexPath:indexPath];
    } else {
        return NSNotFound;
    }
}

- (void)setupHeaderWithIndexPath:(NSIndexPath *)indexPath length:(CGFloat)headerLength
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UICollectionElementKindSectionHeader];
    
    if ([self isHorizontal]) {
        attributes.frame = CGRectMake(0, 0, headerLength, CGRectGetHeight(self.collectionView.bounds));
    } else {
        attributes.frame = CGRectMake(0, 0, CGRectGetWidth(self.collectionView.bounds), headerLength);
    }
    
    [self.itemAttributes addObject:attributes];
}

- (void)setupFooterWithIndexPath:(NSIndexPath *)indexPath length:(CGFloat)footerLength
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:indexPath];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:UICollectionElementKindSectionFooter];
    
    if ([self isHorizontal]) {
        attributes.frame = CGRectMake(self.longestDimensionLength, 0, footerLength, CGRectGetHeight(self.collectionView.bounds));
    } else {
        attributes.frame = CGRectMake(0, self.longestDimensionLength, CGRectGetWidth(self.collectionView.bounds), footerLength);
    }
    
    [self.itemAttributes addObject:attributes];
}

- (CGSize)collectionViewContentSize
{
    NSIndexPath *indexPathZero = [NSIndexPath indexPathForItem:0 inSection:0];
    CGFloat alternateDimension = 0;

    if (self.itemCount > 0) {
        // Find the last item.
        NSUInteger longestColumnIndex = self.longestDimensionIndex;
        alternateDimension = [self.internalDimensions[longestColumnIndex] floatValue];
    } else {
        // Only the header.
        CGFloat headerHeight = [self headerDimensionWithIndexPath:indexPathZero];
        if (headerHeight != NSNotFound) {
            alternateDimension += headerHeight;
        }
    }

    // Always include the footer.
    CGFloat footerHeight = [self footerDimensionWithIndexPath:indexPathZero];
    if (footerHeight != NSNotFound) {
        alternateDimension += footerHeight;
    }

    CGSize contentSize = self.collectionView.frame.size;
    if ([self isHorizontal]) {
        contentSize.width = alternateDimension;
    } else {
        contentSize.height = alternateDimension;
    }

    return contentSize;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path
{
    // This can happen during a reload, returning nil is no problem.
    if (path.row > self.itemAttributes.count - 1) return nil;
    return self.itemAttributes[path.row];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [self.itemAttributes filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return CGRectIntersectsRect(rect, [evaluatedObject frame]);
    }]];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (CGFloat)generateCenteringOffsetWithMainDimension:(CGFloat)dimension
{
    NSInteger numberOfLines = self.rank;
    CGFloat contentWidth = numberOfLines * self.dimensionLength;

    CGFloat contentMargin = [self mainItemMargin];
    contentWidth += (numberOfLines - 1) * contentMargin;

    return (dimension / 2) - (contentWidth / 2);
}

- (void)updateLongestAndShortestDimensions
{
    self.longestDimensionLength = 0;
    self.shortestDimensionLength = CGFLOAT_MAX;

    for (NSNumber *number in self.internalDimensions) {
        if (number.floatValue < self.shortestDimensionLength) {
            self.shortestDimensionLength = number.floatValue;
            self.shortestDimensionIndex = [self.internalDimensions indexOfObject:number];
        }

        if (number.floatValue > self.longestDimensionLength) {
            self.longestDimensionLength = number.floatValue;
            self.longestDimensionIndex = [self.internalDimensions indexOfObject:number];
        }
    }
}

- (BOOL)isHorizontal
{
    return (self.direction == ARCollectionViewMasonryLayoutDirectionHorizontal);
}

/// When vertical this is the horizontal item margin, when
/// horizontal its the vertical

- (CGFloat)mainItemMargin
{
    return (self.isHorizontal) ? self.itemMargins.height : self.itemMargins.height;
}

/// The opposite of above, the space vertically when in vertical mode

- (CGFloat)alternateItemMargin
{
    return (self.isHorizontal) ? self.itemMargins.width : self.itemMargins.height;
}

@end
