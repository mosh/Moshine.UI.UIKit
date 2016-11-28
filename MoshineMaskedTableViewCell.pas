namespace Moshine.UI.UIKit;

uses
  Foundation, UIKit;

type

  MoshineMaskedTableViewCell = public class(UITableViewCell,IUITextFieldDelegate)
  private
  
    method setup;
    begin
      self.detailTextLabel:hidden := true;
      self.MaskedTextField := new NGMaskedTextField;
      self.MaskedTextField.delegate := self;
      self.contentView.viewWithTag(3):removeFromSuperview();
      self.MaskedTextField.tag := 3;
      self.MaskedTextField.translatesAutoresizingMaskIntoConstraints := false;
      self.contentView.addSubview(self.MaskedTextField);
      
      self.addConstraint(NSLayoutConstraint.constraintWithItem(self.MaskedTextField) attribute(NSLayoutAttribute.Leading) relatedBy(NSLayoutRelation.Equal) toItem(self.contentView) attribute(NSLayoutAttribute.Leading) multiplier(1) constant(8));
      self.addConstraint(NSLayoutConstraint.constraintWithItem(self.MaskedTextField) attribute(NSLayoutAttribute.Top) relatedBy(NSLayoutRelation.Equal) toItem(self.contentView) attribute(NSLayoutAttribute.Top) multiplier(1) constant(8));
      self.addConstraint(NSLayoutConstraint.constraintWithItem(self.MaskedTextField) attribute(NSLayoutAttribute.Bottom) relatedBy(NSLayoutRelation.Equal) toItem(self.contentView) attribute(NSLayoutAttribute.Bottom) multiplier(1) constant(-8));
      self.addConstraint(NSLayoutConstraint.constraintWithItem(self.MaskedTextField) attribute(NSLayoutAttribute.Trailing) relatedBy(NSLayoutRelation.Equal) toItem(self.contentView) attribute(NSLayoutAttribute.Trailing) multiplier(1) constant(-16));
      
      self.MaskedTextField.textAlignment := NSTextAlignment.Left;
      
    end;
  
  protected
  public
    property MaskedTextField:weak NGMaskedTextField;
    
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
      self.MaskedTextField:becomeFirstResponder;
    end;
    
    method textField(textField: ^UITextField) shouldChangeCharactersInRange(range: NSRange) replacementString(string: NSString): Boolean;
    begin
      if MaskedTextField.isKindOfClass(NGMaskedTextField.class()) then
      begin
        exit NGMaskedTextField(MaskedTextField).shouldChangeCharactersInRange(range) replacementString(string);
      end
      else
      begin
        exit true;
      end;
    end;
    
  end;

end.
