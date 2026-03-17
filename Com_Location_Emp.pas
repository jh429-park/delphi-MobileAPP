unit Com_Location_Emp;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, System.Sensors, FMX.StdCtrls,
  FMX.Edit, FMX.WebBrowser, FMX.ListBox, FMX.Layouts, System.Sensors.Components,
  FMX.Controls.Presentation, FMX.EditBox, FMX.NumberBox, FMX.Objects,
  FMX.ScrollBox, FMX.Memo;

type
  TfrmCom_Location_Emp = class(TForm)
    WebBrowser1: TWebBrowser;
    ListBox1: TListBox;
    lbTriggerDistance: TListBoxItem;
    nbTriggerDistance: TNumberBox;
    Button1: TButton;
    Button2: TButton;
    lbAccuracy: TListBoxItem;
    Button3: TButton;
    Button4: TButton;
    nbAccuracy: TNumberBox;
    ToolBar1: TToolBar;
    Label_Title: TLabel;
    MenuButton: TButton;
    LocationSensor1: TLocationSensor;
    Layout1: TLayout;
    swLoadView: TSwitch;
    Switch_LocationSensor: TSwitch;
    Timer_Save: TTimer;
    Switch_Save: TSwitch;
    swGoogle: TSwitch;
    Text_Address: TText;
    Text_LatLong: TText;

    procedure LocationSensor1LocationChanged(Sender: TObject; const OldLocation, NewLocation: TLocationCoord2D);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure nbTriggerDistanceChange(Sender: TObject);
    procedure nbAccuracyChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure swLoadViewSwitch(Sender: TObject);
    procedure Switch_LocationSensorSwitch(Sender: TObject);
    procedure Switch_SaveSwitch(Sender: TObject);
    procedure Timer_SaveTimer(Sender: TObject);
  private
    { Private declarations }
    FGeocoder: TGeocoder;
    procedure OnGeocodeReverseEvent(const Address: TCivicAddress);
  public
    { Public declarations }
  end;

var
  frmCom_Location_Emp: TfrmCom_Location_Emp;

  l_Count:        Integer=0;
  l_Address:      String ='';
  l_Latitude:     String ='';
  l_Longitude:    String ='';

  l_Address_old:  String ='';
  l_Latitude_old: String ='';
  l_Longitude_old:String ='';

//DistMeters := DistGPS*111120;  //to meters


implementation

{$R *.fmx}

uses Com_DataModule,Com_function,Com_Variable,
{$IFDEF ANDROID}
  Androidapi.JNI.Os,
  Androidapi.JNI.JavaTypes,
  Androidapi.Helpers,
  System.Android.Sensors,
{$ENDIF}

{$IFDEF IOS}
  System.IOS.Sensors,
{$ENDIF}

  System.Permissions,
  FMX.DialogService;
procedure TfrmCom_Location_Emp.FormShow(Sender: TObject);
var v_MapsURL: String;
begin
  Label_Title.Text   := g_Sel_Title;
  ListBox1.Visible   := true;
  Timer_Save.Enabled := Switch_Save.IsChecked;
  Switch_LocationSensor.IsChecked := true;
  Switch_LocationSensorSwitch(Sender);
end;


procedure TfrmCom_Location_Emp.swLoadViewSwitch(Sender: TObject);
begin
  if Switch_LocationSensor.IsChecked then begin
    Switch_LocationSensor.IsChecked := false;
    Application.ProcessMessages;
    Switch_LocationSensor.IsChecked := true;
    Application.ProcessMessages;
  //Switch_LocationSensorSwitch(Sender);
  end;
end;





procedure TfrmCom_Location_Emp.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;



procedure TfrmCom_Location_Emp.LocationSensor1LocationChanged(Sender: TObject; const OldLocation, NewLocation: TLocationCoord2D);
var v_MapsURL: String;
begin
  WebBrowser1.EnableCaching := false;
  if      swGoogle.IsChecked   then v_MapsURL := c_URL_Google_Map
  else if swLoadView.IsChecked then v_MapsURL := c_URL_Daum_RoadView
  else                              v_MapsURL := c_URL_Daum_Map_EmpList;

  l_Latitude  := Format('%2.10f',[NewLocation.Latitude]);
  l_Longitude := Format('%2.10f',[NewLocation.Longitude]);
  if True then

  Text_LatLong.Text:= '('+l_Latitude+', '+l_Longitude+')';
  WebBrowser1.Navigate(Format(v_MapsURL,[l_Latitude,l_Longitude]));

  try
    if not Assigned(FGeocoder) then begin
      if Assigned(TGeocoder.Current) then FGeocoder := TGeocoder.Current.Create;
      if Assigned(FGeocoder) then FGeocoder.OnGeocodeReverse := OnGeocodeReverseEvent;
    end;
    if Assigned(FGeocoder) and not FGeocoder.Geocoding then begin
       FGeocoder.GeocodeReverse(NewLocation);
    end;
  except
    p_Toast('Geocoder service error');
  end;
end;

