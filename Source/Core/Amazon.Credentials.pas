unit Amazon.Credentials;

interface

uses System.SysUtils,
  Amazon.Utils;

type
  TAmazonCredentials = class
  protected
    FSecret_Key: UTF8String;
    FAccess_Key: UTF8String;
    FRegion: UTF8String;
  private
    function GetSecret_Key: UTF8String;
    procedure SetSecret_Key(Value: UTF8String);
    function GetAccess_Key: UTF8String;
    procedure SetAccess_Key(Value: UTF8String);
    function GetRegion: UTF8String;
    procedure SetRegion(Value: UTF8String);
  public
    property Region: UTF8String read GetRegion write SetRegion;
    property Secret_Key: UTF8String read GetSecret_Key write SetSecret_Key;
    property Access_Key: UTF8String read GetAccess_Key write SetAccess_Key;
  end;

implementation

{ TAmazonCredentials }

function TAmazonCredentials.GetAccess_Key: UTF8String;
begin
  Result := FAccess_Key;
end;

function TAmazonCredentials.GetRegion: UTF8String;
begin
  Result := FRegion;
end;

function TAmazonCredentials.GetSecret_Key: UTF8String;
begin
  Result := FSecret_Key;
end;

procedure TAmazonCredentials.SetAccess_Key(Value: UTF8String);
begin
  FSecret_Key := Value;
end;

procedure TAmazonCredentials.SetRegion(Value: UTF8String);
begin
  FRegion := Value;
end;

procedure TAmazonCredentials.SetSecret_Key(Value: UTF8String);
begin
  FAccess_Key := Value;
end;

end.
