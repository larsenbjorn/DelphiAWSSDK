unit Amazon.Marshaller;

interface

uses System.Rtti, System.TypInfo, System.Classes, System.StrUtils,
  System.SysUtils,
  Amazon.Utils, Amazon.Interfaces;

type
  TAmazonMarshallerAttribute = class(TCustomAttribute)
  private
    fTagName: string;
  public
    constructor Create(const aTagName: String);
    property TagName: String read fTagName write fTagName;
  end;

  TAmazonMarshaller = class(TInterfacedObject, IAmazonMarshaller)
  private
    procedure CloseJSONArray(var aJSON: TStringList;
      aCloseBracket: UTF8String = ']'; aIsClass: Boolean = False);
    procedure OpenJSONArray(var aJSON: TStringList; aParentTagName: UTF8String;
      aOpenBracket: UTF8String = '[');
    procedure AddJSONArray(var aJSON: TStringList; aTagName,
      aTagValue: UTF8String);
    procedure AddJSONString(aTypeKind: TTypeKind; var aJSON: TStringList;
      aTagName, aTagValue: UTF8String; aIsClass: Boolean;
      var aIsOpenBracket: Boolean; aIsListJSONArray: Boolean = False;
      aIsSubOpenBracket: Boolean = False);
    function IsAnyKindOfGenericList(AType: TRttiType): Boolean;
  public
    procedure GetSubRttiAttributekeys(var aJSON: TStringList;
      aParentTagName: string; aCtx: TRttiContext; aObject: TObject;
      aIsClass: Boolean = False; aIsOpenBracket: Boolean = False;
      aIsListJSONArray: Boolean = False);
  end;

implementation

constructor TAmazonMarshallerAttribute.Create(const aTagName: string);
begin
  fTagName := aTagName;
end;

procedure TAmazonMarshaller.GetSubRttiAttributekeys(var aJSON: TStringList;
  aParentTagName: string; aCtx: TRttiContext; aObject: TObject;
  aIsClass: Boolean = False; aIsOpenBracket: Boolean = False;
  aIsListJSONArray: Boolean = False);
var
  I: Integer;
  Prop: TRttiProperty;
  TagName, TagValue, PropName: UTF8String;
  Att: TCustomAttribute;
  RttiType: TRttiType;
  Val: TValue;
  List: TList;
  FObject: TObject;
  IsSubOpenBracket: Boolean;
begin
  IsSubOpenBracket := False;

  if aIsClass then
  begin
    if IsAnyKindOfGenericList(aCtx.GetType(aObject.ClassType)) then
    begin
      List := Tlist(aObject);

      OpenJSONArray(aJSON, aParentTagName);
      for I := 0 to List.Count - 1 do
      begin
        FObject := TObject(List.Items[I]);
        GetSubRttiAttributekeys(aJSON, aParentTagName, aCtx, FObject, False, True, True);
      end;
      CloseJSONArray(aJSON);

      Exit;
    end
    else
    begin
      OpenJSONArray(aJSON, aParentTagName, '{');
      aIsOpenBracket := true;
    end;
  end
  else if aIsListJSONArray then
  begin
    OpenJSONArray(aJSON, '', '{');
    IsSubOpenBracket := true;
    aIsOpenBracket := False;
  end;

  for Prop in aCtx.GetType(aObject.ClassType).GetProperties do
  begin
    PropName := Prop.Name;
    for Att in Prop.GetAttributes do
    begin
      TagName := TAmazonMarshallerAttribute(Att).TagName;
      RttiType := Prop.PropertyType;

      case RttiType.TypeKind of
        tkInteger, tkLString, tkWString, tkString:
          begin
            Val := Prop.GetValue(aObject);
            TagValue := Val.ToString;
            AddJSONString(RttiType.TypeKind, aJSON, TagName, TagValue,
              aIsClass, aIsOpenBracket, aIsListJSONArray, IsSubOpenBracket);
          end;
        tkClass:
          begin
            Val := Prop.GetValue(aObject);
            GetSubRttiAttributekeys(aJSON, TagName, aCtx, Val.AsObject, true);
          end;
      end;

      IsSubOpenBracket := False;
    end;
  end;

  if aIsClass then
    CloseJSONArray(aJSON, '}', aIsClass)
  else if aIsListJSONArray then
  begin
    IsSubOpenBracket := False;
    CloseJSONArray(aJSON, '}', False);
  end;
end;

function TAmazonMarshaller.IsAnyKindOfGenericList(AType: TRttiType): Boolean;
begin
  Result := False;
  while AType <> nil do
  begin
    Result := StartsText('TList<', AType.Name);
    if Result then
      Exit;
    AType := AType.BaseType;
  end;
end;

procedure TAmazonMarshaller.AddJSONString(aTypeKind: TTypeKind;
  var aJSON: TStringList; aTagName, aTagValue: UTF8String; aIsClass: Boolean;
  var aIsOpenBracket: Boolean; aIsListJSONArray: Boolean = False;
  aIsSubOpenBracket: Boolean = False);
var
  JSONLine: UTF8String;
begin
  case aTypeKind of
    tkInteger: JSONLine := DoubleQuotedStr(aTagName) + ':' + aTagValue;
  else
    JSONLine := DoubleQuotedStr(aTagName) + ':' + DoubleQuotedStr(aTagValue);
  end;

  if not aIsClass then
  begin
    if aJSON.Count > 0 then
    begin
      if aIsListJSONArray then
      begin
        if not aIsSubOpenBracket then
          aJSON.Strings[aJSON.Count - 1] := aJSON.Strings[aJSON.Count - 1] + ','
      end
      else if Not aIsOpenBracket then
        aJSON.Strings[aJSON.Count - 2] := aJSON.Strings[aJSON.Count - 2] + ','
    end;

    aJSON.Add(JSONLine);
  end
  else
  begin
    if aIsOpenBracket then
    begin
      aJSON.Strings[aJSON.Count - 1] := aJSON.Strings[aJSON.Count - 1] +
        JSONLine;
      aIsOpenBracket := False;
    end
    else
      aJSON.Strings[aJSON.Count - 1] := aJSON.Strings[aJSON.Count - 1] + ',' +
        JSONLine;
  end;
end;

procedure TAmazonMarshaller.AddJSONArray(var aJSON: TStringList;
  aTagName, aTagValue: UTF8String);
Var
  JSONLine: UTF8String;
begin
  JSONLine := '{' + DoubleQuotedStr(aTagName) + ':' +
    DoubleQuotedStr(aTagValue) + '}';

  aJSON.Add(JSONLine);
end;

procedure TAmazonMarshaller.OpenJSONArray(var aJSON: TStringList;
  aParentTagName: UTF8String; aOpenBracket: UTF8String = '[');
Var
  JSONLine: UTF8String;
begin
  if aParentTagName <> '' then
  begin
    JSONLine := '"' + aParentTagName + '": ' + aOpenBracket;
    if aJSON.Count > 0 then
    begin
      aJSON.Strings[aJSON.Count - 1] := aJSON.Strings[aJSON.Count - 1] + ',';
    end
  end
  else
    JSONLine := aOpenBracket;
  aJSON.Add(JSONLine);
end;

procedure TAmazonMarshaller.CloseJSONArray(var aJSON: TStringList;
  aCloseBracket: UTF8String = ']'; aIsClass: Boolean = False);
begin
  if not aIsClass then
    aJSON.Add(aCloseBracket)
  else
    aJSON.Strings[aJSON.Count - 1] := aJSON.Strings[aJSON.Count - 1] +
      aCloseBracket;
end;

end.
