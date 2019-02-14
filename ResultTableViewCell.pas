namespace Moshine.UI.UIKit;

uses
  RemObjects.Elements.RTL,
  ThirdParty,PureLayout,
  Moshine.UI.UIKit,
  UIKit;

type

  [IBObject]
  ResultTableViewCell = public class(UITableViewCell, IMKDropdownMenuDataSource, IMKDropdownMenuDelegate)
  private

    property menu:MKDropdownMenu;
    property label:UILabel;
    _nonPlaces : NSMutableArray<String> := new NSMutableArray<String>;

    _DSQ:Boolean;
    _DNF:Boolean;
    _DNS:Boolean;
    _RET:Boolean;
    _place:Integer;


    method setup;
    begin

      Place := 1;

      var width := 100;
      var height := 44;

      var primaryRect := CGRectMake(44, 0, 200, height);
      var emptyRect := CGRectMake(0,0,0,0);

      self.menu := new MKDropdownMenu WithFrame(emptyRect);
      self.menu.dataSource := self;
      self.menu.delegate := self;

      label := new UILabel withFrame(primaryRect);
      label.text := '';

      menu.autoSetDimensionsToSize(CGSizeMake(width,height));

      self.contentView.addSubview(label);
      self.contentView.addSubview(menu);

      self.menu.autoPinEdge(ALEdge.ALEdgeLeft) toEdge(ALEdge.ALEdgeRight) ofView(self.label) withOffset(10);
      self.menu.autoPinEdge(ALEdge.ALEdgeTop) toEdge(ALEdge.ALEdgeTop) ofView(self.label) withOffset(0);

      _nonPlaces.addObjectsFromArray(['DSQ','DNF','DNS','RET']);


    end;

    method ParseDropdownValue(value:String);
    begin

      ClearNonPlaced;

      case value of
        'DSQ': self.DSQ := true;
        'DNF' : self.DNF := true;
        'DNS' : self.DNS := true;
        'RET' : self.RET := true;
        else
        begin
          var potentialValue := Convert.TryToInt32(value);

          if(assigned(potentialValue))then
          begin
            self.Place := potentialValue;
          end;
        end;
      end;

    end;

    method valuesForDropdown(value:String):NSArray<String>;
    begin
      var newValues := new NSMutableArray<String>;

      if not Placed then
      begin
        newValues.addObject(NSString.stringWithFormat('%d',Place));
      end;

      for each nonPlace in _nonPlaces do
        begin
        if(value.compare(nonPlace) <> NSComparisonResult.OrderedSame)then
        begin
          newValues.addObject(nonPlace);
        end
      end;

      exit newValues;

    end;

    method ParseObject:String;
    begin
      var value:String := '';
      if (Placed)then
      begin
        value := NSString.stringWithFormat('%d',Place);
      end
      else
      begin
        if DSQ then
        begin
          value := 'DSQ';
        end
        else if DNF then
        begin
          value := 'DNF';
        end
        else if DNS then
        begin
          value := 'DNS';
        end
        else
        begin
          value := 'RET';
        end;
      end;
      exit value;

    end;

    method dropdownMenu(dropdownMenu: not nullable MKDropdownMenu) didSelectRow(row: NSInteger) inComponent(component: NSInteger);
    begin

      var selectedValue := valuesForDropdown(ParseObject)[row];

      ParseDropdownValue(selectedValue);

      DelayCallback(method begin
        dropdownMenu.closeAllComponentsAnimated(true);
        dropdownMenu.reloadAllComponents();

        if(assigned(ResultReceiver))then
        begin
          self.ResultReceiver.ValueChanged(self);
        end;

      end) forMilliseconds(500);


    end;


    method numberOfComponentsInDropdownMenu(dropdownMenu: not nullable MKDropdownMenu): NSInteger;
    begin
      exit 1;
    end;

    method dropdownMenu(dropdownMenu: not nullable MKDropdownMenu) numberOfRowsInComponent(component: NSInteger): NSInteger;
    begin
      exit self._nonPlaces.count;
    end;

    method dropdownMenu(dropdownMenu: not nullable MKDropdownMenu) titleForRow(row: NSInteger) forComponent(component: NSInteger): nullable NSString;
    begin
      var value := valuesForDropdown(ParseObject)[row];
      exit value;
    end;

    method dropdownMenu(dropdownMenu: not nullable MKDropdownMenu) titleForComponent(component: NSInteger): nullable NSString;
    begin
      var value := ParseObject;
      exit value;
    end;

    method ClearNonPlaced;
    begin
      _DSQ := false;
      _DNF := false;
      _DNS := false;
      _RET := false;
    end;



  public

    method initWithStyle(style: UITableViewCellStyle) reuseIdentifier(reuseIdentifier: NSString): InstanceType; override;
    begin

      self := inherited initWithStyle(style) reuseIdentifier(reuseIdentifier);
      if(assigned(self))then
      begin
        setup;
      end;

      exit self;

    end;

    method get_Placed:Boolean;
    begin
      exit not DSQ and not DNF and not DNS and not RET;
    end;

    property Placed:Boolean read get_Placed;

    property Entry:UILabel read label;

    method set_Place(value:Integer);
    begin
      _place := value;
    end;

    method set_DSQ(value:Boolean);
    begin
      _DSQ := value;
    end;

    method set_DNF(value:Boolean);
    begin
      _DNF := value;
    end;

    method set_DNS(value:Boolean);
    begin
      _DNS := value;
    end;

    method set_RET(value:Boolean);
    begin
      _RET := value;
    end;

    method reload;
    begin
      self.menu.reloadAllComponents;
    end;

    property Place:Integer read _place write set_Place;
    property DSQ:Boolean read _DSQ write set_DSQ;
    property DNF:Boolean read _DNF write set_DNF;
    property DNS:Boolean read _DNS write set_DNS;
    property RET:Boolean read _RET write set_RET;
    property ResultReceiver:IResultReceiver;


  end;

end.