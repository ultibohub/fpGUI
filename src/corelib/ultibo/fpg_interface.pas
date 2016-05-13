{
    fpGUI  -  Free Pascal GUI Toolkit

    Copyright (C) 2006 - 2016 See the file AUTHORS.txt, included in this
    distribution, for details of the copyright.

    See the file COPYING.modifiedLGPL, included in this distribution,
    for details about redistributing fpGUI.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

    Description:
      This unit defines alias types to bind each backend graphics library
      to fpg_main without the need for IFDEF's
}

unit fpg_interface;

{$mode objfpc}{$H+}

interface

uses
  fpg_ultibo;

type
  TfpgFontResourceImpl  = class(TfpgUltiboFontResource);
  TfpgImageImpl         = class(TfpgUltiboImage);
  TfpgCanvasImpl        = class(TfpgUltiboCanvas);
  TfpgWindowImpl        = class(TfpgUltiboWindow);
  TfpgApplicationImpl   = class(TfpgUltiboApplication);
  TfpgClipboardImpl     = class(TfpgUltiboClipboard);
  TfpgFileListImpl      = class(TfpgUltiboFileList);
  TfpgMimeDataImpl      = class(TfpgUltiboMimeDataBase);
  TfpgDragImpl          = class(TfpgUltiboDrag);
  TfpgTimerImpl         = class(TfpgUltiboTimer);
  TfpgSystemTrayHandler = class(TfpgUltiboSystemTrayIcon);

implementation

end.

