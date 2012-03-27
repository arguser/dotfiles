-- WORK IN PROGRESS

-- arguser << xmonad.hs
--
-- Besed on default template

-- Read THIS! (note to myself)
-- http://www.haskell.org/haskellwiki/Xmonad/Notable_changes_since_0.8
--

-----------
--Imports--
-----------

--Xmonad
import XMonad
import XMonad.Hooks.SetWMName
-----------
--Layouts--
-----------
--No Borders
import XMonad.Layout.NoBorders
--Grid
import XMonad.Layout.Grid
--Rezise
import XMonad.Layout.ResizableTile
--Tabs
import XMonad.Layout.Tabbed
--Names
import XMonad.Layout.Named
--Sub layouts
import XMonad.Layout.SubLayouts
import XMonad.Layout.Simplest
--Window Navigator
import XMonad.Layout.WindowNavigation
---------
--Hooks--
---------
--Urgents
import XMonad.Hooks.UrgencyHook
--Grid Selection
import XMonad.Actions.GridSelect
--Windows Focus
import XMonad.Hooks.InsertPosition
--Helpers
import XMonad.Hooks.ManageHelpers
--Apps Workspaces
import XMonad.Hooks.ManageDocks(avoidStruts, manageDocks)
--Figure out what this about
import XMonad.Util.Run(spawnPipe)
--Xmobar
import XMonad.Hooks.DynamicLog

---------
--Utils--
---------
--Extra Keys
import XMonad.Util.EZConfig(additionalKeys)

import System.IO
import Data.Monoid
--Exit
import System.Exit
--Keys
import qualified XMonad.StackSet as W
import qualified Data.Map        as M


myTerminal      = "urxvt"

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

-------------------
--Super as Modkey--
-------------------

myModMask       = mod4Mask

--------------
--Workspaces--
--------------

myWorkspaces    = ["  1  ","  2  ","  3  ","  4  "]

---------------
--Main Colors--
---------------
myFgColor = "#6D9EAB"
myBgColor = "#202020"
myHighlightedFgColor = "#FFFFFF"
myHighlightedBgColor = myFgColor

---------------------
--Workspaces Colors--
---------------------
myCurrentWsFgColor = myHighlightedFgColor
myCurrentWsBgColor = "#DE4314"
myVisibleWsFgColor = "#DE4314"
myVisibleWsBgColor = "#303030"
myHiddenWsFgColor = "#909090"
myHiddenWsBgColor = "#A62806"
myHiddenEmptyWsFgColor = myHiddenWsFgColor
myHiddenEmptyWsBgColor = myBgColor
myUrgentWsFgColor = myBgColor
myUrgentWsBgColor = "#F0F0F0"
myTitleFgColor = myFgColor
-----------------
--Border Colors--
-----------------
myActiveBorderColor = myFgColor
myInactiveBorderColor = myBgColor
myBorderWidth = 2

-------------
--Key Binds--
-------------
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)
    -- lock screen
    , ((0, 0x1008ff2d                    ), spawn "slimlock")
    -- activate/deactivate bluetooth/wireless
    --, ((0, 0x1008ff95			 ), spawn "sudo set_rf")
    -- Fn+F5 suspends with pm-suspend
    , ((0,0x1008ff2f			 ), spawn "slimlock | sudo pm-suspend")
    -- Power for poweroff
    , ((0,0x1008ff2a			 ), spawn "sudo poweroff")
    -- Autorandr for Displays
    , ((0,0x1008ff59                     ), spawn "autorandr -c && sh .fehbg")

    -- screenshot screen
    , ((modm,               xK_Print     ), spawn "scrot -e 'mv $f ~/picts/shots'")

    -- screenshot window or area
    , ((modm .|. shiftMask, xK_Print     ), spawn "scrot -s -e'mv $f ~/picts/shots'")

    -- launch dmenu-xft
    , ((modm,               xK_p     ), spawn "dmenu_run -nb '#202020' -nf grey70 -sb '#DE4314' -sf white -p wha? -fn 'Envy Code R:pixelsize=15'")

    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)

    -------------------
    --Volume Keybinds--

    , ((0,0x1008ff13                 ), spawn "amixer sset 'Master' 5%+,5%+")
    , ((0,0x1008ff11                 ), spawn "amixer sset 'Master' 5%-,5%-")

    -----------------------
    --Layout Control Keys--
    -----------------------
    -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)
    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)
    ----------------------


    --------------
    --Sub Layout--
    --------------
    --
    --Group to Left
    , ((modm .|. controlMask, xK_Left), sendMessage $ pullGroup L)
    --Group to Right
    , ((modm .|. controlMask, xK_Right), sendMessage $ pullGroup R)
    --Group Above
    , ((modm .|. controlMask, xK_Up), sendMessage $ pullGroup U)
    --Group Below
    , ((modm .|. controlMask, xK_Down), sendMessage $ pullGroup D)
    --Merge/UnMerge
    , ((modm .|. controlMask, xK_m), withFocused (sendMessage . MergeAll))
    , ((modm .|. controlMask, xK_u), withFocused (sendMessage . UnMerge))
    --Focus between tabs
    , ((modm .|. controlMask, xK_period), onGroup W.focusUp')
    , ((modm .|. controlMask, xK_comma), onGroup W.focusDown')
    --

    --------------
    --Focus Keys--
    --------------
    --
    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)
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
    -- Shrink/Expand the master area
    , ((modm,               xK_h     ), sendMessage Shrink)
    , ((modm,               xK_l     ), sendMessage Expand)
    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)
    -- Increment/Decrement the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -------------
    --Show Grid--
    -------------
    , ((modm,               xK_g    ), goToSelected myGSConfig)

    --NEED REVIEW!

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

    --END NEED REVIEW!


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


