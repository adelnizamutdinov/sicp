module Test.HigherProcedures where

import Prelude (class Show, (==), return, ($), bind, negate, (-), (>=), (&&), (<=))
import Data.Generic (class Generic, gShow)
import Test.QuickCheck.Gen (chooseInt, choose)
import Test.QuickCheck.Arbitrary (class Arbitrary)
import Basic (cube)
import HigherProcedures (inc, productIter, product, sumIter, sum, simpsonsRule, integral)

-- Approximate equality comparison
approxEqual :: Number -> Number -> Boolean
approxEqual x y = (y - x) <= eps && (y - x) >= (-eps)
  where eps = 0.1

infixl 9 approxEqual as =~=

data LeftRight = LeftRight Number Number

instance arbitraryLeftRight :: Arbitrary LeftRight where
  arbitrary = do
    l <- choose (-2.0) 2.0
    r <- choose l 2.0
    return $ LeftRight l r

prop_Integral :: LeftRight -> Boolean
prop_Integral (LeftRight a b) = left =~= right
  where left  = integral cube a b 0.01
        right = simpsonsRule cube a b

data LeftRightInt = LeftRightInt Int Int
derive instance genericLeftRightInt :: Generic LeftRightInt
instance showLeftRightInt :: Show LeftRightInt where
  show = gShow

instance arbitraryLeftRightInt :: Arbitrary LeftRightInt where
  arbitrary = do
    l <- chooseInt (-1000) 1000
    r <- chooseInt l 1000
    return $ LeftRightInt l r

prop_SumIter :: LeftRightInt -> Boolean
prop_SumIter (LeftRightInt a b) = s1 == s2
  where s1 = sum inc a inc b
        s2 = sumIter inc a inc b

prop_Product :: LeftRightInt -> Boolean
prop_Product (LeftRightInt a b) = s1 == s2
  where s1 = product inc a inc b
        s2 = productIter inc a inc b
