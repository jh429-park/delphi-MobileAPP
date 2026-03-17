unit Com_Image;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  System.Math.Vectors, FMX.StdCtrls, FMX.Objects, FMX.Controls.Presentation;

type
  TfrmCom_Image = class(TForm)
    ImageControl1: TImageControl;
    Text_Title: TText;
    btnClose: TButton;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ImageControl1Click(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCom_Image: TfrmCom_Image;

implementation

{$R *.fmx}

uses Com_function,Com_Variable;

procedure TfrmCom_Image.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCom_Image.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;

procedure TfrmCom_Image.FormShow(Sender: TObject);
begin
  Text_Title.Text     := g_Sel_Title;
  p_LoadImage_Url_Large(ImageControl1.Bitmap,g_Sel_Url,g_Sel_FileName);
end;

procedure TfrmCom_Image.ImageControl1Click(Sender: TObject);
begin
  Close;
end;

initialization
   RegisterClasses([TfrmCom_Image]);

finalization
   UnRegisterClasses([TfrmCom_Image]);



end.

