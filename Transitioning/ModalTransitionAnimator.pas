namespace Moshine.UI.UIKit.Transitioning;

uses
  UIKit;

type

  ModalTransitionAnimatorType = public enum(Present,Dismiss);
  [Cocoa]
  ModalTransitionAnimator = public class(IUIViewControllerAnimatedTransitioning)
  public

    method animateTransition(transitionContext: not nullable IUIViewControllerContextTransitioning);
    begin

      //var &to := transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey);
      var &from := transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey);

      UIView.animateWithDuration(transitionDuration(transitionContext)) animations(method begin

          if(assigned(&from))then
          begin
            &from.view.frame := CGRectMake(&from.view.frame.origin.x, 800, &from.view.frame.size.width, &from.view.frame.size.height);

            NSLog('%@','animating...');
          end;
        end) completion(method(completed:Boolean) begin
            NSLog('%@','animate completed');
            transitionContext.completeTransition(not transitionContext.transitionWasCancelled);
          end);


    end;

    constructor (&someType:ModalTransitionAnimatorType);
    begin
      //self.&type := &someType;
    end;


    method transitionDuration(transitionContext: nullable IUIViewControllerContextTransitioning): NSTimeInterval;
    begin
      exit 0.4;
    end;

  end;

end.