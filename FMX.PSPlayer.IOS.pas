unit FMX.PSPlayer.IOS;

interface

uses
  System.Variants, System.Classes, System.SysUtils, System.Math, System.Types,
  System.UIConsts,
  Macapi.ObjectiveC, Macapi.ObjCRuntime, Macapi.CoreFoundation, Macapi.Dispatch,
  iOSapi.CocoaTypes, iOSapi.Foundation, iOSapi.UIKit, iOSapi.CoreAudio, iOSapi.CoreVideo,
  iOSapi.CoreMedia, iOSapi.AVFoundation, iOSapi.CoreGraphics,
  FMX.Consts, FMX.Types, FMX.Types3D, FMX.Forms, FMX.Media, FMX.Canvas.iOS,
  FMX.Platform.iOS, FMX.PixelFormats, FMX.Graphics;

{ TAVMedia }
type
  TAVMedia10 = class(TMedia)
  private
    FPlayer: AVPlayer;
    FPlayerItem: AVPlayerItem;
    FPlayerLayer: AVPlayerLayer;
  protected
    procedure SeekToBegin;
    function GetDuration: TMediaTime; override;
    function GetCurrent: TMediaTime; override;
    procedure SetCurrent(const Value: TMediaTime); override;
    function GetVideoSize: TPointF; override;
    function GetMediaState: TMediaState; override;
    function GetVolume: Single; override;
    procedure SetVolume(const Value: Single); override;
    procedure UpdateMediaFromControl; override;
    procedure DoPlay; override;
    procedure DoStop; override;
  public
    constructor Create(const AFileName: string; isUrl: Boolean); overload;
    destructor Destroy; override;
  end;

implementation

function CGRectFromRect(const R: TRectF): CGRect;
begin
  Result.origin.x := R.Left;
  Result.origin.Y := R.Top;
  Result.size.Width := R.Right - R.Left;
  Result.size.Height := R.Bottom - R.Top;
end;

{ TAVMedia }

constructor TAVMedia10.Create(const AFileName: string; isUrl: Boolean);
var
  URL: NSUrl;
  AbsoluteFileName: string;
begin
  inherited Create(AFileName);
  AVMediaTypeAudio; // force load framework
  if ExtractFilePath(AFileName).IsEmpty then
    AbsoluteFileName := UTF8ToString(TNSString.Wrap(NSHomeDirectory).UTF8String) + '/' + AFileName
  else
    AbsoluteFileName := AFileName;

  if isUrl then
    URL := TNSUrl.Wrap(TNSUrl.OCClass.URLWithString(NSStr(AbsoluteFileName)))
  else
    URL := TNSUrl.Wrap(TNSUrl.OCClass.fileURLWithPath(NSStr(AbsoluteFileName)));

  FPlayerItem := TAVPlayerItem.Wrap(TAVPlayerItem.OCClass.playerItemWithURL(URL));
  FPlayerItem.retain;

  FPlayer := TAVPlayer.Wrap(TAVPlayer.OCClass.playerWithPlayerItem(FPlayerItem));
  FPlayer.retain;

  FPlayerLayer := TAVPlayerLayer.Wrap(TAVPlayerLayer.OCClass.playerLayerWithPlayer(FPlayer));
  FPlayerLayer.retain;
end;

destructor TAVMedia10.Destroy;
begin
  if FPlayerLayer <> nil then
    FPlayerLayer.removeFromSuperlayer;
  FPlayerLayer.release;
  FPlayerLayer := nil;
  FPlayer.release;
  FPlayer := nil;
  FPlayerItem.release;
  FPlayerItem := nil;
  inherited Destroy;
end;

function TAVMedia10.GetCurrent: TMediaTime;
begin
  if Assigned(FPlayerItem) then
    Result := Trunc(FPlayerItem.currentTime.Value / FPlayerItem.currentTime.timeScale * MediaTimeScale)
  else
    Result := 0;
end;

