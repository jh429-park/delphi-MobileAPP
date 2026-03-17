 unit Dtm_TTime_Detail;

interface

uses
//{$IFDEF ANDROID}
//  Androidapi.JNI.Os,
//  Androidapi.JNI.JavaTypes,
//  Androidapi.Helpers,
//{$ENDIF}
//  System.IOUtils,
//  System.DateUtils,
//  FMX.VirtualKeyboard,
//  FMX.Platform,
//  FMX.DialogService,
//  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
//  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.ListView.Types,
//  Fmx.Bind.GenData, System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors,
//  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components,
//  Data.Bind.ObjectScope, FMX.ListBox,
//  System.UIConsts,
//  FMX.Graphics,
//  IdTCPClient, IdHTTP, System.ImageList, FMX.ImgList, System.Math.Vectors,
//  FMX.ListView.Adapters.Base, FMX.TabControl, FMX.Controls.Presentation,
//  FMX.StdCtrls, FMX.ListView.Appearances, FMX.ListView, FMX.ScrollBox, FMX.Memo,
//  FMX.Layouts, FMX.Edit, FMX.DateTimeCtrls, FMX.Objects,
//  FMX.ActnList, FMX.StdActns, FMX.MediaLibrary.Actions, FMX.TMSCustomButton,
//  FMX.TMSSpeedButton,
//  System.Actions;

  System.IOUtils,
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
  FMX.TMS7SegLed, System.Actions, FMX.ActnList, FMX.StdActns,
  FMX.MediaLibrary.Actions, FMX.TMSCustomButton, FMX.TMSSpeedButton,
  FMX.DateTimeCtrls;

type
  TfrmDtm_TTime_Detail = class(TForm)
    HeaderToolBar: TToolBar;
    Label_Title: TLabel;
    btnClose: TButton;
    btnQuery: TButton;
    Layout_Body: TLayout;
    Layout11: TLayout;
    edtDateFr: TDateEdit;
    Label26: TLabel;
    Layout3: TLayout;
    edtCustCompany: TEdit;
    edtCustCompany_Code: TEdit;
    Layout5: TLayout;
    edtTitle: TEdit;
    edtCompany: TEdit;
    edtEmpNo: TEdit;
    edtSeq: TEdit;
    Label10: TLabel;
    edtDateTo: TDateEdit;
    Label1: TLabel;
    edtUrl: TEdit;
    TMSFMXSpeedButton1: TTMSFMXSpeedButton;
    TMSFMXSpeedButton2: TTMSFMXSpeedButton;
    Layout4: TLayout;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    DateEdit2: TDateEdit;
    Label4: TLabel;
    edtImage: TEdit;
    Image_Body: TImage;
    Layout_Save: TLayout;
    btnDelete: TButton;
    btnSave: TButton;
    procedure btnClearClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MenuButtonClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure btnQueryClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDtm_TTime_Detail: TfrmDtm_TTime_Detail;
  l_Action: integer;
implementation

{$R *.fmx}

uses System.Math, FMX.Utils,Com_DataModule,Com_function,Com_Variable;

procedure TfrmDtm_TTime_Detail.FormShow(Sender: TObject);
begin
 {$IFDEF ANDROID}
  PermissionsService.RequestPermissions(
    [JStringToString(TJManifest_permission.JavaClass.READ_EXTERNAL_STORAGE),
     JStringToString(TJManifest_permission.JavaClass.WRITE_EXTERNAL_STORAGE)],
    procedure(const APermissions: TArray<string>; const AGrantResults: TArray<TPermissionStatus>)
    begin
      if (Length(AGrantResults) = 2) and
         (AGrantResults[0] = TPermissionStatus.Granted) and
         (AGrantResults[1] = TPermissionStatus.Granted) then begin
      end
      else begin
        TDialogService.ShowMessage('파일사용권한이 없습니다.');
      end;
    end);
 {$ENDIF}



  l_Action         := g_Sel_ActionKind;
  g_Sel_ActionKind := -1;
  g_Data_Updated   := false;
  if l_Action = 0 then begin
     btnClearClick(Sender);
     btnSave.  Visible:= true;
     btnDelete.Visible:= false;
  end else
  if l_Action > 0 then begin
     edtSeq.Text   := g_Sel_TagString[0];
     btnQueryClick(Sender);
  end;
end;


