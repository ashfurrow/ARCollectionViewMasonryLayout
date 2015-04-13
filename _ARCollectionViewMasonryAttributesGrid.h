#import <UIKit/UIKit.h>
#import "ARCollectionViewMasonryLayout.h"

/// This class uses ‘sections’ to indicate ‘columns’ in a vertical layout and ‘rows’ in a horizontal layout.
@interface _ARCollectionViewMasonryAttributesGrid : NSObject

@property (nonatomic, readonly) ARCollectionViewMasonryLayoutDirection direction;
@property (nonatomic, readonly) NSUInteger sectionCount;
@property (nonatomic, readonly) NSUInteger shortestSection;
@property (nonatomic, readonly) CGFloat longestSectionDimension;
@property (nonatomic, readonly) NSArray *allItemAttributes;

- (instancetype)initWithSectionCount:(NSUInteger)sectionCount
                           direction:(ARCollectionViewMasonryLayoutDirection)direction;

- (void)addAttributes:(UICollectionViewLayoutAttributes *)attributes
            toSection:(NSUInteger)sectionIndex;

- (UICollectionViewLayoutAttributes *)attributesAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)dimensionForSection:(NSUInteger)sectionIndex;

- (BOOL)isSectionEmpty:(NSUInteger)sectionIndex;

@end
