Option Explicit

' ******************************************
' **            Mirage Source 4           **
' ******************************************

Public Function FileExist(ByVal FileName As String, Optional RAW As Boolean = False) As Boolean
    If Not RAW Then
        If LenB(Dir(App.Path & "\" & FileName)) > 0 Then
            FileExist = True
         End If
    Else
        If LenB(Dir(FileName)) > 0 Then
            FileExist = True
        End If
    End If
End Function

Public Sub AddLog(ByVal Text As String)
Dim FileName As String
Dim f As Long

    If DebugMode Then
        If Not frmDebug.Visible Then
            frmDebug.Visible = True
        End If
        
        FileName = App.Path & LOG_PATH & LOG_DEBUG
    
        If Not FileExist(LOG_DEBUG, True) Then
            f = FreeFile
            Open FileName For Output As #f
            Close #f
        End If
    
        f = FreeFile
        Open FileName For Append As #f
            Print #f, Time & ": " & Text
        Close #f
    End If
End Sub

Public Sub SaveMap(ByVal MapNum As Long)
Dim FileName As String
Dim f As Long

    FileName = App.Path & MAP_PATH & "map" & MapNum & MAP_EXT
            
    f = FreeFile
    Open FileName For Binary As #f
        Put #f, , Map
    Close #f
End Sub

Public Sub LoadMap(ByVal MapNum As Long)
Dim FileName As String
Dim f As Long

    FileName = App.Path & MAP_PATH & "map" & MapNum & MAP_EXT
        
    f = FreeFile
    Open FileName For Binary As #f
        Get #f, , Map
    Close #f
End Sub

Public Sub CheckTiles()
Dim i As Long

    i = 1

    While FileExist(GFX_PATH & "tiles" & i & GFX_EXT)
        NumTileSets = NumTileSets + 1
        i = i + 1
    Wend

    frmMirage.scrlTileSet.Max = NumTileSets

End Sub

Public Sub CheckSprites()
Dim i As Long

    i = 1

    While FileExist(GFX_PATH & "sprites\" & i & GFX_EXT)
        NumSprites = NumSprites + 1
        i = i + 1
    Wend

    ReDim DDS_Sprite(1 To NumSprites)
    ReDim DDSD_Sprite(1 To NumSprites)
    
    ReDim SpriteTimer(1 To NumSprites)

End Sub

Public Sub CheckSpells()
Dim i As Long

    i = 1

    While FileExist(GFX_PATH & "Spells\" & i & GFX_EXT)
        NumSpells = NumSpells + 1
        i = i + 1
    Wend

    ReDim DDS_Spell(1 To NumSpells)
    ReDim DDSD_Spell(1 To NumSpells)
    
    ReDim SpellTimer(1 To NumSpells)

End Sub

Public Sub CheckItems()
Dim i As Long

    i = 1

    While FileExist(GFX_PATH & "Items\" & i & GFX_EXT)
        NumItems = NumItems + 1
        i = i + 1
    Wend

    ReDim DDS_Item(1 To NumItems)
    ReDim DDSD_Item(1 To NumItems)
    
    ReDim ItemTimer(1 To NumItems)

End Sub

Public Sub ClearPlayer(ByVal Index As Long)
    Call ZeroMemory(ByVal VarPtr(Player(Index)), LenB(Player(Index)))
    Player(Index).Name = vbNullString
End Sub

Public Sub ClearItem(ByVal Index As Long)
    Call ZeroMemory(ByVal VarPtr(Item(Index)), LenB(Item(Index)))
    Item(Index).Name = vbNullString
End Sub

Public Sub ClearItems()
Dim i As Long

    For i = 1 To MAX_ITEMS
        Call ClearItem(i)
    Next
End Sub

Public Sub ClearMapItem(ByVal Index As Long)
    Call ZeroMemory(ByVal VarPtr(MapItem(Index)), LenB(MapItem(Index)))
End Sub

Public Sub ClearMap()
    Call ZeroMemory(ByVal VarPtr(Map), LenB(Map))
    Map.Name = vbNullString
    Map.TileSet = 1
End Sub

Public Sub ClearMapItems()
Dim i As Long

    For i = 1 To MAX_MAP_ITEMS
        Call ClearMapItem(i)
    Next
End Sub

Public Sub ClearMapNpc(ByVal Index As Long)
    Call ZeroMemory(ByVal VarPtr(MapNpc(Index)), LenB(MapNpc(Index)))
End Sub

Public Sub ClearMapNpcs()
Dim i As Long

    For i = 1 To MAX_MAP_NPCS
        Call ClearMapNpc(i)
    Next
End Sub

' *****************************
' ** Player Public Functions **
' *****************************

Public Function GetPlayerName(ByVal Index As Long) As String
    GetPlayerName = Trim$(Player(Index).Name)
End Function
Public Sub SetPlayerName(ByVal Index As Long, ByVal Name As String)
    Player(Index).Name = Name
End Sub

Public Function GetPlayerClass(ByVal Index As Long) As Long
    GetPlayerClass = Player(Index).Class
End Function
Public Sub SetPlayerClass(ByVal Index As Long, ByVal ClassNum As Long)
    Player(Index).Class = ClassNum
End Sub

Public Function GetPlayerSprite(ByVal Index As Long) As Long
    GetPlayerSprite = Player(Index).Sprite
End Function
Public Sub SetPlayerSprite(ByVal Index As Long, ByVal Sprite As Long)
    Player(Index).Sprite = Sprite
End Sub

Public Function GetPlayerLevel(ByVal Index As Long) As Long
    GetPlayerLevel = Player(Index).Level
End Function
Public Sub SetPlayerLevel(ByVal Index As Long, ByVal Level As Long)
    Player(Index).Level = Level
End Sub

Public Function GetPlayerExp(ByVal Index As Long) As Long
    GetPlayerExp = Player(Index).Exp
End Function
Public Sub SetPlayerExp(ByVal Index As Long, ByVal Exp As Long)
    Player(Index).Exp = Exp
End Sub

Public Function GetPlayerAccess(ByVal Index As Long) As Long
    GetPlayerAccess = Player(Index).Access
End Function
Public Sub SetPlayerAccess(ByVal Index As Long, ByVal Access As Long)
    Player(Index).Access = Access
End Sub

Public Function GetPlayerPK(ByVal Index As Long) As Long
    GetPlayerPK = Player(Index).PK
End Function
Public Sub SetPlayerPK(ByVal Index As Long, ByVal PK As Long)
    Player(Index).PK = PK
End Sub

Public Function GetPlayerVital(ByVal Index As Long, ByVal Vital As Vitals) As Long
    GetPlayerVital = Player(Index).Vital(Vital)
End Function

Public Sub SetPlayerVital(ByVal Index As Long, ByVal Vital As Vitals, ByVal Value As Long)
    Player(Index).Vital(Vital) = Value
    
    If GetPlayerVital(Index, Vital) > GetPlayerMaxVital(Index, Vital) Then
        Player(Index).Vital(Vital) = GetPlayerMaxVital(Index, Vital)
    End If
End Sub

Public Function GetPlayerMaxVital(ByVal Index As Long, ByVal Vital As Vitals) As Long
    Select Case Vital
        Case HP
            GetPlayerMaxVital = Player(Index).MaxHP
        Case MP
            GetPlayerMaxVital = Player(Index).MaxMP
        Case SP
            GetPlayerMaxVital = Player(Index).MaxSP
    End Select
End Function

Public Function GetPlayerStat(ByVal Index As Long, Stat As Stats) As Long
    GetPlayerStat = Player(Index).Stat(Stat)
End Function
Public Sub SetPlayerStat(ByVal Index As Long, Stat As Stats, ByVal Value As Long)
    Player(Index).Stat(Stat) = Value
End Sub

Public Function GetPlayerPOINTS(ByVal Index As Long) As Long
    GetPlayerPOINTS = Player(Index).POINTS
End Function
Public Sub SetPlayerPOINTS(ByVal Index As Long, ByVal POINTS As Long)
    Player(Index).POINTS = POINTS
End Sub

Public Function GetPlayerMap(ByVal Index As Long) As Long
    GetPlayerMap = Player(Index).Map
End Function
Public Sub SetPlayerMap(ByVal Index As Long, ByVal MapNum As Long)
    Player(Index).Map = MapNum
End Sub

Public Function GetPlayerX(ByVal Index As Long) As Long
    GetPlayerX = Player(Index).X
End Function
Public Sub SetPlayerX(ByVal Index As Long, ByVal X As Long)
    Player(Index).X = X
End Sub

Public Function GetPlayerY(ByVal Index As Long) As Long
    GetPlayerY = Player(Index).Y
End Function
Public Sub SetPlayerY(ByVal Index As Long, ByVal Y As Long)
    Player(Index).Y = Y
End Sub

Public Function GetPlayerDir(ByVal Index As Long) As Long
    GetPlayerDir = Player(Index).Dir
End Function
Public Sub SetPlayerDir(ByVal Index As Long, ByVal Dir As Long)
    Player(Index).Dir = Dir
End Sub

Public Function GetPlayerInvItemNum(ByVal Index As Long, ByVal InvSlot As Long) As Long
    GetPlayerInvItemNum = PlayerInv(InvSlot).Num
End Function
Public Sub SetPlayerInvItemNum(ByVal Index As Long, ByVal InvSlot As Long, ByVal ItemNum As Long)
    PlayerInv(InvSlot).Num = ItemNum
End Sub

Public Function GetPlayerInvItemValue(ByVal Index As Long, ByVal InvSlot As Long) As Long
    GetPlayerInvItemValue = PlayerInv(InvSlot).Value
End Function
Public Sub SetPlayerInvItemValue(ByVal Index As Long, ByVal InvSlot As Long, ByVal ItemValue As Long)
    PlayerInv(InvSlot).Value = ItemValue
End Sub

Public Function GetPlayerInvItemDur(ByVal Index As Long, ByVal InvSlot As Long) As Long
    GetPlayerInvItemDur = PlayerInv(InvSlot).Dur
End Function
Public Sub SetPlayerInvItemDur(ByVal Index As Long, ByVal InvSlot As Long, ByVal ItemDur As Long)
    PlayerInv(InvSlot).Dur = ItemDur
End Sub

Public Function GetPlayerEquipmentSlot(ByVal Index As Long, ByVal EquipmentSlot As Equipment) As Byte
    GetPlayerEquipmentSlot = Player(Index).Equipment(EquipmentSlot)
End Function
Public Sub SetPlayerEquipmentSlot(ByVal Index As Long, ByVal InvNum As Long, ByVal EquipmentSlot As Equipment)
    Player(Index).Equipment(EquipmentSlot) = InvNum
End Sub


