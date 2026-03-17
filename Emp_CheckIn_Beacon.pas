unit Emp_CheckIn_Beacon;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  System.Bluetooth, System.Beacon.Components, FMX.Controls.Presentation,
  FMX.StdCtrls, FMX.ScrollBox, FMX.Memo, System.Bluetooth.Components,
  FMX.Objects, FMX.TMSBaseControl, FMX.TMSLed, FMX.Ani, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  FMX.DialogService,
  FMX.Platform,
  FMX.VirtualKeyboard,
  BeaconsRender,
  System.Beacon,
  System.Generics.Collections,



{$IFDEF ANDROID}
  Androidapi.JNI.Os,
  Androidapi.JNI.JavaTypes,
  Androidapi.Helpers,
{$ENDIF}
  System.Permissions, FMX.Layouts, FMX.Edit, FMX.EditBox, FMX.NumberBox,
  FMX.TMS7SegLed;

type
  TfrmEmp_CheckIn_Beacon = class(TForm)
    Timer1: TTimer;
    HeaderToolBar: TToolBar;
    Label_Title: TLabel;
    TMSFMXLED_OnOff: TTMSFMXLED;
    btnExit: TButton;
    Layout_Man: TLayout;
    Image_Emp: TImage;
    FloatAnimation_image: TFloatAnimation;
    Text_BeaconInfo: TText;
    RectAnimation3: TRectAnimation;
    Rectangle_Start: TRectangle;
    Text_Time_StartStop: TText;
    BtnStartScan: TButton;
    BtnStopScan: TButton;
    btnClose: TButton;
    Layout_Pie: TLayout;
    Pie1: TPie;
    Pie2: TPie;
    FloatAnimation1: TFloatAnimation;
    FloatAni_OnOff: TFloatAnimation;
    ListView_Beacon: TListView;
    Text_Message: TText;
    Layout1: TLayout;
    Layout_Ok: TLayout;
    Image_Ok: TImage;
    FloatAnimation2: TFloatAnimation;
    Layout2: TLayout;
    Text_Work_Time: TText;
    Layout3: TLayout;
    Text_On_Time: TText;
    Layout4: TLayout;
    Text_On_Status: TText;
    Layout5: TLayout;
    Text_On_Where: TText;
    BtnBCStart: TButton;
    Beacon1: TBeacon;

    procedure QueryBeaconList(Sender: TObject);
    procedure BtnStartScanClick(Sender: TObject);
    procedure BtnStopScanClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure Image_EmpClick(Sender: TObject);
    procedure BtnBCStartClick(Sender: TObject);
  private
    { Private declarations }

    FBeacon: IBeacon;

    FLock: TObject;
    FList: TList<TBeaconGraphicInfo>;
    FRenderer: TRenderer;
    FMaxDistance: Double;
    FBeaconManager: TBeaconManager;

//    FCurrentBeaconList: TBeaconList;

//    FBeaconsRegion: TBeaconsRegion;




    procedure Beacon_Register;
    procedure Beacon_SetManager;
    procedure StringToRegion(AString: string; var Guid: string; var Major: integer; var Minor: integer);
    procedure onBeaconEnter(const Sender: TObject; const ABeacon: IBeacon; const CurrentBeaconList: TBeaconList);
    procedure onBeaconExit(const Sender: TObject; const ABeacon: IBeacon; const CurrentBeaconList: TBeaconList);
    procedure onEnterRegion(const Sender: TObject; const UUID: TGUID; Major, Minor: Integer);
    procedure onExitRegion(const Sender: TObject; const UUID: TGUID; Major, Minor: Integer);
    procedure onBeaconProximity(const Sender: TObject; const ABeacon: IBeacon; Proximity: TBeaconProximity);

    procedure OnOff_Check;



  public
    { Public declarations }
  end;

var
  frmEmp_CheckIn_Beacon: TfrmEmp_CheckIn_Beacon;
  BeaconDeviceList: array[0..9] of TBeaconDevice;
  l_Second:   Integer;
  l_CheckIn:  Boolean;
  l_CheckCnt: Integer=0;
  l_CheckDateTime: TDateTime;

  l_UUID:    String='';
  l_Major:   Word=0;
  l_Minor:   Word=0;

  l_CheckOn: String='';
  l_Where2:  String='';
  v_SysUser: String='';
const
  l_Height=25;

implementation

{$R *.fmx}

Uses Com_DataModule,Com_Variable,MainMenu,Com_Function;

