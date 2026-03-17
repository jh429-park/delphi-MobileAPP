unit Com_function;

interface

uses
 {$IF Defined(MSWINDOWS)}
  Winapi.ShellAPI,
  Winapi.Windows,
 {$ENDIF}
  FMX.TMSCheckGroupPicker,
  FMX.GridExcelIO,
  FMX.ActnList,
  FMXTee.Engine,
  FMXTee.Procs,
  FMXTee.Chart,
  FMXTee.Series,
  FMXTee.Chart.Functions,
  FMX.DialogService,
  Fmx.ListBox,
  Fmx.Graphics,
  Fmx.Dialogs,
  Fmx.Platform,
  Fmx.Forms,
  Fmx.ImgList,
  Fmx.ListView,
  FMX.ListView.Appearances,
  FMX.ListView.Types,
  FMX.MultiResBitmap,
  FMX.Types,
  FMX.StdCtrls,
  FMX.TMSRadioGroupPicker,
  FMX.Controls, FMX.TMSPlanner,
  FMX.TMSPlannerDatabaseAdapter, FMX.TMSBaseControl, FMX.TMSPlannerBase,
  FMX.TMSPlannerData, FMX.Controls.Presentation, FMX.DateTimeCtrls,

  Datasnap.DBClient,
  Data.DB,
  System.JSON,
  System.StrUtils,
  System.Net.HttpClient,
  System.Rtti,
  System.Diagnostics,
  IdHTTP,
  IdSSLOpenSSL,
  System.Net.HttpClientComponent,
  System.UITypes,
  System.Character,
  System.Variants,
  System.Permissions,
  System.Sensors.Components,
  System.IOUtils,
  System.UIConsts,
  System.PushNotification,
  System.Types,
  System.IniFiles,
  System.SysUtils,
  System.Classes,
  System.Math,
  System.DateUtils,
//Posix.Unistd,
  IdGlobalProtocols,
  IdURI,
 {$IF Defined(ANDROID)}
  FMX.Helpers.Android,
  FMX.Platform.Android,
  FMX.PushNotification.Android,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNIBridge,
  AndroidAPI.JNI.JavaTypes,
  Androidapi.JNI.Net,
  Androidapi.JNI.Location,
  Androidapi.JNI.App,
  Androidapi.JNI.Webkit,
  Androidapi.Helpers,
  Androidapi.JNI.Os,
  Androidapi.IOUtils,
  Android.JNI.Toast,
 {$ELSEIF Defined(IOS)}
  iOSApi.Foundation,
  iOSapi.UIKit,
  FMX.Helpers.iOS,
  Macapi.CoreFoundation,
  FMX.MediaLibrary.iOS,
  Macapi.Helpers,
  FMX.PushNotification.IOS,
  Macapi.ObjectiveC,

//FGX.Toasts,
//FGX.Toasts.iOS,

 {$ENDIF}
  FMX.TMSGrid,
  FMX.TMSGridData,
  FMX.TMSGridOptions,
  FMX.TMSGridCell;

{$IF Defined(ANDROID)}
function  f_NetworkIsConnected: Boolean;
function  f_NetworkIsWiFiConnected: Boolean;
function  f_NetworkIsMobileConnected: Boolean;
{$ENDIF}

{$IFDEF Android}
function  f_LaunchActivityForResult(const Intent: JIntent; RequestCode: Integer): Boolean;
function  f_LaunchActivity(const Action: JString; const URI: Jnet_Uri): Boolean; overload;
function  f_LaunchActivity(const Intent: JIntent): Boolean; overload;
{$ENDIF}

procedure StyleComboBoxItems(ComboBox:TComboBox; Size:Single);
function  f_Query_TMSFMXGrid(aForm:TForm; aTMSFMXGrid:TTMSFMXGrid; aFixedCols, aFooterRow:integer): integer;
Procedure p_Excel_DownLoad_Grid(TMSFMXGrid: TTMSFMXGrid);
Procedure p_Excel_DownLoad_ListView(aForm:TForm;a_ActionName,a_arg_Text01,a_arg_Text02,a_arg_Text03,a_arg_Text04,a_arg_Text05:String);

//Procedure p_Excel_DownLoad(aForm:TForm; TMSFMXGrid: TTMSFMXGrid;a_FileName:String);
Procedure p_SetCombo_Dept(aCombo:TTMSFMXRadioGroupPicker; aAll:Boolean);

function f_Query_PlanerList(aForm:TForm; aPlanner:TTMSFMXPlanner; aDateFr,aDateTo:TDateTime; aSelect:Boolean): integer;  overload;
function f_Query_PlanerList(aForm:TForm; aPlanner:TTMSFMXPlanner; aDateFr,aDateTo:TDateTime; aSelect:Boolean; aUnit,aDStart,aDEnd,aAStart,aAEnd:Integer): integer;  overload;

procedure p_ClearPlaner(aForm:TForm; aPlanner:TTMSFMXPlanner; aDateEdit:TDateEdit); Overload;
procedure p_ClearPlaner(aForm:TForm; aPlanner:TTMSFMXPlanner; aDateEdit:TDateEdit; aUnit,aHeight:Integer); Overload;
procedure p_ClearPlaner(aForm:TForm; aPlanner:TTMSFMXPlanner; aDateTime:TDateTime; aUnit,aHeight:Integer); Overload;
procedure p_ClearPlaner(aForm:TForm; aPlanner:TTMSFMXPlanner; aDateTime:TDateTime); Overload;

procedure p_CopyPaste(aString: String);

procedure p_SetComboBox(aComboBox:TTMSFMXRadioGroupPicker; aHCode:String); overload;
procedure p_SetComboBox(aComboBox:TTMSFMXRadioGroupPicker; aCompany,aHCode:String); overload;
procedure p_SetComboBox(aComboBox:TTMSFMXRadioGroupPicker; aCompany,aHCode,aDCode:String); overload;
procedure p_GetComboBox(aChkCombo:TTMSFMXRadioGroupPicker; aValues:String);

procedure p_SetChkCombo(aChkCombo:TTMSFMXCheckGroupPicker; aHCode:String); overload;
procedure p_SetChkCombo(aChkCombo:TTMSFMXCheckGroupPicker; aCompany,aHCode,aDCode:String); overload;
procedure p_SetChkCombo(aChkCombo:TTMSFMXCheckGroupPicker; aCompany,aHCode,aDCode:String; aAddNull:Boolean; aNullCode,aNullName:String); overload;
function  f_GetChkCombo(aChkCombo:TTMSFMXCheckGroupPicker; aValue:Boolean): String;
procedure p_GetChkCombo(aChkCombo:TTMSFMXCheckGroupPicker; aValues:String);
procedure p_iniChkCombo(aChkCombo:TTMSFMXCheckGroupPicker);

//procedure p_SetComCode(aComboCode,aComboName:TComboBox; const aCompany,aHcode:String; aClear,aAddNull:Boolean); overload;
procedure p_SetComboCode(aForm:TForm; aComboBox:TComboBox; const aCompany,aHcode:String;aAddNull:Boolean; aNullCode,aNullName:String); overload;
procedure p_SetComboCode(aForm:TForm; aComboBox:TComboBox; const aCompany,aHcode:String); overload;
procedure p_SetComboCode(aForm:TForm; aComboBox:TComboBox; const aHcode:String); overload;


function  f_GetComboCode(aComboBox:TComboBox; aCode:String): integer; overload;

procedure p_ComboBox_FontSize(aComboBox:TComboBox; aSize:Single);
function  f_StrToDate(aDate:String):TDate; overload;


procedure p_ActExecute(Sender: TAction);
//procedure p_Excute_File(aFileName:String);
procedure p_iniFile_Write(aString1,aString2,aString3:String);
procedure p_Check_VersonUpdate(localversion,requestversion:Integer);
function  f_Send_Verify_Number(aCompany,aEmpNo,aNumber:String):Boolean;
//procedure p_Send_SMS(const PhoneNumber, Msg: string);
//procedure p_Send_SMS_New(const Number, Msg: string);
procedure P_Send_Email(const Recipient, Subject, Content, Attachment: string);
function  f_Send_eMail(const aMailTo,aSubject,aBody: string; const DisplayError: Boolean = False): Boolean;
function  f_OpenURL(const URL: string; const DisplayError: Boolean = False): Boolean;
procedure p_LaunchURL(const URL: string);
procedure p_LaunchApp(a_AppUrl:String);

procedure p_Delay(ms: Integer);
function  f_FindAnyClass(const Name: string): TClass;
function  f_IsAppInstalled(const AAppName: string): Boolean;




function  f_ToNumber(aString:String):Double;
procedure p_SetButtonWidth(aForm:TForm;aName:String);

procedure p_TMSFMXGrid_ChartClickSeries(Form:TForm; TMSFMXGrid:TTMSFMXGrid;  Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton;  Shift: TShiftState; X, Y: Integer);
procedure p_TMSFMXGrid_GetCellAppearance(Form:TForm; TMSFMXGrid:TTMSFMXGrid; ACol,ARow:Integer; Cell:TFmxObject; ACellState:TCellState);
Procedure p_TMSFMXGrid_SetField(Form:TForm; TMSFMXGrid:TTMSFMXGrid; aFields:TFields; i,c,r:integer);

function  f_TMSFMXGrid_SetData(Form:TForm; ClientDataSet:TClientDataSet; TMSFMXGrid:TTMSFMXGrid): integer;
Procedure p_TMSFMXGrid_Clear(Form:TForm; TMSFMXGrid: TTMSFMXGrid; Chart:TChart );overload;
Procedure p_TMSFMXGrid_Clear(Form:TForm; TMSFMXGrid: TTMSFMXGrid);overload;
Procedure p_Chart_Clear(Chart:TChart ); Overload;
procedure p_MakeChart(aForm:TForm; aTMSFMXGrid:TTMSFMXGrid; aChart:TChart; aTitle:String; aColText,aColValue:integer);



function f_DayOfYear_First(Date: TDateTime): TDateTime;
function f_DayOfYear_Last(Date: TDateTime): TDateTime;
function f_DayOfMonth_First(Date: TDateTime): TDateTime;
function f_DayOfMonth_Last (Date: TDateTime): TDateTime;

function f_GetAppVersion(aKind:Integer): string;
function f_System_FullName_Html: string;
function f_System_Name_Html: string;

function f_GetURLAsString(aURL: string): string;
procedure p_Lotto2(aString: String);
procedure p_Lotto(aString: String);
function f_GetUrlContent(aUrl:string):String;
function f_Lotto(aString: String):String;

procedure p_ShowMessage(const Msg: string);
function f_HasPermission(const Permission: string): Boolean;

function f_Chart_Color(i:integer):TAlphaColor;
procedure p_LoadImage_Building(aBitMap:TBitMap;aImageName:string);
//function f_IsNETWORK_Provider: Boolean;
//function f_IsGPS_Provider: Boolean;
function f_Query_Sample(aListView:TListView): integer;
function f_File_MimeType(a_FileName:String): String;
procedure p_Open_Url(a_Url:String);
procedure p_Open_Url_New(a_Url:String);
procedure p_Show_PDF(a_Url,a_FileName: String);

function f_Screen_Landscape(Sender: TObject):Boolean;
function f_Query_ListViewDetail(aListView:TListView): integer;

function f_Query_ListViewList(aListView:TListView): integer;  overload;
function f_Query_ListViewList(aListView:TListView; aMsg_NoData:Boolean): integer;  overload;
function f_Query_ListViewList(aListView:TListView; aMsg_Count,aMsg_NoData:Boolean): integer;  overload;

procedure p_LoadImage_Clear(aBitMap:TBitMap);
procedure p_LoadImage_Url_Large(aBitMap:TBitMap; aUrl,aFileName:string);
procedure p_LoadImage_Url_Small(aBitMap:TBitMap; aUrl,aFileName:string);

procedure p_LoadImage_Emp_ListView(aListView:TListView; k:integer; aImage,aRecycle,aLarge:Boolean);
procedure p_LoadImage_Emp_Small(aBitMap:TBitMap; aCompany,aEmpNo:string);
procedure p_LoadImage_Emp_Large(aBitMap:TBitMap; aCompany,aEmpNo:string);

//function f_GetPhoneNumber: string;
procedure p_CreatePrams;
procedure p_ParamByName(a_Name:String; a_Value:String);    overload;
procedure p_ParamByName(a_Name:String; a_Value:Integer);   overload;
procedure p_ParamByName(a_Name:String; a_Value:Double);    overload;
procedure p_ParamByName(a_Name:String; a_Value:TDateTime); overload;
procedure p_ExecuteProc;
procedure p_Toast(a_Msg: String);
procedure p_FormClose(a_Form:TForm; var Action: TCloseAction);

function  f_Check_Version:Boolean;


type
  TImageListHelper = class helper for TImageList
    function Add(aBitmap: TBitmap): integer;
  end;

type
  TUrlOpen = class
    class procedure p_UrlOpen(URL: string);
  end;

{$IF Defined(ANDROID)}
type
  JConnectivityManager = interface;
  JNetworkInfo = interface;

  JNetworkInfoClass = interface(JObjectClass)
  ['{E92E86E8-0BDE-4D5F-B44E-3148BD63A14C}']
  end;

  [JavaSignature('android/net/NetworkInfo')]
  JNetworkInfo = interface(JObject)
  ['{6DF61A40-8D17-4E51-8EF2-32CDC81AC372}']
    {Methods}
    function isAvailable: Boolean; cdecl;
    function isConnected: Boolean; cdecl;
    function isConnectedOrConnecting: Boolean; cdecl;
  end;
  TJNetworkInfo = class(TJavaGenericImport<JNetworkInfoClass, JNetworkInfo>) end;

  JConnectivityManagerClass = interface(JObjectClass)
  ['{E03A261F-59A4-4236-8CDF-0068FC6C5FA1}']
    {Property methods}
    function _GetTYPE_WIFI: Integer; cdecl;
    function _GetTYPE_WIMAX: Integer; cdecl;
    function _GetTYPE_MOBILE: Integer; cdecl;
    {Properties}
    property TYPE_WIFI: Integer read _GetTYPE_WIFI;
    property TYPE_WIMAX: Integer read _GetTYPE_WIMAX;
    property TYPE_MOBILE: Integer read _GetTYPE_MOBILE;
  end;

  [JavaSignature('android/net/ConnectivityManager')]
  JConnectivityManager = interface(JObject)
  ['{1C4C1873-65AE-4722-8EEF-36BBF423C9C5}']
    {Methods}
    function getActiveNetworkInfo: JNetworkInfo; cdecl;
    function getNetworkInfo(networkType: Integer): JNetworkInfo; cdecl;
  end;
  TJConnectivityManager = class(TJavaGenericImport<JConnectivityManagerClass, JConnectivityManager>) end;
{$ENDIF}



