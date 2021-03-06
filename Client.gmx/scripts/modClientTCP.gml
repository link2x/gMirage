Option Explicit

' ******************************************
' **            Mirage Source 4           **
' ** Communcation to server, TCP          **
' ** Winsock Control (mswinsck.ocx)       **
' ** String packets (slow and big)        **
' ******************************************

' TCP variables
Private PlayerBuffer As String

' Used for parsing String packets
Public SEP_CHAR As String * 1
Public END_CHAR As String * 1

Public Sub TcpInit()

    ' used for parsing packets
    SEP_CHAR = Chr$(1) 'vbNullChar ' ChrW$(0)
    END_CHAR = Chr$(2)
    
    ' check if IP is valid
    If IsIP(GAME_IP) Then
        frmMirage.Socket.RemoteHost = GAME_IP
        frmMirage.Socket.RemotePort = GAME_PORT
    Else
        MsgBox GAME_IP & " does not appear as a valid IP address!"
        DestroyGame
    End If
        
End Sub

Public Sub DestroyTCP()
    frmMirage.Socket.Close
End Sub

Public Sub IncomingData(ByVal DataLength As Long)
Dim Buffer As String
Dim Packet As String
Dim Start As Integer

    frmMirage.Socket.GetData Buffer, vbString, DataLength
    PlayerBuffer = PlayerBuffer & Buffer
        
    Start = InStr(PlayerBuffer, END_CHAR)
    Do While Start > 0
        Packet = Mid$(PlayerBuffer, 1, Start - 1)
        PlayerBuffer = Mid$(PlayerBuffer, Start + 1, Len(PlayerBuffer))
        Start = InStr(PlayerBuffer, END_CHAR)
        
        If Len(Packet) > 0 Then
            Call HandleData(Packet)
        End If
    Loop
End Sub

Public Function ConnectToServer() As Boolean
Dim Wait As Long

    ' Check to see if we are already connected, if so just exit
    If IsConnected Then
        ConnectToServer = True
        Exit Function
    End If

    Wait = GetTickCount
    
    With frmMirage.Socket
        .Close
        .Connect
    End With
    
    Call SetStatus("Connecting to server...")
    
    ' Wait until connected or a few seconds have passed and report the server being down
    Do While (Not IsConnected) And (GetTickCount <= Wait + 3500)
        DoEvents
        Sleep 20
    Loop
    
    ' return value
    If IsConnected Then
        ConnectToServer = True
    End If
    
End Function

Private Function IsIP(ByVal IPAddress As String) As Boolean
Dim s() As String
Dim i As Long

    ' Check if connecting to localhost or URL
    If IPAddress = "localhost" Or InStr(1, IPAddress, "http://", vbTextCompare) = 1 Then
        IsIP = True
        Exit Function
    End If

    'If there are no periods, I have no idea what we have...
    If InStr(1, IPAddress, ".") = 0 Then Exit Function
    
    'Split up the string by the periods
    s = Split(IPAddress, ".")
    
    'Confirm we have ubound = 3, since xxx.xxx.xxx.xxx has 4 elements and we start at index 0
    If UBound(s) <> 3 Then Exit Function
    
    'Check that the values are numeric and in a valid range
    For i = 0 To 3
        If Val(s(i)) < 0 Then Exit Function
        If Val(s(i)) > 255 Then Exit Function
    Next
    
    'Looks like we were passed a valid IP!
    IsIP = True
    
End Function

Public Function IsConnected() As Boolean
    If frmMirage.Socket.State = sckConnected Then
        IsConnected = True
    End If
End Function

Public Function IsPlaying(ByVal Index As Long) As Boolean
    If LenB(GetPlayerName(Index)) > 0 Then
        IsPlaying = True
    End If
End Function

Public Sub SendData(ByVal Data As String)
    ' check if connection exist, otherwise will error
    If IsConnected Then
        frmMirage.Socket.SendData Data
        DoEvents
    End If
End Sub

' *****************************
' ** Outgoing Client Packets **
' *****************************

