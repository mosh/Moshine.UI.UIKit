namespace Moshine.UI.UIKit.Extensions;

uses
  Moshine.UI.UIKit.Presentation,
  Moshine.UI.UIKit.Transitioning;
type

  CloseReason = public enum (Cancel,Done);


  ModalPresentableExtensions = public extension class(IModalPresentable)
  public

    method close(reason:CloseReason);
    begin
      self.reasonForClose := reason;

      if(assigned(self.transitioningDelegate) and (self.transitioningDelegate is ModalTransitioningDelegate)) then
      begin
        var &delegate := self.transitioningDelegate as ModalTransitioningDelegate;
        &delegate.interactiveDismiss := false;
      end;

      dismissViewControllerAnimated(true) completion(nil);

    end;
  end;

end.