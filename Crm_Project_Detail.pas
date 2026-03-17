 unit Crm_Project_Detail;

interface

uses
  FMX.VirtualKeyboard,
  FMX.Platform,
  FMX.DialogService,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.ListView.Types,
  Fmx.Bind.GenData, System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components,
  Data.Bind.ObjectScope, FMX.ListBox,
  System.UIConsts,
  IdTCPClient, IdHTTP, System.ImageList, FMX.ImgList, System.Math.Vectors,
  FMX.ListView.Adapters.Base, FMX.TabControl, FMX.Controls.Presentation,
  FMX.StdCtrls, FMX.ListView.Appearances, FMX.ListView, FMX.ScrollBox, FMX.Memo,
  FMX.Layouts, FMX.Edit, FMX.DateTimeCtrls, FMX.Objects, FMX.TMSCustomButton,
  FMX.TMSSpeedButton, FMX.TMSBaseControl, FMX.TMSCustomPicker,
  FMX.TMSCheckGroupPicker, FMX.TMSRadioGroupPicker;

type
  TfrmCrm_Project_Detail = class(TForm)
    HeaderToolBar: TToolBar;
    Label_Title: TLabel;
    btnClose: TButton;
    btnQuery: TButton;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    ListView1: TListView;
    Layout_Body: TLayout;
    Layout11: TLayout;
    edtDateFr: TDateEdit;
    edtDateTo: TDateEdit;
    Text1: TText;
    Label26: TLabel;
    Layout7: TLayout;
    edtCustName: TEdit;
    edtCustName_Code: TEdit;
    Label23: TLabel;
    Layout_BdInfo: TLayout;
    edtBd_YYYYMM: TEdit;
    edtBdName: TEdit;
    btnQuery_Bd: TTMSFMXSpeedButton;
    btnSelect_Bd: TTMSFMXSpeedButton;
    edtBdCode: TEdit;
    edtBDYYYYMM: TEdit;
    Label21: TLabel;
    Layout6: TLayout;
    edtProject: TEdit;
    edtSeq: TEdit;
    edtCompany: TEdit;
    Label10: TLabel;
    Layout4: TLayout;
    Label19: TLabel;
    Layout8: TLayout;
    Label18: TLabel;
    Layout2: TLayout;
    edtEmpNo: TEdit;
    edtEmpName: TEdit;
    edtDeptCode: TEdit;
    edtDeptName: TEdit;
    Label22: TLabel;
    Layout3: TLayout;
    edtCustCompany: TEdit;
    edtCustCompany_Code: TEdit;
    lblCustCompany: TLabel;
    Layout5: TLayout;
    edtKeyMan: TEdit;
    btnQuery_KeyMan: TTMSFMXSpeedButton;
    btnSelect_KeyMan: TTMSFMXSpeedButton;
    edtKeyMan_Code: TEdit;
    Label2: TLabel;
    Layout9: TLayout;
    edtHomePage: TEdit;
    btnQuery_HomePage: TTMSFMXSpeedButton;
    Label3: TLabel;
    Label1: TLabel;
    edtMemo: TMemo;
    Layout_Save: TLayout;
    btnDelete: TButton;
    btnSave: TButton;
    btnSaveAs: TButton;
    Layout1: TLayout;
    Label17: TLabel;
    edtiUserName: TEdit;
    Layout10: TLayout;
    Label4: TLabel;
    edtuUserName: TEdit;
    edtOpen: TTMSFMXCheckGroupPicker;
    edtStep: TTMSFMXRadioGroupPicker;
    procedure btnQueryClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MenuButtonClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure btnQuery_BdClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSaveAsClick(Sender: TObject);
    procedure btnQuery_HomePageClick(Sender: TObject);
    procedure btnQuery_KeyManClick(Sender: TObject);
    procedure btnSelect_KeyManClick(Sender: TObject);
    procedure btnSelect_BdClick(Sender: TObject);
    procedure edtMemoMouseEnter(Sender: TObject);
    procedure edtOpenCheckGroupSelected(Sender: TObject; Index: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCrm_Project_Detail: TfrmCrm_Project_Detail;
  l_Action: integer;
  l_TabItem2Text :String;//= '마케팅활동';

implementation

{$R *.fmx}

uses System.Math, FMX.Utils,Com_DataModule,Com_function,Com_Variable,MainMenu,
  Crm_Customer_Detail, Com_Select_Code, Com_WebBrowser;

procedure TfrmCrm_Project_Detail.FormShow(Sender: TObject);
begin
  l_TabItem2Text := TabItem2.Text;
  TabControl1.ActiveTab.Index := 0;
  l_Action         := g_Sel_ActionKind;
  g_Sel_ActionKind := -1;

  p_SetComboBox(edtStep,'PROJECT_STEP');
  p_SetChkCombo(edtOpen,'PROJECT_OPEN');

  g_Data_Updated        := false;
  if l_Action = 0 then begin
     btnClearClick(Sender);
  end else
  if l_Action > 0 then begin
     edtCompany.Text         := g_Sel_TagString[0];
     edtSeq.Text             := g_Sel_TagString[1];
     btnQueryClick(Sender);
  end;
end;


procedure TfrmCrm_Project_Detail.btnCloseClick(Sender: TObject);
begin
  Close;
end;


procedure TfrmCrm_Project_Detail.btnClearClick(Sender: TObject);
begin
  TabItem2.Text            := l_TabItem2Text;
  Layout_Save.Visible      := true;
  btnQuery.Visible         := false;
  btnSaveAs.Visible        := false;
  btnSave.Visible          := true;
  btnDelete.Visible        := false;

  edtCompany.Text          := g_User_Company;
  edtEmpNo.Text            := g_User_EmpNo;
  edtDateFr.DateTime       := Now;
  edtDateTo.DateTime       := f_StrToDate(FormatDateTime('YYYY'+'1231',edtDateFr.DateTime));

  edtSeq.Text              := '';

  p_iniChkCombo(edtOpen);
  p_GetChkCombo(edtOpen,'11,20'); //부서원,상위부서장

  edtStep.ItemIndex   := 0;

  edtiUserName.Text        := '';
  edtuUserName.Text        := '';

  btnQuery_KeyMan.Visible  := false;
  btnQuery_Bd.Visible      := false;
  btnQuery_HomePage.Visible:= false;
  btnSelect_KeyMan.Visible := true;
  btnSelect_Bd.Visible     := true;

end;

procedure TfrmCrm_Project_Detail.btnSaveAsClick(Sender: TObject);
begin
  l_Action                 := 0;
  btnClearClick(Sender);
  edtProject.Text          := '(복사)'+edtProject.Text;
  edtSeq.Text              := '';
end;

procedure TfrmCrm_Project_Detail.btnQueryClick(Sender: TObject);
begin

  Layout_Save.Visible      := false;
  btnQuery.Visible         := false;
  btnSaveAs.Visible        := false;
  btnSave.Visible          := false;
  btnDelete.Visible        := false;
  TabItem2.Text            := l_TabItem2Text;
  with frmCom_DataModule.ClientDataSet_Proc do begin
    try
      p_CreatePrams;
      ParamByName('arg_ModCd' ).AsString := 'Crm_Project_Detail';
      ParamByName('arg_Text01').AsString := edtCompany.Text;
      ParamByName('arg_Text02').AsString := edtSeq.Text;
      Open;
      if RecordCount=1 then begin
         edtCompany.Text          := FieldByName('Company'         ).AsString;
         edtSeq.Text              := FieldByName('Seq'             ).AsString;
         edtProject.Text          := FieldByName('Project'         ).AsString;
         edtDaTeFr.DateTime       := FieldByName('DATEFR'          ).AsDateTime;
         edtDaTeTo.DateTime       := FieldByName('DATETO'          ).AsDateTime;
         edtCustCompany.Text      := FieldByName('CustCompany'     ).AsString;
         edtCustName.Text         := FieldByName('CustName'        ).AsString;
         edtKeyMan.Text           := FieldByName('KeyMan'          ).AsString;
         edtCustCompany_Code.Text := FieldByName('CustCompany_Code').AsString;
         edtCustName_Code.Text    := FieldByName('CustName_Code'   ).AsString;
         edtKeyMan_Code.Text      := FieldByName('KeyMan_Code'     ).AsString;

         p_GetComboBox(edtStep, FieldByName('Step').AsString);
         p_GetChkCombo(edtOpen, FieldByName('Open').AsString);

         edtEmpNo.Text            := FieldByName('EmpNo'           ).AsString;
         edtDeptCode.Text         := FieldByName('DeptCode'        ).AsString;
         edtEmpName.Text          := FieldByName('EmpName'         ).AsString;
         edtDeptName.Text         := FieldByName('DeptName'        ).AsString;
         edtBdName.Text           := FieldByName('BDNAME'          ).AsString;
         edtBdCode.Text           := FieldByName('BDCODE'          ).AsString;
         edtHomePage.Text         := FieldByName('HOMEPAGE'        ).AsString;
         edtMemo.Text             := FieldByName('Memo'            ).AsString;

         edtiUserName.Text        := FieldByName('iUserName'       ).AsString;
         edtuUserName.Text        := FieldByName('uUserName'       ).AsString;

         edtBdYYYYMM.Text         := FieldByName('BDYYYYMM'        ).AsString;
         btnSave.Visible          := FieldByName('CAN_UPDATE'      ).AsInteger=1;
         btnDelete.Visible        := FieldByName('CAN_DELETE'      ).AsInteger=1;
         Layout_Save.Visible      :=(btnSave.Visible) or (btnDelete.Visible);
         btnSaveAs.Visible        := Layout_Save.Visible;
         btnQuery.Visible         := Layout_Save.Visible;

         btnQuery_KeyMan.Visible  := edtKeyMan_Code.Text<>'';
         btnQuery_HomePage.Visible:= edtHomePage.Text<>'';
         btnQuery_Bd.Visible      := edtBdCode.Text<>'';


      end
      else ShowMessage('해당데이타없습니다.');
      Close;
      p_CreatePrams;
      ParamByName('arg_ModCd' ).AsString := 'Crm_Project_Detail_Activity';
      ParamByName('arg_Text01').AsString := edtCompany.Text;
      ParamByName('arg_Text02').AsString := edtSEQ.Text;
      f_Query_ListViewList(ListView1);
      btnDelete.Visible := ListView1.ItemCount=0;
      TabItem2.Text := l_TabItem2Text+'('+ListView1.ItemCount.ToString+')';
    finally
      Close;
    end;
  end;
end;


procedure TfrmCrm_Project_Detail.btnSaveClick(Sender: TObject);
begin

  Layout_Body.Align    := Fmx.Types.TAlignLayout.Client;

  TDialogService.MessageDialog(('저장하시겠습니까?'),
  system.UITypes.TMsgDlgType.mtInformation,
 [system.UITypes.TMsgDlgBtn.mbYes, system.UITypes.TMsgDlgBtn.mbCancel], system.UITypes.TMsgDlgBtn.mbYes,0,
  procedure (const AResult: System.UITypes.TModalResult)
  begin
    case AResult of
      mrYes: begin
        with frmCom_DataModule.ClientDataSet_Proc do begin
          try
            p_CreatePrams;
            if l_Action = 0
               then ParamByName('arg_ModCd' ).AsString := 'Crm_Project_Insert'
               else ParamByName('arg_ModCd' ).AsString := 'Crm_Project_Update';

            ParamByName('arg_Text01').AsString := edtCompany.Text;
            ParamByName('arg_Text02').AsString := edtSeq.Text;
            ParamByName('arg_Text03').AsString := edtProject.Text;
            ParamByName('arg_Text04').AsString := FormatDateTime('YYYYMMDD',edtDateFr.DateTime);
            ParamByName('arg_Text05').AsString := FormatDateTime('YYYYMMDD',edtDateTo.DateTime);
            ParamByName('arg_Text06').AsString := edtCustCompany.Text;
            ParamByName('arg_Text07').AsString := edtCustName.Text;
            ParamByName('arg_Text08').AsString := edtKeyMan.Text;
            ParamByName('arg_Text09').AsString := edtCustCompany_Code.Text;
            ParamByName('arg_Text10').AsString := edtCustName_Code.Text;
            ParamByName('arg_Text11').AsString := edtKeyMan_Code.Text;
            ParamByName('arg_Text12').AsString := edtStep.Items[edtStep.ItemIndex].Value;
            ParamByName('arg_Text13').AsString := f_GetChkCombo(edtOpen,false);//edtOpen.Text;
            ParamByName('arg_Text14').AsString := edtEmpNo.Text;
            ParamByName('arg_Text15').AsString := edtDeptCode.Text;
            ParamByName('arg_Text16').AsString := edtEmpName.Text;
            ParamByName('arg_Text17').AsString := edtDeptName.Text;
            ParamByName('arg_Text18').AsString := edtBdCode.Text;
            ParamByName('arg_Text19').AsString := edtBdName.Text;
            ParamByName('arg_Text20').AsString := edtHomePage.Text;
            ParamByName('arg_Text21').AsString := edtMemo.Text;
            Open;
            if RecordCount=1 then begin
               P_Toast('저장완료');
               g_Data_Updated      := true;
               l_Action            := 1;
               edtCompany.Text     := FieldByName('COMPANY'    ).AsString;
               edtSeq.Text         := FieldByName('Seq'        ).AsString;
               Layout_Save.Visible := true;
               btnQuery.Visible    := true;
               btnSaveAs.Visible   := true;
               btnSave.Visible     := true;
               btnDelete.Visible   := true;
               btnQuery_KeyMan.Visible  := edtKeyMan_Code.Text<>'';
               btnQuery_HomePage.Visible:= edtHomePage.Text<>'';
               btnQuery_Bd.Visible      := edtBdCode.Text<>'';
            end;
          finally
            Close;
          end;
        end;
      end;
    end;
  end);
end;


procedure TfrmCrm_Project_Detail.btnSelect_KeyManClick(Sender: TObject);
begin
  g_Sel_Title    := '고객선택';
  g_Sel_GUBUN   := 'CUSTOMER_CODE';
  g_Sel_Text01   := ' 회사명/성명';
  if      Trim(edtKeyMan.Text)=''
    then g_Sel_Text02 := edtCustCompany.Text
    else g_Sel_Text02 := edtKeyMan.Text;
  g_Sel_Text03   := '';//edtCustCompany.Text;
  g_Sel_Text04   := '';
  g_Sel_Text05   := '';
  Application.CreateForm(TfrmCom_Select_Code,frmCom_Select_Code);
  frmCom_Select_Code.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
end;

procedure TfrmCrm_Project_Detail.btnDeleteClick(Sender: TObject);
begin
  TDialogService.MessageDialog(('삭제하시겠습니까?'),
  system.UITypes.TMsgDlgType.mtInformation,
 [system.UITypes.TMsgDlgBtn.mbYes, system.UITypes.TMsgDlgBtn.mbCancel], system.UITypes.TMsgDlgBtn.mbYes,0,
  procedure (const AResult: System.UITypes.TModalResult)
  begin
    case AResult of
      mrYes: begin
              with frmCom_DataModule.ClientDataSet_Proc do begin
                try
                  p_CreatePrams;
                  ParamByName('arg_ModCd' ).AsString := 'Crm_Project_Delete';
                  ParamByName('arg_Text01').AsString := edtCompany.Text;
                  ParamByName('arg_Text02').AsString := edtSeq.Text;
                  Open;
                  if FieldByName('CNT').AsInteger=0 then begin
                     P_Toast('삭제완료');
                     g_Data_Updated           := true;
                     l_Action                 := 0;
                     edtSeq.Text              := '';
                     Layout_Save.Visible      := true;
                     btnQuery.Visible         := false;
                     btnSaveAs.Visible        := false;
                     btnSave.Visible          := true;
                     btnDelete.Visible        := false;

                     btnSelect_KeyMan.Visible := false;
                     btnSelect_Bd.Visible     := false;
                     btnQuery_KeyMan.Visible  := false;
                     btnQuery_Bd.Visible      := false;
                     btnQuery_HomePage.Visible:= false;
                  end
                  else if FieldByName('CNT_ACTIVITY').AsInteger>0 then begin
                     ShowMessage('삭세불가(관련 마케팅활동이 있습니다)');
                  end;
                finally
                  Close;
                end;
              end;
      end;
    end;
  end);
end;





procedure TfrmCrm_Project_Detail.btnCancelClick(Sender: TObject);
begin
  Close;
end;



procedure TfrmCrm_Project_Detail.FormCreate(Sender: TObject);
begin
  g_Sel_CodeName1 := '';
  g_Sel_CodeName2 := '';
  g_Sel_Code      := '';
end;


procedure TfrmCrm_Project_Detail.FormActivate(Sender: TObject);
begin
  if (g_Sel_Code='') and (g_Sel_CodeName1='') and (g_Sel_CodeName2='') then Exit;
  if g_Sel_GUBUN = 'CUSTOMER_CODE' then begin
     edtKeyMan.Text      := g_Sel_CodeName1;
     edtKeyMan_Code.Text := g_Sel_Code;
     btnQuery_KeyMan.Visible := edtKeyMan_Code.Text<>'';
  end else
  if g_Sel_GUBUN = 'BUILDING_CODE' then begin
     edtBdName.Text        := g_Sel_CodeName1;
     edtBdCode.Text        := g_Sel_Code;
     btnQuery_Bd.Visible   := edtBdCode.Text<>'';
  end;
  g_Sel_CodeName1 := '';
  g_Sel_CodeName2 := '';
  g_Sel_Code      := '';
end;

procedure TfrmCrm_Project_Detail.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;






procedure TfrmCrm_Project_Detail.MenuButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCrm_Project_Detail.btnSelect_BdClick(Sender: TObject);
begin
  g_Sel_Title    := '빌딩선택';
  g_Sel_GUBUN   := 'BUILDING_CODE';
  g_Sel_Text01   := ' 빌딩명/주소';
  if      Trim(edtBDNAME.Text)=''
    then g_Sel_Text02 := edtProject.Text
    else g_Sel_Text02 := edtBDNAME.Text;

  g_Sel_Text02   := edtBDNAME.Text;
  g_Sel_Text03   := '';
  g_Sel_Text04   := '';
  g_Sel_Text05   := '';
  Application.CreateForm(TfrmCom_Select_Code,frmCom_Select_Code);
  frmCom_Select_Code.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
end;

procedure TfrmCrm_Project_Detail.btnQuery_BdClick(Sender: TObject);
begin
  g_Sel_ActionKind := 1;
  g_Sel_Title := '대상빌딩정보';
  if (edtBdYYYYMM.Text='') or (edtBdCode.Text='') then Exit;
  g_Sel_Text01 := edtBdYYYYMM.Text;
  g_Sel_Text02 := edtBdCode.Text;
  p_ActExecute(frmMainMenu.Rch_Building_List01);
end;

procedure TfrmCrm_Project_Detail.btnQuery_HomePageClick(Sender: TObject);
begin
//if Trim(edtHomePage.Text) <> '' then p_LaunchApp(edtHomePage.Text);
  if Trim(edtHomePage.Text) <> '' then TUrlOpen.p_UrlOpen(edtHomePage.Text);
end;

procedure TfrmCrm_Project_Detail.btnQuery_KeyManClick(Sender: TObject);
begin
  if edtKeyMan_Code.Text <> '' then begin
    try
      g_Sel_Title := '고객정보';
      g_Sel_TagString.Clear;
    finally
      ExtractStrings([':'],[#0],PChar(edtKeyMan_Code.Text),g_Sel_TagString);
    end;
    Application.CreateForm(TfrmCrm_Customer_Detail,frmCrm_Customer_Detail);
    frmCrm_Customer_Detail.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
  end
  else begin
    g_Sel_Title    := '고객선택';
    g_Sel_Text01   := 'CUSTOMER_CODE';
    g_Sel_Text02   := ' 회사명/성명';
    g_Sel_Text03   := edtCustName.Text;//edtCustName_Code.Text;
    g_Sel_Text04   := '';//edtCustCompany.Text;
    g_Sel_Text05   := '';
    Application.CreateForm(TfrmCom_Select_Code,frmCom_Select_Code);
    frmCom_Select_Code.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
  end;
end;


procedure TfrmCrm_Project_Detail.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
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



procedure TfrmCrm_Project_Detail.edtMemoMouseEnter(Sender: TObject);
begin
  if (btnSave.Visible) and (btnSave.Enabled) and
     (Layout_Body.Align = Fmx.Types.TAlignLayout.Client) then begin
     Layout_Body.Align      := Fmx.Types.TAlignLayout.None;
     Layout_Body.Position.Y := HeaderToolBar.Height+1;
     Layout_Body.Position.Y := Layout_Body.Position.Y-Layout_Body.Height/2;
     Layout_Body.SendToBack;
     edtMemo.SetFocus;
  end;
end;

procedure TfrmCrm_Project_Detail.edtOpenCheckGroupSelected(Sender: TObject; Index: Integer);
var i:integer;
var s1,s2:integer;
begin
  s1:=-1;
  s2:=-1;
  for i:=0 to edtOpen.Items.Count-1 do begin
    if       (edtOpen.Items[i].Value ='00') then s1:=i
    else if  (edtOpen.Items[i].Value ='99') then s2:=i;
  end;

  if (s1=Index) and (edtOpen.IsChecked[Index]) then begin
     for i:=0 to edtOpen.Items.Count-1 do begin
       if s1<>i then edtOpen.IsChecked[i] := false;
     end;
  end else
  if (s2=Index) and (edtOpen.IsChecked[Index]) then begin
     for i:=0 to edtOpen.Items.Count-1 do begin
       if s2<>i then edtOpen.IsChecked[i] := false;
     end;
  end else
  if (edtOpen.IsChecked[Index]) then begin
      edtOpen.IsChecked[s1] := false;
      edtOpen.IsChecked[s2] := false;
  end;
end;

initialization
   RegisterClasses([TfrmCrm_Project_Detail]);

finalization
   UnRegisterClasses([TfrmCrm_Project_Detail]);

end.