procedure TfrmDtm_TTime_Detail.btnClearClick(Sender: TObject);
begin
  edtSeq.Text    := '';
  edtTitle.Text  := '';
  edtUrl.Text    := 'DT_contents_vol???.html';
  edtImage.Text  := '';
  edtDateFr.DateTime := Trunc(Now);
  edtDateTo.DateTime := Trunc(Now)+7;
  Image_Body.BitMap.Clear(TAlphaColors.Gray);
  btnSave.  Visible:= false;
  btnDelete.Visible:= false;
end;


procedure TfrmDtm_TTime_Detail.btnQueryClick(Sender: TObject);
begin
  g_Data_Updated := false;
  with frmCom_DataModule.ClientDataSet_Proc do begin
    try
      p_CreatePrams;
      ParamByName('arg_ModCd' ).AsString := 'saram_dtm_TTime_Detail';
      ParamByName('arg_Text01').AsString := edtSeq.Text;
      btnClearClick(Sender);
      Open;
      if RecordCount=1 then begin
         edtSeq.Text         := FieldByName('Seq'       ).AsString;
         edtTitle.Text       := FieldByName('Title'     ).AsString;
         edtUrl.Text         := FieldByName('Url'       ).AsString;
         edtImage.Text       := FieldByName('Image'     ).AsString;
         Layout_Save.Visible := FieldByName('Can_Update').AsInteger=1;
         p_LoadImage_Url_Small(Image_Body.Bitmap,c_Image_Dt_Main,edtImage.Text);
      end;
    finally
      Close;
    end;
  end;
end;





procedure TfrmDtm_TTime_Detail.btnSaveClick(Sender: TObject);
begin
  g_Data_Updated := true;
  edtImage.Text  := StringReplace(edtUrl.Text,'.html','',[])+'.png';
  Image_Body.BitMap.Clear(TAlphaColors.Gray);
  with frmCom_DataModule.ClientDataSet_Proc do begin
    try
      p_CreatePrams;
      ParamByName('arg_ModCd' ).AsString := 'saram_dtm_TTime_Save';
      ParamByName('arg_Text01').AsString := edtSeq.  Text;
      ParamByName('arg_Text02').AsString := edtTitle.Text;
      ParamByName('arg_Text03').AsString := edtUrl.  Text;
      ParamByName('arg_Text04').AsString := edtImage.Text;
      ParamByName('arg_Text05').AsString := FormatDateTime('YYYYMMDD',edtDateTo.Date);
      ParamByName('arg_Text06').AsString := FormatDateTime('YYYYMMDD',edtDateTo.Date);
      Open;
      if RecordCount=1 then begin
         p_LoadImage_Url_Small(Image_Body.Bitmap,c_Image_Dt_Main,edtImage.Text);
         p_Toast('저장완료');
      end else
      begin
         p_Toast('저장실패');
      end;
    finally
      Close;
    end;
  end;
end;



procedure TfrmDtm_TTime_Detail.btnCloseClick(Sender: TObject);
begin
  Close;
end;




procedure TfrmDtm_TTime_Detail.btnDeleteClick(Sender: TObject);
begin
  g_Data_Updated   := true;
  with frmCom_DataModule.ClientDataSet_Proc do begin
    try
      p_CreatePrams;
      ParamByName('arg_ModCd' ).AsString := 'saram_dtm_TTime_Delete';
      ParamByName('arg_Text01').AsString := edtSeq.  Text;
      Open;
      if RecordCount=0 then begin
         p_Toast('삭제완료');
      end else
      begin
         p_Toast('삭제실패');
      end;

    finally
      Close;
    end;
  end;
end;

procedure TfrmDtm_TTime_Detail.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;


procedure TfrmDtm_TTime_Detail.MenuButtonClick(Sender: TObject);
begin
  Close;
end;


procedure TfrmDtm_TTime_Detail.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
var FService: IFMXVirtualKeyboardService;
begin
  if (Key = vkHardwareBack) then begin
    TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, IInterface(FService));
    if (FService <> nil) and (TVirtualKeyboardState.Visible in FService.VirtualKeyBoardState) then begin
        Layout_Body.Align := Fmx.Types.TAlignLayout.Client;
    end
    else begin
      Key := 0;
      Self.Close;
    end;
  end;
end;


initialization
   RegisterClasses([TfrmDtm_TTime_Detail]);

finalization
   UnRegisterClasses([TfrmDtm_TTime_Detail]);

end.



