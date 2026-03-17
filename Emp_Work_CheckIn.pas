unit Emp_Work_CheckIn;

interface

uses
 {$ifdef android}
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.Helpers,
  Androidapi.JNI,
  Androidapi.JNI.App,
  Androidapi.JNI.Os,
  Androidapi.JNI.Bluetooth,
  Androidapi.JNI.JavaTypes,
  Androidapi.JNIBridge,
  System.Android.Sensors,
 {$endif}

 {$IFDEF IOS}
  iOSApi.Foundation,
  iOSapi.UIKit,
  FMX.MediaLibrary.iOS,
  FMX.PushNotification.IOS,
//Macapi.Helpers,
//FMX.Helpers.iOS,
 {$ENDIF}


  System.IOUtils,
  IdHTTP,

  FMX.DialogService,
  System.Messaging,
  System.Permissions,
  System.DateUtils,
  System.Sensors,
  FMX.ListView.Appearances,
  System.Generics.Collections,
  System.Bluetooth,
  System.Actions,
  System.Beacon,
  System.JSON,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls, FMX.Layouts, FMX.Viewport3D,
  FMX.Layers3D, FMX.Objects, FMX.Controls3D, FMX.Objects3D, System.Math, FMX.ListBox, System.Math.Vectors,
  System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope, FMX.TabControl,
  FMX.ListView.Types, FMX.ListView, FMX.Grid,DB,Datasnap.DBClient,Data.SqlExpr,
  FMX.Controls.Presentation, FMX.Edit,
  FMX.PhoneDialer, FMX.Platform,
  FMX.MediaLibrary.Actions,
  FMX.ActnList,
  FMX.StdActns,
  FMX.Effects,
  FMX.WebBrowser, FMX.VirtualKeyboard, FMX.Ani,Com_Function,
  FMX.Calendar,
  FMX.Memo, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdFTP,

  FMX.TMSBaseControl,
  FMX.TMSTableView,
  FMX.DateTimeCtrls,
  FMX.TMSGridCell,
  FMX.TMSGridOptions,
  FMX.TMSGridData,
  FMX.TMSCustomGrid,
  FMX.TMSGrid,
  FMX.TMSLed,
  FMX.TMS7SegLed,
  FMX.TMSMatrixLabel,

  FMX.ExtCtrls,
  FMX.Gestures, FMX.Media, FMX.ScrollBox, FMX.ListView.Adapters.Base,
  System.Sensors.Components,
  System.ImageList, FMX.ImgList,
  Data.DBXJSONCommon,
  Data.FMTBcd,
  FMX.EditBox,
  FMX.NumberBox;
const
  //TSCANRESPONSE POSITIONS
  BEACON_TYPE_POSITION = 2;
  BEACON_GUID_POSITION = 4;
  BEACON_MAJOR_POSITION = 20;
  BEACON_MINOR_POSITION = 22;
  BEACON_ST_TYPE: Word = $0215;

type
 TBeaconDevice = Record
    Device: TBluetoothLEDevice;
    GUID:  TGUID;
    Major: Word;
    Minor: Word;
    TxPower: Integer;
    Rssi: Integer;
    Distance: Double;
    Alt: Boolean;
 end;

Type
  TBeaconList = Record
    UUID:       string;
    MAJOR:      Integer;
    MINOR:      Integer;
    DISTANCE:   Double;
    DateTimeFr: TDateTime;
    DateTimeTo: TDateTime;
    WHERE:      string;
    Ok_YN:      string;
    Memo:       string;
    SENDATA:    Boolean;
    TxPower:    Integer;
    Rssi:       Integer;
    Cnt:        Integer;
    Alt:        Boolean;
  end;




