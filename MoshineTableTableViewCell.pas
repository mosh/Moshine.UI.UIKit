namespace Moshine.UI.UIKit;

uses
  Foundation, UIKit,PureLayout.PureLayout;

type

  OnDetailSelectedDelegate = public block(indexPath: NSIndexPath);


  [IBObject]
  MoshineTableTableViewCell = public class(MoshineBaseTableViewCell,IUITableViewDelegate)
    
  protected
  
    method createControl:UIView; override;
    begin
      exit new UITableView;
    end;

  
    method setup; override;
    begin
      inherited setup;
      
      self.TableView.delegate := self;
      
      var insets := new UIEdgeInsets;
      insets.top := 20.0;
      insets.left := 5.0;
      insets.bottom := 10.0;
      insets.right := 5.0;
      
      self.TableView.autoPinEdgesToSuperviewEdgesWithInsets(insets);      
      
    end;
    
    method get_TableView:UITableView;
    begin
      exit cellControl as UITableView;
    end;
    
    method tableView(tableView: UITableView) accessoryButtonTappedForRowWithIndexPath(indexPath: NSIndexPath);
    begin
      if(assigned(DetailSelected))then
      begin
        DetailSelected(indexPath);
      end;
    end;

    
  public
  
    
    method layoutSubviews; override;
    begin
      inherited layoutSubviews;
    end;
    
    property dataSource:IUITableViewDataSource write set_dataSource;
    
    property TableView:weak UITableView read get_TableView;
    
    property DetailSelected:OnDetailSelectedDelegate;
    
    method set_dataSource(value:IUITableViewDataSource);
    begin
      self.TableView.dataSource := value;
    end;
    
  
  end;

end.
