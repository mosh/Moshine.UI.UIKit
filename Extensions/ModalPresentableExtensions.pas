namespace Moshine.UI.UIKit.Extensions;

uses
  Moshine.UI.UIKit.Presentation,
  Moshine.UI.UIKit.Transitioning;
type

  ModalPresentableExtensions = public extension class(ModalPresentable)
  public

    method close;
    begin
      if(assigned(self.transitioningDelegate) and (self.transitioningDelegate is ModalTransitioningDelegate)) then
      begin
        var &delegate := self.transitioningDelegate as ModalTransitioningDelegate;
        &delegate.interactiveDismiss := false;
      end;

      dismissViewControllerAnimated(true) completion(nil);

    end;
  end;

end.