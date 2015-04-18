#import "_ARCollectionViewMasonryAttributesGrid.h"

@interface _ARCollectionViewMasonryAttributesGrid ()
@property (nonatomic, readonly, strong) NSArray *sections;
@property (nonatomic, assign) NSUInteger shortestSection;
@property (nonatomic, assign) CGFloat shortestSectionDimension;
@property (nonatomic, assign) CGFloat longestSectionDimension;
@end

@implementation _ARCollectionViewMasonryAttributesGrid

- (instancetype)initWithSectionCount:(NSUInteger)sectionCount
                           direction:(ARCollectionViewMasonryLayoutDirection)direction
                        leadingInset:(CGFloat)leadingInset
                     orthogonalInset:(CGFloat)orthogonalInset
                      mainItemMargin:(CGFloat)mainItemMargin
                 alternateItemMargin:(CGFloat)alternateItemMargin
                     centeringOffset:(CGFloat)centeringOffset;
{
    if ((self = [super init])) {
        _direction = direction;
        _leadingInset = leadingInset;
        _orthogonalInset = orthogonalInset;
        _mainItemMargin = mainItemMargin;
        _alternateItemMargin = alternateItemMargin;
        _centeringOffset = centeringOffset;
        _sectionCount = sectionCount;
        _shortestSection = 0;
        _longestSectionDimension = 0;
        _shortestSectionDimension = 0;

        NSMutableArray *sections = [NSMutableArray arrayWithCapacity:_sectionCount];
        for (NSUInteger i = 0; i < _sectionCount; i++) {
            [sections addObject:[NSMutableArray new]];
        }
        _sections = [sections copy];
    }
    return self;
}

- (NSArray *)allItemAttributes;
{
    NSMutableArray *attributes = [NSMutableArray new];
    for (NSArray *section in self.sections) {
        [attributes addObjectsFromArray:section];
    }
    return [attributes copy];
}

- (UICollectionViewLayoutAttributes *)lastAttributesOfSection:(NSUInteger)sectionIndex;
{
    return [self.sections[sectionIndex] lastObject];
}

- (CGFloat)dimensionForAttributes:(UICollectionViewLayoutAttributes *)attributes;
{
    if (self.direction == ARCollectionViewMasonryLayoutDirectionVertical) {
      return attributes.size.height;
    } else {
      return attributes.size.width;
    }
}

- (CGFloat)fixedDimensionForAttributes:(UICollectionViewLayoutAttributes *)attributes;
{
    if (self.direction == ARCollectionViewMasonryLayoutDirectionHorizontal) {
      return attributes.size.height;
    } else {
      return attributes.size.width;
    }
}

- (CGFloat)maxEdgeForAttributes:(UICollectionViewLayoutAttributes *)attributes;
{
    if (self.direction == ARCollectionViewMasonryLayoutDirectionVertical) {
      return CGRectGetMaxY(attributes.frame);
    } else {
      return CGRectGetMaxX(attributes.frame);
    }
}

- (CGFloat)dimensionForSection:(NSUInteger)sectionIndex;
{
    return [self maxEdgeForAttributes:[self lastAttributesOfSection:sectionIndex]];
}

- (void)addAttributes:(UICollectionViewLayoutAttributes *)attributes;
{
    [self addAttributes:attributes toSection:self.shortestSection];
}

- (void)addAttributes:(UICollectionViewLayoutAttributes *)attributes toSection:(NSUInteger)sectionIndex;
{
    NSAssert(!CGSizeEqualToSize(attributes.size, CGSizeZero), @"Attributes are expected to specify a size.");

    CGFloat fixedDimension = [self fixedDimensionForAttributes:attributes];
    CGFloat dimension = [self dimensionForAttributes:attributes];

    CGFloat edgeX = (fixedDimension + self.mainItemMargin) * sectionIndex;

    CGFloat xOffset = self.orthogonalInset + self.centeringOffset + edgeX;
    CGFloat yOffset = [self dimensionForSection:sectionIndex] + self.alternateItemMargin;

    NSMutableArray *section = self.sections[sectionIndex];

    // Start all the sections with the content inset, specifically to offset for the header.
    if (section.count == 0) {
      yOffset += self.leadingInset;
    }

    // Calculate center
    CGPoint itemCenter = (CGPoint) {
        xOffset + (fixedDimension / 2),
        yOffset + (dimension / 2)
    };
    if (self.direction == ARCollectionViewMasonryLayoutDirectionHorizontal) {
        itemCenter = (CGPoint){ itemCenter.y, itemCenter.x };
    }

    // Set rounded frame
    attributes.center = itemCenter;
    attributes.frame = CGRectIntegral(attributes.frame);

    [section addObject:attributes];

    // Update longestSectionDimension if this section is now longer.
    CGFloat sectionDimension = [self maxEdgeForAttributes:attributes];
    if (sectionDimension > self.longestSectionDimension) {
        self.longestSectionDimension = sectionDimension;
    }

    // Find the new shortestSection if this section used to be it.
    if (sectionIndex == self.shortestSection) {
        [self updateShortestSection];
    }
}

- (void)updateShortestSection;
{
        NSUInteger shortestSection;
    CGFloat shortestSectionDimension = CGFLOAT_MAX;
        for (NSUInteger i = 0; i < self.sectionCount; i++) {
            CGFloat dimension = [self dimensionForSection:i];
        if (dimension < shortestSectionDimension) {
                shortestSection = i;
            shortestSectionDimension = dimension;
            }
        }
        self.shortestSection = shortestSection;
    self.shortestSectionDimension = shortestSectionDimension;
}

- (UICollectionViewLayoutAttributes *)attributesAtIndexPath:(NSIndexPath *)indexPath;
{
    return self.sections[indexPath.section][indexPath.item];
}

@end
