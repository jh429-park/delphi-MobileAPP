unit Com_BlueTooth_iOS;

interface



uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  System.Bluetooth, FMX.Controls.Presentation, FMX.StdCtrls,
  System.Bluetooth.Components, FMX.ScrollBox, FMX.Memo;



type

  TfrmCom_BlueTooth_iOS = class(TForm)
    BluetoothLE1: TBluetoothLE;
    Button1: TButton;
    Memo1: TMemo;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure BluetoothLE1ServicesDiscovered(const Sender: TObject;
      const AServiceList: TBluetoothGattServiceList);
    procedure BluetoothLE1DiscoverLEDevice(const Sender: TObject;
      const ADevice: TBluetoothLEDevice; Rssi: Integer;
      const ScanResponse: TScanResponse);
    procedure BluetoothLE1EndDiscoverDevices(const Sender: TObject;
      const ADeviceList: TBluetoothLEDeviceList);
    procedure BluetoothLE1Connect(Sender: TObject);
    procedure BluetoothLE1CharacteristicRead(const Sender: TObject;
      const ACharacteristic: TBluetoothGattCharacteristic;
      AGattStatus: TBluetoothGattStatus);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure BluetoothLE1ReliableWriteCompleted(const Sender: TObject;
      AGattStatus: TBluetoothGattStatus);
    procedure BluetoothLE1ConnectedDevice(const Sender: TObject;
      const ADevice: TBluetoothLEDevice);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { private 宣言 }
    fBleSerialDevice : TBluetoothLEDevice;
    fBleSerialService : TBluetoothGattService;
  public
    { public 宣言 }
  end;



var
  frmCom_BlueTooth_iOS: TfrmCom_BlueTooth_iOS;



const

  // BLESerial サービス UUID
  BleSerialService: TBluetoothUUID = '{24DDF411-8CF1-440C-87CD-E368DAF9C93E}';
  // BLESerial 受信 UUID (Notify)
  BleSerialRx :     TBluetoothUUID = '{24DDF411-8CF1-440C-87CD-E368DAF9C93E}';
  // BLESerial 送信 UUID (write without response)
  BleSerialTx:      TBluetoothUUID = '{24DDF411-8CF1-440C-87CD-E368DAF9C93E}';



implementation



{$R *.fmx}



// 受信

procedure TfrmCom_BlueTooth_iOS.BluetoothLE1CharacteristicRead(const Sender: TObject;
  const ACharacteristic: TBluetoothGattCharacteristic;
  AGattStatus: TBluetoothGattStatus);
var
  s : string;
begin
  // 受信した文字列
  Memo1.Lines.Add('BluetoothLE1CharacteristicRead');
  s := ACharacteristic.GetValueAsString(0, true);
  Memo1.Lines.Add('read:'+s);
end;



procedure TfrmCom_BlueTooth_iOS.BluetoothLE1Connect(Sender: TObject);
begin
  Memo1.Lines.Add('BluetoothLE1Connect');
end;



procedure TfrmCom_BlueTooth_iOS.BluetoothLE1ConnectedDevice(const Sender: TObject;
  const ADevice: TBluetoothLEDevice);
begin
end;

// BLESerial を発見

procedure TfrmCom_BlueTooth_iOS.BluetoothLE1DiscoverLEDevice(const Sender: TObject;
  const ADevice: TBluetoothLEDevice; Rssi: Integer;
  const ScanResponse: TScanResponse);
begin
  Memo1.Lines.Add('BluetoothLE1DiscoverLEDevice:'+ADevice.DeviceName);
  if Pos('BLESerial_',ADevice.DeviceName) > 0 then begin
     Memo1.Lines.Add('Pos(''BLESerial_'',ADevice.DeviceName)>0');
    // デバイスを保持
    fBleSerialDevice := ADevice;
    // 検索を終了
    BluetoothLE1.CancelDiscovery;
  end;
end;



// BLE デバイスの検索終了

procedure TfrmCom_BlueTooth_iOS.BluetoothLE1EndDiscoverDevices(const Sender: TObject;
  const ADeviceList: TBluetoothLEDeviceList);