type

  TfrmEmp_Work_CheckIn = class(TForm)
    MediaPlayer1: TMediaPlayer;
    GestureManager1: TGestureManager;
    Timer1: TTimer;
    HeaderToolBar: TToolBar;
    Label_Title: TLabel;
    Layout_Man: TLayout;
    Image_Emp: TImage;
    FloatAnimation_image: TFloatAnimation;
    Rectangle_Start: TRectangle;
    btnStartStop: TButton;
    Layout_Pie: TLayout;
    Pie1: TPie;
    Pie2: TPie;
    FloatAnimation1: TFloatAnimation;
    ListView_Beacon: TListView;
    Text_Time_StartStop: TText;
    Layout_Main: TLayout;
    TMSFMXLED_Alive: TTMSFMXLED;
    Text_Address: TText;
    RectAnimation2: TRectAnimation;
    Text_LatLong: TText;
    Text_BeaconInfo: TText;
    RectAnimation3: TRectAnimation;
    LocationSensor1: TLocationSensor;
    Text_Process: TText;
    txtProcess: TText;

    procedure p_Process;
    procedure p_checkSelfPermission(Sender: TObject);
    procedure p_LocationAddress(const aLocation: TLocationCoord2D);
    function  f_Seconds(aDateTimeFr,aDateTimeTo:TDateTime):String;
    procedure p_Clear_BeaconList;
    procedure p_Clear_AllValue(aStart:Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnStartStopClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);

  private
    BluetoothLEManager: TBluetoothLEManager;
//  URLString: String;
    FGeocoder: TGeocoder;
    procedure OnGeocodeReverseEvent(const Address: TCivicAddress);


    procedure RequestPermissions;
    procedure HandlePermissionsRequest(const Sender: TObject; const M: TMessage);
   {$IFDEF ANDROID}
    procedure OnPermissionsRequest(ARequestCode: Integer; APermissions: TJavaObjectArray<JString>; AGrantResults: TJavaArray<Integer>);
   {$ENDIF}


  private
    { Private declarations }

// l_LocationSensor: Boolean;
   l_Busy:           Boolean;
   l_Started:        Boolean;
   l_Time_Start:     TDateTime;
   l_Time_Stop:      TDateTime;
   l_Beacon_Reg:     Array of TBeaconList;
   l_Discovering:    Boolean;

   l_GPS:            Boolean;

  public
    { Public declarations }
    procedure onDiscoverLEDevice(const Sender: TObject; const ADevice: TBluetoothLEDevice; Rssi: Integer; const ScanResponse: TScanResponse);
  end;
const
// c_Item_Height:   integer=  100;
   c_Distance_Ok:   Double =   20;  //20미터 이내만 순찰정보 전송가능
   c_Distance_Null: Double =99999;  //미터
   c_Second_Max:    Double =   30;  //30초이내 비콘신호가 응답이 없으면....
var
  frmEmp_Work_CheckIn: TfrmEmp_Work_CheckIn;
  p,q:String;
implementation
Uses
     Com_DataModule,Com_Variable,MainMenu;

{$R *.fmx}

procedure TfrmEmp_Work_CheckIn.btnCloseClick(Sender: TObject);
begin
  Close;
end;


procedure TfrmEmp_Work_CheckIn.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  LocationSensor1.Active  := false;
  if l_Discovering then BluetoothLEManager.CancelDiscovery;
  p_FormClose(Self,Action);
end;


procedure TfrmEmp_Work_CheckIn.FormCreate(Sender: TObject);
var i,c:integer;
    LItem: TListViewItem;
begin
//ListView_Beacon.Visible := false;//g_User_Grade<>'S';

  TMessageManager.DefaultManager.SubscribeToMessage(TPermissionsRequestResultMessage, HandlePermissionsRequest);
  p_checkSelfPermission(Sender);


  l_Busy                  := false;
  btnStartStop.Enabled    := l_GPS;
  Text_Address.Text       := '';
  Text_LatLong.Text       := '';
  Label_Title.Text        := g_Sel_Title;
  p_Clear_AllValue(false);
//Image_Emp.Bitmap.Assign(Image_None.Bitmap);


