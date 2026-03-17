 unit Crm_Marketing_Detail;

interface

uses
  System.IOUtils,
  System.DateUtils,
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
  FMX.TMSCheckGroupPicker, FMX.TMSRadioGroupPicker, FMX.Memo.Types, FMX.TMSMemo;

type
  TfrmCrm_Marketing_Detail = class(TForm)
    HeaderToolBar: TToolBar;
    Label_Title: TLabel;
    btnClose: TButton;
    btnQuery: TButton;
    Layout_Save: TLayout;
    btnDelete: TButton;
    btnSave: TButton;
    btnSaveAs: TButton;
    VertScrollBox1: TVertScrollBox;
    MainLayout1: TLayout;
    Label1: TLabel;
    Layout_BdInfo: TLayout;
    edtBd_YYYYMM: TEdit;
    edtBd_Code: TEdit;
    Label21: TLabel;
    edtBd_Name: TEdit;
    btnQuery_Bd: TTMSFMXSpeedButton;
    btnSelect_Bd: TTMSFMXSpeedButton;
    Layout_FileName: TLayout;
    Label3: TLabel;
    sbtFileName: TTMSFMXSpeedButton;
    Layout1: TLayout;
    Label17: TLabel;
    Layout11: TLayout;
    edtActDate_New: TDateEdit;
    edtActTime_Fr: TTimeEdit;
    Label26: TLabel;
    edtActTime_To: TTimeEdit;
    Text1: TText;
    Layout2: TLayout;
    edtEmpId: TEdit;
    edtEmpDept: TEdit;
    edtEmpCompany: TEdit;
    Label22: TLabel;
    Layout3: TLayout;
    edtCustCompany_Code: TEdit;
    lblCustCompany: TLabel;
    edtCustCompany: TEdit;
    Layout4: TLayout;
    Label19: TLabel;
    edtOpen_Code: TTMSFMXCheckGroupPicker;
    Layout5: TLayout;
    edtTitle: TEdit;
    edtCompany: TEdit;
    edtEmpNo: TEdit;
    edtSeq: TEdit;
    edtActDate_Old: TDateEdit;
    Label10: TLabel;
    Layout6: TLayout;
    edtProject_Code: TEdit;
    Label20: TLabel;
    edtProject: TEdit;
    btnQuery_Project: TTMSFMXSpeedButton;
    btnSelect_Project: TTMSFMXSpeedButton;
    Layout7: TLayout;
    edtCustName_Code: TEdit;
    Label23: TLabel;
    edtCustName: TEdit;
    btnQuery_Cust: TTMSFMXSpeedButton;
    btnSelect_Cust: TTMSFMXSpeedButton;
    Layout8: TLayout;
    Label18: TLabel;
    edtStep_Code: TTMSFMXRadioGroupPicker;
    Layout9: TLayout;
    Label2: TLabel;
    edtEmpId_Name: TEdit;
    edtuUserName: TEdit;
    edtiUserName: TEdit;
    edtFileName: TEdit;
    Panel1: TPanel;
    edtmemo: TMemo;

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
    procedure btnQuery_CustClick(Sender: TObject);
    procedure btnQuery_BdClick(Sender: TObject);
    procedure btnQuery_ProjectClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label23Click(Sender: TObject);
    procedure Label21Click(Sender: TObject);
    procedure Label20Click(Sender: TObject);
    procedure lblCustCompanyClick(Sender: TObject);
    procedure btnSaveAsClick(Sender: TObject);
    procedure btnSelect_CustClick(Sender: TObject);
    procedure btnSelect_BdClick(Sender: TObject);
    procedure btnSelect_ProjectClick(Sender: TObject);
    procedure edtOpen_CodeCheckGroupSelected(Sender: TObject; Index: Integer);
    procedure edtActTime_FrClosePicker(Sender: TObject);
    procedure edtActTime_ToClosePicker(Sender: TObject);
    procedure FormFocusChanged(Sender: TObject);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardShown(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
  private
    { Private declarations }
    FKBBounds: TRectF;
    FNeedOffset: Boolean;
    procedure CalcContentBoundsProc(Sender: TObject; var ContentBounds: TRectF);
    procedure RestorePosition;
    procedure UpdateKBBounds;

  public
    { Public declarations }
  end;

var
  frmCrm_Marketing_Detail: TfrmCrm_Marketing_Detail;
  l_Action: integer;
implementation

{$R *.fmx}

uses System.Math, FMX.Utils,Com_DataModule,Com_function,Com_Variable,MainMenu,
     Com_Select_Code, Crm_Customer_Detail, Crm_Project_Detail;

procedure TfrmCrm_Marketing_Detail.FormShow(Sender: TObject);
begin
  l_Action         := g_Sel_ActionKind;
  g_Sel_ActionKind := -1;
  p_SetComboBox(edtStep_Code,'MARKETING_STEP');
  p_SetChkCombo(edtOpen_Code,'MARKETING_OPEN');
  g_Data_Updated        := false;
  if l_Action = 0 then begin
     btnClearClick(Sender);
  end else
  if l_Action > 0 then begin
     edtCompany.Text         := g_Sel_TagString[0];
     edtEmpNo.Text           := g_Sel_TagString[1];
     edtActDate_Old.DateTime := f_StrToDate(g_Sel_TagString[2]);
     edtActDate_New.DateTime := f_StrToDate(g_Sel_TagString[2]);
     edtSeq.Text             := g_Sel_TagString[3];
     btnQueryClick(Sender);
  end;
end;


procedure TfrmCrm_Marketing_Detail.btnCloseClick(Sender: TObject);
begin
  edtOpen_Code.Free;
  edtStep_Code.Free;
  Close;
{ g_Data_Updated  := false;
  Close;}
end;



procedure TfrmCrm_Marketing_Detail.btnClearClick(Sender: TObject);
var Hour,Min,Sec,MSec:Word;
begin

  DecodeTime(Now,Hour,Min,Sec,MSec);

  Layout_Save.Visible      := true;
  btnQuery.Visible         := false;
  btnSaveAs.Visible        := false;
  btnSave.Visible          := true;
  btnDelete.Visible        := false;

  edtCompany.Text          := g_User_Company;
  edtEmpNo.Text            := g_User_EmpNo;
  edtActDate_Old.DateTime  := Now;
  edtActDate_New.DateTime  := Now;
  edtSeq.Text              := '';
  edtTitle.Text            := '업무일정';

  edtActTime_Fr.DateTime   := Int(Now)+EncodeTime(Hour,0,0,0);
  edtActTime_To.DateTime   := IncHour(edtActTime_Fr.DateTime,2);

  if Int(edtActTime_Fr.DateTime) <> Int(edtActTime_To.DateTime) then begin
     edtActTime_To.DateTime := Int(edtActTime_Fr.DateTime)+EncodeTime(23,29,0,0);
  end;


  if  edtActTime_Fr.DateTime >= edtActTime_To.DateTime then begin
      edtActTime_To.DateTime := edtActTime_Fr.DateTime;
  end;

//edtStep.ItemIndex        := 0;
  edtStep_Code.ItemIndex   := 0;
  p_iniChkCombo(edtOpen_Code);
  p_GetChkCombo(edtOpen_Code,'11,20'); //부서원,상위부서장

  edtiUserName.Text        := '';
  edtuUserName.Text        := '';

  edtFileName.Text         := '';
  Layout_FileName.Visible  := false;

  btnQuery_Cust.Visible     := false;
  btnQuery_Project.Visible  := false;
  btnQuery_Bd.Visible       := false;

  btnSelect_Cust.Visible    := false;
  btnSelect_Project.Visible := false;
  btnSelect_Bd.Visible      := false;

end;

procedure TfrmCrm_Marketing_Detail.btnSaveAsClick(Sender: TObject);
begin
  l_Action                 := 0;
  btnClearClick(Sender);
  edtTitle.Text            := '(복사)'+edtTitle.Text;
end;

procedure TfrmCrm_Marketing_Detail.btnQueryClick(Sender: TObject);
begin

  Layout_Save.Visible      := false;
  btnQuery.Visible         := false;
  btnSaveAs.Visible        := false;
  btnSave.Visible          := false;
  btnDelete.Visible        := false;

  with frmCom_DataModule.ClientDataSet_Proc do begin
    try
      p_CreatePrams;
      ParamByName('arg_ModCd' ).AsString := 'CRM_Marketing_Detail02';//'CRM_Marketing_Detail';
      ParamByName('arg_Text01').AsString := edtCompany.Text;
      ParamByName('arg_Text02').AsString := edtEmpNo.Text;
      ParamByName('arg_Text03').AsString := FormatDateTime('YYYYMMDD',edtActDate_Old.DateTime);
      ParamByName('arg_Text04').AsString := FormatDateTime('YYYYMMDD',edtActDate_New.DateTime);
      ParamByName('arg_Text05').AsString := edtSeq.Text;
      Open;
      if RecordCount=1 then begin

         edtCompany.Text          := FieldByName('Company'         ).AsString;
         edtEmpNo.Text            := FieldByName('EmpNo'           ).AsString;
         edtActDate_Old.DateTime  := FieldByName('ACTDATE_FR'      ).AsDateTime;
         edtActDate_New.DateTime  := FieldByName('ACTDATE_TO'      ).AsDateTime;
         edtSeq.Text              := FieldByName('Seq'             ).AsString;

         edtActTime_Fr.DateTime   := FieldByName('ACTTIME_FR'      ).AsDateTime;
         edtActTime_TO.DateTime   := FieldByName('ACTTIME_TO'      ).AsDateTime;

         edtCustCompany.Text      := FieldByName('CustCompany'     ).AsString;
         edtCustName.Text         := FieldByName('CustName'        ).AsString;
         edtMemo.Text             := FieldByName('Memo'            ).AsString;
         edtCustCompany_Code.Text := FieldByName('CustCompany_code').AsString;
         edtCustName_Code.Text    := FieldByName('CustName_Code'   ).AsString;
         edtProject.Text          := FieldByName('Project'         ).AsString;
         edtProject_Code.Text     := FieldByName('Project_Code'    ).AsString;

         p_GetComboBox(edtStep_Code, FieldByName('Step_Code'       ).AsString);
         p_GetChkCombo(edtOpen_Code, FieldByName('Open_Code'       ).AsString);

         edtTitle.Text            := FieldByName('Title'           ).AsString;
         edtEmpCompany.Text       := FieldByName('EmpCompany'      ).AsString;
         edtEmpDept.Text          := FieldByName('EmpDept'         ).AsString;
         edtEmpID.Text            := FieldByName('EmpID'           ).AsString;
         edtEmpID_Name.Text       := FieldByName('EmpID_Name'      ).AsString;
         edtBd_Code.Text          := FieldByName('BD_CODE'         ).AsString;
         edtBd_Name.Text          := FieldByName('BD_NAME'         ).AsString;
         edtBd_YYYYMM.Text        := FieldByName('BD_YYYYMM'       ).AsString;
         edtCustName_Code.Text    := FieldByName('CustName_Code'   ).AsString;

         edtFileName.Text         := FieldByName('FileName'        ).AsString;
         Layout_FileName.Visible  := FieldByName('FileSelect'      ).AsInteger=1;

         edtiUserName.Text        := FieldByName('iUserName'       ).AsString;
         edtuUserName.Text        := FieldByName('uUserName'       ).AsString;

         btnSave.Visible          := FieldByName('CAN_UPDATE'      ).AsInteger=1;
         btnDelete.Visible        := FieldByName('CAN_DELETE'      ).AsInteger=1;
         Layout_Save.Visible      :=(btnSave.Visible) or (btnDelete.Visible);
         btnSaveAs.Visible        := Layout_Save.Visible;
         btnQuery.Visible         := Layout_Save.Visible;

//         btnQuery_Cust.Visible    := edtCustName_Code.Text<>'';
//         btnQuery_Project.Visible := edtProject_Code.Text<>'';
//         btnQuery_Bd.Visible      := edtBd_Code.Text<>'';

        if (g_User_EmpNo <> edtEmpNo.text) and (FieldByName('CAN_UPDATE'      ).AsInteger=1) then begin
           edtMemo.Text := edtMemo.Text + #13#10+#13#10+ '└ '+ g_User_EmpName+' : ';
           edtMemo.GoToTextEnd;
           edtMemo.SetFocus;
        end;

      end
      else ShowMessage('해당데이타없습니다.');
    finally
      Close;
    end;
  end;
end;

procedure TfrmCrm_Marketing_Detail.btnSaveClick(Sender: TObject);
begin
//edtStep_Code.ItemIndex := edtStep.ItemIndex;
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
               then ParamByName('arg_ModCd' ).AsString := 'Crm_Marketing_Insert'
               else ParamByName('arg_ModCd' ).AsString := 'Crm_Marketing_Update';

            ParamByName('arg_Text01').AsString := edtCompany.Text;
            ParamByName('arg_Text02').AsString := edtEmpNo.Text;
            ParamByName('arg_Text03').AsString := FormatDateTime('YYYYMMDD',edtActDate_Old.DateTime);
            ParamByName('arg_Text04').AsString := FormatDateTime('YYYYMMDD',edtActDate_New.DateTime);
            ParamByName('arg_Text05').AsString := edtSeq.Text;

            ParamByName('arg_Text06').AsString := FormatDateTime('HHNN',edtActTime_Fr.Time)+FormatDateTime('HHNN',edtActTime_To.Time);
            ParamByName('arg_Text07').AsString := edtCustCompany.Text;
            ParamByName('arg_Text08').AsString := edtCustName.Text;
            ParamByName('arg_Text09').AsString := edtMemo.Text;
            ParamByName('arg_Text10').AsString := '';//컬럼실수로 추가...
            ParamByName('arg_Text11').AsString := edtCustCompany_Code.Text;
            ParamByName('arg_Text12').AsString := edtCustName_Code.Text;
            ParamByName('arg_Text13').AsString := edtProject.Text;
            ParamByName('arg_Text14').AsString := edtProject_Code.Text;

            ParamByName('arg_Text15').AsString := edtStep_Code.Items[edtStep_Code.ItemIndex].Text;
            ParamByName('arg_Text16').AsString := edtStep_Code.Items[edtStep_Code.ItemIndex].Value;

            ParamByName('arg_Text17').AsString := f_GetChkCombo(edtOpen_Code,false);//edtOpen.Text;
            ParamByName('arg_Text18').AsString := f_GetChkCombo(edtOpen_Code,true );//edtOpen_Code.Text;

            ParamByName('arg_Text19').AsString := Trim(edtTitle.     Text);
            ParamByName('arg_Text20').AsString := Trim(edtEmpCompany.Text);
            ParamByName('arg_Text21').AsString := Trim(edtEmpDept.   Text);
            ParamByName('arg_Text22').AsString := Trim(edtEmpID.     Text);
            ParamByName('arg_Text23').AsString := Trim(edtEmpID_Name.Text);
            ParamByName('arg_Text24').AsString := Trim(edtBD_Code.Text);
            ParamByName('arg_Text25').AsString := Trim(edtBD_Name.Text);
            ParamByName('arg_Text26').AsString := Trim(edtFileName.Text);
            Open;
            if RecordCount=1 then begin
               P_Toast('저장완료');
               g_Data_Updated          := true;
               l_Action                := 1;

               edtCompany.Text         := FieldByName('COMPANY'    ).AsString;
               edtEmpNo.Text           := FieldByName('EMPNO'      ).AsString;
               edtActDate_Old.DateTime := FieldByName('ACTDATE'    ).AsDateTime;
               edtActDate_New.DateTime := FieldByName('ACTDATE'    ).AsDateTime;
               edtSeq.Text             := FieldByName('Seq'        ).AsString;

               Layout_Save.Visible     := true;
               btnQuery.Visible        := true;
               btnSaveAs.Visible       := true;
               btnSave.Visible         := true;
               //btnDelete.Visible       := true;

//               btnQuery_Cust.Visible    := edtCustName_Code.Text<>'';
//               btnQuery_Project.Visible := edtProject_Code.Text<>'';
//               btnQuery_Bd.Visible       := edtBd_Code.Text<>'';

               frmMainMenu.Com_Marketing_ScheduleExecute;
            end;
          finally
            Close;
          end;
        end;
      end;
    end;
  end);
