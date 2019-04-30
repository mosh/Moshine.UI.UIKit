namespace Moshine.UI.UIKit.Presentation;

type
  IModalReceiver = public interface
    method OnCloseWithCancel(sender:id);
    method OnCloseWithDone(sender:id);
  end;
end.