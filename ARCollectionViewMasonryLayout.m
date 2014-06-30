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
@property (nonatomic, strong) UICollectionViewLayoutAttributes *headerAttributes;
@property (nonatomic, strong) UICollectionViewLayoutAttributes *footerAttributes;

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

        NSMutableArray *variableDimensions = [NSMutableArray arrayWithCapacity:itemCount];
        CGFloat staticDimension = [self isHorizontal]? self.collectionView.frame.size.height : self.collectionView.frame.size.width;

        // Ask delegates for all the dimensions
        for (int i = 0; i < itemCount; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];

            CGFloat variableDimension = [self.delegate collectionView:self.collectionView layout:self variableDimensionForItemAtIndexPath:indexPath];

            [variableDimensions addObject:@(variableDimension)];
        }

        [self setupLayoutWithStaticDimension:staticDimension andVariableDimensions:variableDimensions];
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

- (CGFloat)longestDimensionWithLengths:(NSArray *)variableDimensions withOppositeDimension:(CGFloat)staticDimension;
{
    if ([self collectionView]) {
        [self setupLayoutWithStaticDimension:staticDimension andVariableDimensions:variableDimensions];
    }
    
    if ([self isHorizontal]) {
        return  [self collectionViewContentSize].width;
    } else {
        return  [self collectionViewContentSize].height;
    }
}

- (void)setupLayoutWithStaticDimension:(CGFloat)staticDimension andVariableDimensions:(NSArray *)variableDimensions
{
    NSAssert(_rank > 0, @"Rank for ARCollectionViewMasonryLayout should be greater than 0.");
    NSAssert(self.collectionView.numberOfSections == 1, @"ARCollectionViewmMasonry doesn't support multiple sections.");
    self.dimensionLength = ceilf(self.dimensionLength);
    self.itemCount = variableDimensions.count;
    self.itemAttributes = [NSMutableArray array];
    self.internalDimensions = [NSMutableArray array];
    self.centeringOffset = [self generateCenteringOffsetWithMainDimension:staticDimension];

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
    CGFloat headerDimension = [self headerDimensionAtIndexPath:indexPathZero];
    if (headerDimension != NSNotFound) {
        [self setupHeaderAtIndexPath:indexPathZero];
        leadingInset += headerDimension;
    }
    
    // Start all the dimensions with the content inset.
    for (NSInteger index = 0; index < self.rank; index++) {
        [self.internalDimensions addObject:@(leadingInset)];
    }
   
    // Simple rule of thumb, find the shortest column and throw
    // the current object into that.

    [variableDimensions enumerateObjectsUsingBlock:^(NSNumber *dimension, NSUInteger index, BOOL *stop) {

        // Generate the new shortest & longest
        // after changes from adding the last object
        
        // TODO: this should be incremental in the loop
        [self updateLongestAndShortestDimensions];

        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        CGFloat itemAlternateDimension = ceilf([dimension floatValue]);
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
        if (index != variableDimensions.count - 1) {
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
    CGFloat footerLength = [self footerDimensionAtIndexPath:indexPathZero];
    if (footerLength != NSNotFound) {
        [self setupFooterAtIndexPath:indexPathZero];
    }
}

- (CGFloat)headerDimensionAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = [self headerSizeAtIndexPath:indexPath];
    if (CGSizeEqualToSize(size, CGSizeZero)) { return NSNotFound; }

    if ([self isHorizontal]) {
        return size.width;
    } else {
        return size.height;
    }
}

- (CGFloat)footerDimensionAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = [self footerSizeAtIndexPath:indexPath];
    if (CGSizeEqualToSize(size, CGSizeZero)) { return NSNotFound; }

    if ([self isHorizontal]) {
        return size.width;
    } else {
        return size.height;
    }
}

- (CGSize)headerSizeAtIndexPath:(NSIndexPath *)indexPath
{
    id<UICollectionViewDelegateFlowLayout> delegate = self.delegate;
    CGSize size = CGSizeZero;

    if (delegate && [delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
        size = [delegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:indexPath.section];
    }

    return size;
}

- (CGSize)footerSizeAtIndexPath:(NSIndexPath *)indexPath
{
    id<UICollectionViewDelegateFlowLayout> delegate = self.delegate;
    CGSize size = CGSizeZero;

    if (delegate && [delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
        size = [delegate collectionView:self.collectionView layout:self referenceSizeForFooterInSection:indexPath.section];
    }

    return size;
}

- (void)setupHeaderAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
;
    CGSize size = [self headerSizeAtIndexPath:indexPath];
    if ([self isHorizontal]) {
        attributes.frame = CGRectMake(0, 0, size.width, CGRectGetHeight(self.collectionView.bounds));
    } else {
        attributes.frame = CGRectMake(0, 0, CGRectGetWidth(self.collectionView.bounds), size.height);
    }

    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UICollectionElementKindSectionHeader];
    self.headerAttributes = attributes;
}

- (void)setupFooterAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:indexPath];

    CGSize size = [self footerSizeAtIndexPath:indexPath];
    CGFloat longestDimension = [self.internalDimensions[self.longestDimensionIndex] floatValue];
    if ([self isHorizontal]) {
        attributes.frame = CGRectMake(longestDimension, 0, size.width, CGRectGetHeight(self.collectionView.bounds));
    } else {
        attributes.frame = CGRectMake(0, longestDimension, CGRectGetWidth(self.collectionView.bounds), size.height);
    }

    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:UICollectionElementKindSectionFooter];
    self.footerAttributes = attributes;
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
        CGFloat headerHeight = [self headerDimensionAtIndexPath:indexPathZero];
        if (headerHeight != NSNotFound) {
            alternateDimension += headerHeight;
        }
    }

    // Always include the footer.
    CGFloat footerHeight = [self footerDimensionAtIndexPath:indexPathZero];
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
    NSArray *attributes = self.itemAttributes;
    if (self.headerAttributes) {
        attributes = [attributes arrayByAddingObject:self.headerAttributes];
    }
    if (self.footerAttributes) {
        attributes = [attributes arrayByAddingObject:self.footerAttributes];
    }

    return [attributes filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return CGRectIntersectsRect(rect, [evaluatedObject frame]);
    }]];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        return self.headerAttributes;
    } else if (kind == UICollectionElementKindSectionFooter) {
        return self.footerAttributes;
    } else {
        return nil;
    }
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
    return (self.isHorizontal) ? self.itemMargins.height : self.itemMargins.width;
}

/// The opposite of above, the space vertically when in vertical mode

- (CGFloat)alternateItemMargin
{
    return (self.isHorizontal) ? self.itemMargins.width : self.itemMargins.height;
}

@end
