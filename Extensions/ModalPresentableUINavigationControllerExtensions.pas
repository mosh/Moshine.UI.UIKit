namespace Moshine.UI.UIKit.Extensions;

uses
  Moshine.UI.UIKit.Presentation,
  UIKit;

type
  ModalPresentableUINavigationControllerExtensions = public extension class(UINavigationController)
  public
    method isModalMaximized:Boolean;
    begin
      if(self.presentationController is ModalPresentationController)then
      begin
        exit ModalPresentationController(self.presentationController).isMaximized;
      end;

      exit;

    end;
  end;


end.