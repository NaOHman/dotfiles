import Control.Monad
import Data.Ratio
import Graphics.X11.ExtraTypes.XF86
import System.Exit
import System.Environment
import System.Posix.IO
import XMonad 
import XMonad.Actions.Navigation2D
import XMonad.Actions.FloatKeys
import XMonad.Float.SimplestFloatDec
import XMonad.Layout.BinarySpacePartition
import XMonad.Hooks.BorderResize
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.InsertPosition hiding (Position)
import XMonad.Hooks.ManageDocks 
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Layout.Fullscreen
import XMonad.Layout.Gaps
import XMonad.Layout.NoBorders
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.XUtils
import qualified XMonad.StackSet as W
import qualified XMonad.Core as C
import qualified Data.Map        as M
import XMonad.Layout.EqualSpacing

myTerminal = "/usr/bin/urxvt"
myWorkspaces = map show ([1..9] ++ [0])

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
    ] <+> manageDocks
    where isFloating = ask >>= \w -> liftX . gets $ M.member w . W.floating . windowset
          putAbove   = insertPosition Master Newer


------------------------------------------------------------------------
-- Layouts
myLayout = gaps [(U,48)] (smartBorders (avoidStruts (equalSpacing 24 4 1 1 myBSP))) ||| noBorders (fullscreenFull Full)
    where myBSP = configBSP 0.025 0.60

myActive   = "#281200" -- color8
myInactive = "#5c3809" -- color10

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
    { activeColor         = "#281200" --color8
    , inactiveColor       = "#281200" --color8
    , urgentColor         = "#281200" --color8
    , activeBorderColor   = "#281200" --color8
    , inactiveBorderColor = "#281200" --color8
    , urgentBorderColor   = "##281200" --color8
    , activeTextColor     = "#a07230" --color11
    , inactiveTextColor   = "#a07230" --color11
    , urgentTextColor     = "#a07230" --color11
    , fontName            = "-*-ubuntu-*-r-*-*-14-*-*-*-*-*-*-*"
    , decoHeight          = 36
    }

myNavConf = def { layoutNavigation = [("BSP", centerNavigation)] }

main = do
    fifo <- getEnv "PANEL_FIFO"
    pipe <- openFd fifo WriteOnly Nothing defaultFileFlags
    xmonad $ withNavigation2DConfig myNavConf $ defaults {
          logHook         = myLogHook pipe -- >> myFloatHook
        , manageHook      = myManageHook 
        , handleEventHook = borderResizesFloat
        , startupHook     = setWMName "LG3D"
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
  [ ((modMask, xK_z),               spawn $ XMonad.terminal conf)
  , ((modMask, xK_c),               spawn "firefox")
  , ((modMask, xK_o),               spawn "synapse")
  , ((modMask, xK_g),               spawn "nautilus")
  , ((modMask, xK_x),               kill)
  , ((modMask, xK_m),               windows W.swapDown  )
  , ((modMask, xK_n),               windows W.swapUp    )
  , ((modMask, xK_j),               windowGo D False)
  , ((modMask, xK_k),               windowGo U False )
  , ((modMask, xK_h),               windowGo L False)
  , ((modMask, xK_l),               windowGo R False)
  , ((modMask, xK_r),               sendMessage Rotate)
  , ((modMask, xK_s),               sendMessage Swap)
  , ((modMask, xK_t),               withFocused $ windows . W.sink)
  , ((modMask, xK_q),               restart "xmonad" True)
  , ((modMask, xK_w),               sendMessage MoreSpacing)
  , ((modMask, xK_e),               sendMessage LessSpacing)
  , ((modMask, xK_space),           sendMessage NextLayout)
  , ((modMask, xK_comma),           sendMessage (IncMasterN 1))
  , ((modMask, xK_period),          sendMessage (IncMasterN (-1)))
  , ((modMask, xK_bracketleft),     spawn "spotwrap prev; ~/.config/panel/music.sh kick")
  , ((modMask, xK_bracketright),    spawn "spotwrap next; ~/.config/panel/music.sh kick")
  , ((modMask, xK_backslash),       spawn "spotwrap toggle")
  , ((noModMask, xF86XK_AudioRaiseVolume),  spawn "change-vol 5%+")
  , ((noModMask, xF86XK_AudioLowerVolume),  spawn "change-vol 5%-")
  , ((noModMask, xF86XK_AudioMute),         spawn "change-vol toggle")
  , ((noModMask, xF86XK_MonBrightnessDown), spawn "xbacklight -dec 5")
  , ((noModMask, xF86XK_MonBrightnessUp),   spawn "xbacklight -inc 5")
  , ((modMask .|. shiftMask, xK_q), io exitSuccess)
  , ((modMask .|. mod1Mask, xK_j), withFocused (keysMoveWindow (0,8) ))
  , ((modMask .|. mod1Mask, xK_k), withFocused (keysMoveWindow (0,-8)))
  , ((modMask .|. mod1Mask, xK_h), withFocused (keysMoveWindow (-8,0)))
  , ((modMask .|. mod1Mask, xK_l), withFocused (keysMoveWindow (8,0) ))
  , ((modMask .|. mod1Mask .|. controlMask, xK_h), withFocused (keysResizeWindow (-8,0) (1%2, 1%2)))
  , ((modMask .|. mod1Mask .|. controlMask, xK_l), withFocused (keysResizeWindow (8,0) (1%2, 1%2)))
  , ((modMask .|. mod1Mask .|. controlMask, xK_j), withFocused (keysResizeWindow (0,-8) (1%2, 1%2)))
  , ((modMask .|. mod1Mask .|. controlMask, xK_k), withFocused (keysResizeWindow (0,8) (1%2, 1%2)))
  , ((modMask .|. shiftMask, xK_l), sendMessage $ ExpandTowards R)
  , ((modMask .|. shiftMask, xK_h), sendMessage $ ExpandTowards L)
  , ((modMask .|. shiftMask, xK_j), sendMessage $ ExpandTowards D)
  , ((modMask .|. shiftMask, xK_k), sendMessage $ ExpandTowards U)
  , ((modMask .|. shiftMask .|. controlMask , xK_l), sendMessage $ ShrinkFrom R)
  , ((modMask .|. shiftMask .|. controlMask , xK_h), sendMessage $ ShrinkFrom L)
  , ((modMask .|. shiftMask .|. controlMask , xK_j), sendMessage $ ShrinkFrom D)
  , ((modMask .|. shiftMask .|. controlMask , xK_k), sendMessage $ ShrinkFrom U)
  , ((modMask .|. shiftMask, xK_space),      setLayout $ XMonad.layoutHook conf)
  , ((modMask, xK_0), windows $ W.greedyView "0")
  , ((modMask .|. shiftMask, xK_0), windows $ W.shift "0")
  ]
  ++

  [((m .|. modMask, k), windows $ f i)
      | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
      , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myFloatFocusFollowsMouse :: Bool
myFloatFocusFollowsMouse = False

myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList
  [ ((modMask, button1), \w -> focus w >> mouseMoveWindow w)
  , ((modMask, button2), \w -> focus w >> windows W.swapMaster)
  , ((modMask, button3), \w -> focus w >> mouseResizeWindow w)
  {-, ((noModMask, button1), \_ -> return ())-}
  ]