end;


procedure TfrmCrm_Marketing_Detail.btnDeleteClick(Sender: TObject);
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
                  ParamByName('arg_ModCd' ).AsString := 'Crm_Marketing_Delete';
                  ParamByName('arg_Text01').AsString := edtCompany.Text;
                  ParamByName('arg_Text02').AsString := edtEmpNo.Text;
                  ParamByName('arg_Text03').AsString := FormatDateTime('YYYYMMDD',edtActDate_Old.DateTime);
                  ParamByName('arg_Text04').AsString := FormatDateTime('YYYYMMDD',edtActDate_New.DateTime);
                  ParamByName('arg_Text05').AsString := edtSeq.Text;
                  Open;
                  if FieldByName('CNT').AsInteger=0 then begin
                     P_Toast('삭제완료');
                     g_Data_Updated          := true;
                     l_Action                := 0;
                     edtSeq.Text             := '';
                     Layout_Save.Visible     := true;
                     btnQuery.Visible        := false;
                     btnSaveAs.Visible       := false;
                     btnSave.Visible         := true;
                     btnDelete.Visible       := false;

                     btnQuery_Cust.Visible   := false;
                     btnQuery_Project.Visible:= false;
                     btnQuery_Bd.Visible     := false;

                  end;
                finally
                  Close;
                end;
              end;
      btnCloseClick(Sender);
      frmMainMenu.Com_Marketing_ScheduleExecute;
      end;
    end;
  end);
