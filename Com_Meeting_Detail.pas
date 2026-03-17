 unit Com_Meeting_Detail;

interface

uses
  System.DateUtils,
  FMX.DialogService,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.ListView.Types,
  FMX.StdCtrls, FMX.ListView, FMX.ListView.Appearances, Data.Bind.GenData,
  Fmx.Bind.GenData, System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components,
  Data.Bind.ObjectScope, FMX.ListBox,
  System.UIConsts,
  FMX.VirtualKeyboard,
  FMX.TabControl, FMX.Objects, FMX.MobilePreview, FMX.Controls.Presentation,
  FMX.ListView.Adapters.Base, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP, System.ImageList, FMX.ImgList, System.Math.Vectors,
  FMX.Controls3D, FMX.Objects3D, FMX.Viewport3D, FMX.Layouts,
  FMX.Layers3D,
  Fmx.Ani, FMX.MultiView,
  FMX.Platform, Datasnap.DSClientRest, System.Actions, FMX.ActnList,
  FMX.Gestures, FMX.ScrollBox, FMX.Memo, FMX.Edit, FMX.DateTimeCtrls,
  FMX.EditBox, FMX.NumberBox, FMX.TMSBaseControl, FMX.TMSCustomPicker,
  FMX.TMSRadioGroupPicker;

