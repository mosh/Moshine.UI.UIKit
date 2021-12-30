namespace Moshine.UI.UIKit.Transitioning;

uses
  UIKit;

type

  {$IFDEF TOFFEE}


  [Cocoa]
  ModalInteractiveTransition = public class(UIPercentDrivenInteractiveTransition)
  private

    presentingViewController:UIViewController;
    panGestureRecognizer:UIPanGestureRecognizer;

    shouldComplete:Boolean := false;

    method get_completionSpeed: CGFloat;
    begin
      exit 1.0 - self.percentComplete;
    end;


  protected
  public
    constructor (someViewController:UIViewController) withView(view:UIView; somePresentingViewController:UIViewController);
    begin
      inherited constructor;

      self.presentingViewController := somePresentingViewController;
      self.panGestureRecognizer := new UIPanGestureRecognizer;

      self.panGestureRecognizer.addTarget(self) action(selector(onPan:));
      view.addGestureRecognizer(panGestureRecognizer);
    end;

    method startInteractiveTransition(transitionContext: not nullable IUIViewControllerContextTransitioning); override;
    begin
      inherited startInteractiveTransition(transitionContext);

      NSLog('%@','start interactive');
    end;

    property completionSpeed: CGFloat read get_completionSpeed; override;

    method onPan(pan: UIPanGestureRecognizer);
    begin
      var translation := pan.translationInView(pan.view:superview);

      case pan.state of
        UIGestureRecognizerState.Began:
          begin
            self.presentingViewController:dismissViewControllerAnimated(true) completion(nil);
          end;
        UIGestureRecognizerState.Changed:
          begin
            var screenHeight := UIScreen.mainScreen.bounds.size.height - 50;
            var dragAmount := screenHeight;
            var threshold := 0.2;
            var percent := translation.y / dragAmount;

            percent := fmaxf(percent,0.0);
            percent := fminf(percent,1.0);

            self.updateInteractiveTransition(percent);

            shouldComplete := percent>threshold;
          end;
        UIGestureRecognizerState.Ended, UIGestureRecognizerState.Cancelled:
          begin
            if((pan.state = UIGestureRecognizerState.Cancelled) or (not shouldComplete))then
            begin
              self.cancelInteractiveTransition;
              NSLog('%@','cancel transition');
            end
            else
            begin
              self.finishInteractiveTransition;
              NSLog('%@','finished transition');
            end;
          end;
        else
          self.cancelInteractiveTransition;
      end;

    end;

  end;

  {$ENDIF}

end.
