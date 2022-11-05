program CalendarHolidayDaysDemo;

uses
  System.StartUpCopy,
  FMX.Forms,
  MainFrm in 'MainFrm.pas' {Form18},
  FMX.CalendarHolidayDays.Style in 'FMX.CalendarHolidayDays.Style.pas',
  FMX.Calendar.Helpers in 'FMX.Calendar.Helpers.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