Public Sub SendNewAccount(ByVal Name As String, ByVal Password As String)
Dim Packet As String

    Packet = CNewAccount & SEP_CHAR & Trim$(Name) & SEP_CHAR & Trim$(Password) & END_CHAR
    Call SendData(Packet)
End Sub

Public Sub SendDelAccount(ByVal Name As String, ByVal Password As String)
Dim Packet As String
    
    Packet = CDelAccount & SEP_CHAR & Trim$(Name) & SEP_CHAR & Trim$(Password) & END_CHAR
    Call SendData(Packet)
End Sub

Public Sub SendLogin(ByVal Name As String, ByVal Password As String)
Dim Packet As String

    Packet = CLogin & SEP_CHAR & Trim$(Name) & SEP_CHAR & Trim$(Password) & SEP_CHAR & App.Major & SEP_CHAR & App.Minor & SEP_CHAR & App.Revision & END_CHAR
    Call SendData(Packet)
End Sub

Public Sub SendAddChar(ByVal Name As String, ByVal Sex As Long, ByVal ClassNum As Long, ByVal Slot As Long)
Dim Packet As String

    Packet = CAddChar & SEP_CHAR & Trim$(Name) & SEP_CHAR & Sex & SEP_CHAR & ClassNum & SEP_CHAR & Slot & END_CHAR
    Call SendData(Packet)
End Sub

Public Sub SendDelChar(ByVal Slot As Long)
Dim Packet As String
    
    Packet = CDelChar & SEP_CHAR & Slot & END_CHAR
    Call SendData(Packet)
End Sub

Public Sub SendGetClasses()
Dim Packet As String

    Packet = CGetClasses & END_CHAR
    Call SendData(Packet)
End Sub

Public Sub SendUseChar(ByVal CharSlot As Long)
Dim Packet As String

    Packet = CUseChar & SEP_CHAR & CharSlot & END_CHAR
    Call SendData(Packet)
End Sub

Public Sub SayMsg(ByVal Text As String)
Dim Packet As String

    Packet = CSayMsg & SEP_CHAR & Text & END_CHAR
    Call SendData(Packet)
End Sub

Public Sub GlobalMsg(ByVal Text As String)
Dim Packet As String

    Packet = CGlobalMsg & SEP_CHAR & Text & END_CHAR
    Call SendData(Packet)
End Sub

Public Sub BroadcastMsg(ByVal Text As String)
Dim Packet As String

    Packet = CBroadcastMsg & SEP_CHAR & Text & END_CHAR
    Call SendData(Packet)
End Sub

Public Sub EmoteMsg(ByVal Text As String)
Dim Packet As String

    Packet = CEmoteMsg & SEP_CHAR & Text & END_CHAR
    Call SendData(Packet)
End Sub

Public Sub PlayerMsg(ByVal Text As String, ByVal MsgTo As String)
Dim Packet As String

    Packet = CPlayerMsg & SEP_CHAR & MsgTo & SEP_CHAR & Text & END_CHAR
    Call SendData(Packet)
End Sub

Public Sub AdminMsg(ByVal Text As String)
Dim Packet As String

    Packet = CAdminMsg & SEP_CHAR & Text & END_CHAR
    Call SendData(Packet)
End Sub

Public Sub SendPlayerMove()
Dim Packet As String

    Packet = CPlayerMove & SEP_CHAR & GetPlayerDir(MyIndex) & SEP_CHAR & Player(MyIndex).Moving & END_CHAR
    Call SendData(Packet)
End Sub

Public Sub SendPlayerDir()
Dim Packet As String

    Packet = CPlayerDir & SEP_CHAR & GetPlayerDir(MyIndex) & END_CHAR
    Call SendData(Packet)
End Sub

Public Sub SendPlayerRequestNewMap()
Dim Packet As String
    
    Packet = CRequestNewMap & SEP_CHAR & GetPlayerDir(MyIndex) & END_CHAR
    Call SendData(Packet)
End Sub

