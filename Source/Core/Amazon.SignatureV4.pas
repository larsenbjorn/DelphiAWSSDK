unit Amazon.SignatureV4;

interface

Uses Classes, Amazon.Utils, SysUtils, IdGlobal, Amazon.Interfaces, Amazon.Request;

const
   awsALGORITHM = 'AWS4-HMAC-SHA256';
   awsSIGN = 'AWS4';
   awsContent_typeV4 = 'application/x-amz-json-1.0';

function GetSignatureV4Key(aSecret_Access_Key, aDateStamp, aRegionName, aServiceName: UTF8String): TidBytes;
function GetSignatureV4(aSignatureV4Key: TidBytes; aString_to_Sign: UTF8String): UTF8String;

type
  TAmazonSignatureV4 = class(TInterfacedObject, IAmazonSignature)
  protected
  private
    fMethod: UTF8String;
    fContent_Type: UTF8String;
    fResponse: UTF8String;
    fCanonical_URI: UTF8String;
    fCanonical_QueryString: UTF8String;
    fCanonical_Headers: UTF8String;
    fSigned_Headers: UTF8String;
    fPayload_Hash: UTF8String;
    fCanonical_Request: UTF8String;
    fAlgorithm: UTF8String;
    fCredential_Scope: UTF8String;
    fString_to_Sign: UTF8String;
    fSignatureV4Key: TidBytes;
    fSignature: UTF8String;
    fAuthorization_Header: UTF8String;

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
Var
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
  fSignature := '';
  fAuthorization_Header := '';
  fMethod := 'POST';
  fContent_Type := GetContent_type;
  fCanonical_URI := '/';
  fCanonical_QueryString := '';

  fCanonical_Headers := 'content-type:' + fContent_Type + char(10) +
                        'host:' + aRequest.Host + char(10)  +
                        'x-amz-date:' + aRequest.AWS_Date + char(10) +
                        'x-amz-target:' + aRequest.TargetPrefix + '.' +
                                          aRequest.OperationName + char(10);
  fSigned_Headers := 'content-type;host;x-amz-date;x-amz-target';
  fPayload_Hash := HashSHA256(aRequest.Request_Parameters);
  fCanonical_Request := fMethod + char(10) +
                        fCanonical_URI + char(10) +
                        fCanonical_QueryString + char(10) +
                        fCanonical_Headers + char(10) +
                        fSigned_Headers + char(10) +
                        fPayload_Hash;

  fAlgorithm := awsALGORITHM;
  fCredential_Scope := aRequest.Date_Stamp + '/' +
                       aRequest.Region + '/' +
                       aRequest.Service + '/' + 'aws4_request';

  fString_to_Sign := fAlgorithm + char(10) +
                     aRequest.AWS_Date + char(10) +
                     fCredential_Scope + char(10) +
                     HashSHA256(fCanonical_Request);

  fSignatureV4Key := GetSignatureV4Key(aRequest.Secret_Key, aRequest.Date_Stamp,
    aRequest.Region, aRequest.Service);

  fSignature :=  GetSignatureV4(fSignatureV4Key, fString_to_Sign );

  fAuthorization_Header := fAlgorithm + ' ' +
                           'Credential=' + aRequest.access_key + '/' +
                                           fCredential_Scope + ', ' +
                           'SignedHeaders=' + fSigned_Headers + ', ' +
                           'Signature=' + fSignature;
end;

function TAmazonSignatureV4.GetSignature: UTF8String;
begin
  Result := fSignature;
end;

function TAmazonSignatureV4.GetAuthorization_Header: UTF8String;
begin
  Result := fAuthorization_Header;
end;

function TAmazonSignatureV4.GetContent_type: UTF8String;
begin
  Result := awsContent_typeV4;
end;

end.