end;





procedure TfrmCrm_Marketing_Detail.btnCancelClick(Sender: TObject);
begin
  Close;
end;



procedure TfrmCrm_Marketing_Detail.FormActivate(Sender: TObject);
begin
  if (g_Sel_Code='') and (g_Sel_CodeName1='') and (g_Sel_CodeName2='') then Exit;
  if g_Sel_GUBUN = 'CUSTOMER_CODE' then begin
     edtCustName.Text      := g_Sel_CodeName1;
     edtCustName_Code.Text := g_Sel_Code;
//   btnQuery_Cust.Visible := edtCustName_Code.Text<>'';
  end else
  if g_Sel_GUBUN = 'PROJECT_CODE' then begin
     edtProject.Text       := g_Sel_CodeName1;
     edtProject_Code.Text  := g_Sel_Code;
//   btnQuery_Project.Visible := edtProject_Code.Text<>'';
  end else
  if g_Sel_GUBUN = 'BUILDING_CODE' then begin
     edtBd_Name.Text       := g_Sel_CodeName1;
     edtBd_Code.Text       := g_Sel_Code;
//   btnQuery_Bd.Visible   := edtBd_Code.Text<>'';
  end;
  g_Sel_CodeName1 := '';
  g_Sel_CodeName2 := '';
  g_Sel_Code      := '';
