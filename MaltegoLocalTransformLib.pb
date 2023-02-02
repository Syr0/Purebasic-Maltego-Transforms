OpenConsole() 
#MaltegoType_Email = "EmailAddress"
#MaltegoType_Person = "Person"

#MaltegoType_MatchingRule = "loose"

Structure Field
  DisplayName.s
  MatchingRule.s
  Value.s
EndStructure

Structure MaltegoEntity
  Type.s
  Value.s
  Weight.i
  ConnectionLabel.s
  Map AdditionalFields.Field()
  List ConnectionLabelProperties.s();Not Implemented
  ;{
  ; AdditionalFields("link#0")\DisplayName = "My first edge property"
  ; AdditionalFields("link#0")\Value = "My first edge property value"
  ; AdditionalFields("link#0")\MatchingRule = #MaltegoType_MatchingRule
  ; 
  ; AdditionalFields("link#1")\DisplayName = "My second edge property"
  ; AdditionalFields("link#1")\Value = "My second edge property value"
  ; AdditionalFields("link#1")\MatchingRule = #MaltegoType_MatchingRule
  ;}
  VisibleConnectionLabelIndex.i
EndStructure

Global NewList MaltegoReturnEntities.MaltegoEntity()

Procedure AddMaltegoCustomEntity(Type.s,Value.s,Map *AdditionalFields.Field(), LinkLabel.s="",Weight=0)
  ;Basic Information
  AddElement(MaltegoReturnEntities())
  MaltegoReturnEntities()\Type = Type
  MaltegoReturnEntities()\Value = Value
  MaltegoReturnEntities()\Weight = Weight
  
  ;Additional dynamic properties
  CopyMap(*AdditionalFields(),MaltegoReturnEntities()\AdditionalFields())
  
  If Len(LinkLabel) > 0
    ;Label on Arrow:
    MaltegoReturnEntities()\AdditionalFields("link#maltego.link.label")\DisplayName = "link#maltego.link.label"
    MaltegoReturnEntities()\AdditionalFields("link#maltego.link.label")\Value = LinkLabel
    MaltegoReturnEntities()\AdditionalFields("link#maltego.link.label")\MatchingRule = #MaltegoType_MatchingRule
    
    MaltegoReturnEntities()\AdditionalFields("link#maltego.link.show-label")\DisplayName = "link#maltego.link.show-label"
    MaltegoReturnEntities()\AdditionalFields("link#maltego.link.show-label")\Value = "1"
    MaltegoReturnEntities()\AdditionalFields("link#maltego.link.show-label")\MatchingRule = #MaltegoType_MatchingRule
  EndIf

EndProcedure

;{ Templates
Procedure Maltego_PersonEnrichEntity(EntityType.s,EntityValue.s,firstname.s="",lastname.s="",AutogenerateName=0)
  ForEach MaltegoReturnEntities()
    If MaltegoReturnEntities()\Type = EntityType And MaltegoReturnEntities()\Value = EntityValue
      MaltegoReturnEntities()\AdditionalFields("firstname")\Value = firstname
      MaltegoReturnEntities()\AdditionalFields("lastname")\Value = lastname
      If AutogenerateName
        MaltegoReturnEntities()\Value = ""
      EndIf
    Else
      Continue
    EndIf
  Next    
EndProcedure

;}

Structure Properties
  Map Property.s()
EndStructure

Structure InputParams
  List Params.Properties()
EndStructure

Procedure Maltego_ReadInput(*Input.InputParams)
  For x = 1 To CountProgramParameters()
    
    Param$ = ProgramParameter()
    If FindString(Param$,"=")
      For y = 1 To CountString(Param$,"#")+1
        AddElement(*Input\Params())
        tempString.s = StringField(Param$,y,"#")
        a.s = StringField(tempString,1,"=")
        b.s = StringField(tempString,2,"=")
        *Input\Params()\Property(a) = b
      Next
      
    Else
      AddElement(*Input\Params())
      *Input\Params()\Property(Param$) = Param$
    EndIf
  Next
  
EndProcedure

;{ Documentation
;Param 1 = "Hans Wurst"
;Param 2 = "person.fullname=Hans Wurst#firstname=Hans#lastname=Wurst"
;Param 3 = ""
;}

Procedure.s CreateMaltegoStdoutXml()
  result$ = "<MaltegoMessage>"
  result$ + "<MaltegoTransformResponseMessage>"
  result$ + "  <Entities>"
  
  ForEach MaltegoReturnEntities()
    result$ + "    <Entity Type="+Chr(34)+MaltegoReturnEntities()\Type+Chr(34)+">"
    result$ + "      <Value>"+Chr(34)+MaltegoReturnEntities()\Value+Chr(34)+"</Value>"
    result$ + "      <Weight>"+MaltegoReturnEntities()\Weight+"</Weight>"
    If MapSize(MaltegoReturnEntities()\AdditionalFields()) > 0
      result$ + "<AdditionalFields>"
      ForEach MaltegoReturnEntities()\AdditionalFields()
        result$ + "<Field Name="+Chr(34)+MapKey(MaltegoReturnEntities()\AdditionalFields())+Chr(34)+" "
        result$ + "DisplayName="+Chr(34)+MaltegoReturnEntities()\AdditionalFields()\DisplayName+Chr(34)+" "
        result$ + "MatchingRule="+Chr(34)+MaltegoReturnEntities()\AdditionalFields()\MatchingRule+Chr(34)+" "
        result$ + ">"+MaltegoReturnEntities()\AdditionalFields()\Value+"</Field>"
      Next
      result$ + "</AdditionalFields>"
    EndIf
    result$ + "    </Entity>"
  Next
  
  result$ + "  </Entities>"
  result$ + "</MaltegoTransformResponseMessage>"
  result$ + "</MaltegoMessage>"
  ProcedureReturn result$
EndProcedure

; NewMap AdditionalFields.Field()
; AdditionalFields("Age")\DisplayName = "Age"
; AdditionalFields("Age")\Value = "45"
; AdditionalFields("Age")\MatchingRule = #MaltegoType_MatchingRule
; 
; AdditionalFields("HairColor")\DisplayName = "Hair Color"
; AdditionalFields("HairColor")\Value = "Blond"
; AdditionalFields("HairColor")\MatchingRule = #MaltegoType_MatchingRule

; AddMaltegoCustomEntity(#MaltegoType_Person,"Hans Wurst",AdditionalFields(),"Geiler Scheiss")
; Maltego_PersonEnrichEntity(#MaltegoType_Person,"Hans Wurst","Hans","Wurst",1)
; Output

Procedure Maltego_Output()
MaltegoXmlStdOutString.s = CreateMaltegoStdoutXml()
Print(MaltegoXmlStdOutString)
FlushFileBuffers_(GetStdHandle_(#STD_OUTPUT_HANDLE))
EndProcedure

; IDE Options = PureBasic 6.00 LTS (Windows - x64)
; ExecutableFormat = Console
; CursorPosition = 5
; Folding = B9
; EnableThread
; EnableXP
; DPIAware
; Executable = ..\Bitmasker\IACR-Scaper\IACR_StudentToPublicationTransform.exe