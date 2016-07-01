unit Amazon.Client;

interface

uses Amazon.Interfaces, System.SysUtils, Amazon.Credentials,
  Amazon.Utils, Amazon.Response, System.Rtti, Amazon.RESTClient,
  Amazon.Request, Amazon.SignatureV4;

type
  TAmazonClient = class(TInterfacedObject, IAmazonClient)
  protected
    fAmazonCredentials: TAmazonCredentials;
    fEndPoint: UTF8String;
    fService: UTF8String;
    fHost: UTF8String;
    fAuthorization_Header: UTF8String;
  private
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
  public
    constructor Create; overload;
    constructor Create(aSecret_Key: UTF8String;
      aAccess_Key: UTF8String); overload;
    destructor Destory;

    procedure InitClient(aSecret_Key: UTF8String;
      aAccess_Key: UTF8String); virtual;
    function Execute(aAmazonRequest: IAmazonRequest;
      aAmazonSignature: IAmazonSignature;
      aAmazonRESTClient: IAmazonRESTClient): IAmazonResponse; virtual;
    function MakeRequest(aAmazonRequest: IAmazonRequest): IAmazonResponse;

    property Secret_Key: UTF8String read GetSecret_Key write SetSecret_Key;
    property Access_Key: UTF8String read GetAccess_Key write SetAccess_Key;
    property Region: UTF8String read GetRegion write SetRegion;
    property EndPoint: UTF8String read GetEndPoint write SetEndPoint;
    property Service: UTF8String read GetService write SetService;
    property Host: UTF8String read GetHost write SetHost;
  end;

implementation

constructor TAmazonClient.Create;
begin
  InitClient('', '');
end;

constructor TAmazonClient.Create(aSecret_Key: UTF8String;
  aAccess_Key: UTF8String);
begin
  InitClient(aSecret_Key, aAccess_Key);
end;

destructor TAmazonClient.Destory;
begin
  FreeandNil(fAmazonCredentials);
end;

procedure TAmazonClient.InitClient(aSecret_Key: UTF8String;
  aAccess_Key: UTF8String);
begin
  fAmazonCredentials := TAmazonCredentials.Create;

  fEndPoint := '';
  fService := '';
  fHost := '';

  fAmazonCredentials.Access_Key := aAccess_Key;
  fAmazonCredentials.Secret_Key := aSecret_Key;
end;

function TAmazonClient.GetRegion: UTF8String;
begin
  Result := '';
  if Assigned(fAmazonCredentials) then
    Result := fAmazonCredentials.Region;
end;

procedure TAmazonClient.SetRegion(Value: UTF8String);
begin
  if Assigned(fAmazonCredentials) then
    fAmazonCredentials.Region := Value;
end;

function TAmazonClient.GetAccess_Key: UTF8String;
begin
  Result := '';
  if Assigned(fAmazonCredentials) then
    Result := fAmazonCredentials.Access_Key;
end;

procedure TAmazonClient.SetAccess_Key(Value: UTF8String);
begin
  if Assigned(fAmazonCredentials) then
    fAmazonCredentials.Access_Key := Value;
end;

function TAmazonClient.GetSecret_Key: UTF8String;
begin
  Result := '';
  if Assigned(fAmazonCredentials) then
    Result := fAmazonCredentials.Secret_Key;
end;

procedure TAmazonClient.SetSecret_Key(Value: UTF8String);
begin
  if Assigned(fAmazonCredentials) then
    fAmazonCredentials.Secret_Key := Value;
end;

function TAmazonClient.GetEndPoint: UTF8String;
begin
  Result := fEndPoint;
end;

procedure TAmazonClient.SetEndPoint(Value: UTF8String);
begin
  fEndPoint := Value;
end;

function TAmazonClient.GetService: UTF8String;
begin
  Result := fService;
end;

procedure TAmazonClient.SetService(Value: UTF8String);
begin
  fService := Value;
end;

function TAmazonClient.GetHost: UTF8String;
begin
  Result := fHost;
end;

procedure TAmazonClient.SetHost(Value: UTF8String);
begin
  fHost := Value;
end;

function TAmazonClient.Execute(aAmazonRequest: IAmazonRequest;
  aAmazonSignature: IAmazonSignature;
  aAmazonRESTClient: IAmazonRESTClient): IAmazonResponse;
var
  AWS_Date: UTF8String;
  Date_Stamp: UTF8String;
  Content_Type: UTF8String;
  Response: UTF8String;
  AmazonResponse: TAmazonResponse;
begin
  Result := NIL;
  try
    GetAWSDate_Stamp(UTCNow, AWS_Date, Date_Stamp);
    Content_Type := aAmazonSignature.GetContent_type;

    aAmazonRequest.Secret_Key := Secret_Key;
    aAmazonRequest.Access_Key := Access_Key;
    aAmazonRequest.Service := Service;
    aAmazonRequest.EndPoint := EndPoint;
    if Host = '' then
      aAmazonRequest.Host := GetAWSHost(aAmazonRequest.EndPoint)
    else
      aAmazonRequest.Host := Host;
    aAmazonRequest.Region := Region;
    aAmazonRequest.AWS_Date := AWS_Date;
    aAmazonRequest.Date_Stamp := Date_Stamp;
    aAmazonSignature.Sign(aAmazonRequest);
    aAmazonRESTClient.Content_Type := Content_Type;

    aAmazonRESTClient.AddHeader('X-Amz-Date', AWS_Date);
    aAmazonRESTClient.AddHeader('X-Amz-Target', aAmazonRequest.Target);
    aAmazonRESTClient.AddHeader('Authorization', aAmazonSignature.Authorization_Header);

    Response := '';
    aAmazonRESTClient.Post(EndPoint, aAmazonRequest.request_parameters, Response);
  finally
    AmazonResponse := TAmazonResponse.Create;
    AmazonResponse.Response := Response;
    AmazonResponse.ResponseCode := aAmazonRESTClient.ResponseCode;
    AmazonResponse.ResponseText := aAmazonRESTClient.ResponseText;
    Result := AmazonResponse;
  end;
end;

function TAmazonClient.MakeRequest(aAmazonRequest: IAmazonRequest): IAmazonResponse;
var
  FAmazonRESTClient: TAmazonRESTClient;
  FAmazonSignatureV4: TAmazonSignatureV4;
begin
  try
    FAmazonSignatureV4 := TAmazonSignatureV4.Create;
    FAmazonRESTClient := TAmazonRESTClient.Create;
    result := Execute(aAmazonRequest, FAmazonSignatureV4, FAmazonRESTClient);
  finally
    FAmazonSignatureV4 := NIL;
    FAmazonRESTClient := NIL;
  end;
end;

end.
