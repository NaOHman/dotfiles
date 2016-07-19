{-# LANGUAGE DeriveDataTypeable, FlexibleInstances, MultiParamTypeClasses #-}

module EqualSpacing ( equalSpacing
                                  , EqualSpacing
                                  , EqualSpacingMsg (..) ) where

import Control.Arrow                (second)
import Graphics.X11                 (Rectangle(..))
import XMonad.Core
import XMonad.StackSet              (integrate', stack, Stack(..) )
import XMonad.Util.Font             (fi)
import XMonad.Layout.LayoutModifier


equalSpacing :: Int -> Int -> Int -> l a -> ModifiedLayout EqualSpacing l a
equalSpacing gap add min = ModifiedLayout (EqualSpacing gap add min)


data EqualSpacingMsg = MoreSpacing | LessSpacing deriving (Typeable)


instance Message EqualSpacingMsg


data EqualSpacing a = EqualSpacing
    { gap  :: Int
    , add  :: Int
    , min  :: Int
    } deriving (Show, Read)


instance LayoutModifier EqualSpacing a where

    modifierDescription eqsp = "EqualSpacing " ++ show eqsp

    modifyLayout eqsp workspace screen =
        runLayout workspace $ shrinkScreen eqsp screen

    pureModifier eqsp _ stck windows =
        (map (second $ shrinkWindow eqsp) windows, Nothing)

    pureMess eqsp msg

        | Just MoreSpacing <- fromMessage msg = Just $
            eqsp { gap = 1 + fi (gap eqsp) }

        | Just LessSpacing <- fromMessage msg = Just $
            eqsp { gap = max 0 ((-1) + fi (gap eqsp)) }

        | otherwise = Nothing


shrinkScreen :: EqualSpacing a -> Rectangle -> Rectangle
shrinkScreen (EqualSpacing gap _ m) (Rectangle x y w h) =
    Rectangle x y (w-fi sp) (h-fi sp)
    where sp = max m gap


shrinkWindow :: EqualSpacing a -> Rectangle -> Rectangle
shrinkWindow (EqualSpacing gap _ m) (Rectangle x y w h) =
    Rectangle (x+fi sp) (y+fi sp) (w-fi sp) (h-fi sp)
    where sp = max m gap 
