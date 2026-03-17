unit Com_Location_Research;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, System.Sensors, FMX.StdCtrls,
  FMX.Edit, FMX.WebBrowser, FMX.ListBox, FMX.Layouts, System.Sensors.Components,
  FMX.Controls.Presentation, FMX.EditBox, FMX.NumberBox, FMX.Objects,
  FMX.ScrollBox, FMX.Memo;

type
  TfrmCom_Location_Research = class(TForm)
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
    Text_Address: TText;
    Switch_LocationSensor: TSwitch;
    Text_LatLong: TText;

    procedure LocationSensor1LocationChanged(Sender: TObject; const OldLocation, NewLocation: TLocationCoord2D);
    procedure FormShow(Sender: TObject);
    procedure MenuButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure swLoadViewSwitch(Sender: TObject);
    procedure Switch_LocationSensorSwitch(Sender: TObject);
  private
    { Private declarations }
    FGeocoder: TGeocoder;
    procedure OnGeocodeReverseEvent(const Address: TCivicAddress);
  public
    { Public declarations }
  end;

var
  frmCom_Location_Research: TfrmCom_Location_Research;

  l_Count:    Integer=0;
  l_Address:  String ='';
  l_Latitude: String ='';
  l_Longitude:String ='';

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
procedure TfrmCom_Location_Research.FormShow(Sender: TObject);
begin
  Label_Title.Text   := g_Sel_Title;
  ListBox1.Visible   := false;
  Switch_LocationSensor.IsChecked := true;
  Switch_LocationSensorSwitch(Sender);
end;


procedure TfrmCom_Location_Research.swLoadViewSwitch(Sender: TObject);
begin
  if Switch_LocationSensor.IsChecked then begin
    Switch_LocationSensor.IsChecked := false;
    Application.ProcessMessages;
    Switch_LocationSensor.IsChecked := true;
    Application.ProcessMessages;
  //Switch_LocationSensorSwitch(Sender);
  end;
end;





procedure TfrmCom_Location_Research.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;



procedure TfrmCom_Location_Research.LocationSensor1LocationChanged(Sender: TObject; const OldLocation, NewLocation: TLocationCoord2D);
var v_MapsURL: String;
//var Flags: OLEVariant;
begin
//Flags:=4; //Navigate NoRead From Cache
//WebBrowser1.Navigate('http://www.ghisler.com/', Flags);
  WebBrowser1.EnableCaching := false;
  if swLoadView.IsChecked
    then v_MapsURL := c_URL_Daum_RoadView
    else v_MapsURL := c_URL_Daum_Map_BDList;

  l_Latitude  := Format('%2.10f',[NewLocation.Latitude]);
  l_Longitude := Format('%2.10f',[NewLocation.Longitude]);

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

procedure TfrmCom_Location_Research.OnGeocodeReverseEvent(const Address: TCivicAddress);
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



procedure TfrmCom_Location_Research.MenuButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCom_Location_Research.Switch_LocationSensorSwitch(Sender: TObject);
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



end.
