namespace Moshine.UI.UIKit;

uses
  Foundation, UIKit;

type

  OnTextChangedDelegate = public block(value:NSString);


  [IBObject]
  MoshineTextFieldTableViewCell = public class(MoshineBaseTableViewCell)
  protected

    method createControl:UIView; override;
    begin
      exit new UITextField;
    end;


    method setup; override;
    begin
      inherited setup;

      self.textField.textAlignment := NSTextAlignment.Left;

      self.textField.addTarget(self) action(selector(textFieldDidChange:)) forControlEvents(UIControlEvents.EditingChanged);

    end;

    method textFieldDidChange(sender:id);
    begin
      if((assigned(OnTextChanged)) and (assigned(sender)))then
      begin
        OnTextChanged(UITextField(sender).text);
      end;

    end;

    method get_textField:UITextField;
    begin
      exit cellControl as UITextField;
    end;

  public

    property OnTextChanged:OnTextChangedDelegate;

    [IBOutlet]property textField:weak UITextField read get_textField;


    method touchesBegan(touches: not nullable NSSet) withEvent(&event: nullable UIEvent); override;
    begin
      self.textField:becomeFirstResponder;
    end;

  end;


end.