unit Com_Planner_List02;

interface

uses
  System.UIConsts,
  System.DateUtils,
  Data.DB,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Platform,
  FMX.VirtualKeyboard,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TMSPlanner,
  FMX.TMSPlannerDatabaseAdapter, FMX.TMSBaseControl, FMX.TMSPlannerBase,
  FMX.TMSPlannerData, FMX.StdCtrls, FMX.Controls.Presentation, FMX.DateTimeCtrls,
  FMX.Layouts, FMX.Edit, FMX.ListBox, FMX.TMSCustomPicker,
  FMX.TMSRadioGroupPicker, FMX.Gestures, FMX.TMSCheckGroupPicker;

type
  TfrmCom_Planner_List02 = class(TForm)
    Planner1: TTMSFMXPlanner;
    HeaderToolBar: TToolBar;
    btnQuery: TButton;
    Label_Title: TLabel;
    btnClose: TButton;
    Layout2: TLayout;
    edtDateTime: TDateEdit;
    GestureManager1: TGestureManager;
    Layout_Marketing: TLayout;
    sbtInsert2: TSpeedButton;
    sbtInsert1: TSpeedButton;
    sbtInsert3: TSpeedButton;
    Layout1: TLayout;
    cboEmpNo: TTMSFMXCheckGroupPicker;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    cboDeptCode: TTMSFMXRadioGroupPicker;
    cboPeriod: TTMSFMXRadioGroupPicker;
    Label5: TLabel;
    cboKind: TTMSFMXCheckGroupPicker;

    procedure ChangeTab_Left;
    procedure ChangeTab_Right;

    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnQueryClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure sbtInsert1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Planner1Gesture(Sender: TObject;
      const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure Planner1AfterSelectItem(Sender: TObject;
      AItem: TTMSFMXPlannerItem);
    procedure sbtInsert2Click(Sender: TObject);
    procedure Planner1GetPositionText(Sender: TObject; APosition: Integer;
      AKind: TTMSFMXPlannerCacheItemKind; var AText: string);
    procedure edtDateTimeClosePicker(Sender: TObject);
    procedure cboEmpNoCheckGroupSelected(Sender: TObject; Index: Integer);
    procedure sbtInsert3Click(Sender: TObject);
    procedure cboPeriodRadioGroupSelected(Sender: TObject; Index: Integer);
    procedure cboDeptCodeRadioGroupSelected(Sender: TObject; Index: Integer);
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  frmCom_Planner_List02: TfrmCom_Planner_List02;

implementation

{$R *.fmx}

uses System.Math, Com_DataModule,Com_function,Com_Variable,MainMenu,
     Crm_Marketing_Detail, Com_Vacation_Insert, Com_RentCar_Detail;

procedure TfrmCom_Planner_List02.FormShow(Sender: TObject);
begin
  edtDateTime.DateTime := Trunc(Now);
  p_SetCombo_Dept(cboDeptCode,true);
  p_SetChkCombo(cboEmpNo,g_User_Company,'EMPNO_DEPT',  cboDeptCode.Items[cboDeptCode.ItemIndex].Value);
  p_SetChkCombo(cboKind,'PLANNER_KIND');
  if cboKind.Items.Count>0 then cboKind.IsChecked[0] := true;
  if cboKind.Items.Count>1 then cboKind.IsChecked[1] := true;
  btnQueryClick(Sender);
end;

procedure TfrmCom_Planner_List02.FormActivate(Sender: TObject);
begin
  if g_Data_Updated then begin
     g_Data_Updated := false;
     btnQueryClick(Sender);
  end;
end;


procedure TfrmCom_Planner_List02.btnQueryClick(Sender: TObject);
var v_DateFr,v_DateTo: TDateTime;
begin

  Case cboPeriod.ItemIndex of
    0: begin //1일
         v_DateFr := edtDateTime.DateTime;
         v_DateTo := edtDateTime.DateTime;
       end;
    1: begin //3일
         v_DateFr := edtDateTime.DateTime;
         v_DateTo := IncDay(edtDateTime.DateTime,+2);
       end;
    2: begin //1주
         edtDateTime.DateTime := StartOfTheWeek(edtDateTime.DateTime);
         v_DateFr := edtDateTime.DateTime;
         v_DateTo := EndOfTheWeek(edtDateTime.DateTime);
       end;
    3: begin //1개월
         edtDateTime.DateTime := StartOfTheMonth(edtDateTime.DateTime);
         v_DateFr := edtDateTime.DateTime;
         v_DateTo := EndOfTheMonth(edtDateTime.DateTime);
       end;
  End;

  with frmCom_DataModule.ClientDataSet_Proc do begin
    p_CreatePrams;
    ParamByName('arg_ModCd' ).AsString := 'Com_Planner_List01_x';
    ParamByName('arg_DateFr').AsString := FormatDateTime('YYYYMMDD',v_DateFr);
    ParamByName('arg_DateTo').AsString := FormatDateTime('YYYYMMDD',v_DateTo);
    ParamByName('arg_Text01').AsString := g_User_DeptList_CD;
    ParamByName('arg_Text02').AsString := cboDeptCode.Items[cboDeptCode.ItemIndex].Value;
    ParamByName('arg_Text03').AsString := f_GetChkCombo(cboEmpNo,true);
    ParamByName('arg_Text04').AsString := f_GetChkCombo(cboKind, true);
    f_Query_PlanerList(Self,Planner1,v_DateFr,v_DateTo);
  end;
end;


procedure TfrmCom_Planner_List02.Planner1AfterSelectItem(Sender: TObject; AItem: TTMSFMXPlannerItem);
begin
  try
    g_Data_Updated   := false;
    g_Sel_ActionKind := 1;
    g_Sel_TagString  := TStringList.Create;
    g_Sel_TagString.Clear;
  finally
    ExtractStrings([':'],[#0],PChar(Planner1.Items[AItem.Index].DataString),g_Sel_TagString);
    Case AItem.DataInteger of
      10:begin
           Application.CreateForm(TfrmCrm_Marketing_Detail,frmCrm_Marketing_Detail);
           frmCrm_Marketing_Detail.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
         end;
      20:begin
           Application.CreateForm(TfrmCom_Vacation_Insert,frmCom_Vacation_Insert);
           frmCom_Vacation_Insert.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
         end;
      30:begin
           Application.CreateForm(TfrmCom_RentCar_Detail,frmCom_RentCar_Detail);
           frmCom_RentCar_Detail.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
         end;
    End;
  end;
end;



procedure TfrmCom_Planner_List02.cboDeptCodeRadioGroupSelected(Sender: TObject;
  Index: Integer);
begin
  p_SetChkCombo(cboEmpNo,g_User_Company,'EMPNO_DEPT',cboDeptCode.Items[cboDeptCode.ItemIndex].Value);
  p_ClearPlaner(Self,Planner1,edtDateTime);
//btnQueryClick(btnQuery);
end;

procedure TfrmCom_Planner_List02.cboEmpNoCheckGroupSelected(Sender: TObject; Index: Integer);
begin
  p_ClearPlaner(Self,Planner1,edtDateTime);
//btnQueryClick(btnQuery);
end;

procedure TfrmCom_Planner_List02.cboPeriodRadioGroupSelected(Sender: TObject; Index: Integer);
begin
  p_ClearPlaner(Self,Planner1,edtDateTime);
//btnQueryClick(btnQuery);
end;

procedure TfrmCom_Planner_List02.edtDateTimeClosePicker(Sender: TObject);
begin
  p_ClearPlaner(Self,Planner1,edtDateTime);
//btnQueryClick(btnQuery);
end;






procedure TfrmCom_Planner_List02.sbtInsert1Click(Sender: TObject);
begin
  g_Sel_ActionKind := 0;
  g_Sel_Gubun      :='0';
  g_Data_Updated   := false;
  Application.CreateForm(TfrmCom_Vacation_Insert,frmCom_Vacation_Insert);
  frmCom_Vacation_Insert.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
end;

procedure TfrmCom_Planner_List02.sbtInsert2Click(Sender: TObject);
begin
  g_Sel_ActionKind := 0;
  g_Sel_Gubun      :='0';
  g_Data_Updated   := false;
  Application.CreateForm(TfrmCrm_Marketing_Detail,frmCrm_Marketing_Detail);
  frmCrm_Marketing_Detail.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
end;

procedure TfrmCom_Planner_List02.sbtInsert3Click(Sender: TObject);
begin
  g_Sel_ActionKind := 0;
  g_Sel_Gubun      :='0';
  g_Data_Updated   := false;
  Application.CreateForm(TfrmCom_RentCar_Detail,frmCom_RentCar_Detail);
  frmCom_RentCar_Detail.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
end;

procedure TfrmCom_Planner_List02.btnCloseClick(Sender: TObject);
begin
  Self.Close;
end;


procedure TfrmCom_Planner_List02.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;

procedure TfrmCom_Planner_List02.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
var
  FService : IFMXVirtualKeyboardService;
begin
  if (Key = vkHardwareBack) then begin
    TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, IInterface(FService));
    if (FService <> nil) and (TVirtualKeyboardState.Visible in FService.VirtualKeyBoardState) then begin
    end
    else begin
      Self.Close;
    end;
  end;
end;

procedure TfrmCom_Planner_List02.ChangeTab_Left;
begin
  case cboPeriod.ItemIndex of
    0: edtDateTime.DateTime := IncDay         (edtDateTime.DateTime,+1);
    1: edtDateTime.DateTime := IncDay         (edtDateTime.DateTime,+3);
    2: edtDateTime.DateTime := EndOfTheWeek   (edtDateTime.DateTime)+1;
    3: edtDateTime.DateTime := EndOfTheMonth  (edtDateTime.DateTime)+1;
  end;
  btnQueryClick(btnQuery);
end;

procedure TfrmCom_Planner_List02.ChangeTab_Right;
begin
  case cboPeriod.ItemIndex of
    0: edtDateTime.DateTime := IncDay         (edtDateTime.DateTime,-1);
    1: edtDateTime.DateTime := IncDay         (edtDateTime.DateTime,-3);
    2: edtDateTime.DateTime := StartOfTheWeek (edtDateTime.DateTime)-1;
    3: edtDateTime.DateTime := StartOfTheMonth(edtDateTime.DateTime)-1;
  end;
  btnQueryClick(btnQuery);
end;


procedure TfrmCom_Planner_List02.Planner1Gesture(Sender: TObject; const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
  Case EventInfo.GestureID of
    sgiLeft : ChangeTab_Left();
    sgiRight: ChangeTab_Right();
  End;
end;

procedure TfrmCom_Planner_List02.Planner1GetPositionText(Sender: TObject; APosition: Integer; AKind: TTMSFMXPlannerCacheItemKind; var AText: string);
begin
  Case cboPeriod.ItemIndex of
    0: AText := FormatDateTime('YYYY-MM-DD(DDD)',edtDateTime.DateTime+APosition);
    1: AText := FormatDateTime('MM-DD(DDD)',edtDateTime.DateTime+APosition);
    2: AText := FormatDateTime('D(DDD)',edtDateTime.DateTime+APosition);
    3: AText := FormatDateTime('D',edtDateTime.DateTime+APosition);
  End;
end;

initialization
   RegisterClasses([TfrmCom_Planner_List02]);

finalization
   UnRegisterClasses([TfrmCom_Planner_List02]);



end.