end;

procedure TfrmCrm_Marketing_Detail.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Hide; //
  Action := TCloseAction.caFree;
  frmCrm_Marketing_Detail := nil; //
end;








procedure TfrmCrm_Marketing_Detail.MenuButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCrm_Marketing_Detail.btnQuery_BdClick(Sender: TObject);
begin
  g_Sel_ActionKind := 1;
  g_Sel_Title      := '대상빌딩정보';
  if (edtBd_YYYYMM.Text='') or (edtBd_Code.Text='') then Exit;
  g_Sel_Text01 := edtBd_YYYYMM.Text;
  g_Sel_Text02 := edtBd_Code.Text;
  p_ActExecute(frmMainMenu.Rch_Building_List01);
end;

procedure TfrmCrm_Marketing_Detail.btnSelect_BdClick(Sender: TObject);
begin
  g_Sel_Title    := '빌딩선택';
  g_Sel_GUBUN   := 'BUILDING_CODE';
  g_Sel_Text01   := ' 빌딩명/주소';
  if      Trim(edtBD_NAME.Text)=''
    then g_Sel_Text02 := edtProject.Text
    else g_Sel_Text02 := edtBD_NAME.Text;

//g_Sel_Text02   := edtBD_NAME.Text;//edtCustName_Code.Text;
  g_Sel_Text03   := '';//edtCustCompany.Text;
  g_Sel_Text04   := '';
  g_Sel_Text05   := '';
  Application.CreateForm(TfrmCom_Select_Code,frmCom_Select_Code);
  frmCom_Select_Code.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
