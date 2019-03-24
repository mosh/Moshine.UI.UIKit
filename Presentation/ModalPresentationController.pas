namespace Moshine.UI.UIKit.Presentation;

uses
  Moshine.UI.UIKit.Presentation,
  UIKit;

type

  ModalPresentationController = public class(UIPresentationController)

  public
    isMaximized:Boolean := false;

  private

    _dimmingView:UIView;


  public

    property presentationDelegate:IPresentationDelegate;

    method presentationTransitionWillBegin; override;
    begin
      if(assigned(self.containerView) and assigned(presentedViewController.transitionCoordinator))then
      begin
        var containerView := self.containerView;
        var coordinator := self.presentedViewController.transitionCoordinator;
        dimmingView.alpha := 0;
        containerView.addSubview(dimmingView);
        dimmingView.addSubview(presentedViewController.view);

        coordinator.animateAlongsideTransition(method begin
            dimmingView.alpha := 1;
            self.presentedViewController.view.transform := CGAffineTransformMakeScale(0.9,0.9);

          end) completion(nil);

      end;

    end;

    method dismissalTransitionWillBegin; override;
    begin
      if(assigned(presentedViewController.transitionCoordinator))then
      begin
        var coordinator := presentedViewController.transitionCoordinator;

        coordinator.animateAlongsideTransition(method begin
            self.dimmingView.alpha := 0;
            self.presentedViewController.view.transform := CGAffineTransformIdentity;
          end) completion(method begin
              NSLog('done dismiss animation');
            end);
      end;
    end;

    method dismissalTransitionDidEnd(completed:Boolean);override;
    begin
      NSLog('dismissal did end: %@','completed');
      if (completed)then
      begin
        dimmingView.removeFromSuperview;
        _dimmingView := nil;
        isMaximized := false;
      end;
    end;

    property dimmingView:UIView read begin

      if(assigned(_dimmingView))then
      begin
        exit _dimmingView;
      end;

      var rect := CGRectMake(0,0,containerView.bounds.size.width,containerView.bounds.size.height);

      var view := new UIView withFrame(rect);

      // Blur Effect
      var blurEffect := UIBlurEffect.effectWithStyle(UIBlurEffectStyle.Dark);
      var blurEffectView :=  new UIVisualEffectView withEffect(blurEffect);
      blurEffectView.frame := view.bounds;
      view.addSubview(blurEffectView);

      // Vibrancy Effect
      var vibrancyEffect := UIVibrancyEffect.effectForBlurEffect(blurEffect);
      var vibrancyEffectView := new UIVisualEffectView withEffect(vibrancyEffect);
      vibrancyEffectView.frame := view.bounds;

      // Add the vibrancy view to the blur view
      blurEffectView.contentView.addSubview(vibrancyEffectView);

      _dimmingView := view;

      exit view;

    end;

    property frameOfPresentedViewInContainerView: CGRect read begin
        if(assigned(presentationDelegate))then
        begin
          exit presentationDelegate.frameOfPresentedViewInContainerView(self.containerView.bounds);
        end
        else
        begin
          exit CGRectMake(0, self.containerView.bounds.size.height/2,
                          containerView.bounds.size.width,
                          containerView.bounds.size.height/2);
        end;

      end;  override;

    method adjustToFullScreen;
    begin

      if (assigned(presentedView) and assigned(containerView)) then
      begin

        UIView.animateWithDuration(0.8) delay(0) usingSpringWithDamping(0.5) initialSpringVelocity(0.5) options(UIViewAnimationOptions.CurveEaseOut) animations(method begin
          presentedView.frame := containerView.frame;

          if(self.presentedViewController is UINavigationController)then
          begin
            var navController := self.presentedViewController as UINavigationController;
            self.isMaximized := true;
            navController.setNeedsStatusBarAppearanceUpdate;
              // Force the navigation bar to update its size
            navController.navigationBarHidden := true;
            navController.navigationBarHidden := false;
          end;

        end) completion(nil);

      end;

    end;

  end;




end.