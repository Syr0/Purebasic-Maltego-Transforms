key.s = "4a565e5663c2db057cb60a33538a05580e801937"

;{
Enumeration
  #Statuscode_Finished
  #Statuscode_Processing
  #Statuscode_Error
EndEnumeration

Structure Jobstructure
  priority.i
  created_at.s
  user_id.i 
  name.s     
  updated_at.s
  id.i       
  description.s
EndStructure
Structure QueriesStructure
  timeout.i
  format.s
  start_date.s
  id.i
  limit.i
  List any_port.i()
  List exclude_any_port.i()
  List num_octets_range.i()
  List exclude_num_octets_range.s()
  List exclude_src_cc.s()
  List cc.s()
  List port.s()
  List exclude_tcp_flags.s()
  List exclude_cc.s()
  List exclude_port.s()
  List any_cidr.s()
  List tcp_flags.s()
  List any_port_range.s()
  List cidr.s()
  List class.s()
  List exclude_any_port_range.s()
  List num_octets.s()
  List port_range.s()
  List exclude_tcp_flags_range.s()
  List exclude_num_octets.s()
  List exclude_proto.s()
  List exclude_port_range.s()
  List exclude_ip_addr.s()
  List tcp_flags_range.s()
  List proto.s()
  List ip_addr.s()
  List exclude_any_ip_addr.s()
  List query_type.s()
  List end_date.s()
  List any_cc.s()
  List any_ip_addr.s()
  List exclude_any_cc.s()
  List qname.s()
  List exclude_dst_cc.s()
  List section.s()
  List src_cidr.s()
  List src_ip_addr.s()
  List ttl.s()
  List ttl_range.s()
  List type.s()
  List exclude_class.s()
  List exclude_qname.s()
  List exclude_rdata.s()
  List exclude_section.s()
  List exclude_src_ip_addr.s()
  List exclude_ttl.s()
  List exclude_ttl_range.s()
  List exclude_type.s()
  List rdata.s()
  List rdata_cidr.s()
EndStructure

Structure ResponseStructure
  job.Jobstructure
  List queries.QueriesStructure()
EndStructure

Structure query_type
  any_cc.s ;ISO-3166 CountryCodes
  any_ip_addr.s ;0.0.0.0, 0.0.0.0/24 ODER 0.0.0.0 - 1.1.1.1
  any_port.s    ; 80,443,100-250
  cc.s;Country Code;ISO-3166 Country Code(Geographical city of Source or Destination IP Address);CH, US
  exclude_any_cc.s;Exclude CC;Exclude any ISO-3166 Country Code(Geographical city of Any IP Address);CH, US
  exclude_any_ip_addr.s;Exclude IP Address;Excludes any IP Address for all IP Address fields in query type;1.1.1.1
  exclude_any_port.s;Exclude Port;Exclude Any Port/Port Range value for all port fields in this query type;80,443,100-250
  exclude_cc.s;Exclude ISO-3166 Country Code(Geographical city of Source or Destination IP Address);CH, US
  exclude_dst_cc.s;Exclude ISO-3166 Country Code(Geographical city of Destination IP Address);CH, US
  exclude_ip_addr.s;Exclude IP Address;Exclude Source IP or Destination IP (direction flow perspective);1.1.1.1
  exclude_num_octets.s;Exclude Number/Number Range of layer 3 bytes observed in network flow;1, 3-5
  exclude_port.s;Exclude The TCP/UDP source or destination Port/Port Range (or equivalent) of the network flow;80,443,100-250
  exclude_proto.s;Exclude Proto;Exclude The IP protocol number in decimal format;6, 17, 20
  exclude_src_cc.s;Exclude ISO-3166 Country Code(Geographical city of Source IP Address);CH, US
  exclude_tcp_flags.i;Exclude Cumulative OR of TCP flags in decimal format;1, 3-5
  ip_addr.s;IP Address;Source IP or Destination IP (direction flow perspective);0.0.0.0, 0.0.0.0/24, 0.0.0.0 - 1.1.1.1
  num_octets.i;Bytes;Number/Number Range of layer 3 bytes observed in network flow;1, 3-5
  port.s;The TCP/UDP source or destination port (or equivalent) of the network flow;80,443,100-250
  proto.s;Proto;The IP protocol number in decimal format;6, 17, 20
  tcp_flags.s;TCP Flags;Cumulative OR of TCP flags in decimal format. Please note, if flows are aggregates of the packets seen, you can end up with flag combinations that don't make sense for individual packets. 1 - FIN, 2 - SYN, 4 - RST, 8 - PSH, 16 - ACK, 32 - URG, 64 - ECE, 128 - CWR
  query_type.s;apt_dns, apt_dnsrr, apt_hostname, apt_ip, apt_malware, ddos_attacks, ddos_commands, bars_controllers, bars_victims, dns_derived_domains_via_domain, dns_derived_domains_via_ip, dns_derived_ips_via_domain, dns_derived_ips_via_ip, banners_ptr, dns_query, nmap_dnsrr, pdns, pdns_nxd, pdns_other, banners, dns_fingerprint, ja3, nmap_port, nmap_fingerprint, ntp_server, open_ports, os_fingerprint, tor, router, sip, snmp, ssh, x509, antipaste, compromised_hosts, open_resolvers, spam_domains, spam_headers, flows, bgp_updates, bgp_history, bgp_info, conpot_honeypot, cowrie_honeypot, darknet, dionaea_honeypot, portscan, scanner, beacons, cookies, urls, useragents
EndStructure

Structure RequestStructure
  job_name.s
  job_description.s
  start_date.s
  end_date.s
  timeout.i
  priority.i
  group_id.i
  List queries.query_type()
EndStructure

Structure SchedulerStructure
  JobID.i
  LastCheckTime.i
EndStructure
;}
Structure Flows
  src_ip_addr.s
  dst_ip_addr.s
  src_port.s
  dst_port.s
