# Drag select fmx TCalendar.

A fast drag select extention to the default fmx TCalendar. No component need to be installed. Just include some files and optional set colours. It should work in most Delphi FMX versions, I tested it in Delphi 11.2.


![Screenshot dark 1](https://github.com/Spelt/EventCalendar/blob/master/git-resources/drag-select-dark.png )

![Screenshot light 1](https://github.com/Spelt/EventCalendar/blob/master/git-resources/drag-select.png )

Screenshots: result of drag select operation.  You can change the drag select colours.


## Background
To select a date range in Delphi Firemonkey is perfectly possible and easy to do using two TCalendar controls and thats what I did in one of my commercial applications. However, a client complained that the control in a older application version (Silverlight based) had a drag select and that was easier.
Easier is King so I created this extension which supports drag select dates.

## Installation
You only need to add two files to your project FMX.CalendarHolidayDays.Style.pas and FMX.Calendar.Helpers.pas
Look at the demo project for using this extension.


## Origins
This 'Drag and Select TCalendar' is an extension of the work of Yaroslav Brovin. See the complete explaination here: http://yaroslavbrovin.ru/tcalendar_with_highlight_days_based_on_default_tcalendar/
Also see the video.

## Special thanks to
- Remy Lebeau (for the cast hack)
- Yaroslav Brovin (for the orginal)
