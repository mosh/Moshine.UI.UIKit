namespace Moshine.UI.UIKit;

uses
  Foundation, UIKit;

type

  [IBObject]
  MoshineDatePickerTableViewCell = public class(MoshineBaseTableViewCell)

  public

    method createControl:UIView; override;
    begin
      exit new UIDatePicker;
    end;

    method setup; override;
    begin
      inherited setup;

    end;

    property DatePicker:UIDatePicker read begin
      exit cellControl as UIDatePicker;
    end;

  end;

end.