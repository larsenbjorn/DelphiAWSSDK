unit Amazon.Request;

interface

uses System.SysUtils,
  Amazon.Interfaces, Amazon.Credentials;

type
  TAmazonRequest = class(TInterfacedObject, IAmazonRequest)
  private
    FAuthorization_Header: UTF8String;
    FCredentials: TAmazonCredentials;
    FAWS_Date: UTF8String;
    FDate_Stamp: UTF8String;
    FService: UTF8String;
    FEndPoint: UTF8String;
    FTargetPrefix: UTF8String;
    FRequest_Parameters: UTF8String;
    FHost: UTF8String;
    FOperationName: UTF8String;
  protected
    function GetSecret_Key: UTF8String;
    procedure SetSecret_Key(Value: UTF8String);
    function GetAccess_Key: UTF8String;
    procedure SetAccess_Key(Value: UTF8String);
    function GetRegion: UTF8String;
    procedure SetRegion(Value: UTF8String);
    function GetEndPoint: UTF8String;
    procedure SetEndPoint(Value: UTF8String);
    function GetService: UTF8String;
    procedure SetService(Value: UTF8String);
    function GetHost: UTF8String;
    procedure SetHost(Value: UTF8String);
    function GetTarget: UTF8String;
    function GetTargetPrefix: UTF8String;
    procedure SetTargetPrefix(Value: UTF8String);
    function GetRequest_Parameters: UTF8String;
    procedure SetRequest_Parameters(Value: UTF8String);
    function GetAWS_Date: UTF8String;
    procedure SetAWS_Date(Value: UTF8String);
    function GetDate_Stamp: UTF8String;
    procedure SetDate_Stamp(Value: UTF8String);
    function GetOperationName: UTF8String;
    procedure SetOperationName(Value: UTF8String);
    function GetAuthorization_Header: UTF8String;
    procedure SetAuthorization_Header(Value: UTF8String);
  public
    constructor Create; overload;
    destructor Destory;
    property Secret_Key: UTF8String read GetSecret_Key write SetSecret_Key;
    property Access_Key: UTF8String read GetAccess_Key write SetAccess_Key;
    property TargetPrefix: UTF8String read GetTargetPrefix write SetTargetPrefix;
    property OperationName: UTF8String read GetOperationName write SetOperationName;
    property Service: UTF8String read GetService write SetService;
    property EndPoint: UTF8String read GetEndPoint write SetEndPoint;
    property Host: UTF8String read GetHost write SetHost;
    property Region: UTF8String read GetRegion write SetRegion;
    property Request_Parameters: UTF8String read GetRequest_Parameters write SetRequest_Parameters;
    property AWS_Date: UTF8String read GetAWS_Date write SetAWS_Date;
    property Date_Stamp: UTF8String read GetDate_Stamp write SetDate_Stamp;
    property Authorization_Header: UTF8String read GetAuthorization_Header write SetAuthorization_Header;
    property Target: UTF8String read GetTarget;
  end;

implementation

function TAmazonRequest.GetSecret_Key: UTF8String;
begin
  Result := FCredentials.Secret_Key;
end;

procedure TAmazonRequest.SetSecret_Key(Value: UTF8String);
begin
  FCredentials.Secret_Key := Value;
end;

function TAmazonRequest.GetRequest_Parameters: UTF8String;
begin
  Result := FRequest_Parameters;
end;

procedure TAmazonRequest.SetRequest_Parameters(Value: UTF8String);
begin
  FRequest_Parameters := Value;
end;

constructor TAmazonRequest.Create;
begin
  FCredentials := TAmazonCredentials.Create;
end;

destructor TAmazonRequest.Destory;
begin
  FreeAndNil(FCredentials);
end;

function TAmazonRequest.GetAccess_Key: UTF8String;
begin
  Result := FCredentials.Access_Key;
end;

procedure TAmazonRequest.SetAccess_Key(Value: UTF8String);
begin
  FCredentials.Access_Key := Value;
end;

function TAmazonRequest.GetTargetPrefix: UTF8String;
begin
  Result := FTargetPrefix;
end;

procedure TAmazonRequest.SetTargetPrefix(Value: UTF8String);
begin
  FTargetPrefix := Value;
end;

function TAmazonRequest.GetService: UTF8String;
begin
  Result := FService;
end;

procedure TAmazonRequest.SetService(Value: UTF8String);
begin
  FService := Value;
end;

function TAmazonRequest.GetRegion: UTF8String;
begin
  Result := FCredentials.Region;
end;

procedure TAmazonRequest.SetRegion(Value: UTF8String);
begin
  FCredentials.Region := Value;
end;

function TAmazonRequest.GetHost: UTF8String;
begin
  Result := FHost;
end;

procedure TAmazonRequest.SetHost(Value: UTF8String);
begin
  FHost := Value;
end;

function TAmazonRequest.GetEndPoint: UTF8String;
begin
  Result := FEndPoint;
end;

procedure TAmazonRequest.SetEndPoint(Value: UTF8String);
begin
  FEndPoint := Value;
end;

function TAmazonRequest.GetAWS_Date: UTF8String;
begin
  Result := FAWS_Date;
end;

procedure TAmazonRequest.SetAWS_Date(Value: UTF8String);
begin
  FAWS_Date := Value;
end;

function TAmazonRequest.GetDate_Stamp: UTF8String;
begin
  Result := FDate_Stamp;
end;

procedure TAmazonRequest.SetDate_Stamp(Value: UTF8String);
begin
  FDate_Stamp := Value;
end;

function TAmazonRequest.GetOperationName: UTF8String;
begin
  Result := FOperationName;
end;

procedure TAmazonRequest.SetOperationName(Value: UTF8String);
begin
  FOperationName := Value;
end;

procedure TAmazonRequest.SetAuthorization_Header(Value: UTF8String);
begin
  FAuthorization_Header := Value;
end;

function TAmazonRequest.GetAuthorization_Header;
begin
  Result := FAuthorization_Header;
end;

function TAmazonRequest.GetTarget: UTF8String;
begin
  Result := TargetPrefix + '.' + OperationName;
end;

end.
