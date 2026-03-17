unit Com_Planner_List01;

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
  FMX.TMSRadioGroupPicker, FMX.Gestures, FMX.TMSCheckGroupPicker,
  FMX.TMSBitmapContainer;

type
  TfrmCom_Planner_List01 = class(TForm)
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
    Label1: TLabel;
    Label2: TLabel;
    cboPeriod: TTMSFMXRadioGroupPicker;
    lblKind: TLabel;
    cboKind: TTMSFMXCheckGroupPicker;
    sbtInsert4: TSpeedButton;
    TMSFMXBitmapContainer1: TTMSFMXBitmapContainer;
    sbtInsert5: TSpeedButton;

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
    procedure sbtInsert4Click(Sender: TObject);
    procedure Planner1AfterDrawItem(Sender: TObject; ACanvas: TCanvas;
      ARect: TRectF; AItem: TTMSFMXPlannerItem);
    procedure FormCreate(Sender: TObject);
    procedure sbtInsert5Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  frmCom_Planner_List01: TfrmCom_Planner_List01;
  l_Action_Name:  String='';
  l_Action_Title: String='';


implementation

{$R *.fmx}

uses System.Math, Com_DataModule,Com_function,Com_Variable,MainMenu,
     Crm_Marketing_Detail, Com_Vacation_Insert, Com_RentCar_Detail,
  Com_Meeting_Detail, Com_WebBrowser, Com_Memo;


procedure TfrmCom_Planner_List01.FormCreate(Sender: TObject);
begin
{$IF Defined(MSWINDOWS)}
  cboPeriod.ItemIndex := 0; //2
{$ELSE}
  cboPeriod.ItemIndex := 0; //1
{$ENDIF}
end;

procedure TfrmCom_Planner_List01.FormShow(Sender: TObject);
begin
  l_Action_Name          := UpperCase(g_Sel_Action_Name);
  l_Action_Title         := g_Sel_Title;
  Label_Title.Text       := l_Action_Title;
  g_Sel_Action_Name      := '';
  g_Sel_Title            := '';
  edtDateTime.DateTime := Trunc(Now);

  p_SetChkCombo(cboKind,'PLANNER_KIND');
//for i:=0 to cboKind.Items.Count-1 do cboKind.IsChecked[i] := true;
  cboKind.IsChecked[0] := true;
  btnQueryClick(Sender);
end;

procedure TfrmCom_Planner_List01.FormActivate(Sender: TObject);
begin
  if g_Data_Updated then begin
     g_Data_Updated := false;
     btnQueryClick(Sender);
  end;
end;


procedure TfrmCom_Planner_List01.btnQueryClick(Sender: TObject);
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
    sbtInsert1.Visible     := true;
    sbtInsert2.Visible     := true;
    sbtInsert3.Visible     := true;
    sbtInsert4.Visible     := true;
    lblKind.Visible        := true;
    cboKind.Visible        := true;
    ParamByName('arg_ModCd' ).AsString := 'Com_Planner_List01';
    ParamByName('arg_DateFr').AsString := FormatDateTime('YYYYMMDD',v_DateFr);
    ParamByName('arg_DateTo').AsString := FormatDateTime('YYYYMMDD',v_DateTo);
    ParamByName('arg_Text01').AsString := f_GetChkCombo(cboKind, true);
    f_Query_PlanerList(Self,Planner1,v_DateFr,v_DateTo,false);
  end;
end;


procedure TfrmCom_Planner_List01.Planner1AfterDrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRectF; AItem: TTMSFMXPlannerItem);
var bmp: TBitmap;
    rbmp: TRectF;
begin
  if AItem.DataBoolean then begin
    if AItem.ConflictsForPosition(0) > 1 then begin
      bmp := TMSFMXBitmapContainer1.FindBitmap('item1');
      if Assigned(bmp) then begin
        rbmp := RectF(ARect.Right - 26, ARect.Bottom - 26, ARect.Right - 2, ARect.Bottom - 2);
        ACanvas.DrawBitmap(bmp, RectF(0, 0, bmp.Width, bmp.Height), rbmp, 1);
      end;
    end;
  end;
end;

procedure TfrmCom_Planner_List01.Planner1AfterSelectItem(Sender: TObject; AItem: TTMSFMXPlannerItem);
begin
  if AItem.DataBoolean then begin
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
        40:begin
             Application.CreateForm(TfrmCom_Meeting_Detail,frmCom_Meeting_Detail);
             frmCom_Meeting_Detail.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
           end;
        50:begin
             if (g_Sel_TagString[3]='W') and (g_Sel_TagString[4]<>'') then begin
               g_Sel_Title       := '부동산뉴스';
               g_Sel_Url         := g_Sel_TagString[4];//AItem.ButtonText;
               g_Sel_Code        := g_Sel_TagString[5];
               g_Sel_Action_Name := 'Com_Newspaper';
               Application.CreateForm(TfrmCom_WebBrowser,frmCom_WebBrowser);
               frmCom_WebBrowser.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
             end
             else begin
               g_Sel_Title       := '부동산뉴스';
               g_Sel_Url         := '';
               g_Sel_Code        := '';
               g_Sel_Action_Name := 'Com_Newspaper';
               Application.CreateForm(TfrmCom_Memo,frmCom_Memo);
               frmCom_Memo.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
             end;
           end;
      End;
    end;
  end;
