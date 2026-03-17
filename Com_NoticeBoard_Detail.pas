 unit Com_NoticeBoard_Detail;

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
  FMX.EditBox, FMX.NumberBox, FMX.TMSCustomButton, FMX.TMSSpeedButton,
  FMX.Memo.Types;

type
  TfrmCom_NoticeBoard_Detail = class(TForm)
    HeaderToolBar: TToolBar;
    Label_Title: TLabel;
    btnClose: TButton;
    Layout1: TLayout;
    edtSeq: TEdit;
    edtBdCode: TEdit;
    edtBdName_DB: TEdit;
    edtSubSeq: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    btnQuery: TButton;
    edtNo_Emp: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    edtCd_Company: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    edtKind: TEdit;
    Edit6: TEdit;
    Edit9: TEdit;
    Layout_Notice: TLayout;
    edtTitle: TEdit;
    Image2: TImage;
    edtMemo: TMemo;
    Layout_Save: TLayout;
    btnSave: TButton;
    btnDelete: TButton;
    Layout2: TLayout;
    Layout_Save_R: TLayout;
    btnSave_R: TButton;
    memo_Reply: TMemo;
    Label2: TLabel;
    procedure FormClear(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MenuButtonClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnQueryClick(Sender: TObject);
    procedure btnSave_RClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCom_NoticeBoard_Detail: TfrmCom_NoticeBoard_Detail;
implementation

{$R *.fmx}

uses Com_DataModule,Com_function,Com_Variable,MainMenu, Com_Select_Code;


procedure TfrmCom_NoticeBoard_Detail.FormShow(Sender: TObject);
begin
  FormClear(Sender);
  if g_Sel_ActionKind=0 then begin
    Layout_Save.Visible   := true;
    btnSave.Visible       := true;
    btnDelete.Visible     := false;
    memo_Reply.Visible    := false;
    Layout_Save_R.Visible := false;

    edtSeq.Text         := '';
    edtSubSeq.Text      := '';
    edtKind.Text        := '';

  end else
  begin
     edtSeq.Text    := g_Sel_TagString[0];
     edtSubSeq.Text := g_Sel_TagString[1];
     btnQueryClick(Sender);
  end;

end;

procedure TfrmCom_NoticeBoard_Detail.FormClear(Sender: TObject);
begin

  edtSeq.Text         := '';
  edtSubSeq.Text      := '';
  edtKind.Text        := '';

  edtCd_Company.Text  := g_User_Company;
  edtNo_Emp.Text      := g_User_EmpNo;

  edtMemo.Text        := '';
  edtTitle.Text       := '';

  Layout_Save.Visible := false;
  btnSave.Visible     := false;
  btnDelete.Visible   := false;

end;



procedure TfrmCom_NoticeBoard_Detail.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCom_NoticeBoard_Detail.btnDeleteClick(Sender: TObject);
begin
  g_Data_Updated := true;
  with frmCom_DataModule.ClientDataSet_Proc do begin
    try
      p_CreatePrams;
      ParamByName('arg_ModCd'  ).AsString := 'Com_NoticeBoard_Delete';
      ParamByName('arg_TEXT01' ).AsString := edtSeq.Text;
      ParamByName('arg_TEXT02' ).AsString := edtSubSeq.Text;
      Open;
      p_Toast('삭제되었습니다.');
    finally
      Close;
    end;
  end;
end;

procedure TfrmCom_NoticeBoard_Detail.btnQueryClick(Sender: TObject);
begin
  g_Data_Updated := true;
  with frmCom_DataModule.ClientDataSet_Proc do begin
    try
      p_CreatePrams;
      ParamByName('arg_ModCd'  ).AsString := 'Com_NoticeBoard_Detail';
      ParamByName('arg_TEXT01' ).AsString := edtSeq.Text;
      ParamByName('arg_TEXT02' ).AsString := edtSubSeq.Text;
      Open;
      edtSeq.Text        := FieldByName('Seq'       ).AsString;
      edtSubSeq.Text     := FieldByName('SubSeq'    ).AsString;
      edtTitle.Text      := FieldByName('Title'     ).AsString;
      edtMemo.Text       := FieldByName('Memo'      ).AsString;
      edtKind.Text       := FieldByName('Kind'      ).AsString;
      edtCd_Company.Text := FieldByName('Cd_Company').AsString;
      edtNo_Emp.Text     := FieldByName('No_Emp'    ).AsString;
      Layout_Save.Visible := edtNo_Emp.Text=g_User_EmpNo;
      btnSave.Visible     := edtNo_Emp.Text=g_User_EmpNo;
      btnDelete.Visible   := edtNo_Emp.Text=g_User_EmpNo;

      edtMemo.Enabled     := edtNo_Emp.Text=g_User_EmpNo;
      edtTitle.Enabled    := edtNo_Emp.Text=g_User_EmpNo;

      if edtNo_Emp.Text<>g_User_EmpNo then begin
         memo_Reply.Visible    := true;
         Layout_Save_R.Visible := true;
      end;

    finally
      Close;
    end;

  end;
end;



procedure TfrmCom_NoticeBoard_Detail.btnSaveClick(Sender: TObject);
begin
  g_Data_Updated := true;
  with frmCom_DataModule.ClientDataSet_Proc do begin
    try
      p_CreatePrams;
      ParamByName('arg_ModCd'  ).AsString := 'Com_NoticeBoard_Insert';
      ParamByName('arg_TEXT01' ).AsString := edtSeq.Text;
      ParamByName('arg_TEXT02' ).AsString := edtSubSeq.Text;
      ParamByName('arg_TEXT03' ).AsString := edtCd_Company.Text;
      ParamByName('arg_TEXT04' ).AsString := edtNo_Emp.Text;
      ParamByName('arg_TEXT05' ).AsString := edtKind.Text;
      ParamByName('arg_TEXT06' ).AsString := edtTitle.Text;
      ParamByName('arg_TEXT07' ).AsString := edtMemo.Text;
      Open;
      if (RecordCount=1) then begin
         ShowMessage('Ok');
         edtSeq.Text    := FieldByName('SEQ').AsString;
         edtSubSeq.Text := FieldByName('SubSEQ').AsString;
         p_Toast('게시되었습니다.')
      end else p_Toast('System Error');
    finally
      Close;
      Self.Close;
    end;
  end;
end;

procedure TfrmCom_NoticeBoard_Detail.btnSave_RClick(Sender: TObject);
begin
  with frmCom_DataModule.ClientDataSet_Proc do begin
    try
      p_CreatePrams;
      ParamByName('arg_ModCd'  ).AsString := 'Com_NoticeBoard_Insert_Reply';
      ParamByName('arg_TEXT01' ).AsString := edtSeq.Text;
      ParamByName('arg_TEXT02' ).AsString := '';
      ParamByName('arg_TEXT03' ).AsString := g_User_Company;
      ParamByName('arg_TEXT04' ).AsString := g_User_EmpNo;
      ParamByName('arg_TEXT05' ).AsString := edtKind.Text;
      ParamByName('arg_TEXT06' ).AsString := 'R';
      ParamByName('arg_TEXT07' ).AsString := memo_Reply.Text;
      Open;
      if (RecordCount=1) then begin
         ShowMessage('Ok');
         edtSeq.Text    := FieldByName('SEQ').AsString;
         edtSubSeq.Text := FieldByName('SubSEQ').AsString;
         p_Toast('게시되었습니다.')
      end else p_Toast('System Error');
    finally
      Close;
    end;
  end;
end;

procedure TfrmCom_NoticeBoard_Detail.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;



procedure TfrmCom_NoticeBoard_Detail.MenuButtonClick(Sender: TObject);
begin
  Close;
end;

initialization
   RegisterClasses([TfrmCom_NoticeBoard_Detail]);

finalization
   UnRegisterClasses([TfrmCom_NoticeBoard_Detail]);

end.

