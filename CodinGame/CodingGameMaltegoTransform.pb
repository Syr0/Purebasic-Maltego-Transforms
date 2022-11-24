IncludeFile "C:\Users\User\Desktop\Codes\Purebasic-Maltego-Transforms\MaltegoLocalTransformLib.pb"


 Input.InputParams
 Maltego_ReadInput(Input.InputParams)
 
 ForEach Input\Params()
   If Input\Params()\Property("Alias")
     nickname$ = Input\Params()\Property("alias")
   EndIf
 Next
 nickname$ = "John"
 
 If OpenWindow(0, 0, 0, 600, 300, "WebGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered) 
    WebGadget(0, 10, 10, 580, 280, "https://www.codingame.com/contests/cultist-wars/leaderboard/Global?column=keyword&value="+nickname$) 
    
    Repeat 
    Until WaitWindowEvent() = #PB_Event_CloseWindow 
  EndIf

  
  ;Skills
  ;Programming Languages
  ;Friends
  ;Team
  ;Country
  
NewMap AdditionalFields.Field()
; AdditionalFields("Time")\DisplayName = "Time"
; AdditionalFields("Time")\Value = "test"
; AdditionalFields("Time")\MatchingRule = #MaltegoType_MatchingRule
; 
; AddMaltegoCustomEntity("University","value",AdditionalFields(),"")


; ForEach Result()
;     AddMaltegoCustomEntity("ipv4-address",FlowResult()\src_ip_addr,AdditionalFields())
;     AddMaltegoCustomEntity("port",FlowResult()\dst_port,AdditionalFields())
; Next


Maltego_Output()
; IDE Options = PureBasic 6.00 LTS (Windows - x64)
; CursorPosition = 14
; FirstLine = 4
; EnableThread
; EnableXP
; DPIAware