namespace Moshine.UI.UIKit;

uses
  Foundation, UIKit,PureLayout.PureLayout;

type


  MoshineTableTableViewCell = public class(MoshineBaseTableCell,IUITableViewDelegate)
    
  protected
  
    method createControl:UIView; override;
    begin
      exit new UITableView;
    end;

  
    method setup; override;
    begin
      inherited setup;
      
      self.TableControl.delegate := self;
      
      var insets := new UIEdgeInsets;
      insets.top := 20.0;
      insets.left := 5.0;
      insets.bottom := 10.0;
      insets.right := 5.0;
      
      self.TableControl.autoPinEdgesToSuperviewEdgesWithInsets(insets);      
      
    end;
    
    method get_TableControl:UITableView;
    begin
      exit cellControl as UITableView;
    end;
    
  public
  
    
    method layoutSubviews; override;
    begin
      inherited layoutSubviews;
    end;
    
    property dataSource:IUITableViewDataSource write set_dataSource;
    
    property TableControl:weak UITableView read get_TableControl;
    
    method set_dataSource(value:IUITableViewDataSource);
    begin
      self.TableControl.dataSource := value;
    end;
    
  
  end;

end.
