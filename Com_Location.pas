unit Com_Location;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, System.Sensors, FMX.StdCtrls,
  FMX.Edit, FMX.WebBrowser, FMX.ListBox, FMX.Layouts, System.Sensors.Components,
  FMX.Controls.Presentation, FMX.EditBox, FMX.NumberBox, FMX.Objects,
  FMX.ScrollBox, FMX.Memo;

type
  TfrmCom_Location = class(TForm)
    WebBrowser1: TWebBrowser;
    ToolBar1: TToolBar;
    Label_Title: TLabel;
    MenuButton: TButton;
    Layout1: TLayout;
    swLoadView: TSwitch;
    Text_Address: TText;
    Switch_LocationSensor: TSwitch;
    Text_LatLong: TText;
    Timer_Save: TTimer;
    LocationSensor1: TLocationSensor;
    procedure FormShow(Sender: TObject);
    procedure MenuButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FGeocoder: TGeocoder;
    procedure OnGeocodeReverseEvent(const Address: TCivicAddress);
  public
    { Public declarations }
  end;

var
  frmCom_Location: TfrmCom_Location;


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


procedure TfrmCom_Location.FormShow(Sender: TObject);
var v_MapsURL: String;
var v_Location: TLocationCoord2D;
var l_Latitude,l_Longitude:String;
begin
  Label_Title.Text   := g_Sel_Title;
  WebBrowser1.EnableCaching := false;
  if swLoadView.IsChecked
    then v_MapsURL := c_URL_Daum_RoadView
    else v_MapsURL := c_URL_Daum_Map;
  l_Latitude  := g_Sel_Latitude;
  l_Longitude := g_Sel_Longitude;
  Text_LatLong.Text:= '('+l_Latitude+', '+l_Longitude+')';
  WebBrowser1.Navigate(Format(v_MapsURL,[l_Latitude,l_Longitude]));

  //www.genstarre.com/SARA_Erp/Daum/Daum_Map.asp?p1=36.53713&p2=127.00544

  v_Location := TLocationCoord2D.Create(l_Latitude.ToDouble,l_Longitude.ToDouble);

  try
    if not Assigned(FGeocoder) then begin
      if Assigned(TGeocoder.Current) then FGeocoder := TGeocoder.Current.Create;
      if Assigned(FGeocoder) then FGeocoder.OnGeocodeReverse := OnGeocodeReverseEvent;
    end;
    if Assigned(FGeocoder) and not FGeocoder.Geocoding then begin
       FGeocoder.GeocodeReverse(v_Location);
    end;
  except
    p_Toast('Geocoder service error');
  end;

end;


procedure TfrmCom_Location.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;



procedure TfrmCom_Location.OnGeocodeReverseEvent(const Address: TCivicAddress);
begin
  Text_Address.Text := '';
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
end;



procedure TfrmCom_Location.MenuButtonClick(Sender: TObject);
begin
  Close;
end;

end.

