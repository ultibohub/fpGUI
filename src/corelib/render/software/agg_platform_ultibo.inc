{%mainunit Agg2D.pas}

{$ifdef uses_interface}
  GlobalConfig,
  GlobalConst,
  Platform,
  Threads,
  Devices,
  Framebuffer,
{$endif}


{$ifdef agg_platform_interface}
  protected
//    m_ximg_window : PXImage;
{$endif}


{$ifdef uses_implementation}
  fpg_ultibo,
{$endif}


{$ifdef agg_platform_implementation}

procedure TAgg2D.DoPutBufferToScreen(x, y, w, h: TfpgCoord);
var
 Data:TDMAData;
 Size:LongWord;
 Source:Pointer;
 Address:LongWord;
 CurrentX:LongWord;
 CurrentY:LongWord;
 Application:TfpgUltiboApplication;
begin
 {$IFDEF DEBUG}
 LoggingOutput('TAgg2D.DoPutBufferToScreen (x=' + IntToStr(x) + ' y=' + IntToStr(y) + ' w=' + IntToStr(w) + ' h=' + IntToStr(h) + ')'); //Ultibo To Do //Implement simpleipc for SendDebug
 {$ENDIF DEBUG} 

 if TfpgWindow(FWindow).WinHandle <= 0 then
 begin
   debugln('    no winhandle available');
   exit;
 end;
  
 Application:=TfpgUltiboApplication(fpgApplication);
 if (Application <> nil) and (Application.Framebuffer <> nil) then
  begin
   {Lock Framebuffer}
   if MutexLock(Application.Framebuffer.Lock) <> ERROR_SUCCESS then Exit;
   
   if DMAAvailable and SysInitCompleted then
    begin
     {Create Data}
     FillChar(Data,SizeOf(TDMAData),0);
     Data.Source:=m_rbuf.row_xy(x,y,w);
     Data.Dest:=Pointer(Application.Framebuffer.Address + ((FWindow.Top + y) * Application.Framebuffer.Pitch) + ((FWindow.Left + x) * (Application.Framebuffer.Depth shr 3)));
     Data.Flags:=DMA_DATA_FLAG_STRIDE or DMA_DATA_FLAG_SOURCE_WIDE or DMA_DATA_FLAG_DEST_WIDE or DMA_DATA_FLAG_NOCLEAN or DMA_DATA_FLAG_NOINVALIDATE or DMA_DATA_FLAG_BULK;
     Data.StrideLength:=w * (Application.Framebuffer.Depth shr 3);
     Data.SourceStride:=0; 
     Data.DestStride:=Application.Framebuffer.Pitch - Data.StrideLength; 
     Data.Size:=Data.StrideLength * h;
     
     {Check Cached}
     if not(DMA_CACHE_COHERENT) then
      begin
       {Clean Cache}
       CleanDataCacheRange(LongWord(Data.Source),Data.StrideLength * h);
      end;
     
     {Perform Copy}
     DMATransfer(@Data,DMA_DIR_MEM_TO_MEM,DMA_DREQ_ID_NONE);
    end
   else
    begin   
     {Memory Barrier}
     DataMemoryBarrier;  {Before the First Write}
     
     {Draw Buffer}
     CurrentX:=x;
     CurrentY:=y;
     while CurrentY < (y + h) do
      begin
       {Get Source}
       Source:=m_rbuf.row_xy(CurrentX,CurrentY,w);
       
       {Get Address}
       Address:=(Application.Framebuffer.Address + ((FWindow.Top + CurrentY) * Application.Framebuffer.Pitch) + ((FWindow.Left + CurrentX) * (Application.Framebuffer.Depth shr 3)));
       
       {Write Buffer}
       System.Move(Source^,Pointer(Address)^,w * SizeOf(LongWord));
       
       {Check Cached}
       if (Application.Framebuffer.Device.DeviceFlags and FRAMEBUFFER_FLAG_CACHED) <> 0 then
        begin
         {Clean Cache}
         CleanDataCacheRange(Address,w * SizeOf(LongWord));
        end;
        
       Inc(CurrentY);
      end;
    end;
    
   {Unlock Framebuffer}
   MutexUnlock(Application.Framebuffer.Lock);
  end;  
end;

{$endif}