end;



procedure TfrmCom_Planner_List01.cboEmpNoCheckGroupSelected(Sender: TObject; Index: Integer);
begin
//p_ClearPlaner(Self,Planner1,edtDateTime);
  btnQueryClick(btnQuery);
end;

procedure TfrmCom_Planner_List01.cboPeriodRadioGroupSelected(Sender: TObject; Index: Integer);
begin
//p_ClearPlaner(Self,Planner1,edtDateTime);
  btnQueryClick(btnQuery);
end;

procedure TfrmCom_Planner_List01.edtDateTimeClosePicker(Sender: TObject);
begin
//p_ClearPlaner(Self,Planner1,edtDateTime);
  btnQueryClick(btnQuery);
end;







procedure TfrmCom_Planner_List01.btnCloseClick(Sender: TObject);
begin
  Self.Close;
end;


procedure TfrmCom_Planner_List01.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;


procedure TfrmCom_Planner_List01.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
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

procedure TfrmCom_Planner_List01.ChangeTab_Left;
begin
  case cboPeriod.ItemIndex of
    0: edtDateTime.DateTime := IncDay         (edtDateTime.DateTime,+1);
    1: edtDateTime.DateTime := IncDay         (edtDateTime.DateTime,+3);
    2: edtDateTime.DateTime := EndOfTheWeek   (edtDateTime.DateTime)+1;
    3: edtDateTime.DateTime := EndOfTheMonth  (edtDateTime.DateTime)+1;
  end;
  btnQueryClick(btnQuery);
end;

procedure TfrmCom_Planner_List01.ChangeTab_Right;
begin
  case cboPeriod.ItemIndex of
    0: edtDateTime.DateTime := IncDay         (edtDateTime.DateTime,-1);
    1: edtDateTime.DateTime := IncDay         (edtDateTime.DateTime,-3);
    2: edtDateTime.DateTime := StartOfTheWeek (edtDateTime.DateTime)-1;
    3: edtDateTime.DateTime := StartOfTheMonth(edtDateTime.DateTime)-1;
  end;
  btnQueryClick(btnQuery);
end;


procedure TfrmCom_Planner_List01.Planner1Gesture(Sender: TObject; const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
  Case EventInfo.GestureID of
    sgiLeft : ChangeTab_Left();
    sgiRight: ChangeTab_Right();
  End;
end;

procedure TfrmCom_Planner_List01.Planner1GetPositionText(Sender: TObject; APosition: Integer; AKind: TTMSFMXPlannerCacheItemKind; var AText: string);
begin
  Case cboPeriod.ItemIndex of
    0: AText := FormatDateTime('YYYY-MM-DD(DDD)',edtDateTime.DateTime+APosition);
    1: AText := FormatDateTime('MM-DD(DDD)',edtDateTime.DateTime+APosition);
    2: AText := FormatDateTime('D(DDD)',edtDateTime.DateTime+APosition);
    3: AText := FormatDateTime('D',edtDateTime.DateTime+APosition);
  End;
end;


procedure TfrmCom_Planner_List01.sbtInsert1Click(Sender: TObject);
begin
  g_Sel_ActionKind := 0;
  g_Sel_Gubun      :='0';
  g_Data_Updated   := false;
  Application.CreateForm(TfrmCom_Vacation_Insert,frmCom_Vacation_Insert);
  frmCom_Vacation_Insert.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
end;

procedure TfrmCom_Planner_List01.sbtInsert2Click(Sender: TObject);
begin
  g_Sel_ActionKind := 0;
  g_Sel_Gubun      :='0';
  g_Data_Updated   := false;
  Application.CreateForm(TfrmCrm_Marketing_Detail,frmCrm_Marketing_Detail);
  frmCrm_Marketing_Detail.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
end;

procedure TfrmCom_Planner_List01.sbtInsert3Click(Sender: TObject);
begin
  g_Sel_ActionKind := 0;
  g_Sel_Gubun      :='0';
  g_Data_Updated   := false;
  Application.CreateForm(TfrmCom_RentCar_Detail,frmCom_RentCar_Detail);
  frmCom_RentCar_Detail.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
end;

procedure TfrmCom_Planner_List01.sbtInsert4Click(Sender: TObject);
begin
  g_Sel_ActionKind := 0;
  g_Sel_Gubun      :='0';
  g_Data_Updated   := false;
  Application.CreateForm(TfrmCom_Meeting_Detail,frmCom_Meeting_Detail);
  frmCom_Meeting_Detail.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
end;



procedure TfrmCom_Planner_List01.sbtInsert5Click(Sender: TObject);
begin
  g_Sel_ActionKind := 0;
  g_Sel_Gubun      :='0';
  g_Data_Updated   := false;
  Application.CreateForm(TfrmCrm_Marketing_Detail,frmCrm_Marketing_Detail);
  frmCrm_Marketing_Detail.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
end;

initialization
   RegisterClasses([TfrmCom_Planner_List01]);

finalization
   UnRegisterClasses([TfrmCom_Planner_List01]);



end.
