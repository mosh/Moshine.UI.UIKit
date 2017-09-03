namespace Moshine.UI.UIKit;

uses
  Foundation, UIKit;

type

  //
  // code from:
  // https://www.raywenderlich.com/63089/cookbook-moving-table-view-cells-with-a-long-press-gesture
  //

  IMoveableUITableView = public interface
    property MoveableObjects : NSMutableArray read;
    property tableView: UITableView read;

    property snapshot: UIView read write;
    property sourceIndexPath: NSIndexPath read write;

  end;

  MoveableUITableViewExtensions = public extension class(IMoveableUITableView)

  protected

    method createGestureRecognizer: UILongPressGestureRecognizer;
    begin
      exit new UILongPressGestureRecognizer withTarget(self) action(selector(longPressGestureRecognized:));
    end;


    method customSnapshotFromView(inputView: UIView): UIView;
    begin
      UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0);
      inputView.layer.renderInContext(UIGraphicsGetCurrentContext());
      var image: UIImage := UIGraphicsGetImageFromCurrentImageContext();
      UIGraphicsEndImageContext();
      var snapshot: UIView := new UIImageView withImage(image);
      snapshot.layer.masksToBounds := false;
      snapshot.layer.cornerRadius := 0;
      snapshot.layer.shadowOffset := CGSizeMake(-5, 0);
      snapshot.layer.shadowRadius := 5;
      snapshot.layer.shadowOpacity := 0.4;
      exit snapshot;
    end;

  public

    method longPressGestureRecognizedImpl(sender:id);
    begin
      var longPress: UILongPressGestureRecognizer := UILongPressGestureRecognizer(sender);
      var state: UIGestureRecognizerState := longPress.state;
      var location: CGPoint := longPress.locationInView(self.tableView);
      var indexPath: NSIndexPath := self.tableView.indexPathForRowAtPoint(location);



      case state of
        UIGestureRecognizerState.Began:
        begin
          if (assigned(indexPath)) then
          begin
            sourceIndexPath := indexPath;
            var cell: UITableViewCell := self.tableView.cellForRowAtIndexPath(indexPath);
            snapshot := self.customSnapshotFromView(cell);
            var center: CGPoint := cell.center;
            snapshot.center := center;
            snapshot.alpha := 0;
            self.tableView.addSubview(snapshot);
            UIView.animateWithDuration(0.25) animations(() -> begin
              center.y := location.y;
              snapshot.center := center;
              snapshot.transform := CGAffineTransformMakeScale(1.05, 1.05);
              snapshot.alpha := 0.98;
              cell.alpha := 0;
              cell.hidden := true;
            end);
          end;
        end;
        UIGestureRecognizerState.Changed:
        begin
          var center: CGPoint := snapshot.center;
          center.y := location.y;
          snapshot.center := center;
          if (assigned(indexPath)) and not indexPath.isEqual(sourceIndexPath) then
          begin
            self.MoveableObjects.exchangeObjectAtIndex(indexPath.row) withObjectAtIndex(sourceIndexPath.row);
            self.tableView.moveRowAtIndexPath(sourceIndexPath) toIndexPath(indexPath);
            sourceIndexPath := indexPath;
          end;
        end;
        else
          begin
            var cell: UITableViewCell := self.tableView.cellForRowAtIndexPath(sourceIndexPath);
            cell.alpha := 0;
            UIView.animateWithDuration(0.25) animations(() -> begin
              snapshot.center := cell.center;
              snapshot.transform := CGAffineTransformIdentity;
              snapshot.alpha := 0;
              cell.alpha := 1;
            end) completion((finished) -> begin
              cell.hidden := false;
              sourceIndexPath := nil;
              snapshot.removeFromSuperview();
              snapshot := nil;
            end);
          end;
      end;
    end;


  end;


end.