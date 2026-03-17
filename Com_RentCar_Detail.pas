 unit Com_RentCar_Detail;

interface

uses
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
  FMX.TMSRadioGroupPicker, FMX.TMSPlannerBase, FMX.TMSPlannerData,
  FMX.TMSPlanner, FMX.TMSCustomButton, FMX.TMSSpeedButton,
  System.DateUtils;

type
  TfrmCom_RentCar_Detail = class(TForm)
    HeaderToolBar: TToolBar;
    Label_Title: TLabel;
    Layout_Combo: TLayout;
    cboCompany: TComboBox;
    btnClose: TButton;
    btnQuery: TButton;
    Layout_I: TLayout;
    Layout3: TLayout;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label19: TLabel;
    Label7: TLabel;
    Layout_Data: TLayout;
    edtI_Why: TEdit;
    edtI_Where: TEdit;
    edtI_Who: TEdit;
    Layout4: TLayout;
    edtI_DateFr: TDateEdit;
    edtI_TimeFr: TTimeEdit;
    Layout5: TLayout;
    edtI_DateTo: TDateEdit;
    edtI_TimeTo: TTimeEdit;
    Layout_Body: TLayout;
    edtI_Cd_Company: TEdit;
    edtI_Nm_Dept: TEdit;
    edtI_Nm_Kor: TEdit;
    edtI_Cd_Dept: TEdit;
    edtI_No_Emp: TEdit;
    edtSeq: TEdit;
    edtI_MEMO: TMemo;
    edtO_YesNo: TEdit;
    Layout_O: TLayout;
    Layout2: TLayout;
    Layout6: TLayout;
    Label21: TLabel;
    Label1: TLabel;
    edtO_MEMO: TMemo;
    Layout7: TLayout;
    edtO_Cd_Company: TEdit;
    edtO_Nm_Kor: TEdit;
    edtO_Cd_Dept: TEdit;
    edtO_No_Emp: TEdit;
    edtO_Nm_Dept: TEdit;
    Layout_I_Btn: TLayout;
    Button_Delete: TButton;
    Button_Save: TButton;
    Layout_O_Btn: TLayout;
    Button_Yes: TButton;
    Button_No: TButton;
    edtO_YesNoName: TEdit;
    Layout1: TLayout;
    edtI_Car_Name: TComboBox;
    btnClearCar_Name: TTMSFMXSpeedButton;
    function  f_Check_Data: Integer;
    procedure p_ClearData(Sender: TObject);
    procedure btnQueryClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MenuButtonClick(Sender: TObject);
    procedure Button_SaveClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure Button_DeleteClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button_YesClick(Sender: TObject);
    procedure Button_NoClick(Sender: TObject);
    procedure btnClearCar_NameClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCom_RentCar_Detail: TfrmCom_RentCar_Detail;
  l_ActionKind: Integer=-1;

implementation

{$R *.fmx}

uses System.Math, FMX.Utils,Com_DataModule,Com_function,Com_Variable,MainMenu,
  Com_Select_Code;


procedure TfrmCom_RentCar_Detail.FormShow(Sender: TObject);
begin
  g_Data_Updated   := false;
  Label_Title.Text := '배차신청';
  l_ActionKind     := g_Sel_ActionKind;
  p_SetComboCode(Self,edtI_Car_Name,g_User_Company,'RENTCAR',true,'','');
  if l_ActionKind = 0 then begin
    p_ClearData(Sender);
    Layout_I.Visible     := true;
    LayOut_I_Btn.Visible := true;
    Button_Save.Visible  := true;
    edtI_DATEFR.DateTime := g_Sel_DateTimeFr;
    edtI_TimeFR.DateTime := g_Sel_DateTimeFr;
    edtI_DATETO.DateTime := g_Sel_DateTimeTo;
    edtI_TimeTO.DateTime := g_Sel_DateTimeTo;
  end
  else begin
    edtI_Cd_Company.Text := g_Sel_TagString[0]; //
    edtI_No_Emp.Text     := g_Sel_TagString[1];
    edtSeq.Text          := g_Sel_TagString[2];
    btnQueryClick(Sender);
  end;
end;