type
  TDummyInt = class
  public
    Number: Integer;
  end;



procedure TfrmEmp_CheckIn_Beacon.FormCreate(Sender: TObject);
begin
  l_CheckIn             := false;
  ListView_Beacon.Align := Fmx.Types.TAlignLayout.Client;

  FLock := TObject.Create;
  FList := TList<TBeaconGraphicInfo>.Create;
  FRenderer := TRenderer.Create;
  FMaxDistance := 30;
end;


procedure TfrmEmp_CheckIn_Beacon.FormDestroy(Sender: TObject);
begin
  FBeaconManager.StopScan;

end;

procedure TfrmEmp_CheckIn_Beacon.FormShow(Sender: TObject);
begin

  FloatAni_OnOff.Stop;

  ListView_Beacon.Align := Fmx.Types.TAlignLayout.None;
  Label_Title.Text      := g_Sel_Title;
  Timer1.Enabled        := false;
  BtnStartScan.Visible  := true;
  BtnStopScan. Visible  := false;
  BtnClose.    Visible  := false;

  BtnStartScan.Align    := Fmx.Types.TAlignLayout.Client;
  BtnStopScan. Align    := Fmx.Types.TAlignLayout.Client;
  BtnClose.    Align    := Fmx.Types.TAlignLayout.Client;
  TMSFMXLED_OnOff.State := false;

  Layout_Pie.Visible    := false;
  FloatAnimation1.Stop;
  ListView_Beacon.Opacity := 0.1;
  QueryBeaconList(Sender);
  Beacon_SetManager;
  Beacon_Register;
  OnOff_Check;
  //Layout_OK.Visible := false;
end;



procedure TfrmEmp_CheckIn_Beacon.Image_EmpClick(Sender: TObject);
begin
  BtnStartScanClick(Sender);
end;

procedure TfrmEmp_CheckIn_Beacon.onBeaconEnter(const Sender: TObject; const ABeacon: IBeacon; const CurrentBeaconList: TBeaconList);
begin
  FBeacon := ABeacon;
  Text_Message.Text := 'onBeaconEnter:'+ABeacon.Major.ToString+ABeacon.Minor.ToString;
end;
procedure TfrmEmp_CheckIn_Beacon.onBeaconExit(const Sender: TObject; const ABeacon: IBeacon; const CurrentBeaconList: TBeaconList);
begin
  FBeacon := nil;
  Text_Message.Text := 'onBeaconExit: '+ABeacon.Major.ToString+':'+ABeacon.Minor.ToString;
end;

procedure TfrmEmp_CheckIn_Beacon.onEnterRegion(const Sender: TObject; const UUID: TGUID; Major, Minor: Integer);
begin
  Text_Message.Text := 'onEnterRegion:'+Major.ToString+':'+Minor.ToString;
end;

procedure TfrmEmp_CheckIn_Beacon.onExitRegion(const Sender: TObject; const UUID: TGUID; Major, Minor: Integer);
begin
  FBeacon := nil;
  Text_Message.Text := 'onExitRegion:'+Major.ToString+':'+Minor.ToString;
end;


procedure TfrmEmp_CheckIn_Beacon.onBeaconProximity(const Sender: TObject; const ABeacon: IBeacon; Proximity: TBeaconProximity);
begin
  FBeacon := ABeacon;
  Text_Message.Text := 'onBeaconProximity:'+ABeacon.Major.ToString+':'+ABeacon.Minor.ToString;
end;

procedure TfrmEmp_CheckIn_Beacon.QueryBeaconList(Sender: TObject);
var i:integer;
    LItem: TListViewItem;
begin
  ListView_Beacon.Items.Clear;
  ListView_Beacon.SearchVisible := false;
  ListView_Beacon.CanSwipeDelete:= false;
  with frmCom_DataModule.ClientDataSet_Proc do begin
    try
      p_CreatePrams;
      ParamByName('arg_ModCd' ).AsString := 'Emp_CheckIn_BeaconList';
      Open;
      ListView_Beacon.Height := l_Height*RecordCount;
      for i:=0 to RecordCount-1 do begin

        LItem            := ListView_Beacon.Items.Add;
        LItem.Tag        := 0;
        LItem.TagString  := FieldByName('bc_uuid' ).AsString+';'
                           +FieldByName('bc_major').AsString+';'
                           +FieldByName('bc_minor').AsString;
        LItem.Text       := FieldByName('where2'  ).AsString;
        {
        LItem.Text       := FieldByName('where1'  ).AsString+'-'
                           +FieldByName('where2'  ).AsString+' ('
                           +FieldByName('bc_major').AsString+'-'
                           +FieldByName('bc_minor').AsString+') '; }
        LItem.Detail     := LItem.Text;
        LItem.Height     := l_Height;
        LItem.Bitmap.Assign(frmCom_DataModule.ImageList.Bitmap(TSizeF.Create(300,300),0));
        Next;
      end;
      if RecordCount<1 then begin
        p_ShowMessage('등록된 비콘이 없습니다.');
      end;
    finally
      Close;
      if ListView_Beacon.ItemCount>0 then begin
         ListView_Beacon.Visible := true;
      end;
    end;
  end;
