// From modFont

    
        for (x=0;x<MAX_MAPX;x+=1) {
            for (y=0;y<MAX_MAPY;y+=1) {
                with Map.Tile[X, Y] {
                    switch Type {
                    
                        case TILE_TYPE_BLOCKED:
                            drawText(0, ((X * PIC_X) - 4) + (PIC_X * 0.5), ((Y * PIC_Y) - 7) + (PIC_Y * 0.5), "B", c_red);
                        break;
                        
                        case TILE_TYPE_WARP:
                            drawText(0, ((X * PIC_X) - 4) + (PIC_X * 0.5), ((Y * PIC_Y) - 7) + (PIC_Y * 0.5), "W", c_blue);
                        break;
                    
                        case TILE_TYPE_ITEM:
                            drawText(0, ((X * PIC_X) - 4) + (PIC_X * 0.5), ((Y * PIC_Y) - 7) + (PIC_Y * 0.5), "I",c_white);
                        break;
                    
                        case TILE_TYPE_NPCAVOID:
                            drawText(0, ((X * PIC_X) - 4) + (PIC_X * 0.5), ((Y * PIC_Y) - 7) + (PIC_Y * 0.5), "N",c_white);
                        break;
                    
                        case TILE_TYPE_KEY:
                            drawText(0, ((X * PIC_X) - 4) + (PIC_X * 0.5), ((Y * PIC_Y) - 7) + (PIC_Y * 0.5), "K",c_white);
                        break;
                    
                        case TILE_TYPE_KEYOPEN:
                            drawText(0, ((X * PIC_X) - 4) + (PIC_X * 0.5), ((Y * PIC_Y) - 7) + (PIC_Y * 0.5), "O",c_white);
                        break;
                    
            }
        }
    }
}