//  if not Com_Network.IsConnected then begin
//     TMSFMXLED_Alive.Visible := false;
//     ListView_Beacon.Visible := false;
//     btnStartStop.Enabled  := false;
//     btnStartStop.Text     := '사용불가';
//     p_ShowMessage('사용가능한 네트워크가 연결되지 않았습니다.');
//   //Close;
//     Exit;
//  end;

  l_Started               := false;
  btnStartStop.TextSettings.FontColor := TAlphaColors.Black;
  btnStartStop.Text       := '출근확인';
  with frmCom_DataModule.ClientDataSet_Proc do begin
    try
      p_CreatePrams;
      ParamByName('arg_ModCd' ).AsString := 'fms_security_BeaconList01';
      Open;
      c:=0;
      ListView_Beacon.BeginUpdate;
      ListView_Beacon.Items.Clear;
      ListView_Beacon.SearchVisible := false;
      ListView_Beacon.CanSwipeDelete:= false;
      SetLength(l_Beacon_Reg,RecordCount);
      ListView_Beacon.Height := 25*RecordCount;
      for i:=0 to RecordCount-1 do begin
        LItem            := ListView_Beacon.Items.Add;
        LItem.Text       := FieldByName('where1'  ).AsString+'-'
                           +FieldByName('where2'  ).AsString+' ('
                           +FieldByName('bc_major').AsString+'-'
                           +FieldByName('bc_minor').AsString+') ';
    //  LItem.Bitmap.Assign(Image_ZoneNo.Bitmap);
        LItem.Height := 25;

        with l_Beacon_Reg[i] do begin
          UUID        := FieldByName('bc_uuid' ).AsString;
          Major       := FieldByName('bc_major').AsInteger;
          Minor       := FieldByName('bc_minor').AsInteger;
          WHERE       := LItem.Text;
          SENDATA     := false;
          DISTANCE    := c_Distance_Null;
          DateTimeFr  := 0;
          DateTimeTo  := 0;
          Cnt         := 0;
          Memo        := '';
          Ok_YN       := '';

        end;



        Next;
      end;
      ListView_Beacon.EndUpdate;
      if RecordCount<1 then begin
        p_ShowMessage('등록된 비콘이 없습니다.');
      end;
    finally
      Close;
      if ListView_Beacon.ItemCount>0 then begin
         TMSFMXLED_Alive.Visible := true;
         ListView_Beacon.Visible := true;
         btnStartStop.Enabled    := true;
      end;
    end;
  end;

  ListView_Beacon.Align   := Fmx.Types.TAlignLayout.None;
  ListView_Beacon.Visible := false;

end;

procedure TfrmEmp_Work_CheckIn.FormDestroy(Sender: TObject);
begin
  TMessageManager.DefaultManager.Unsubscribe(TPermissionsRequestResultMessage, HandlePermissionsRequest);
end;

procedure TfrmEmp_Work_CheckIn.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkHardwareBack then begin
    if l_Discovering
       then btnStartStopClick(btnStartStop)
       else Close;
  end;
  Key:=0;
end;


procedure TfrmEmp_Work_CheckIn.btnStartStopClick(Sender: TObject);
{$ifdef android}
var BluetoothAdapter: JBluetoothAdapter;
{$endif}
begin

  ListView_Beacon.Align   := Fmx.Types.TAlignLayout.None;
  ListView_Beacon.Visible := true;
  ListView_Beacon.Opacity := 0.2;
  ListView_Beacon.Position.x := Layout_Main.Position.x+20;
  ListView_Beacon.Position.y := Layout_Main.Position.Y+20;
  ListView_Beacon.Width   := Layout_Main.Width-40;
  ListView_Beacon.Height  := Layout_Main.Height-40;
  ListView_Beacon.SendToBack;

  if not l_GPS then begin
     p_showmessage('휴대폰 GPS기능을 활성화 하세요.');
     Exit;
  end;