end;


procedure TfrmEmp_CheckIn_Beacon.StringToRegion(AString: string; var Guid: string; var Major: integer; var Minor: integer);
var LSplitted: TArray<string>;
begin
  LSplitted := AString.Split([';']);
  Guid      := LSplitted[0];
  Major     := LSplitted[1].ToInteger;
  Minor     := LSplitted[2].ToInteger;
end;


procedure TfrmEmp_CheckIn_Beacon.Beacon_SetManager;
begin
  if FBeaconManager = nil then begin
     try
       FBeaconManager := TBeaconManager.GetBeaconManager(TBeaconScanMode.Standard);
       FBeaconManager.OnBeaconEnter     := onBeaconEnter;
       FBeaconManager.OnBeaconExit      := onBeaconExit;
       FBeaconManager.OnEnterRegion     := onEnterRegion;
       FBeaconManager.OnExitRegion      := onExitRegion;
       FBeaconManager.OnBeaconProximity := onBeaconProximity;
       FBeaconManager.StopScan;
     except
       ShowMessage('Beacon_SetManager Error');
     end;
  end;
end;
procedure TfrmEmp_CheckIn_Beacon.BtnBCStartClick(Sender: TObject);
begin
  FloatAni_OnOff.Stop;
  l_Second              := 0;
  l_CheckCnt            := 0;
  l_CheckIn             := false;
  Timer1.Enabled        := false;
  FloatAni_OnOff.Stop;
  BtnStartScan.Visible  := false;
  BtnStopScan. Visible  := false;
  BtnClose.    Visible  := false;
  TMSFMXLED_OnOff.State := false;
  Text_BeaconInfo.Position.y := 1;
  Text_BeaconInfo.Text  := 'Beacon Scanning...';

  v_SysUser := 'Y';

  BtnStartScan.TextSettings.FontColor := TAlphaColors.Black;
  BtnStopScan.TextSettings.FontColor  := TAlphaColors.Black;
  BtnClose.TextSettings.FontColor     := TAlphaColors.Black;

  if ListView_Beacon.ItemCount<1 then begin
     p_ShowMessage('등록된 비콘이 없습니다.');
     BtnStartScan.Visible  := true;
     Exit;
  end;


//Image_Emp.Bitmap.Assign(frmMainMenu.Image_Emp.Bitmap);

 {$IFDEF ANDROID}
  PermissionsService.RequestPermissions(
    [JStringToString(TJManifest_permission.JavaClass.BLUETOOTH),
     JStringToString(TJManifest_permission.JavaClass.BLUETOOTH_ADMIN),
     JStringToString(TJManifest_permission.JavaClass.ACCESS_FINE_LOCATION)],
    procedure(const APermissions: TArray<string>; const AGrantResults: TArray<TPermissionStatus>)
    begin
      if (Length(AGrantResults) = 3) and
         (AGrantResults[0] = TPermissionStatus.Granted) and
         (AGrantResults[1] = TPermissionStatus.Granted) and
         (AGrantResults[2] = TPermissionStatus.Granted) then begin

          FBeaconManager.StartScan;
          BtnStopScan. Visible  := True;
          Timer1.Enabled        := True;
          Layout_Pie.Visible    := True;
          FloatAnimation1.Start;
          FloatAni_OnOff.Start;
      end
      else begin
        TDialogService.ShowMessage('블루투스 권한이 없습니다.');
      end;
    end);
 {$ELSE}

  FBeaconManager.StartScan;
  BtnStopScan. Visible  := True;
  Timer1.Enabled        := True;
  Layout_Pie.Visible    := True;
  FloatAnimation1.Start;
  FloatAni_OnOff.Start;
 {$ENDIF}

