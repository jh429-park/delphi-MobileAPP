 unit Crm_Project_Detail;

interface

uses
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
  FMX.TMSCustomButton, FMX.TMSSpeedButton, FMX.Edit, FMX.Layouts, FMX.Objects;

type
  TfrmCrm_Project_Detail = class(TForm)
    HeaderToolBar: TToolBar;
    Label_Title: TLabel;
    btnClose: TButton;
    btnQuery: TButton;
    Rectangle1: TRectangle;
    Layout_Save: TLayout;
    btnDelete: TButton;
    btnSave: TButton;
    btnSaveAs: TButton;
    Layout_Body: TLayout;
    Layout_Label: TLayout;
    Label10: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label21: TLabel;
    Label23: TLabel;
    lblCustCompany: TLabel;
    Layout_Edit: TLayout;
    Layout7: TLayout;
    edtCust: TEdit;
    Image_Customer: TTMSFMXSpeedButton;
    edtCust_Code: TEdit;
    Layout_BdInfo: TLayout;
    edtBd_YYYYMM: TEdit;
    Image_Bdinfo: TTMSFMXSpeedButton;
    edtBdName: TEdit;
    edtBdCode: TEdit;
    Layout6: TLayout;
    edtProject_Code: TEdit;
    Layout4: TLayout;
    edtOpen: TComboBox;
    edtOpen_Name: TComboBox;
    Layout8: TLayout;
    edtStep: TComboBox;
    edtStep_Name: TComboBox;
    Layout3: TLayout;
    edtCustCompany: TEdit;
    edtCustCompany_Code: TEdit;
    Image_CustCompany: TTMSFMXSpeedButton;
    Layout1: TLayout;
    edtiUserName: TEdit;
    edtiDateTime: TEdit;
    edtMemo: TMemo;
    Label1: TLabel;
    edtProject: TEdit;
    Layout2: TLayout;
    edtHomePage: TEdit;
    TMSFMXSpeedButton1: TTMSFMXSpeedButton;
    Label2: TLabel;
    edtCompany: TEdit;
    Layout5: TLayout;
    edtKeyMan: TEdit;
    edtKeyMan_Code: TEdit;
    TMSFMXSpeedButton2: TTMSFMXSpeedButton;
    Label3: TLabel;
    procedure btnClearClick(Sender: TObject);
    procedure btnQueryClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MenuButtonClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnSaveAsClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure Image_CustCompanyChange(Sender: TObject);
    procedure Image_CustomerChange(Sender: TObject);
    procedure Image_BdinfoChange(Sender: TObject);
    procedure Image_CustCompanyClick(Sender: TObject);
    procedure Image_BdinfoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCrm_Project_Detail: TfrmCrm_Project_Detail;
implementation

{$R *.fmx}

uses System.Math, FMX.Utils,Com_DataModule,Com_function,Com_Variable,MainMenu;

procedure TfrmCrm_Project_Detail.FormShow(Sender: TObject);
begin
  p_SetComCode(edtStep,edtStep_Name,'0000000','PROJECT_STEP',true,false);
  p_SetComCode(edtOpen,edtOpen_Name,'0000000','PROJECT_OPEN',true,false);
  p_ComboBox_FontSize (edtStep_Name,edtBdName.Font.Size);
  p_ComboBox_FontSize (edtStep_Name,edtBdName.Font.Size);

  g_Data_Updated        := false;
  if g_Sel_ActionKind = 0 then begin
     btnClearClick(Sender);
  end else
  if g_Sel_ActionKind > 0 then begin
     edtCompany.Text         := g_Sel_TagString[0];
     edtProject_Code.Text    := g_Sel_TagString[1];
     btnQueryClick(Sender);
  end;
end;

procedure TfrmCrm_Project_Detail.btnClearClick(Sender: TObject);
begin
  Layout_Save.Visible      := true;
  btnQuery.Visible         := false;
  btnSaveAs.Visible        := false;
  btnSave.Visible          := true;
  btnDelete.Visible        := false;

  edtCompany.Text          := g_User_Company;
  edtOpen.ItemIndex        := 0;
  edtStep.ItemIndex        := 0;
  edtiUserName.Text        := '';
  edtiDateTime.Text        := '';
end;


procedure TfrmCrm_Project_Detail.Image_BdinfoChange(Sender: TObject);
begin
//
end;

procedure TfrmCrm_Project_Detail.Image_BdinfoClick(Sender: TObject);
begin
//
end;

procedure TfrmCrm_Project_Detail.Image_CustCompanyChange(Sender: TObject);
begin
//
end;

procedure TfrmCrm_Project_Detail.Image_CustCompanyClick(Sender: TObject);
begin
//
end;

procedure TfrmCrm_Project_Detail.Image_CustomerChange(Sender: TObject);
begin
//
end;

