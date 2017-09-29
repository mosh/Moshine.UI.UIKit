namespace SimpleApp2;

uses
  Foundation,
  UIKit;

type

  DateTimePicker = public class(UIView,
    IUITableViewDataSource, IUITableViewDelegate,IUICollectionViewDataSource, IUICollectionViewDelegate)
  private
    contentHeight: CGFloat := 310;

    _backgroundViewColor:UIColor := UIColor.clearColor;
    _highlightColor:UIColor := UIColor.colorWithRed(0/255.0) green(199.0/255.0) blue(194.0/255.0) alpha(1);
    _darkColor:UIColor := UIColor.colorWithRed(0) green(22.0/255.0) blue(39.0/255.0) alpha(1);

    didLayoutAtOnce:Boolean := false;
    _selectedDate:NSDate := new NSDate();
    _dateFormat:String := 'HH:mm dd/MM/YYYY';
    _cancelButtonTitle:String := 'Cancel';
    _todayButtonTitle:String := 'Today';
    _doneButtonTitle:String := 'DONE';
    _is12HourFormat:Boolean := false;
    _isDatePickerOnly:Boolean := false;

    hourTableView: UITableView;
    minuteTableView: UITableView;
    amPmTableView: UITableView;
    dayCollectionView: UICollectionView;

    shadowView: UIView;
    contentView: UIView;
    dateTitleLabel: UILabel;
    todayButton: UIButton;
    doneButton: UIButton;
    cancelButton: UIButton;
    colonLabel1: UILabel;
    colonLabel2: UILabel;

    borderTopView: UIView;
    borderBottomView: UIView;
    separatorTopView: UIView;
    separatorBottomView: UIView;



    method tableView(tableView: not nullable UITableView) didSelectRowAtIndexPath(indexPath: not nullable NSIndexPath);
    begin
      tableView.selectRowAtIndexPath(indexPath) animated(true) scrollPosition(UITableViewScrollPosition.Middle);

      if(tableView = hourTableView)then
      begin
        if is12HourFormat then
        begin
          var hour := (indexPath.row -12)mod 12 +1;
          var amPmIndexPath := amPmTableView.indexPathForSelectedRow;

          if ((amPmIndexPath.row = 1) and (hour < 12)) then
          begin
            hour := hour + 12;
          end
          else if ((amPmIndexPath.row = 0) and (hour = 12)) then
          begin
            hour := 0;
          end;

          components.hour := hour;
        end
        else
        begin
          components.hour := (indexPath.row-12)mod 24;
        end;
      end
      else if tableView = minuteTableView then
      begin
        components.minute := (indexPath.row-60) mod 60;
      end
      else if tableView = amPmTableView then
      begin
        var hour := components.hour;
        if ((indexPath.row = 0) and (hour >= 12)) then
        begin
          components.hour := hour - 12;
        end
        else if ((indexPath.row = 1) and (hour < 12)) then
        begin
          components.hour := hour + 12;
        end;

      end;

      var selected := calendar.dateFromComponents(components);

      if (selected.compare(minimumDate) = NSComparisonResult.OrderedAscending) then
      begin
        selectedDate := minimumDate;
        resetTime;
      end
      else
      begin
        selectedDate := selected;
      end;

    end;


    //
    // IUITableViewDataSource
    //


    method tableView(tableView: not nullable UITableView) cellForRowAtIndexPath(indexPath: not nullable NSIndexPath): not nullable UITableViewCell;
    begin
      var cell := tableView.dequeueReusableCellWithIdentifier('timeCell');

      if(not assigned(cell))then
      begin
        cell := new UITableViewCell withStyle(UITableViewCellStyle.Default) reuseIdentifier('timeCell');
      end;

      cell.selectedBackgroundView := new UIView();

      cell.textLabel.textAlignment := iif(tableView = hourTableView, NSTextAlignment.Right, NSTextAlignment.Left);
      cell.textLabel.font := UIFont.boldSystemFontOfSize(18);
      cell.textLabel.textColor := darkColor.colorWithAlphaComponent(0.4);
      cell.textLabel.highlightedTextColor := highlightColor;
      // add module operation to set value same
      if (tableView = amPmTableView) then
      begin
        cell.textLabel.text := iif(indexPath.row = 0, 'AM', 'PM');
      end
      else if tableView = minuteTableView then
      begin
        cell.textLabel.text := NSString.stringWithFormat('%02i', Integer(indexPath.row mod 60));
      end
      else
      begin

        if (is12HourFormat) then
        begin
          cell.textLabel.text := NSString.stringWithFormat('%02i', Integer(indexPath.row mod 12) + 1);
        end
        else
        begin
          cell.textLabel.text := NSString.stringWithFormat('%02i', Integer(indexPath.row mod 24));
        end;
      end;

      exit cell;

    end;


    method numberOfSectionsInTableView(tableView: not nullable UITableView): NSInteger;
    begin
      exit 1;
    end;

    method tableView(tableView: not nullable UITableView) numberOfRowsInSection(section: NSInteger): NSInteger;
    begin
      if tableView = hourTableView then
      begin
        // need triple of origin storage to scroll infinitely
        exit iif(is12HourFormat, 12, 24) * 3;
      end
      else if tableView = amPmTableView then
      begin
        exit 2;
      end;

      // need triple of origin storage to scroll infinitely
      exit 60 * 3;


    end;



    //
    //
    //

    method scrollViewDidScroll(scrollView: UIScrollView);
    begin
      if ((scrollView <> dayCollectionView) and (scrollView <> amPmTableView))then
      begin
        exit;
      end;


      var totalHeight := scrollView.contentSize.height;
      var visibleHeight := totalHeight / 3.0;
      if ((scrollView.contentOffset.y < visibleHeight) or (scrollView.contentOffset.y > visibleHeight + visibleHeight)) then
      begin
        var positionValueLoss := scrollView.contentOffset.y - CGFloat(Integer(scrollView.contentOffset.y));
        var heightValueLoss := visibleHeight - CGFloat(Integer(visibleHeight));
        var modifiedPositionY := CGFloat(Integer( scrollView.contentOffset.y ) mod Integer( visibleHeight ) + Integer( visibleHeight )) - positionValueLoss - heightValueLoss;
        var newOffset := CGPointMake(scrollView.contentOffset.x,modifiedPositionY);
        //scrollView.contentOffset := newOffset;

      end;

    end;

    //
    // IUICollectionViewDelegate
    //

    method collectionView(collectionView: not nullable UICollectionView) didSelectItemAtIndexPath(indexPath: not nullable NSIndexPath);
    begin

      var cell := collectionView.cellForItemAtIndexPath(indexPath);

      // workaround to center to every cell including ones near margins
      if(assigned(cell))then
      begin
        var offset := CGPointMake(cell.center.x - collectionView.frame.size.width / 2, 0);
        collectionView.setContentOffset(offset) animated(true);
      end;

      // update selected dates
      var date := dates[indexPath.item];
      var unitFlags := NSCalendarUnit.YearCalendarUnit or NSCalendarUnit.MonthCalendarUnit or NSCalendarUnit.DayCalendarUnit;
      var dayComponents := calendar.components(unitFlags) fromDate(date);

      components.day := dayComponents.day;
      components.month := dayComponents.month;
      components.year := dayComponents.year;

      var selected := calendar.dateFromComponents(components);

      if(assigned(selected))then
      begin

        if (selected.compare(minimumDate) = NSComparisonResult.OrderedAscending)then
        begin
          selectedDate := minimumDate;
          resetTime;
        end
        else
        begin
          selectedDate := selected;
        end;

      end;

    end;

    //
    //
    //


    //
    // IUICollectionViewDataSource
    //

    method collectionView(collectionView: not nullable UICollectionView) numberOfItemsInSection(section: NSInteger): NSInteger;
    begin
      exit dates.count;
    end;

    method numberOfSectionsInCollectionView(collectionView: not nullable UICollectionView): NSInteger;
    begin
      exit 1;
    end;




    method collectionView(collectionView: not nullable UICollectionView) cellForItemAtIndexPath(indexPath: not nullable NSIndexPath): Dynamic<UICollectionViewCell>;
    begin
      var cell := collectionView.dequeueReusableCellWithReuseIdentifier('dateCell') forIndexPath(indexPath) as DateCollectionViewCell;

      var date := dates[indexPath.item];

      cell.populateItem(date, highlightColor, darkColor);

      exit cell;

    end;




    method scrollViewDidEndDecelerating(scrollView: UIScrollView);
    begin
      alignScrollView(scrollView);
    end;

    method scrollViewDidEndDragging(scrollView: UIScrollView) willDecelerate(decelerate: Boolean);
    begin
      if (not decelerate) then
      begin
        alignScrollView(scrollView);
      end;

    end;



    method alignScrollView(scrollView:UIScrollView);
    begin
      if scrollView is UICollectionView then
      begin
        var collectionView := scrollView as UICollectionView;
        var centerPoint := CGPointMake(collectionView.center.x + collectionView.contentOffset.x, 50);
        var indexPath := collectionView.indexPathForItemAtPoint(centerPoint);
        if(assigned(indexPath)) then
        begin
          // automatically select this item and center it to the screen
          // set animated = false to avoid unwanted effects
          collectionView.selectItemAtIndexPath(indexPath) animated(true) scrollPosition(UICollectionViewScrollPosition.Top);
          var cell := collectionView.cellForItemAtIndexPath(indexPath);
          if(assigned(cell))then
          begin
            var offset := CGPointMake(cell.center.x - collectionView.frame.size.width / 2, 0);
            collectionView.setContentOffset(offset) animated(false);
          end;

          // update selected date

          var date := dates[indexPath.item];

          var unitFlags := NSCalendarUnit.MonthCalendarUnit or NSCalendarUnit.DayCalendarUnit or NSCalendarUnit.YearCalendarUnit;
          var dayComponents := calendar.components(unitFlags) fromDate(date);

          components.day := dayComponents.day;
          components.month := dayComponents.month;
          components.year := dayComponents.year;

          var selected := calendar.dateFromComponents(components);

          if (selected.compare(minimumDate) = NSComparisonResult.OrderedDescending) then
          begin
            selectedDate := minimumDate;
            resetTime;
          end
          else
          begin
            selectedDate := selected;
          end;



        end;

      end
      else if (scrollView is UITableView) then
      begin
        var tableView := scrollView as UITableView;
        var relativeOffset := CGPointMake(0, tableView.contentOffset.y + tableView.contentInset.top);
        // change row from var to let
        var row := round(relativeOffset.y / tableView.rowHeight);

        if ((tableView = amPmTableView) and (row > 1))then
        begin
          row := 1;
        end;

        tableView.selectRowAtIndexPath(NSIndexPath.indexPathForRow(Integer(row)) inSection(0)) animated(true) scrollPosition(UITableViewScrollPosition.Middle);

        // add 24 to hour and 60 to minute, because datasource now has buffer at top and bottom.
        if (tableView = hourTableView) then
        begin
          if is12HourFormat then
          begin
            var hour := Integer(row - 12) mod 12 + 1;
            var amPmIndexPath := amPmTableView.indexPathForSelectedRow;
            if((amPmIndexPath.row = 1) and (hour < 12))then
            begin
              hour := hour +12;
            end
            else if ((amPmIndexPath.row = 0) and (hour=12))then
            begin
              hour := 0;
            end;
            components.hour := hour;
          end
          else
          begin
            components.hour := Integer(row - 24) mod 24;
          end;
        end
        else if (tableView = minuteTableView)then
        begin
          components.minute := Integer(row - 60) mod 60;

        end
        else if (tableView = amPmTableView)then
        begin
          var hour := components.hour;
          if ((row = 0) and (hour >= 12)) then
          begin
            components.hour := hour - 12;
          end
          else if ((row = 1) and (hour < 12)) then
          begin
            components.hour := hour + 12;
          end;

        end;

        var selected := calendar.dateFromComponents(components);
        if(assigned(selected))then
        begin
          if (selected.compare(minimumDate) = NSComparisonResult.OrderedAscending)then
          begin
            selectedDate := minimumDate;
            resetTime;
          end
          else
          begin
            selectedDate := selected;
          end;

        end;

      end;

    end;

    //
    //
    //


  protected

  public

    property backgroundViewColor:UIColor read _backgroundViewColor write set_backgroundViewColor;

    method set_backgroundViewColor(value:UIColor);
    begin
      self.
      _backgroundViewColor:=value;
      shadowView.backgroundColor := _backgroundViewColor;
    end;

    property highlightColor:UIColor read _highlightColor write set_highlightColor;

    method set_highlightColor(value:UIColor);
    begin
      _highlightColor:=value;
      todayButton.setTitleColor(_highlightColor) forState(UIControlState.Normal);

      colonLabel1.textColor := _highlightColor;
      colonLabel2.textColor := _highlightColor;
    end;

    property darkColor:UIColor read _darkColor write set_darkColor;

    method set_darkColor(Value:UIColor);
    begin
      _darkColor := Value;
      dateTitleLabel.textColor := _darkColor;
      cancelButton.setTitleColor(darkColor.colorWithAlphaComponent(0.5)) forState(UIControlState.Normal);
      doneButton.backgroundColor := darkColor.colorWithAlphaComponent(0.5);
      borderTopView.backgroundColor := darkColor.colorWithAlphaComponent(0.2);
      borderBottomView.backgroundColor := darkColor.colorWithAlphaComponent(0.2);
      separatorTopView.backgroundColor := darkColor.colorWithAlphaComponent(0.2);
      separatorBottomView.backgroundColor := darkColor.colorWithAlphaComponent(0.2);

    end;

    var daysBackgroundColor:UIColor := UIColor.colorWithRed(239.0 /255.0) green(243.0/255.0) blue(244.0/255.0) alpha(1);


    method layoutSubviews;override;
    begin
      inherited layoutSubviews;

      // For the first time view will be layouted manually before show
      // For next times we need relayout it because of screen rotation etc.
      if not didLayoutAtOnce then
      begin
        didLayoutAtOnce := true;
      end
      else
      begin
        self.configureView();
      end;
    end;

    property selectedDate:NSDate read _selectedDate write set_selectedDate;

    method set_selectedDate(Value:NSDate);
    begin
      _selectedDate := Value;
      resetDateTitle;
    end;


    property dateFormat:String read _dateFormat write set_dateFormat;

    method set_dateFormat(Value:String);
    begin
      _dateFormat:=Value;
      resetDateTitle;
    end;

    property cancelButtonTitle:String read _cancelButtonTitle write set_cancelButtonTitle;

    method set_cancelButtonTitle(Value:String);
    begin
      _cancelButtonTitle := Value;
      cancelButton.setTitle(cancelButtonTitle) forState(UIControlState.Normal);
      var size := cancelButton.sizeThatFits(CGSizeMake(0, 44.0)).width + 20.0;
      cancelButton.frame := CGRectMake(0, 0, size, 44);
    end;

    property todayButtonTitle:String read _todayButtonTitle write set_todayButtonTitle;

    method set_todayButtonTitle(value:String);
    begin
      _todayButtonTitle := value;

      todayButton.setTitle(todayButtonTitle) forState(UIControlState.Normal);
      var size := todayButton.sizeThatFits(CGSizeMake(0, 44.0)).width + 20.0;
      todayButton.frame := CGRectMake(contentView.frame.size.width - size, 0, size, 44);
    end;

    property doneButtonTitle:String read _doneButtonTitle write set_doneButtonTitle;

    method set_doneButtonTitle(Value:String);
    begin
      _doneButtonTitle := Value;
      doneButton.setTitle(doneButtonTitle) forState(UIControlState.Normal);
    end;

    property is12HourFormat:Boolean read _is12HourFormat write set_is12HourFormat;

    method set_is12HourFormat(value:Boolean);
    begin
      _is12HourFormat:= value;
      configureView;
    end;

    property isDatePickerOnly:Boolean read _isDatePickerOnly write set_isDatePickerOnly;

    method set_isDatePickerOnly(value:Boolean);
    begin
      _isDatePickerOnly := value;
      configureView;
    end;

    timeZone:TimeZone := NSTimeZone.localTimeZone;

    property completionHandler:block(value:NSDate);
    property dismissHandler:block;


    var minimumDate: NSDate;
    var maximumDate: NSDate;

    calendar: Calendar := NSCalendar.currentCalendar;

    dates := new NSMutableArray<NSDate>;

    _components:NSDateComponents;

    property components:NSDateComponents read _components write set_components;

    method set_components(Value:NSDateComponents);
    begin
      _components := Value;
      _components.timeZone := timeZone;
    end;

    class method show(selected:nullable NSDate := nil; minimumDate: nullable NSDate := nil; maximumDate:nullable NSDate := nil):DateTimePicker;
    begin
      var dateTimePicker := new DateTimePicker();

      dateTimePicker.minimumDate := iif(minimumDate = nil, new NSDate WithTimeIntervalSinceNow(-3600 * 24 * 365 * 20), minimumDate);
      dateTimePicker.maximumDate := iif(maximumDate = nil, new NSDate withTimeIntervalSinceNow(3600 * 24 * 365 * 20), maximumDate);
      dateTimePicker.selectedDate := iif(selected = nil, dateTimePicker.minimumDate,selected);

      assert(dateTimePicker.minimumDate.compare(dateTimePicker.maximumDate)=NSComparisonResult.OrderedAscending,'Minimum date should be earlier than maximum date');
      assert(dateTimePicker.minimumDate.compare(dateTimePicker.selectedDate) <> NSComparisonResult.OrderedDescending,'Selected date should be later or equal to minimum date');
      assert(dateTimePicker.selectedDate.compare(dateTimePicker.maximumDate) <> NSComparisonResult.OrderedDescending,'Selected date should be earlier or equal to maximum date');

      dateTimePicker.configureView;
      UIApplication.sharedApplication.keyWindow.addSubview(dateTimePicker);

      exit dateTimePicker;


    end;


    /* private */

    method configureView;
    begin

      if assigned(self.contentView) then
      begin
        self.contentView.removeFromSuperview;
      end;

      var screenSize := UIScreen.mainScreen.bounds.size;
      self.frame := CGRectMake(0,0,screenSize.width,screenSize.height);


      // shadow view
      shadowView := new UIView withFrame(CGRectMake(0,0,frame.size.width,frame.size.height));

      shadowView.backgroundColor := iif(assigned(backgroundColor), backgroundViewColor, UIColor.blackColor.colorWithAlphaComponent(0.3));
      shadowView.alpha := 1;


      var shadowViewTap :=  new UITapGestureRecognizer withTarget(self) action(selector(dismissView:));

      shadowView.addGestureRecognizer(shadowViewTap);
      addSubview(shadowView);

      // content view
      contentHeight := iif(isDatePickerOnly, 208, 310);

      contentView := new UIView withFrame(CGRectMake(0,frame.size.height,frame.size.width,contentHeight));

      contentView.layer.shadowColor := UIColor.colorWithWhite(0) alpha(0.3).CGColor;
      contentView.layer.shadowOffset := CGSizeMake(0, -2.0);
      contentView.layer.shadowRadius := 1.5;
      contentView.layer.shadowOpacity := 0.5;
      contentView.backgroundColor := UIColor.whiteColor;
      contentView.hidden := true;
      addSubview(contentView);

      // title view
      var titleView := new UIView withFrame(CGRectMake(0,0,contentView.frame.size.width, 44));
      titleView.backgroundColor := UIColor.whiteColor;
      contentView.addSubview(titleView);

      dateTitleLabel := new UILabel withFrame( CGRectMake(0, 0, 200, 44));

      dateTitleLabel.font := UIFont.systemFontOfSize(15);
      dateTitleLabel.textColor := darkColor;
      dateTitleLabel.textAlignment := NSTextAlignment.Center;
      resetDateTitle();
      titleView.addSubview(dateTitleLabel);

      cancelButton := UIButton.buttonWithType(UIKit.UIButtonType.System);

      cancelButton.setTitle(cancelButtonTitle) forState(UIControlState.Normal);
      cancelButton.setTitleColor(darkColor.colorWithAlphaComponent(0.5)) forState(UIControlState.Normal);
      cancelButton.addTarget(self) action(selector(dismissView:)) forControlEvents(UIControlEvents.TouchUpInside);
      cancelButton.titleLabel.font := UIFont.boldSystemFontOfSize(15);
      var cancelSize := cancelButton.sizeThatFits(CGSizeMake(0, 44.0)).width + 20.0;
      cancelButton.frame := CGRectMake(0, 0, cancelSize, 44);
      titleView.addSubview(cancelButton);


      todayButton := UIButton.buttonWithType(UIButtonType.System);
      todayButton.setTitle(todayButtonTitle) forState(UIControlState.Normal);
      todayButton.setTitleColor(highlightColor) forState(UIControlState.Normal);
      todayButton.addTarget(self) action(selector(setToday)) forControlEvents(UIControlEvents.TouchUpInside);
      todayButton.titleLabel.font := UIFont.boldSystemFontOfSize(15);

      todayButton.hidden := (self.minimumDate.compare(new NSDate()) = NSComparisonResult.OrderedDescending) or (self.maximumDate.compare(new NSDate()) = NSComparisonResult.OrderedAscending);
      var todaySize := todayButton.sizeThatFits(CGSizeMake(0, 44.0)).width + 20.0;
      todayButton.frame := CGRectMake(contentView.frame.size.width - todaySize, 0, todaySize, 44);
      titleView.addSubview(todayButton);

      // day collection view
      var layout := new StepCollectionViewFlowLayout();
      layout.scrollDirection := UICollectionViewScrollDirection.Horizontal;
      layout.minimumInteritemSpacing := 10;
      layout.sectionInset := UIEdgeInsetsMake(10, 0, 10, 0);
      layout.itemSize := CGSizeMake(75, 80);

      dayCollectionView := new UICollectionView withFrame(CGRectMake(0, 44, contentView.frame.size.width, 100)) collectionViewLayout(layout);
      dayCollectionView.backgroundColor := daysBackgroundColor;
      dayCollectionView.showsHorizontalScrollIndicator := false;
      dayCollectionView.registerClass(DateCollectionViewCell.class) forCellWithReuseIdentifier('dateCell');
      dayCollectionView.dataSource := self;
      dayCollectionView.delegate := self;

      var inset := (dayCollectionView.frame.size.width - 75) / 2;

      dayCollectionView.contentInset := UIEdgeInsetsMake(0, inset, 0, inset);
      contentView.addSubview(dayCollectionView);

      // top & bottom borders on day collection view
      borderTopView := new UIView withFrame(CGRectMake(0, titleView.frame.size.height, titleView.frame.size.width, 1));
      borderTopView.backgroundColor := darkColor.colorWithAlphaComponent(0.2);
      contentView.addSubview(borderTopView);

      borderBottomView := new UIView withFrame(CGRectMake(0, dayCollectionView.frame.origin.y + dayCollectionView.frame.size.height, titleView.frame.size.width, 1));
      borderBottomView.backgroundColor := darkColor.colorWithAlphaComponent(0.2);
      contentView.addSubview(borderBottomView);

      // done button
      doneButton := UIButton.buttonWithType(UIButtonType.System);
      doneButton.frame := CGRectMake(10, contentView.frame.size.height - 10 - 44, contentView.frame.size.width - 20, 44);
      doneButton.setTitle(doneButtonTitle) forState(UIControlState.Normal);
      doneButton.setTitleColor(UIColor.whiteColor) forState(UIControlState.Normal);
      doneButton.backgroundColor := darkColor.colorWithAlphaComponent(0.5);
      doneButton.titleLabel.font := UIFont.boldSystemFontOfSize(13);
      doneButton.layer.cornerRadius := 3;
      doneButton.layer.masksToBounds := true;
      doneButton.addTarget(self) action(selector(dismissView:)) forControlEvents(UIControlEvents.TouchUpInside);
      contentView.addSubview(doneButton);

      // if time picker format is 12 hour, we'll need an extra tableview for am/pm
      // the width for this tableview will be 60, so we need extra -30 for x position of hour & minute tableview
      var extraSpace: CGFloat := iif(is12HourFormat, -30, 0);
      // hour table view
      hourTableView := new UITableView withFrame(CGRectMake(contentView.frame.size.width / 2 - 60 + extraSpace, borderBottomView.frame.origin.y + 2,
        60, doneButton.frame.origin.y - borderBottomView.frame.origin.y - 10));

      hourTableView.rowHeight := 36;
      hourTableView.contentInset := UIEdgeInsetsMake(hourTableView.frame.size.height / 2, 0, hourTableView.frame.size.height / 2, 0);
      hourTableView.showsVerticalScrollIndicator := false;
      hourTableView.separatorStyle := UITableViewCellSeparatorStyle.None;
      hourTableView.delegate := self;
      hourTableView.dataSource := self;
      hourTableView.hidden := isDatePickerOnly;
      contentView.addSubview(hourTableView);

      // minute table view
      minuteTableView := new UITableView withFrame(
        CGRectMake(contentView.frame.size.width / 2 + extraSpace,
          borderBottomView.frame.origin.y + 2,
          60,
          doneButton.frame.origin.y - borderBottomView.frame.origin.y - 10));

      minuteTableView.rowHeight := 36;
      minuteTableView.contentInset := UIEdgeInsetsMake(minuteTableView.frame.size.height / 2, 0, minuteTableView.frame.size.height / 2, 0);
      minuteTableView.showsVerticalScrollIndicator := false;
      minuteTableView.separatorStyle := UITableViewCellSeparatorStyle.None;
      minuteTableView.delegate := self;
      minuteTableView.dataSource := self;
      minuteTableView.hidden := isDatePickerOnly;
      contentView.addSubview(minuteTableView);

      // am/pm table view
      amPmTableView := new UITableView withFrame(CGRectMake(contentView.frame.size.width / 2 - extraSpace, borderBottomView.frame.origin.y + 2, 64, doneButton.frame.origin.y - borderBottomView.frame.origin.y - 10));
      amPmTableView.rowHeight := 36;
      amPmTableView.contentInset := UIEdgeInsetsMake(amPmTableView.frame.size.height / 2, 0, amPmTableView.frame.size.height / 2, 0);
      amPmTableView.showsVerticalScrollIndicator := false;
      amPmTableView.separatorStyle := UITableViewCellSeparatorStyle.None;
      amPmTableView.delegate := self;
      amPmTableView.dataSource := self;
      amPmTableView.hidden  := not is12HourFormat or isDatePickerOnly;
      contentView.addSubview(amPmTableView);


      // colon
      colonLabel1 := new UILabel withFrame(CGRectMake(0, 0, 10, 36));
      colonLabel1.center := CGPointMake(contentView.frame.size.width / 2 + extraSpace, (doneButton.frame.origin.y - borderBottomView.frame.origin.y - 10) / 2 + borderBottomView.frame.origin.y);
      colonLabel1.text := ':';
      colonLabel1.font := UIFont.boldSystemFontofSize(18);
      colonLabel1.textColor := highlightColor;
      colonLabel1.textAlignment := NSTextAlignment.Center;
      colonLabel1.hidden := isDatePickerOnly;
      contentView.addSubview(colonLabel1);

      colonLabel2 := new UILabel withFrame(CGRectMake(0, 0, 10, 36));
      colonLabel2.text := ':';
      colonLabel2.font := UIFont.boldSystemFontOfSize(18);
      colonLabel2.textColor := highlightColor;
      colonLabel2.textAlignment := NSTextAlignment.Center;
      var colon2Center := colonLabel1.center;
      colon2Center.x := colon2Center.x + 57;
      colonLabel2.center := colon2Center;
      colonLabel2.hidden := not is12HourFormat or isDatePickerOnly;
      contentView.addSubview(colonLabel2);

      // time separators
      separatorTopView := new UIView withFrame(CGRectMake(0, 0, 90 - extraSpace * 2, 1));
      separatorTopView.backgroundColor := darkColor.colorWithAlphaComponent(0.2);
      separatorTopView.center := CGPointMake(contentView.frame.size.width / 2, borderBottomView.frame.origin.y + 36);
      separatorTopView.hidden := isDatePickerOnly;
      contentView.addSubview(separatorTopView);

      separatorBottomView := new UIView withFrame(CGRectMake(0, 0, 90 - extraSpace * 2, 1));
      separatorBottomView.backgroundColor := darkColor.colorWithAlphaComponent(0.2);
      separatorBottomView.center := CGPointMake(contentView.frame.size.width / 2, separatorTopView.frame.origin.y + 36);
      separatorBottomView.hidden := isDatePickerOnly;
      contentView.addSubview(separatorBottomView);

      // fill date
      fillDates(minimumDate, maximumDate);
      updateCollectionView(selectedDate);

      var formatter := new DateFormatter();
      formatter.dateFormat := 'dd/MM/YYYY';

      for i:Integer :=0 to dates.count-1 do
      begin
        var date := dates[i];

        if formatter.stringFromDate(date) = formatter.stringFromDate(selectedDate) then
        begin

          var itemPath := NSIndexPath.indexPathForRow(i) inSection(0);
          dayCollectionView.selectItemAtIndexPath(itemPath) animated(true) scrollPosition(UICollectionViewScrollPosition.CenteredHorizontally);
          break
        end;
      end;



      var unitFlags := NSCalendarUnit.YearCalendarUnit or NSCalendarUnit.MonthCalendarUnit or NSCalendarUnit.DayCalendarUnit or NSCalendarUnit.HourCalendarUnit or NSCalendarUnit.MinuteCalendarUnit;
      components := calendar.components(unitFlags) fromDate(selectedDate);

      contentView.hidden := false;

      resetTime;

      // animate to show contentView
      UIView.animateWithDuration(0.3) delay(0) usingSpringWithDamping(0.8) initialSpringVelocity(0.4) options(UIViewAnimationOptions.CurveEaseIn) animations(method begin
          self.contentView.frame := CGRectMake(0,self.frame.size.height - self.contentHeight, self.frame.size.width,self.contentHeight);
        end) completion(method begin
          end);

    end;

    method setToday;
    begin
      selectedDate := NSDate.date;
      resetTime();
    end;

    method resetTime;
    begin

      var unitFlags := NSCalendarUnit.YearCalendarUnit or NSCalendarUnit.MonthCalendarUnit or NSCalendarUnit.DayCalendarUnit or NSCalendarUnit.HourCalendarUnit or NSCalendarUnit.MinuteCalendarUnit;
      components := calendar.components(unitFlags) fromDate(selectedDate);

      updateCollectionView(selectedDate);
      var hour := components.hour;

      if(true)then
      begin
        var expectedRow := hour + 24;
        if (is12HourFormat) then
        begin
          if (hour < 12) then
          begin
            expectedRow := hour + 11;
          end
          else
          begin
            expectedRow := hour -1;
          end;
          // workaround to fix issue seleting row when hour 12 am/pm
          if (expectedRow = 11)then
          begin
            expectedRow := 23;
          end;
        end;

        hourTableView.selectRowAtIndexPath(NSIndexPath.indexPathForRow(expectedRow) inSection(0)) animated(true) scrollPosition(UITableViewScrollPosition.Middle);
        if (hour >= 12)then
        begin
          amPmTableView.selectRowAtIndexPath(NSIndexPath.indexPathForRow(1) inSection(0)) animated(true) scrollPosition(UITableViewScrollPosition.Middle);
        end
        else
        begin
          amPmTableView.selectRowAtIndexPath(NSIndexPath.indexPathForRow(0) inSection(0)) animated(true) scrollPosition(UITableViewScrollPosition.Middle);
        end;

      end;

      var minute := components.minute;
      if(true)then
      begin
        var expectedRow := iif(minute=0,120,minute+60); // workaround for issue when minute = 0
        minuteTableView.selectRowAtIndexPath(NSIndexPath.indexPathForRow(expectedRow) inSection(0)) animated(true) scrollPosition(UITableViewScrollPosition.Middle);
      end;

    end;

    method resetDateTitle;
    begin
      if (assigned(dateTitleLabel))then
      begin
        var formatter := new NSDateFormatter;
        formatter.dateFormat := dateFormat;
        dateTitleLabel.text := formatter.stringFromDate(selectedDate);
        dateTitleLabel.sizeToFit;
        dateTitleLabel.center := CGPointMake(contentView.frame.size.width/2,22);

      end;

    end;

    method fillDates(fromDate:NSDate; toDate:NSDate);
    begin

      var localDates := new NSMutableArray<NSDate>;
      var days := new DateComponents;

      var dayCount := 0;

      loop
      begin
        days.day := dayCount;
        dayCount := dayCount+1;
        var date := calendar.dateByAddingComponents(days) toDate(fromDate) options(0);
        if(not assigned(date))then
        begin
          break;
        end;

        if (date.compare(toDate) = NSComparisonResult.OrderedDescending)then
        begin
          break;
        end;
        localDates.addObject(date);
      end;

      self.dates := localDates;
      dayCollectionView.reloadData;

      var &index := self.dates.indexOfObject(selectedDate);
      dayCollectionView.selectItemAtIndexPath(NSIndexPath.indexPathForRow(&index) inSection(0)) animated(true) scrollPosition(UICollectionViewScrollPosition.CenteredHorizontally);

    end;

    method updateCollectionView(currentDate:NSDate);
    begin
      var formatter := new DateFormatter;
      formatter.dateFormat := 'dd/MM/YYYY';
      for i:Integer := 0 to dates.count-1 do
      begin
        var date := dates[i];
        if (formatter.stringFromDate(date) = formatter.stringFromDate(currentDate))then
        begin
          var indexPath := NSIndexPath.indexPathForRow(i) inSection(0);
          dayCollectionView.scrollToItemAtIndexPath(indexPath) atScrollPosition(UICollectionViewScrollPosition.CenteredHorizontally) animated(true);

          var delayInSeconds: Double := 0.5;
          var popTime: dispatch_time_t := dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * NSEC_PER_SEC));
          dispatch_after(popTime, dispatch_get_main_queue(), () -> begin
            self.dayCollectionView.selectItemAtIndexPath(indexPath) animated(true) scrollPosition(UICollectionViewScrollPosition.CenteredHorizontally);
          end);

          break;
        end;
      end;

    end;

    method dismissView(sender:UIButton);
    begin
      UIView.animateWithDuration(0.3) animations(method begin
          // animate to show contentview
          self.contentView.frame := CGRectMake(0, self.frame.size.height, self.frame.size.width, self.contentHeight);

        end) completion(method begin

            if(assigned(self))then
            begin
              if (sender = self.doneButton)then
              begin
                if(assigned(self.completionHandler))then
                begin
                  self:completionHandler(self.selectedDate);
                end;
              end
              else
              begin
                if(assigned(self.dismissHandler))then
                begin
                  self:dismissHandler;
                end;
              end;
              self.removeFromSuperview;
            end;
          end);
    end;

  end;

end.