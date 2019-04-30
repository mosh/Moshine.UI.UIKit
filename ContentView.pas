namespace Moshine.UI.UIKit;

uses
  Moshine.UI.UIKit.Extensions,
  Moshine.UI.UIKit.Presentation,
  UIKit;

type
  [IBObject]
  ContentView = public abstract class(UIView)
  protected

    method closeWithCancel;
    begin
      if(self.nextResponder is IModalPresentable)then
      begin
        IModalPresentable(self.nextResponder).OnCloseWithCancel(self);
        IModalPresentable(self.nextResponder).close(CloseReason.Cancel);
      end;
    end;

    method closeWithDone;
    begin
      if(self.nextResponder is IModalPresentable)then
      begin
        IModalPresentable(self.nextResponder).OnCloseWithDone(self);
        IModalPresentable(self.nextResponder).close(CloseReason.Done);
      end;
    end;

    method NibName:String; abstract;

    method commonInit;
    begin
      Bundle.mainBundle.loadNibNamed(NibName) owner(self) options(nil);
      addSubview(contentView);
      contentView.frame := self.bounds;
      contentView.autoresizingMask := UIViewAutoresizing.FlexibleWidth or UIViewAutoresizing.FlexibleHeight;
    end;

  public
    [IBOutlet]property contentView:UIView;

    [IBAction]method doCancel(sender:id);virtual;
    begin
      closeWithCancel;
    end;

    [IBAction]method doDone(sender:id);virtual;
    begin
      closeWithDone;
    end;

    // In code
    method initWithFrame(aFrame: CGRect): InstanceType; override;
    begin
      self := inherited initWithFrame(aFrame);
      if assigned(self) then
      begin
        commonInit;
      end;
      result := self;
    end;

    // InterfaceBuilder
    method initWithCoder(aDecoder: not nullable NSCoder):id; override;
    begin
      self := inherited initWithCoder(aDecoder);
      if(assigned(self))then
      begin
        commonInit;
      end;
      exit self;
    end;

  end;

end.