begin
  Memo1.Lines.Add('BluetoothLE1EndDiscoverDevices');
  if fBleSerialDevice <> nil then begin
    if not fBleSerialDevice.DiscoverServices then begin
      Memo1.Lines.Add('fBleSerialDevice <> nil and not fBleSerialDevice.DiscoverServices');
    end;
  end
  else begin
    Memo1.Lines.Add('fBleSerialDevice = nil');
  end;
end;



procedure TfrmCom_BlueTooth_iOS.BluetoothLE1ReliableWriteCompleted(const Sender: TObject;
  AGattStatus: TBluetoothGattStatus);
begin
end;

// サービスを発見

procedure TfrmCom_BlueTooth_iOS.BluetoothLE1ServicesDiscovered(const Sender: TObject;
  const AServiceList: TBluetoothGattServiceList);
var
  i :integer;
  RxCharact: TBluetoothGattCharacteristic;
begin
  Memo1.Lines.Add('BluetoothLE1ServicesDiscovered');
  if AServiceList.Count > 0 then begin
    for i := 0 to AServiceList.Count -1 do begin
      fBleSerialService := AServiceList[i];
      break;
    end;
    if fBleSerialService <> nil then begin
      for i := 0 to fBleSerialService.Characteristics.Count -1 do begin
        if fBleSerialService.Characteristics[i].UUID = BleSerialRx then begin
          RxCharact := fBleSerialService.Characteristics[i];
          break;
        end;
      end;
      if RxCharact <> nil then begin
        fBleSerialDevice.SetCharacteristicNotification(RxCharact, true);
      end;
    end;
  end;
end;



procedure TfrmCom_BlueTooth_iOS.Button1Click(Sender: TObject);
begin
  Memo1.Lines.Clear;
  try
    fBleSerialDevice  := nil;
    fBleSerialService := nil;
    BluetoothLE1.DiscoverDevices(1000, [BleSerialService]);
    Memo1.Lines.Add('1. BluetoothLE1.DiscoverDevices');
  except
    Memo1.Lines.Add('1. except BluetoothLE1.DiscoverDevices');
  end;
end;

procedure TfrmCom_BlueTooth_iOS.Button2Click(Sender: TObject);
var
  s : string;
  TxCharact : TBluetoothGattCharacteristic;
begin
  if (fBleSerialDevice <> nil) and fBleSerialDevice.IsConnected then begin
    Memo1.Lines.Add('2. (fBleSerialDevice <> nil) and fBleSerialDevice.IsConnected');
    TxCharact := fBleSerialService.GetCharacteristic(BleSerialTx);
    if TxCharact <> nil then begin
      s := 'ABCDEFGH';
      TxCharact.SetValueAsString(s, true);
      if fBleSerialDevice.WriteCharacteristic(TxCharact) then begin
        Memo1.Lines.Add('2. fBleSerialDevice.WriteCharacteristic(TxCharact)');
      end;
    end;
  end
  else begin
    Memo1.Lines.Add('2. No! (fBleSerialDevice <> nil) and fBleSerialDevice.IsConnected');
  end;
end;



// 切断

procedure TfrmCom_BlueTooth_iOS.Button3Click(Sender: TObject);
begin
  if (fBleSerialDevice <> nil) and fBleSerialDevice.IsConnected then begin
    Memo1.Lines.Add('3. (fBleSerialDevice <> nil) and fBleSerialDevice.IsConnected');
    if fBleSerialDevice.Disconnect then begin
      Memo1.Lines.Add('3. fBleSerialDevice.Disconnect');
      fBleSerialDevice := nil;
      fBleSerialService := nil;
    end;
  end
  else begin
    Memo1.Lines.Add('3. No! (fBleSerialDevice <> nil) and fBleSerialDevice.IsConnected');
  end;
end;


procedure TfrmCom_BlueTooth_iOS.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;

procedure TfrmCom_BlueTooth_iOS.FormShow(Sender: TObject);
begin
  showMessage('FormShow');
end;

initialization
   RegisterClasses([TfrmCom_BlueTooth_iOS]);

finalization
   UnRegisterClasses([TfrmCom_BlueTooth_iOS]);

end.

