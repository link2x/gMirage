// From modClientTCP

// I'm not entirely sure what the point of this one is.
if getPlayerName(argument0) > 0 {
    playing = true;
    return 1;
} else {
    playing = false;
    return 0;
}