implementation


Uses
  Com_DataModule,Com_Variable,MainMenu,
  FMX.Devgear.Extentions;

class procedure TUrlOpen.p_UrlOpen(URL: string);
{$IF Defined(ANDROID)}
var
  Intent: JIntent;
{$ENDIF}
begin
{$IF Defined(ANDROID)}
  Intent := TJIntent.Create;
  Intent.setAction(TJIntent.JavaClass.ACTION_VIEW);
  Intent.setData(StrToJURI(URL));
  tandroidhelper.Activity.startActivity(Intent);
//SharedActivity.startActivity(Intent);
{$ELSEIF Defined(MSWINDOWS)}
  ShellExecute(0, 'OPEN', PWideChar(URL), nil, nil, SW_SHOWNORMAL);
{$ELSEIF Defined(IOS)}
  SharedApplication.OpenURL(StrToNSUrl(URL));
{$ELSEIF Defined(MACOS)}
  _system(PAnsiChar('open ' + AnsiString(URL)));
{$ENDIF}
end;


procedure p_Toast(a_Msg: String);
begin
  {$IFDEF Android}
   Toast(a_Msg, ShortToast);
  {$ENDIF Android}

  {$IFDEF IOS}
//   FGX.Toasts.ShowMessage(a_Msg);
  {$ENDIF IOS}

end;


function f_Screen_Landscape(Sender: TObject):Boolean;
var SS: IFMXScreenService;
begin
  Result := false;
  if TPlatformServices.Current.SupportsPlatformService(IFMXScreenService, IInterface(SS)) then begin
    if SS.GetScreenOrientation in [TScreenOrientation.Portrait, TScreenOrientation.InvertedPortrait]
      then Result := false //'Portrait Orientation'
      else Result := true; //'Landscape Orientation'
  end;

end;




procedure p_CloseDataBase;
begin
   frmCom_DataModule.DataSQLCon.Connected := false;
   frmCom_DataModule.DataSQLCon.Close;
   frmCom_DataModule.DataSQLCon.FreeOnRelease;
end;

procedure p_FormClose(a_Form:TForm; var Action: TCloseAction);
begin
  p_CloseDataBase;
  Action := TCloseAction.caFree;
end;


procedure p_ParamByName(a_Name:String; a_Value:String);    overload;
begin
  with frmCom_DataModule.ClientDataSet_Proc do begin
    ParamByName(a_Name).AsString := a_Value;
  end;
end;

procedure p_ParamByName(a_Name:String; a_Value:Integer); overload;
begin
  with frmCom_DataModule.ClientDataSet_Proc do begin
    ParamByName(a_Name).AsInteger := a_Value;
  end;
end;

procedure p_ParamByName(a_Name:String; a_Value:Double); overload;
begin
  with frmCom_DataModule.ClientDataSet_Proc do begin
    ParamByName(a_Name).AsFloat := a_Value;
  end;
end;

procedure p_ParamByName(a_Name:String; a_Value:TDateTime); overload;
begin
  with frmCom_DataModule.ClientDataSet_Proc do begin
    ParamByName(a_Name).AsDateTime := a_Value;
  end;
end;





procedure p_CreatePrams;
begin
  with frmCom_DataModule.ClientDataSet_Proc do begin
    try
      with Params do begin
        Clear;
        CreateParam(ftWideString, 'arg_ModCd',          ptInput);
        CreateParam(ftWideString, 'arg_COMPANY',        ptInput);
        CreateParam(ftWideString, 'arg_EMPNO',          ptInput);
        CreateParam(ftWideString, 'arg_DEPT',           ptInput);
        CreateParam(ftWideString, 'arg_DATE',           ptInput);
        CreateParam(ftWideString, 'arg_DATEFR',         ptInput);
        CreateParam(ftWideString, 'arg_DATETO',         ptInput);
        CreateParam(ftWideString, 'arg_TEXT01',         ptInput);
        CreateParam(ftWideString, 'arg_TEXT02',         ptInput);
        CreateParam(ftWideString, 'arg_TEXT03',         ptInput);
        CreateParam(ftWideString, 'arg_TEXT04',         ptInput);
        CreateParam(ftWideString, 'arg_TEXT05',         ptInput);
        CreateParam(ftWideString, 'arg_TEXT06',         ptInput);
        CreateParam(ftWideString, 'arg_TEXT07'          ,ptInput);
        CreateParam(ftWideString, 'arg_TEXT08'          ,ptInput);
        CreateParam(ftWideString, 'arg_TEXT09'          ,ptInput);
        CreateParam(ftWideString, 'arg_TEXT10'          ,ptInput);
        CreateParam(ftWideString, 'arg_TEXT11'          ,ptInput);
        CreateParam(ftWideString, 'arg_TEXT12'          ,ptInput);
        CreateParam(ftWideString, 'arg_TEXT13'          ,ptInput);
        CreateParam(ftWideString, 'arg_TEXT14'          ,ptInput);
        CreateParam(ftWideString, 'arg_TEXT15'          ,ptInput);
        CreateParam(ftWideString, 'arg_TEXT16'          ,ptInput);
        CreateParam(ftWideString, 'arg_TEXT17'          ,ptInput);
        CreateParam(ftWideString, 'arg_TEXT18'          ,ptInput);
        CreateParam(ftWideString, 'arg_TEXT19'          ,ptInput);
        CreateParam(ftWideString, 'arg_TEXT20'          ,ptInput);
        CreateParam(ftWideString, 'arg_TEXT21'          ,ptInput);
        CreateParam(ftWideString, 'arg_TEXT22'          ,ptInput);
        CreateParam(ftWideString, 'arg_TEXT23'          ,ptInput);
        CreateParam(ftWideString, 'arg_TEXT24'          ,ptInput);
        CreateParam(ftWideString, 'arg_TEXT25'          ,ptInput);
        CreateParam(ftWideString, 'arg_TEXT26'          ,ptInput);
        CreateParam(ftWideString, 'arg_TEXT27'          ,ptInput);
        CreateParam(ftWideString, 'arg_TEXT28'          ,ptInput);
        CreateParam(ftWideString, 'arg_TEXT29'          ,ptInput);
        CreateParam(ftWideString, 'arg_TEXT30'          ,ptInput);
        CreateParam(ftWideString, 'arg_User_Id'         ,ptInput);
        CreateParam(ftWideString, 'arg_User_PassWord'   ,ptInput);
        CreateParam(ftWideString, 'arg_User_EmpNo'      ,ptInput);
        CreateParam(ftWideString, 'arg_User_Phone'      ,ptInput);
        CreateParam(ftWideString, 'arg_User_Name'       ,ptInput);
        CreateParam(ftWideString, 'arg_User_Grade'      ,ptInput);
        CreateParam(ftWideString, 'arg_User_GradeName'  ,ptInput);
        CreateParam(ftWideString, 'arg_User_Company'    ,ptInput);
        CreateParam(ftWideString, 'arg_User_Dept'       ,ptInput);
        CreateParam(ftWideString, 'arg_User_Dept1'      ,ptInput);
        CreateParam(ftWideString, 'arg_User_Dept2'      ,ptInput);
        CreateParam(ftWideString, 'arg_User_Dept3'      ,ptInput);
        CreateParam(ftWideString, 'arg_User_Dept4'      ,ptInput);
        CreateParam(ftWideString, 'arg_User_Dept5'      ,ptInput);
        CreateParam(ftWideString, 'arg_User_Boss1'      ,ptInput);
        CreateParam(ftWideString, 'arg_User_Boss2'      ,ptInput);
        CreateParam(ftWideString, 'arg_User_Boss3'      ,ptInput);
        CreateParam(ftWideString, 'arg_User_Boss4'      ,ptInput);
        CreateParam(ftWideString, 'arg_User_Boss5'      ,ptInput);
        CreateParam(ftWideString, 'arg_User_CompanyName',ptInput);
        CreateParam(ftWideString, 'arg_User_DeptName'   ,ptInput);
        CreateParam(ftWideString, 'arg_User_Dept1Name'  ,ptInput);
        CreateParam(ftWideString, 'arg_User_Dept2Name'  ,ptInput);
        CreateParam(ftWideString, 'arg_User_Dept3Name'  ,ptInput);
        CreateParam(ftWideString, 'arg_User_Dept4Name'  ,ptInput);
        CreateParam(ftWideString, 'arg_User_Dept5Name'  ,ptInput);
        CreateParam(ftWideString, 'arg_User_Boss1Name'  ,ptInput);
        CreateParam(ftWideString, 'arg_User_Boss2Name'  ,ptInput);
        CreateParam(ftWideString, 'arg_User_Boss3Name'  ,ptInput);
        CreateParam(ftWideString, 'arg_User_Boss4Name'  ,ptInput);
        CreateParam(ftWideString, 'arg_User_Boss5Name'  ,ptInput);
        CreateParam(ftcursor,     'p_Cursor'            ,ptOutput);
     // ParamByName('arg_User_eMail'    ).AsString :=  g_User_eMail;
        ParamByName('arg_User_Company'  ).AsString :=  g_User_Company;
        ParamByName('arg_User_Dept'     ).AsString :=  g_User_Dept;
        ParamByName('arg_User_DeptName' ).AsString :=  g_User_DeptName;
        ParamByName('arg_User_EmpNo'    ).AsString :=  g_User_EmpNo;
        ParamByName('arg_User_Name'     ).AsString :=  g_User_EmpName;
        ParamByName('arg_User_Grade'    ).AsString :=  g_User_Grade;
        ParamByName('arg_User_Phone'    ).AsString :=  g_User_Phone;

        ParamByName('arg_User_Boss1'    ).AsString :=  g_User_Boss1;
        ParamByName('arg_User_Boss2'    ).AsString :=  g_User_Boss2;
        ParamByName('arg_User_Boss3'    ).AsString :=  g_User_Boss3;
        ParamByName('arg_User_Boss4'    ).AsString :=  g_User_Boss4;
        ParamByName('arg_User_Boss5'    ).AsString :=  g_User_Boss5;

        ParamByName('arg_Text27'        ).AsString :=  g_Sel_Title;
        ParamByName('arg_Text28'        ).AsString :=  g_User_Version;
        ParamByName('arg_Text29'        ).AsString :=  g_User_DeviceId;
        ParamByName('arg_Text30'        ).AsString :=  g_User_DeviceToken;

      end;
    except
      on e: Exception do begin
        p_ShowMessage(e.Message);
        Sleep(3000);
        Halt(1);
        Exit;
      end;
    end;
  end;
end;


procedure p_ExecuteProc;
begin
  with frmCom_DataModule.ClientDataSet_Proc do begin
    try
      Close;
      p_CreatePrams;
      ParamByName('arg_ModCd' ).AsString := 'USER_CHECK_IdPswd';
      Open;
      Close;
    Except
      on e: Exception do
      begin
        p_ShowMessage(e.Message);
        Close;
        Sleep(3000);
        Halt(1);
        Exit;
      end;
    end;
  end;
end;


procedure p_LoadImage_Emp_Large(aBitMap:TBitMap; aCompany,aEmpNo:string);
begin
  p_LoadImage_Url_Large(aBitMap,c_Image_Emp,aEmpNo+'.jpg');
end;


procedure p_LoadImage_Emp_Small(aBitMap:TBitMap; aCompany,aEmpNo:string);
begin
  p_LoadImage_Url_Small(aBitMap,c_Image_Emp_Small,aEmpNo+'.jpg');
end;



procedure p_LoadImage_Clear(aBitMap:TBitMap);
begin
  try
    aBitMap.Clear(TAlphaColors.White);
    aBitMap.Assign(frmCom_DataModule.ImageList.Bitmap(TSizeF.Create(300,300),0));
  except
    aBitMap.Clear(TAlphaColors.White);
  end;
end;



procedure p_LoadImage_Url_Large(aBitMap:TBitMap; aUrl,aFileName:string);
begin
  try
    aBitMap.Clear(TAlphaColors.White);
    aBitMap.LoadFromURL(TPath.Combine(aUrl,aFileName));
  except
    aBitMap.Clear(TAlphaColors.White);
  end;
end;

procedure p_LoadImage_Url_Small(aBitMap:TBitMap; aUrl,aFileName:string);
begin
  try
    aBitMap.Clear(TAlphaColors.White);
    aBitMap.LoadThumbnailFromURL(TPath.Combine(aUrl,aFileName),aBitMap.Width,aBitMap.Height);
  except
    aBitMap.Clear(TAlphaColors.White);
  end;
end;




function TImageListHelper.Add(aBitmap: TBitmap): integer;
const SCALE = 1;
var
  vSource: TCustomSourceItem;
  vBitmapItem: TCustomBitmapItem;
  vDest: TCustomDestinationItem;
  vLayer: TLayer;
