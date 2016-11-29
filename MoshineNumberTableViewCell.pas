namespace Moshine.UI.UIKit;

uses
  Foundation,UIKit;

type

  MoshineNumberTableViewCell = public class(MoshineBaseTableCell, IUITextFieldDelegate)
  protected
  
    method createControl:UIView; override;
    begin
      exit new UITextField;
    end;
  
    method setup; override;
    begin
      inherited setup;
      
      self.textControl.textAlignment := NSTextAlignment.Left;
      self.textControl.delegate := self;
      
      self.textControl.addTarget(self) action(selector(textFieldDidChange:)) forControlEvents(UIControlEvents.EditingChanged);
      
    end;
    
    method textFieldDidChange(sender:id);
    begin
      if((assigned(OnTextChanged)) and (assigned(sender)))then
      begin
        OnTextChanged(UITextField(sender).text);
      end;
      
    end;
    
    method textField(textField: ^UITextField) shouldChangeCharactersInRange(range: NSRange) replacementString(value: NSString): Boolean;
    begin
      var characterSetAllowed := NSCharacterSet.decimalDigitCharacterSet;
      
      if((not assigned(value)) or ((assigned(value)) and (value.length=0)))then
      begin
        exit true;
      end;
      
      var rangeAllowed := value.rangeOfCharacterFromSet(characterSetAllowed) options(NSStringCompareOptions.CaseInsensitiveSearch);
      
      if(rangeAllowed.length = value.length)then
      begin
        exit true;
      end;
      
      exit false;
    end;
    
    method get_textControl:UITextField;
    begin
      exit cellControl as UITextField;
    end;

  public
  

    property OnTextChanged:OnTextChangedDelegate;
  
    [IBOutlet]property textControl:weak UITextField read get_textControl;
    
    method touchesBegan(touches: not nullable NSSet) withEvent(&event: nullable UIEvent); override;
    begin
      self.textControl:becomeFirstResponder;
    end;
        
    
  end;

end.
