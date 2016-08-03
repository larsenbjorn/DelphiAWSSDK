unit Amazon.SignatureV4;

interface

uses System.Classes, System.SysUtils,
  IdGlobal,
  Amazon.Utils, Amazon.Interfaces, Amazon.Request;

const
   awsALGORITHM = 'AWS4-HMAC-SHA256';
   awsSIGN = 'AWS4';
   awsContent_typeV4 = 'application/x-amz-json-1.0';

function GetSignatureV4Key(aSecret_Access_Key, aDateStamp, aRegionName, aServiceName: UTF8String): TidBytes;
function GetSignatureV4(aSignatureV4Key: TidBytes; aString_to_Sign: UTF8String): UTF8String;

type
  TAmazonSignatureV4 = class(TInterfacedObject, IAmazonSignature)
  private
    FMethod: UTF8String;
    FContent_Type: UTF8String;
    FResponse: UTF8String;
    FCanonical_URI: UTF8String;
    FCanonical_QueryString: UTF8String;
    FCanonical_Headers: UTF8String;
    FSigned_Headers: UTF8String;
    FPayload_Hash: UTF8String;
    FCanonical_Request: UTF8String;
    FAlgorithm: UTF8String;
    FCredential_Scope: UTF8String;
    FString_to_Sign: UTF8String;
    FSignatureV4Key: TidBytes;
    FSignature: UTF8String;
    FAuthorization_Header: UTF8String;
  protected
    function GetSignature: UTF8String;
    function GetAuthorization_Header: UTF8String;
  public
    procedure Sign(aRequest: IAmazonRequest);
    function GetContent_Type: UTF8String;

    property Signature: UTF8String read GetSignature;
    property Authorization_Header: UTF8String read GetAuthorization_Header;
  end;

implementation

function GetSignatureV4Key(aSecret_Access_Key, aDateStamp, aRegionName,
  aServiceName: UTF8String): TidBytes;
var
  Service: TidBytes;
  Region: TidBytes;
  Secret: TidBytes;
  Date: TidBytes;
  Signing: TidBytes;
begin
  Secret := ToBytes(UTF8Encode(awsSIGN + aSecret_Access_Key));
  Date := HmacSHA256Ex(Secret, adateStamp);
  Region := HmacSHA256Ex(Date, aregionName );
  Service := HmacSHA256Ex(Region, aserviceName);
  Signing := HmacSHA256Ex(Service, 'aws4_request');

  Result := Signing;
end;

function GetSignatureV4(aSignatureV4Key: TidBytes; aString_to_Sign: UTF8String): UTF8String;
begin
  Result := BytesToHex(HmacSHA256Ex(aSignatureV4Key, aString_to_Sign));
end;

procedure TAmazonSignatureV4.Sign(aRequest: IAmazonRequest);
begin
  FSignature := '';
  FAuthorization_Header := '';
  FMethod := 'POST';
  FContent_Type := GetContent_type;
  FCanonical_URI := '/';
  FCanonical_QueryString := '';

  FCanonical_Headers := 'content-type:' + FContent_Type + char(10) +
                        'host:' + aRequest.Host + char(10)  +
                        'x-amz-date:' + aRequest.AWS_Date + char(10) +
                        'x-amz-target:' + aRequest.TargetPrefix + '.' +
                                          aRequest.OperationName + char(10);
  FSigned_Headers := 'content-type;host;x-amz-date;x-amz-target';
  FPayload_Hash := HashSHA256(aRequest.Request_Parameters);
  FCanonical_Request := FMethod + char(10) +
                        FCanonical_URI + char(10) +
                        FCanonical_QueryString + char(10) +
                        FCanonical_Headers + char(10) +
                        FSigned_Headers + char(10) +
                        FPayload_Hash;

  FAlgorithm := awsALGORITHM;
  FCredential_Scope := aRequest.Date_Stamp + '/' +
                       aRequest.Region + '/' +
                       aRequest.Service + '/' + 'aws4_request';

  FString_to_Sign := FAlgorithm + char(10) +
                     aRequest.AWS_Date + char(10) +
                     FCredential_Scope + char(10) +
                     HashSHA256(FCanonical_Request);

  FSignatureV4Key := GetSignatureV4Key(aRequest.Secret_Key, aRequest.Date_Stamp,
    aRequest.Region, aRequest.Service);

  FSignature :=  GetSignatureV4(FSignatureV4Key, FString_to_Sign );

  FAuthorization_Header := FAlgorithm + ' ' +
                           'Credential=' + aRequest.access_key + '/' +
                                           FCredential_Scope + ', ' +
                           'SignedHeaders=' + FSigned_Headers + ', ' +
                           'Signature=' + FSignature;
end;

function TAmazonSignatureV4.GetSignature: UTF8String;
begin
  Result := FSignature;
end;

function TAmazonSignatureV4.GetAuthorization_Header: UTF8String;
begin
  Result := FAuthorization_Header;
end;

function TAmazonSignatureV4.GetContent_type: UTF8String;
begin
  Result := awsContent_typeV4;
end;

end.