begin
  Result := -1;
  if (aBitmap.Width = 0) or (aBitmap.Height = 0) then exit;
  // add source bitmap
  vSource := Source.Add;
  vSource.MultiResBitmap.TransparentColor := TColorRec.Fuchsia;
  vSource.MultiResBitmap.SizeKind := TSizeKind.Source;
  vSource.MultiResBitmap.Width := Round(aBitmap.Width / SCALE);
  vSource.MultiResBitmap.Height := Round(aBitmap.Height / SCALE);
  vBitmapItem := vSource.MultiResBitmap.ItemByScale(SCALE, True, True);
  if vBitmapItem = nil then begin
    vBitmapItem := vSource.MultiResBitmap.Add;
    vBitmapItem.Scale := Scale;
  end;
  vBitmapItem.Bitmap.Assign(aBitmap);
  vDest := Destination.Add;
  vLayer := vDest.Layers.Add;
  vLayer.SourceRect.Rect := TRectF.Create(TPoint.Zero, vSource.MultiResBitmap.Width,
      vSource.MultiResBitmap.Height);
  vLayer.Name := vSource.Name;
  Result := vDest.Index;
end;

function f_Query_ListViewList(aListView:TListView): integer;  overload;
begin
  Result := f_Query_ListViewList(aListView,false,false);
end;

function f_Query_ListViewList(aListView:TListView; aMsg_NoData:Boolean): integer;  overload;
begin
  Result := f_Query_ListViewList(aListView,false,aMsg_NoData);
end;

function f_Query_ListViewList(aListView:TListView; aMsg_Count,aMsg_NoData:Boolean): integer;  overload;
var r,c:integer;
var v_Item: TListViewItem;
begin
  Result := -1;
  g_ChartTitle := '';
  g_Sel_TabCnt := '';

  //aListView.BeginUpdate;  //10.4.2로 변경후 itemobjects 모두 나오기 시작
  aListView.Items.Clear;
  aListView.CanSwipeDelete:= false;
  aListView.SearchVisible := false;

//aListView.ItemAppearanceObjects.ItemObjects.GlyphButton.Visible := false;
//aListView.ItemAppearanceObjects.ItemObjects.Accessory.  Visible := false;
//aListView.ItemAppearanceObjects.ItemObjects.Image.Visible       := true;

  with frmCom_DataModule.ClientDataSet_Proc do begin
    try
      Open;
      Result := RecordCount;
      for r:=0 to RecordCount-1 do begin
        v_Item := aListView.Items.Add;
        v_Item.BeginUpdate;
        for c:=0 to FieldCount-1 do begin
          if      UpperCase(Fields[c].FullName)=UpperCase('Text')          then v_Item.Text       := Fields[c].AsString
          else if UpperCase(Fields[c].FullName)=UpperCase('Detail')        then v_Item.Detail     := Fields[c].AsString
          else if UpperCase(Fields[c].FullName)=UpperCase('Tag')           then v_Item.Tag        := Fields[c].AsInteger
          else if UpperCase(Fields[c].FullName)=UpperCase('TagString')     then v_Item.TagString  := Fields[c].AsString
          else if UpperCase(Fields[c].FullName)=UpperCase('ChartTitle')    then g_ChartTitle      := Fields[c].AsString
          else if UpperCase(Fields[c].FullName)=UpperCase('Height')        then v_Item.Height     := Fields[c].AsInteger
          else if UpperCase(Fields[c].FullName)=UpperCase('ButtonText')    then v_Item.ButtonText := Fields[c].AsString
          else if UpperCase(Fields[c].FullName)=UpperCase('IndexTitle')    then v_Item.IndexTitle := Fields[c].AsString
          else if UpperCase(Fields[c].FullName)=UpperCase('TabCount')      then g_Sel_TabCnt      := Fields[c].AsString
          else if UpperCase(Fields[c].FullName)=UpperCase('TextColor')     then v_Item.Objects.TextObject.TextColor    := StringToAlphaColor(Fields[c].AsString)
          else if UpperCase(Fields[c].FullName)=UpperCase('DetailColor')   then v_Item.Objects.DetailObject.TextColor  := StringToAlphaColor(Fields[c].AsString)
          else if UpperCase(Fields[c].FullName)=UpperCase('GlyphButton')   then v_Item.Objects.GlyphButton.Visible     := (Fields[c].AsInteger>0)
          else if UpperCase(Fields[c].FullName)=UpperCase('ItemObjects')   then v_Item.Objects.AccessoryObject.Visible := (Fields[c].AsInteger>0)
          else if UpperCase(Fields[c].FullName)=UpperCase('Bitmap')        then v_Item.BitMap.Assign(frmMainMenu.ImageList_MainMenu.Bitmap(TSizeF.Create(v_Item.Height,v_Item.Height),Fields[c].AsInteger))
          else if UpperCase(Fields[c].FullName)=UpperCase('SearchVisible') then aListView.SearchVisible := FieldS[c].AsInteger>0;
        end;
        v_Item.EndUpdate;
        Next;
      end;
      //aListView.SearchVisible := RecordCount>0;
      Close;
    except
      p_ShowMessage(c_Network_Error_Msg);
     {$ifdef ANDROID}Application.Terminate;{$endif}
    end;
  end;
  if  aListView.ItemCount>0 then aListView.ScrollTo(0);
  if      (aMsg_Count)  and (aListView.ItemCount>0) then p_Toast('조회완료('+aListView.ItemCount.ToString+')')
  else if (aMsg_NoData) and (aListView.ItemCount<1) then p_Toast('해당데이타없습니다');
  //aListView.EndUpdate;
end;

function f_Query_ListViewDetail(aListView:TListView): integer;
var i:integer;
var b:Boolean;
var v_ListViewItem:  TListViewItem;
begin
  Result := 0;
  aListView.BeginUpdate;
  aListView.Items.Clear;
  aListView.CanSwipeDelete:= false;
  with frmCom_DataModule.ClientDataSet_Proc,aListView do begin
    try
      Open;
      Result := RecordCount;
      for i:=0 to FieldCount-1 do begin
        b := false;
        if UpperCase(Fields[i].FullName)=UpperCase('Bitmap') then begin
           v_ListViewItem.BitMap.Assign(frmMainMenu.ImageList_MainMenu.Bitmap(TSizeF.Create(v_ListViewItem.Height,v_ListViewItem.Height),Fields[i].AsInteger));
           b := true;
        end;
        if UpperCase(Fields[i].FullName)=UpperCase('Height') then begin
           v_ListViewItem.Height := Fields[i].AsInteger;
           b := true;
        end;
        if b then continue;
        v_ListViewItem      := aListView.Items.Add;
        v_ListViewItem.Text := Fields[i].AsString;
      end;
      Close;
    except
      Close;
      p_ShowMessage(c_Network_Error_Msg);
     {$ifdef ANDROID}Application.Terminate;{$endif}
    end;
  end;
  if aListView.ItemCount>0 then aListView.ScrollTo(0);
  aListView.EndUpdate;
  if Result<1 then P_Toast('해당데이타 없습니다.');
end;

procedure p_Open_Url(a_Url:String);
{$IFDEF ANDROID}
var Intent: JIntent;
{$ENDIF}
begin
{$IFDEF ANDROID}
  Intent := TJIntent.Create;
  Intent.setAction(TJIntent.JavaClass.ACTION_VIEW);
  Intent.setData(StrToJURI(a_Url));
  TAndroidHelper.Activity.startActivity(Intent);
{$ENDIF}
{$IFDEF IOS}
{$ENDIF}

end;


procedure p_Open_Url_New(a_Url:String);
{$IFDEF ANDROID}
var Intent: JIntent;
var MimeType:String;
var FileExt: String;
{$ENDIF}
begin
{$IFDEF ANDROID}
  MimeType := f_File_MimeType(a_Url);
  FileExt  := StringReplace(TPath.GetExtension(a_Url), '.', '', []);
