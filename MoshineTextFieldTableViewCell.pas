﻿namespace Moshine.UI.UIKit;

uses
  Foundation, UIKit;

type

  OnTextChangedDelegate = public block(value:NSString);


  [IBObject]
  MoshineTextFieldTableViewCell = public class(MoshineBaseTableViewCell, IUITextFieldDelegate)
  protected

    method createControl:UIView; override;
    begin
      var field := new UITextField;
      field.keyboardType := UIKeyboardType.Default;
      field.returnKeyType := UIReturnKeyType.Done;
      field.delegate := self;
      exit field;
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

  public

    property OnTextChanged:OnTextChangedDelegate;

    [IBOutlet]property textField:UITextField read
      begin
        exit cellControl as UITextField;
      end;

    method touchesBegan(touches: NSSet<UITouch>) withEvent(&event: nullable UIEvent); override;
    begin
      self.textField:becomeFirstResponder;
    end;

    method textFieldShouldReturn(someTextField: not nullable UITextField): BOOL;
    begin
      self.textField.resignFirstResponder;
      exit true;
    end;


  end;


end.