// ui_bring_to_front(UIController ,window-id);

aController = argument0;
aWindow = aController.window[argument1];
oldZ    = aWindow.z;

aWindow.z = 1; // Bring it to the front.

// Push all windows back that need pushing.
for(zWindow=aController.windowCount;zWindow>=1;zWindow-=1) {
    if ((aController.window[zWindow].z < oldZ) and (aController.window[zWindow] != aWindow)) {aController.window[zWindow].z+=1;};
};
