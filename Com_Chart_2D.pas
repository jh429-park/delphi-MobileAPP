unit Com_Chart_2D;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMXTee.Engine,FMXTee.Procs, FMXTee.Chart, FMXTee.Series, FMX.StdCtrls,
  System.Threading,
  System.UIConsts,
  FMX.Controls.Presentation, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, FMX.Layouts, FMXTee.Chart.Functions,
  FMX.Objects;

type
  TfrmCom_Chart_2D = class(TForm)
    HeaderToolBar: TToolBar;
    MenuButton: TButton;
    btnQuery: TButton;
    Label_Title: TLabel;
    Layout_Chart: TLayout;
    Chart1: TChart;
    LineSeries1: TLineSeries;
    Layout1: TLayout;
    CheckBox_3D: TCheckBox;
    CheckBox_Sort: TCheckBox;
    ListView1: TListView;
    Rectangle_Detail: TRectangle;
    CornerButton_Detail: TCornerButton;
    procedure btnQueryClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure CheckBox_3DChange(Sender: TObject);
    procedure ListView1ItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure Chart1ClickSeries(Sender: TCustomChart; Series: TChartSeries;
      ValueIndex: Integer; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure CheckBox_SortChange(Sender: TObject);
    procedure MenuButtonClick(Sender: TObject);
    procedure CornerButton_DetailClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCom_Chart_2D: TfrmCom_Chart_2D;
  l_Height:Single;

implementation

{$R *.fmx}

uses Com_function,Com_Variable,Com_DataModule, Com_MasterDetail_Office;

procedure TfrmCom_Chart_2D.FormCreate(Sender: TObject);
begin
  chart1.visible := false;
  TTask.Run(procedure
  begin
    sleep(35);
    TThread.Synchronize(nil, procedure
    begin
      chart1.visible := true;
      btnQueryClick(Sender);
    end);
  end);
end;


procedure TfrmCom_Chart_2D.FormShow(Sender: TObject);
begin
  l_Height := Layout_Chart.Height;
  Label_Title.Text := g_Sel_Title;
end;



procedure TfrmCom_Chart_2D.ListView1ItemClick(const Sender: TObject; const AItem: TListViewItem);
var i,s:integer;
begin
  g_Sel_Title := AItem.Text;
  CornerButton_Detail.Text := AItem.Text;
  for s:=0 to Chart1.SeriesCount-1 do begin
    for i:=0 to Chart1.Series[s].Count-1 do begin
      if AItem.TagString = Chart1.Series[s].Labels.Labels[i] then begin
         Chart1.Series[s].ValueColor[i] := TAlphaColors.Black;
      end
      else begin
         Chart1.Series[s].ValueColor[i] := f_Chart_Color(ListView1.Items[i].Tag);
      end;
    end;
  end;
end;

procedure TfrmCom_Chart_2D.MenuButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCom_Chart_2D.Chart1ClickSeries(Sender: TCustomChart;
  Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var i,j:integer;
begin
  for i:=0 to Series.Count-1 do begin
    for j:=0 to ListView1.ItemCount-1 do begin
      if ListView1.Items[j].TagString = Series.Labels.Labels[i] then begin
         Series.ValueColor[i] := f_Chart_Color(ListView1.Items[j].Tag);
      end;
    end;
  end;

  for i:=0 to ListView1.ItemCount-1 do begin
    if ListView1.Items[i].TagString = Series.Labels.Labels[ValueIndex] then begin
       ListView1.ItemIndex  := i;
       ListView1.ScrollTo(i);
       ListView1ItemClick(Sender,ListView1.Items[i]);
    end;
  end;

  Series.ValueColor[ValueIndex] := TAlphaColors.Black;


end;

procedure TfrmCom_Chart_2D.btnQueryClick(Sender: TObject);
var i:integer;
    v:Double;
    s:String;
    c:TAlphaColor;
    v_ListViewItem:TListViewItem;
begin
  g_Sel_Title              := '';
  CornerButton_Detail.Text := '';
  Chart1.BeginUpdate;
  Chart1.View3D := CheckBox_3D.IsChecked;
//Chart1.ClearChart;
  Chart1.Title.Visible  := false;
  Chart1.Legend.Visible := false;
  Chart1.RemoveAllSeries;
  ListView1.BeginUpdate;
  ListView1.Items.Clear;
  ListView1.CanSwipeDelete:= false;
  with frmCom_DataModule.ClientDataSet_Proc,Chart1 do begin
    p_CreatePrams;
    ParamByName('arg_ModCd'  ).AsString := g_Sel_Url;
    ParamByName('arg_Company').AsString := g_Sel_Company;
    ParamByName('arg_Dept'   ).AsString := g_Sel_Dept;
    ParamByName('arg_EmpNo'  ).AsString := g_Sel_EmpNo;
    ParamByName('arg_TEXT01' ).AsString := '';
    Open;
    AddSeries(TBarSeries.Create(Self));
    AddSeries(TLineSeries.Create(Self));
    Series[0].Clear;
    Series[0].Title := FieldByName('Title' ).AsString;
    Series[1].Clear;
    Series[1].Title := FieldByName('Title' ).AsString;
    TBarSeries(Series[0]).Marks.Arrow.Visible := true;
    TBarSeries(Series[0]).Marks.Visible       := true;
    TBarSeries(Series[0]).Marks.Style         := smsValue;
    TBarSeries(Series[0]).Marks.Font.Size     := 7;
  //TLineSeries(Series[1]).Marks.Visible := true;
  //TLineSeries(Series[1]).Marks.Style   := smsValue;
    for i:=0 to RecordCount-1 do begin
      c                        := f_Chart_Color(i);
      v_ListViewItem           := ListView1.Items.Add;
      v_ListViewItem.Height    := FieldByName('ITEM_HEIGHT').AsInteger;
      v_ListViewItem.Tag       := FieldByName('Tag'        ).AsInteger;
      v_ListViewItem.TagString := FieldByName('TagString'  ).AsString;
      v_ListViewItem.Text      := FieldByName('Text'       ).AsString;
      v_ListViewItem.Detail    := FieldByName('DETAIL'     ).AsString;
      v_ListViewItem.Objects.TextObject.TextColor := StringToAlphaColor(FieldByName('TEXT_COLOR').AsString);
      v := FieldByName('VALUE'    ).AsFloat;
      s := FieldByName('TagString').AsString;
      Series[0].AddXY(i,v,s,c);
      Series[1].AddXY(i,v,s,c);
      Next;
    end;
    Close;
  end;

  if ListView1.ItemCount>0 then begin
     ListView1.ItemIndex := 0;
     ListView1.ScrollTo(0);
     ListView1ItemClick(Sender,ListView1.Items[0]);
  end;

  if CheckBox_Sort.IsChecked then CheckBox_SortChange(Sender);
  ListView1.EndUpdate;
  Chart1.EndUpdate;

end;



procedure TfrmCom_Chart_2D.CheckBox_3DChange(Sender: TObject);
begin
  Chart1.View3D := CheckBox_3D.IsChecked;
end;

procedure TfrmCom_Chart_2D.CheckBox_SortChange(Sender: TObject);
var i:integer;
begin
  for i:=0 to Chart1.SeriesCount-1 do begin
    if CheckBox_Sort.IsChecked then begin
       Chart1.Series[i].XValues.Order := TChartListOrder.loNone;
       Chart1.Series[i].YValues.Order := TChartListOrder.loAscending;
       Chart1.Series[i].YValues.Sort;
       Chart1.Series[i].XValues.FillSequence;
       Chart1.Series[i].Repaint;
    end
    else begin
       Chart1.Series[i].XValues.Order := TChartListOrder.loNone;
       Chart1.Series[i].YValues.Order := TChartListOrder.loDescending;
       Chart1.Series[i].YValues.Sort;
       Chart1.Series[i].XValues.FillSequence;
       Chart1.Series[i].Repaint;
    end;
  end;
  Chart1.Series[0].ValueColor[ListView1.ItemIndex] := TAlphaColors.Gray;


end;

procedure TfrmCom_Chart_2D.CornerButton_DetailClick(Sender: TObject);
begin
  if ListView1.ItemIndex>=0 then begin
    g_Sel_Action_Name := 'Com_DB_Office';
    g_Sel_Text01 := ListView1.Items[ListView1.ItemIndex].TagString;
    g_Sel_Text02 := '';
    frmCom_MasterDetail_Office := TfrmCom_MasterDetail_Office.Create(nil);
    frmCom_MasterDetail_Office.ShowModal(procedure(ModalResult : TModalResult) begin if ModalResult = mrOK then; end);
  end;
end;

procedure TfrmCom_Chart_2D.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;



end.