EndStructure
Global NewList FlowResult.Flows()

;{
Global Auth.s
Global _Scheduler_EndNow.b = 1
Global NewList _Scheduler_JobIDs.SchedulerStructure()
Global _Scheduler_ControlMutex = CreateMutex()
Global _Scheduler_Intervall = 1000
Global _Scheduler_ThreadId = 0
Global _ResponseStruct.ResponseStructure
;}

Procedure.s CreateAuth(APIkey.s="",Username.s="",Pass.s="")
  If APIkey
    ProcedureReturn "Token "+APIkey
  Else
    If Len(UserName) <= 0 Or Len(pass) <= 0
      ProcedureReturn "ERROR, need credentials"
    Else
      Credentials.s = UserName+":"+Pass
      B64Credentials.s = Base64Encoder(@Credentials,Len(Credentials))
      ProcedureReturn "Basic "+B64Credentials
    EndIf
  EndIf
EndProcedure

;TODO
Auth.s = CreateAuth(key)

Procedure PermaSaveJob(JobID.i,RequestJson.s)
EndProcedure

Procedure PermaSaveJobResult(jobID,_ResponseStruct)
EndProcedure

Procedure InterpretStatusCode(Status.s)
  Select status 
    Case "200"
      ProcedureReturn #Statuscode_finished
    Case "206"
      Debug "Incomplete Data - Your request was successful, however not all of the requested data was returned. This normally happens when downloading results from a query that is not yet complete."
      ProcedureReturn #Statuscode_processing
    Case "400"
      Debug "Input Parameter Error"
      ProcedureReturn #Statuscode_error
    Case "401"
      Debug "Authentication Error - There was an error with your username and/or password."
      ProcedureReturn #Statuscode_error
    Case "403"
      Debug "Authorization Error - You are not authorized to view this resource."
      ProcedureReturn #Statuscode_error
    Case "422"
      Debug "Validation Error - There was a problem with one or more of your input values. A json body will return with detailed information of which fields to update."
      ProcedureReturn #Statuscode_error
    Case "429"
      Debug "Too Many Requests - There was a problem with the number of requests being submitted at one time. A maximum of one request per second is permitted, subject to change."
      ProcedureReturn #Statuscode_error
    Case "500"
      Debug "Internal Error - There was an internal server error. Please contact support to investigate this."
      ProcedureReturn #Statuscode_error
    Default
      Debug "ErrorCode: "+Status
      ProcedureReturn #Statuscode_error
  EndSelect
EndProcedure

Procedure ResponseInterpreter(ResponseString.s)
  If ResponseString = ""
    Debug "There was no response!"
    Debug ""
  EndIf
  
  ParseJSON(0,ResponseString)
  If ExtractJSONStructure(JSONValue(0),@_ResponseStruct,ResponseStructure) > 0
    ShowLibraryViewer("json",0)
    Debug "There was an error on extracting the json!"
    Debug ""
  EndIf
  FreeJSON(0)
  ProcedureReturn _ResponseStruct\job\id
