import Control.Monad
import Data.Ratio
import Graphics.X11.ExtraTypes.XF86
import System.Exit
import System.Environment
import System.Posix.IO
import XMonad 
import XMonad.Actions.FloatKeys
import XMonad.Actions.CycleWS
import XMonad.Actions.Navigation2D
import XMonad.Float.SimplestFloatDec
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.InsertPosition hiding (Position)
import XMonad.Hooks.ManageDocks 
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Layout.Fullscreen
import XMonad.Layout.Gaps
import XMonad.Layout.NoBorders
import XMonad.Layout.Tabbed
import XMonad.Actions.PhysicalScreens
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.XUtils
import qualified XMonad.StackSet as W
import qualified XMonad.Core as C
import qualified Data.Map        as M

-- lib modules
import EqualSpacing
import BorderResize
import NaOHmanBSP

myTerminal = "/usr/bin/urxvt"
myWorkspaces = map show [0..9]

------------------------------------------------------------------------
-- Window rules
--
myManageHook = composeOne
    [ resource  =? "desktop_window" -?> doIgnore
    , isFullscreen                  -?> putAbove <+> doFullFloat 
    , isFloating                    -?> putAbove
    , className =? "Spotify"        -?> doShift "0" -- >> doFullFloat
    , className =? "Nautilus"       -?> doFloat <+> putAbove 
    , return True                   -?> insertPosition Below Newer
    ] <+> manageDocks <+> fullscreenManageHook
    where isFloating = ask >>= \w -> liftX . gets $ M.member w . W.floating . windowset
          putAbove   = insertPosition Master Newer


------------------------------------------------------------------------
-- Layouts
myLayout = bsp ||| tabs ||| fullscreen
    where bsp        = equalSpacing 0 4 0 $ myBorder $ configBSP 0.025 0.6
          tabs       = noBorders $ gaps [(U,24)] myTabs
          myTabs     = tabbedBottom shrinkText $ myTheme 
                                { activeColor       = "#848758" -- color6
                                , activeBorderColor = "#848758" -- color6
                                , activeTextColor   = "#181512" --color15
                                }
          myBorder l = smartBorders $ gaps [(U,24)] l
          fullscreen = noBorders $ fullscreenFull Full

myActive   = "#f2d1ba" -- color8
myInactive = "#bea492" -- color10

-- Width of the window border in pixels.
myBorderWidth = 5

------------------------------------------------------------------------
-- Key bindings
--
myModMask = mod4Mask

myStartupHook = return ()

myLogHook fd = dynamicLogWithPP def 
    { ppCurrent         = const "a"
    , ppVisible         = const "o"
    , ppHidden          = const "o"
    , ppHiddenNoWindows = const "i"
    , ppUrgent          = const "u"
    , ppOrder           = \(ws:_) -> [ws]
    , ppOutput          = \s -> void $ fdWrite fd ("W" ++ s ++ "\n")
    } 

myFloatDec = simplestDec myIgnores myTheme
    where myIgnores = [ isFullscreen
                      , className =? "Synapse"
                      , className =? "Nautilus"
                      ] 

myTheme = def 
    { activeColor         = "#181512" --color15
    , inactiveColor       = "#181512" --color15
    , urgentColor         = "#181512" --color15
    , activeBorderColor   = "#181512" --color15
    , inactiveBorderColor = "#181512" --color15
    , urgentBorderColor   = "#181512" --color15
    , activeTextColor     = "#bea492" --color10
    , inactiveTextColor   = "#bea492" --color10
    , urgentTextColor     = "#bea492" --color10
    , fontName            = "-*-ubuntu-*-r-*-*-14-*-*-*-*-*-*-*"
    , decoHeight          = 36
    }

myNavConf = def { layoutNavigation = [("BSP", centerNavigation)] }

main = do
    fifo <- getEnv "PANEL_FIFO"
    pipe <- openFd fifo WriteOnly Nothing defaultFileFlags
    {-nScreens  <- countScreens-}
    xmonad $ withNavigation2DConfig myNavConf $ defaults {
          logHook         = myLogHook pipe -- >> myFloatHook
        , manageHook      = myManageHook 
        , handleEventHook = borderResizesFloat <+> fullscreenEventHook
        , startupHook     = setWMName "LG3D"
        {-, workspaces = withScreens nScreens myWorkspaces-}
    }

defaults = def {
    terminal           = myTerminal,
    focusFollowsMouse  = myFocusFollowsMouse,
    clickJustFocuses   = False,
    floatFocusFollowsMouse = myFloatFocusFollowsMouse,
    focusRaisesFloat   = True,
    borderWidth        = myBorderWidth,
    modMask            = myModMask,
    workspaces         = myWorkspaces,
    normalBorderColor  = myInactive,
    focusedBorderColor = myActive,
    keys               = myKeys,
    mouseBindings      = myMouseBindings,
    layoutHook         = myLayout,
    floatHook          = myFloatDec,
    manageHook         = myManageHook,
    startupHook        = myStartupHook
}


myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
  -- Launchers
  [ sup      xK_z $ spawn $ XMonad.terminal conf
  , sup      xK_c $ spawn "firefox"
  , sup      xK_o $ spawn "synapse"
  , sup      xK_g $ spawn "nautilus"
  , sup      xK_i $ spawn "systemctl restart netctl-auto@wlp2s0.service"
  , supShift xK_z $ spawn "/usr/bin/urxvt"

  -- Music control keys
  , sup xK_bracketleft          $ spawn "spotwrap prev; ~/.config/panel/music.sh kick"
  , sup xK_bracketright         $ spawn "spotwrap next; ~/.config/panel/music.sh kick"
  , sup xK_backslash            $ spawn "spotwrap toggle"

  -- Hardware keys
  , hw xF86XK_AudioRaiseVolume  $ spawn "change-vol +5"
  , hw xF86XK_AudioLowerVolume  $ spawn "change-vol -5"
  , hw xF86XK_AudioMute         $ spawn "change-vol toggle"
  , hw xF86XK_MonBrightnessDown $ spawn "xbacklight -dec 5"
  , hw xF86XK_MonBrightnessUp   $ spawn "xbacklight -inc 5"
  , hw xK_Print                 $ spawn "scrot -e 'mv $f ~/Pictures/scrots/'"

  -- Other Keys
  , sup      xK_x        kill
  , sup      xK_q      $ restart "xmonad" True
  , sup      xK_m      $ windows W.swapDown
  , sup      xK_n      $ windows W.swapUp
  , sup      xK_s      $ sendMessage Swap
  , sup      xK_v      $ sendMessage Rotate
  , sup      xK_Up     $ sendMessage MoreSpacing
  , sup      xK_Down   $ sendMessage LessSpacing
  , sup      xK_t      $ withFocused $ windows . W.sink
  , sup      xK_space  $ sendMessage NextLayout
  , sup      xK_comma  $ sendMessage (IncMasterN 1)
  , sup      xK_period $ sendMessage (IncMasterN (-1))
  , supShift xK_q      $ io exitSuccess
  , supShift xK_space  $ setLayout $ XMonad.layoutHook conf
  ]

  -- Move to WS with Super + N, shift window to desktop with Super + Shift + N
  ++
  [((m .|. modMask, k), windows $ f i)
      | (i, k) <- zip (XMonad.workspaces conf) ([xK_1 .. xK_9] ++ [xK_0])
      , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

 {-++  -- swap screen order-}
 {-[((m .|. modMask .|. mod1Mask, key), action screen)-}
    {-| (key, screen) <- zip [xK_1..xK_3] [1,0,2]-}
    {-, (action, m) <- [(viewScreen, 0), (sendToScreen, shiftMask)]]-}

    -- Move between windows with Super
  ++ withMKeys sup        (`windowGo` False) dirs

    -- Move Float with Super + Alt
  ++ withMKeys supAlt     (withFocused . keysMoveWindow) transforms

    -- Resize Float with Super + Control + Alt
  ++ withMKeys supCtrlAlt (\dir -> withFocused $ keysResizeWindow dir (1%2, 1%2)) transforms

    -- Expand Tiling Window with Super + Shift
  ++ withMKeys supShift   (sendMessage . ExpandTowards) dirs

    -- Shrink Tiled Window with Super + Ctrl
  ++ withMKeys supCtrl   (sendMessage . ShrinkFrom) dirs

    -- Navigate WSs/Screens with Ctrl + Alt
  ++ withMKeys ctrlAlt    id [prevWS, prevScreen, nextScreen, nextWS]

dirs = [L,D,U,R]
transforms = [(8,0), (0,8), (0,-8), (8,0)]

withMKeys :: (KeySym -> X () -> ((KeyMask,KeySym), X())) -> (a -> X()) -> [a] -> [((KeyMask,KeySym), X ())]
withMKeys mod f = zipWith (\k x -> mod k $ f x) moveKeys
    where moveKeys = [xK_h, xK_j, xK_k, xK_l]

hw           key command = ((noModMask, key), command)
sup          key command = ((myModMask, key), command)
supShift     key command = ((myModMask .|. shiftMask, key), command)
supAlt       key command = ((myModMask .|. mod1Mask, key), command)
supCtrl      key command = ((myModMask .|. controlMask, key), command)
ctrlAlt      key command = ((mod1Mask  .|. controlMask, key), command)
supCtrlAlt   key command = ((myModMask .|. controlMask .|. mod1Mask, key), command)
supShiftCtrl key command = ((myModMask .|. controlMask .|. shiftMask, key), command)


myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myFloatFocusFollowsMouse :: Bool
myFloatFocusFollowsMouse = False

myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList
  [ ((modMask, button1), \w -> focus w >> mouseMoveWindow w)
  , ((modMask, button2), \w -> focus w >> windows W.swapMaster)
  , ((modMask, button3), \w -> focus w >> mouseResizeWindow w)
  ]
