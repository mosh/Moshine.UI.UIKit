namespace Moshine.UI.UIKit.Presentation;

uses
  Moshine.UI.UIKit.Extensions,
  UIKit;

type
  IModalPresentable = public interface(IModalReceiver)

    property transitioningDelegate: IUIViewControllerTransitioningDelegate;
    method dismissViewControllerAnimated(flag: Boolean) completion(completion: block());
    property reasonForClose:CloseReason;


  end;

end.