procedure TfrmCom_RentCar_Detail.Button_YesClick(Sender: TObject);
begin
  if f_Check_Data<>0 then Exit;
  TDialogService.MessageDialog(('배차승인하시겠습니까?'),
  system.UITypes.TMsgDlgType.mtInformation,
 [system.UITypes.TMsgDlgBtn.mbYes, system.UITypes.TMsgDlgBtn.mbCancel], system.UITypes.TMsgDlgBtn.mbYes,0,
  procedure (const AResult: System.UITypes.TModalResult)
  begin
    case AResult of
      mrYes:
        begin
          g_Data_Updated:=true;
          with frmCom_DataModule.ClientDataSet_Proc do begin
            try
              p_CreatePrams;
              ParamByName('arg_ModCd'  ).AsString := 'Com_RentCar_Ok';
              ParamByName('arg_TEXT01' ).AsString := edtSEQ.Text;
              ParamByName('arg_TEXT02' ).AsString := edtI_CAR_NAME.ListItems[edtI_CAR_NAME.ItemIndex].TagString;
              ParamByName('arg_TEXT03' ).AsString := edtI_CAR_NAME.ListItems[edtI_CAR_NAME.ItemIndex].Text;
              ParamByName('arg_TEXT04' ).AsString := FormatDateTime('YYYYMMDD',edtI_DATEFR.DateTime);
              ParamByName('arg_TEXT05' ).AsString := FormatDateTime('YYYYMMDD',edtI_DATETO.DateTime);
              ParamByName('arg_TEXT06' ).AsString := FormatDateTime('HHNNSS',  edtI_TimeFR.DateTime);
              ParamByName('arg_TEXT07' ).AsString := FormatDateTime('HHNNSS',  edtI_TimeTo.DateTime);
              ParamByName('arg_TEXT08' ).AsString := edtO_MEMO.Text;
              Open;
              if RecordCount=1
                then p_Toast('승인처리되었습니다.')
                else p_Toast('System Error');
            finally
              Close;
              frmMainMenu.Com_Marketing_ScheduleExecute;
              Self.Close;
            end;
          end;
        end;
    end;
  end);
end;


procedure TfrmCom_RentCar_Detail.Button_NoClick(Sender: TObject);
begin
  TDialogService.MessageDialog(('배차불가처리하시겠습니까?'),
  system.UITypes.TMsgDlgType.mtInformation,
 [system.UITypes.TMsgDlgBtn.mbYes, system.UITypes.TMsgDlgBtn.mbCancel], system.UITypes.TMsgDlgBtn.mbYes,0,
  procedure (const AResult: System.UITypes.TModalResult)
  begin
    case AResult of
      mrYes:
        begin
          g_Data_Updated:=true;
          with frmCom_DataModule.ClientDataSet_Proc do begin
            try
              p_CreatePrams;
              ParamByName('arg_ModCd'  ).AsString := 'Com_RentCar_Reject';
              ParamByName('arg_TEXT01' ).AsString := edtSEQ.Text;
              ParamByName('arg_TEXT02' ).AsString := edtO_MEMO.Text;
              Open;
              if RecordCount=1
                then p_Toast('배차불가처리되었습니다.')
                else p_Toast('System Error');
            finally
              Close;
              frmMainMenu.Com_Marketing_ScheduleExecute;
              Self.Close;
            end;
          end;
        end;
    end;
  end);
end;

