unit FMX.CalendarHolidayDays.Style;

interface

uses
  System.UITypes, FMX.Calendar, FMX.Calendar.Style, FMX.Controls.Model, FMX.Presentation.Messages, FMX.Controls.Presentation,
  FMX.ListBox,
  {$IFDEF DEBUG}
  {$IFDEF MSWINDOWS}
  Winapi.Windows,
  {$ENDIF MSWINDOWS}
  {$ENDIF}
  System.Classes;

type

  TStyledCalendarWithHolidayDays = class(TStyledCalendar)
  protected
    { Messages from Model }
    /// <summary>Notification about changing value of DataSource of a model of <c>PresentedControl</c> </summary>
    procedure MMDataChanged(var AMessage: TDispatchMessageWithValue<TDataRecord>); message MM_DATA_CHANGED;
  private

    { Start ES 2022-11-5: Custom Added. }
    fStartDateSelected, fCurrentDateSelected: TDate;
    procedure CalendarMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure CalendarMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
    { End ES 2022-11-5: Custom Added. }
  protected
    procedure FillDays; override;

    procedure CreateBackground(ADayItem: TListBoxItem; const AColor: TAlphaColor); virtual;
    procedure RemoveDaysBackgrounds;

    procedure PaintWeekends; virtual;
    procedure PaintEvents; virtual;
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses
  System.SysUtils, System.DateUtils, System.Math, System.Types, FMX.Presentation.Factory,
  FMX.Controls, FMX.Presentation.Style, FMX.Types, FMX.Objects, FMX.Graphics, FMX.Calendar.Helpers,
  Rtti;

type

  {
    ES: 2022-11-05, Added hack.
    Copied from inherited class because the declaration is in the implementation part.
  }

  TDayItem = class(TListBoxItem)
  private
    FDate: TDateTime;
  public
    property Date: TDateTime read FDate write FDate;
  end;

constructor TStyledCalendarWithHolidayDays.Create(AOwner: TComponent);
begin
  inherited;
end;

procedure TStyledCalendarWithHolidayDays.CreateBackground(ADayItem: TListBoxItem; const AColor: TAlphaColor);
var
  Hightlight: TRectangle;
begin
  Hightlight := TRectangle.Create(nil);
  Hightlight.Corners := [TCorner.TopLeft, TCorner.TopRight, TCorner.BottomLeft, TCorner.BottomRight];
  Hightlight.CornerType := TCornerType.Round;
  Hightlight.XRadius := 5;
  Hightlight.YRadius := 5;
  Hightlight.Name := 'HightlightBackground';
  Hightlight.HitTest := False;
  Hightlight.Align := TAlignLayout.Contents;
  Hightlight.Margins.Rect := TRectF.Create(3, 3, 3, 3);
  Hightlight.Stroke.Kind := TBrushKind.None;
  Hightlight.Fill.Color := AColor;
  ADayItem.InsertObject(0, Hightlight);
end;

procedure TStyledCalendarWithHolidayDays.FillDays;
begin
  inherited;

  if Days <> nil then
  begin
    for var I := 0 to Days.Count - 1 do
    begin
      var DayItem := Days.ListItems[I];

      { Start ES 2022-11-5: Custom Added. }

      DayItem.OnMouseMove := CalendarMouseMove;
      DayItem.OnMouseDown := CalendarMouseDown;

      { End ES 2022-11-5: Custom Added. }

    end;
  end;

  // Paint holidays
  RemoveDaysBackgrounds;
  if Model.ShowWeekends then
    PaintWeekends;
  if Model.ShowEvents then
    PaintEvents;
end;

procedure TStyledCalendarWithHolidayDays.MMDataChanged(var AMessage: TDispatchMessageWithValue<TDataRecord>);
begin
  if SameText(AMessage.Value.Key, 'ShowWeekends') or
     SameText(AMessage.Value.Key, 'ShowEvents') or
     SameText(AMessage.Value.Key, 'EventsColor') or
     SameText(AMessage.Value.Key, 'WeekendsColor') or
     SameText(AMessage.Value.Key, 'Events') then
    FillCalendar
  else
    inherited;
end;

procedure TStyledCalendarWithHolidayDays.PaintEvents;
var
  Events: TArray<TDateTime>;
  Event: TDateTime;
  DayItem: TListBoxItem;
begin
  if Model.Data['Events'].IsType<TArray<TDateTime>> then
  begin
    Events := Model.Data['Events'].AsType<TArray<TDateTime>>;
    for Event in Events do
    begin
      DayItem := TryFindDayItem(Event);
      if DayItem <> nil then
        CreateBackground(DayItem, Model.EventsColor);
    end;
  end;
end;

