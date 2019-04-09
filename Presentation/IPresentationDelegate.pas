namespace Moshine.UI.UIKit.Presentation;

uses
  Coregraphics,
  Foundation;

type

  IPresentationDelegate = public interface
    method frameOfPresentedViewInContainerView(containerBounds:CGRect):CGRect;
    method dismissAnimation;
  end;

end.