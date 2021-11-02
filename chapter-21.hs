 -- I don't want any warnings as exercises will have some warnings.
{-# OPTIONS_GHC -w #-}

module Chapter_21 where

-- Chapter Exercises

-- Traversable instances

-- Write a Traversable instance for the datatype provided, filling in any
-- required superclasses. Use QuickCheck to validate your instances.

-- Identity
-- Write a Traversable instance for Identity.

newtype Identity' a = Identity' a
  deriving (Eq, Show)

instance Functor Identity' where
  fmap f (Identity' a) = Identity' $ f a

instance Foldable Identity' where
  foldMap f (Identity' a) = f a

instance Traversable Identity' where
  traverse f (Identity' a) = Identity' <$> f a

-- Constant

newtype Constant' a b = Constant' { getConstant' :: a }
  deriving (Eq, Show)

instance Functor (Constant' a) where
  fmap _ (Constant' a) = Constant' a

instance Foldable (Constant' a) where
  foldMap _ _ = mempty

instance Traversable (Constant' a) where
  traverse _ (Constant' a) = pure $ Constant' a

-- Maybe

data Optional a =
    Nada
  | Yep a
  deriving (Eq, Show)

instance Functor Optional where
  fmap _ Nada = Nada
  fmap f (Yep a) = Yep $ f a

instance Foldable Optional where
  foldMap _ Nada = mempty
  foldMap f (Yep a) = f a

instance Traversable Optional where
  traverse _ Nada = pure Nada
  traverse f (Yep a) = Yep <$> f a

-- List
data List a = Nil | Cons a (List a)
  deriving (Eq, Show)

instance Functor List where
  fmap _ Nil = Nil
  fmap f (Cons a as) = Cons (f a) $ fmap f as

instance Foldable List where
  foldMap _ Nil = mempty
  foldMap f (Cons a as) = f a <> foldMap f as

instance Traversable List where
  traverse _ Nil = pure Nil
  traverse f (Cons a as) = Cons <$> f a <*> traverse f as

-- Three
data Three' a b c = Three' a b c
  deriving (Eq, Show)

instance Functor (Three' a b) where
  fmap f (Three' a b c) = Three' a b $ f c

instance Foldable (Three' a b) where
  foldMap f (Three' _ _ c) = f c

instance Traversable (Three' a b) where
  traverse f (Three' a b c) = Three' a b <$> f c

-- Pair
data Pair a b = Pair a b
  deriving (Eq, Show)

instance Functor (Pair a) where
  fmap f (Pair a b) = Pair a $ f b

instance Foldable (Pair a) where
  foldMap f (Pair a b) = f b

instance Traversable (Pair a) where
  traverse f (Pair a b) = Pair a <$> f b

-- Big
-- When you have more than one value of type 𝑏, you’ll want to use Monoid and
-- Applicative for the Foldable and Traversable instances respectively.

data Big a b = Big a b b
  deriving (Eq, Show)

instance Functor (Big a) where
  fmap f (Big a b b') = Big a (f b) (f b')

instance Foldable (Big a) where
  foldMap f (Big _ b b') = f b <> f b'

instance Traversable (Big a) where
  traverse f (Big a b b') = Big a <$> f b <*> f b'

-- Bigger
-- Same as for Big.

data Bigger a b = Bigger a b b b
  deriving (Eq, Show)

instance Functor (Bigger a) where
  fmap f (Bigger a b b' b'') = Bigger a (f b) (f b') (f b'')

instance Foldable (Bigger a) where
  foldMap f (Bigger _ b b' b'') = f b <> f b' <> f b''

instance Traversable (Bigger a) where
  traverse f (Bigger a b b' b'') = Bigger a <$> f b <*> f b' <*> f b''