procedure TStyledCalendarWithHolidayDays.PaintWeekends;
var
  DayItem: TListBoxItem;
  FirstDate: TDateTime;
  FirstDay: Word;
  LWeek: Integer;
  WeekendDate: TDateTime;
  FirstWeekendDay: Integer;
  MonthDaysCount: Word;
  SaturdayDay: Word;
  SundayDay: Word;
begin
  FirstDate := StartOfTheMonth(Self.Date);
  FirstDay := DayOfTheWeek(FirstDate);
  MonthDaysCount := DaysInMonth(FirstDate);
  FirstWeekendDay := DaysPerWeek - FirstDay + 1;

  for LWeek := 0 to 4 do
  begin
    // Saturday
    SaturdayDay := FirstWeekendDay - 1 + LWeek * DaysPerWeek;
    if InRange(SaturdayDay, 1, MonthDaysCount) then
    begin
      WeekendDate := RecodeDay(FirstDate, SaturdayDay);
      DayItem := TryFindDayItem(WeekendDate);
      if DayItem <> nil then
        CreateBackground(DayItem, Model.WeekendsColor);
    end;
    // Sunday
    SundayDay := FirstWeekendDay + LWeek * DaysPerWeek;
    if InRange(SundayDay, 1, MonthDaysCount) then
    begin
      WeekendDate := RecodeDay(FirstDate, SundayDay);
      DayItem := TryFindDayItem(WeekendDate);
      if DayItem <> nil then
        CreateBackground(DayItem, Model.WeekendsColor);
    end;
  end;
end;

procedure TStyledCalendarWithHolidayDays.RemoveDaysBackgrounds;

  procedure RemoveBackground(ADayItem: TListBoxItem);
  var
    I: Integer;
    Background: TControl;
  begin
    for I := ADayItem.ControlsCount - 1 downto 0 do
      if ADayItem.Controls[I].Name = 'HightlightBackground' then
      begin
        Background := ADayItem.Controls[I];
        Background.Parent := nil;
        Background.Free;
      end;
  end;

var
  I: Integer;
  DayItem: TListBoxItem;
begin
  if Days <> nil then
    for I := 0 to Days.Count - 1 do
    begin
      DayItem := Days.ListItems[I];
      RemoveBackground(DayItem);
    end;
end;

{ ES 2022-11-5: Custom Added. }

procedure TStyledCalendarWithHolidayDays.CalendarMouseDown(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Single);
begin
  fStartDateSelected := TDayItem(Sender).Date.GetDate();
  fCurrentDateSelected := fStartDateSelected;
  var arrayTotalDays := TArray<TDateTime>.Create();
  SetLength(arrayTotalDays, 1);
  arrayTotalDays[0] := fStartDateSelected;
  Model.Data['Events'] := TValue.From<TArray<TDateTime>>(arrayTotalDays);
end;

{ ES 2022-11-5: Custom Added. }

procedure TStyledCalendarWithHolidayDays.CalendarMouseMove(Sender: TObject; Shift: TShiftState; X, Y:
    Single);
begin

  if (ssLeft in Shift) then
  begin
    var dayItem := TDayItem(Sender).Date.GetDate();
    if dayItem = fCurrentDateSelected then
      Exit;

    fCurrentDateSelected := dayItem;
    var dayIncrement := -1;
    if fCurrentDateSelected >= fStartDateSelected then
    begin
      dayIncrement := 1;
    end;

    var totalDays := DaysBetween(fCurrentDateSelected, fStartDateSelected) + 1;

    {$IFDEF DEBUG}
    {$IFDEF MSWINDOWS}
    OutputDebugString(PChar(string.format('DaysBetween: %d, Start date: %s, Current date: %s Day item: %s',[totalDays,
    FormatDateTime('c',fStartDateSelected), FormatDateTime('c',fCurrentDateSelected), FormatDateTime('c',dayItem)])));
    {$ENDIF MSWINDOWS}
    {$ENDIF}

    var arrayTotalDays := TArray<TDateTime>.Create();
    SetLength(arrayTotalDays, totalDays);

    var dt := fStartDateSelected;
    for var i := Low(arrayTotalDays) to High(arrayTotalDays) do
    begin
      arrayTotalDays[i]:= dt;
      dt := IncDay(dt, dayIncrement)
    end;

    Model.Data['Events'] := TValue.From<TArray<TDateTime>>(arrayTotalDays);
  end

end;

initialization
  TPresentationProxyFactory.Current.Replace(TCalendar, TControlType.Styled, TStyledPresentationProxy<TStyledCalendarWithHolidayDays>);
finalization
  TPresentationProxyFactory.Current.Replace(TCalendar, TControlType.Styled, TStyledPresentationProxy<TStyledCalendar>);
end.
