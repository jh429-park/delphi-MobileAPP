unit Com_Meeting_Schedule;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Platform,
  FMX.VirtualKeyboard,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.TMSBaseControl, FMX.TMS7SegLed, FMX.Layouts, FMX.Controls.Presentation,
  FMX.StdCtrls, FMX.TMSGauge, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, FMX.TMSPassLock,System.DateUtils,
  FMX.Ani, FMX.Edit, FMX.EditBox, FMX.NumberBox, FMX.DateTimeCtrls, FMX.ListBox,
  System.IOUtils,FMX.Media, FMX.SpinBox, FMX.MultiView;

type
  TfrmCom_Meeting_Schedule = class(TForm)
    Timer1: TTimer;
    HeaderToolBar: TToolBar;
    btnQuery: TButton;
    Label_Title: TLabel;
    Layout_Timer: TLayout;
    Layout_Meeting: TLayout;
    AniIndicator1: TAniIndicator;
    TMSFMXClock1: TTMSFMXClock;
    Layout_Schedule: TLayout;
    Layout1: TLayout;
    Layout_TimeJan: TLayout;
    Led11: TTMSFMX7SegLEDShape;
    Led32: TTMSFMX7SegLEDShape;
    Led31: TTMSFMX7SegLEDShape;
    Led22: TTMSFMX7SegLEDShape;
    Led21: TTMSFMX7SegLEDShape;
    Led12: TTMSFMX7SegLEDShape;
    Lbl10: TLabel;
    Lbl20: TLabel;
    Layout8: TLayout;
    Label_MeetingRoom: TLabel;
    Label_MeetingTime: TLabel;
    Layout_Button: TLayout;
    btnCancel: TButton;
    btnPause: TButton;
    btnStart: TButton;
    btnStop: TButton;
    lbl_Message: TLabel;
    Label_MeetingMemo: TLabel;
    Layout4: TLayout;
    btnInsertNew: TButton;
    Button1: TButton;
    Label_MeetingTitle: TLabel;
    Layout_SelTime: TLayout;
    Label2: TLabel;
    Label3: TLabel;
    edtMinutes: TSpinBox;
    btnDelete: TButton;
    MediaPlayer1: TMediaPlayer;
    FloatAnimation1: TFloatAnimation;
    Layout_InsertNew: TLayout;
    Layout7: TLayout;
    lblRoom: TLabel;
    cboRoom: TComboBox;
    Layout10: TLayout;
    lblTitle: TLabel;
    edtDate: TDateEdit;
    Layout11: TLayout;
    lblDate: TLabel;
    Layout5: TLayout;
    edtTimeFr: TTimeEdit;
    edtTimeTo: TTimeEdit;
    Layout6: TLayout;
    btnSave: TButton;
    btnSaveCancel: TButton;
    Layout2: TLayout;
    lblTime: TLabel;
    edtTitle: TEdit;
    Layout3: TLayout;
    Label1: TLabel;
    edtMember: TEdit;
    Layout9: TLayout;
    Text1: TText;
    edtDateFr_Query: TDateEdit;
    Layout12: TLayout;
    Text2: TText;
    cboRoom_Query: TComboBox;
    edtDateTo_Query: TDateEdit;
    Text3: TText;
    btnClose: TButton;
    ListView_Meeting: TListView;


    procedure p_QueryDetail(Sender:TObject; aTagString:String);

    procedure p_SetLed_Value(aSecond:integer);
    procedure p_SetLed_Visible(h,m:integer);
    procedure p_SetLed_Position;
    procedure p_SetLed_Clear;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure btnPauseClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnQueryClick(Sender: TObject);
    procedure ListView_MeetingItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure btnStopClick(Sender: TObject);
    procedure btnInsertNewClick(Sender: TObject);
    procedure btnSaveCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure edtTimeFrClosePicker(Sender: TObject);
    procedure edtMinutesChange(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure edtDateFr_QueryChange(Sender: TObject);
    procedure edtDateTo_QueryChange(Sender: TObject);
    procedure cboRoom_QueryClosePopup(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCom_Meeting_Schedule: TfrmCom_Meeting_Schedule;

  v_second,h,m,s :integer;

  l_Meeting_No :String;
  l_Time_Fr    :TDateTime;
  l_Time_To    :TDateTime;
  l_Time_Start :TDateTime;
  l_Time_End   :TDateTime;

  l_Minute  : Integer;
  l_Second  : Integer;
  l_Pause   : Boolean=false;
  l_Room    : Array of String;

implementation

{$R *.fmx}

uses Com_function,Com_Variable,Com_DataModule, MainMenu;



procedure TfrmCom_Meeting_Schedule.edtDateFr_QueryChange(Sender: TObject);
var v_DateTimeFr:TDateTime;
var v_DateTimeTo:TDateTime;
begin
  v_DateTimeFr := edtDateFr_Query.DateTime;
  v_DateTimeTo := edtDateTo_Query.DateTime;
  if edtDateFr_Query.Date > edtDateTo_Query.Date then edtDateTo_Query.DateTime:=edtDateFr_Query.DateTime;
  if (v_DateTimeFr <> edtDateFr_Query.DateTime) or
     (v_DateTimeTo <> edtDateTo_Query.DateTime) then btnQueryClick(Self);
end;

procedure TfrmCom_Meeting_Schedule.edtDateTo_QueryChange(Sender: TObject);
var v_DateTimeFr:TDateTime;
var v_DateTimeTo:TDateTime;
begin
  v_DateTimeFr := edtDateFr_Query.DateTime;
  v_DateTimeTo := edtDateTo_Query.DateTime;
  if edtDateFr_Query.Date > edtDateTo_Query.Date then edtDateFr_Query.DateTime:=edtDateTo_Query.DateTime;
  if (v_DateTimeFr <> edtDateFr_Query.DateTime) or
     (v_DateTimeTo <> edtDateTo_Query.DateTime) then btnQueryClick(Self);
end;


procedure TfrmCom_Meeting_Schedule.FormShow(Sender: TObject);
var i:integer;
begin

  edtDateFr_Query.Format   := 'YYYY-MM-DD';
  edtDateTo_Query.Format   := 'YYYY-MM-DD';
  edtDateFr_Query.DateTime := Trunc(Now);
  edtDateTo_Query.DateTime := Trunc(IncDay(Now,+03));


  btnCancel.Visible       := true;

  AniIndicator1.Align     := Fmx.Types.TAlignLayout.Client;
  Layout_Timer.Visible    := false;
  Layout_Timer.Align      := Fmx.Types.TAlignLayout.Client;

  Layout_InsertNew.Visible:= false;
  Layout_InsertNew.Align  := Fmx.Types.TAlignLayout.Center;

  Layout_Meeting.Visible := true;
  Layout_Meeting.Align   := Fmx.Types.TAlignLayout.Client;

  l_minute               := 60;
  Timer1.Enabled         := false;
  TMSFMXClock1.ClockTime := Time;

  p_SetLed_Clear;

  Label_Title.Text := g_Sel_Title;


  with frmCom_DataModule.ClientDataSet_Proc do begin
    try
      p_CreatePrams;
      ParamByName('arg_ModCd'  ).AsString := 'MEETING_ROOM_CODE';
      Open;
      setLength(l_Room,RecordCount+1);
      cboRoom.Clear;
      cboRoom_Query.Clear;
      cboRoom.Items.Add('');
      cboRoom_Query.Items.Add('전체');
      l_Room[0] := '';
      for i:=1 to RecordCount do begin
        cboRoom_Query.Items.Add(FieldByName('CD_DNAME').AsString);
        cboRoom.Items.Add(FieldByName('CD_DNAME').AsString);
        l_Room[i] := FieldByName('CD_DCODE').AsString;
        Next;
      end;
      cboRoom_Query.ItemIndex := 0;
      cboRoom.ItemIndex := 0;
    finally
      Close;
    end;
  end;

  btnQueryClick(Sender);
//Button1Click(Sender)
end;


procedure TfrmCom_Meeting_Schedule.btnSaveCancelClick(Sender: TObject);
begin
  Layout_InsertNew.Visible := false;
  Layout_Meeting.Visible   := true;
  Layout_Timer.Visible     := false;
  Layout_Meeting.BringToFront;
end;


procedure TfrmCom_Meeting_Schedule.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCom_Meeting_Schedule.btnDeleteClick(Sender: TObject);
begin



  with frmCom_DataModule.ClientDataSet_Proc do begin
    try
      p_CreatePrams;
      ParamByName('arg_ModCd'  ).AsString := 'MEETING_SCHEDULE_DELETE';
      ParamByName('arg_TEXT01' ).AsString := l_Meeting_No; //MEETING_NO
      Open;
      if RecordCount=0 then begin
         ListView_Meeting.Items.Delete(ListView_Meeting.ItemIndex);
         ListView_Meeting.ItemIndex := -1;
         p_Toast('삭제되었습니다');
         frmMainMenu.Com_Marketing_ScheduleExecute;
      end;
    finally
      Close;
    end;
  end;
  p_SetLed_Clear;

  Timer1.Enabled           := false;
  l_Pause                  := false;
  Layout_Timer.Visible     := false;
  Layout_InsertNew.Visible := false;
  Layout_Meeting.Visible   := true;
  Layout_Meeting.BringToFront;
end;





procedure TfrmCom_Meeting_Schedule.btnSaveClick(Sender: TObject);
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

  if cboRoom.ItemIndex<=0 then begin
    p_Toast('예약회의실을선택하세요');
    cboRoom.SetFocus;
    Exit;
  end;




  with frmCom_DataModule.ClientDataSet_Proc do begin
    try
      p_CreatePrams;
      ParamByName('arg_ModCd'  ).AsString := 'MEETING_SCHEDULE_INSERT';
      ParamByName('arg_TEXT01' ).AsString := edtTitle.Text;
      ParamByName('arg_TEXT02' ).AsString := l_Room[cboRoom.ItemIndex];
      ParamByName('arg_TEXT03' ).AsString := FormatDateTime('YYYYMMDD',edtDate.Date)+FormatDateTime('HHNN',edtTimeFr.DateTime)+'00';
      ParamByName('arg_TEXT04' ).AsString := FormatDateTime('YYYYMMDD',edtDate.Date)+FormatDateTime('HHNN',edtTimeTo.DateTime)+'00';
      ParamByName('arg_TEXT05' ).AsString := '';
      ParamByName('arg_TEXT06' ).AsString := '';
      ParamByName('arg_TEXT07' ).AsString := edtMember.Text;
      Open;
      if Fields[0].AsInteger=1 then begin
        Layout_InsertNew.Visible := false;
        Layout_Meeting.Visible   := true;
        Layout_Timer.Visible     := false;
        Layout_Meeting.BringToFront;
        btnQueryClick(Sender);
        frmMainMenu.Com_Marketing_ScheduleExecute;
      end
      else begin
        ShowMessage('해당 시간에 기예약건이 있습니다.');
      end;
    finally
      Close;
    end;
  end;


end;



procedure TfrmCom_Meeting_Schedule.btnStartClick(Sender: TObject);
begin
  btnStart. Visible := false;
  btnStop.  Visible := true;
//btnPause. Visible := true;
  btnCancel.Visible := true;
  btnDelete.Visible := false;

//btnPause. Align   := Fmx.Types.TAlignLayout.MostLeft;
  btnStop.  Align   := Fmx.Types.TAlignLayout.MostLeft;
  btnCancel.Align   := Fmx.Types.TAlignLayout.Client;

//btnPause. width   := Layout_Button.Width/5*2;
  btnStop.  width   := Layout_Button.Width/3*2;
  btnCancel.width   := Layout_Button.Width/3;

  if Layout_SelTime.Visible then begin
     l_Time_Fr      := Now;
     l_Time_To      := IncMinute(l_Time_Fr,StrToInt(edtMinutes.Value.ToString));
     l_Time_Start   := l_Time_Fr;
     l_Time_End     := l_Time_To;
     Label_MeetingTime.Text := FormatDateTime('HH:NN:SS',l_Time_Fr)+' ~ '
                              +FormatDateTime('HH:NN:SS',l_Time_To);
  end;

  if not l_Pause then begin
     p_SetLed_Clear;
  end;

  Timer1.Enabled    := true;

end;


procedure TfrmCom_Meeting_Schedule.btnStopClick(Sender: TObject);
var r:Integer;
begin
  MediaPlayer1.Stop;
  Timer1.Enabled    := false;
  l_Pause           := false;
  btnStart. Visible := false;
  btnStop.  Visible := false;
  btnPause. Visible := false;
  btnCancel.Visible := true;
  btnCancel.Align   := Fmx.Types.TAlignLayout.Client;
  r := -1;
  with frmCom_DataModule.ClientDataSet_Proc do begin
    try
      p_CreatePrams;
      ParamByName('arg_ModCd'  ).AsString := 'MEETING_SCHEDULE_END';
      ParamByName('arg_TEXT01' ).AsString := l_Meeting_No;
      Open;
      if (RecordCount=1) and (Fields[0].AsInteger=1) then begin
          r := 1;
          p_Toast('종료처리되었습니다.');
      end else
      if (RecordCount=1) and (Fields[0].AsInteger<>1) then begin
          r := 0;
          p_Toast('처리불가.');
      end
      else begin
          r := -1;
          p_Toast('System Error');
      end;
    finally
      Close;
    end;
  end;

  if r=1 then btnQueryClick(btnQuery);

end;


procedure TfrmCom_Meeting_Schedule.Button1Click(Sender: TObject);
begin
  p_SetLed_Clear;

  edtMinutes.Value           := 30;
  Layout_SelTime.Visible     := true;
  Label_MeetingTitle.Visible := false;

  Timer1.Enabled    := false;
  l_Pause           := false;
  btnStart. Visible := true;
  btnStop.  Visible := false;
  btnPause. Visible := false;
  btnCancel.Visible := true;

  btnDelete.Visible := false;

  btnStart.Align    := Fmx.Types.TAlignLayout.MostLeft;
  btnCancel.Align   := Fmx.Types.TAlignLayout.Client;
  btnStart. width   := Layout_Button.Width/3*2;
  btnCancel.width   := Layout_Button.Width/3;

  Layout_Meeting.Visible   := false;
  Layout_Timer.Visible     := true;
  Layout_InsertNew.Visible := false;
  Layout_Timer.BringToFront;

  Label_MeetingTitle.Text  := '';
  Label_MeetingTime. Text  := '';
  Label_MeetingRoom. Text  := '';
  Label_MeetingMemo. Text  := '';

  p_SetLed_Value(Trunc(edtMinutes.Value*60));

end;


procedure TfrmCom_Meeting_Schedule.cboRoom_QueryClosePopup(Sender: TObject);
begin
  btnQueryClick(Self);
end;

procedure TfrmCom_Meeting_Schedule.edtMinutesChange(Sender: TObject);
begin
  p_SetLed_Value(Trunc(edtMinutes.Value*60));

end;

procedure TfrmCom_Meeting_Schedule.edtTimeFrClosePicker(Sender: TObject);
begin
  edtTimeTo.DateTime := IncMinute(edtTimeFr.DateTime,60);

//  with frmCom_DataModule.ClientDataSet_Proc do begin
//    try
//      p_CreatePrams;
//      ParamByName('arg_ModCd'  ).AsString := 'MEETING_SCHEDULE_Check';
//      ParamByName('arg_TEXT01' ).AsString := FormatDateTime('YYYYMMDD',edtDate.Date)+FormatDateTime('HHNN',edtTimeFr.DateTime)+'00';
//      ParamByName('arg_TEXT02' ).AsString := FormatDateTime('YYYYMMDD',edtDate.Date)+FormatDateTime('HHNN',edtTimeTo.DateTime)+'00';
//      Open;
//      if (RecordCount=1) and (Fields[0].AsInteger=1) then begin
//        Layout_InsertNew.Visible := false;
//        Layout_Meeting.Visible   := true;
//        Layout_Timer.Visible     := false;
//        Layout_Meeting.BringToFront;
//      end
//      else begin
//        ShowMessage('System Error');
//      end;
//    finally
//      Close;
//    end;
//  end;



end;

procedure TfrmCom_Meeting_Schedule.btnCancelClick(Sender: TObject);
begin
  MediaPlayer1.Stop;
  Timer1.Enabled         := false;
  l_Pause                := false;
  Layout_Meeting.Visible := true;
  Layout_Timer.Visible   := false;
  Layout_Meeting.BringToFront;
  p_SetLed_Clear;

end;


procedure TfrmCom_Meeting_Schedule.btnPauseClick(Sender: TObject);
begin
  MediaPlayer1.Stop;
  Timer1.Enabled    := false;
  l_Pause           := true;

  btnStart. Visible := true;
  btnStop.  Visible := true;
  btnPause. Visible := false;
  btnCancel.Visible := true;

  btnStart. Align   := Fmx.Types.TAlignLayout.MostLeft;
  btnStop.  Align   := Fmx.Types.TAlignLayout.Client;
  btnCancel.Align   := Fmx.Types.TAlignLayout.MostRight;

  btnStart. width   := Layout_Button.Width/5*2;
  btnStop.  width   := Layout_Button.Width/5*2;
  btnCancel.width   := Layout_Button.Width/5;

end;



procedure TfrmCom_Meeting_Schedule.Timer1Timer(Sender: TObject);
var v_Timer:Boolean;
begin
  v_Timer:=Timer1.Enabled;
  Timer1.Enabled := false;

  if Now < l_Time_Fr then begin
     l_Time_To := IncSecond(Now,SecondsBetween(l_Time_Fr,l_Time_To));
     l_Time_Fr := Now;
  end
  else begin
     l_Time_Fr := Now;
  end;
  v_second := SecondsBetween(l_Time_Fr,l_Time_To);
  if  Now > l_Time_To then v_second := v_second*(-1);

  if v_second < 0 then begin
     Led11.FillActive.Color :=  TAlphaColors.Gray;
     Led12.FillActive.Color :=  TAlphaColors.Gray;
     Led21.FillActive.Color :=  TAlphaColors.Gray;
     Led22.FillActive.Color :=  TAlphaColors.Gray;
     Led31.FillActive.Color :=  TAlphaColors.Gray;
     Led32.FillActive.Color :=  TAlphaColors.Gray;
     Lbl10.TextSettings.FontColor := TAlphaColors.Gray;
     Lbl20.TextSettings.FontColor := TAlphaColors.Gray;
     lbl_Message.Text       :=  '회의 예정시간을 초과했습니다.';
     FloatAnimation1.Enabled:= true;
     FloatAnimation1.Start;
   //MediaPlayer1.FileName  := GetHomePath() + PathDelim + 'alert.mp3';
   //TPath.GetHomePath()+TPath.DirectorySeparatorChar+'alert.mp3'
   //Label_Title.Text := GetHomePath() + PathDelim + 'alert.mp3';
   //if TFile.Exists(MediaPlayer1.FileName) then MediaPlayer1.Play;
  end
  else
  if (v_second <= 60) then begin
     Led11.FillActive.Color :=  TAlphaColors.OrangeRed;
     Led12.FillActive.Color :=  TAlphaColors.OrangeRed;
     Led21.FillActive.Color :=  TAlphaColors.OrangeRed;
     Led22.FillActive.Color :=  TAlphaColors.OrangeRed;
     Led31.FillActive.Color :=  TAlphaColors.OrangeRed;
     Led32.FillActive.Color :=  TAlphaColors.OrangeRed;
     Lbl10.TextSettings.FontColor := TAlphaColors.OrangeRed;
     Lbl20.TextSettings.FontColor := TAlphaColors.OrangeRed;
  end
  else
  if (v_second <= 300) then begin
     Led11.FillActive.Color :=  TAlphaColors.Orange;
     Led12.FillActive.Color :=  TAlphaColors.Orange;
     Led21.FillActive.Color :=  TAlphaColors.Orange;
     Led22.FillActive.Color :=  TAlphaColors.Orange;
     Led31.FillActive.Color :=  TAlphaColors.Orange;
     Led32.FillActive.Color :=  TAlphaColors.Orange;
     Lbl10.TextSettings.FontColor := TAlphaColors.Orange;
     Lbl20.TextSettings.FontColor := TAlphaColors.Orange;
  end
  else begin
     Led11.FillActive.Color :=  TAlphaColors.Lightseagreen;
     Led12.FillActive.Color :=  TAlphaColors.Lightseagreen;
     Led21.FillActive.Color :=  TAlphaColors.Lightseagreen;
     Led22.FillActive.Color :=  TAlphaColors.Lightseagreen;
     Led31.FillActive.Color :=  TAlphaColors.Lightseagreen;
     Led32.FillActive.Color :=  TAlphaColors.Lightseagreen;
     Lbl10.TextSettings.FontColor := TAlphaColors.Lightseagreen;
     Lbl20.TextSettings.FontColor := TAlphaColors.Lightseagreen;
  end;
//  l_Time_To   := IncSecond(l_Time_To,-1);

  p_SetLed_Value(v_second);
  Timer1.Enabled := v_Timer;

end;


procedure TfrmCom_Meeting_Schedule.p_SetLed_Value(aSecond:integer);
var s:integer;
begin
  if aSecond<0 then s:=0 else s:=aSecond;
  h           := (S div 3600);
  m           := (S div 60) mod 60;
  s           := (S mod 60);
  Led11.Value := StrToInt(copy(FormatFloat('00',h),1,1));
  Led12.Value := StrToInt(copy(FormatFloat('00',h),2,1));
  Led21.Value := StrToInt(copy(FormatFloat('00',m),1,1));
  Led22.Value := StrToInt(copy(FormatFloat('00',m),2,1));
  Led31.Value := StrToInt(copy(FormatFloat('00',s),1,1));
  Led32.Value := StrToInt(copy(FormatFloat('00',s),2,1));

  p_SetLed_Visible(h,m);
  p_SetLed_Position;

end;

procedure TfrmCom_Meeting_Schedule.p_SetLed_Visible(h,m:integer);
begin
  Led11.Visible := h>0;
  Led12.Visible := h>0;
  Lbl10.Visible := h>0;
  Led21.Visible :=(h>0) or (m>0);
  Led22.Visible :=(h>0) or (m>0);
  Lbl20.Visible :=(h>0) or (m>0);
end;

procedure TfrmCom_Meeting_Schedule.p_SetLed_Clear;
begin

  FloatAnimation1.Enabled:= false;
  FloatAnimation1.Stop;


  l_Pause          := false;
  lbl_Message.Text := '';

  Led11.Value := 0;
  Led12.Value := 0;
  Led21.Value := 0;
  Led22.Value := 0;
  Led31.Value := 0;
  Led32.Value := 0;

  Led11.FillActive.Color       := Label_MeetingTitle.FontColor;
  Led12.FillActive.Color       := Label_MeetingTitle.FontColor;
  Led21.FillActive.Color       := Label_MeetingTitle.FontColor;
  Led22.FillActive.Color       := Label_MeetingTitle.FontColor;
  Led31.FillActive.Color       := Label_MeetingTitle.FontColor;
  Led32.FillActive.Color       := Label_MeetingTitle.FontColor;
  Lbl10.TextSettings.FontColor := Label_MeetingTitle.FontColor;
  Lbl20.TextSettings.FontColor := Label_MeetingTitle.FontColor;

  Led32.Visible  := true;
  Led31.Visible  := true;
  Lbl20.Visible  := true;
  Led22.Visible  := true;
  Led21.Visible  := true;
  Lbl10.Visible  := true;
  Led12.Visible  := true;
  Led11.Visible  := true;

  ;

  p_SetLed_Position;


end;

procedure TfrmCom_Meeting_Schedule.p_SetLed_Position;
begin
  Led11.Align := Fmx.Types.TAlignLayout.Right;
  Led12.Align := Fmx.Types.TAlignLayout.Right;
  Lbl10.Align := Fmx.Types.TAlignLayout.Right;
  Led21.Align := Fmx.Types.TAlignLayout.Right;
  Led22.Align := Fmx.Types.TAlignLayout.Right;
  Lbl20.Align := Fmx.Types.TAlignLayout.Right;
  Led31.Align := Fmx.Types.TAlignLayout.Right;
  Led32.Align := Fmx.Types.TAlignLayout.MostRight;
  Led32.Position.x  := Led32.Position.x;
  Led31.Position.x  := Led32.Position.x - Led32.Margins.Left - Led31.Width-1;
  Lbl20.Position.x  := Led31.Position.x - Led31.Margins.Left - Lbl20.Width-1;
  Led22.Position.x  := Lbl20.Position.x - Lbl20.Margins.Left - Led22.Width-1;
  Led21.Position.x  := Led22.Position.x - Led22.Margins.Left - Led21.Width-1;
  Lbl10.Position.x  := Led21.Position.x - Led21.Margins.Left - Lbl10.Width-1;
  Led12.Position.x  := Lbl10.Position.x - Lbl10.Margins.Left - Led12.Width-1;
  Led11.Position.x  := Led12.Position.x - Led12.Margins.Left - Led11.Width-1;
end;


procedure TfrmCom_Meeting_Schedule.btnQueryClick(Sender: TObject);
begin
  Layout_Meeting.Visible := true;
  Layout_Timer.Visible   := false;
  Layout_Meeting.BringToFront;
  AniIndicator1.Visible  := true;
  AniIndicator1.Enabled  := true;
  AniIndicator1.BringToFront;
  TThread.CreateAnonymousThread(procedure ()
  begin
    TThread.Synchronize (TThread.CurrentThread, procedure ()
    begin
      try
        with frmCom_DataModule.ClientDataSet_Proc do begin
          p_CreatePrams;
          ParamByName('arg_ModCd'  ).AsString := 'MEETING_SCHEDULE_LIST';
          ParamByName('arg_TEXT01' ).AsString := FormatDateTime('YYYYMMDD',edtDateFr_Query.Date);
          ParamByName('arg_TEXT02' ).AsString := FormatDateTime('YYYYMMDD',edtDateTo_Query.Date);
          ParamByName('arg_TEXT03' ).AsString := l_Room[cboRoom_Query.ItemIndex];
          f_Query_ListViewList(ListView_Meeting);
        end;
        if g_ShowEmpImage then p_loadImage_Emp_ListView(ListView_Meeting,1,true,true,false);
      finally
      end;
    end);
  end).Start;
  AniIndicator1.Visible := false;
  AniIndicator1.Enabled := false;
end;



procedure TfrmCom_Meeting_Schedule.ListView_MeetingItemClick(const Sender: TObject; const AItem: TListViewItem);
begin
  p_QueryDetail(Sender,AItem.TagString);
end;


procedure TfrmCom_Meeting_Schedule.p_QueryDetail(Sender:TObject; aTagString:String);
var v_StringList:TStringList;
begin
//p_SetLed_Visible(1,1);
  Layout_SelTime.Visible     := false;
  Label_MeetingTitle.Visible := true;

  l_Meeting_No      := '';
  Timer1.Enabled    := false;
  l_Pause           := false;

  btnStart. Visible := false;
  btnCancel.Visible := true;
  btnStop.  Visible := false;
  btnPause. Visible := false;
  btnDelete.Visible := false;

  btnStart. Align   := Fmx.Types.TAlignLayout.MostLeft;
  btnDelete.Align   := Fmx.Types.TAlignLayout.Left;
  btnCancel.Align   := Fmx.Types.TAlignLayout.Client;

  btnStart. Width   := Layout_Button.Width/5*3;
  btnDelete.Width   := Layout_Button.Width/5*1;
  btnCancel.width   := Layout_Button.Width/5*1;

  Layout_Meeting.Visible   := false;
  Layout_Timer.Visible     := true;
  Layout_InsertNew.Visible := false;
  Layout_Timer.BringToFront;

  try
    v_StringList := TStringList.Create;
    with frmCom_DataModule.ClientDataSet_Proc do begin
      v_StringList.Clear;
      ExtractStrings([':'],[#0],PChar(aTagString),v_StringList);
      try
        p_CreatePrams;
        ParamByName('arg_ModCd'  ).AsString := 'MEETING_SCHEDULE_DETAIL';
        ParamByName('arg_TEXT01' ).AsString := v_StringList[02]; //MEETING_NO
        Open;
        Label_MeetingTitle.Text := FieldByName('MEETING_TITLE').AsString;
        Label_MeetingTime. Text := FieldByName('MEETING_TIME' ).AsString;
        Label_MeetingRoom. Text := FieldByName('MEETING_ROOM' ).AsString;
        Label_MeetingMemo. Text := FieldByName('MEETING_MEMO' ).AsString;

        l_Meeting_No            := FieldByName('MEETING_NO'   ).AsString;
        l_Time_Fr               := FieldByName('TIME_FR'      ).AsDateTime;
        l_Time_To               := FieldByName('TIME_TO'      ).AsDateTime;
        l_Time_Start            := FieldByName('TIME_START'   ).AsDateTime;
        l_Time_End              := FieldByName('TIME_END'     ).AsDateTime;

      //btnStart. Visible       := FieldByName('OK_OWNER'     ).AsString='Y';
        btnStart. Visible       := l_Time_Fr>now;
        btnDelete.Visible       := FieldByName('OK_OWNER'     ).AsString='Y';
      finally
        Close;
      end;
    end;
  finally
    frmCom_DataModule.ClientDataSet_Proc.Close;
    v_StringList.Free;
  end;

  p_SetLed_Value(SecondsBetween(l_Time_Fr,l_Time_To));

  if (l_Time_Fr<=now) and (l_Time_To>=now) then btnStartClick(Sender);

end;





procedure TfrmCom_Meeting_Schedule.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  MediaPlayer1.Stop;
  Timer1.Enabled := false;
  Action := TCloseAction.caFree;
end;

procedure TfrmCom_Meeting_Schedule.btnInsertNewClick(Sender: TObject);
begin
  l_Meeting_No             := '';
  if MinuteOf(Now)<30
     then edtDate.DateTime := IncMinute(IncMinute(Now,-(MinuteOf(Now))),30)
     else edtDate.DateTime := IncMinute(IncMinute(Now,-(MinuteOf(Now))),60);
  edtTimeFr.DateTime       := edtDate.DateTime;
  edtTimeTo.DateTime       := IncMinute(edtTimeFr.DateTime,60);
  edtTitle.Text            := '';
  cboRoom.ItemIndex        := cboRoom_Query.ItemIndex;

  btnSave.Enabled          := true;
  btnSave.Text             := '입력';

  Layout_InsertNew.Visible := true;
  Layout_InsertNew.BringToFront;
  Layout_Meeting.Visible   := false;
  Layout_Timer.Visible     := false;
end;


procedure TfrmCom_Meeting_Schedule.FormKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
var FService : IFMXVirtualKeyboardService;
begin
  if (Key = vkHardwareBack) then begin
    TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, IInterface(FService));
    if (FService <> nil) and (TVirtualKeyboardState.Visible in FService.VirtualKeyBoardState) then begin
    end
    else if Layout_InsertNew.Visible then begin
      Key := 0;
      btnSaveCancelClick(btnSaveCancel);
    end
    else begin
      Key := 0;
      Self.Close;
    end;
  end;
end;

procedure TfrmCom_Meeting_Schedule.FormResize(Sender: TObject);
begin
  if f_Screen_Landscape(Sender) then begin
    HeaderToolBar.Visible := false;
    Self.FullScreen       := true;
    Layout_Schedule.Align := Fmx.Types.TAlignLayout.MostRight;
    TMSFMXClock1.   Align := Fmx.Types.TAlignLayout.Center;
    Layout_Schedule.Width := Self.Width/2;
  //TMSFMXClock1.   Width := Self.Width/3;
  //TMSFMXClock1.   Height:= TMSFMXClock1.Width;
  end
  else begin
    HeaderToolBar.Visible := true;
    Self.FullScreen       := false;
    Layout_Schedule.Align := Fmx.Types.TAlignLayout.MostBottom;
    TMSFMXClock1.   Align := Fmx.Types.TAlignLayout.Center;
    Layout_Schedule.Height:= Self.Height/5*2;
  //TMSFMXClock1.   Height:= Self.Height/2;
  //TMSFMXClock1.   width := TMSFMXClock1.Height;
  end;

end;


initialization
   RegisterClasses([TfrmCom_Meeting_Schedule]);

finalization
   UnRegisterClasses([TfrmCom_Meeting_Schedule]);


end.