end;

procedure TfrmCrm_Marketing_Detail.btnSelect_CustClick(Sender: TObject);
begin
  g_Sel_Title    := '고객선택';
  g_Sel_GUBUN   := 'CUSTOMER_CODE';
  g_Sel_Text01   := ' 회사명/성명';
  if      Trim(edtCustName.Text)=''
    then g_Sel_Text02 := edtCustCompany.Text
    else g_Sel_Text02 := edtCustName.Text;
  g_Sel_Text03   := '';//edtCustCompany.Text;
  g_Sel_Text04   := '';
  g_Sel_Text05   := '';
  Application.CreateForm(TfrmCom_Select_Code,frmCom_Select_Code);
  frmCom_Select_Code.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
end;


procedure TfrmCrm_Marketing_Detail.btnSelect_ProjectClick(Sender: TObject);
begin
  g_Sel_Title    := '프로젝트선택';
  g_Sel_GUBUN    := 'PROJECT_CODE';
  g_Sel_Text01   := ' 프로젝트명/고객사';
  if      Trim(edtProject.Text)=''
    then g_Sel_Text02 := edtBd_Name.Text
    else g_Sel_Text02 := edtProject.Text;
  g_Sel_Text02   := edtPROJECT.Text;//edtCustName_Code.Text;
  g_Sel_Text03   := '';//edtCustCompany.Text;
  g_Sel_Text04   := '';
  g_Sel_Text05   := '';
  Application.CreateForm(TfrmCom_Select_Code,frmCom_Select_Code);
  frmCom_Select_Code.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
