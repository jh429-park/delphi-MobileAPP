 unit Com_NewPaper_Detail;

interface

uses
  FMX.Graphics,
  FMX.DialogService,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.ListView.Types,
  FMX.StdCtrls, FMX.ListView, FMX.ListView.Appearances, Data.Bind.GenData,
  Fmx.Bind.GenData, System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components,
  Data.Bind.ObjectScope, FMX.ListBox,
  System.UIConsts,
  FMX.TabControl, FMX.Objects, FMX.MobilePreview, FMX.Controls.Presentation,
  FMX.ListView.Adapters.Base, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP, System.ImageList, FMX.ImgList, System.Math.Vectors,
  FMX.Controls3D, FMX.Objects3D, FMX.Viewport3D, FMX.Layouts,
  FMX.Layers3D,
  Fmx.Ani, FMX.MultiView,
  FMX.Platform, Datasnap.DSClientRest, System.Actions, FMX.ActnList,
  FMX.Gestures, FMX.ScrollBox, FMX.Memo, FMX.Edit, FMX.DateTimeCtrls,
  FMX.EditBox, FMX.NumberBox, FMX.TMSCustomButton, FMX.TMSSpeedButton;

type
  TfrmCom_NewPaper_Detail = class(TForm)
    HeaderToolBar: TToolBar;
    Label_Title: TLabel;
    btnClose: TButton;
    edtBdName: TEdit;
    btnSelect_Bd: TTMSFMXSpeedButton;
    edtBdCode: TEdit;
    btnBdInfo: TTMSFMXSpeedButton;
    edtUrl: TMemo;
    Label1: TLabel;
    edtTitle: TEdit;
    Image2: TImage;
    edtFrom: TEdit;
    edtSeq: TEdit;
    btnUrl: TTMSFMXSpeedButton;
    edtBdName_DB: TEdit;
    edtIUserId: TEdit;
    Layout_Update: TLayout;
    btnSave: TButton;
    btnDelete: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MenuButtonClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnSelect_BdClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnBdInfoClick(Sender: TObject);
    procedure btnUrlClick(Sender: TObject);
    procedure edtBdNameChange(Sender: TObject);
    procedure edtUrlChange(Sender: TObject);
    procedure edtUrlKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure edtBdNameKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure btnDeleteClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCom_NewPaper_Detail: TfrmCom_NewPaper_Detail;
implementation

{$R *.fmx}

uses Com_DataModule,Com_function,Com_Variable,MainMenu, Com_Select_Code;


procedure TfrmCom_NewPaper_Detail.btnBdInfoClick(Sender: TObject);
begin
  g_Sel_ActionKind := 1;
  g_Sel_Title      := '대상빌딩정보';
  if (Trim(edtBdCode.Text)='') or (Trim(edtBdName.Text)='') then Exit;
  g_Sel_Text01 := edtBdName.Text;
  g_Sel_Text02 := edtBdCode.Text;
  p_ActExecute(frmMainMenu.Rch_Building_List01);
end;

procedure TfrmCom_NewPaper_Detail.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCom_NewPaper_Detail.btnDeleteClick(Sender: TObject);
begin
  if Trim(edtSeq.Text)='' then Exit;
  if Trim(edtiUserId.Text)<>g_User_EmpNo then Exit;
  TDialogService.MessageDialog(('삭제하시겠습니까?'),
  system.UITypes.TMsgDlgType.mtInformation,
 [system.UITypes.TMsgDlgBtn.mbYes, system.UITypes.TMsgDlgBtn.mbCancel], system.UITypes.TMsgDlgBtn.mbYes,0,
  procedure (const AResult: System.UITypes.TModalResult)
  begin
    case AResult of
      mrYes: begin
               g_Data_Updated := true;
               with frmCom_DataModule.ClientDataSet_Proc do begin
                 try
                   p_CreatePrams;
                   ParamByName('arg_ModCd'  ).AsString := 'Com_Newspaper_Delete';
                   ParamByName('arg_TEXT01' ).AsString := edtSeq.Text;
                   Open;
                   if (RecordCount=0) then begin
                      edtSeq.Text := '';
                      p_Toast('삭제되었습니다.')
                   end else p_Toast('System Error');
                   frmMainMenu.Com_Marketing_ScheduleExecute(Self);
                 finally
                   Close;
                   Layout_Update.Visible := false;
                 end;
               end;
             end;
    end;
  end);
end;

procedure TfrmCom_NewPaper_Detail.FormShow(Sender: TObject);
begin

  btnUrl.Visible        := false;
  btnBdInfo.Visible     := false;
  Label_Title.Text      := g_Sel_Title;

  edtSeq.Text           := '';
  edtFrom.Text          := '';
  edtTitle.Text         := '';
  edtUrl.Text           := '';
  edtBdCode.Text        := '';
  edtBdName.Text        := '';
  edtBdName_Db.Text     := '';
  Layout_Update.Visible := true;
  btnDelete.Visible     := false;


  if g_Sel_GUBUN='1' then begin
    with frmCom_DataModule.ClientDataSet_Proc do begin
      try
        p_CreatePrams;
        ParamByName('arg_ModCd'  ).AsString := 'Com_Newspaper_Select';
        ParamByName('arg_TEXT01' ).AsString := g_Sel_TagString[0];
        Open;
        edtSeq.Text           := FieldByName('SEQ'      ).AsString;
        edtFrom.Text          := FieldByName('FROM'     ).AsString;
        edtTitle.Text         := FieldByName('TITLE'    ).AsString;
        edtUrl.Text           := FieldByName('WEBADDR'  ).AsString;
        edtBdCode.Text        := FieldByName('STR_LOCAL').AsString;
        edtBdName.Text        := FieldByName('STR_BONBU').AsString;
        edtBdName_Db.Text     := FieldByName('STR_TEAM' ).AsString;
        edtIUserId.Text       := FieldByName('iUSerID'  ).AsString;

        btnUrl.Visible        := edtUrl.Text<>'';
        btnBdInfo.Visible     := edtBdCode.Text<>'';
        Layout_Update.Visible := edtIUserId.Text=g_User_EmpNo;
        btnDelete.Visible     := edtIUserId.Text=g_User_EmpNo;
      finally
        Close;
      end;
    end;
  end;

  g_Sel_GUBUN := '';

