namespace Moshine.UI.UIKit.Extensions;

uses
  Moshine.UI.UIKit.Presentation,
  UIKit;

type
  ModalPresentableUIViewControllerExtensions = public extension class(UIViewController)
  public
    method maximizeToFullScreen;
    begin
      if(assigned(self.navigationController.presentationController) and (self.navigationController.presentationController is ModalPresentationController))then
      begin
        (self.navigationController.presentationController as ModalPresentationController).adjustToFullScreen
      end;
    end;
  end;

end.