Public Sub SendMap()
Dim Packet As String
Dim X As Long
Dim Y As Long

    CanMoveNow = False
    
    With Map
        Packet = CMapData & SEP_CHAR & Trim$(.Name) & SEP_CHAR & .Moral & SEP_CHAR & .TileSet & SEP_CHAR & .Up & SEP_CHAR & .Down & SEP_CHAR & .Left & SEP_CHAR & .Right & SEP_CHAR & .Music & SEP_CHAR & .BootMap & SEP_CHAR & .BootX & SEP_CHAR & .BootY & SEP_CHAR & .Shop
    End With
    
    For X = 0 To MAX_MAPX
        For Y = 0 To MAX_MAPY
            With Map.Tile(X, Y)
                Packet = Packet & SEP_CHAR & .Ground & SEP_CHAR & .Mask & SEP_CHAR & .Anim & SEP_CHAR & .Fringe & SEP_CHAR & .Type & SEP_CHAR & .Data1 & SEP_CHAR & .Data2 & SEP_CHAR & .Data3
            End With
        Next
    Next
    
    With Map
        For X = 1 To MAX_MAP_NPCS
            Packet = Packet & SEP_CHAR & .Npc(X)
        Next
    End With
    
    Packet = Packet & END_CHAR
    
    Call SendData(Packet)
End Sub

Public Sub WarpMeTo(ByVal Name As String)
Dim Packet As String

    Packet = CWarpMeTo & SEP_CHAR & Name & END_CHAR
    Call SendData(Packet)
End Sub

Public Sub WarpToMe(ByVal Name As String)
Dim Packet As String

    Packet = CWarpToMe & SEP_CHAR & Name & END_CHAR
    Call SendData(Packet)
End Sub

Public Sub WarpTo(ByVal MapNum As Long)
Dim Packet As String
    
    Packet = CWarpTo & SEP_CHAR & MapNum & END_CHAR
    Call SendData(Packet)
End Sub

Public Sub SendSetAccess(ByVal Name As String, ByVal Access As Byte)
Dim Packet As String

    Packet = CSetAccess & SEP_CHAR & Name & SEP_CHAR & Access & END_CHAR
    Call SendData(Packet)
End Sub

Public Sub SendSetSprite(ByVal SpriteNum As Long)
Dim Packet As String

    Packet = CSetSprite & SEP_CHAR & SpriteNum & END_CHAR
    Call SendData(Packet)
End Sub

Public Sub SendKick(ByVal Name As String)
Dim Packet As String

    Packet = CKickPlayer & SEP_CHAR & Name & END_CHAR
    Call SendData(Packet)
End Sub

Public Sub SendBan(ByVal Name As String)
Dim Packet As String

    Packet = CBanPlayer & SEP_CHAR & Name & END_CHAR
    Call SendData(Packet)
End Sub

Public Sub SendBanList()
Dim Packet As String

    Packet = CBanList & END_CHAR
    Call SendData(Packet)
End Sub

Public Sub SendRequestEditItem()
Dim Packet As String

    Packet = CRequestEditItem & END_CHAR
    Call SendData(Packet)
End Sub

Public Sub SendSaveItem(ByVal ItemNum As Long)
Dim Packet As String
    
    With Item(ItemNum)
        Packet = CSaveItem & SEP_CHAR & ItemNum & SEP_CHAR & Trim$(.Name) & SEP_CHAR & .Pic & SEP_CHAR & .Type & SEP_CHAR & .Data1 & SEP_CHAR & .Data2 & SEP_CHAR & .Data3 & END_CHAR
    End With
    
    Call SendData(Packet)
End Sub

Public Sub SendRequestEditNpc()
Dim Packet As String

    Packet = CRequestEditNpc & END_CHAR
    Call SendData(Packet)
End Sub

