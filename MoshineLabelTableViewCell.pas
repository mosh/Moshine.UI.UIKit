namespace Moshine.UI.UIKit;

uses
  Foundation, UIKit;

type

  [IBObject]
  MoshineLabelTableViewCell = public class(UITableViewCell)
  private
  
    method setup;
    begin
      self.detailTextLabel:hidden := true;
      self.textLabel := new UILabel;
      self.contentView.viewWithTag(3):removeFromSuperview();
      self.textLabel.tag := 3;
      self.textLabel.translatesAutoresizingMaskIntoConstraints := false;
      self.contentView.addSubview(self.textLabel);
      
      self.addConstraint(NSLayoutConstraint.constraintWithItem(self.textLabel) attribute(NSLayoutAttribute.Leading) relatedBy(NSLayoutRelation.Equal) toItem(self.contentView) attribute(NSLayoutAttribute.Leading) multiplier(1) constant(50));
      self.addConstraint(NSLayoutConstraint.constraintWithItem(self.textLabel) attribute(NSLayoutAttribute.Top) relatedBy(NSLayoutRelation.Equal) toItem(self.contentView) attribute(NSLayoutAttribute.Top) multiplier(1) constant(8));
      self.addConstraint(NSLayoutConstraint.constraintWithItem(self.textLabel) attribute(NSLayoutAttribute.Bottom) relatedBy(NSLayoutRelation.Equal) toItem(self.contentView) attribute(NSLayoutAttribute.Bottom) multiplier(1) constant(-8));
      self.addConstraint(NSLayoutConstraint.constraintWithItem(self.textLabel) attribute(NSLayoutAttribute.Trailing) relatedBy(NSLayoutRelation.Equal) toItem(self.contentView) attribute(NSLayoutAttribute.Trailing) multiplier(1) constant(-16));
      
      self.textLabel.textAlignment := NSTextAlignment.Left;
      
    end;
  
  protected
  public
  
    [IBOutlet]property textLabel:weak UILabel; override;
  
  
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
      self.textLabel:becomeFirstResponder;
    end;
  
  end;

end.
