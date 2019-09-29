namespace Moshine.UI.UIKit;

uses
  Foundation, UIKit;

type

  OnDateChangedDelegate = public block(value:NSDate);


  [IBObject]
  MoshineDatePickerTableViewCell = public class(MoshineBaseTableViewCell)



  public

    property OnDateChanged:OnDateChangedDelegate;


    method valueChanged(sender:UIDatePicker);
    begin
      if(assigned(OnDateChanged))then
      begin
        OnDateChanged(sender.date);
      end;
    end;

    method createControl:UIView; override;
    begin
      var newPicker := new UIDatePicker;
      newPicker.addTarget(self) action(selector(valueChanged:)) forControlEvents(UIControlEvents.ValueChanged);
      exit newPicker;
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