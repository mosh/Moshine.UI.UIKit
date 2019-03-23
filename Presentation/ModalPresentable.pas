namespace Moshine.UI.UIKit.Presentation;

uses
  UIKit;

type
  ModalPresentable = public interface

    property transitioningDelegate: IUIViewControllerTransitioningDelegate;
    method dismissViewControllerAnimated(flag: Boolean) completion(completion: block());

  end;

end.