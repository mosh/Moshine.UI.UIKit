namespace Moshine.UI.UIKit;

uses
  Foundation,UIKit,PureLayout.PureLayout;

type

  [IBObject]
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
      
      var insets := new UIEdgeInsets;
      insets.top := 8.0;
      insets.left := 16.0;
      insets.bottom := 8.0;
      insets.right := 16.0;
      
      self.cellControl.autoPinEdgesToSuperviewEdgesWithInsets(insets);      
      
      
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
