// From modText

Index = argument0;
    
if getPlayerPK(Index) = false {
    switch getPlayerAccess(Index) {
    
        case 0:
            Color = c_green;
        break;
        
        case 1:
            Color = c_dkgray;
        break;
        
        case 2:
            Color = c_white;
            break;
        Case 3:
            Color = c_orange;
        break;
        
        case 4:
            Color = c_blue;
        break;
        
        }
    } else {
        Color = c_red;
    }

// Determine location for text
TextX = getPlayerX(Index) * PIC_X + Player(Index).XOffset + (PIC_X / 2) - ((string_length(getPlayerName(Index)) / 2) * 8)
TextY = getPlayerY(Index) * PIC_Y + Player(Index).YOffset - (PIC_Y / 2) - 4

// Draw name
drawText(0, TextX, TextY, GetPlayerName(Index), Color);
