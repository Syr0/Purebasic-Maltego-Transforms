IncludeFile "C:\Users\User\Desktop\Codes\Purebasic-Maltego-Transforms\MaltegoLocalTransformLib.pb"
IncludeFile "C:\Users\User\Desktop\Codes\CymruAPI\CymruAPI.pb"


 Input.InputParams
 Maltego_ReadInput(Input.InputParams)
 
 ForEach Input\Params()
   If Input\Params()\Property("ipv4-address")
     IPAddress$ = Input\Params()\Property("ipv4-address")
   EndIf
 Next

Request.RequestStructure
Request\job_name = "Maltego - "+IPAddress$
Request\job_description = ""
Request\end_date = FormatDate("%yyyy-%mm-%dd %hh:%ii:%ss", Date()) ;"2022-05-03 00:00:00"
Jahr = Val(FormatDate("%yyyy", Date()))
Request\start_date = Str(Jahr-1)+FormatDate("-%mm-%dd %hh:%ii:%ss", Date()) ;"2022-11-03 23:59:59"
Request\priority = 25
AddElement(Request\queries())
CreateFlowQuery(Request\queries(),IPAddress$)

Request(Request)

Repeat
  Delay(1)
Until _Scheduler_EndNow = 1


NewMap AdditionalFields.Field()
; AdditionalFields("Time")\DisplayName = "Time"
; AdditionalFields("Time")\Value = "test"
; AdditionalFields("Time")\MatchingRule = #MaltegoType_MatchingRule
; 
; AddMaltegoCustomEntity("University","value",AdditionalFields(),"")


ForEach FlowResult()
  If FlowResult()\dst_ip_addr = IPAddress$
    AddMaltegoCustomEntity("ipv4-address",FlowResult()\src_ip_addr,AdditionalFields())
    AddMaltegoCustomEntity("port",FlowResult()\dst_port,AdditionalFields())
  ElseIf FlowResult()\src_ip_addr = IPAddress$
    AddMaltegoCustomEntity("ipv4-address",FlowResult()\dst_ip_addr,AdditionalFields())
    AddMaltegoCustomEntity("port",FlowResult()\src_port,AdditionalFields())
  EndIf
  
    
Next


Maltego_Output()

; IDE Options = PureBasic 6.00 LTS (Windows - x64)
; ExecutableFormat = Console
; CursorPosition = 44
; FirstLine = 19
; EnableThread
; EnableXP
; Executable = CymruMaltegoTransform.exe