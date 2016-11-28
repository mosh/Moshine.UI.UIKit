namespace Moshine.UI.UIKit;

uses
  Foundation, UIKit,PureLayout.PureLayout;

type


  MoshineTableTableViewCell = public class(UITableViewCell,IUITableViewDelegate)
  private
    
    _content:UITableView;
  
    method setup;
    begin
      self._content := new UITableView;
      self._content.delegate := self;
      //self._content.dataSource := self;
      
      self.detailTextLabel:hidden := true;
      self.contentView.viewWithTag(3):removeFromSuperview();
      self._content.tag := 3;
      self._content.translatesAutoresizingMaskIntoConstraints := false;
      self.contentView.addSubview(self._content);
      
      {
      self.addConstraint(NSLayoutConstraint.constraintWithItem(self._content) attribute(NSLayoutAttribute.Leading) relatedBy(NSLayoutRelation.Equal) toItem(self.contentView) attribute(NSLayoutAttribute.Leading) multiplier(1) constant(50));
      self.addConstraint(NSLayoutConstraint.constraintWithItem(self._content) attribute(NSLayoutAttribute.Top) relatedBy(NSLayoutRelation.Equal) toItem(self.contentView) attribute(NSLayoutAttribute.Top) multiplier(1) constant(8));
      self.addConstraint(NSLayoutConstraint.constraintWithItem(self._content) attribute(NSLayoutAttribute.Bottom) relatedBy(NSLayoutRelation.Equal) toItem(self.contentView) attribute(NSLayoutAttribute.Bottom) multiplier(1) constant(-8));
      self.addConstraint(NSLayoutConstraint.constraintWithItem(self._content) attribute(NSLayoutAttribute.Trailing) relatedBy(NSLayoutRelation.Equal) toItem(self.contentView) attribute(NSLayoutAttribute.Trailing) multiplier(1) constant(-16));
      }
      
      
      //self._content.autoCenterInSuperview( );
      
      var insets := new UIEdgeInsets;
      insets.top := 20.0;
      insets.left := 5.0;
      insets.bottom := 10.0;
      insets.right := 5.0;
      
      self._content.autoPinEdgesToSuperviewEdgesWithInsets(insets);      
      
    end;
    
    
  protected
  
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
    
    method layoutSubviews; override;
    begin
      inherited layoutSubviews;
    end;
    
    property dataSource:IUITableViewDataSource write set_dataSource;
    
    method set_dataSource(value:IUITableViewDataSource);
    begin
      self._content.dataSource := value;
    end;
    
  
  end;

end.
