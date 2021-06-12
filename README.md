# Monad Composition Example

## One level of monad composition: ExceptT

Monads are like a computation, a computation where only some behavior are allowed.  

To create you own monad (ready to be composed) just define a new type. One type for transformer and one for the monad.  

Usually a monad has a runner. So we need to define 2 runners, one for the transformer and one for the monad.  

Given a Monad as `MyMonad a`, runner run the monad instance and return something like `a`.

## Second level of monad composition: ExceptT StateT

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
