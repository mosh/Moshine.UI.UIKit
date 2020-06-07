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
      var view := new UITextView;
      view.scrollEnabled := false;
      view.keyboardType := UIKeyboardType.Default;
      view.returnKeyType := UIReturnKeyType.Done;
      exit view;
    end;


  public

    method setup; override;
    begin
      inherited setup;

      textView.delegate := self;
      textView.setFont(UIFont.systemFontOfSize(17));

    end;

    [IBOutlet]property textView:UITextView read
      begin
        exit cellControl as UITextView;
      end;

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

    property Text: nullable String read
      begin
        exit self.textView.text;
      end
      write
      begin
        self.textView.text := value;
      end; override;

    method updateConstraints; override;
    begin

      var labelHeight := self.Text.sizeWithFont(textView.font).height;
      NSLog('%@',$'labelHeight {labelHeight}');
      var newFrame := self.frame;
      newFrame.size := CGSizeMake(newFrame.size.width , labelHeight);
      self.textView.frame := newFrame;

      inherited updateConstraints;
    end;

    method textViewShouldEndEditing(someTextView: not nullable UITextView):BOOL;
    begin
      someTextView.resignFirstResponder;
      exit true;
    end;


  end;

end.