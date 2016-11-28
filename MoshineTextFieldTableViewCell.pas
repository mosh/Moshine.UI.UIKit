namespace Moshine.UI.UIKit;

uses
  Foundation, UIKit;

type

  OnTextChangedDelegate = public block(value:NSString);


  [IBObject]
  MoshineTextFieldTableViewCell = public class(UITableViewCell)
  private
  
    method setup;
    begin
      self.detailTextLabel:hidden := true;
      self.textField := new UITextField;
      self.contentView.viewWithTag(3):removeFromSuperview();
      self.textField.tag := 3;
      self.textField.translatesAutoresizingMaskIntoConstraints := false;
      self.contentView.addSubview(self.textField);
      
      self.addConstraint(NSLayoutConstraint.constraintWithItem(self.textField) attribute(NSLayoutAttribute.Leading) relatedBy(NSLayoutRelation.Equal) toItem(self.contentView) attribute(NSLayoutAttribute.Leading) multiplier(1) constant(8));
      self.addConstraint(NSLayoutConstraint.constraintWithItem(self.textField) attribute(NSLayoutAttribute.Top) relatedBy(NSLayoutRelation.Equal) toItem(self.contentView) attribute(NSLayoutAttribute.Top) multiplier(1) constant(8));
      self.addConstraint(NSLayoutConstraint.constraintWithItem(self.textField) attribute(NSLayoutAttribute.Bottom) relatedBy(NSLayoutRelation.Equal) toItem(self.contentView) attribute(NSLayoutAttribute.Bottom) multiplier(1) constant(-8));
      self.addConstraint(NSLayoutConstraint.constraintWithItem(self.textField) attribute(NSLayoutAttribute.Trailing) relatedBy(NSLayoutRelation.Equal) toItem(self.contentView) attribute(NSLayoutAttribute.Trailing) multiplier(1) constant(-16));
      
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
    
  protected
  public
  

    property OnTextChanged:OnTextChangedDelegate;
    
  
    [IBOutlet]property textField:weak UITextField;
  
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
      self.textField:becomeFirstResponder;
    end;
    
  end;


end.