end;

procedure TfrmEmp_CheckIn_Beacon.Beacon_Register;
var
  LGUID:  string;
  LMajor: integer;
  LMinor: integer;
  GUID: TGUID;
  R : Boolean;
begin
  StringToRegion(ListView_Beacon.Items[0].TagString,LGUID,LMajor, LMinor);
  GUID := StringToGUID(LGUID);
  R    := FBeaconManager.RegisterBeacon(GUID);
end;

procedure TfrmEmp_CheckIn_Beacon.BtnStartScanClick(Sender: TObject);
begin
  FloatAni_OnOff.Stop;
  l_Second              := 0;
  l_CheckCnt            := 0;
  l_CheckIn             := false;
  Timer1.Enabled        := false;
  FloatAni_OnOff.Stop;
  BtnStartScan.Visible  := false;
  BtnStopScan. Visible  := false;
  BtnClose.    Visible  := false;
  TMSFMXLED_OnOff.State := false;
  Text_BeaconInfo.Position.y := 1;
  Text_BeaconInfo.Text  := 'Beacon Scanning...';

  BtnStartScan.TextSettings.FontColor := TAlphaColors.Black;
  BtnStopScan.TextSettings.FontColor  := TAlphaColors.Black;
  BtnClose.TextSettings.FontColor     := TAlphaColors.Black;

  if ListView_Beacon.ItemCount<1 then begin
     p_ShowMessage('등록된 비콘이 없습니다.');
     BtnStartScan.Visible  := true;
     Exit;
  end;


//Image_Emp.Bitmap.Assign(frmMainMenu.Image_Emp.Bitmap);

 {$IFDEF ANDROID}
  PermissionsService.RequestPermissions(
    [JStringToString(TJManifest_permission.JavaClass.BLUETOOTH),
     JStringToString(TJManifest_permission.JavaClass.BLUETOOTH_ADMIN),
     JStringToString(TJManifest_permission.JavaClass.ACCESS_FINE_LOCATION)],
    procedure(const APermissions: TArray<string>; const AGrantResults: TArray<TPermissionStatus>)
    begin
      if (Length(AGrantResults) = 3) and
         (AGrantResults[0] = TPermissionStatus.Granted) and
         (AGrantResults[1] = TPermissionStatus.Granted) and
         (AGrantResults[2] = TPermissionStatus.Granted) then begin

          FBeaconManager.StartScan;
          BtnStopScan. Visible  := True;
          Timer1.Enabled        := True;
          Layout_Pie.Visible    := True;
          FloatAnimation1.Start;
          FloatAni_OnOff.Start;
      end
      else begin
        TDialogService.ShowMessage('블루투스 권한이 없습니다.');
      end;
    end);
 {$ELSE}

  FBeaconManager.StartScan;
  BtnStopScan. Visible  := True;
  Timer1.Enabled        := True;
  Layout_Pie.Visible    := True;
  FloatAnimation1.Start;
  FloatAni_OnOff.Start;
 {$ENDIF}
end;



procedure TfrmEmp_CheckIn_Beacon.Timer1Timer(Sender: TObject);
var v_Timer:Boolean;
var i:integer;
var v_TagString:String;
var v_Proximity:String;

