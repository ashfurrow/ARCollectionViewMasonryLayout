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

- (BOOL)isSectionEmpty:(NSUInteger)sectionIndex;
{
    return [self.sections[sectionIndex] count] == 0;
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
    NSUInteger columnIndex = self.shortestSection;
    // self.dimensionLength
    CGFloat fixedDimension = [self fixedDimensionForAttributes:attributes];
    // itemAlternateDimension
    CGFloat dimension = [self dimensionForAttributes:attributes];

    // Where would it be without any manipulation
    CGFloat edgeX = (fixedDimension + self.mainItemMargin) * columnIndex;

    // Apply centering
    CGFloat xOffset = self.orthogonalInset + self.centeringOffset + edgeX;
    CGFloat yOffset = [self dimensionForSection:columnIndex] + self.alternateItemMargin;
    // Start all the sections with the content inset, specifically to offset for the header.
    if ([self isSectionEmpty:columnIndex]) {
      yOffset += self.leadingInset;
    }

    CGPoint itemCenter = (CGPoint) {
        xOffset + (fixedDimension / 2),
        yOffset + (dimension / 2)
    };
    if (self.direction == ARCollectionViewMasonryLayoutDirectionHorizontal) {
        itemCenter = (CGPoint){ itemCenter.y, itemCenter.x };
    }

    attributes.center = itemCenter;
    // Round calculated frame
    attributes.frame = CGRectIntegral(attributes.frame);

    [self addAttributes:attributes toSection:columnIndex];
}

- (void)addAttributes:(UICollectionViewLayoutAttributes *)attributes toSection:(NSUInteger)sectionIndex;
{
    NSMutableArray *section = self.sections[sectionIndex];

    // This is mainly to ensure no incorrect frames are used in the tests.
    NSAssert(section.count == 0 ||
                 !CGRectIntersectsRect([self lastAttributesOfSection:sectionIndex].frame, attributes.frame),
             @"Expect layout attribute frames to not intersect.");

    [section addObject:attributes];

    // Update longestSectionDimension if this section is now longer.
    CGFloat dimension = [self maxEdgeForAttributes:attributes];
    if (dimension > self.longestSectionDimension) {
        self.longestSectionDimension = dimension;
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
