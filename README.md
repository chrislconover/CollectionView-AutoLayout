

Approaches and problems

### TL;DR:

The third tab demonstrates a working example of non trivial auto layout based cells that expand when clicked, delete cells when swiped, and also demonstrate re-insertion.  This is a testbed in progress, hacked up for various tests, but working in the third tab.

### Configure estimatedSize to width of contents, after insets
 - layout can work, but also prone autolayout warnings from collection view contraints
 - update animations look broken, compress to top and back again
 - requires implementing `systemSizeFitting(..)` on cell to point to nested contents
 - requires that the collection view update it's estimated size to it's actual width minus insets in layoutSubviews, otherwise this will be 0 (if done in a VC's view did load)
 - can also implement `preferredAttributes...`, for a flow layout, but this does not seem to add any value over `systemSizeFitting`

### Use sizeForItemAt..
- layout can work (though have also run into AL warnings and errors)
- complicates state management for things like selected expanded cells as you need to access not just the supporting data but also the transient state of the cell aka view model.  This generally means that instead of your data being raw source data, you need to first map it to the final view models, so you can later access the live view model from one's "data" store, update that, and set either set it back on the cell, or have the cell listen to changes (binding)
- stil needs `systemSizeFitting` on cell
- will cause continual layout loop if `estimatedSize` is also set

### Animations
- only `UIView.animate` seems to work, enclosing `layout.invalidateLayout` and `collectionView.layoutIfNeeded`
- in my testing, `performBatchUpdates` does not work reliably


![alt text][sizeForItemAtImage]

[sizeForItemAtImage]: https://github.com/chrisco314/CollectionView-AutoLayout/WorkingAutoLayoutCollectionView.gif "Sample using sizeForItemAt"
