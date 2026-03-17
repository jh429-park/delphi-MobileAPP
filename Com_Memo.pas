unit Com_Memo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  System.Math.Vectors, FMX.StdCtrls, FMX.Objects, FMX.Controls.Presentation,
  FMX.ScrollBox, FMX.Memo, FMX.Ani, FMX.Layouts;

type
  TfrmCom_Memo = class(TForm)
    HeaderToolBar: TToolBar;
    Label_Title: TLabel;
    Memo: TMemo;
    btnQuery: TButton;
    btnClose: TButton;
    Layout1: TLayout;
    Label_Bottom: TLabel;
    Image_Detail: TImageControl;
    FloatAnimation1: TFloatAnimation;
    Label_Top: TLabel;
    Label_DateTime: TLabel;
    Text_Url: TText;
    procedure btnQueryClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ImageControl1Click(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure Image_DetailClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCom_Memo: TfrmCom_Memo;

implementation

{$R *.fmx}

uses Com_function,Com_Variable, Com_DataModule, Com_Image;

procedure TfrmCom_Memo.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCom_Memo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;

procedure TfrmCom_Memo.FormShow(Sender: TObject);
begin
  Label_Title.Text  := g_Sel_Title;
  btnQueryClick(Sender);
end;

procedure TfrmCom_Memo.btnQueryClick(Sender: TObject);
begin
  Memo.Lines.Clear;
  Label_Top.Text      := '';
  Label_Bottom.Text   := '';
  Label_DateTime.Text := '';
  Text_Url.Text       := '';
  with frmCom_DataModule.ClientDataSet_Proc do begin
    try
      p_CreatePrams;
      if UpperCase(g_Sel_Action_Name) = UpperCase('Com_Newspaper') then begin
         ParamByName('arg_ModCd'  ).AsString := 'Com_Newspaper_Detail';
         ParamByName('arg_TEXT01' ).AsString := g_Sel_TagString[0];
         Open;
         Memo.Text           := FieldByName('Detail'  ).AsString;
         Label_Top.Text      := FieldByName('Title'   ).AsString;
         Label_Bottom.Text   := FieldByName('Bottom'  ).AsString;
         Label_DateTime.Text := FieldByName('DateTime').AsString;
         Text_Url.Text       := FieldByName('WebAddr' ).AsString;
      end;
    finally
      Close;
    end;
    p_LoadImage_Emp_Small(Image_Detail.Bitmap,g_Sel_TagString[1],g_Sel_TagString[2]);
    Image_Detail.TagString := g_Sel_TagString[2]+'.jpg';
  end;
end;


procedure TfrmCom_Memo.ImageControl1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmCom_Memo.Image_DetailClick(Sender: TObject);
begin
  g_Sel_Url      := c_Image_Emp;
  g_Sel_FileName := Image_Detail.TagString;
  g_Sel_Title    := Label_Bottom.Text;
  Application.CreateForm(TfrmCom_Image,frmCom_Image);
  frmCom_Image.Show;
end;

initialization
   RegisterClasses([TfrmCom_Memo]);

finalization
   UnRegisterClasses([TfrmCom_Memo]);



end.