{$ifdef android}
  l_Started  := not l_Started;
  if l_Started then begin
    BluetoothAdapter := TJBluetoothAdapter.JavaClass.getDefaultAdapter;
    if not BluetoothAdapter.isEnabled then begin
      BluetoothAdapter := nil;
      l_Started  := false;
      p_Clear_AllValue(false);
      p_showmessage('블루투스 기능을 활성화 하세요.');
      Exit;
    end;


    p_Clear_AllValue(true);

    Image_Emp.Bitmap.Assign(frmMainMenu.Image_Emp.Bitmap);
    FloatAnimation_Image.Start;
    btnStartStop.Text := '중지';
    try
      if BluetoothLEManager = nil then begin
         BluetoothLEManager :=  TBluetoothLEManager.Current;
         BluetoothLEManager.OnDiscoverLeDevice := onDiscoverLEDevice;
      end;
      l_Discovering := BluetoothLEManager.StartDiscoveryRaw;
    except
      l_Started := false;
      p_Clear_AllValue(false);
      p_showmessage('BluetoothLEManager Error!');
    end;
    Application.ProcessMessages;
  end
  else begin
    BluetoothAdapter := nil;
    p_Clear_AllValue(false);
  //Image_Emp.Bitmap.Assign(Image_None.Bitmap);
    FloatAnimation_Image.Stop;
    btnStartStop.TextSettings.FontColor := TAlphaColors.Black;
    btnStartStop.Text := '출근확인';
    Text_Time_StartStop.Text := f_Seconds(l_Time_Start,Now);
    //ReleaseWakeLock;
  end;

{$endif}
end;

procedure TfrmEmp_Work_CheckIn.p_Clear_BeaconList;
var i:Integer;
begin
  for i:=Low(l_Beacon_Reg) to High(l_Beacon_Reg) do begin
    with  l_Beacon_Reg[i] do begin
      DISTANCE    := c_Distance_Null;
      DateTimeFr  := 0;
      DateTimeTo  := 0;
      Ok_YN       := '';
      Memo        := '';
      Cnt         := 0;
      SENDATA     := false;
      TxPower     := 0;
      Rssi        := 0;
      Cnt         := 0;
      Alt         := false;
    end;
    if i<=(ListView_Beacon.ItemCount-1) then begin
      with  ListView_Beacon.Items[i] do begin
       //Bitmap.Assign(Image_ZoneNo.Bitmap);
         Text := l_Beacon_Reg[i].Where;
      end;
    end;
  end;
end;



procedure TfrmEmp_Work_CheckIn.p_Clear_AllValue(aStart:Boolean);
begin
  p_Clear_BeaconList;
  if l_Discovering then BluetoothLEManager.CancelDiscovery;
  FloatAnimation_Image.Stop;
  ListView_Beacon.ScrollTo(0);
  ListView_Beacon.ItemIndex:=-1;
  btnStartStop.TextSettings.FontColor := TAlphaColors.Dimgray;
  btnStartStop.Enabled    := true;
  Text_Address.Visible    := false;
  Text_LatLong.Text       := '';
  Text_Address.Text       := '';
  Text_BeaconInfo.Text    := '';
  Text_BeaconInfo.Visible := aStart;
  l_Discovering           := aStart;
  l_Busy                  := false;
  l_Time_Stop             := Now;
  TMSFMXLED_Alive.State   := false;
  LocationSensor1.Active  := aStart;
  Layout_Pie.Visible      := aStart;
  Timer1.Enabled          := aStart;
  Layout_Pie.Visible      := aStart;
  Text_BeaconInfo.Visible := aStart;
  if aStart then begin
    l_Time_Start          := Now;
    Text_Address.Text     := '';
    Text_LatLong.Text     := '';
    Text_BeaconInfo.Align      := TAlignLayOut.None;
    Text_BeaconInfo.Position.y := 1;
  end;
end;



procedure TfrmEmp_Work_CheckIn.p_Process;
begin
  txtProcess.Text := p+':'+q;
end;


procedure TfrmEmp_Work_CheckIn.onDiscoverLEDevice(const Sender: TObject; const ADevice: TBluetoothLEDevice;
          Rssi: Integer; const ScanResponse: TScanResponse);
