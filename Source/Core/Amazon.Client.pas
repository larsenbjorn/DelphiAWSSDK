unit Amazon.Client;

interface

uses System.SysUtils, System.Rtti,
  Amazon.Interfaces, Amazon.Credentials, Amazon.Utils, Amazon.Response,
  Amazon.RESTClient, Amazon.Request, Amazon.SignatureV4;

type
  TAmazonClient = class(TInterfacedObject, IAmazonClient)
  protected
    FCredentials: TAmazonCredentials;
    FEndPoint: UTF8String;
    FService: UTF8String;
    FHost: UTF8String;
    FAuthorization_Header: UTF8String;
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
    destructor Destory;

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
  FCredentials := TAmazonCredentials.Create;
end;

destructor TAmazonClient.Destory;
begin
  FreeAndNil(FCredentials);
end;

function TAmazonClient.GetRegion: UTF8String;
begin
  Result := FCredentials.Region;
end;

procedure TAmazonClient.SetRegion(Value: UTF8String);
begin
  FCredentials.Region := Value;
end;

function TAmazonClient.GetAccess_Key: UTF8String;
begin
  Result := FCredentials.Access_Key;
end;

procedure TAmazonClient.SetAccess_Key(Value: UTF8String);
begin
  FCredentials.Access_Key := Value;
end;

function TAmazonClient.GetSecret_Key: UTF8String;
begin
  Result := FCredentials.Secret_Key;
end;

procedure TAmazonClient.SetSecret_Key(Value: UTF8String);
begin
  FCredentials.Secret_Key := Value;
end;

function TAmazonClient.GetEndPoint: UTF8String;
begin
  Result := FEndPoint;
end;

procedure TAmazonClient.SetEndPoint(Value: UTF8String);
begin
  FEndPoint := Value;
end;

function TAmazonClient.GetService: UTF8String;
begin
  Result := FService;
end;

procedure TAmazonClient.SetService(Value: UTF8String);
begin
  FService := Value;
end;

function TAmazonClient.GetHost: UTF8String;
begin
  Result := FHost;
end;

procedure TAmazonClient.SetHost(Value: UTF8String);
begin
  FHost := Value;
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
  AmazonRESTClient: TAmazonRESTClient;
  AmazonSignatureV4: TAmazonSignatureV4;
begin
  try
    AmazonSignatureV4 := TAmazonSignatureV4.Create;
    AmazonRESTClient := TAmazonRESTClient.Create;
    Result := Execute(aAmazonRequest, AmazonSignatureV4, AmazonRESTClient);
  finally
    AmazonSignatureV4 := nil;
    AmazonRESTClient := nil;
  end;
end;

end.
