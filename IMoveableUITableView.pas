namespace Moshine.UI.UIKit;

uses
  Foundation,
  UIKit;

type

  IMoveableUITableView = public interface
    property MoveableObjects : NSMutableArray read;
    property tableView: UITableView read;

    property snapshot: UIView read write;
    property sourceIndexPath: NSIndexPath read write;

    method rowMovedToIndexPath(indexPath:NSIndexPath);
    begin
    end;

    [IBAction]method longPressGestureRecognized(sender:id);
    begin
      self.longPressGestureRecognizedImpl(sender);
    end;

  end;

end.