var LBeaconDevice: TBeaconDevice;

  procedure p_BinToHex(Buffer: TBytes; Text: PWideChar; BufSize: Integer);
  const Convert: array[0..15] of WideChar = '0123456789ABCDEF';
  var I: Integer;
  begin
    for I := 0 to BufSize - 1 do begin
      Text[0] := Convert[Buffer[I] shr 4];
      Text[1] := Convert[Buffer[I] and $F];
      Inc(Text, 2);
    end;
  end;

  function f_DecodeScanResponse: TBeaconDevice;
  const
    GUID_LENGTH   = 16;
    MARK_POSITION =  9;
  var
    LSTBuff: string;
    v_Byte : TBytes;

  begin
    SetLength(LSTBuff,GUID_LENGTH*2);
 // p_BinToHex(@ScanResponse.Items[TScanResponseKey.ManufacturerSpecificData][BEACON_GUID_POSITION], PChar(LSTBuff), GUID_LENGTH);
    v_Byte := TBytes(@ScanResponse.Items[TScanResponseKey.ManufacturerSpecificData][BEACON_GUID_POSITION]);
    p_BinToHex(v_Byte,PWideChar(LSTBuff),GUID_LENGTH);

    LSTBuff := '{' + LSTBuff + '}';
    LSTBuff.Insert(MARK_POSITION,'-');
    LSTBuff.Insert(MARK_POSITION + 5,'-');
    LSTBuff.Insert(MARK_POSITION + 10,'-');
    LSTBuff.Insert(MARK_POSITION + 15,'-');
    Result.GUID := TGUID.Create(LSTBuff);

    WordRec(Result.Major).Hi := ScanResponse.Items[TScanResponseKey.ManufacturerSpecificData][BEACON_MAJOR_POSITION];
    WordRec(Result.Major).Lo := ScanResponse.Items[TScanResponseKey.ManufacturerSpecificData][BEACON_MAJOR_POSITION + 1];
    WordRec(Result.Minor).Hi := ScanResponse.Items[TScanResponseKey.ManufacturerSpecificData][BEACON_MINOR_POSITION];
    WordRec(Result.Minor).Lo := ScanResponse.Items[TScanResponseKey.ManufacturerSpecificData][BEACON_MINOR_POSITION + 1];


    if (ScanResponse.Items[TScanResponseKey.ManufacturerSpecificData][BEACON_TYPE_POSITION] = WordRec(BEACON_ST_TYPE).Hi) then begin
      Result.Alt     := False;
      Result.TxPower := ShortInt(ScanResponse.Items[TScanResponseKey.ManufacturerSpecificData]
                         [length(ScanResponse.Items[TScanResponseKey.ManufacturerSpecificData])-1]);
    end else
    begin
      Result.Alt      := True;
      Result.TxPower  := ShortInt(ScanResponse.Items[TScanResponseKey.ManufacturerSpecificData]
                         [length(ScanResponse.Items[TScanResponseKey.ManufacturerSpecificData]) - 2]);
    end;
      Result.Rssi     := Rssi;
      Result.Device   := ADevice;
      Result.Distance := BluetoothLEManager.RssiToDistance(Rssi,Result.TxPower,0.5);
  end;

begin
p:='0000'; p_Process;
q:='0000'; p_Process;

