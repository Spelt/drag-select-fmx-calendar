unit FMX.Calendar.Helpers;

interface

uses
  System.Rtti, FMX.Calendar, System.UITypes, SysUtils, DateUtils;

type
  TCalendarModelHelpers = class helper for TCalendarModel
  public const
    DefaultEventsColor = $7F32CD32;
    DefaultWeekendsColor = $7FFEB1AF;
  private
    function GetShowEvents: Boolean;
    procedure SetShowEvents(const Value: Boolean);
    function GetShowWeekends: Boolean;
    procedure SetShowWeekends(const Value: Boolean);
    function GetEventsColor: TAlphaColor;
    procedure SetEventsColor(const Value: TAlphaColor);
    function GetWeekendsColor: TAlphaColor;
    procedure SetWeekendsColor(const Value: TAlphaColor);
  public
    property ShowEvents: Boolean read GetShowEvents write SetShowEvents;
    property ShowWeekends: Boolean read GetShowWeekends write SetShowWeekends;
    property EventsColor: TAlphaColor read GetEventsColor write SetEventsColor;
    property WeekendsColor: TAlphaColor read GetWeekendsColor write SetWeekendsColor;

    function GetSelectedMinMaxRange(var First, Last: TDate): Boolean;
  end;

implementation

{ TCalendarModelHelpers }

function TCalendarModelHelpers.GetEventsColor: TAlphaColor;
var
  Value: TValue;
begin
  Value := Data['EventsColor'];
  if Value.IsEmpty or Value.TryAsType<TAlphaColor>(Result) then
    Result := DefaultEventsColor;
end;

function TCalendarModelHelpers.GetShowEvents: Boolean;
begin
  Result := Data['ShowEvents'].AsBoolean;
end;

function TCalendarModelHelpers.GetShowWeekends: Boolean;
begin
  Result := Data['ShowWeekends'].AsBoolean;
end;

function TCalendarModelHelpers.GetWeekendsColor: TAlphaColor;
var
  Value: TValue;
begin
  Value := Data['WeekendsColor'];
  if Value.IsEmpty or not Value.TryAsType<TAlphaColor>(Result) then
    Result := DefaultWeekendsColor;
end;

procedure TCalendarModelHelpers.SetEventsColor(const Value: TAlphaColor);
begin
  Data['EventsColor'] := TValue.From<TAlphaColor>(Value);
end;

procedure TCalendarModelHelpers.SetShowEvents(const Value: Boolean);
begin
  Data['ShowEvents'] := Value;
end;

procedure TCalendarModelHelpers.SetShowWeekends(const Value: Boolean);
begin
  Data['ShowWeekends'] := Value;
end;

procedure TCalendarModelHelpers.SetWeekendsColor(const Value: TAlphaColor);
begin
  Data['WeekendsColor'] := TValue.From<TAlphaColor>(Value);
end;

function TCalendarModelHelpers.GetSelectedMinMaxRange(var First, Last: TDate): Boolean;
begin
  First := MaxDateTime;
  Last := MinDateTime;
  var events := Data['Events'].AsType<TArray<TDateTime>>;
  result := Length(events) > 0;
  for var event in Events do
  begin
    if Event < First then
      First := Event;

    if Event > Last then
      Last := Event;
  end;
end;


end.
