# Monad Composition Example

## One level of monad composition: ExceptT

Monads are like a computation, a computation where only some behavior are allowed.  

To create you own monad (ready to be composed) just define a new type. One type for transformer and one for the monad.  

Usually a monad has a runner. So we need to define 2 runners, one for the transformer and one for the monad.  

Given a Monad as `MyMonad a`, runner run the monad instance and return something like `a`.