p:='0001'; p_Process;   if l_Busy then Exit else l_Busy := true;
p:='0002'; p_Process;   LBeaconDevice := f_DecodeScanResponse;
                        TThread.Synchronize(nil, procedure
                        var i,c1,c2:integer;
                            v_Device,v_Kind: String;
                        begin
                          try
p:='0003'; p_Process;       TMSFMXLED_Alive.State := not TMSFMXLED_Alive.State;
p:='0004'; p_Process;       Text_Time_StartStop.Text := f_Seconds(l_Time_Start,Now);
                         //---------------------------------------------------------------------------------------
                         //
                         //---------------------------------------------------------------------------------------
                            with Text_BeaconInfo do begin
p:='0005'; p_Process;         TextSettings.FontColor := TAlphaColors.Olive;
p:='0006'; p_Process;         Text := '(GUID:'+ LBeaconDevice.GUID.ToString
                                   +',TxPower:'  + LBeaconDevice.TxPower.ToString
                                   +',Alt:'      + LBeaconDevice.Alt.ToString
                                   +',Distance:' + Format('%2.2f',[LBeaconDevice.Distance])+'m)'
                                   +',Major:'    + LBeaconDevice.MAJOR.ToString
                                   +',Minor:'    + LBeaconDevice.MINOR.ToString
                                   +',DateTime:' + FormatDateTime('HH:NN:SS',Now)
                                   +')';
p:='0007'; p_Process;         if Position.y<TLayOut(Parent).Height then begin
p:='0008'; p_Process;            Position.y := Position.y+Height;
p:='0009'; p_Process;         end
                              else begin
p:='0010'; p_Process;           Position.y := 0;
p:='0011'; p_Process;           end;
p:='0012'; p_Process;       end;
                          //---------------------------------------------------------------------------------------
p:='0013'; p_Process;       if LBeaconDevice.Alt then Exit;
                          //---------------------------------------------------------------------------------------
                          // 모든신호 수신
                          //---------------------------------------------------------------------------------------
p:='0014'; p_Process;        v_Kind      := '';
p:='0015'; p_Process;        v_Device    := '';
p:='0016'; p_Process;        if ScanResponse.ContainsKey(TScanResponseKey.CompleteLocalName) then begin
p:='0017'; p_Process;         v_Device := TEncoding.UTF8.GetString(ScanResponse.Items[TScanResponseKey.CompleteLocalName]);
                             end;
p:='0018'; p_Process;        if LBeaconDevice.Alt then v_Kind := 'Alt' else v_Kind := 'iBeacon';
                          //---------------------------------------------------------------------------------------
                          // 등록된 비콘신호만 수신
                          //---------------------------------------------------------------------------------------
p:='0019'; p_Process;        if High(l_Beacon_Reg)>=0 then begin
q:='0020'; p_Process;          c1 := Low(l_Beacon_Reg);
q:='0021'; p_Process;          c2 := High(l_Beacon_Reg);
q:='0022'; p_Process;          for i:=c1 to c2 do begin
q:='0023'; p_Process;            try
q:='0024'; p_Process;              with l_Beacon_Reg[i] do begin
q:='0025'; p_Process;                if Ok_YN <> 'Y' then begin
q:='0026'; p_Process;                  if ((UUID  = LBeaconDevice.GUID.ToString) and
                                           (Major = LBeaconDevice.Major)         and
                                           (Minor = LBeaconDevice.Minor))        then begin
q:='0027'; p_Process;                    DISTANCE    := LBeaconDevice.Distance;
q:='0028'; p_Process;                    TxPower     := LBeaconDevice.TxPower;
q:='0029'; p_Process;                    Rssi        := LBeaconDevice.Rssi;
q:='0030'; p_Process;                    Alt         := LBeaconDevice.Alt;
q:='0031'; p_Process;                    SENDATA     := true;
q:='0032'; p_Process;                    Ok_YN       := 'Y';
q:='0033'; p_Process;                    DateTimeFr  := l_Time_Start;
q:='0035'; p_Process;                    ListView_Beacon.Items[i].Objects.TextObject.TextColor := TAlphaColors.Green;
q:='0036'; p_Process;                    ListView_Beacon.Items[i].Text := Where;
q:='0037'; p_Process;                    if DateTimeTo=0 then begin
q:='0038'; p_Process;                       DateTimeTo  := Now();
q:='0039'; p_Process;                       ListView_Beacon.Items[i].Text := Where+' '+f_Seconds(DateTimeFr,DateTimeTo);
                                         end;
                                       end;
                                     end;
                                   end;
                                 finally
                                   l_Busy := false;
                                 end;
                               end;
                             end;
                          finally
                            l_Busy := false;
                          end;
                        end);
end;


function TfrmEmp_Work_CheckIn.f_Seconds(aDateTimeFr,aDateTimeTo:TDateTime):String;
begin
//Result := FormatDateTime('YYYY-MM-DD HH:NN:SS',aDateTimeTo)
  Result := FormatDateTime('HH:NN:SS',aDateTimeTo)
         +' ('+SecondsBetween(aDateTimeTo,aDateTimeFr).ToString+'초)';
end;



procedure TfrmEmp_Work_CheckIn.Timer1Timer(Sender: TObject);
var i,c,k:integer;
    v_Sec:integer;
    v_DateTime:TDateTime;
    v_LocationCoord2d: TLocationCoord2d;
