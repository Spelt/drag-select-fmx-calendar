unit MainFrm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Calendar, FMX.Controls.Presentation, FMX.MultiView, FMX.DateTimeCtrls, FMX.Layouts, FMX.ListBox;

type
  TMainForm = class(TForm)
    MultiView1: TMultiView;
    Calendar1: TCalendar;
    CBDisplayEvents: TCheckBox;
    CBDisplayWeekends: TCheckBox;
    LBEvents: TListBox;
    Layout1: TLayout;
    GroupBox1: TGroupBox;
    DEEvent: TDateEdit;
    BtnAddEvents: TButton;
    BtnDeleteEvents: TButton;
    Layout2: TLayout;
    BtnCheckPresentationName: TButton;
    btnGetRange: TButton;
    procedure CBDisplayWeekendsChange(Sender: TObject);
    procedure CBDisplayEventsChange(Sender: TObject);
    procedure BtnAddEventsClick(Sender: TObject);
    procedure BtnDeleteEventsClick(Sender: TObject);
    procedure BtnCheckPresentationNameClick(Sender: TObject);
    procedure btnGetRangeClick(Sender: TObject);
  private
    procedure UpdateEvents;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

uses
  FMX.Calendar.Helpers,
  System.Rtti;

procedure TMainForm.BtnAddEventsClick(Sender: TObject);
begin
  LBEvents.Items.Add(DEEvent.Text);
  UpdateEvents;
end;

procedure TMainForm.BtnDeleteEventsClick(Sender: TObject);
begin
  if LBEvents.ItemIndex <> -1 then
    LBEvents.Items.Delete(LBEvents.ItemIndex);
  UpdateEvents;
end;

procedure TMainForm.BtnCheckPresentationNameClick(Sender: TObject);
begin
  if Calendar1.Presentation <> nil then
    ShowMessage(Calendar1.Presentation.ClassName)
  else
    ShowMessage('TCalendar doesn''t have presentation');
end;

procedure TMainForm.CBDisplayEventsChange(Sender: TObject);
begin
  Calendar1.Model.ShowEvents := CBDisplayEvents.IsChecked;
end;

procedure TMainForm.CBDisplayWeekendsChange(Sender: TObject);
begin
  Calendar1.Model.ShowWeekends := CBDisplayWeekends.IsChecked;
end;

procedure TMainForm.UpdateEvents;
var
  Events: TArray<TDateTime>;
  I: Integer;
begin
  SetLength(Events, LBEvents.Count);
  for I := 0 to LBEvents.Count - 1 do
    Events[I] := StrToDateTime(LBEvents.Items[I]);

  var d := TValue.From<TArray<TDateTime>>(Events);

  Calendar1.Model.Data['Events'] := TValue.From<TArray<TDateTime>>(Events);
end;

procedure TMainForm.btnGetRangeClick(Sender: TObject);
var
  firstDate, lastDate: TDate;
begin

  if Calendar1.Model.GetSelectedMinMaxRange(firstDate, lastDate) then
  begin
    btnGetRange.Text := FormatDateTime('yyyy-m-d', firstDate) + ' / ' + FormatDateTime('yyyy-m-d', lastDate);
    Exit;
  end;

  btnGetRange.Text := 'Non selected';

end;


end.
