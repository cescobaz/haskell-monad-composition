# Monad Composition Example

## Pure computation using Either monad

```bash
git checkout pure-computation-using-either-monad
```

Define the app type as an alias of Either.

```haskell
type PascalM a = Either String a
```

Then I suggest to use it as a monad:

```haskell
parseNumber s (x : xs)
    | isDigit x = parseNumber (s ++ [ x ]) xs
    | x == '+' && not (null s) = (+) l <$> parseNumber "" xs
    | otherwise = Left ("unexpected " ++ [ x ])
  where
    l = read s
```

### Not with pattern matching

```bash
git checkout pure-computation-using-either-monad-pattern-matching
```

```haskell
parseNumber s (x : xs)
    | isDigit x = parseNumber (s ++ [ x ]) xs
    | x == '+' && not (null s) = case (parseNumber "" xs) of
        Right r -> Right (r + l)
        Left err -> Left err
    | otherwise = Left ("unexpected " ++ [ x ])
  where
    l = read s
```

## One level of monad composition: ExceptT

Monads are like a computation, a computation where only some behavior are allowed.  

To create you own monad (ready to be composed):  

1. define your monad transformer type based on a transformer;

```haskell
type PascalT m a = ExceptT String m a
```

2. define your transformer runner;

```haskell
runPascalT :: (Monad m) => PascalT m a -> m (Either String a)
runPascalT = runExceptT
```

Transformer runner will execute the monad (`ExceptT` in this case) and pop out the inner monad `m`, ready to be runned by another runner.

3. define your monad type;

```haskell
type PascalM a = PascalT Identity a
```

Because of run*T will pop out the inner monad `m`, at some poit we need stop the composition and we can do it by using an `Identity` monad that does nothing than give as the value `a`.  
If you need to use `IO` in your monad you can use `IO` insted of `Identity`.

4. define your monad runner.

```haskell
runPascal :: PascalM a -> Either String a
runPascal = runIdentity . runPascalT
```

## Two level of monad composition: ExceptT StateT

The type of app monad is the same, but the generic `m` is now wrapped by an other monad: the StateT monad transformer.

```haskell
-- before
type PascalT m a = ExceptT String m a
-- after
type PascalT m a = ExceptT String (StateT Memory m) a
```

Transformer runner needs to run also the StateT transformer. Just add it (with the initial state).  

```haskell
-- before
runPascalT :: (Monad m) => PascalT m a -> m (Either String a)
runPascalT m = runExceptT m
-- after
runPascalT :: (Monad m) => PascalT m a -> Memory -> m (Either String a)
runPascalT m = evalStateT (runExceptT m)
```

Then change add the initial state in the monad runner.

```haskell
-- before
runPascal :: PascalM a -> Either String a
runPascal m = runIdentity (runPascalT m)
-- after
runPascal :: PascalM a -> Either String a
runPascal m = runIdentity (runPascalT m (Memory [] 0))
```

Now it is possible to use State monad functions like `get`, `put` or `modify` inside your app monad using `lift` as prefix.  
If you are using [`transformer`](https://hackage.haskell.org/package/transformers-0.5.6.2) lib you need to use [`lift`](https://hackage.haskell.org/package/transformers-0.5.6.2/docs/Control-Monad-Trans-Class.html#v:lift) operator to add monad.  

Note that your app monad interface doesn't changed, so you don't need to change tests.

## Three level of monad composition: ExceptT StateT WriterT

Ok, lets add another layer of monad. Lets try a WriterT.  
Start from the type of the app monad: just replace m with the new transformer:

```haskell
-- before
type PascalT m a = ExceptT String (StateT Memory m) a
-- after
type PascalT m a = ExceptT String (StateT Memory (WriterT String m)) a
```

Then call the relative runner in our app runner:

```haskell
-- before
runPascalT :: (Monad m) => PascalT m a -> Memory -> m (Either String a)
runPascalT m = evalStateT (runExceptT m)
-- after
runPascalT :: (Monad m) => PascalT m a -> Memory -> m (Either String a, String)
runPascalT m memory = runWriterT (evalStateT (runExceptT m) memory)
```

I changed the output type to a tuple with the "old" result plus the output of WriterT, a String in this case.  

Accordingly I correct the main runner.

```haskell
-- before
runPascal :: PascalM a -> Either String a
runPascal m = runIdentity (runPascalT m (Memory [] 0))
-- after
runPascal :: PascalM a -> (Either String a, String)
runPascal m = runIdentity (runPascalT m (Memory [] 0))
```

Ok, now is time to use the new WriterT layer, but at this time it is necessary to call `lift` two times, e.g.:

```haskell
tell :: Monad m => String -> PascalT m ()
tell = lift . lift . Control.Monad.Trans.Writer.tell . (:) ':'
```

