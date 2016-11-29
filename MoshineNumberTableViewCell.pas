namespace Moshine.UI.UIKit;

uses
  Foundation,UIKit;

type

  MoshineNumberTableViewCell = public class(UITableViewCell, IUITextFieldDelegate)
  private
  
    method setup;
    begin
      self.detailTextLabel:hidden := true;
      self.CellControl := new UITextField;
      self.contentView.viewWithTag(3):removeFromSuperview();
      self.CellControl.tag := 3;
      self.CellControl.translatesAutoresizingMaskIntoConstraints := false;
      self.contentView.addSubview(self.CellControl);
      
      self.addConstraint(NSLayoutConstraint.constraintWithItem(self.CellControl) attribute(NSLayoutAttribute.Leading) relatedBy(NSLayoutRelation.Equal) toItem(self.contentView) attribute(NSLayoutAttribute.Leading) multiplier(1) constant(8));
      self.addConstraint(NSLayoutConstraint.constraintWithItem(self.CellControl) attribute(NSLayoutAttribute.Top) relatedBy(NSLayoutRelation.Equal) toItem(self.contentView) attribute(NSLayoutAttribute.Top) multiplier(1) constant(8));
      self.addConstraint(NSLayoutConstraint.constraintWithItem(self.CellControl) attribute(NSLayoutAttribute.Bottom) relatedBy(NSLayoutRelation.Equal) toItem(self.contentView) attribute(NSLayoutAttribute.Bottom) multiplier(1) constant(-8));
      self.addConstraint(NSLayoutConstraint.constraintWithItem(self.CellControl) attribute(NSLayoutAttribute.Trailing) relatedBy(NSLayoutRelation.Equal) toItem(self.contentView) attribute(NSLayoutAttribute.Trailing) multiplier(1) constant(-16));
      
      self.CellControl.textAlignment := NSTextAlignment.Left;
      self.CellControl.delegate := self;
      
      self.CellControl.addTarget(self) action(selector(textFieldDidChange:)) forControlEvents(UIControlEvents.EditingChanged);
      
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

  public
  

    property OnTextChanged:OnTextChangedDelegate;
    
  
    [IBOutlet]property CellControl:weak UITextField;
  
    method awakeFromNib; override;
    begin
      inherited awakeFromNib;
      setup;
    end;
    
    method initWithStyle(style: UITableViewCellStyle) reuseIdentifier(reuseIdentifier: NSString): instancetype; override;
    begin
      self := inherited initWithStyle(style) reuseIdentifier(reuseIdentifier);
      if(assigned(self))then
      begin
        setup;
      end;
      exit self;
    end;
    
    method initWithCoder(aDecoder: NSCoder): instancetype;
    begin
      self := inherited initWithCoder(aDecoder);
      if(assigned(self))then
      begin
        setup;
      end;
      exit self;
    end;
    
    method touchesBegan(touches: not nullable NSSet) withEvent(&event: nullable UIEvent); override;
    begin
      self.CellControl:becomeFirstResponder;
    end;
        
    
  end;

end.
