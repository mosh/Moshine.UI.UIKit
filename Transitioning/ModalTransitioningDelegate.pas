namespace Moshine.UI.UIKit.Transitioning;

uses
  Moshine.UI.UIKit.Presentation,
  UIKit;

type

  ModalTransitioningDelegate = public class(IUIViewControllerTransitioningDelegate, IPresentationDelegate)
  public
    interactiveDismiss:Boolean := true;

  private
    interactiveController:ModalInteractiveTransition;

  public

    property viewController:UIViewController;
    property presentingViewController:UIViewController;


    constructor (someViewController:UIViewController; somePresentingViewController:UIViewController);
    begin
      inherited constructor;

      self.viewController := someViewController;
      self.presentingViewController := somePresentingViewController;
      self.interactiveController := new ModalInteractiveTransition(self.viewController) withView(self.presentingViewController.view, self.presentingViewController);
    end;

    method animationControllerForDismissedController(dismissed: not nullable UIViewController): nullable IUIViewControllerAnimatedTransitioning;
    begin
      exit new ModalTransitionAnimator(ModalTransitionAnimatorType.Dismiss);
    end;

    method presentationControllerForPresentedViewController(presented: not nullable UIViewController) presentingViewController(presenting: nullable UIViewController) sourceViewController(source: not nullable UIViewController): nullable UIPresentationController;
    begin
      var presentationController := new ModalPresentationController withPresentedViewController(presented) presentingViewController(presenting);
      if(assigned(presentationDelegate))then
      begin
        presentationController.presentationDelegate := self;
      end;
      exit presentationController;
    end;

    method frameOfPresentedViewInContainerView(containerBounds:CGRect):CGRect;
    begin
      exit presentationDelegate:frameOfPresentedViewInContainerView(containerBounds);
    end;

    method dismissAnimation(sender:id);
    begin
      presentationDelegate:dismissAnimation(self);
    end;

    property presentationDelegate:IPresentationDelegate;



    method interactionControllerForDismissal(animator: not nullable IUIViewControllerAnimatedTransitioning): nullable IUIViewControllerInteractiveTransitioning;
    begin
      if(interactiveDismiss)then
      begin
        exit self.interactiveController;
      end;
    end;
  end;

end.