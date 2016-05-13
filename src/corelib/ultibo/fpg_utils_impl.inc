{%mainunit fpg_utils.pas}

uses
  fpg_constants, fpg_stringutils;
  
// GDI specific implementations of encoding functions

function fpgToOSEncoding(aString: TfpgString): string;
begin
  Result := Utf8ToAnsi(aString);
end;

function fpgFromOSEncoding(aString: string): TfpgString;
begin
  Result := AnsiToUtf8(aString);
end;

procedure fpgOpenURL(const aURL: TfpgString);
begin
  try
   //Ultibo To Do
  except
    // do nothing
  end;
end;

function fpgFileSize(const AFilename: TfpgString): integer;
var
 Str: widestring;
 SearchRec:TSearchRec;
begin
  Str:=UTF8Decode(AFilename);
  if FindFirst(Str,faAnyFile,SearchRec) = 0 then
   begin
    Result:=SearchRec.Size;
   end
  else
   begin
    Result:=-1;
   end;   
  FindClose(SearchRec); 
end;

