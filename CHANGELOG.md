2.2.0
-----

- [#28](https://github.com/ashfurrow/ARCollectionViewMasonryLayout/pull/29): Sticky headers can offer a callback when they switch stickiness - [@orta](https://github.com/orta)
- [#27](https://github.com/ashfurrow/ARCollectionViewMasonryLayout/pull/27): Add support for Sticky headers in the collectionview - [@orta](https://github.com/orta)
- [#27](https://github.com/ashfurrow/ARCollectionViewMasonryLayout/pull/27): Careful layout cache invalidation, should be a big speed boost from previous builds. - [@orta](https://github.com/orta)

2.1.2
-----

- [#25](https://github.com/ashfurrow/ARCollectionViewMasonryLayout/pull/25): Section dimensions and max attribtue should reflect header height even if items haven't yet been added to the collection view. - [@1aurabrown](https://github.com/1aurabrown)

2.1.1
-----
- [#24](https://github.com/ashfurrow/ARCollectionViewMasonryLayout/pull/24): Do not include trailing margin in the content size when the collection view is empty - [@alloy](https://github.com/alloy). 

2.1.0
-----
- [#22](remove header and footer attributes if header/footer has no size): Remove header and footer attributes if header/footer has no size - [@laurabrown](https://github.com/1aurabrown).
- [#23](https://github.com/ashfurrow/ARCollectionViewMasonryLayout/pull/23): Move entries that stick out too far on the wrong side to the front & Move section dimension calculation into a separate class. - [@alloy](https://github.com/alloy).

2.0.0
-----
- [#20](https://github.com/AshFurrow/ARCollectionViewMasonryLayout/pull/20): Fixed multiple sections false positive assert in `longestDimensionWithLengths` when invoked without a collection view - [@dblock](https://github.com/dblock).

1.0.1
-----
- [#16](https://github.com/AshFurrow/ARCollectionViewMasonryLayout/pull/16): Changed ARCollectionViewMasonryLayout to use UICollectionViewFlowLayout's API and support for headers and footers - [@laurabrown](https://github.com/1aurabrown).


1.0.0
-----

- [#9](https://github.com/AshFurrow/ARCollectionViewMasonryLayout/pull/9): Moved ARCollectionViewMasonryLayout.podspec and screenshots into the project - [@dblock](https://github.com/dblock).
- [#8](https://github.com/AshFurrow/ARCollectionViewMasonryLayout/issues/8): Added support for header and footer views via `ARCollectionViewMasonryLayoutDelegate` - [@dblock](https://github.com/dblock).
- [#11](https://github.com/AshFurrow/ARCollectionViewMasonryLayout/issues/11): Fixed crash in layout without footer on iOS8 - [@dblock](https://github.com/dblock).
- [#13](https://github.com/AshFurrow/ARCollectionViewMasonryLayout/pull/13): Removed `footerHeight`, `footerViewClass`, `leadingView` and `trailingView`  - [@dblock](https://github.com/dblock).

0.0.2
-----

- [#7](https://github.com/AshFurrow/ARCollectionViewMasonryLayout/pull/7): Fixed antialiasing on non-retina display - [@1aurabrown](https://github.com/1aurabrown).
- [#6](https://github.com/AshFurrow/ARCollectionViewMasonryLayout/pull/6): Added integration and unit tests - [@AshFurrow](https://github.com/AshFurrow).
- [#5](https://github.com/AshFurrow/ARCollectionViewMasonryLayout/issues/5): Fixed `mainItemMargin` returning the wrong value - [@AshFurrow](https://github.com/AshFurrow).

0.0.1
-----

- Initial public release - [@AshFurrow](https://github.com/AshFurrow), original code from [@prta](https://github.com/orta).
