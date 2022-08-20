namespace Moshine.UI.UIKit;

uses
  UIKit;

type
  SearchUIViewControllerExtensions = public extension class(UIViewController)
  public

    method createSearchController(placeHolder:String) withTableView(someTableView:UITableView):UISearchController;
    begin
      var searchController := new UISearchController withSearchResultsController(nil);
      searchController.searchBar.placeholder := placeHolder;
      if(self is IUISearchControllerDelegate)then
      begin
        searchController.delegate := self as IUISearchControllerDelegate;
      end;
      if(self is IUISearchResultsUpdating)then
      begin
        searchController.searchResultsUpdater := self as IUISearchResultsUpdating;
      end;
      searchController.obscuresBackgroundDuringPresentation := false;

      if available("iOS 11.0") then
      begin
        self.navigationItem.searchController :=  searchController;
      end
      else
      begin
        someTableView.tableHeaderView := searchController.searchBar;
      end;

      exit searchController;

    end;
  end;

end.