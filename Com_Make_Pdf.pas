unit Com_Make_Pdf;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.TMSPDFLib,FMX.TMSGraphicsTypes, FMX.TMSCustomComponent, FMX.TMSPDFIO,
  FMX.TMSGridPDFIO, FMX.TMSBitmapContainer, FMX.Edit;

type
  TfrmCom_Make_Pdf = class(TForm)
    Button1: TButton;
    TMSFMXBitmapContainer1: TTMSFMXBitmapContainer;
    SaveDialog1: TSaveDialog;
    edtFileName: TEdit;
    Button2: TButton;
    HeaderToolBar: TToolBar;
    Label_Title: TLabel;
    btnClose: TButton;
    procedure p_GeneratePDF(AFileName: string);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCom_Make_Pdf: TfrmCom_Make_Pdf;
  l_FileName_Img1: String;
  l_FileName_Img2: String;
  l_FileName_Img3: String;
  l_FileName_Img4: String;

  l_Html: String = 'Lorem Ipsum is simply <b>dummy</b> text of the printing and typesetting industry. Lorem'+
                   'Ipsum has been the industry''s standard dummy'+
                   'text ever since the 1500s, when an <i><font color="gcOrange">unknown printer took a'+
                   'galley</font></i> of type and scrambled it to make a type specimen book. '+
                   'It has survived not only five <font size="16" color="gcRed">centuries</font>, but also the'+
                   '<sup>leap</sup> <sub>into</sub> <u>electronic</u> typeset'+
                   'ting, <br><br>remaining essentially <font color"gcYellow" face="Comic Sans MS"'+
                   'bgcolor="gcBlue"><s>unchanged</s></font>. It'+
                   ' was popularised in the 1960s with the <font size="12"><a'+
                   'href="http://www.tmssoftware.com">release</a></font> of Letraset sheets containing Lorem Ipsum'+
                   'passages, and more recently with des'+
                   'ktop publishing software like <font bgcolor="gcSteelBlue" color="gcWhite">Aldus'+
                   'PageMaker</font> including versions of Lorem Ipsum.';

implementation

{$R *.fmx}

procedure TfrmCom_Make_Pdf.FormCreate(Sender: TObject);
begin
  edtFileName.Text := GetCurrentDir+'\Make_PDF_File.pdf';
  l_FileName_Img1  := GetCurrentDir+'\sample1.jpg';
  l_FileName_Img2  := GetCurrentDir+'\sample2.jpg';
  l_FileName_Img3  := GetCurrentDir+'\sample3.jpg';
  l_FileName_Img4  := GetCurrentDir+'\sample4.jpg';
end;

procedure TfrmCom_Make_Pdf.Button1Click(Sender: TObject);
begin
  p_GeneratePDF(edtFileName.Text);
end;


procedure TfrmCom_Make_Pdf.Button2Click(Sender: TObject);
begin
//  if SaveDialog1.Execute then begin
//     edtFileName.Text := SaveDialog1.FileName+'.pdf';
//  end;
end;


procedure TfrmCom_Make_Pdf.p_GeneratePDF(AFileName: string);
var
 p: TTMSFMXPDFLib;
 r: TRectF;
 MyImage: TBitmap;
 s: String;
begin
  p := TTMSFMXPDFLib.Create;

  try
     p.BeginDocument(AFileName);


   //---------------------------------------------------------------------------
     p.NewPage;
     p.Graphics.Stroke.Color := gcRed;
     p.Graphics.Stroke.Width := 3;
     p.Graphics.Stroke.Kind  := gskDot;//gskDashDotDot;  gskSolid
     p.Graphics.DrawRectangle(RectF(10, 50, 100, 150));
     p.Graphics.DrawLine(PointF(10, 50), PointF(100, 50));
   //---------------------------------------------------------------------------
     p.NewPage;
     p.Graphics.Stroke.Color := gcGreen;
     p.Graphics.Stroke.Kind  := gskSolid;//gskDot;//gskDashDotDot;
     p.Graphics.Fill.Kind    := gfkGradient;
     p.Graphics.Fill.Color   := gcBlue;
     p.Graphics.Fill.ColorTo := gcOrange;
     p.Graphics.DrawRectangle(RectF(10, 50, 100, 150));
   //---------------------------------------------------------------------------
     p.NewPage;
     p.Graphics.Font.Name := 'Arial';
     p.Graphics.Fill.Color := gcNull;
     r := RectF(10, 50, 100, 100);
     p.Graphics.DrawRectangle(r);
     p.Graphics.DrawText('A single line', r);
   //---------------------------------------------------------------------------
     p.NewPage;
     s := 'Lorem Ipsum is simply dummy text of the printing and typesetting industry.';
     p.Graphics.Font.Name := 'Arial';
     p.Graphics.Font.Size := 8;
     p.Graphics.Fill.Color := gcNull;
     p.Graphics.DrawText(s, RectF(10, 50, 500, 400), 3);
   //---------------------------------------------------------------------------
     p.NewPage;
     p.Graphics.Font.Name := 'Arial';
     p.Graphics.Font.Size := 10;
     p.Graphics.Fill.Color := gcNull;
     r := RectF(10, 50, 300, 400);
     p.Graphics.DrawHTMLText(l_Html, r);
   //---------------------------------------------------------------------------
//     p.NewPage;//     r := RectF(30, 50, 100, 200);
//     p.Graphics.DrawImageFromFile(l_FileName_Img1,r);
//     r := RectF(130,50, 200, 200);
//     p.Graphics.DrawImageFromFile(l_FileName_Img2,r);
//     r := RectF(230,50, 300, 200);
//     p.Graphics.DrawImageFromFile(l_FileName_Img3,r);
//     r := RectF(330,50, 400, 200);
//     p.Graphics.DrawImageFromFile(l_FileName_Img4,r);
   //---------------------------------------------------------------------------     p.NewPage;
     MyImage := TBitmap.Create;
     p.BitmapContainer     := TMSFMXBitmapContainer1;
     p.Graphics.Font.Name  := 'Arial';
     p.Graphics.Font.Size  := 8;
     p.Graphics.Fill.Color := gcNull;
     p.Graphics.DrawImageWithName('MyImage', PointF(10, 50));
     p.Graphics.DrawText('Rendering from image container', PointF(010, 100));
     p.Graphics.DrawImageFromFile(l_FileName_Img3, PointF(160, 50));
     p.Graphics.DrawText('Rendering from memory image',PointF(160, 100));

     MyImage.LoadFromFile(l_FileName_Img4);
   //p.Graphics.DrawImage(MyImage, PointF(310, 50));
     p.Graphics.DrawText('Rendering from file',PointF(310, 100));

     p.EndDocument(True);  finally    MyImage.Free;
    p.Free;
  end;
end;initialization   RegisterClasses([TfrmCom_Make_Pdf]);

finalization
   UnRegisterClasses([TfrmCom_Make_Pdf]);

end.

end.