EndProcedure

Procedure FlowJsonInterpreter(jsonBuffer)
  json.s = PeekS(jsonBuffer,MemorySize(jsonBuffer),#PB_UTF8)
  
  If FindString(json,"results"+Chr(34)+":null")
    Debug "no flows found"
    ProcedureReturn
  EndIf
  
  Regex_src_ip_addr = CreateRegularExpression(#PB_Any,"src_ip_addr"+Chr(34)+":"+Chr(34)+"([^\"+Chr(34)+"]+)"+Chr(34))
  Regex_dst_ip_addr = CreateRegularExpression(#PB_Any,"dst_ip_addr"+Chr(34)+":"+Chr(34)+"([^\"+Chr(34)+"]+)"+Chr(34))
  Regex_src_port = CreateRegularExpression(#PB_Any,"src_port"+Chr(34)+":(\d+),")
  Regex_dst_port = CreateRegularExpression(#PB_Any,"dst_port"+Chr(34)+":(\d+),")
  
  For x = 1 To CountString(json,"{")
    line$ = StringField(json,x,"{")
    If line$ = ""
      Continue
    EndIf
    AddElement(FlowResult())
    
    ExamineRegularExpression(Regex_src_ip_addr,line$):NextRegularExpressionMatch(Regex_src_ip_addr)
    FlowResult()\src_ip_addr =RegularExpressionMatchString(Regex_src_ip_addr)
    
    ExamineRegularExpression(Regex_dst_ip_addr,line$):NextRegularExpressionMatch(Regex_dst_ip_addr)
    FlowResult()\dst_ip_addr =RegularExpressionMatchString(Regex_dst_ip_addr)
    
    ExamineRegularExpression(Regex_src_port,line$):NextRegularExpressionMatch(Regex_src_port)
    FlowResult()\src_port =RegularExpressionMatchString(Regex_src_port)
    
    ExamineRegularExpression(Regex_dst_port,line$):NextRegularExpressionMatch(Regex_dst_port)
    FlowResult()\dst_port =RegularExpressionMatchString(Regex_dst_port)
  Next
  
EndProcedure

Procedure ResultScheduler(trash)
  NewMap Headers.s()
  Headers("Content-Type") = "application/x-www-form-urlencoded"
  Headers("Authorization") = Auth
  Repeat
    UnlockMutex(_Scheduler_ControlMutex)
    ForEach _Scheduler_JobIDs()
      If ElapsedMilliseconds() - _Scheduler_JobIDs()\LastCheckTime < _Scheduler_Intervall
        Continue
      EndIf
      
      HTTPRequest = HTTPRequest(#PB_HTTP_Get,"https://recon.cymru.com/api/jobs/"+Str(_Scheduler_JobIDs()\JobID)+"?format=json","",#PB_HTTP_HeadersOnly,Headers())
      statuscode.s = HTTPInfo(HTTPRequest, #PB_HTTP_StatusCode)
      Select InterpretStatusCode(statuscode)
        Case #Statuscode_finished
          FinishHTTP(HTTPRequest)
          ;FIXME
          ;Bug: Beim Erstellen wid ein Ergebnis geladen obwohl eigl klar sein sollte, dass gar kein Ergebnis da ist
          HTTPRequest = HTTPRequest(#PB_HTTP_Get,"http://recon.cymru.com/api/jobs/"+Str(_Scheduler_JobIDs()\JobID)+"?format=json","",#PB_HTTP_Asynchronous,Headers())
          Repeat
            Delay(1)
          Until HTTPProgress(HTTPRequest) = #PB_HTTP_Success
          
          *Puffer = HTTPMemory(HttpRequest)
          f = CreateFile(#PB_Any,GetCurrentDirectory()+"Result_"+Str(_Scheduler_JobIDs()\JobID)+".json")
          WriteData(f,*Puffer,MemorySize(*Puffer))
          CloseFile(f)
          FlowJsonInterpreter(*Puffer)
          FinishHTTP(HTTPRequest)
          
          LockMutex(_Scheduler_ControlMutex)
          DeleteElement(_Scheduler_JobIDs())
          UnlockMutex(_Scheduler_ControlMutex)
          
        Case #Statuscode_Processing
          FinishHTTP(HTTPRequest)
          LockMutex(_Scheduler_ControlMutex)
          _Scheduler_JobIDs()\LastCheckTime = ElapsedMilliseconds()
          UnlockMutex(_Scheduler_ControlMutex)

        Default
          FinishHTTP(HTTPRequest)
          Debug "Problem - Status is not finished and not pending - what happend?!"
      EndSelect
    Next
    Delay(1)
    LockMutex(_Scheduler_ControlMutex)
    If ListSize(_Scheduler_JobIDs()) = 0
      _Scheduler_EndNow = 1
    EndIf
  Until _Scheduler_EndNow = 1
  _Scheduler_ThreadId = 0
  UnlockMutex(_Scheduler_ControlMutex)
EndProcedure

Procedure StartResultScheduler()
  LockMutex(_Scheduler_ControlMutex)
  If _Scheduler_ThreadId = 0
    ForEach _Scheduler_JobIDs()
      _Scheduler_JobIDs()\LastCheckTime = ElapsedMilliseconds()
    Next
    _Scheduler_EndNow = 0
    _Scheduler_ThreadId = CreateThread(@ResultScheduler(),0)  
  EndIf
  
  UnlockMutex(_Scheduler_ControlMutex)
EndProcedure

Procedure StopResultScheduler(ThreadID)
  LockMutex(_Scheduler_ControlMutex)
  _Scheduler_EndNow = 1
  UnlockMutex(_Scheduler_ControlMutex)
EndProcedure

Procedure AddResultScheduler(jobID)
  LockMutex(_Scheduler_ControlMutex)
  
  AddElement(_Scheduler_JobIDs())
  _Scheduler_JobIDs()\LastCheckTime = ElapsedMilliseconds()
  _Scheduler_JobIDs()\JobID = jobID
  _Scheduler_EndNow = 0
  
  Debug "Added JobID: "+Str(jobID)
  UnlockMutex(_Scheduler_ControlMutex)
  StartResultScheduler()
EndProcedure

Procedure Request(*Request.RequestStructure)
  url.s = "https://recon.cymru.com/api/jobs"
  
  CreateJSON(1)
  InsertJSONStructure(JSONValue(1),*Request,RequestStructure)
  payload.s = ComposeJSON(1, #PB_JSON_PrettyPrint)
  
  ;POST PROCESS
  newpayload.s
  For x = 1 To CountString(payload,#LF$)+1
    line$ = StringField(payload,x,#LF$)
    If FindString(line$,": "+Chr(34)+Chr(34)+","+#CR$)
      Continue
    ElseIf FindString(line$,": 0,"+#CR$)
      Continue
    ElseIf FindString(line$,": 0"+#CR$)
      Continue
    ElseIf FindString(line$,": "+Chr(34)+Chr(34)+#CR$)
      Continue
    Else
      newpayload = newpayload + line$
    EndIf
  Next
  payload = newpayload
  
  While FindString(payload," }")
    payload = ReplaceString(payload," }","}")
  Wend
  While FindString(payload,Chr(10)+"}")
    payload = ReplaceString(payload,Chr(10)+"}","}")
  Wend
  
  payload = ReplaceString(payload,#CR$,#LF$)
  payload = ReplaceString(payload,","+#LF$+"}",#LF$+"}")
  
   If CreateJSON(0)
     Person = SetJSONObject(JSONValue(0))
     SetJSONString(AddJSONMember(Person, "job_name"), "Example Job")
     SetJSONString(AddJSONMember(Person, "job_description"), "This job is just an example.")
     SetJSONString(AddJSONMember(Person, "start_date"), "04/26/2017 00:00:00")
     SetJSONString(AddJSONMember(Person, "end_date"), "05/03/2017 23:59:59")
     SetJSONInteger(AddJSONMember(Person, "priority"), 25)
     ArrayValue = SetJSONArray(AddJSONMember(Person, "queries"))
     
     NewArrayObject = SetJSONObject(AddJSONElement(ArrayValue))
     SetJSONString(AddJSONMember(NewArrayObject, "query_type"), "flows")
     SetJSONString(AddJSONMember(NewArrayObject, "any_ip_addr"), "142.250.184.238/24")
     SetJSONInteger(AddJSONMember(NewArrayObject, "any_port"), 10)
     
 ;     NewArrayObject = SetJSONObject(AddJSONElement(ArrayValue))
 ;     SetJSONString(AddJSONMember(NewArrayObject, "query_type"), "pdns")
 ;     SetJSONString(AddJSONMember(NewArrayObject, "any_ip_addr"), "2.2.2.2,8.8.8.0/24")
     
;      payload.s = ComposeJSON(0, #PB_JSON_PrettyPrint)
     FreeJSON(0)
   EndIf
  
  NewMap headers.s()
  headers("Content-Type") = "application/json"
  headers("Authorization") = Auth
  
  HttpRequest = HTTPRequest(#PB_HTTP_Post,url,payload,0,headers())
  If HttpRequest
    Statuscode.s = HTTPInfo(HTTPRequest, #PB_HTTP_StatusCode) 
    Select InterpretStatusCode(Statuscode)
;       Case #Statuscode_finished
;         ResponseInterpreter(HTTPInfo(HTTPRequest, #PB_HTTP_Response))
;         
;         FinishHTTP(HTTPRequest)
;         
;         HTTPRequest = HTTPRequest(#PB_HTTP_Get,"http://recon.cymru.com/api/jobs/"+Str(_ResponseStruct\job\id)+"?format=json","",#PB_HTTP_Asynchronous,Headers())
;         Repeat
;           Delay(1)
;         Until HTTPProgress(HTTPRequest) = #PB_HTTP_Success
;         
;         *Puffer = HTTPMemory(HttpRequest)
;         Response.s = PeekS(*Puffer,MemorySize(*Puffer),#PB_UTF8)
;         jobID = ResponseInterpreter(Response)
;         
;         f = CreateFile(#PB_Any,GetCurrentDirectory()+"Result_"+Str(jobID)+".json")
;         WriteData(f,*Puffer,MemorySize(*Puffer))
;         CloseFile(f)
;         FinishHTTP(HTTPRequest)
;         
;         ProcedureReturn 1
      Case #Statuscode_Processing, #Statuscode_finished
        Response.s = HTTPInfo(HTTPRequest, #PB_HTTP_Response)
        If FindString(Response.s,"Response: ")
          Response = StringField(Response,2,"Response: ")
        EndIf
        ResponseInterpreter(Response)
        ;AddResultScheduler(_ResponseStruct\job\id)
        
        FinishHTTP(HTTPRequest)
        ProcedureReturn 0
      Default
        
        FinishHTTP(HTTPRequest)
        ProcedureReturn -1
    EndSelect
    
  Else
    Debug "Request creation failed"
  EndIf
  
EndProcedure

Procedure CreateFlowQuery(*Queries.query_type,IPAddress.s,Port=0)
  *Queries\query_type = "flows"
  *Queries\ip_addr = IPAddress
  If port > 0
    *Queries\any_port = Str(Port)
  EndIf
EndProcedure

;  AddResultScheduler(4275626)

f = ReadFile(#PB_Any,"C:\Users\User\Desktop\Codes\Purebasic-Maltego-Transforms\CymruAPI\Lazarus_VPNS.txt")
While Eof(f) = 0
  content$ + ReadString(f)+#LF$
Wend
CloseFile(f)

For y = 1 To 9 Step 3
  For x = 1 To CountString(content$,#LF$)+1
    line$ = StringField(content$,x,#LF$)
    Debug line$
    IP$ = Trim(StringField(line$,2,"|"))
    Debug ip$
    
    Request.RequestStructure
    ClearStructure(Request,RequestStructure)
    InitializeStructure(Request,RequestStructure)
     Request\job_name = "Lazarus_VPN - "+IP$
     Request\job_description = ""
     Request\start_date = "2022-"+RSet(Str(y),2,"0")+"-01 00:00:00"
     Request\end_date ="2022-"+RSet(Str(y+2),2,"0")+"-01 23:59:59"
     Request\priority = 5
     AddElement(Request\queries())
     
     CreateFlowQuery(Request\queries(),IP$)
     
     Request(Request)
     Delay(5000)
  Next
Next



; 
; Repeat
;   Delay(1)
; Until _Scheduler_EndNow = 1
; 
; ForEach FlowResult()
;   Debug FlowResult()\dst_ip_addr
; Next


; IDE Options = PureBasic 6.00 LTS (Windows - x64)
; CursorPosition = 463
; FirstLine = 257
; Folding = BA0
; EnableThread
; EnableXP
; DPIAware