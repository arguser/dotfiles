--
-- xmonad example config file for xmonad-0.9
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--
-- NOTE: Those updating from earlier xmonad versions, who use
-- EwmhDesktops, safeSpawn, WindowGo, or the simple-status-bar
-- setup functions (dzen, xmobar) probably need to change
-- xmonad.hs, please see the notes below, or the following
-- link for more details:
--
-- http://www.haskell.org/haskellwiki/Xmonad/Notable_changes_since_0.8
--
 
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks(avoidStruts, manageDocks)
import XMonad.Layout.ResizableTile
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
import Data.Monoid
import System.Exit
 
import qualified XMonad.StackSet as W
import qualified Data.Map        as M

 
myTerminal      = "urxvt"
 
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False 
  
myModMask       = mod4Mask

myWorkspaces    = ["  1  ","  2  ","  3  ","  4  "]

--- Main Colours
myFgColor = "#DCDCCC"
myBgColor = "#3f3f3f"
myHighlightedFgColor = myFgColor
myHighlightedBgColor = "#7F9F7F"

--- Ws Stuff
myCurrentWsFgColor = myHighlightedFgColor
myCurrentWsBgColor = myHighlightedBgColor
myVisibleWsFgColor = myBgColor
myVisibleWsBgColor = "#CCDC90"
myHiddenWsFgColor = myHighlightedFgColor
myHiddenEmptyWsFgColor = "#8F8F8F"
myUrgentWsBgColor = "#DCA3A3"
myTitleFgColor = myFgColor
--

 
-- Border colors for unfocused and focused windows, respectively.
--
myActiveBorderColor = "#1992cf" 
myInactiveBorderColor = "#262626"
myBorderWidth = 1

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
 
    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)
    -- lock screen
    , ((0, 0x1008ff2d                    ), spawn "xlock")
    -- activate/deactivate bluetooth/wireless
    , ((0, 0x1008ff95			 ), spawn "sudo set_rf")
    -- Fn+F5 suspends with pm-suspend
    , ((0,0x1008ff2f			 ), spawn "sudo pm-suspend")
    -- Power for poweroff 
    , ((0,0x1008ff2a			 ), spawn "sudo poweroff")

    -- screenshot screen
    , ((modm,               xK_Print     ), spawn "scrot -e 'mv $f ~/picts/shots'")

    -- screenshot window or area
    , ((modm .|. shiftMask, xK_Print     ), spawn "scrot -s -e'mv $f ~/picts/shots'")

    -- launch dmenu-xft
    , ((modm,               xK_p     ), spawn "dmenu_run -nb black -nf grey70 -sb '#1992cf' -sf white -p wha? -fn 'Envy Code R:pixelsize=15'")
 
    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)
 
     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)
 
    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
 
    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)
 
    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)
 
    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)
 
    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )
 
    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )
 
    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)
 
    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )
 
    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )
 
    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)
 
    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)
 
    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)
 
    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))
 
    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))
 
    -- Audio control. See <X11/XF86keysym.h>
    -- XF86XK_AudioPlay
    , ((0, 0x1008FF14),                spawn "ncmpcpp toggle")
    , ((0, 0x1008FF15),                spawn "ncmpcpp stop")
    -- XF86XK_AudioPrev, XF86XK_Prev
    , ((0, 0x1008FF16),                spawn "ncmpcpp prev")
    , ((0, 0x1008FF26),                spawn "ncmpcpp prev")
    -- XF86XK_AudioNext, XF86XK_Next
    , ((0, 0x1008FF17),                spawn "ncmpcpp next")
    , ((0, 0x1008FF27),                spawn "ncmpcpp next")

    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)
 
    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))
 
    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")
    ]
    ++
 
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
 
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
 
 
------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $
 
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))
 
    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))
 
    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))
 
    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]
 
------------------------------------------------------------------------
-- Layouts:
 
-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- * NOTE: XMonad.Hooks.EwmhDesktops users must remove the obsolete
-- ewmhDesktopsLayout modifier from layoutHook. It no longer exists.
-- Instead use the 'ewmh' function from that module to modify your
-- defaultConfig as a whole. (See also logHook, handleEventHook, and
-- startupHook ewmh notes.)
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayout = tiled ||| Mirror tiled ||| Full
  where
    -- default tiling algorithm partitions the screen into two panes
    tiled   = Tall nmaster delta ratio
 
    -- The default number of windows in the master pane
    nmaster = 1
 
    -- Default proportion of screen occupied by master pane
    ratio   = 1/2
 
    -- Percent of screen to increment by when resizing panes
    delta   = 3/100
 
------------------------------------------------------------------------
-- Window rules:
 
-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]
 
------------------------------------------------------------------------
-- Event handling
 
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
-- * NOTE: EwmhDesktops users should use the 'ewmh' function from
-- XMonad.Hooks.EwmhDesktops to modify their defaultConfig as a whole.
-- It will add EWMH event handling to your custom event hooks by
-- combining them with ewmhDesktopsEventHook.
--
myEventHook = mempty
 
------------------------------------------------------------------------
-- Status bars and logging
 
-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
--
-- * NOTE: EwmhDesktops users should use the 'ewmh' function from
-- XMonad.Hooks.EwmhDesktops to modify their defaultConfig as a whole.
-- It will add EWMH logHook actions to your custom log hook by
-- combining it with ewmhDesktopsLogHook.
--
myLogHook = return ()
 
------------------------------------------------------------------------
-- Startup hook
 
-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
--
-- * NOTE: EwmhDesktops users should use the 'ewmh' function from
-- XMonad.Hooks.EwmhDesktops to modify their defaultConfig as a whole.
-- It will add initialization of EWMH support to your custom startup
-- hook by combining it with ewmhDesktopsStartup.
--
myStartupHook = return ()
 
------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.
 
-- Run xmonad with the settings you specify. No need to modify this.
--

main = do
  xmproc <- spawnPipe "xmobar"
  xmonad $ defaults {
         manageHook = manageDocks <+> manageHook defaults
         , layoutHook = avoidStruts $ layoutHook defaults 
         , logHook = dynamicLogWithPP $ xmobarPP{
						  ppOutput = hPutStrLn xmproc
						  , ppTitle = xmobarColor "#1992cf" "" . shorten 50
						  , ppCurrent = xmobarColor "#FFFFFF" "#1992cf"
						  , ppVisible = xmobarColor "#FFFFFF" "#19A2af" 
						  , ppHidden = xmobarColor "#8f8f8f" "#0066a1"
						  , ppHiddenNoWindows = xmobarColor "#8F8F8F" ""
						  , ppUrgent = xmobarColor "#FFFFFF" "#DCA3A3"
						  } 
         }



-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = defaultConfig {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = "black",
        focusedBorderColor = "#1992cf",
 
      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,
 
      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook
        }