type
  TfrmCom_Meeting_Detail = class(TForm)
    HeaderToolBar: TToolBar;
    btnQuery: TButton;
    Label_Title: TLabel;
    Layout_Combo: TLayout;
    cboCompany: TComboBox;
    btnClose: TButton;
    Layout_InsertNew: TLayout;
    Layout7: TLayout;
    lblRoom: TLabel;
    Layout11: TLayout;
    lblDate: TLabel;
    Layout5: TLayout;
    edtTimeFr: TTimeEdit;
    edtTimeTo: TTimeEdit;
    Layout6: TLayout;
    btnSave: TButton;
    btnDelete: TButton;
    Layout2: TLayout;
    lblTime: TLabel;
    edtTitle: TEdit;
    Layout3: TLayout;
    Label1: TLabel;
    edtMember: TEdit;
    Layout1: TLayout;
    Label2: TLabel;
    edtDate: TDateEdit;
    cboRoom: TTMSFMXRadioGroupPicker;
    edtMeetingNo: TEdit;
    Layout4: TLayout;
    Label3: TLabel;
    edtNm_Kor: TEdit;
    edtNo_Emp: TEdit;
    procedure p_ClearData(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MenuButtonClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnQueryClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCom_Meeting_Detail: TfrmCom_Meeting_Detail;
  l_ActionKind: Integer=-1;
implementation

{$R *.fmx}

uses System.Math, FMX.Utils,Com_DataModule,Com_function,Com_Variable,MainMenu;



procedure TfrmCom_Meeting_Detail.FormShow(Sender: TObject);
begin
  p_SetComboBox(cboRoom,'MEETING_ROOM');
  l_ActionKind     := g_Sel_ActionKind;
  p_ClearData(Sender);
  if l_ActionKind = 1 then begin
    edtMeetingNo.Text := g_Sel_TagString[2];
    btnQueryClick(Sender);
  end;
end;

procedure TfrmCom_Meeting_Detail.p_ClearData(Sender: TObject);
begin
  if MinuteOf(Now)<30
     then edtDate.DateTime := IncMinute(IncMinute(Now,-(MinuteOf(Now))),30)
     else edtDate.DateTime := IncMinute(IncMinute(Now,-(MinuteOf(Now))),60);

  edtNm_Kor.Text           := g_User_EmpName;
  edtNo_Emp.Text           := g_User_EmpNo;
  edtMeetingNo.Text        := '';
  edtTimeFr.DateTime       := edtDate.DateTime;
  edtTimeTo.DateTime       := IncMinute(edtTimeFr.DateTime,60);
  edtTitle.Text            := '';
  edtMember.Text           := '';
  cboRoom.ItemIndex        := -1;//
  btnSave.Visible          := true;
  btnDelete.Visible        := false;
  btnSave.Text             := '입력';
end;


procedure TfrmCom_Meeting_Detail.btnQueryClick(Sender: TObject);
begin
  try
    btnSave.Visible          := false;
    btnDelete.Visible        := false;
    with frmCom_DataModule.ClientDataSet_Proc do begin
      try
        p_CreatePrams;
        ParamByName('arg_ModCd'  ).AsString := 'MEETING_SCHEDULE_DETAIL';
        ParamByName('arg_TEXT01' ).AsString := edtMeetingNo.Text; //MEETING_NO
        Open;
        edtNm_Kor.Text       := FieldByName('NM_KOR'       ).AsString;
        edtNo_Emp.Text       := FieldByName('NO_EMP'       ).AsString;
        p_GetComboBox(cboRoom,  FieldByName('MEETING_ROOM' ).AsString);
        edtDate.DateTime     := Trunc(FieldByName('TIME_FR').AsDateTime);
        edtTimeFr.DateTime   := FieldByName('TIME_FR'      ).AsDateTime;
        edtTimeTo.DateTime   := FieldByName('TIME_TO'      ).AsDateTime;
        btnSave.Visible      := FieldByName('btnSave'      ).AsString='Y';
        btnDelete.Visible    := FieldByName('btnDelete'    ).AsString='Y';
        btnSave.Text         := '저장';
      finally
        Close;
      end;
    end;
  finally
    frmCom_DataModule.ClientDataSet_Proc.Close;
  end;
end;

procedure TfrmCom_Meeting_Detail.btnDeleteClick(Sender: TObject);
begin
  TDialogService.MessageDialog(('삭제하시겠습니까?'),
  system.UITypes.TMsgDlgType.mtInformation,
 [system.UITypes.TMsgDlgBtn.mbYes, system.UITypes.TMsgDlgBtn.mbCancel], system.UITypes.TMsgDlgBtn.mbYes,0,
  procedure (const AResult: System.UITypes.TModalResult)
  begin
    case AResult of
      mrYes:
      begin
        g_Data_Updated := true;
        with frmCom_DataModule.ClientDataSet_Proc do begin
          try
            p_CreatePrams;
            ParamByName('arg_ModCd'  ).AsString := 'MEETING_SCHEDULE_DELETE';
            ParamByName('arg_TEXT01' ).AsString := edtMeetingNo.Text; //MEETING_NO
            Open;
            if RecordCount=0
               then p_Toast('삭제완료')
               else p_Toast('삭제불가');
          finally
            Close;
            Self.Close;
          end;
        end;
      end;
    end;
  end);
end;

procedure TfrmCom_Meeting_Detail.btnSaveClick(Sender: TObject);
begin
  if cboRoom.ItemIndex<0 then begin
     cboRoom.SetFocus;
     Exit;
  end;



  if FormatDateTime('HHNN',edtTimeFr.DateTime) >=
     FormatDateTime('HHNN',edtTimeTo.DateTime) then begin
     p_Toast('시간입력착오');
     edtTimeTo.SetFocus;
     Exit;
  end;

  if cboRoom.ItemIndex<0 then begin
    p_Toast('예약회의실을선택하세요');
    cboRoom.SetFocus;
    Exit;
  end;

  if Trim(edtTitle.Text) = '' then begin
    p_Toast('회의제목을선택하세요');
    edtTitle.SetFocus;
    Exit;
  end;



  TDialogService.MessageDialog(('저장하시겠습니까?'),
  system.UITypes.TMsgDlgType.mtInformation,
 [system.UITypes.TMsgDlgBtn.mbYes, system.UITypes.TMsgDlgBtn.mbCancel], system.UITypes.TMsgDlgBtn.mbYes,0,
  procedure (const AResult: System.UITypes.TModalResult)
  begin
    case AResult of
      mrYes:
      begin
        g_Data_Updated := true;
        with frmCom_DataModule.ClientDataSet_Proc do begin
          try
            p_CreatePrams;
            ParamByName('arg_ModCd'  ).AsString := 'MEETING_SCHEDULE_INSERT';
            ParamByName('arg_TEXT01' ).AsString := edtTitle.Text;
            ParamByName('arg_TEXT02' ).AsString := cboRoom.Items[cboRoom.ItemIndex].Value;;
            ParamByName('arg_TEXT03' ).AsString := FormatDateTime('YYYYMMDD',edtDate.Date)+FormatDateTime('HHNN',edtTimeFr.DateTime)+'00';
            ParamByName('arg_TEXT04' ).AsString := FormatDateTime('YYYYMMDD',edtDate.Date)+FormatDateTime('HHNN',edtTimeTo.DateTime)+'00';
            ParamByName('arg_TEXT05' ).AsString := '';
            ParamByName('arg_TEXT06' ).AsString := '';
            ParamByName('arg_TEXT07' ).AsString := edtMember.Text;
            ParamByName('arg_TEXT08' ).AsString := edtMeetingNo.Text;
            Open;
            edtMeetingNo.Text := FieldByName('MEETING_NO').AsString;
            if edtMeetingNo.Text<>'' then begin
              ShowMessage('예약완료');
              frmMainMenu.Com_Marketing_ScheduleExecute;
            end
            else begin
              ShowMessage('해당 시간에 기예약건이 있습니다');
            end;
          finally
            Close;
            Self.Close;
          end;
        end;
      end;
    end;
  end);
end;

procedure TfrmCom_Meeting_Detail.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;

procedure TfrmCom_Meeting_Detail.btnCloseClick(Sender: TObject);
begin
  Self.Close;
end;



procedure TfrmCom_Meeting_Detail.MenuButtonClick(Sender: TObject);
begin
  Close;
end;

initialization
   RegisterClasses([TfrmCom_Meeting_Detail]);

finalization
   UnRegisterClasses([TfrmCom_Meeting_Detail]);

end.