//MimeType := JStringToString(TJMimeTypeMap.JavaClass.getSingleton.getMimeTypeFromExtension(StringToJString(a_Url)));
//if MimeType = nil then MimeType := StringToJString('*/*');
  Intent := TJIntent.Create;
  Intent.setAction(TJIntent.JavaClass.ACTION_VIEW);
  if MimeType='' then begin
    Intent.setData(StrToJURI(a_Url));
    TAndroidHelper.Activity.startActivity(Intent);
  end
  else begin
    Intent.setDataAndType(StrToJURI(a_Url),StringToJString(MimeType));
  //Intent.setDataAndType(StrToJURI(a_Url),MimeType);
    if MainActivity.getPackageManager.queryIntentActivities(Intent,TJPackageManager.JavaClass.MATCH_DEFAULT_ONLY).size>0
       then TAndroidHelper.Activity.startActivity(Intent)
       else p_Toast(Format('''%s'' 확장자와 연결된 프로그램을 찾을 수 없습니다.',[FileExt]));
  end;
{$ENDIF}
{$IFDEF IOS}
{$ENDIF}
end;

procedure p_Show_PDF(a_Url,a_FileName: String);
{$IFDEF ANDROID}
var Intent: JIntent;
   sPath: string;
   MemoryStream: TMemoryStream;
   fileuri: JParcelable;
{$ENDIF}
begin
{$IFDEF ANDROID}
   sPath := TPath.Combine(TPath.GetSharedDocumentsPath, 'xxx.pdf');
   DeleteFile(sPath);
   MemoryStream := TMemoryStream.Create;
   frmCom_DataModule.IdHTTP.Get(a_Url,MemoryStream);
   MemoryStream.SaveToFile(sPath);
   if FileExists(sPath) then
   begin
     fileuri:= JParcelable(TJNet_Uri.JavaClass.fromFile(TJFile.JavaClass.init(StringToJString(sPath))));
     Intent := TJIntent.Create;
   //Intent.setAction(TJIntent.JavaClass.ACTION_VIEW);
     Intent.setAction(TJIntent.JavaClass.ACTION_SEND);
     intent.setType(StringToJString('application/pdf'));
     Intent.putExtra(TJIntent.JavaClass.EXTRA_STREAM, fileuri);
   //SharedActivity.StartActivity(Intent);
     TAndroidHelper.Activity.startActivity(Intent);
   end;
{$ENDIF}
{$IFDEF IOS}
{$ENDIF}

end;


function f_File_MimeType(a_FileName:String): String;
var v_FileExt: String;
begin
  v_FileExt:=LowerCase(ExtractFileExt(a_FileName));
  if      v_FileExt='.mp3'  then Result:='audio/*'
  else if v_FileExt='.mp4'  then Result:='vidio/*'
  else if v_FileExt='.jpg'  then Result:='image/*'
  else if v_FileExt='.jpeg' then Result:='image/*'
  else if v_FileExt='.gif'  then Result:='image/*'
  else if v_FileExt='.png'  then Result:='image/*'
  else if v_FileExt='.bmp'  then Result:='image/*'
  else if v_FileExt='.txt'  then Result:='text/*'
  else if v_FileExt='.doc'  then Result:='application/msword'
  else if v_FileExt='.docx' then Result:='application/msword'
  else if v_FileExt='.xls'  then Result:='application/vnd.ms-excel'      // vendor-specific MIME types
  else if v_FileExt='.xlsx' then Result:='application/vnd.ms-excel'      // vendor-specific MIME types
  else if v_FileExt='.ppt'  then Result:='application/vnd.ms-powerpoint' // vendor-specific MIME types
  else if v_FileExt='.pptx' then Result:='application/vnd.ms-powerpoint' // vendor-specific MIME types
  else if v_FileExt='.pdf'  then Result:='application/pdf'               // pdf
  else if v_FileExt='.hwp'  then Result:='application/haansofthwp'       // hwp
  else                           Result:='';
end;

function f_Query_Sample(aListView:TListView): integer;
var i:integer;
var v_ListViewItem:  TListViewItem;
begin
  Result := 0;
  aListView.BeginUpdate;
  aListView.Items.Clear;
  aListView.CanSwipeDelete:= false;
  with frmCom_DataModule.ClientDataSet_Proc do begin
    try
      Open;
      Result := RecordCount;
      for i:=0 to RecordCount-1 do begin
        v_ListViewItem           := aListView.Items.Add;
        v_ListViewItem.TagString := FieldByName('TagString'  ).AsString;
        v_ListViewItem.Text      := FieldByName('Text'       ).AsString;
        v_ListViewItem.Detail    := FieldByName('Detail'     ).AsString;
        v_ListViewItem.Height    := FieldByName('Item_Height').AsInteger;
        v_ListViewItem.Bitmap    := frmCom_DataModule.ImageList.Bitmap(TSizeF.Create(300,300),FieldByName('IMAGE_INDEX').AsInteger);

        v_ListViewItem.Objects.TextObject.Visible     := FieldByName('Text_Visible').AsInteger>0;
        v_ListViewItem.Objects.TextObject.Height      := FieldByName('Text_Height' ).AsInteger;
        v_ListViewItem.Objects.TextObject.TextColor   := StringToAlphaColor(FieldByName('Text_Color').AsString);


        v_ListViewItem.Objects.DetailObject.Visible   := FieldByName('Detail_Visible').AsInteger>0;
        v_ListViewItem.Objects.DetailObject.Height    := FieldByName('Detail_Height').AsInteger;
        v_ListViewItem.Objects.DetailObject.TextColor := StringToAlphaColor(FieldByName('Detail_Color').AsString);

        v_ListViewItem.Objects.ImageObject.Visible    := FieldByName('Image_Visible' ).AsInteger>0;
        v_ListViewItem.Objects.ImageObject.Width      := FieldByName('Image_Width'   ).AsInteger;
        v_ListViewItem.Objects.ImageObject.Height     := FieldByName('Image_Height'  ).AsInteger;

        v_ListViewItem.Objects.ImageObject.Visible    := FieldByName('Image_Visible').AsInteger>0;
        v_ListViewItem.Objects.GlyphButton.Visible    := FieldByName('GlyphButton_Visible').AsInteger>0;


        Next;
      end;
      Close;
    Except
      on e: Exception do begin
        p_ShowMessage(e.ToString);
        Close;
        Exit;
      end;
    end;
  end;
  if aListView.ItemCount>0 then aListView.ScrollTo(0);
//aListView.EndUpdate;
end;

//function f_IsGPS_Provider: Boolean;
//var locationManager: JLocationManager;
//begin
//  locationManager := TJLocationManager.Wrap(
//    ((TAndroidHelper.Activity.getSystemService(TJContext.JavaClass.LOCATION_SERVICE)) as ILocalObject).GetObjectID);
//  //((SharedActivity.getSystemService(TJContext.JavaClass.LOCATION_SERVICE)) as ILocalObject).GetObjectID);
//  Result := locationManager.isProviderEnabled(TJLocationManager.JavaClass.GPS_PROVIDER);
//  if not Result then p_Toast('No GPS_PROVIDER found');
//end;

//function f_IsNETWORK_Provider: Boolean;
//var locationManager: JLocationManager;
//begin
//  locationManager := TJLocationManager.Wrap(
//    ((TAndroidHelper.Activity.getSystemService(TJContext.JavaClass.LOCATION_SERVICE)) as ILocalObject).GetObjectID);
//  //((SharedActivity.getSystemService(TJContext.JavaClass.LOCATION_SERVICE)) as ILocalObject).GetObjectID);
//  Result := locationManager.isProviderEnabled(TJLocationManager.JavaClass.NETWORK_PROVIDER);
//  if not Result then p_Toast('No NETWORK_PROVIDER found');
//end;


procedure p_LoadImage_Building(aBitMap:TBitMap;aImageName:string);
begin
  p_LoadImage_Url_Small(aBitMap,c_Image_Bd_Image,aImageName);
//p_LoadImage_Url(aBitMap,c_Image_Bd_Image,'AA001200101111410_1.jpg');
end;

function f_Chart_Color(i:integer):TAlphaColor;
begin
  Result := TAlphaColors.Gray*(i+1)*30000;
end;



function f_HasPermission(const Permission: string): Boolean;
begin
  //Permissions listed at http://d.android.com/reference/android/Manifest.permission.html
Result := false;

{$IFDEF ANDROID}
  {$IF RTLVersion >= 30}
    Result := TAndroidHelper.Context.checkCallingOrSelfPermission(
  {$ELSE}
  //Result := SharedActivityContext.checkCallingOrSelfPermission(
    Result := TAndroidHelper.Context.checkCallingOrSelfPermission(
  {$ENDIF}
    StringToJString(Permission)) = TJPackageManager.JavaClass.PERMISSION_GRANTED;
{$ENDIF}

{$IFDEF IOS}
{$ENDIF}

end;

procedure p_ShowMessage(const Msg: string);
begin
{$IFDEF ANDROID}
  {$IF RTLVersion >= 31}
      TDialogService.MessageDialog(Msg, TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOk], TMsgDlgBtn.mbCancel, 0, nil)
  {$ELSE}
      MessageDlg(Msg, TMsgDlgType.mtInformation,[TMsgDlgBtn.mbOk],0)
  {$ENDIF}
{$ENDIF}

{$IFDEF IOS}
     ShowMessage(Msg);
{$ENDIF}
end;



function f_GetUrlContent(aUrl:string):String;
var
  IdHTTP1: TIdHTTP;
begin
  IdHTTP1 := TIdHTTP.Create;
  try
    Result := IdHTTP1.Get(aUrl);
  finally
    IdHTTP1.Free;
  end;
end;


function f_Lotto(aString: String): String;
var
  json: string;
  obj: TJSONObject;
begin
  Result:= '';
  try
    json := f_GetUrlContent(c_Url_Lotto+aString);
    p_ShowMessage(json);
    obj  := TJSONObject.ParseJSONValue(json) as TJSONObject;
    if obj = nil then raise Exception.Create('Error parsing JSON');
    try
      Result := obj.Values['totSellamnt'].Value;
    finally
      obj.Free;
    end;
  except
    on E : Exception do
    begin
      p_ShowMessage('Error' + sLineBreak + E.ClassName + sLineBreak + E.Message);
    end;
  end;
end;


procedure p_Lotto(aString: String);
var
  JSONObject  :TJSONObject;
  JSONData    :TJSONObject;
  HTTP        :TIdHTTP;
  IdSSL       :TIdSSLIOHandlerSocketOpenSSL;
  RequestBody :TStream;
  ResponseBody:string;
const
  c_Url_Lotto = 'https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=100';
begin
  try
    JSONData    := TJSONObject.Create;
    JSONObject  := TJSONObject.Create;
    HTTP        := TIdHTTP.Create(nil);
    IdSSL       := TIdSSLIOHandlerSocketOpenSSL.Create(nil);

    HTTP.ReadTimeout := 30000;
    HTTP.IOHandler   := IdSSL;
    IdSSL.SSLOptions.Method := sslvTLSv1;
    IdSSL.SSLOptions.Method := sslvTLSv1;
    IdSSL.SSLOptions.Mode   := sslmUnassigned;

    RequestBody := TStringStream.Create(JSONObject.ToString,TEncoding.UTF8);
  try
    HTTP.Request.CharSet := 'utf-8';
    HTTP.Request.Accept := 'application/json';
    HTTP.Request.ContentType := 'application/json';
    HTTP.Request.CustomHeaders.FoldLines := False;
    ResponseBody := HTTP.Post(c_Url_Lotto,RequestBody);
    p_ShowMessage('p_Lotto:'+'ResponseBody : '+#13#10+ResponseBody);
  except
    on E:Exception do begin
      p_ShowMessage(E.Message);
    end;
  end;
  finally
    JSONData.Free;
    JSONObject.Free;
    HTTP.Free;
    IdSSL.Free;
  end;
end;


//libeay32.dll과 ssleay32.dll 실행 파일 폴더에 복사를 했는데도 계속 오류가 발생 합니다.
procedure p_Lotto2(aString: String);
var
  JSONObject  :TJSONObject;
  JSONData    :TJSONObject;
  HTTPClient  :TNetHTTPClient;
  HTTPResponse:IHTTPResponse;
  RequestBody :TStream;
  ResponseBody:string;
const
  c_Url_Lotto = 'https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=100';
begin
  try
    RequestBody  := TStringStream.Create(JSONObject.ToString,TEncoding.UTF8);
    RequestBody.Position   := 0;

    p_ShowMessage('p_Lotto21');
    HTTPClient             := TNetHTTPClient.Create(nil);
    HTTPClient.ContentType := 'application/json';
    HTTPClient.Accept      := 'application/json';
    HTTPClient.ConnectionTimeout := 20000;
    HTTPClient.ResponseTimeout   := 20000;
    p_ShowMessage('p_Lotto22');
    try
   // ResponseBody := HTTPClient.Post(c_Url_Lotto,RequestBody);
      p_ShowMessage('p_Lotto23:'+ResponseBody);
      HTTPResponse       := HTTPClient.Post(c_Url_Lotto,RequestBody);
      ResponseBody       := HTTPResponse.StatusCode.ToString;
      p_ShowMessage('p_Lotto24:'+ResponseBody);

    //ShowMessage('ResponseBody : '+#13#10+HTTPResponse.ContentAsString(TEncoding.UTF8));
    finally
      RequestBody.Free;
    end;
  finally
    JSONData.Free;
    JSONObject.Free;
    HTTPClient.Free;
  end;
end;




//  returnValue    :json 결과값 (success 또는 fail)
//  totSellamnt    : 누적 상금
//  drwNo          : 로또회차
//  drwNoDate      : 로또당첨일시
//  firstWinamnt   : 1등 당첨금
//  firstPrzwnerCo : 1등 당첨 인원
//  firstAccumamnt : 1등 당첨금 총액
//  drwtNo1 : 로또번호1
//  drwtNo2 : 로또번호2
//  drwtNo3 : 로또번호3
//  drwtNo4 : 로또번호4
//  drwtNo5 : 로또번호5
//  drwtNo6 : 로또번호6
//  bnusNo  : 보너스번호

function f_GetURLAsString(aURL: string): string;
var
  lHTTP: TIdHTTP;
  lStream: TStringStream;
begin
  lHTTP := TIdHTTP.Create(nil);
  lStream := TStringStream.Create(Result);
  try
    lHTTP.Get(aURL, lStream);
    lStream.Position := 0;
    Result := lStream.ReadString(lStream.Size);
  finally
    FreeAndNil(lHTTP);
    FreeAndNil(lStream);
  end;
end;


function f_System_FullName_Html: string;
begin
  Result := c_System_FullName_HTML
           +'<font color="#DCDCDC";> Ver'+f_GetAppVersion(1)+'</font>';
end;

function f_System_Name_Html: string;
begin
  Result := c_System_Name_HTML
           +'<font color="#DCDCDC";> Ver'+f_GetAppVersion(1)+'</font>';
end;




function f_GetAppVersion(aKind:Integer): string;
{$IFDEF ANDROID}
var
  PackageManager: JPackageManager;
  PackageInfo: JPackageInfo;
{$ENDIF}
begin
{$IFDEF ANDROID}
  PackageManager := TAndroidHelper.Context.getPackageManager;
  PackageInfo := PackageManager.getPackageInfo(TAndroidHelper.Context.getPackageName, 0);
//PackageManager := SharedActivityContext.getPackageManager;
//PackageInfo := PackageManager.getPackageInfo(SharedActivityContext.getPackageName, 0);
  case aKind of
    0: Result := PackageInfo.versionCode.ToString;
  else Result := JStringToString(PackageInfo.versionName);
  end;
{$ENDIF}
{$IFDEF IOS}
  case aKind of
    0: Result := TNSString.Wrap(CFBundleGetValueForInfoDictionaryKey(CFBundleGetMainBundle, kCFBundleVersionKey)).UTF8String;
  else Result := TNSString.Wrap(CFBundleGetValueForInfoDictionaryKey(CFBundleGetMainBundle, kCFBundleVersionKey)).UTF8String;
  end;
{$ENDIF}
end;



function f_DayOfMonth_First(Date: TDateTime): TDateTime;
var Year, Month, Day: Word;
begin
  DecodeDate(Date, Year, Month, Day);
  Result := EncodeDate(Year, Month, 1);
end;

function f_DayOfMonth_Last(Date: TDateTime): TDateTime;
var Year, Month, Day: Word;
begin
  DecodeDate(Date, Year, Month, Day);
  if Month=12 then begin Inc(Year); Month:=1; end;
  Result := EncodeDate(Year, Month+1,1)-1;
end;


function f_DayOfYear_First(Date: TDateTime): TDateTime;
begin
  Result := StartOfTheYear(Date);
end;

function f_DayOfYear_Last(Date: TDateTime): TDateTime;
begin
  Result := EndOfTheYear(Date);
end;




Procedure p_Chart_Clear(Chart:TChart ); overload;
begin
  Chart.BeginUpdate;
  with Chart do begin
    RemoveAllSeries;
    View3D               := false;
    Title.Visible        := true;
    Legend.Visible       := false;
  end;
  Chart.EndUpdate;
end;


Procedure p_TMSFMXGrid_Clear(Form:TForm; TMSFMXGrid: TTMSFMXGrid; Chart:TChart ); overload;
begin
  p_TMSFMXGrid_Clear(Form,TMSFMXGrid);
  p_Chart_Clear(Chart);
end;



Procedure p_TMSFMXGrid_SetField(Form:TForm; TMSFMXGrid:TTMSFMXGrid; aFields:TFields; i,c,r:integer);
begin
  with TMSFMXGrid do begin

    if      pos('%',Cells[c,0])>0             then Cells[c,r] := FormatFloat('##0.00',aFields[i].AsFloat)
    else if aFields[i].DataType = ftSmallint  then Cells[c,r] := FormatFloat('#,###', aFields[i].AsFloat)
    else if aFields[i].DataType = ftInteger   then Cells[c,r] := FormatFloat('#,###', aFields[i].AsFloat)
    else if aFields[i].DataType = ftWord      then Cells[c,r] := FormatFloat('#,###', aFields[i].AsFloat)
    else if aFields[i].DataType = ftFloat     then Cells[c,r] := FormatFloat('#,###', aFields[i].AsFloat)
    else if aFields[i].DataType = ftSingle    then Cells[c,r] := FormatFloat('#,###', aFields[i].AsFloat)
    else if aFields[i].DataType = ftBytes     then Cells[c,r] := FormatFloat('#,###', aFields[i].AsFloat)
    else if aFields[i].DataType = ftFMTBcd    then Cells[c,r] := FormatFloat('#,###', aFields[i].AsFloat)
    else if aFields[i].DataType = ftDate      then Cells[c,r] := FormatDateTime('YYYY-MM-DD',aFields[i].AsDateTime)
    else if aFields[i].DataType = ftTime      then Cells[c,r] := FormatDateTime('HH:NN:SS',aFields[i].AsDateTime)
    else if aFields[i].DataType = ftDateTime  then Cells[c,r] := FormatDateTime('YYYY-MM-DD HH:NN:SS',aFields[i].AsDateTime)
    else                                           Cells[c,r] := aFields[i].AsString;

    if      aFields[i].DataType = ftSmallint  then HorzAlignments[c,r] := Fmx.Types.TTextAlign.Trailing
    else if aFields[i].DataType = ftInteger   then HorzAlignments[c,r] := Fmx.Types.TTextAlign.Trailing
    else if aFields[i].DataType = ftWord      then HorzAlignments[c,r] := Fmx.Types.TTextAlign.Trailing
    else if aFields[i].DataType = ftFloat     then HorzAlignments[c,r] := Fmx.Types.TTextAlign.Trailing
    else if aFields[i].DataType = ftSingle    then HorzAlignments[c,r] := Fmx.Types.TTextAlign.Trailing
    else if aFields[i].DataType = ftBytes     then HorzAlignments[c,r] := Fmx.Types.TTextAlign.Trailing
    else if aFields[i].DataType = ftFMTBcd    then HorzAlignments[c,r] := Fmx.Types.TTextAlign.Trailing
    else                                           HorzAlignments[c,r] := Fmx.Types.TTextAlign.Leading;


  end;


{
ftUnknown
ftString
ftSmallint
ftInteger
ftWord
ftBoolean
ftFloat
ftCurrency
ftBCD
ftDate
ftTime
ftDateTime
ftBytes
ftVarBytes
ftAutoInc
ftBlob
ftMemo
ftGraphic
ftFmtMemo
ftParadoxOle
ftDBaseOle
ftTypedBinary
ftCursor
ftFixedChar
ftWideString
ftLargeint
ftADT
ftArray
ftReference
ftDataSet
ftOraBlob
ftOraClob
ftVariant
ftInterface
ftIDispatch
ftGuid
ftTimeStamp
ftFMTBcd
ftFixedWideChar
ftWideMemo
ftOraTimeStamp
ftOraInterval
ftLongWord
ftShortint
ftByte
ftExtended
ftConnection
ftParams
ftStream
ftTimeStampOffset
ftObject
ftSingle
}

end;




Procedure p_TMSFMXGrid_Clear(Form:TForm; TMSFMXGrid: TTMSFMXGrid); overload;
begin

  with TMSFMXGrid do begin
    TMSFMXGrid.BeginUpdate;
    Clear;
//  TMSFMXGrid.AutoSizeColumns;
    RowCount             := 1;
    SelectionMode        := smSingleRow;
    Selected             :=-1;
//  FixedFooterRows      := 1;
    FixedColumns         := 2;
    FixedRows            := 1;
    Options.Sorting.Mode := gsmIndexed;
    RowHeights[0]        := 30;
    TMSFMXGrid.EndUpdate;
  end;
end;


function f_TMSFMXGrid_SetData(Form:TForm; ClientDataSet:TClientDataSet; TMSFMXGrid:TTMSFMXGrid): integer;
var r,c:integer;
begin
  Result := -1;
//TMSFMXGrid.BeginUpdate;
  p_TMSFMXGrid_Clear(Form,TMSFMXGrid);
  TMSFMXGrid.BeginUpdate;
  with ClientDataSet,TMSFMXGrid do begin
    try
      Open;
      Result          := RecordCount;
      RowCount        := RecordCount+1;
      ColumnCount     := FieldCount+1;
      ColumnWidths[0] := 20;
    //if g_org_Grade='S' then frmMainMenu.Text_Msg.Text := g_Sel_Url+' ('+RecordCount.ToString+')';
      for c:=0 to FieldCount-1 do begin
        Cells [c+1,0]         := Fields[c].FullName;
        HorzAlignments[c+1,0] := Fmx.Types.TTextAlign.Center;
      end;
      for r:=0 to RecordCount-1 do begin
      //Colors[1,r+1]         := f_Chart_Color(r+1);
        RowHeights[r+1]       := RowHeights[0];
        Cells [0,r+1]         := (r+1).toString;
        HorzAlignments[0,r+1] := Fmx.Types.TTextAlign.Trailing;
        for c:=0 to FieldCount-1 do begin
          p_TMSFMXGrid_SetField(Form,TMSFMXGrid,Fields,c,c+1,r+1);
          TMSFMXGrid.ReadOnlys[c+1,r+1] := true;
        end;
        Next;
      end;
      Close;
    except
      Close;
      p_ShowMessage(c_Network_Error_Msg);
     {$ifdef ANDROID}Application.Terminate;{$endif}
    end;
  end;
  TMSFMXGrid.UpdateCalculations;
//TMSFMXGrid.EndUpdate;
  if Result<1 then P_Toast('해당데이타 없습니다.');
  TMSFMXGrid.EndUpdate;

end;


function f_ToNumber(aString:String):Double;
//var c1,c2,c3:integer;
var s:String;
begin
//  c1 := 0;
//  c2 := 0;
//  c3 := 0;
  s  := Trim(aString);
  s  := Trim(stringReplace(s,',','',[rfReplaceAll]));
  s  := Trim(StringReplace(s,' ','',[rfReplaceAll]));
  if s='' then s:='0';
  Result := s.ToDouble;

//  Result:=0;
//  for i:=0 to High(s) do begin
//    c0 := 0;
//    for j:=0 to High(c_Number) do if s[i]=c_Number[j] then c0:=c0+1;
//    if  c0   = 0   then c1 := c1+1; //--숫자아닌것 갯수
//    if  s[i] = '.' then c2 := c2+1; //--소수점의   갯수
//    if  s[i] = '.' then c3 := i;
//    if  s[i] = '-' then c4 := i;    //--마이너스
//  end;
//
//  if      (c1>1) then             s := '0'
//  else if (c2>1) then             s := '0'
//  else if (c4>0) then             s := '0'
//  else if (c1=1) and (c2<>1) then s := '0'
//  else if (c2=1) then begin
//     if      c3=0       then s:='0'+s
//     else if c3=High(s) then s:=s+'0';
//  end;
//  Result := StrToFloat(s);


end;



procedure p_TMSFMXGrid_GetCellAppearance(Form:TForm; TMSFMXGrid:TTMSFMXGrid; ACol,ARow:Integer; Cell:TFmxObject; ACellState:TCellState);
begin
  case ACellState of
   //csNormal:        (Cell as TTMSFMXGridCell).Layout.Fill.Color := claRed;
     csFocused:       (Cell as TTMSFMXGridCell).Layout.Fill.Color := f_Chart_Color(ARow);
     csFixed:         ;//(Cell as TTMSFMXGridCell).Layout.Fill.Color := claGreen;
     csFixedSelected: ;//(Cell as TTMSFMXGridCell).Layout.Fill.Color := claOrange;
   //csSelected:      (Cell as TTMSFMXGridCell).Layout.Fill.Color := claSilver;
  end;
  case ACellState of
     csNormal:        (Cell as TTMSFMXGridCell).Layout.FontFill.Color := claBlack;
     csFocused:       (Cell as TTMSFMXGridCell).Layout.FontFill.Color := claBlue;
     csFixed:         (Cell as TTMSFMXGridCell).Layout.FontFill.Color := claNavy;
     csFixedSelected: (Cell as TTMSFMXGridCell).Layout.FontFill.Color := claNavy;
     csSelected:      (Cell as TTMSFMXGridCell).Layout.FontFill.Color := claWhite;
  end;
end;


procedure p_TMSFMXGrid_ChartClickSeries(Form:TForm; TMSFMXGrid:TTMSFMXGrid;
  Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var i,j:integer;
begin
  for i:=0 to Series.Count-1 do begin
    for j:=0 to TMSFMXGrid.RowCount-1 do begin
      if TMSFMXGrid.Cells[0,j] = Series.Labels.Labels[i] then begin
         //Series.ValueColor[i] := f_Chart_Color(TMSFMXGrid1.Items[j].Tag);
      end;
    end;
  end;

  for i:=0 to TMSFMXGrid.RowCount-1 do begin
    if TMSFMXGrid.Cells[0,i] = Series.Labels.Labels[ValueIndex] then begin
       TMSFMXGrid.ItemIndex  := i;
     //ListView1ItemClick(Sender,ListView1.Items[i]);
    end;
  end;
  //Series.ValueColor[ValueIndex] := TAlphaColors.Black;


end;


procedure p_SetButtonWidth(aForm:TForm;aName:String);
var i,c:integer;
begin
  c:=0;
  for i:=0 to aForm.ComponentCount-1 do begin
    if  (Pos(UpperCase(aName),UpperCase(aForm.Components[i].Name))>0) and
        (aForm.Components[i] is TButton) and
        (TButton(aForm.Components[i]).Visible) then begin
       c:=c+1;
    end;
  end;
  for i:=0 to aForm.ComponentCount-1 do begin
    if  (Pos(UpperCase(aName),UpperCase(aForm.Components[i].Name))>0) and
        (aForm.Components[i] is TButton) and
        (TButton(aForm.Components[i]).Visible) then begin
       TButton(aForm.Components[i]).Width := aForm.Width/c;
    end;
  end;

end;

//어플실행
procedure p_LaunchApp(a_AppUrl:String);
{$ifdef android}
var
  PM: JPackageManager;
  mainIntent: JIntent;
  LaunchIntent: JIntent;
  pkgAppsList: JList;
  ri: JResolveInfo;
  iter: JIterator;
  midlist : TStringList;
{$endif}
begin
{$ifdef android}
//PM := SharedActivityContext.getPackageManager;
  PM := TAndroidHelper.Context.getPackageManager;
  mainIntent := TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_MAIN, nil);
  mainIntent.addCategory(TJIntent.JavaClass.CATEGORY_LAUNCHER);
  pkgAppsList := PM.queryIntentActivities(mainIntent, 0);
  midlist := TStringList.Create;
  iter := pkgAppsList.iterator;
  while iter.hasNext do
  begin
    ri := TJResolveInfo.Wrap((iter.next as ILocalObject).GetObjectID);
    mIdList.Add(JStringToString(ri.activityInfo.applicationInfo.packageName));
  end;
  LaunchIntent := PM.getLaunchIntentForPackage(StringToJString(a_AppUrl));

// 해당을 실행하려면 아래처럼,..,
//SharedActivityContext.startActivity( LaunchIntent )
  TAndroidHelper.Context.startActivity( LaunchIntent );

  //showmessage(  mIdList.Text );
{$endif}
{$IFDEF IOS}
{$ENDIF}

end;

//어플설치여부
function f_IsAppInstalled(const AAppName: string): Boolean;
{$ifdef android}
var
  PackageManager: JPackageManager;
{$endif}
begin
{$ifdef android}
  PackageManager := TAndroidHelper.Activity.getPackageManager;
  try
    PackageManager.getPackageInfo(StringToJString(AAppName), TJPackageManager.JavaClass.GET_ACTIVITIES);
    Result := True;
  except
    on Ex: Exception do
      Result := False;
  end;
{$endif}
{$IFDEF IOS}
//Result := TNSString.Wrap(CFBundleGetValueForInfoDictionaryKey(CFBundleGetMainBundle, kCFBundleVersionKey)).UTF8String;
{$ENDIF}
end;



procedure p_LaunchURL(const URL: string);
{$IFDEF IOS}
 var NSU: NSUrl;
{$ENDIF IOS}
begin
 {$ifdef android}
  f_LaunchActivity(TJIntent.JavaClass.ACTION_VIEW, StrToJURI(URL));
 {$endif}
 {$IFDEF IOS}
  NSU := StrToNSUrl(TIdURI.URLEncode(URL));
  if SharedApplication.canOpenURL(NSU) then SharedApplication.openUrl(NSU);
 {$ENDIF IOS}
end;


procedure p_Launchios(const URL: string);
{$IFDEF IOS}
var
   App : UIApplication;
   NSU: NSUrl;
{$ENDIF IOS}
begin
{$IFDEF IOS}
  App   := TUIApplication.Wrap(TUIApplication.OCClass.sharedApplication);
  NSU   := TNSURL.Wrap(TNSURL.OCClass.URLWithString(StrToNSStr(URL)));
  if App.canOpenURL(NSU) then
     App.openUrl(NSU)else
     p_ShowMessage('Can not open URL');
{$ENDIF IOS}
end;


{$IFDEF ANDROID}
function f_LaunchActivityForResult(const Intent: JIntent; RequestCode: Integer): Boolean;
var
  ResolveInfo: JResolveInfo;
begin
  ResolveInfo := TAndroidHelper.Activity.getPackageManager.resolveActivity(Intent, 0);
  Result := ResolveInfo <> nil;
  if Result then TAndroidHelper.Activity.startActivityForResult(Intent, RequestCode);
end;

function f_LaunchActivity(const Action: JString; const URI: Jnet_Uri): Boolean; overload;
var
  Intent: JIntent;
begin
  Intent := TJIntent.JavaClass.init(Action, URI);
  Result := f_LaunchActivity(Intent);
end;
{$ENDIF}
{$IFDEF IOS}
{$ENDIF}


{$IFDEF ANDROID}
function f_LaunchActivity(const Intent: JIntent): Boolean; overload;
var
  ResolveInfo: JResolveInfo;
begin
  ResolveInfo := TAndroidHelper.Activity.getPackageManager.resolveActivity(Intent, 0);
  Result := ResolveInfo <> nil;
  if Result then
    TAndroidHelper.Activity.startActivity(Intent);
end;
{$ENDIF}


{$IFDEF IOS}
{$ENDIF}



procedure p_LoadImage_Emp_ListView(aListView:TListView; k:integer; aImage,aRecycle,aLarge:Boolean);
var i:integer;
var v_StringList:TStringList;
var x_StringList:TStringList;

  function f_Same_Image(idx:integer;aEmpNo:String):Boolean;
  var x:integer;
  begin
    Result := false;
    if idx<1 then Exit;
    for x:=idx-1 Downto 0 do begin
      try
        x_StringList.Clear;
        ExtractStrings([':'],[#0],PChar(aListView.Items[x].TagString),x_StringList);
        if aEmpNo = x_StringList[k] then begin
           aListView.Items[idx].Bitmap.Assign(aListView.Items[x].Bitmap);
           Result := true;
           Break;
        end;
      finally
      end;
    end;
  end;

begin
  v_StringList := TStringList.Create;
  x_StringList := TStringList.Create;
  aListView.BeginUpdate;
  with aListView do begin
    for i:=0 to ItemCount-1 do begin
      try
        v_StringList.Clear;
        ExtractStrings([':'],[#0],PChar(Items[i].TagString),v_StringList);

        //if ItemCount>g_User_MaxImage then begin
        //   p_LoadImage_Clear(Items[i].Bitmap);
        //end

        p_LoadImage_Clear(Items[i].Bitmap);

        if aRecycle then begin
          if not f_Same_Image(i,v_StringList[k]) then begin
             if aLarge
                then p_LoadImage_Url_Large(Items[i].Bitmap,c_Image_Emp_small,v_StringList[k]+'.jpg')
                else p_LoadImage_Url_Small(Items[i].Bitmap,c_Image_Emp_small,v_StringList[k]+'.jpg');
          end
        end
        else begin
             if aLarge
                then p_LoadImage_Url_Large(Items[i].Bitmap,c_Image_Emp_small,v_StringList[k]+'.jpg')
                else p_LoadImage_Url_Small(Items[i].Bitmap,c_Image_Emp_small,v_StringList[k]+'.jpg');
        end;
      finally
      end;
    end;
  end;
  v_StringList.Free;
  x_StringList.Free;
  aListView.EndUpdate;
end;




// 웹상의 이미지를 폼(TImage)에서 사용하는 방법
//https://tech.devgear.co.kr/delphi_news/344499

//https://tech.devgear.co.kr/delphi_news/344499
//procedure p_LoadThumbnailFromUrl(AUrl: string; const AFitWidth,AFitHeight: Integer);
//var
//  Bitmap: TBitmap;
//  scale: Single;
//begin
//  LoadFromUrl(AUrl);
//  scale := RectF(0, 0, Width, Height).Fit(RectF(0, 0, AFitWidth, AFitHeight));
//  Bitmap := CreateThumbnail(Round(Width / scale), Round(Height / scale));
//  try
//    Assign(Bitmap);
//  finally
//    Bitmap.Free;
//  end;
//end;

function f_FindAnyClass(const Name: string): TClass;
var
  C: TRttiContext;
  T: TRttiType;
  list: TArray<TRttiType>;
begin
  Result := nil;
  C := TRttiContext.Create;
  list := C.GetTypes;
  for T in list do begin
      if T.IsInstance and (EndsText(Name, T.Name)) then begin
          Result := T.AsInstance.MetaClassType;
          break;
      end;
    end;
  C.Free;
end;

procedure p_Delay(ms: Integer);
var StopWatch: TStopWatch;
begin
  StopWatch := TStopWatch.Create;
  StopWatch.Start;
  repeat
    Application.ProcessMessages;
    Sleep(1);
  until StopWatch.ElapsedMilliseconds >= ms;
end;

function  f_Check_Version:Boolean;
var v_Version:String;
begin
  Result := false;
  with frmCom_DataModule.ClientDataSet_Proc do begin
    try
        v_Version := f_GetAppVersion(0);
        {$IFDEF Android}
        p_CreatePrams;//('Check_Version');
        ParamByName('arg_ModCd'       ).AsString := 'SARAM_Check_Version';
        {$ENDIF}
        {$IFDEF ios}
        p_CreatePrams;//('Check_Version_ios');
        ParamByName('arg_ModCd'       ).AsString := 'SARAM_Check_Version_ios';
        {$ENDIF}
        p_ParamByName('arg_Text01',    f_GetAppVersion(0));
        Open;
        if RecordCount=1 then begin
          Result           := FieldByName('SYS_Status' ).AsInteger=0;
          g_Query_Message  := FieldByName('SYS_Message').AsString;
          g_Query_Status   := FieldByName('SYS_Status' ).AsInteger;
          g_Query_SysVer   := FieldByName('SYS_Version').AsString;
          g_Query_SysID    := FieldByName('SYS_AppID'  ).AsString;
        end;
    finally
      Close;
    end;
  end;
end;


//procedure p_Send_SMS(const PhoneNumber, Msg: string);
//var
//  SmsManager: JSmsManager;
//begin
//  if Trim(PhoneNumber)='' then exit;
//  if Trim(Msg)='' then exit;
//  if not f_HasPermission('android.permission.SEND_SMS') then
//{$IF RTLVersion >= 31}
//    TDialogService.MessageDialog('App does not have the SEND_SMS permission', TMsgDlgType.mtError, [TMsgDlgBtn.mbCancel], TMsgDlgBtn.mbCancel, 0, nil)
//{$ELSE}
//    MessageDlg('App does not have the SEND_SMS permission', TMsgDlgType.mtError, [TMsgDlgBtn.mbCancel], 0)
//{$ENDIF}
//  else
//  begin
//    SmsManager := TJSmsManager.JavaClass.getDefault;
//    SmsManager.sendTextMessage(
//      StringToJString(PhoneNumber),
//      nil,
//      StringToJString(Msg),
//      nil,
//      nil)
//  end;
//end;


//procedure p_Send_SMS_New(const Number, Msg: string);
//var
//  Intent: JIntent;
//  Uri: Jnet_Uri;
//begin
//  Uri    := TJnet_Uri.JavaClass.parse(StringToJString(Format('smsto:%s', [Number])));
//  Intent := TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_VIEW,Uri);
//  Intent.putExtra(StringToJString('sms_body'), StringToJString(Msg));
//  Intent.setType (StringToJString('vnd.android-dir/mms-sms'));
//  SharedActivity.startActivity(Intent);
//end;





function f_OpenURL(const URL: string; const DisplayError: Boolean = False): Boolean;
{$IFDEF ANDROID}
var
  Intent: JIntent;
begin
// There may be an issue with the geo: prefix and URLEncode.
// will need to research
  Intent := TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_VIEW,
    TJnet_Uri.JavaClass.parse(StringToJString(TIdURI.URLEncode(URL))));
  try
    TAndroidHelper.Activity.startActivity(Intent);
  //TAndroidHelper.Activity(Intent);
    exit(true);
  except
    on e: Exception do
    begin
      if DisplayError then ShowMessage('Error: ' + e.Message);
      exit(false);
    end;
  end;
end;
{$ELSE}
{$IFDEF IOS}
var
  NSU: NSUrl;
begin
  // iOS doesn't like spaces, so URL encode is important.
  NSU := StrToNSUrl(TIdURI.URLEncode(URL));
  if SharedApplication.canOpenURL(NSU) then
    exit(SharedApplication.openUrl(NSU))
  else
  begin
    if DisplayError then
      ShowMessage('Error: Opening "' + URL + '" not supported.');
    exit(false);
  end;
end;
{$ELSE}
begin
  raise Exception.Create('Not supported!');
end;
{$ENDIF IOS}
{$ENDIF ANDROID}



function f_Send_eMail(const aMailTo,aSubject,aBody: string; const DisplayError: Boolean = False): Boolean;
{$IFDEF ANDROID}
var Intent: JIntent;
begin
  Intent := TJIntent.JavaClass.init(TJIntent.Javaclass.ACTION_SENDTO);
  Intent.setData(TJnet_Uri.JavaClass.parse(StringToJString('mailto:'+aMailTo)));
  Intent.putExtra(TJIntent.JavaClass.EXTRA_SUBJECT, StringToJString(aSubject));
  Intent.putExtra(TJIntent.JavaClass.EXTRA_TEXT,    StringToJString(aBody));
  try
    TAndroidHelper.Context.startActivity(Intent);
    Exit(true);
  except
  on e: Exception do
    begin
      if DisplayError then ShowMessage('Error(ANDROID): ' + e.Message);
      Exit(false);
    end;
  end;
end;
{$ELSE}
{$IFDEF IOS}
var NSU: NSUrl;
begin
  NSU := StrToNSUrl(TIdURI.URLEncode('mailto://'+aMailTo+'?Subject='+aSubject+'&Body='+aBody));
  if SharedApplication.canOpenURL(NSU) then begin
     Exit(SharedApplication.openUrl(NSU))
  end
  else begin
    if DisplayError then ShowMessage('Error(IOS): Opening not supported.');
    Exit(false);
  end;
end;
{$ELSE}
begin
  raise Exception.Create('Not supported!');
end;
{$ENDIF IOS}
{$ENDIF ANDROID}



//{$IFDEF ANDROID}
//OpenURL('mailto:ASDADA@something.com');
//{$ELSE}
//{$IFDEF IOS}
//OpenURL('mailto://ASDADA@something.com?Subject=This is the subject'+
//                                    '&Body=This is the text of the body'+
//                                    'And this will change line \n '+
//                                    'This is written in a new line');
//{$ENDIF IOS}
//{$ENDIF ANDROID}



procedure P_Send_Email(const Recipient, Subject, Content, Attachment: string);
{$IFDEF ANDROID}
var
  JRecipient: TJavaObjectArray<JString>;
  Intent: JIntent;
  Uri: Jnet_Uri;
  AttachmentFile: JFile;
{$ENDIF}
begin
{$IFDEF ANDROID}
  JRecipient := TJavaObjectArray<JString>.Create(1);
  JRecipient.Items[0] := StringToJString(Recipient);
  Intent := TJIntent.Create;
  Intent.setAction(TJIntent.JavaClass.ACTION_SEND);
  Intent.setFlags (TJIntent.JavaClass.FLAG_ACTIVITY_NEW_TASK);
  Intent.putExtra (TJIntent.JavaClass.EXTRA_EMAIL,   JRecipient);
  Intent.putExtra (TJIntent.JavaClass.EXTRA_SUBJECT, StringToJString(Subject));
  Intent.putExtra (TJIntent.JavaClass.EXTRA_TEXT,    StringToJString(Content));
  if Attachment <> '' then begin
     AttachmentFile := TJFile.JavaClass.init(StringToJString(Attachment));
     Uri := TJnet_Uri.JavaClass.fromFile(AttachmentFile);
     Intent.putExtra(TJIntent.JavaClass.EXTRA_STREAM, TJParcelable.Wrap((Uri as ILocalObject).GetObjectID));
  end;
  Intent.setType(StringToJString('vnd.android.cursor.dir/email'));
  TandroidHelper.Activity.startActivity(Intent);
{$ENDIF}
end;

function f_Send_Verify_Number(aCompany,aEmpNo,aNumber:String):Boolean;
begin
  Result := false;
  with frmCom_DataModule.ClientDataSet_Proc do begin
    try
      p_CreatePrams;
      ParamByName('arg_ModCd' ).AsString := 'INSERT_USER_VERIFY_NUMBER';
      ParamByName('arg_Text01').AsString := aCompany;
      ParamByName('arg_Text02').AsString := aEmpNo;
      ParamByName('arg_Text03').AsString := 'BluePocket 인증번호';
      ParamByName('arg_Text04').AsString := aNumber;
      Open;
      if RecordCount=1 then Result := FieldByName('CNT' ).AsInteger=1;
      Close;
    except
      Close;
      Result := false;
      p_ShowMessage('인증번호를 발신할 수 없습니다.');
    end;
  end;
end;



procedure p_Check_VersonUpdate(localversion,requestversion:Integer);
{$IFDEF ANDROID}
var Intent: JIntent;
{$ENDIF}
begin
{$IFDEF ANDROID}
  if localversion<requestversion then begin
    TDialogService.MessageDialog(('새로운 버젼이 출시되었습니다. 업데이트 하시겠습니까?'),
    system.UITypes.TMsgDlgType.mtInformation,
   [system.UITypes.TMsgDlgBtn.mbYes, system.UITypes.TMsgDlgBtn.mbNo], system.UITypes.TMsgDlgBtn.mbYes,0,
    procedure (const AResult: System.UITypes.TModalResult)
    begin
      case AResult of
        mrYES: begin
                 Intent := TJIntent.Create;
                 Intent.setAction(TJIntent.JavaClass.ACTION_VIEW);
                 Intent.setData(StrToJURI('https://play.google.com/store/apps/details?id=com.mygenstar.genstarsaram'));
                 TAndroidHelper.Context.startActivity(Intent);
                 exit;
               end;
        mrNo:     exit;
        mrCancel: exit;
      end;
    end);
  end;
{$ENDIF}
end;


procedure p_MakeChart(aForm:TForm; aTMSFMXGrid:TTMSFMXGrid; aChart:TChart; aTitle:String; aColText,aColValue:integer);
var i:integer;
    v:Double;
    s:String;
    c:TAlphaColor;
begin
  aChart.BeginUpdate;
  aChart.Visible:= true;
//aChart.BeginUpdate;
  aChart.Title.Visible  := false;
  aChart.Legend.Visible := false;
  aChart.RemoveAllSeries;
  aChart.Title.Visible  := True;
  aChart.Title.Caption  := aTitle;
  with aTMSFMXGrid,aChart do begin
    AddSeries(TLineSeries.Create(aForm));
    AddSeries(TBarSeries.Create(aForm));
    Series[0].Clear;
    Series[1].Clear;
    TBarSeries(Series[1]).Marks.Arrow.Visible := true;
    TBarSeries(Series[1]).Marks.Visible       := true;
    TBarSeries(Series[1]).Marks.Style         := smsValue;
    TBarSeries(Series[1]).Marks.Font.Size     := 7;
    for i:=1 to RowCount-1-FixedFooterRows do begin
      c := f_Chart_Color(i);
      v := f_ToNumber(Cells[aColValue,i]);
    //v := Cells[aColValue,i].ToDouble;
      s := Cells[aColText,i];
      Series[0].AddXY(i,v,s,c);
      Series[1].AddXY(i,v,s,c);
    end;
  end;
  aChart.EndUpdate;
end;




procedure p_iniFile_Write(aString1,aString2,aString3:String);
var iniFile: TIniFile;
begin
  try
    IniFile := TIniFile.Create(System.IOUtils.TPath.Combine(System.IOUtils.TPath.GetDocumentsPath,c_iniFile));
    IniFile.WriteString(aString1,aString2,aString3);
  finally
    IniFile.Free;
  end;
end;

//procedure p_Excute_File(aFileName:String);
//var
//  Path, Filename, FileExt: String;
//  MimeType: JString;
//  LFile: JFile;
//  FileUri: JNet_Uri;
//  ViewIntent, OpenIntent: JIntent;
//begin
//  Filename := aFileName;
//  FileExt := StringReplace(TPath.GetExtension(Filename), '.', '', []);
//  MimeType := TJMimeTypeMap.JavaClass.getSingleton.getMimeTypeFromExtension(StringToJString (FileExt));
//  if MimeType = nil then MimeType := StringToJString('*/*');
//  Path := TPath.GetPublicPath + PathDelim + Filename;
//  LFile := TJFile.JavaClass.init(StringToJString(Path));
//  FileUri := TJnet_Uri.JavaClass.fromFile(LFile);
//  ViewIntent := TJIntent.Create;
//  OpenIntent := TJIntent.Create;
//  ViewIntent.setAction(TJIntent.JavaClass.ACTION_VIEW);
//  ViewIntent.setDataAndType(FileUri, MimeType);
//  if MainActivity.getPackageManager.queryIntentActivities(ViewIntent, TJPackageManager.JavaClass.MATCH_DEFAULT_ONLY).size > 0
//    then SharedActivity.startActivity(ViewIntent)
//    else ShowMessage(Format('''%s'' 확장자와 연결된 프로그램을 찾을 수 없습니다.', [FileExt]));
//end;



procedure p_ActExecute(Sender: TAction);
begin
  with TAction(Sender) do begin
    g_Sel_Action_Text := Text;
    g_Sel_Action_Name := Name;
    g_Sel_Title       := Hint;
    g_Sel_Url         := HelpKeyword;
    Execute;
  end;
end;



//procedure p_SetComCode(aComboCode,aComboName:TComboBox; const aCompany,aHcode:String; aClear,aAddNull:Boolean);
//var i: Integer;
//begin
//  if aClear then begin
//    aComboCode.Items.Clear;
//    aComboName.Items.Clear;
//  end;
//  if aAddNull then begin
//     aComboName.Items.Add('');
//     aComboCode.Items.Add('');
//  end;
////aComboCode.Visible := false;
//  with frmCom_DataModule.ClientDataSet_Proc do begin
//    try
//      p_CreatePrams;
//      ParamByName('arg_ModCd' ).AsString := 'SARAM_COM_CODE';
//      ParamByName('arg_Text01').AsString := aCompany;
//      ParamByName('arg_Text02').AsString := aHcode;
//      Open;
//      for i:=0 to RecordCount-1 do begin
//        aComboName.Items.Add(FieldByName('CD_DNAME').AsString);
//        aComboCode.Items.Add(FieldByName('CD_DCODE').AsString);
//        aComboName.ListItems[i].TagString := FieldByName('CD_DCODE').AsString;
//        aComboName.ListItems[i].Text      := FieldByName('CD_DNAME').AsString;
//        aComboName.ListItems[i].Tag       := FieldByName('CD_VALUE').AsInteger;
//        aComboCode.ListItems[i].TagString := FieldByName('CD_DCODE').AsString;
//        aComboCode.ListItems[i].Text      := FieldByName('CD_DNAME').AsString;
//        aComboCode.ListItems[i].Tag       := FieldByName('CD_VALUE').AsInteger;
//        Next;
//      end;
//    finally
//      Close;
//    end;
//  end;
//end;


procedure p_SetComboCode(aForm:TForm; aComboBox:TComboBox; const aHcode:String); overload;
begin
  p_SetComboCode(aForm,aComboBox,'0000000',aHcode,false,'','');
end;


procedure p_SetComboCode(aForm:TForm; aComboBox:TComboBox; const aCompany,aHcode:String); overload;
begin
  p_SetComboCode(aForm,aComboBox,aCompany,aHcode,false,'','');
end;

procedure p_SetComboCode(aForm:TForm; aComboBox:TComboBox; const aCompany,aHcode:String;aAddNull:Boolean; aNullCode,aNullName:String); overload;
var i: Integer;
var v_ListItems : TListBoxItem;
begin
  aComboBox.Items.Clear;

  if aAddNull then begin
     v_ListItems                := TListBoxItem.Create(aForm);
     v_ListItems.Parent         := aComboBox;
     v_ListItems.Text           := aNullName;
     v_ListItems.TagString      := aNullCode;
     v_ListItems.Tag            := -1;
     v_ListItems.StyledSettings := v_ListItems.StyledSettings-[TStyledSetting.FontColor];
     v_ListItems.FontColor      := TAlphaColors.Black;
     aComboBox.ItemIndex        := 0;
  end;

  with frmCom_DataModule.ClientDataSet_Proc do begin
    try
      p_CreatePrams;
      ParamByName('arg_ModCd' ).AsString := 'SARAM_COM_CODE';
      ParamByName('arg_Text01').AsString := aCompany;
      ParamByName('arg_Text02').AsString := aHcode;
      Open;
      for i:=0 to RecordCount-1 do begin
        v_ListItems                := TListBoxItem.Create(aForm);
        v_ListItems.Parent         := aComboBox;
        v_ListItems.Text           := FieldByName('CD_DNAME'      ).AsString;
        v_ListItems.TagString      := FieldByName('CD_DCODE'      ).AsString;
        v_ListItems.Tag            := FieldByName('CD_VALUE'      ).AsInteger;
        v_ListItems.StyledSettings := v_ListItems.StyledSettings-[TStyledSetting.FontColor];
        v_ListItems.FontColor      := StringToAlphaColor(FieldByName('CD_FontColor').AsString);
        Next;
      end;

    finally
      Close;
    end;
  end;
end;


function f_GetComboCode(aComboBox:TComboBox; aCode:String): integer;
var i,cnt:integer;
begin
  Result:=-1;
  cnt := 0;
  for i:=0 to aComboBox.Items.Count-1 do begin
    if aComboBox.ListItems[i].TagString=aCode then begin
       cnt    := cnt+1;
       Result := i;
    end;
  end;
  if cnt<>1 then Result := -1;
end;



function  f_StrToDate(aDate:String):TDate; overload;
var S: String;
var F: TFormatSettings;
begin
  S := Copy(aDate,1,4)+'-'+Copy(aDate,5,2)+'-'+Copy(aDate,7,2);
  GetLocaleFormatSettings(0,F);
  F.ShortDateFormat := 'YYYY-MM-DD';
  F.DateSeparator   := '-';
  Result := StrToDate(S,F);
end;


procedure p_ComboBox_FontSize(aComboBox:TComboBox; aSize:Single);
var item : TListBoxItem;
    i : Integer;
begin
  for i:=0 to aComboBox.Count-1 do begin
    item := aComboBox.ListItems[i];
    item.Font.Size := aSize;
    item.StyledSettings := item.StyledSettings - [TStyledSetting.Size];
  end;
end;


procedure p_iniChkCombo(aChkCombo:TTMSFMXCheckGroupPicker);
var i: Integer;
begin
  for i:=0 to aChkCombo.Items.Count-1 do begin
    aChkCombo.IsChecked[i] := false;
  end;
end;





//procedure p_SetChkCombo(aChkCombo:TTMSFMXCheckGroupPicker); overload;
//begin
//  p_SetChkCombo(aChkCombo,aChkCombo.HelpKeyword);
//end;


procedure p_SetChkCombo(aChkCombo:TTMSFMXCheckGroupPicker;aHCode:String); overload;
begin
  p_SetChkCombo(aChkCombo,'0000000',aHCode,'',false,'','');
end;

procedure p_SetChkCombo(aChkCombo:TTMSFMXCheckGroupPicker;aCompany,aHCode,aDCode:String); overload;
begin
  p_SetChkCombo(aChkCombo,aCompany,aHCode,aDCode,false,'','');
end;


procedure p_SetChkCombo(aChkCombo:TTMSFMXCheckGroupPicker; aCompany,aHCode,aDCode:String; aAddNull:Boolean; aNullCode,aNullName:String); overload;
var i,k: Integer;
begin
  aChkCombo.BeginUpdate;
  aChkCombo.Items.Clear;
  aChkCombo.DropDownAutoSize := true;
  k:=-1;
  if aAddNull then Begin
     k:=k+1;
     aChkCombo.Items.Add;
     aChkCombo.Items[0].Tag   := -1;
     aChkCombo.Items[0].Text  := aNullName;
     aChkCombo.Items[0].Value := aNullCode;
  end;

  with frmCom_DataModule.ClientDataSet_Proc do begin
    try
      p_CreatePrams;
      ParamByName('arg_ModCd' ).AsString := 'SARAM_COM_CODE';
      ParamByName('arg_Text01').AsString := aCompany;
      ParamByName('arg_Text02').AsString := aHCode;
      ParamByName('arg_Text03').AsString := aDCode;
      Open;
      for i:=0 to RecordCount-1 do begin
        k:=k+1;
        aChkCombo.Items.Add;
        aChkCombo.Items[k].Tag   := FieldByName('CD_VALUE').AsInteger;
        aChkCombo.Items[k].Text  := FieldByName('CD_DNAME').AsString;
        aChkCombo.Items[k].Value := FieldByName('CD_DCODE').AsString;
        Next;
      end;
    finally
      Close;
      aChkCombo.EndUpdate;
    end;
  end;
end;


procedure p_GetChkCombo(aChkCombo:TTMSFMXCheckGroupPicker; aValues:String);
var i,j:integer;
var v_StringList:TStringList;
begin
  v_StringList := TStringList.Create;
  v_StringList.CommaText := aValues;
  for i:=0 to aChkCombo.Items.Count-1 do begin
    aChkCombo.IsChecked[i] := false;
    for j:=0 to v_StringList.Count-1 do begin
      if aChkCombo.Items[i].Value=v_StringList[j] then begin
         aChkCombo.IsChecked[i] := true;
      end;
    end;
  end;
  v_StringList.Free;
end;



function f_GetChkCombo(aChkCombo:TTMSFMXCheckGroupPicker;aValue:Boolean): String;
var i,c:integer;
begin
  c:=0;
  Result := '';
  for i:=0 to aChkCombo.Items.Count-1 do begin
    if aChkCombo.IsChecked[i] then begin
       c:=c+1;
       if aValue then begin  //코드
         if c=1
            then Result := aChkCombo.Items[i].Value
            else Result := Result+','+aChkCombo.Items[i].Value;
       end
       else begin           //코드명
         if c=1
            then Result := aChkCombo.Items[i].Text
            else Result := Result+','+aChkCombo.Items[i].Text;
       end;
    end;
  end;
end;

procedure p_GetComboBox(aChkCombo:TTMSFMXRadioGroupPicker; aValues:String);
var i:integer;
begin
  aChkCombo.ItemIndex := -1;
  for i:=0 to aChkCombo.Items.Count-1 do begin
    if aChkCombo.Items[i].Value = aValues then begin
       aChkCombo.ItemIndex := i;
       Break;
    end;
  end;
end;


//procedure p_SetComboBox(aComboBox:TTMSFMXRadioGroupPicker); overload;
//begin
//  p_SetComboBox(aComboBox,aComboBox.HelpKeyword);
//end;
procedure p_SetComboBox(aComboBox:TTMSFMXRadioGroupPicker; aHCode:String); overload;
begin
  p_SetComboBox(aComboBox,'0000000',aHCode,'');
end;


procedure p_SetComboBox(aComboBox:TTMSFMXRadioGroupPicker; aCompany,aHCode:String); overload;
begin
  p_SetComboBox(aComboBox,aCompany,aHCode,'');
end;

procedure p_SetComboBox(aComboBox:TTMSFMXRadioGroupPicker; aCompany,aHCode,aDCode:String); overload;
var i: Integer;
begin
  aComboBox.BeginUpdate;
  aComboBox.Items.Clear;
  with frmCom_DataModule.ClientDataSet_Proc do begin
    try
      p_CreatePrams;
      ParamByName('arg_ModCd' ).AsString := 'SARAM_COM_CODE';
      ParamByName('arg_Text01').AsString := aCompany;
      ParamByName('arg_Text02').AsString := aHCode;
      ParamByName('arg_Text03').AsString := aDCode;
      Open;
      for i:=0 to RecordCount-1 do begin
        aComboBox.Items.Add;
        aComboBox.Items[i].Tag   := i;
        aComboBox.Items[i].Text  := FieldByName('CD_DNAME').AsString;
        aComboBox.Items[i].Value := FieldByName('CD_DCODE').AsString;
        Next;
      end;
    finally
      Close;
      aComboBox.EndUpdate;
    end;
  end;
end;


//procedure p_QRCodeScanner(RequestCode: Integer);
//{$ifdef android}
//var
//  Intent: JIntent;
//{$endif}
//begin
//{$ifdef android}
//  Intent := TJIntent.JavaClass.init(StringToJString('com.google.zxing.client.android.SCAN'));
//  Intent.setPackage(StringToJString('com.google.zxing.client.android'));
//  //If you want to target QR codes
//  //Intent.putExtra(StringToJString('SCAN_MODE'), StringToJString('QR_CODE_MODE'));
//  if not f_LaunchActivityForResult(Intent, RequestCode) then begin
//    Toast('Cannot display QR scanner', ShortToast);
//  end;
//{$endif}
//end;



procedure p_CopyPaste(aString: String);
var
  Svc: IFMXClipboardService;
  Value: TValue;
begin
  if TPlatformServices.Current.SupportsPlatformService(IFMXClipboardService, Svc) then begin
    Value := Svc.GetClipboard;
    if not Value.IsEmpty then begin
      if Value.IsType<string> then begin
         aString := Value.ToString;
      end;
    end;
  end;
end;

procedure p_ClearPlaner(aForm:TForm; aPlanner:TTMSFMXPlanner; aDateTime:TDateTime; aUnit,aHeight:Integer); Overload;
begin
  with aPlanner do begin
    try
      BeginUpdate;
    //Resources.Clear;
      SelectedItems.Clear;
      Items.Clear;
    //Mode                                := pmDay;   //pmMultiDay;
      ModeSettings.StartTime              := aDateTime;
      OrientationMode                     := pomVertical;
      TimeLine.DisplayUnit                := aUnit;   //분간격
      TimeLine.DisplayUnitSize            := aHeight; //라인의높이
      TimeLine.CurrentTimeMode            := pctmText;
      TimeLine.DisplayEnd                 := Round(MinsPerDay/TimeLine.DisplayUnit)-1;
      TimeLineAppearance.CurrentTimeColor := TAlphaColors.Blue;
      TimeLine.ViewStart                  := aDateTime;//+EncodeTime(08,0,0,0);
      EndUpdate;
    finally
    end;
  end;
end;

procedure p_ClearPlaner(aForm:TForm; aPlanner:TTMSFMXPlanner; aDateEdit:TDateEdit; aUnit,aHeight:Integer); Overload;
begin
  p_ClearPlaner(aForm,aPlanner,aDateEdit.DateTime,aUnit,aHeight);
end;

procedure p_ClearPlaner(aForm:TForm; aPlanner:TTMSFMXPlanner; aDateEdit:TDateEdit); Overload;
begin
  p_ClearPlaner(aForm,aPlanner,aDateEdit.DateTime,30,30);
end;


procedure p_ClearPlaner(aForm:TForm; aPlanner:TTMSFMXPlanner; aDateTime:TDateTime); Overload;
begin
  p_ClearPlaner(aForm,aPlanner,aDateTime,30,30);
end;




function f_Query_PlanerList(aForm:TForm; aPlanner:TTMSFMXPlanner; aDateFr,aDateTo:TDateTime; aSelect:Boolean): integer;  overload;
begin
  f_Query_PlanerList(aForm,aPlanner,aDateFr,aDateTo,aSelect,30,08,23,08,19);
end;

function f_Query_PlanerList(aForm:TForm; aPlanner:TTMSFMXPlanner; aDateFr,aDateTo:TDateTime; aSelect:Boolean; aUnit,aDStart,aDEnd,aAStart,aAEnd:Integer): integer;  overload;
var i,c,k:integer;
var v_item: TTMSFMXPlannerItem;
begin
  Result := -1;
  k := Trunc(60/aUnit);
  p_ClearPlaner(aForm,aPlanner,aDateFr,30,25);
  with frmCom_DataModule.ClientDataSet_Proc,aPlanner do begin
    try
      BeginUpdate;
      Interaction.ShowSelection      := aSelect; //라인선택
      Positions.Count                := Trunc(aDateTo)-Trunc(aDateFr)+1;
      Resources.Clear;
      TimeLine.DisplayUnit           := aUnit;     //간격(분)
      TimeLine.DisplayStart          := aDStart*k; //시작(시)
      TimeLine.DisplayEnd            := aDEnd*k+1; //종료(시)
      TimeLine.ActiveStart           := aAStart*k; //시작(시)
      TimeLine.ActiveEnd             := aAEnd*k+1; //종료(시)
      TimeLine.ViewStart             := aDateFr+EncodeTime(aDStart,0,0,0);
      Open;
      Result := RecordCount;
      for i:=0 to RecordCount-1 do begin
        v_item             := AddOrUpdateItem(FieldByName('DateFr').AsDateTime
                                             ,FieldByName('DateTo').AsDateTime
                                             ,FieldByName('TITLE' ).AsString
                                             ,FieldByName('TEXT'  ).AsString,i);

        v_item.Resource    := 0;

        v_item.DataString  := '';
        v_item.DataInteger := -1;
        v_item.DataBoolean := false;

        v_item.Editable    := false;
        v_item.Deletable   := false;
        v_item.Movable     := false;
        v_item.Sizeable    := false;

        for c:=0 to FieldCount-1 do begin
          if      CompareText(Fields[c].FullName,'Color'         )=0 then v_item.Color          := StringToAlphaColor(Fields[c].AsString)
          else if CompareText(Fields[c].FullName,'FontColor'     )=0 then v_item.FontColor      := StringToAlphaColor(Fields[c].AsString)
          else if CompareText(Fields[c].FullName,'TitleColor'    )=0 then v_item.TitleColor     := StringToAlphaColor(Fields[c].AsString)
          else if CompareText(Fields[c].FullName,'TitleFontColor')=0 then v_item.TitleFontColor := StringToAlphaColor(Fields[c].AsString)

          else if CompareText(Fields[c].FullName,'DataString'    )=0 then v_item.DataString     := Fields[c].AsString
          else if CompareText(Fields[c].FullName,'DataInteger'   )=0 then v_item.DataInteger    := Fields[c].AsInteger
          else if CompareText(Fields[c].FullName,'DataBoolean'   )=0 then v_item.DataBoolean    := Fields[c].AsInteger=1

          else if CompareText(Fields[c].FullName,'Editable'      )=0 then v_item.Editable       := Fields[c].AsInteger=1
          else if CompareText(Fields[c].FullName,'Deleteable'    )=0 then v_item.Deletable      := Fields[c].AsInteger=1
          else if CompareText(Fields[c].FullName,'Moveable'      )=0 then v_item.Movable        := Fields[c].AsInteger=1
          else if CompareText(Fields[c].FullName,'Sizeable'      )=0 then v_item.Sizeable       := Fields[c].AsInteger=1;
        end;
        Next;
      end;
    finally
      Close;
      EndUpdate;
    end;
  end;
end;

Procedure p_SetCombo_Dept(aCombo:TTMSFMXRadioGroupPicker; aAll:Boolean);
var i:integer;
var v_StringList1:TStringList;
var v_StringList2:TStringList;
begin
  try
    aCombo.BeginUpdate;
    aCombo.Items.Clear;
    aCombo.Enabled := false;

    v_StringList1 := TStringList.Create;
    v_StringList2 := TStringList.Create;
    v_StringList1.Clear;
    v_StringList2.Clear;
    ExtractStrings([':'],[#0],PChar(g_User_DeptList_CD),v_StringList1);
    ExtractStrings([':'],[#0],PChar(g_User_DeptList_NM),v_StringList2);

    if v_StringList1.Count=0 then begin
      aCombo.Items.Add;
      aCombo.Items[0].Value := g_User_Dept;
      aCombo.Items[0].Text  := g_User_DeptName;
    end else
    if v_StringList1.Count=1 then begin
      aCombo.Items.Add;
      aCombo.Items[0].Value := v_StringList1[0];
      aCombo.Items[0].Text  := v_StringList2[0];
    end else
    if v_StringList1.Count>1 then begin
      if aAll then begin
         aCombo.Items.Add;
         aCombo.Items[0].Value := '*';
         aCombo.Items[0].Text  := '전체';
      end;
      for i:=0 to v_StringList1.Count-1 do begin
        aCombo.Items.Add;
        aCombo.Items[aCombo.Items.Count-1].Value := v_StringList1[i];
        aCombo.Items[aCombo.Items.Count-1].Text  := v_StringList2[i];
      end;
    end;
    if aCombo.Items.Count>0 then aCombo.ItemIndex := 0;
    if aCombo.Items.Count>1 then aCombo.Enabled   := true;
  finally
    v_StringList1.Free;
    v_StringList2.Free;
    aCombo.EndUpdate;
  end;

end;

{$IF Defined(ANDROID)}
function f_NetworkGetConnectivityManager: JConnectivityManager;
var
  ConnectivityServiceNative: JObject;
begin
  ConnectivityServiceNative := SharedActivityContext.getSystemService(TJContext.JavaClass.CONNECTIVITY_SERVICE);
  if not Assigned(ConnectivityServiceNative) then
    raise Exception.Create('Could not locate Connectivity Service');
  Result := TJConnectivityManager.Wrap(
    (ConnectivityServiceNative as ILocalObject).GetObjectID);
  if not Assigned(Result) then
    raise Exception.Create('Could not access Connectivity Manager');
end;

function f_NetworkIsConnected: Boolean;
var
  ConnectivityManager: JConnectivityManager;
  ActiveNetwork: JNetworkInfo;
begin
  ConnectivityManager := f_NetworkGetConnectivityManager;
  ActiveNetwork := ConnectivityManager.getActiveNetworkInfo;
  Result := Assigned(ActiveNetwork) and ActiveNetwork.isConnected;
end;

function f_NetworkIsWiFiConnected: Boolean;
var
  ConnectivityManager: JConnectivityManager;
  WiFiNetwork: JNetworkInfo;
begin
  ConnectivityManager := f_NetworkGetConnectivityManager;
  WiFiNetwork := ConnectivityManager.getNetworkInfo(TJConnectivityManager.JavaClass.TYPE_WIFI);
  Result := WiFiNetwork.isConnected;
end;

function f_NetworkIsMobileConnected: Boolean;
var
  ConnectivityManager: JConnectivityManager;
  MobileNetwork: JNetworkInfo;
begin
  ConnectivityManager := f_NetworkGetConnectivityManager;
  MobileNetwork := ConnectivityManager.getNetworkInfo(TJConnectivityManager.JavaClass.TYPE_MOBILE);
  Result := MobileNetwork.isConnected;
end;
{$ENDIF}


//Procedure  p_Excel_DownLoad(aForm:TForm; TMSFMXGrid: TTMSFMXGrid;a_FileName:String);
//var TExcel : TTMSFMXGridExcelIO;
//begin
//  TExcel := TTMSFMXGridExcelIO.Create(nil);
//  TExcel.GridStartRow := 0;
//  TExcel.GridStartCol := 0;
//  TExcel.Grid         := TMSFMXGrid;
//  TExcel.Options.ExportShowGridLines := True;
//  TExcel.Options.ExportHiddenColumns := False;
//  TExcel.Options.ExportShowInExcel   := True;
//  TExcel.XLSExport(a_FileName);
//end;

Procedure  p_Excel_DownLoad_Grid(TMSFMXGrid: TTMSFMXGrid);
{$IF Defined(MSWINDOWS)}
var TExcel : TTMSFMXGridExcelIO;
    TSave  : TSaveDialog;
    v_FileName : String;
{$ENDIF}
begin
{$IF Defined(MSWINDOWS)}
  TSave := TSaveDialog.Create(nil);
  TSave.Filter :=  'Excel files (*.xls)|*.xls';
  TSave.Execute;
  TSave.DefaultExt := 'xls';
  v_FileName := TSave.FileName + '.xls';


  if TSave.FileName <> '' then begin
     TExcel := TTMSFMXGridExcelIO.Create(nil);
     TExcel.GridStartRow := 0;
     TExcel.GridStartCol := 0;
     TExcel.Grid         := TMSFMXGrid;

     TExcel.Options.ExportHiddenColumns := True;
     TExcel.Options.ExportShowInExcel   := True;
     TExcel.XLSExport(v_FileName);
  end;
  TSave.Free;
{$ENDIF}
end;

Procedure  p_Excel_DownLoad_ListView(aForm:TForm;a_ActionName,a_arg_Text01,a_arg_Text02,
                                     a_arg_Text03,a_arg_Text04,a_arg_Text05:String);
{$IF Defined(MSWINDOWS)}
var TExcel : TTMSFMXGridExcelIO;
    TSave  : TSaveDialog;
    TGrid  : TTMSFMXGrid;
    v_FileName : String;
{$ENDIF}
begin
{$IF Defined(MSWINDOWS)}
  TGrid := TTMSFMXGrid.Create(nil);

  with frmCom_DataModule.ClientDataSet_Proc do begin
    p_CreatePrams;
    ParamByName('arg_ModCd' ).AsString := a_ActionName;
    ParamByName('arg_Text01').AsString := a_arg_Text01;
    ParamByName('arg_Text02').AsString := a_arg_Text02;
    ParamByName('arg_Text03').AsString := a_arg_Text03;
    ParamByName('arg_Text04').AsString := a_arg_Text04;
    ParamByName('arg_Text05').AsString := a_arg_Text05;
    f_TMSFMXGrid_SetData (aForm,frmCom_DataModule.ClientDataSet_Proc,TGrid);
  end;

  TSave := TSaveDialog.Create(nil);
  TSave.Filter :=  'Excel files (*.xls)|*.xls';
  TSave.Execute;
  TSave.DefaultExt := 'xls';
  v_FileName := TSave.FileName + '.xls';


  if TSave.FileName <> '' then begin
     TExcel := TTMSFMXGridExcelIO.Create(nil);
     TExcel.GridStartRow := 0;
     TExcel.GridStartCol := 0;
     TExcel.Grid         := TGrid;

     TExcel.Options.ExportHiddenColumns := True;
     TExcel.Options.ExportShowInExcel   := True;
     TExcel.XLSExport(v_FileName);
  end;
  TSave.Free;
  TGrid.Free;
{$ENDIF}
end;

function f_Query_TMSFMXGrid(aForm:TForm; aTMSFMXGrid:TTMSFMXGrid; aFixedCols, aFooterRow:integer): integer;
var r,c,k:integer;
begin
  Result := -1;
  aTMSFMXGrid.Visible := true;
  aTMSFMXGrid.FixedFooterRows := aFooterRow;
  p_TMSFMXGrid_Clear(aForm,aTMSFMXGrid);
  aTMSFMXGrid.BeginUpdate;
  aTMSFMXGrid.Align := Fmx.Types.TAlignLayout.Client;
  with frmCom_DataModule.ClientDataSet_Proc,aTMSFMXGrid do begin
    try
      Open;
      Result      := RecordCount;
      RowCount    := RecordCount+1;
      ColumnCount := FieldCount +1;
      Clear;
     k:=-1;
     for c:=0 to FieldCount-1 do begin
        Cells [c+1,0]         := Fields[c].FullName;
        HorzAlignments[c+1,0] := Fmx.Types.TTextAlign.Center;
      end;
      for r:=0 to RecordCount-1 do begin
        RowHeights[r+1]       := RowHeights[0];
        Cells [0,r+1]         := (r+1).toString;
        HorzAlignments[0,r+1] := Fmx.Types.TTextAlign.Center;
        for c:=0 to FieldCount-1 do begin
//        if (c+1)=k
//          then aTMSFMXGrid.AddProgressBar(c+1,r+1,Fields[c].AsFloat)
//          else p_TMSFMXGrid_SetField(Self,aTMSFMXGrid,Fields,c,c+1,r+1);
          p_TMSFMXGrid_SetField(aForm,aTMSFMXGrid,Fields,c,c+1,r+1);
        end;
        Next;
      end;
    //AutoSizeColumn(0,true);
    finally
      Close;
      aTMSFMXGrid.AutoSizeColumns;
    end;
  end;
  aTMSFMXGrid.FixedColumns := aFixedCols+1;
  aTMSFMXGrid.EndUpdate;
end;

procedure StyleComboBoxItems(ComboBox:TComboBox; Size:Single);
var
  Item : TListBoxItem;
  i : Integer;
begin

  for i := 0 to ComboBox.Count-1 do begin
    Item := ComboBox.ListItems[i];
//    Item.Font.Family := Family; //'Arial';
    Item.Font.Size := Size;
//20;

// Item.FontColor := TAlphaColorRec.Red;
    Item.StyledSettings := Item.StyledSettings - [TStyledSetting.Size];

// Item.Text := '*'+Item.Text;
  end;
end;

end.


