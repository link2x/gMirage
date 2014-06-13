// ui_create_window
//
// Purpose:
// Creates a new window, initializing the surface and all settings for drawing it.
// Additionally, registers the window with a given UIController, for Z-handling and easy control.
//
// Usage:
// window = ui_create_window( X, Y, Width, Height, [iHeight], [UIController]);
//
// Notes:
// If you want to specify UIController, but don't want to specify iHeight, just
// use a 0 or negative number.
//     EX: ui_create_window(32,32,240,480,0,objUI);
// The system will handle the rest.

// Create the new window object. Position is unimportant.
nWindow         = instance_create(0,0,obj_UIWindow);

// Make it invisible until needed.
nWindow.visible = false;

// Now we set all of the draw/control information.
nWindow.x            = argument[0]; // Window X Position
nWindow.y            = argument[1]; // Window Y Position
nWindow.Width        = argument[2]; // Window Width
nWindow.Height       = argument[3]; // Window Height (Viewport)
if (argument_count >= 5) {nWindow.iHeight = argument[4];} else {nWindow.iHeight = nWindow.Height;};
if (argument_count >= 6) {nWindow.UIController = argument[5];} else {nWindow.UIController = id;};

// Some theming variables - Because of how these are referenced, it's easier to pass them along here instead of having the window reference them itsself.
nWindow.Padding = nWindow.UIController.Padding;
nWindow.tHeight = nWindow.UIController.tHeight;
nWindow.Border  = nWindow.UIController.Border;

// Some control variables.
nWindow.Dragging     =          0; // Used for mouse handling during dragging.
nWindow.mouseXOffset =          0; // Used for mouse handling during dragging.
nWindow.mouseYOffset =          0; // Used for mouse handling during dragging.

// And set some extra information.
nWindow.Title         = ""; // Optionally titles the window.
nWindow.windowBlinds  =  1; // Enables/Disables the Windowblinds button.
nWindow.closeButton   =  1; // Enables/Disables the Close button.
nWindow.scrollBar     =  1; // Enables/Disables the Scroll Bar. (This is automatically disabled by having your iHeight equal to your Height. This leaves unused pixels, but you can force this on by setting the variable again later.
nWindow.mouseInBounds =  0; // Used for mouse detection with Z levels.
nWindow.blindsMode    =  0; // Used for switching between blinds and normal mode.
nWindow.overClose     =  0; // Used for the close button.
nWindow.overBlinds    =  0; // Used for the blinds button.

// System checks.
if nWindow.iHeight < nWindow.Height {nWindow.iHeight = nWindow.Height}; // There's no reason to have an inner window be smaller than the space it has. This automatically corrects that.
if nWindow.iHeight = nWindow.Height {nWindow.ScrollBar = 0;}; // This disables the Scroll Bar for windows that don't need it.

// Create a surface to work with. This will be defined by the Width (minus chrome) and iHeight.
nWindow.Surface = surface_create( nWindow.Width-(2*((2*nWindow.Border)+nWindow.Padding)), nWindow.iHeight);

// Draw the inner window.
surface_set_target(nWindow.Surface);
draw_set_color(nWindow.UIController.windowColorInner);
draw_rectangle(-1,-1, nWindow.Width-(2*((2*nWindow.Border)+nWindow.Padding)),nWindow.iHeight,0);
surface_reset_target();

// Now we register the window with the UIController:
nWindow.UIController.windowCount += 1;                                   // Increases the windowCount, used for Z-handling
nWindow.UIController.window[nWindow.UIController.windowCount] = nWindow; // Sets the object-id for the new window-id.

// This is a little counter-intuitive, but to make the next function work we need to set the
// Z level of the window, and can't set it until after we have our window-id... Sorry!
nWindow.windowID = nWindow.UIController.windowCount;
nWindow.z        = nWindow.UIController.windowCount;

// Bring the new window to the front.
ui_bring_to_front(nWindow.UIController,nWindow.windowID);

return windowCount; // Returns the window id of the new window.
