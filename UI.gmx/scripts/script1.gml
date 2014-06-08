// ui_bring_to_front(window-id);

aWindow = argument0;
oldZ    = aWindow.z;

aWindow.z = 0; // Bring it to the front.

// Push all windows back that need pushing.
for (i=oldZ;i>0;i-=1) {
    for(zWindow=windowCount;zWindow>0;zWindow-=1) {
        if window[zWindow].z < oldZ {window[zWindow].z+=1;};
    };
};