function TAVMedia10.GetDuration: TMediaTime;
begin
  if Assigned(FPlayerItem) then
    Result := Trunc(FPlayerItem.duration.Value / FPlayerItem.duration.timeScale * MediaTimeScale)
  else
    Result := 0;
end;

function TAVMedia10.GetMediaState: TMediaState;
begin
  if Assigned(FPlayer) and (FPlayer.status <> AVPlayerStatusFailed) then
  begin
    if (FPlayer.Rate > 0) then
      Result := TMediaState.Playing
    else
      Result := TMediaState.Stopped
  end
  else
    Result := TMediaState.Unavailable;
end;

function TAVMedia10.GetVideoSize: TPointF;
begin
  if Assigned(FPlayerItem) then
    Result := PointF(FPlayerItem.presentationSize.width, FPlayerItem.presentationSize.height)
  else
    Result := TPointF.Create(0, 0);
end;

function TAVMedia10.GetVolume: Single;
begin
{  if Assigned(FPlayer) then
    Result := FPlayer.volume
  else}
    Result := 1.0;
end;

procedure TAVMedia10.SeekToBegin;
begin
  FPlayer.seekToTime(CMTimeMake(0, 1));
end;

procedure TAVMedia10.SetCurrent(const Value: TMediaTime);
begin
  if Assigned(FPlayer) then
    FPlayer.seekToTime(CMTimeMake(Value, MediaTimeScale));
end;

procedure TAVMedia10.SetVolume(const Value: Single);
begin
{  if (FMovie <> nil) then
    FMovie.setVolume(Value);}
end;

procedure TAVMedia10.UpdateMediaFromControl;
var
  View: UIView;
  Bounds: TRectF;
  P: TPointF;
  Form: TCommonCustomForm;
begin
  if Assigned(FPlayerLayer) then
  begin
    if (Control <> nil) and not (csDesigning in Control.ComponentState) and (Control.ParentedVisible) and
       (Control.Root <> nil) and  (Control.Root.GetObject is TCommonCustomForm) then
    begin
      Form := TCommonCustomForm(Control.Root.GetObject);
      P := GetVideoSize;
      Bounds := TRectF.Create(0, 0, P.X, P.Y);
      Bounds.Fit(Control.AbsoluteRect);

      if Assigned(FPlayerLayer.superlayer) then
        FPlayerLayer.removeFromSuperlayer;

      View := WindowHandleToPlatform(Form.Handle).View;
      View := TUIView.Wrap(View.superview);
      View.layer.addSublayer(FPlayerLayer);

      FPlayerLayer.setFrame(CGRectFromRect(RectF(Bounds.Left, Bounds.Top, Bounds.Right, Bounds.Bottom)));
      FPlayerLayer.setHidden(False);
      FPlayerLayer.removeAllAnimations;
    end
    else if Assigned(Application.MainForm) then
    begin
      if Assigned(FPlayerLayer.superlayer) then
        FPlayerLayer.removeFromSuperlayer;

      View := WindowHandleToPlatform(Application.MainForm.Handle).View;
      View := TUIView.Wrap(View.superview);
      View.layer.addSublayer(FPlayerLayer);

      FPlayerLayer.setFrame(CGRectFromRect(RectF(0, 0, Application.MainForm.Width, Application.MainForm.Height)));
      FPlayerLayer.setHidden(False);
      FPlayerLayer.removeAllAnimations;
    end
    else
      FPlayerLayer.setHidden(True);
  end;
end;

procedure TAVMedia10.DoStop;
begin
  if Assigned(FPlayer) then
  begin
    FPlayer.pause;
    SeekToBegin;
  end;
end;

procedure TAVMedia10.DoPlay;
var
  error: NSError;
  AudioSession: AVAudioSession;
begin
  AudioSession := TAVAudioSession.Wrap(TAVAudioSession.OCClass.sharedInstance);
  AudioSession.setCategory(AVAudioSessionCategoryPlayback, error);
  AudioSession.setActive(True, Error);

  if Assigned(FPlayer) then
  begin
    SeekToBegin;
    FPlayer.play;

    UpdateMediaFromControl;
  end;
end;

end.