Public Sub SendSaveNpc(ByVal NpcNum As Long)
Dim Packet As String
    
    With Npc(NpcNum)
        Packet = CSaveNpc & SEP_CHAR & NpcNum & SEP_CHAR & Trim$(.Name) & SEP_CHAR & Trim$(.AttackSay) & SEP_CHAR & .Sprite & SEP_CHAR & .SpawnSecs & SEP_CHAR & .Behavior & SEP_CHAR & .Range & SEP_CHAR & .DropChance & SEP_CHAR & .DropItem & SEP_CHAR & .DropItemValue & SEP_CHAR & .Stat(Stats.Strength) & SEP_CHAR & .Stat(Stats.Defense) & SEP_CHAR & .Stat(Stats.SPEED) & SEP_CHAR & .Stat(Stats.Magic) & END_CHAR
    End With
    
    Call SendData(Packet)
End Sub

Public Sub SendMapRespawn()
Dim Packet As String

    Packet = CMapRespawn & END_CHAR
    Call SendData(Packet)
End Sub

Public Sub SendUseItem(ByVal InvNum As Long)
Dim Packet As String

    Packet = CUseItem & SEP_CHAR & InvNum & END_CHAR
    Call SendData(Packet)
End Sub

Public Sub SendDropItem(ByVal InvNum As Long, ByVal Amount As Long)
Dim Packet As String

    Packet = CMapDropItem & SEP_CHAR & InvNum & SEP_CHAR & Amount & END_CHAR
    Call SendData(Packet)
End Sub

Public Sub SendWhosOnline()
Dim Packet As String

    Packet = CWhosOnline & END_CHAR
    Call SendData(Packet)
End Sub

Public Sub SendMOTDChange(ByVal MOTD As String)
Dim Packet As String

    Packet = CSetMotd & SEP_CHAR & MOTD & END_CHAR
    Call SendData(Packet)
End Sub

Public Sub SendRequestEditShop()
Dim Packet As String

    Packet = CRequestEditShop & END_CHAR
    Call SendData(Packet)
End Sub

Public Sub SendSaveShop(ByVal ShopNum As Long)
Dim Packet As String
Dim i As Long

    With Shop(ShopNum)
        Packet = CSaveShop & SEP_CHAR & ShopNum & SEP_CHAR & Trim$(.Name) & SEP_CHAR & Trim$(.JoinSay) & SEP_CHAR & Trim$(.LeaveSay) & SEP_CHAR & .FixesItems
    End With
    
    For i = 1 To MAX_TRADES
        With Shop(ShopNum).TradeItem(i)
            Packet = Packet & SEP_CHAR & .GiveItem & SEP_CHAR & .GiveValue & SEP_CHAR & .GetItem & SEP_CHAR & .GetValue
        End With
    Next
    
    Packet = Packet & END_CHAR
    Call SendData(Packet)
End Sub

Public Sub SendRequestEditSpell()
Dim Packet As String

    Packet = CRequestEditSpell & END_CHAR
    Call SendData(Packet)
End Sub

Public Sub SendSaveSpell(ByVal SpellNum As Long)
Dim Packet As String

    With Spell(SpellNum)
        Packet = CSaveSpell & SEP_CHAR & SpellNum & SEP_CHAR & Trim$(.Name) & SEP_CHAR & .Pic & SEP_CHAR & .MPReq & SEP_CHAR & .ClassReq & SEP_CHAR & .LevelReq & SEP_CHAR & .Type & SEP_CHAR & .Data1 & SEP_CHAR & .Data2 & SEP_CHAR & .Data3 & END_CHAR
    End With
    
    Call SendData(Packet)
End Sub

Public Sub SendRequestEditMap()
Dim Packet As String

    Packet = CRequestEditMap & END_CHAR
    Call SendData(Packet)
End Sub

Public Sub SendPartyRequest(ByVal Name As String)
Dim Packet As String

    Packet = CParty & SEP_CHAR & Name & END_CHAR
    Call SendData(Packet)
End Sub

Public Sub SendJoinParty()
Dim Packet As String

    Packet = CJoinParty & END_CHAR
    Call SendData(Packet)
End Sub

Public Sub SendLeaveParty()
Dim Packet As String

    Packet = CLeaveParty & END_CHAR
    Call SendData(Packet)
End Sub

Public Sub SendBanDestroy()
Dim Packet As String
    
    Packet = CBanDestroy & END_CHAR
    Call SendData(Packet)
End Sub


