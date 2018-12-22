namespace Moshine.UI.UIKit;

uses
  Foundation, UIKit;

type

  [IBObject]
  MoshineTextViewTableViewCell = public class(MoshineBaseTableViewCell, IUITextViewDelegate)
  private

  protected

    method createControl:UIView; override;
    begin
      exit new UITextView;
    end;

  public

    method setup; override;
    begin
      inherited setup;

      textView.delegate := self;
      textView.setFont(UIFont.systemFontOfSize(17));

    end;

    [IBOutlet]property textView:UITextView read UITextView(cellControl);

    method touchesBegan(touches: NSSet<UITouch>) withEvent(&event: nullable UIEvent); override;
    begin
      self.textView:becomeFirstResponder;
    end;

    method textViewDidChange(changingTextView: UITextView);
    begin
      if (assigned(OnTextChanged)) then
      begin
        OnTextChanged(changingTextView.text);
      end;

    end;

    property OnTextChanged:OnTextChangedDelegate;


  end;

end.