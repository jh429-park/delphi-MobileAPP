unit Emp_CheckIn;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Beacon,
  System.Bluetooth, System.Beacon.Components, FMX.Controls.Presentation,
  FMX.StdCtrls, FMX.ScrollBox, FMX.Memo, System.Bluetooth.Components,
  FMX.Objects, FMX.TMSBaseControl, FMX.TMSLed, FMX.Ani, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  FMX.DialogService,
  FMX.Platform,
  FMX.VirtualKeyboard,
{$IFDEF ANDROID}
  Androidapi.JNI.Os,
  Androidapi.JNI.JavaTypes,
  Androidapi.Helpers,
{$ENDIF}
  System.Permissions, FMX.Layouts;

type
  TfrmEmp_CheckIn = class(TForm)
    Beacon1: TBeacon;
    Timer1: TTimer;
    HeaderToolBar: TToolBar;
    Label_Title: TLabel;
    TMSFMXLED_OnOff: TTMSFMXLED;
    btnExit: TButton;
    ListView_Beacon: TListView;
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

    procedure QueryBeaconList(Sender: TObject);
    procedure BtnStartScanClick(Sender: TObject);
    procedure BtnStopScanClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Beacon1BeaconEnter(const Sender: TObject; const ABeacon: IBeacon;
      const CurrentBeaconList: TBeaconList);
    procedure Timer1Timer(Sender: TObject);
    procedure Beacon1BeaconExit(const Sender: TObject; const ABeacon: IBeacon;
      const CurrentBeaconList: TBeaconList);
    procedure FormCreate(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
  private
    { Private declarations }

    FBeacon : IBeacon;


    FBeaconManager: TBeaconManager;

  public
    { Public declarations }
  end;

var
  frmEmp_CheckIn: TfrmEmp_CheckIn;
  BeaconDeviceList: array[0..9] of TBeaconDevice;
  l_Second:  Integer;
  l_CheckIn: Boolean;

  l_UUID:    String='';
  l_Major:   Word=0;
  l_Minor:   Word=0;

implementation

{$R *.fmx}

Uses Com_DataModule,Com_Variable,MainMenu,Com_Function;

procedure TfrmEmp_CheckIn.FormCreate(Sender: TObject);
begin
  l_CheckIn             := false;
  ListView_Beacon.Align := Fmx.Types.TAlignLayout.Client;
  FBeaconManager        := TBeaconManager.GetBeaconManager(TBeaconScanMode(0));
end;


procedure TfrmEmp_CheckIn.FormShow(Sender: TObject);
begin
  if TMSFMXLED_OnOff.Height > TMSFMXLED_OnOff.Width
     then TMSFMXLED_OnOff.Height := TMSFMXLED_OnOff.Width
     else TMSFMXLED_OnOff.Width := TMSFMXLED_OnOff.Height;

  ListView_Beacon.Align := Fmx.Types.TAlignLayout.None;
  Label_Title.Text      := g_Sel_Title;
  Timer1.Enabled        := false;
  Beacon1.Enabled       := false;
  BtnStartScan.Visible  := true;
  BtnStopScan. Visible  := false;
  BtnClose.    Visible  := false;

  BtnStartScan.Align    := Fmx.Types.TAlignLayout.Client;
  BtnStopScan. Align    := Fmx.Types.TAlignLayout.Client;
  BtnClose.    Align    := Fmx.Types.TAlignLayout.Client;
  TMSFMXLED_OnOff.State := false;

  Layout_Pie.Visible    := false;
  FloatAnimation1.Stop;


  QueryBeaconList(Sender);


end;

procedure TfrmEmp_CheckIn.QueryBeaconList(Sender: TObject);
var i:integer;
    LItem: TListViewItem;
begin
  with frmCom_DataModule.ClientDataSet_Proc do begin
    try
      p_CreatePrams;
      ParamByName('arg_ModCd' ).AsString := 'fms_security_BeaconList01';
      Open;
      ListView_Beacon.Items.Clear;
      ListView_Beacon.SearchVisible := false;
      ListView_Beacon.CanSwipeDelete:= false;
      ListView_Beacon.Height := 25*RecordCount;
      for i:=0 to RecordCount-1 do begin
        LItem            := ListView_Beacon.Items.Add;
        LItem.Text       := FieldByName('where1'  ).AsString+'-'
                           +FieldByName('where2'  ).AsString+' ('
                           +FieldByName('bc_major').AsString+'-'
                           +FieldByName('bc_minor').AsString+') ';
        LItem.Height := 25;
        FBeaconManager.RegisterBeacon(TGUID.Create(FieldByName('bc_uuid' ).AsString)
                                     ,FieldByName('bc_major').AsInteger
                                     ,FieldByName('bc_minor').AsInteger);
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





procedure TfrmEmp_CheckIn.BtnStartScanClick(Sender: TObject);
begin
  FloatAni_OnOff.Stop;
  l_Second              := 0;
  l_CheckIn             := false;
  Timer1.Enabled        := false;
  Beacon1.Enabled       := false;
  BtnStartScan.Visible  := false;
  BtnStopScan. Visible  := false;
  BtnClose.    Visible  := false;
  TMSFMXLED_OnOff.State := false;
  Text_BeaconInfo.Position.y := 1;
  Text_BeaconInfo.Text  := 'Beacon Scanning...';

  BtnStartScan.TextSettings.FontColor := TAlphaColors.Black;
  BtnStopScan.TextSettings.FontColor  := TAlphaColors.Black;
  BtnClose.TextSettings.FontColor     := TAlphaColors.Black;

  Image_Emp.Bitmap.Assign(frmMainMenu.Image_Emp.Bitmap);


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

          Beacon1.Enabled       := True;
          BtnStopScan. Visible  := True;
          TMSFMXLED_OnOff.State := True;
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
  Beacon1.Enabled       := true;
  BtnStopScan. Visible  := True;
  TMSFMXLED_OnOff.State := True;
  Timer1.Enabled        := True;
  Layout_Pie.Visible    := True;
  FloatAnimation1.Start;
  FloatAni_OnOff.Start;
{$ENDIF}
end;








procedure TfrmEmp_CheckIn.Timer1Timer(Sender: TObject);
var v_Timer:Boolean;
begin
  v_Timer        := Timer1.Enabled;
  Timer1.Enabled := false;
  l_Second       := l_Second+1;

  l_UUID  := '';
  l_Major := 0;
  l_Minor := 0;

  Text_Time_StartStop.Text := '('+l_Second.ToString+')';

  if (Text_BeaconInfo.Position.y+Text_BeaconInfo.Height)>Image_Emp.Height
      then Text_BeaconInfo.Position.y := 1
      else Text_BeaconInfo.Position.y := Text_BeaconInfo.Position.y+Text_BeaconInfo.Height;

  if Assigned(FBeacon) then begin
     l_CheckIn := true;
     Text_BeaconInfo.Text := FBeacon.GUID.ToString+'] '
                           + FBeacon.Minor.ToString+':'+FBeacon.Major.ToString+')  거리:'
                           + FBeacon.Distance.ToString+'m';

    if      FBeacon.Proximity = TBeaconProximity.Immediate then Text_BeaconInfo.Text := Text_BeaconInfo.Text+', Immediate'
    else if FBeacon.Proximity = TBeaconProximity.Near      then Text_BeaconInfo.Text := Text_BeaconInfo.Text+', Near'
    else if FBeacon.Proximity = TBeaconProximity.Far       then Text_BeaconInfo.Text := Text_BeaconInfo.Text+', Far'
    else if FBeacon.Proximity = TBeaconProximity.Away      then Text_BeaconInfo.Text := Text_BeaconInfo.Text+', Away'
    else                                                        Text_BeaconInfo.Text := Text_BeaconInfo.Text+', None';

  end;

  Timer1.Enabled := v_Timer;

  if l_CheckIn then begin
    if (l_Second >=05) then begin
      FloatAnimation1.Stop;
      FloatAni_OnOff.Stop;
      Layout_Pie.Visible    := false;
      Timer1.Enabled        := false;
      BtnStartScan.Visible  := false;
      BtnStopScan. Visible  := false;
      BtnClose.    Visible  := true;
      BtnClose.    Text     := '출근이 확인되었습니다';
      BtnClose.TextSettings.FontColor := TAlphaColors.Green;

      l_UUID  := FBeacon.GUID.ToString;
      l_Major := FBeacon.Major;
      l_Minor := FBeacon.Minor;

    //--------------------------------------------------------------------------
    // DB Insert ...
    //--------------------------------------------------------------------------
      with frmCom_DataModule.ClientDataSet_Proc do begin
        try
          p_CreatePrams;
          ParamByName('arg_ModCd'  ).AsString := 'Com_Insert_pc_onoff';
          ParamByName('arg_COMPANY').AsString := g_User_Company;
          ParamByName('arg_EMPNO'  ).AsString := g_User_EmpNo;
          ParamByName('arg_Text01' ).AsString := g_User_Phone;
          ParamByName('arg_Text02' ).AsString := FormatDateTime('HH:NN:SS',Now);
          ParamByName('arg_Text03' ).AsString := l_UUID;
          ParamByName('arg_Text04' ).AsString := l_Major.ToString;
          ParamByName('arg_Text05' ).AsString := l_Minor.ToString;
          Open;
          Text_Time_StartStop.Text := '(Check-in ok!)';
          Text_Time_StartStop.TextSettings.FontColor := TAlphaColors.Green;
          Close;
        except
          Close;
          Text_Time_StartStop.Text := '(Check-in Error!)';
          Text_Time_StartStop.TextSettings.FontColor := TAlphaColors.Gray;
        end;
      end;
    //--------------------------------------------------------------------------

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
      BtnClose.TextSettings.FontColor := TAlphaColors.Red;
      TDialogService.MessageDialog(('재시도 하시겠습니까?'),
            system.UITypes.TMsgDlgType.mtInformation,
            [system.UITypes.TMsgDlgBtn.mbYes, system.UITypes.TMsgDlgBtn.mbCancel], system.UITypes.TMsgDlgBtn.mbYes,0,
      procedure (const AResult: System.UITypes.TModalResult)
      begin
        case AResult of
          mrYes:    BtnStartScanClick(BtnStartScan);
          mrCancel: btnCloseClick(btnClose);
        end;
      end);
  end
  else begin
   //Text_Time_StartStop.Text := '('+l_Second.ToString+')';
  end;
end;


procedure TfrmEmp_CheckIn.Beacon1BeaconEnter(const Sender: TObject; const ABeacon: IBeacon; const CurrentBeaconList: TBeaconList);
begin
  FBeacon := ABeacon;
  TMSFMXLED_OnOff.State := true;
end;

procedure TfrmEmp_CheckIn.Beacon1BeaconExit(const Sender: TObject; const ABeacon: IBeacon; const CurrentBeaconList: TBeaconList);
begin
  FBeacon := nil;
  TMSFMXLED_OnOff.State := false;
end;

procedure TfrmEmp_CheckIn.BtnStopScanClick(Sender: TObject);
begin
  Timer1.Enabled        := false;
  Beacon1.Enabled       := false;
  Beacon1.StopScan;
  BtnStartScan.Visible  := True;
  BtnStopScan.Visible   := false;
  BtnClose.Visible      := false;
  TMSFMXLED_OnOff.State := false;
  FloatAnimation1.Stop;
  Layout_Pie.Visible    := false;
  FloatAni_OnOff.Stop;
end;

procedure TfrmEmp_CheckIn.btnCloseClick(Sender: TObject);
begin
  btnExitClick(btnExit);
end;

procedure TfrmEmp_CheckIn.btnExitClick(Sender: TObject);
begin
  Beacon1.StopScan;
  Timer1.Enabled        := false;
  Beacon1.Enabled       := false;
  BtnStartScan.Visible  := True;
  BtnStopScan.Visible   := false;
  BtnClose.Visible      := false;
  TMSFMXLED_OnOff.State := false;
  FloatAnimation1.Stop;
  Close;
end;


procedure TfrmEmp_CheckIn.FormKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
var FService : IFMXVirtualKeyboardService;
begin
  if (Key = vkHardwareBack) then begin
    TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, IInterface(FService));
    if (FService <> nil) and (TVirtualKeyboardState.Visible in FService.VirtualKeyBoardState) then begin
    end
    else if (Beacon1.Enabled) or (Timer1.Enabled) then begin
      Key := 0;
      Beacon1.StopScan;
      Timer1.Enabled       := false;
      Beacon1.Enabled      := false;
      BtnStartScan.Visible := True;
      BtnStopScan.Visible  := false;
      BtnClose.Visible     := false;
    end
    else begin
      Key := 0;
      TDialogService.MessageDialog(('종료하시겠습니까?'),
            system.UITypes.TMsgDlgType.mtInformation,
            [system.UITypes.TMsgDlgBtn.mbYes, system.UITypes.TMsgDlgBtn.mbCancel], system.UITypes.TMsgDlgBtn.mbYes,0,
      procedure (const AResult: System.UITypes.TModalResult)
      begin
        case AResult of
          mrYes: begin
                   Beacon1.StopScan;
                   Timer1.Enabled  := false;
                   Beacon1.Enabled := false;
                   Self.Close;
                 end;
        end;
      end);
    end;
  end;
end;

initialization
   RegisterClasses([TfrmEmp_CheckIn]);

finalization
   UnRegisterClasses([TfrmEmp_CheckIn]);

end.