begin
  l_Busy      := false;
  l_Time_Stop := Now();
  v_Sec := SecondsBetween(l_Time_Stop,l_Time_Start);
  Text_Time_StartStop.Text := f_Seconds(l_Time_Start,l_Time_Stop);
  c:=0;
  for i:=Low(l_Beacon_Reg) to High(l_Beacon_Reg) do begin
    if l_Beacon_Reg[i].Ok_YN = 'Y' then begin
       if l_Time_Stop>=l_Beacon_Reg[i].DateTimeTo then begin
          l_Time_Stop:=l_Beacon_Reg[i].DateTimeTo;
          v_DateTime :=l_Beacon_Reg[i].DateTimeTo;
          k:=i;
       end;
       Inc(c);
    end;
  end;

  if (c>0) and (v_Sec>=3) then begin
    Timer1.Enabled          := false;
    BluetoothLEManager.CancelDiscovery;
    Application.ProcessMessages;

    with l_Beacon_Reg[k] do begin
      Text_BeaconInfo.Text := '(UUID:'  + UUID
                          +',TxPower:'  + TxPower.ToString
                          +',Alt:'      + Alt.ToString
                          +',Distance:' + Format('%2.2f',[Distance])+'m)'
                          +',Major:'    + MAJOR.ToString
                          +',Minor:'    + MINOR.ToString
                          +',DateTime:' + FormatDateTime('HH:NN:SS',DateTimeTo);
    end;
    btnStartStop.Enabled     := false;
    Text_Address.Visible     := true;
    l_Discovering            := false;
    TMSFMXLED_Alive.State    := true;
    Layout_Pie.Visible       := false;
    Text_BeaconInfo.Visible  := false;
    FloatAnimation_Image.Stop;
    ListView_Beacon.ScrollTo(0);
  //ListView_Beacon.ItemIndex:=-1;
    btnStartStop.TextSettings.FontColor := TAlphaColors.Green;
    btnStartStop.Text        := '출근이 확인되었습니다.';
    Text_Time_StartStop.Text := FormatDateTime('YYYY-MM-DD HH:NN:SS',l_Time_Stop);

      try
        v_LocationCoord2d := TLocationCoord2d.Create(LocationSensor1.Sensor.Latitude,LocationSensor1.Sensor.Longitude);
        p_LocationAddress(v_LocationCoord2d);
      finally
        LocationSensor1.Active := false;
      end;

    Application.ProcessMessages;

    with frmCom_DataModule.ClientDataSet_Proc do begin
      try
        p_CreatePrams;
        ParamByName('arg_ModCd'  ).AsString := 'Com_Insert_pc_onoff';
        ParamByName('arg_COMPANY').AsString := g_User_Company;
        ParamByName('arg_EMPNO'  ).AsString := g_User_EmpNo;
        ParamByName('arg_Text01' ).AsString := g_User_Phone;
        ParamByName('arg_Text02' ).AsString := FormatDateTime('HH:NN:SS',v_DateTime);
        Open;
      //btnStartStop.Text := btnStartStop.Text+'('+FieldByName('SEQ').AsString+')';
      finally
        Close;
      end;
    end;

  end else
  if (c=0) and (v_Sec>=180) then begin
    Timer1.Enabled          := false;
    BluetoothLEManager.CancelDiscovery;
    Application.ProcessMessages;
    l_Discovering            := false;
    TMSFMXLED_Alive.State    := false;
    Layout_Pie.Visible       := false;
    btnStartStop.TextSettings.FontColor := TAlphaColors.Red;
    btnStartStop.Text        := '출근을 확인할 수 없습니다.';
    Text_Time_StartStop.Text := f_Seconds(l_Time_Start,l_Time_Stop);
  //Image_Emp.Bitmap.Assign(Image_None.Bitmap);
    Application.ProcessMessages;
  end
  else begin
    TMSFMXLED_Alive.State := not TMSFMXLED_Alive.State;
  end;
end;

procedure TfrmEmp_Work_CheckIn.p_LocationAddress(const aLocation: TLocationCoord2D);
var
  LSettings: TFormatSettings;
  LDecSeparator : Char;
