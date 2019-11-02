namespace Moshine.UI.UIKit;

uses
  UIKit;

type
  UIViewControllerExtensions = public extension class(UIViewController)
  public

    method createSearchController(placeHolder:String) withTableView(someTableView:UITableView):UISearchController;
    begin
      var searchController := new UISearchController withSearchResultsController(nil);
      searchController.searchBar.placeholder := placeHolder;
      //searchController.delegate := self;
      //searchController.searchResultsUpdater := self;
      searchController.dimsBackgroundDuringPresentation := false;

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