import UIKit

extension Delegate: UICollectionViewDelegate {

  /// Asks the delegate for the size of the specified item’s cell.
  ///
  /// - parameter collectionView: The collection view object displaying the flow layout.
  /// - parameter collectionViewLayout: The layout object requesting the information.
  /// - parameter indexPath: The index path of the item.
  ///
  /// - returns: The width and height of the specified item. Both values must be greater than 0.
  @objc(collectionView:layout:sizeForItemAtIndexPath:) public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return spot.sizeForItem(at: indexPath)
  }

  /// Tells the delegate that the item at the specified index path was selected.
  ///
  /// - parameter collectionView: The collection view object that is notifying you of the selection change.
  /// - parameter indexPath: The index path of the cell that was selected.
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let item = spot.item(at: indexPath) else { return }
    spot.delegate?.didSelect(item: item, in: spot)
  }

  /// Asks the delegate whether the item at the specified index path can be focused.
  ///
  /// - parameter collectionView: The collection view object requesting this information.
  /// - parameter indexPath:      The index path of an item in the collection view.
  ///
  /// - returns: YES if the item can receive be focused or NO if it can not.
  public func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
    return true
  }

  ///Asks the delegate whether a change in focus should occur.
  ///
  /// - parameter collectionView: The collection view object requesting this information.
  /// - parameter context:        The context object containing metadata associated with the focus change.
  /// This object contains the index path of the previously focused item and the item targeted to receive focus next. Use this information to determine if the focus change should occur.

  /// - returns: YES if the focus change should occur or NO if it should not.
  @available(iOS 9.0, *)
  public func collectionView(_ collectionView: UICollectionView, shouldUpdateFocusIn context: UICollectionViewFocusUpdateContext) -> Bool {
    guard let indexPaths = collectionView.indexPathsForSelectedItems else { return true }
    return indexPaths.isEmpty
  }
}

extension Delegate: UITableViewDelegate {

  /// Asks the delegate for the height to use for the header of a particular section.
  ///
  /// - parameter tableView: The table-view object requesting this information.
  /// - parameter heightForHeaderInSection: An index number identifying a section of tableView.
  /// - returns: Returns the `headerHeight` found in `component.meta`, otherwise 0.0.

  public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    let header = spot.type.headers.make(spot.component.header)
    return (header?.view as? Componentable)?.preferredHeaderHeight ?? 0.0
  }

  /// Asks the data source for the title of the header of the specified section of the table view.
  ///
  /// - parameter tableView: The table-view object asking for the title.
  /// - parameter section: An index number identifying a section of tableView.
  /// - returns: A string to use as the title of the section header. Will return `nil` if title is not present on Component
  @nonobjc public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if let _ = spot.type.headers.make(spot.component.header) {
      return nil
    }
    return !spot.component.title.isEmpty ? spot.component.title : nil
  }

  /// Tells the delegate that the specified row is now selected.
  ///
  /// - parameter tableView: A table-view object informing the delegate about the new row selection.
  /// - parameter indexPath: An index path locating the new selected row in tableView.
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    if let item = spot.item(at: indexPath) {
      spot.delegate?.didSelect(item: item, in: spot)
    }
  }

  /// Asks the delegate for a view object to display in the header of the specified section of the table view.
  ///
  /// - parameter tableView: The table-view object asking for the view object.
  /// - parameter section: An index number identifying a section of tableView.
  /// - returns: A view object to be displayed in the header of section based on the kind of the ListSpot and registered headers.
  public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard !spot.component.header.isEmpty else { return nil }

    let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: spot.component.header)
    view?.frame.size.height = spot.component.meta(ListSpot.Key.headerHeight, 0.0)
    view?.frame.size.width = tableView.frame.size.width
    (view as? Componentable)?.configure(spot.component)

    return view
  }

  /// Asks the delegate for the height to use for a row in a specified location.
  ///
  /// - parameter tableView: The table-view object requesting this information.
  /// - parameter indexPath: An index path that locates a row in tableView.
  /// - returns:  A nonnegative floating-point value that specifies the height (in points) that row should be based on the view model height, defaults to 0.0.

  public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    spot.component.size = CGSize(
      width: tableView.frame.size.width,
      height: tableView.frame.size.height)

    return spot.item(at: indexPath)?.size.height ?? 0
  }
}