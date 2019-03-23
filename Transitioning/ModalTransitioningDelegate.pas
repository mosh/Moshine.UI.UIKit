namespace Moshine.UI.UIKit.Transitioning;

uses
  Moshine.UI.UIKit.Presentation,
  UIKit;

type

  ModalTransitioningDelegate = public class(IUIViewControllerTransitioningDelegate)
  public
    interactiveDismiss:Boolean := true;

  private
    viewController:UIViewController;
    presentingViewController:UIViewController;
    interactiveController:ModalInteractiveTransition;

  public

    constructor (viewController:UIViewController; presentingViewController:UIViewController);
    begin
      inherited constructor;

      self.viewController := viewController;
      self.presentingViewController := presentingViewController;
      self.interactiveController := new ModalInteractiveTransition(self.viewController) withView(self.presentingViewController.view, self.presentingViewController);
    end;

    method animationControllerForDismissedController(dismissed: not nullable UIViewController): nullable IUIViewControllerAnimatedTransitioning;
    begin
      exit new ModalTransitionAnimator(ModalTransitionAnimatorType.Dismiss);
    end;

    method presentationControllerForPresentedViewController(presented: not nullable UIViewController) presentingViewController(presenting: nullable UIViewController) sourceViewController(source: not nullable UIViewController): nullable UIPresentationController;
    begin
      exit new ModalPresentationController withPresentedViewController(presented) presentingViewController(presenting);
    end;

    method interactionControllerForDismissal(animator: not nullable IUIViewControllerAnimatedTransitioning): nullable IUIViewControllerInteractiveTransitioning;
    begin
      if(interactiveDismiss)then
      begin
        exit self.interactiveController;
      end;
    end;
  end;

end.