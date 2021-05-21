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
    constructor withFrame(frame: CGRect); override;
    begin
      inherited constructor WithFrame(frame);
      commonInit;
    end;


    // InterfaceBuilder
    constructor WithCoder(aDecoder: not nullable NSCoder); override;
    begin
      inherited constructor WithCoder(aDecoder);
      commonInit;
    end;

  end;

end.