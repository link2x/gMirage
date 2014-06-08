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

// Now we set all of the information.
nWindow.x            =  argument0; // Window X Position
nWindow.y            =  argument1; // Window Y Position
nWindow.Width        =  argument2; // Window Width
nWindow.Height       =  argument3; // Window Height (Viewport)
nWindow.Border       =  argument4; // Window Border
nWindow.Padding      =  argument5; // Window Padding (Between Borders)
nWindow.iPadding     =  argument6; // Window Padding (Between Inner Boarder and Content) *UNUSED*
nWindow.bWidth       =  argument7; // Button Width
nWindow.tHeight      =  argument8; // Title Height
nWindow.iHeight      =  argument9; // Window Height (Inner/Unseen - Scroll Bar)
nWindow.UIController = argument10; // Controller Object ID

// Create a surface to work with. This will be defined by the Width (minus chrome) and iHeight.
nWindow.Surface = surface_create( nWindow.Width-(2*((2*nWindow.Boarder)+nWindow.Padding)), nWindow.iHeight);

// Now we register the window with the UIController:
argument10.windowCount += 1;              // Increases the windowCount, used for Z-handling
argument10.window[argument10.windowCount] = nWindow; // Sets the object-id for the new window-id.

// This is a little counter-intuitive, but to make the next function work we need to set the
// Z level of the window, and can't set it until after we have our window-id... Sorry!
nWindow.z = argument10.windowCount;

// Bring the new window to the front.
with argument10 {ui_bring_to_front(windowCount);};

return windowCount; // Returns the window id of the new window.