begin
  v_Timer        := Timer1.Enabled;
  Timer1.Enabled := false;
  l_Second       := l_Second+1;

  l_UUID   := '';
  l_Major  := 0;
  l_Minor  := 0;
  l_Where2 := '';

  Text_Time_StartStop.Text := '('+l_Second.ToString+')';

  if (Text_BeaconInfo.Position.y+Text_BeaconInfo.Height)>Image_Emp.Height
      then Text_BeaconInfo.Position.y := 1
      else Text_BeaconInfo.Position.y := Text_BeaconInfo.Position.y+Text_BeaconInfo.Height;

  if Assigned(FBeacon) then begin
     TMSFMXLED_OnOff.State := true;
     l_CheckIn             := true;
     Text_BeaconInfo.Text  := FBeacon.GUID.ToString+'] '
                            + FBeacon.Minor.ToString+':'+FBeacon.Major.ToString+')  거리:'
                            + FBeacon.Distance.ToString+'m';

    if      FBeacon.Proximity = TBeaconProximity.Immediate then v_Proximity:='I' //Immediate'
    else if FBeacon.Proximity = TBeaconProximity.Near      then v_Proximity:='N' //Near'
    else if FBeacon.Proximity = TBeaconProximity.Far       then v_Proximity:='F' //Far'
    else if FBeacon.Proximity = TBeaconProximity.Away      then v_Proximity:='A' //Away'
    else                                                        v_Proximity:='N';//None';

     v_TagString := FBeacon.GUID. ToString+';'+FBeacon.Major.ToString+';'+FBeacon.Minor.ToString;
     ListView_Beacon.BeginUpdate;
     for i:=0 to ListView_Beacon.ItemCount-1 do begin
       if (ListView_Beacon.Items[i].Tag = 0) and
          (ListView_Beacon.Items[i].TagString = v_TagString) then begin
           l_CheckCnt := l_CheckCnt + 1;
           ListView_Beacon.Items[i].Tag := 1;
           ListView_Beacon.Items[i].Objects.TextObject.TextColor := TAlphaColors.Green;
           ListView_Beacon.Items[i].Bitmap.Assign(frmCom_DataModule.ImageList.Bitmap(TSizeF.Create(300,300),1));
           ListView_Beacon.Items[i].Text := ListView_Beacon.Items[i].Detail+' : '
                                          + FBeacon.Distance.ToString+'m ('+v_Proximity+') '
                                          + FormatDateTime('HH:NN:SS',Now);
           l_CheckDateTime := Now;
           Break;
       end;
     end;
     ListView_Beacon.EndUpdate;
     ListView_Beacon.Height := l_Height*l_CheckCnt;
  end;

  Timer1.Enabled := v_Timer;


  if v_SysUser <> 'Y' then begin
    if l_CheckIn then begin
      if (l_Second >=05) then begin
        FloatAnimation1.Stop;
        FloatAni_OnOff.Stop;

        ListView_Beacon.Opacity:= 1;
        Layout_Pie.Visible     := false;
        Timer1.Enabled         := false;
        BtnStartScan.Visible   := false;
        BtnStopScan. Visible   := false;
        BtnClose.    Visible   := true;
        BtnClose.    Text      := '출근이 확인되었습니다';

        //Image_Emp.Bitmap.Assign(frmMainMenu.Image_MyPicture.Bitmap);
        Text_Time_StartStop.Text := FormatDateTime('HH:NN:SS',l_CheckDateTime)+' (Checkin ok!)';
        Text_Time_StartStop.TextSettings.FontColor := TAlphaColors.Green;



        BtnClose.TextSettings.FontColor := TAlphaColors.Green;
        FloatAni_OnOff.Stop;
        FBeaconManager.StopScan;

        l_UUID    := FBeacon.GUID.ToString;
        l_Major   := FBeacon.Major;
        l_Minor   := FBeacon.Minor;
        l_Where2  := ListView_Beacon.Items[0].Detail;  //

        for i:=ListView_Beacon.Items.Count-1 Downto 0 do begin
          if ListView_Beacon.Items[i].Tag=0 then begin
             ListView_Beacon.Items.Delete(i);
          end;
        end;
      //--------------------------------------------------------------------------
      // DB Insert ...
      //--------------------------------------------------------------------------
        with frmCom_DataModule.ClientDataSet_Proc do begin
          try
            p_CreatePrams;
            ParamByName('arg_ModCd'  ).AsString := 'Com_Insert_pc_onoff';
            ParamByName('arg_COMPANY').AsString := g_User_Company;
            ParamByName('arg_EMPNO'  ).AsString := g_User_EmpNo;
            ParamByName('arg_Text01' ).AsString := l_Where2;//g_User_Phone;
            ParamByName('arg_Text02' ).AsString := FormatDateTime('HH:NN:SS',l_CheckDateTime);
            ParamByName('arg_Text03' ).AsString := l_UUID;
            ParamByName('arg_Text04' ).AsString := l_Major.ToString;
            ParamByName('arg_Text05' ).AsString := l_Minor.ToString;
            Open;
          //Text_Time_StartStop.Text := FormatDateTime('HH:NN:SS',l_CheckDateTime)+' (Checkin ok!)';
          //Text_Time_StartStop.TextSettings.FontColor := TAlphaColors.Green;
            Close;
          except
            Close;
            Text_Time_StartStop.Text := '(Check-in Error!)';
            Text_Time_StartStop.TextSettings.FontColor := TAlphaColors.Gray;
          end;
        end;
        OnOff_Check;

      end
      else begin
        BtnStartScan.Visible  := false;
        BtnStopScan. Visible  := true;
        BtnClose.    Visible  := false;
      end;
    end else
    if (l_Second >=180) then begin
        FloatAni_OnOff.Stop;
        FloatAnimation1.Stop;
        Layout_Pie.Visible    := false;
        Timer1.Enabled        := false;
        BtnStartScan.Visible  := false;
        BtnStopScan. Visible  := false;
        BtnClose.    Visible  := false;
        BtnClose.    Text     := '출근을 확인할 수 없습니다.';
        FloatAni_OnOff.Stop;
        BtnClose.TextSettings.FontColor := TAlphaColors.Red;
        TDialogService.MessageDialog(('재시도 하시겠습니까?'),
              system.UITypes.TMsgDlgType.mtInformation,
              [system.UITypes.TMsgDlgBtn.mbYes, system.UITypes.TMsgDlgBtn.mbCancel], system.UITypes.TMsgDlgBtn.mbYes,0,
        procedure (const AResult: System.UITypes.TModalResult)
        begin
          case AResult of
            mrYes:    begin
                        BtnClose.   Text := '종료';
                        BtnStartScanClick(BtnStartScan);
                      end;
            mrCancel: btnCloseClick(btnClose);
          end;
        end);
    end
    else begin
     //Text_Time_StartStop.Text := '('+l_Second.ToString+')';
    end;
  end;
