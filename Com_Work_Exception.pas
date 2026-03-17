 unit Com_Work_Exception;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.DialogService,
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
  FMX.Gestures, FMX.ScrollBox, FMX.Memo, FMX.Edit, FMX.DateTimeCtrls;

type
  TfrmCom_Work_Exception = class(TForm)
    HeaderToolBar: TToolBar;
    Label_Title: TLabel;
    Layout_Combo: TLayout;
    Layout_Detail: TLayout;
    Layout3: TLayout;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label9: TLabel;
    Layout_Data: TLayout;
    Layout4: TLayout;
    edtDateFr: TDateEdit;
    edtTimeFr: TTimeEdit;
    Layout5: TLayout;
    edtDateTo: TDateEdit;
    edtTimeTo: TTimeEdit;
    Layout_Ok: TLayout;
    Button_Save: TButton;
    cboCompany: TComboBox;
    Layout1: TLayout;
    edtNo_Emp: TEdit;
    Label11: TLabel;
    Label12: TLabel;
    edtNm_Kor: TEdit;
    edtMemo: TEdit;
    Text_Key: TText;
    btnClose: TButton;

    procedure p_ClearData(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MenuButtonClick(Sender: TObject);
    procedure Button_SaveClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCom_Work_Exception: TfrmCom_Work_Exception;

implementation

{$R *.fmx}

uses System.Math, FMX.Utils,Com_DataModule,Com_function,Com_Variable,MainMenu;

procedure TfrmCom_Work_Exception.FormShow(Sender: TObject);
var i:integer;
begin
  Label_Title.Text       := g_Sel_Title;
  p_ClearData(Sender);
  cboCompany.Items.Clear;
  for i:=0 to High(c_Company0) do begin
    cboCompany.Items.AddPair(c_Company0Name[i],c_Company0[i]);
  end;
  if cboCompany.Items.Count>0 then begin
    cboCompany.ItemIndex := 0;
  end;
//btnQueryClick(Sender);
end;


procedure TfrmCom_Work_Exception.p_ClearData(Sender: TObject);
begin
  Button_Save.Visible    := true;
  Button_Save.Enabled    := true;
  cboCompany.ItemIndex   := -1;
  edtNo_Emp.Text         := '';
  edtNm_Kor.Text         := '';
  edtDateFr.DateTime     := Now;
  edtDateTo.DateTime     := Now;
  edtTimeFr.Time         := Now;
  edtTimeTo.Time         := Now;
  edtMemo.Text           := g_User_EmpName;
end;


procedure TfrmCom_Work_Exception.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCom_Work_Exception.Button_SaveClick(Sender: TObject);
begin

  Text_Key.Text := cboCompany.Items.ValueFromIndex[cboCompany.ItemIndex]
                  +' : '+edtNo_Emp.Text
                  +' : '+FormatDateTime('YYYYMMDD',edtDateFr.Date)
                  +' : '+FormatDateTime('YYYYMMDD',edtDateTo.Date)
                  +' : '+FormatDateTime('HHNNSS',  edtTimeFr.Time)
                  +' : '+FormatDateTime('HHNNSS',  edtTimeTo.Time);

  if cboCompany.ItemIndex<0 then Exit;
  if edtNo_Emp.Text = ''    then Exit;
  if edtDateFr.Date>edtDateTo.Date then Exit;
  if edtTimeFr.Time>edtTimeTo.Time then Exit;

  TDialogService.MessageDialog(('입력하시겠습니까?'),
  system.UITypes.TMsgDlgType.mtInformation,
 [system.UITypes.TMsgDlgBtn.mbYes, system.UITypes.TMsgDlgBtn.mbCancel], system.UITypes.TMsgDlgBtn.mbYes,0,
  procedure (const AResult: System.UITypes.TModalResult)
  begin

//  MessageDlg('입력하시겠습니까?',  System.UITypes.TMsgDlgType.mtInformation
// ,[System.UITypes.TMsgDlgBtn.mbYes,System.UITypes.TMsgDlgBtn.mbCancel],0
// ,procedure(const AResult: TModalResult)
//  begin
    case AResult of
      mrYes: begin
               g_Data_Updated := true;
               with frmCom_DataModule.ClientDataSet_Proc do begin
                 try
                    p_CreatePrams;
                    ParamByName('arg_ModCd'  ).AsString := 'INSERT_SARAM_EMP_WORKINFO';
                    ParamByName('arg_TEXT01' ).AsString := cboCompany.Items.ValueFromIndex[cboCompany.ItemIndex];
                    ParamByName('arg_TEXT02' ).AsString := '';  //cd_dept
                    ParamByName('arg_TEXT03' ).AsString := edtNo_Emp.Text;  //no_emp
                    ParamByName('arg_TEXT04' ).AsString := 'W'; //work_type
                    ParamByName('arg_TEXT05' ).AsString := FormatDateTime('YYYYMMDD',edtDateFr.Date);
                    ParamByName('arg_TEXT06' ).AsString := FormatDateTime('YYYYMMDD',edtDateTo.Date);
                    ParamByName('arg_TEXT07' ).AsString := FormatDateTime('HHNNSS',  edtTimeFr.Time);
                    ParamByName('arg_TEXT08' ).AsString := FormatDateTime('HHNNSS',  edtTimeTo.Time);
                    ParamByName('arg_TEXT09' ).AsString := '0';           //break_time
                    ParamByName('arg_TEXT10' ).AsString := edtMemo.Text;   //memo
                    Open;
                 // Button_Save.Visible := false;
                    Button_Save.Enabled := false;
                    if RecordCount=1 then begin
                       edtNm_kor.Text :=  FieldByName('Nm_kor' ).AsString;
                       p_ShowMessage('입력완료');
                    end
                    else begin
                       p_ShowMessage(RecordCount.ToString+'건이 입력되었습니다.');
                    end;
                    Close;
                 Except
                   Close;
                 //Button_Save.Visible := true;
                   Button_Save.Enabled := true;
                   edtNm_kor.Text      := '';
                   p_ShowMessage('Except Error');
                 end;
               end;
             end;
      //mrCancel: Exit;
    end;
  end);

end;

procedure TfrmCom_Work_Exception.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;



procedure TfrmCom_Work_Exception.MenuButtonClick(Sender: TObject);
begin
  Close;
end;


initialization
   RegisterClasses([TfrmCom_Work_Exception]);

finalization
   UnRegisterClasses([TfrmCom_Work_Exception]);



end.