procedure TfrmCom_RentCar_Detail.Button_DeleteClick(Sender: TObject);
begin
  TDialogService.MessageDialog(('삭제하시겠습니까?'),
  system.UITypes.TMsgDlgType.mtInformation,
 [system.UITypes.TMsgDlgBtn.mbYes, system.UITypes.TMsgDlgBtn.mbCancel], system.UITypes.TMsgDlgBtn.mbYes,0,
  procedure (const AResult: System.UITypes.TModalResult)
  begin
    case AResult of
      mrYes: begin
               g_Data_Updated:=true;
               with frmCom_DataModule.ClientDataSet_Proc do begin
                 try
                   p_CreatePrams;
                   ParamByName('arg_ModCd' ).AsString := 'Com_RentCar_Delete2';
                   ParamByName('arg_TEXT01').AsString := edtSeq.Text;
                   Open;
                   if RecordCount=0 then begin
                      edtSeq.Text := '';
                      p_Toast('삭제완료');
                   end
                   else begin
                      p_Toast('System Error');
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

procedure TfrmCom_RentCar_Detail.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCom_RentCar_Detail.btnQueryClick(Sender: TObject);
var v_Seq: String;
begin
  v_Seq := edtSeq.Text;
  p_ClearData(Sender);

  with frmCom_DataModule.ClientDataSet_Proc do begin
    try
      p_CreatePrams;
      ParamByName('arg_ModCd'  ).AsString := 'Com_RentCar_Detail2';
      ParamByName('arg_TEXT01' ).AsString := v_Seq;
      Open;
      btnQuery.Visible            := RecordCount=1;
      edtSEQ.         Text      := FieldByName('SEQ'         ).AsString;
      edtI_CAR_NAME.  ItemIndex := f_GetComboCode(edtI_CAR_NAME,FieldByName('I_CAR_CODE').AsString);
      edtI_CD_COMPANY.Text      := FieldByName('I_CD_COMPANY').AsString;
      edtI_NO_EMP.    Text      := FieldByName('I_NO_EMP'    ).AsString;
      edtI_CD_DEPT.   Text      := FieldByName('I_CD_DEPT'   ).AsString;
      edtI_NM_KOR.    Text      := FieldByName('I_NM_KOR'    ).AsString;
      edtI_NM_DEPT.   Text      := FieldByName('I_NM_DEPT'   ).AsString;

      edtI_DATEFR.    DateTime  := FieldByName('I_DATEFR'    ).AsDateTime;
      edtI_DATETO.    DateTime  := FieldByName('I_DATETO'    ).AsDateTime;
      edtI_TimeFR.    DateTime  := FieldByName('I_TimeFR'    ).AsDateTime;
      edtI_TimeTO.    DateTime  := FieldByName('I_TimeTO'    ).AsDateTime;

      edtI_WHERE.     Text      := FieldByName('I_WHERE'     ).AsString;
      edtI_WHY.       Text      := FieldByName('I_WHY'       ).AsString;
      edtI_WHO.       Text      := FieldByName('I_WHO'       ).AsString;
      edtI_MEMO.      Text      := FieldByName('I_MEMO'      ).AsString;
      edtO_CD_COMPANY.Text      := FieldByName('O_CD_COMPANY').AsString;
      edtO_NO_EMP.    Text      := FieldByName('O_NO_EMP'    ).AsString;
      edtO_CD_DEPT.   Text      := FieldByName('O_CD_DEPT'   ).AsString;
      edtO_NM_KOR.    Text      := FieldByName('O_NM_KOR'    ).AsString;
      edtO_NM_DEPT.   Text      := FieldByName('O_NM_DEPT'   ).AsString;
      edtO_YesNo.     Text      := FieldByName('O_YESNO'     ).AsString;
      edtO_YesNoName. Text      := FieldByName('O_YESNONAME' ).AsString;
      edtO_MEMO.      Text      := FieldByName('O_MEMO'      ).AsString;
    //----------------------------------------------------------------------------
      Layout_I.Visible          := FieldByName('Layout_I'    ).AsInteger=1;
      Layout_I_Btn.Visible      := FieldByName('Layout_I_Btn').AsInteger=1;
      Button_Save.Visible       := FieldByName('Layout_I_Btn').AsInteger=1;
      Button_Delete.Visible     := FieldByName('Layout_I_Btn').AsInteger=1;
      Layout_O.Visible          := FieldByName('Layout_O'    ).AsInteger=1;
      Layout_O_Btn.Visible      := FieldByName('Layout_O_Btn').AsInteger=1;

      Layout_I.    Position.Y   := Layout_I.    Position.Y;
      Layout_I_Btn.Position.Y   := Layout_I.    Position.Y + Layout_I.    Height;
      Layout_O.    Position.Y   := Layout_I_Btn.Position.Y + Layout_I_Btn.Height;
      Layout_O_Btn.Position.Y   := Layout_O.    Position.Y + Layout_O.    Height;

   //----------------------------------------------------------------------------
    finally
      Close;
    end;
  end;
end;



procedure TfrmCom_RentCar_Detail.btnClearCar_NameClick(Sender: TObject);
begin
  edtI_Car_Name.ItemIndex := 0;
end;

procedure TfrmCom_RentCar_Detail.p_ClearData(Sender: TObject);
begin
//---------------------------------------------
  btnQuery.Visible            := false;
//---------------------------------------------
  Layout_I.Visible            := false;
  LayOut_I_Btn.Visible        := false;
  Layout_O.Visible            := false;
  LayOut_O_Btn.Visible        := false;
  Button_Save.Visible         := false;
  Button_Delete.Visible       := false;

  Layout_I.    Position.y     := 1;
  Layout_I_Btn.Position.y     := Layout_I.    Position.y + Layout_I.    Height;
  Layout_O.    Position.y     := Layout_I_Btn.Position.y + Layout_I_Btn.Height;
  Layout_O_Btn.Position.y     := Layout_O.    Position.y + Layout_O.    Height;

//---------------------------------------------
  edtSEQ.           Text      := '';
  edtI_CAR_NAME.    ItemIndex := 0;
  edtI_CD_COMPANY.  Text      := g_User_Company;
  edtI_NO_EMP.      Text      := g_User_EmpNo;
  edtI_CD_DEPT.     Text      := g_User_Dept;
  edtI_NM_KOR.      Text      := g_User_EmpName;
  edtI_NM_DEPT.     Text      := g_User_DeptName;
  edtI_DATEFR.      DateTime  := (IncHour(Now,0));
  edtI_TimeFR.      DateTime  := (IncHour(Now,0));
  edtI_DATETO.      DateTime  := (IncHour(Now,5));
  edtI_TimeTO.      DateTime  := (IncHour(Now,5));

  edtI_WHERE.       Text      := '';
  edtI_WHY.         Text      := '';
  edtI_WHO.         Text      := '';
  edtI_MEMO.        Text      := '';
//---------------------------------------------
  edtO_CD_COMPANY.  Text      := '';
  edtO_NO_EMP.      Text      := '';
  edtO_CD_DEPT.     Text      := '';
  edtO_NM_KOR.      Text      := '';
  edtO_NM_DEPT.     Text      := '';
  edtO_YESNO.       Text      := 'X';
  edtO_YESNOName.   Text      := '';
  edtO_MEMO.        Text      := '';
//---------------------------------------------

end;

function TfrmCom_RentCar_Detail.f_Check_Data: Integer;
begin
  Result := 0;
  if Trunc(edtI_DateFr.DateTime)>Trunc(edtI_DateTo.DateTime) then begin
     Result := Result+1;
     ShowMessage('운행일자를 확인하세요');
  end else
  if (Trunc(edtI_DateFr.DateTime)=Trunc(edtI_DateTo.DateTime)) and
     (FormatDateTime('HHNN',edtI_TimeFR.DateTime)>=
      FormatDateTime('HHNN',edtI_TimeTo.DateTime))then begin
     Result := Result+1;
     ShowMessage('반납예정시간을 확인하세요');
  end else
  if Trim(edtI_Why.Text)='' then begin
     Result := Result+1;
     ShowMessage('운행사유를 입력하세요');
  end else
  if Trim(edtI_Where.Text)='' then begin
     Result := Result+1;
     ShowMessage('행선지를 입력하세요');
  end else
  begin
    with frmCom_DataModule.ClientDataSet_Proc do begin
      try
        p_CreatePrams;
        ParamByName('arg_ModCd'  ).AsString := 'Com_RentCar_CheckData';
        ParamByName('arg_TEXT01' ).AsString := edtSEQ.Text;
        ParamByName('arg_TEXT02' ).AsString := edtI_CAR_NAME.ListItems[edtI_CAR_NAME.ItemIndex].TagString;
        ParamByName('arg_TEXT03' ).AsString := edtI_CAR_NAME.ListItems[edtI_CAR_NAME.ItemIndex].Text;
        ParamByName('arg_TEXT04' ).AsString := edtI_CD_COMPANY.  Text;
        ParamByName('arg_TEXT05' ).AsString := edtI_NO_EMP.      Text;
        ParamByName('arg_TEXT06' ).AsString := edtI_CD_DEPT.     Text;
        ParamByName('arg_TEXT07' ).AsString := edtI_NM_KOR.      Text;
        ParamByName('arg_TEXT08' ).AsString := edtI_NM_DEPT.     Text;
        ParamByName('arg_TEXT09' ).AsString := FormatDateTime('YYYYMMDD',edtI_DATEFR.DateTime);
        ParamByName('arg_TEXT10' ).AsString := FormatDateTime('YYYYMMDD',edtI_DATETO.DateTime);
        ParamByName('arg_TEXT11' ).AsString := FormatDateTime('HHNNSS',  edtI_TimeFR.DateTime);
        ParamByName('arg_TEXT12' ).AsString := FormatDateTime('HHNNSS',  edtI_TimeTo.DateTime);
        Open;
        if FieldByName('R_YESNO').AsString <> 'Y' then begin
           Result := Result+1;
           ShowMessage(FieldByName('R_Message').AsString);
        end;
      finally
        Close;
      end;
    end;
  end;
end;

procedure TfrmCom_RentCar_Detail.Button_SaveClick(Sender: TObject);
begin
  if f_Check_Data<>0 then Exit;
  TDialogService.MessageDialog(('저장하시겠습니까?'),
  system.UITypes.TMsgDlgType.mtInformation,
 [system.UITypes.TMsgDlgBtn.mbYes, system.UITypes.TMsgDlgBtn.mbCancel], system.UITypes.TMsgDlgBtn.mbYes,0,
  procedure (const AResult: System.UITypes.TModalResult)
  begin
    case AResult of
      mrYes:begin
              g_Data_Updated:=true;
              with frmCom_DataModule.ClientDataSet_Proc do begin
                try
                  p_CreatePrams;
                  if edtSeq.Text = ''
                    then ParamByName('arg_ModCd'  ).AsString := 'Com_RentCar_Insert2'
                    else ParamByName('arg_ModCd'  ).AsString := 'Com_RentCar_Update2';
                  ParamByName('arg_TEXT01' ).AsString := edtSEQ.Text;
                  ParamByName('arg_TEXT02').AsString  := edtI_CAR_NAME.ListItems[edtI_CAR_NAME.ItemIndex].TagString;
                  ParamByName('arg_TEXT03').AsString  := edtI_CAR_NAME.ListItems[edtI_CAR_NAME.ItemIndex].Text;
                  ParamByName('arg_TEXT04' ).AsString := edtI_CD_COMPANY.  Text;
                  ParamByName('arg_TEXT05' ).AsString := edtI_NO_EMP.      Text;
                  ParamByName('arg_TEXT06' ).AsString := edtI_CD_DEPT.     Text;
                  ParamByName('arg_TEXT07' ).AsString := edtI_NM_KOR.      Text;
                  ParamByName('arg_TEXT08' ).AsString := edtI_NM_DEPT.     Text;
                  ParamByName('arg_TEXT09' ).AsString := FormatDateTime('YYYYMMDD',edtI_DATEFR.DateTime);
                  ParamByName('arg_TEXT10' ).AsString := FormatDateTime('YYYYMMDD',edtI_DATETO.DateTime);
                  ParamByName('arg_TEXT11' ).AsString := FormatDateTime('HHNNSS',  edtI_TimeFR.DateTime);
                  ParamByName('arg_TEXT12' ).AsString := FormatDateTime('HHNNSS',  edtI_TimeTo.DateTime);
                  ParamByName('arg_TEXT13' ).AsString := edtI_WHERE.       Text;
                  ParamByName('arg_TEXT14' ).AsString := edtI_WHY.         Text;
                  ParamByName('arg_TEXT15' ).AsString := edtI_WHO.         Text;
                  ParamByName('arg_TEXT16' ).AsString := edtI_MEMO.        Text;
                  Open;
                  if (RecordCount=1) then begin
                     if FieldByName('SAVE_YESNO').AsString = 'Y' then begin
                        edtSeq.Text := FieldByName('SEQ').AsString;
                        p_Toast(FieldByName('SAVE_Message').AsString);
                        Close;
                        frmMainMenu.Com_Marketing_ScheduleExecute;
                        Self.Close;
                     end
                     else begin
                        ShowMessage(FieldByName('SAVE_Message').AsString);
                     end;
                  end
                  else begin
                     p_Toast('System Error');
                  end;
                finally
                  Close;
                end;
              end;
            end;
    end;
  end);
end;


procedure TfrmCom_RentCar_Detail.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;

procedure TfrmCom_RentCar_Detail.FormKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
var FService : IFMXVirtualKeyboardService;
begin
  if (Key = vkHardwareBack) then begin
    TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, IInterface(FService));
    if (FService <> nil) and (TVirtualKeyboardState.Visible in FService.VirtualKeyBoardState) then begin
    end
    else begin
      Key := 0;
      Self.Close;
    end;
  end;
end;


procedure TfrmCom_RentCar_Detail.MenuButtonClick(Sender: TObject);
begin
  Close;
end;

initialization
   RegisterClasses([TfrmCom_RentCar_Detail]);

finalization
   UnRegisterClasses([TfrmCom_RentCar_Detail]);

end.