end;






procedure TfrmEmp_CheckIn_Beacon.FormKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
var FService : IFMXVirtualKeyboardService;
begin
  if (Key = vkHardwareBack) then begin
    TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, IInterface(FService));
    if (FService <> nil) and (TVirtualKeyboardState.Visible in FService.VirtualKeyBoardState) then begin
    end
    else begin
      Key := 0;
      btnCloseClick(btnClose);
    end;
  end;
end;




procedure TfrmEmp_CheckIn_Beacon.BtnStopScanClick(Sender: TObject);
begin
  FBeaconManager.StopScan;
  Timer1.Enabled       := false;
  BtnStartScan.Visible := True;
  BtnStopScan.Visible  := false;
  BtnClose.Visible     := false;
  FloatAni_OnOff.Stop;
  FBeaconManager.StopScan;
  Layout_Pie.Visible   := false;
end;

procedure TfrmEmp_CheckIn_Beacon.btnCloseClick(Sender: TObject);
begin
  if Timer1.Enabled then begin
    BtnStopScanClick(BtnStopScan);
    Exit;
  end
  else begin
    FBeaconManager.StopScan;
    FBeaconManager.Free;
    Self.Close;
  end;
end;

procedure TfrmEmp_CheckIn_Beacon.btnExitClick(Sender: TObject);
begin
  btnCloseClick(Sender);
end;

procedure TfrmEmp_CheckIn_Beacon.OnOff_Check;
begin
    //--------------------------------------------------------------------------
    // 근태조회
    //--------------------------------------------------------------------------
      with frmCom_DataModule.ClientDataSet_Proc do begin
        try
          Close;
          p_CreatePrams;
          ParamByName('arg_ModCd'  ).AsString := 'Saram_OnOff_List01';
          ParamByName('arg_COMPANY').AsString := g_User_Company;
          ParamByName('arg_EMPNO'  ).AsString := g_User_EmpNo;
          Open;
          Text_Work_Time.Text := FieldByName('WORK_TIMEFR'  ).AsString;
          Text_On_Time.Text   := FieldByName('Time_ON'      ).AsString;
          Text_On_Status.Text := FieldByName('onoff_status' ).AsString;
          if Text_On_Status.Text = '(지각)' then
             Text_On_Status.TextSettings.FontColor := TAlphaColors.Red;
          Text_On_Where.Text  := FieldByName('onoff_Gubun'  ).AsString;
          l_CheckOn           := FieldByName('YN_Gubun'     ).AsString;
          Close;
        except
          Close;
          Text_Time_StartStop.Text := '(Check-in Error!)';
          Text_Time_StartStop.TextSettings.FontColor := TAlphaColors.Gray;
        end;
      end;

    if l_CheckOn = 'Y' then Begin //출근확인
         Layout_OK.Visible  := True;
         Image_Emp.Visible := False;
    End
    else begin
         Layout_OK.Visible := False;
         Image_Emp.Visible := True;
    end;
end;






initialization
   RegisterClasses([TfrmEmp_CheckIn_Beacon]);

finalization
   UnRegisterClasses([TfrmEmp_CheckIn_Beacon]);

end.
