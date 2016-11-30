namespace Moshine.UI.UIKit;

uses
  Foundation,UIKit;

type

  MoshineBaseTableViewCell = public abstract class(UITableViewCell)
  private
  protected
  
    property cellControl:UIView read private write;
  
    method createControl:UIView; abstract;
    
    method setup; virtual;
    begin
      self.detailTextLabel:hidden := true;
      self.cellControl := createControl;
      self.contentView.viewWithTag(3):removeFromSuperview();
      self.cellControl.tag := 3;
      self.cellControl.translatesAutoresizingMaskIntoConstraints := false;
      self.contentView.addSubview(self.cellControl);
      
      self.addConstraint(NSLayoutConstraint.constraintWithItem(self.cellControl) attribute(NSLayoutAttribute.Leading) relatedBy(NSLayoutRelation.Equal) toItem(self.contentView) attribute(NSLayoutAttribute.Leading) multiplier(1) constant(50));
      self.addConstraint(NSLayoutConstraint.constraintWithItem(self.cellControl) attribute(NSLayoutAttribute.Top) relatedBy(NSLayoutRelation.Equal) toItem(self.contentView) attribute(NSLayoutAttribute.Top) multiplier(1) constant(8));
      self.addConstraint(NSLayoutConstraint.constraintWithItem(self.cellControl) attribute(NSLayoutAttribute.Bottom) relatedBy(NSLayoutRelation.Equal) toItem(self.contentView) attribute(NSLayoutAttribute.Bottom) multiplier(1) constant(-8));
      self.addConstraint(NSLayoutConstraint.constraintWithItem(self.cellControl) attribute(NSLayoutAttribute.Trailing) relatedBy(NSLayoutRelation.Equal) toItem(self.contentView) attribute(NSLayoutAttribute.Trailing) multiplier(1) constant(-16));
      
    end;
    
  public
  
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
  
  end;

end.
