#import "_ARCollectionViewMasonryAttributesGrid.h"

@interface _ARCollectionViewMasonryAttributesGrid ()
@property (nonatomic, readonly) NSArray *sections;
@property (nonatomic, assign) NSUInteger shortestSection;
@property (nonatomic, assign) CGFloat longestSectionDimension;
@end

@implementation _ARCollectionViewMasonryAttributesGrid

- (instancetype)initWithSectionCount:(NSUInteger)sectionCount direction:(ARCollectionViewMasonryLayoutDirection)direction;
{
    if ((self = [super init])) {
        _direction = direction;
        _sectionCount = sectionCount;
        _shortestSection = 0;
        _longestSectionDimension = 0;

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
      return CGRectGetMaxY(attributes.frame);
    } else {
      return CGRectGetMaxX(attributes.frame);
    }
}

- (CGFloat)dimensionForSection:(NSUInteger)sectionIndex;
{
    return [self dimensionForAttributes:[self lastAttributesOfSection:sectionIndex]];
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
    CGFloat dimension = [self dimensionForAttributes:attributes];
    if (dimension > self.longestSectionDimension) {
        self.longestSectionDimension = dimension;
    }

    // Find the new shortestSection if this section used to be it.
    if (sectionIndex == self.shortestSection) {
        NSUInteger shortestSection;
        CGFloat shortestDimension = CGFLOAT_MAX;
        for (NSUInteger i = 0; i < self.sectionCount; i++) {
            CGFloat dimension = [self dimensionForSection:i];
            if (dimension < shortestDimension) {
                shortestSection = i;
                shortestDimension = dimension;
            }
        }
        self.shortestSection = shortestSection;
    }
}

- (UICollectionViewLayoutAttributes *)attributesAtIndexPath:(NSIndexPath *)indexPath;
{
    return self.sections[indexPath.section][indexPath.item];
}

@end