------------------
--Mouse Bindings--
------------------

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

----------------------
--Layout definitions--
----------------------

myLayout = smartBorders $ windowNavigation $ addTabs shrinkText tabTheme $
            tall ||| mtall ||| full ||| Grid
                where
                    rt = ResizableTall 1 (3/100) (1/2) []
                    tall = named "Tall" $ subLayout [0,1,2] (Simplest) $ rt
                    mtall = named "Mirror" $ subLayout [0,1,2] (Simplest) $ Mirror rt
                    full = named "Full" $ subLayout [0] (Simplest) $ Full

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

-----------------
--Windows Rules--
-----------------

myManageHook = composeAll [ -- isFullscreen                  --> doFullFloat
                          className =? "MPlayer"        --> doFloat
                          , className =? "Gimp"           --> doFloat
                          , className =? "feh"            --> doFloat
                          , className =? "Nautilus"       --> doFloat
                          , className =? "Lazarus"        --> doFloat
                          , resource =? "freeorion"      --> doFloat
                          , resource =? "PlayOnLinux"    --> doFloat
                          , resource  =? "VCLSalFrame"    --> doFloat
                          , resource  =? "desktop"        --> doIgnore
                          , resource  =? "desktop_window" --> doIgnore
                          , resource  =? "kdesktop"       --> doIgnore
                          , insertPosition    Above Newer
                          , transience'
                          ]

--------------
--Tab Colors--
--------------

tabTheme = defaultTheme { decoHeight = 14
                        , activeColor = "#303030"
                        , activeBorderColor = "#404040"
                        , activeTextColor = "#6D9EAB"
                        , inactiveTextColor = "#8f8f8f"
                        , inactiveColor = "#252525"
                        , inactiveBorderColor = "#404040"
                        }

---------------
--Grid Config--
---------------
myGSConfig = defaultGSConfig { gs_cellwidth = 160 }

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

------------------
--Event Handling--
------------------

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

---------------------------
--Status Bars and Logging--
---------------------------

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

-------------------
--Startup Actions--
-------------------

myStartupHook = setWMName "LG3D"

----------------------
--XMobar Integration--
----------------------

main = do
  xmproc <- spawnPipe "xmobar"
  spawnPipe "xmobar '.xmobar2rc'"
  xmonad $ withUrgencyHook NoUrgencyHook $ defaults {
         manageHook = manageDocks <+> manageHook defaults
         , layoutHook = avoidStruts $ layoutHook defaults
         , logHook = dynamicLogWithPP $ xmobarPP{
						  ppOutput = hPutStrLn xmproc
						  , ppTitle = xmobarColor myTitleFgColor "" . shorten 40
						  , ppCurrent = xmobarColor myCurrentWsFgColor myCurrentWsBgColor
						  , ppVisible = xmobarColor myVisibleWsFgColor myVisibleWsBgColor
						  , ppHidden = xmobarColor myHiddenWsFgColor myHiddenWsBgColor
						  , ppHiddenNoWindows = xmobarColor myHiddenEmptyWsFgColor myHiddenEmptyWsBgColor
						  , ppUrgent = xmobarColor myUrgentWsFgColor myUrgentWsBgColor . xmobarStrip
                                                  , ppSep    = xmobarColor myHiddenWsFgColor "" " >> "
						  }
         }
--------------------------
--Configuration Settings--
--------------------------
defaults = defaultConfig {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myInactiveBorderColor,
        focusedBorderColor = myActiveBorderColor,

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
