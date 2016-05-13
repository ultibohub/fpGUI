{
    fpGUI  -  Free Pascal GUI Toolkit

    Copyright (C) 2006 - 2010 See the file AUTHORS.txt, included in this
    distribution, for details of the copyright.

    See the file COPYING.modifiedLGPL, included in this distribution,
    for details about redistributing fpGUI.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

    Description:
      A simple hello world application that only uses canvas painting.
}

{Ultibo version of the HelloWorld example

 Compile using the build_ultibo.bat file in this folder
 
}

program HelloWorld_ultibo;

{$mode objfpc}{$H+}

uses
  {$IFDEF ULTIBO}
  GlobalConst, Platform, Threads,  
  {$ENDIF}
  Classes, SysUtils,
  fpg_base,
  fpg_main
  {$IFDEF ULTIBO}
  , Services, {$IFDEF RPI}RaspberryPi{$ENDIF}{$IFDEF RPI2}RaspberryPi2{$ENDIF}, RemoteShell, ShellFilesystem, ShellUpdate
  {$ENDIF};

const
  HelloWorldString: String = 'Hello, world!';
  ClickToClose: String = 'click to close';


type

  TMainWindow = class(TfpgWindow)
  private
    procedure   MsgPaint(var msg: TfpgMessageRec); message FPGM_PAINT;
    procedure   MsgClose(var msg: TfpgMessageRec); message FPGM_CLOSE;
    procedure   MsgResize(var msg: TfpgMessageRec); message FPGM_RESIZE;
    procedure   MsgMouseUp(var msg: TfpgMessageRec); message FPGM_MOUSEUP;
  public
    constructor Create(AOwner: TComponent); override;
    procedure   Show;
  end;
  

constructor TMainWindow.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FWidth    := 350;
  FHeight   := 200;
  WindowAttributes := [waSizeable, waScreenCenterPos];
end;

procedure TMainWindow.Show;
begin
  AllocateWindowHandle;
  DoSetWindowVisible(True);
  // We can't set a title if we don't have a window handle. So we do that here
  // and not in the constructor.
  SetWindowTitle('fpGUI Hello World');
end;

procedure TMainWindow.MsgPaint(var msg: TfpgMessageRec);
var
  r: TfpgRect;
  i: Integer;
  fnt: TfpgFont;
begin
  Canvas.BeginDraw;  // begin double buffering

  Canvas.Clear(clBlue);
  
  r.SetRect(0, 0, Width, Height);
  //Canvas.GradientFill(r, clBlue, clBlack, gdVertical);  //Ultibo To Do //Canvas.GradientFill doesn't seem to work yet

  fnt := fpgGetFont('verdana18'); //Ultibo To Do //Need to account for FreeType
  try
    Canvas.Font := fnt;
    
    Canvas.SetTextColor(clBlack);
    //Canvas.DrawString((Width - Canvas.Font.TextWidth(HelloWorldString)) div 2 + 1, //Ultibo To Do //Canvas.Font.TextWidth doesn't seem to work yet (very large number returned)
    //  (Height - Canvas.Font.Height) div 2 + 1, HelloWorldString);
    Canvas.DrawString(21,
      (Height - Canvas.Font.Height) div 2 + 1, HelloWorldString);

    Canvas.SetTextColor(clWhite);
    //Canvas.DrawString((Width - Canvas.Font.TextWidth(HelloWorldString)) div 2 - 1, //Ultibo To Do //Canvas.Font.TextWidth doesn't seem to work yet (very large number returned)
    //  (Height - Canvas.Font.Height) div 2 - 1, HelloWorldString);
    Canvas.DrawString(19, 
      (Height - Canvas.Font.Height) div 2 - 1, HelloWorldString);
  finally
    fnt.Free;
  end;

  fnt := fpgGetFont('verdana12'); // //Ultibo To Do //Need to account for FreeType
  try
    Canvas.Font := fnt;
    //Canvas.DrawString((Width - Canvas.Font.TextWidth(ClickToClose)) div 2 - 1, //Ultibo To Do //Canvas.Font.TextWidth doesn't seem to work yet (very large number returned)
    //  Height - (Canvas.Font.Height*2), ClickToClose);
    Canvas.DrawString(20, 
      Height - (Canvas.Font.Height*2), ClickToClose);
  finally
    fnt.Free;
  end;

  Canvas.EndDraw;
end;

procedure TMainWindow.MsgClose(var msg: TfpgMessageRec);
begin
  ReleaseWindowHandle;
  fpgApplication.Terminate;
end;

procedure TMainWindow.MsgResize(var msg: TfpgMessageRec);
begin
  FWidth  := msg.Params.rect.Width;
  FHeight := msg.Params.rect.Height;
end;

procedure TMainWindow.MsgMouseUp(var msg: TfpgMessageRec);
begin
  MsgClose(msg);
end;



var
  MainWindow: TMainWindow;
begin
  try 
   Sleep(10000);
   LoggingOutput('Starting fpGUI HelloWorld'); 

   fpgApplication.Initialize;
   MainWindow := TMainWindow.Create(nil);
   fpgApplication.MainForm := MainWindow;
   MainWindow.Show;
   fpgApplication.Run;
   MainWindow.Free;
  except
   on E: Exception do
    begin
     LoggingOutput('Exception Address: ' + IntToHex(PtrUInt(ExceptAddr),8) + ' Message: ' + E.Message);
    end;
  end;
end.

