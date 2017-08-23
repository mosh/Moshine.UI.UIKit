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

    method get_textView:UITextView;
    begin
      exit cellControl as UITextView;
    end;

  public

    method setup; override;
    begin
      inherited setup;

      textView.delegate := self;
      textView.setFont(UIFont.systemFontOfSize(17));

    end;

    [IBOutlet]property textView:weak UITextView read get_textView;


    method touchesBegan(touches: not nullable NSSet) withEvent(&event: nullable UIEvent); override;
    begin
      self.textView:becomeFirstResponder;
    end;

    method textViewDidChange(textView: UITextView);
    begin
      if (assigned(OnTextChanged)) then
      begin
        OnTextChanged(textView.text);
      end;

    end;

    property OnTextChanged:OnTextChangedDelegate;


  end;

end.