procedure TfrmCom_Location_Emp.Switch_SaveSwitch(Sender: TObject);
begin

  Timer_Save.Enabled := Switch_Save.IsChecked and Switch_LocationSensor.IsChecked;
  if Timer_Save.Enabled then Timer_SaveTimer(Sender);
end;


procedure TfrmCom_Location_Emp.Timer_SaveTimer(Sender: TObject);
var v_Timer:Boolean;
begin
  if ((l_Latitude=l_Latitude_old) and (l_Longitude=l_Longitude_old)) or
     ((l_Latitude='') or (l_Longitude='')) then Exit;

  v_Timer := Timer_Save.Enabled;
  Timer_Save.Enabled := false;
  Text_LatLong.Text := '('+l_Latitude+', '+l_Longitude+')';
  with frmCom_DataModule.ClientDataSet_Proc do begin
    try
      p_CreatePrams;
      ParamByName('arg_ModCd'  ).AsString := 'Com_Location_Insert';
      ParamByName('arg_Company').AsString := g_User_Company;
      ParamByName('arg_Dept'   ).AsString := g_User_Dept;
      ParamByName('arg_EmpNo'  ).AsString := g_User_EmpNo;
      ParamByName('arg_Text01' ).AsString := Copy(l_Latitude, 1, 50);
      ParamByName('arg_Text02' ).AsString := Copy(l_Longitude,1, 50);
      ParamByName('arg_Text03' ).AsString := Copy(l_Address,  1,200);
      ParamByName('arg_Text04' ).AsString := '';
      Open;
      l_Count := l_Count+1;
      Text_LatLong.Text := Text_LatLong.Text+' ['+l_Count.ToString+'/'+FieldByName('CNT').AsString+']';
      l_Latitude_old    := l_Latitude;
      l_Longitude_old   := l_Longitude;
      Close;
      Timer_Save.Enabled:= v_Timer;
    Except
      on e: Exception do begin
        Text_LatLong.Text  := Text_LatLong.Text+'Send Error!';
        Close;
        Exit;
      end;
    end;
  end;
end;


procedure TfrmCom_Location_Emp.OnGeocodeReverseEvent(const Address: TCivicAddress);
begin
  Text_Address.Text := '';
  l_Address         := '';
//Text_Address.Text := Text_Address.Text+' '+Address.AdminArea;
//Text_Address.Text := Text_Address.Text+' '+Address.CountryCode;
//Text_Address.Text := Text_Address.Text+' '+Address.CountryName;
//Text_Address.Text := Text_Address.Text+' '+Address.FeatureName;
  Text_Address.Text := Text_Address.Text+' '+Address.Locality;
  Text_Address.Text := Text_Address.Text+' '+Address.PostalCode;
  Text_Address.Text := Text_Address.Text+' '+Address.SubAdminArea;
  Text_Address.Text := Text_Address.Text+' '+Address.SubLocality;
  Text_Address.Text := Text_Address.Text+' '+Address.SubThoroughfare;
  Text_Address.Text := Text_Address.Text+' '+Address.Thoroughfare;
  l_Address         := Text_Address.Text;
end;



procedure TfrmCom_Location_Emp.MenuButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCom_Location_Emp.nbAccuracyChange(Sender: TObject);
begin
  { set the precision }
  LocationSensor1.Accuracy := nbAccuracy.Value;
end;

procedure TfrmCom_Location_Emp.nbTriggerDistanceChange(Sender: TObject);
begin
  { set the triggering distance }
  LocationSensor1.Distance := nbTriggerDistance.Value;
end;


procedure TfrmCom_Location_Emp.Switch_LocationSensorSwitch(Sender: TObject);
begin
{$IFDEF ANDROID}
  if Switch_LocationSensor.IsChecked then begin
    PermissionsService.RequestPermissions([JStringToString(TJManifest_permission.JavaClass.ACCESS_FINE_LOCATION)],
      procedure(const APermissions: TArray<string>;
      const AGrantResults: TArray<TPermissionStatus>)
      begin
        if (Length(AGrantResults)=1) and (AGrantResults[0]=TPermissionStatus.Granted) then begin
          { activate or deactivate the location sensor }
          LocationSensor1.Active := True
        end
        else begin
          Switch_LocationSensor.IsChecked := false;
          TDialogService.ShowMessage('Location permission not granted');
        end;
      end);
  end
  else begin
    LocationSensor1.Active := false;
  end;
{$ENDIF}
end;



procedure TfrmCom_Location_Emp.Button1Click(Sender: TObject);
begin
  nbTriggerDistance.Value := nbTriggerDistance.Value - 1;
end;

procedure TfrmCom_Location_Emp.Button2Click(Sender: TObject);
begin
  nbTriggerDistance.Value := nbTriggerDistance.Value + 1;
end;

procedure TfrmCom_Location_Emp.Button3Click(Sender: TObject);
begin
  nbAccuracy.Value := nbAccuracy.Value - 1;
end;

procedure TfrmCom_Location_Emp.Button4Click(Sender: TObject);
begin
  nbAccuracy.Value := nbAccuracy.Value + 1;
end;


end.