procedure TfrmCrm_Project_Detail.btnQueryClick(Sender: TObject);
begin
  Layout_Save.Visible      := false;
  btnQuery.Visible         := false;
  btnSaveAs.Visible        := false;
  btnSave.Visible          := false;
  btnDelete.Visible        := false;

  with frmCom_DataModule.ClientDataSet_Proc do begin
    try
      p_CreatePrams;
      ParamByName('arg_ModCd' ).AsString := 'Crm_Project_Detail';
      ParamByName('arg_Text01').AsString := edtCompany.Text;
      ParamByName('arg_Text02').AsString := edtProject_Code.Text;
      Open;
      if RecordCount=1 then begin
         edtCompany.Text          := FieldByName('Company'         ).AsString;
         edtProject.Text          := FieldByName('Project'         ).AsString;
         edtProject_Code.Text     := FieldByName('Project_Code'    ).AsString;
         edtCustCompany.Text      := FieldByName('CustCompany'     ).AsString;
         edtCustCompany_Code.Text := FieldByName('CustCompany_Code').AsString;
         edtCust.Text             := FieldByName('Cust'            ).AsString;
         edtCust_Code.Text        := FieldByName('Cust_Code'       ).AsString;
         edtMemo.Text             := FieldByName('Memo'            ).AsString;

         edtStep_Name.ItemIndex   := edtStep.Items.IndexOf(FieldByName('Step').AsString);
         edtStep.ItemIndex        := edtStep.Items.IndexOf(FieldByName('Step').AsString);
         edtOpen_Name.ItemIndex   := edtOpen.Items.IndexOf(FieldByName('Open').AsString);
         edtOpen.ItemIndex        := edtOpen.Items.IndexOf(FieldByName('Open').AsString);


         edtBdCode.Text           := FieldByName('BDCODE'           ).AsString;
         edtBdName.Text           := FieldByName('BDNAME'           ).AsString;

         edtiUserName.Text        := FieldByName('iUserName'        ).AsString;
         edtiDateTime.Text        := FieldByName('iDateTime'        ).AsString;

         btnSave.Visible          := FieldByName('CAN_UPDATE'       ).AsInteger=1;
         btnDelete.Visible        := FieldByName('CAN_DELETE'       ).AsInteger=1;
         Layout_Save.Visible      :=(btnSave.Visible) or (btnDelete.Visible);
         btnSaveAs.Visible        := Layout_Save.Visible;
         btnQuery.Visible         := Layout_Save.Visible;

      end
      else ShowMessage('해당데이타없습니다.');
    finally
      Close;
    end;
  end;
end;

procedure TfrmCrm_Project_Detail.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCrm_Project_Detail.btnDeleteClick(Sender: TObject);
begin
//
end;

procedure TfrmCrm_Project_Detail.btnSaveAsClick(Sender: TObject);
begin
//
end;

procedure TfrmCrm_Project_Detail.btnSaveClick(Sender: TObject);
begin
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
            if g_Sel_ActionKind = 0
               then ParamByName('arg_ModCd' ).AsString := 'Crm_Project_Insert'
               else ParamByName('arg_ModCd' ).AsString := 'Crm_Project_Update';

            ParamByName('arg_Text01').AsString := edtCompany.Text;
            ParamByName('arg_Text02').AsString := edtProject_Code.Text;
            ParamByName('arg_Text03').AsString := edtCustCompany_Code.Text;
            ParamByName('arg_Text04').AsString := edtCust_Code.Text;
            ParamByName('arg_Text05').AsString := edtKeyMan_Code.Text;

            ParamByName('arg_Text06').AsString := edtProject.Text;
            ParamByName('arg_Text07').AsString := edtCustCompany.Text;
            ParamByName('arg_Text08').AsString := edtCust.Text;
            ParamByName('arg_Text09').AsString := edtKeyMan.Text;

            ParamByName('arg_Text10').AsString := edtStep.Items[edtStep.ItemIndex];
            ParamByName('arg_Text11').AsString := edtOpen.Items[edtOpen.ItemIndex];

            ParamByName('arg_Text12').AsString := ''; //empno
            ParamByName('arg_Text13').AsString := ''; //deptcode
            ParamByName('arg_Text14').AsString := ''; //empname
            ParamByName('arg_Text15').AsString := ''; //deptname

            ParamByName('arg_Text16').AsString := Trim(edtBDCode.Text);
            ParamByName('arg_Text17').AsString := Trim(edtBDName.Text);
            ParamByName('arg_Text18').AsString := Trim(edtHomePage.Text);
            ParamByName('arg_Text19').AsString := edtMemo.Text;

            Open;
            if RecordCount=1 then begin
               P_Toast('저장완료');
               g_Data_Updated          := true;
               g_Sel_ActionKind        := 1;
               edtCompany.Text         := FieldByName('COMPANY'     ).AsString;
               edtProject_Code.Text    := FieldByName('PROJECT_CODE').AsString;
               Layout_Save.Visible     := true;
               btnQuery.Visible        := true;
               btnSaveAs.Visible       := true;
               btnSave.Visible         := true;
               btnDelete.Visible       := true;

            end;
          finally
            Close;
          end;
        end;
      end;
    end;
  end);
end;

procedure TfrmCrm_Project_Detail.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;




procedure TfrmCrm_Project_Detail.MenuButtonClick(Sender: TObject);
begin
  Close;
end;

initialization
   RegisterClasses([TfrmCrm_Project_Detail]);

finalization
   UnRegisterClasses([TfrmCrm_Project_Detail]);

end.


