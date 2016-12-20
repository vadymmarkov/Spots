import Cocoa
import Spots
import Brick

class CompositionListView: NSTableRowView, SpotConfigurable {

  var preferredViewSize: CGSize = CGSize(width: 0, height: 120)

  func configure(_ item: inout Item) {
    backgroundColor = NSColor.red
  }
}
