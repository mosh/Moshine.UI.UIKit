namespace Moshine.UI.UIKit;

uses
  Foundation, UIKit, RemObjects.Elements.RTL;

type

  [Cocoa]
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

    property Text: nullable NSString read
      begin
        exit self.textView.text;
      end
      write
      begin
        self.textView.text := value;
      end; override;

    method updateConstraints; override;
    begin

      var fontDictionary := new NSMutableDictionary;
      fontDictionary.setValue(textView.font) forKey(NSFontAttributeName);
      var size := self.Text.sizeWithAttributes(fontDictionary);

      var labelHeight := size.height;
      Log($'labelHeight {labelHeight}');
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