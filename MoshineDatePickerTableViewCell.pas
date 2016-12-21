namespace Moshine.UI.UIKit;

uses
  Foundation, UIKit;

type

  [IBObject]
  MoshineDatePickerTableViewCell = public class(MoshineBaseTableViewCell)
  private
  protected
  
    method get_DatePicker:UIDatePicker;
    begin
      exit cellControl as UIDatePicker;
    end;
  
  public
  
    method createControl:UIView; override;
    begin
      exit new UIDatePicker;
    end;
  
    method setup; override;
    begin
      inherited setup;
      
    end;
    
    property DatePicker:UIDatePicker read get_DatePicker;
  
  end;

end.