begin
  TThread.Synchronize(nil, procedure
  begin
    LDecSeparator := FormatSettings.DecimalSeparator;
    LSettings := FormatSettings;
    try
      FormatSettings.DecimalSeparator := '.';
      Text_LatLong.Text := '('+Format('%2.6f',[aLocation.Latitude])+ ', '+Format('%2.6f',[aLocation.Longitude])+')';
    //URLString:=Format('https://maps.google.com/maps?q=%2.6f,%2.6f',[aLocation.Latitude,aLocation.Longitude]);
    finally
      FormatSettings.DecimalSeparator := LDecSeparator;
    end;
    try
      if not Assigned(FGeocoder) then begin
        if Assigned(TGeocoder.Current) then FGeocoder := TGeocoder.Current.Create;
        if Assigned(FGeocoder)         then FGeocoder.OnGeocodeReverse := OnGeocodeReverseEvent;
      end;
    except
      Text_LatLong.Text := 'Geocoder service error.';
    end;
    if Assigned(FGeocoder) and not FGeocoder.Geocoding then FGeocoder.GeocodeReverse(aLocation);
  end);
end;



{$ifdef android}
procedure TfrmEmp_Work_CheckIn.OnGeocodeReverseEvent(const Address: TCivicAddress);
begin
  Text_Address.Text:= '('+Address.PostalCode+')'
                     +' '+Address.SubAdminArea
                     +' '+Address.Locality
                     +' '+Address.SubLocality
                     +' '+Address.Thoroughfare
                     +' '+Address.SubThoroughfare;
                   //+' '+Address.AdminArea
                   //+' '+Address.CountryCode
                   //+' '+Address.CountryName
                   //+' '+Address.FeatureName

end;
{$endif}

// http://blong.com/Articles/AndroidPermissions/DelphiAppPermissions.htm

procedure TfrmEmp_Work_CheckIn.p_checkSelfPermission(Sender: TObject);
begin
  // API 23+ calls guarded by a runtime check against the OS SDK version
  l_GPS := true;
  if (TJBuild_VERSION.JavaClass.SDK_INT >= 23) then begin
    if  (TAndroidHelper.Activity.checkSelfPermission(TJManifest_permission.JavaClass.ACCESS_COARSE_LOCATION) <> TJPackageManager.JavaClass.PERMISSION_GRANTED) and
        (TAndroidHelper.Activity.checkSelfPermission(TJManifest_permission.JavaClass.ACCESS_FINE_LOCATION)   <> TJPackageManager.JavaClass.PERMISSION_GRANTED)
     then begin
       l_GPS := false;
       RequestPermissions;
     end;
  end;
end;

procedure TfrmEmp_Work_CheckIn.RequestPermissions;
begin
  var Perms := TJavaObjectArray<JString>.Create(2);
  Perms[0]  := TJManifest_permission.JavaClass.ACCESS_COARSE_LOCATION;
  Perms[1]  := TJManifest_permission.JavaClass.ACCESS_FINE_LOCATION;
  TAndroidHelper.Activity.requestPermissions(Perms,1);
end;

procedure TfrmEmp_Work_CheckIn.HandlePermissionsRequest(const Sender: TObject; const M: TMessage);
begin
  if M is TPermissionsRequestResultMessage then begin
    var MessageData  := TPermissionsRequestResultMessage(M).Value;
    var RequestCode  := MessageData.RequestCode;
    var Permissions  := MessageData.Permissions;
    var GrantResults := MessageData.GrantResults;
    OnPermissionsRequest(RequestCode, Permissions, GrantResults);
  end;
end;

procedure TfrmEmp_Work_CheckIn.OnPermissionsRequest(ARequestCode: Integer; APermissions: TJavaObjectArray<JString>; AGrantResults: TJavaArray<Integer>);
begin
  if ARequestCode = 1 then begin
    var PermissionGranted :=
      (AGrantResults.Length = 2) and
      (AGrantResults[0] = TJPackageManager.JavaClass.PERMISSION_GRANTED) and
      (AGrantResults[1] = TJPackageManager.JavaClass.PERMISSION_GRANTED);
    l_GPS := PermissionGranted;
    if not PermissionGranted then p_Toast('User denied permission');
  end;
end;










end.