end;




procedure TfrmCrm_Marketing_Detail.btnQuery_CustClick(Sender: TObject);
begin
  if edtCustName_Code.Text <> '' then begin
    try
      g_Sel_Title := '고객정보';
      g_Sel_TagString.Clear;
    finally
      ExtractStrings([':'],[#0],PChar(edtCustName_Code.Text),g_Sel_TagString);
    end;
    Application.CreateForm(TfrmCrm_Customer_Detail,frmCrm_Customer_Detail);
    frmCrm_Customer_Detail.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
  end;
end;

procedure TfrmCrm_Marketing_Detail.btnQuery_ProjectClick(Sender: TObject);
begin
  g_Sel_ActionKind := 1;
  g_Sel_Title      := '프로젝트정보';
  g_Sel_TagString.Clear;
  g_Sel_TagString.CommaText := edtCompany.Text+','+edtProject_Code.Text;
  Application.CreateForm(TfrmCrm_Project_Detail,frmCrm_Project_Detail);
  frmCrm_Project_Detail.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
end;

procedure TfrmCrm_Marketing_Detail.Label20Click(Sender: TObject);
begin
  edtProject.Text      := '';
  edtProject_Code.Text := '';
end;

procedure TfrmCrm_Marketing_Detail.Label21Click(Sender: TObject);
begin
  edtBd_Code.Text      := '';
  edtBd_Name.Text      := '';
end;

procedure TfrmCrm_Marketing_Detail.Label23Click(Sender: TObject);
begin
  edtCustName.Text      := '';
  edtCustName_Code.Text := '';
end;

procedure TfrmCrm_Marketing_Detail.lblCustCompanyClick(Sender: TObject);
begin
  edtCustCompany.Text      := '';
  edtCustCompany_Code.Text := '';
  lblCustCompany.ShowHint  := true;
end;

procedure TfrmCrm_Marketing_Detail.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
var FService: IFMXVirtualKeyboardService;
begin
  if (Key = vkHardwareBack) then begin
    TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, IInterface(FService));
    if (FService <> nil) and (TVirtualKeyboardState.Visible in FService.VirtualKeyBoardState) then begin
    //  Layout_Body.Align := Fmx.Types.TAlignLayout.Client;
    end
    else begin
      Key := 0;
      Self.Close;
    end;
  end;
end;


procedure TfrmCrm_Marketing_Detail.edtActTime_FrClosePicker(Sender: TObject);
begin
  if edtActTime_Fr.DateTime >= edtActTime_To.DateTime then begin
     edtActTime_To.DateTime := IncHour(edtActTime_Fr.DateTime,2);
  end;
  if Int(edtActTime_Fr.DateTime) <> Int(edtActTime_To.DateTime) then begin
     edtActTime_To.DateTime := Int(edtActTime_Fr.DateTime)+EncodeTime(23,29,0,0);
  end;

end;

procedure TfrmCrm_Marketing_Detail.edtActTime_ToClosePicker(Sender: TObject);
begin
  if edtActTime_Fr.DateTime >= edtActTime_To.DateTime then begin
     edtActTime_Fr.DateTime := IncHour(edtActTime_To.DateTime,-2);
  end;
  if Int(edtActTime_Fr.DateTime) <> Int(edtActTime_To.DateTime) then begin
     edtActTime_To.DateTime := Int(edtActTime_To.DateTime)+EncodeTime(00,01,0,0);
  end;
end;

procedure TfrmCrm_Marketing_Detail.edtOpen_CodeCheckGroupSelected(Sender: TObject; Index: Integer);
var i:integer;
var s1,s2:integer;
begin
  s1:=-1;
  s2:=-1;
  for i:=0 to edtOpen_Code.Items.Count-1 do begin
    if      (edtOpen_Code.Items[i].Value ='00') then s1:=i
    else if (edtOpen_Code.Items[i].Value ='99') then s2:=i;
  end;

  if (s1=Index) and (edtOpen_Code.IsChecked[Index]) then begin
     for i:=0 to edtOpen_Code.Items.Count-1 do begin
       if s1<>i then edtOpen_Code.IsChecked[i] := false;
     end;
  end else
  if (s2=Index) and (edtOpen_Code.IsChecked[Index]) then begin
     for i:=0 to edtOpen_Code.Items.Count-1 do begin
       if s2<>i then edtOpen_Code.IsChecked[i] := false;
     end;
  end else
  if (edtOpen_Code.IsChecked[Index]) then begin
      edtOpen_Code.IsChecked[s1] := false;
      edtOpen_Code.IsChecked[s2] := false;
  end;

end;

procedure TfrmCrm_Marketing_Detail.FormCreate(Sender: TObject);
begin
  VKAutoShowMode := TVKAutoShowMode.Always;
  VertScrollBox1.OnCalcContentBounds := CalcContentBoundsProc;
  g_Sel_CodeName1 := '';
  g_Sel_CodeName2 := '';
  g_Sel_Code      := '';
end;



procedure TfrmCrm_Marketing_Detail.FormVirtualKeyboardHidden(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  FKBBounds.Create(0, 0, 0, 0);
  FNeedOffset := False;
  RestorePosition;
end;

procedure TfrmCrm_Marketing_Detail.FormVirtualKeyboardShown(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  FKBBounds := TRectF.Create(Bounds);
  FKBBounds.TopLeft := ScreenToClient(FKBBounds.TopLeft);
  FKBBounds.BottomRight := ScreenToClient(FKBBounds.BottomRight);
  UpdateKBBounds;
end;

procedure TfrmCrm_Marketing_Detail.FormFocusChanged(Sender: TObject);
begin
  UpdateKBBounds;
end;

procedure TfrmCrm_Marketing_Detail.CalcContentBoundsProc(Sender: TObject; var ContentBounds: TRectF);
begin
  if FNeedOffset and (FKBBounds.Top > 0) then begin
     ContentBounds.Bottom := Max(ContentBounds.Bottom,2 * ClientHeight - FKBBounds.Top);
  end;
end;
procedure TfrmCrm_Marketing_Detail.RestorePosition;
begin
  VertScrollBox1.ViewportPosition := PointF(VertScrollBox1.ViewportPosition.X, 0);
  MainLayout1.Align := TAlignLayout.Client;
  VertScrollBox1.RealignContent;
end;

procedure TfrmCrm_Marketing_Detail.UpdateKBBounds;
var
  LFocused : TControl;
  LFocusRect: TRectF;
begin
  FNeedOffset := False;
  if Assigned(Focused) then begin
    LFocused := TControl(Focused.GetObject);
    LFocusRect := LFocused.AbsoluteRect;
    LFocusRect.Offset(VertScrollBox1.ViewportPosition);
    if (LFocusRect.IntersectsWith(TRectF.Create(FKBBounds))) and
       (LFocusRect.Bottom > FKBBounds.Top) then begin
      FNeedOffset := True;
      MainLayout1.Align := TAlignLayout.Horizontal;
      VertScrollBox1.RealignContent;
      Application.ProcessMessages;
      VertScrollBox1.ViewportPosition := PointF(VertScrollBox1.ViewportPosition.X,
                                                LFocusRect.Bottom - FKBBounds.Top);
    end;
  end;
  if not FNeedOffset then RestorePosition;
end;

initialization
   RegisterClasses([TfrmCrm_Marketing_Detail]);

finalization
   UnRegisterClasses([TfrmCrm_Marketing_Detail]);

end.



