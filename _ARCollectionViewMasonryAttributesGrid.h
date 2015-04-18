#import <UIKit/UIKit.h>
#import "ARCollectionViewMasonryLayout.h"

/// This class uses ‘sections’ to indicate ‘columns’ in a vertical layout and ‘rows’ in a horizontal layout.
@interface _ARCollectionViewMasonryAttributesGrid : NSObject

@property (nonatomic, readonly) ARCollectionViewMasonryLayoutDirection direction;
@property (nonatomic, readonly) CGFloat leadingInset;
@property (nonatomic, readonly) CGFloat orthogonalInset;
@property (nonatomic, readonly) CGFloat mainItemMargin;
@property (nonatomic, readonly) CGFloat alternateItemMargin;
// The offset used on the non-main direction to ensure centering
@property (nonatomic, readonly) CGFloat centeringOffset;
@property (nonatomic, readonly) NSUInteger sectionCount;
@property (nonatomic, readonly) NSUInteger shortestSection;
@property (nonatomic, readonly) CGFloat longestSectionDimension;
@property (nonatomic, readonly) NSArray *allItemAttributes;

- (instancetype)initWithSectionCount:(NSUInteger)sectionCount
                           direction:(ARCollectionViewMasonryLayoutDirection)direction
                        leadingInset:(CGFloat)leadingInset
                     orthogonalInset:(CGFloat)orthogonalInset
                      mainItemMargin:(CGFloat)mainItemMargin
                 alternateItemMargin:(CGFloat)alternateItemMargin
                     centeringOffset:(CGFloat)centeringOffset;

/// Adds `attributes` to the shortest section.
/// Its frame will be calculated based on `-[UICollectionViewLayoutAttributes size]`.
///
- (void)addAttributes:(UICollectionViewLayoutAttributes *)attributes;

- (void)addAttributes:(UICollectionViewLayoutAttributes *)attributes
            toSection:(NSUInteger)sectionIndex;

- (UICollectionViewLayoutAttributes *)attributesAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)dimensionForSection:(NSUInteger)sectionIndex;


@end
