// ui_create_window
//
// Purpose:
// Creates a new window, initializing the surface and all settings for drawing it.
// Additionally, registers the window with a given UIController, for Z-handling and easy control.
//
// Usage:
// window = ui_create_window( X, Y, Width, Height, Boarder, Padding, iPadding, bWidth, tHeight, iHeight, UIController);
//

// Create the new window object. Position is unimportant.
nWindow         = instance_create(0,0,obj_UIWindow);

// Make it invisible until needed.
nWindow.visible = false;

// Now we set all of the draw/control information.
nWindow.x            =  argument0; // Window X Position
nWindow.y            =  argument1; // Window Y Position
nWindow.Width        =  argument2; // Window Width
nWindow.Height       =  argument3; // Window Height (Viewport)
nWindow.Border       =  argument4; // Window Border *BROKEN - SET TO 1*
nWindow.Padding      =  argument5; // Window Padding (Between Borders)
nWindow.iPadding     =  argument6; // Window Padding (Between Inner Boarder and Content) *UNUSED - SET TO 2*
nWindow.bWidth       =  argument7; // Button Width
nWindow.tHeight      =  argument8; // Title Height
nWindow.iHeight      =  argument9; // Window Height (Inner/Unseen - Scroll Bar)
nWindow.UIController = argument10; // Controller Object ID

// Some control variables.
nWindow.Dragging     =          0; // Used for mouse handling during dragging.
nWindow.mouseXOffset =          0; // Used for mouse handling during dragging.
nWindow.mouseYOffset =          0; // Used for mouse handling during dragging.

// And set some extra information.
nWindow.Title         = ""; // Optionally titles the window.
nWindow.WindowBlinds  =  1; // Enables/Disables the Windowblinds button.
nWindow.CloseButton   =  1; // Enables/Disables the Close button.
nWindow.ScrollBar     =  1; // Enables/Disables the Scroll Bar. (This is automatically disabled by having your iHeight equal to your Height. This leaves unused pixels, but you can force this on by setting the variable again later.
nWindow.mouseInBounds =  0; // Used for mouse detection with Z levels.

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