end;


procedure TfrmCom_NewPaper_Detail.btnSelect_BdClick(Sender: TObject);
begin
  g_Sel_Title    := '빌딩선택';
  g_Sel_GUBUN    := 'BUILDING_CODE';
  g_Sel_Text01   := ' 빌딩명/주소';
  g_Sel_Text02   := edtBDNAME.Text;
  g_Sel_Text03   := '';
  g_Sel_Text04   := '';
  g_Sel_Text05   := '';
  Application.CreateForm(TfrmCom_Select_Code,frmCom_Select_Code);
  frmCom_Select_Code.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
end;

procedure TfrmCom_NewPaper_Detail.btnUrlClick(Sender: TObject);
begin
  if Trim(edtUrl.Text) <> '' then  p_Open_Url_New(edtUrl.Text);
end;

procedure TfrmCom_NewPaper_Detail.btnSaveClick(Sender: TObject);
begin

  if Trim(edtTitle.Text)='' then Exit;
  if Trim(edtUrl.Text)  ='' then Exit;

  TDialogService.MessageDialog(('게시하시겠습니까?'),
  system.UITypes.TMsgDlgType.mtInformation,
 [system.UITypes.TMsgDlgBtn.mbYes, system.UITypes.TMsgDlgBtn.mbCancel], system.UITypes.TMsgDlgBtn.mbYes,0,
  procedure (const AResult: System.UITypes.TModalResult)
  begin
    if Trim(edtBdName.Text)='' then begin
       edtBdCode.Text    := '';
       edtBdName_DB.Text := '';
    end;
    case AResult of
      mrYes: begin
               g_Data_Updated := true;
               with frmCom_DataModule.ClientDataSet_Proc do begin
                 try
                   p_CreatePrams;
                   if Trim(edtSeq.Text)=''
                      then ParamByName('arg_ModCd'  ).AsString := 'Com_Newspaper_Insert'
                      else ParamByName('arg_ModCd'  ).AsString := 'Com_Newspaper_Update';
                   ParamByName('arg_TEXT01' ).AsString := '['+Trim(edtFrom.Text)+'] '+edtTitle.Text;
                   ParamByName('arg_TEXT02' ).AsString := edtUrl.Text;
                   ParamByName('arg_TEXT03' ).AsString := edtBdCode.Text;
                   ParamByName('arg_TEXT04' ).AsString := edtBdName.Text;
                   ParamByName('arg_TEXT05' ).AsString := edtBdName_DB.Text;
                   ParamByName('arg_TEXT06' ).AsString := edtSeq.Text;
                   Open;
                   if (RecordCount=1) then begin
                      edtSeq.Text := FieldByName('SEQ').AsString;
                      p_Toast('게시되었습니다.')
                   end else p_Toast('System Error');
                   frmMainMenu.Com_Marketing_ScheduleExecute(Self);
                 finally
                   Close;
                   Layout_Update.Visible := false;
                 end;
               end;
             end;
    end;
  end);
end;

procedure TfrmCom_NewPaper_Detail.edtBdNameChange(Sender: TObject);
begin
  if Trim(edtBdName.Text)='' then begin
     edtBdCode.Text    := '';
     edtBdName_DB.Text := '';
  end;
  btnBdInfo.Visible := not (Trim(edtBdCode.Text)='');
end;

procedure TfrmCom_NewPaper_Detail.edtBdNameKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  edtBdNameChange(Sender);
end;

procedure TfrmCom_NewPaper_Detail.edtUrlKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  edtUrlChange(Sender);
end;


procedure TfrmCom_NewPaper_Detail.edtUrlChange(Sender: TObject);
begin
  btnUrl.Visible := not(Trim(edtUrl.Text)='');
end;


procedure TfrmCom_NewPaper_Detail.FormActivate(Sender: TObject);
begin
  if (g_Sel_Code='') and (g_Sel_CodeName1='') and (g_Sel_CodeName2='') then Exit;
  if g_Sel_GUBUN = 'BUILDING_CODE' then begin
     if Trim(edtBdName.Text)='' then
        edtBdName.Text := g_Sel_CodeName1;
     edtBdName_DB.Text := g_Sel_CodeName1;
     edtBdCode.Text    := g_Sel_Code;
     btnBdInfo.Visible := true;
  end;
  g_Sel_CodeName1 := '';
  g_Sel_CodeName2 := '';
  g_Sel_Code      := '';
end;

procedure TfrmCom_NewPaper_Detail.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;



procedure TfrmCom_NewPaper_Detail.MenuButtonClick(Sender: TObject);
begin
  Close;
end;

initialization
   RegisterClasses([TfrmCom_NewPaper_Detail]);

finalization
   UnRegisterClasses([TfrmCom_NewPaper_Detail]);

end.

