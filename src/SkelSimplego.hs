module SkelSimplego where

-- Haskell module generated by the BNF converter

import AbsSimplego
import ErrM
type Result = Err String

failure :: Show a => a -> Result
failure x = Bad $ "Undefined case: " ++ show x

transIdent :: Ident -> Result
transIdent x = case x of
  Ident string -> failure x
transProgram :: Program -> Result
transProgram x = case x of
  Program topdefs -> failure x
transTopDef :: TopDef -> Result
transTopDef x = case x of
  FnDef ident args type_ block -> failure x
transArg :: Arg -> Result
transArg x = case x of
  Arg ident vartype -> failure x
transBlock :: Block -> Result
transBlock x = case x of
  Block stmts -> failure x
transStmt :: Stmt -> Result
transStmt x = case x of
  SimpleStmt simplestmt -> failure x
  ReturnStmt returnstmt -> failure x
  BreakStmt breakstmt -> failure x
  ContinueStmt continuestmt -> failure x
  BlockStmt block -> failure x
  IfStmt ifstmt -> failure x
  ForStmt forstmt -> failure x
transSimpleStmt :: SimpleStmt -> Result
transSimpleStmt x = case x of
  EmptySimpleStmt -> failure x
  ExprSimpStmt expr -> failure x
  AssSimpleStmt assstmt -> failure x
  DeclSimpleStmt declstmt -> failure x
transAssStmt :: AssStmt -> Result
transAssStmt x = case x of
  Ass ident expr -> failure x
  Incr ident -> failure x
  Decr ident -> failure x
  AddAss ident expr -> failure x
  SubAss ident expr -> failure x
  MulAss ident expr -> failure x
  DivAss ident expr -> failure x
  ModAss ident expr -> failure x
transDeclStmt :: DeclStmt -> Result
transDeclStmt x = case x of
  Decl ident type_ item -> failure x
transItem :: Item -> Result
transItem x = case x of
  NoInit -> failure x
  Init expr -> failure x
transReturnStmt :: ReturnStmt -> Result
transReturnStmt x = case x of
  Ret maybeexpr -> failure x
transMaybeExpr :: MaybeExpr -> Result
transMaybeExpr x = case x of
  MaybeExprYes expr -> failure x
  MaybeExprNo -> failure x
transBreakStmt :: BreakStmt -> Result
transBreakStmt x = case x of
  Break -> failure x
transContinueStmt :: ContinueStmt -> Result
transContinueStmt x = case x of
  Continue -> failure x
transIfStmt :: IfStmt -> Result
transIfStmt x = case x of
  If expr block maybeelse -> failure x
transMaybeElse :: MaybeElse -> Result
transMaybeElse x = case x of
  NoElse -> failure x
  Else iforblock -> failure x
transIfOrBlock :: IfOrBlock -> Result
transIfOrBlock x = case x of
  IfOfIfOrBlock ifstmt -> failure x
  BlockOfIfOrBlock block -> failure x
transForStmt :: ForStmt -> Result
transForStmt x = case x of
  For forclause block -> failure x
transForClause :: ForClause -> Result
transForClause x = case x of
  ForCond condition -> failure x
  ForFull simplestmt1 condition simplestmt2 -> failure x
transCondition :: Condition -> Result
transCondition x = case x of
  ExprCond expr -> failure x
  TrueCond -> failure x
transType :: Type -> Result
transType x = case x of
  VarType vartype -> failure x
  Void -> failure x
transVarType :: VarType -> Result
transVarType x = case x of
  Int -> failure x
  Bool -> failure x
  Fun vartypes type_ -> failure x
transExpr :: Expr -> Result
transExpr x = case x of
  EVar ident -> failure x
  ELitInt integer -> failure x
  EFun args type_ block -> failure x
  ELitTrue -> failure x
  ELitFalse -> failure x
  EApp ident exprs -> failure x
  ENeg expr -> failure x
  ENot expr -> failure x
  EMul expr1 mulop expr2 -> failure x
  EAdd expr1 addop expr2 -> failure x
  ERel expr1 relop expr2 -> failure x
  EAnd expr1 expr2 -> failure x
  EOr expr1 expr2 -> failure x
transAddOp :: AddOp -> Result
transAddOp x = case x of
  PlusOp -> failure x
  MinusOp -> failure x
transMulOp :: MulOp -> Result
transMulOp x = case x of
  TimesOp -> failure x
  DivOp -> failure x
  ModOp -> failure x
transRelOp :: RelOp -> Result
transRelOp x = case x of
  LTOp -> failure x
  LEOp -> failure x
  GTOp -> failure x
  GEOp -> failure x
  EQOp -> failure x
  NEOp -> failure x

