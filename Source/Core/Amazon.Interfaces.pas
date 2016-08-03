unit Amazon.Interfaces;

interface

type
  IAmazonRESTClient = interface
    ['{E6CD9C73-6C92-4996-AEC3-3EC836629E6D}']
    function GetResponseCode: Integer;
    function GetResponseText: String;
    function GetContent_Type: string;
    procedure SetContent_Type(Value: string);
    function GetErrorCode: Integer;
    function GetErrorMessage: String;
    procedure AddHeader(aName, aValue: UTF8String);
    procedure Post(aUrl: string; aRequest: UTF8String; var aResponse: UTF8String);
    property ResponseCode: Integer read GetResponseCode;
    property ResponseText: string read GetResponseText;
    property Content_Type: String read GetContent_Type write SetContent_Type;
    property ErrorCode: Integer read GetErrorCode;
    property ErrorMessage: String read GetErrorMessage;
  end;

  IAmazonClient = interface
    ['{24BF1E03-A208-4F7D-9FC7-875BC33D339F}']
  end;

  IAmazonMarshaller = interface
    ['{132F6BC1-8F07-4A2E-B763-02C4CF66008C}']
  end;

  IAmazonResponse = interface
    ['{022460F3-2D8A-4784-9207-825242851A12}']
    procedure SetResponseCode(Value: Integer);
    procedure SetReponseText(Value: UTF8String);
    procedure SetReponse(Value: UTF8String);
    function GetResponseCode: Integer;
    function GetReponseText: UTF8String;
    function GetReponse: UTF8String;
    property ResponseText: UTF8String read GetReponseText write SetReponseText;
    property ResponseCode: Integer read GetResponseCode write SetResponseCode;
    property Response: UTF8String read GetReponse write SetReponse;
  end;

  IAmazonRequest = interface
    ['{DA029A3F-05C2-4286-BF0B-4FE859AC8A64}']
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
    function GetAWS_Date: UTF8String;
    procedure SetAWS_Date(Value: UTF8String);
    function GetDate_Stamp: UTF8String;
    procedure SetDate_Stamp(Value: UTF8String);
    function GetOperationName: UTF8String;
    procedure SetOperationName(Value: UTF8String);
    function GetAuthorization_Header: UTF8String;
    procedure SetAuthorization_Header(Value: UTF8String);
    function GetRequest_Parameters: UTF8String;
    procedure SetRequest_Parameters(Value: UTF8String);

    property Secret_Key: UTF8String read GetSecret_Key write SetSecret_Key;
    property Access_Key: UTF8String read GetAccess_Key write SetAccess_Key;
    property Region: UTF8String read GetRegion write SetRegion;
    property EndPoint: UTF8String read GetEndPoint write SetEndPoint;
    property Service: UTF8String read GetService write SetService;
    property Host: UTF8String read GetHost write SetHost;
    property TargetPrefix: UTF8String read GettargetPrefix write settargetPrefix;
    property OperationName: UTF8String read GetoperationName write setoperationName;
    property AWS_Date: UTF8String read GetAWS_Date write SetAWS_Date;
    property Date_Stamp: UTF8String read GetDate_Stamp write SetDate_Stamp;
    property Target: UTF8String read GetTarget;
    property Authorization_Header: UTF8String read GetAuthorization_Header
      write SetAuthorization_Header;
    property Request_Parameters: UTF8String read GetRequest_Parameters
      write SetRequest_Parameters;
  end;

  IAmazonSignature = interface
    ['{56901E5E-BA6C-49E4-B730-CA58AE7F8DCB}']
    function GetSignature: UTF8String;
    function GetAuthorization_Header: UTF8String;
    function GetContent_Type: UTF8String;
    procedure Sign(aRequest: IAmazonRequest);
    property Signature: UTF8String read GetSignature;
    property Authorization_Header: UTF8String read GetAuthorization_Header;
  end;

implementation

end.
