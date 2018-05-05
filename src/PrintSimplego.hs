{-# OPTIONS_GHC -fno-warn-incomplete-patterns #-}
module PrintSimplego where

-- pretty-printer generated by the BNF converter

import AbsSimplego
import Data.Char


-- the top-level printing method
printTree :: Print a => a -> String
printTree = render . prt 0

type Doc = [ShowS] -> [ShowS]

doc :: ShowS -> Doc
doc = (:)

render :: Doc -> String
render d = rend 0 (map ($ "") $ d []) "" where
  rend i ss = case ss of
    "["      :ts -> showChar '[' . rend i ts
    "("      :ts -> showChar '(' . rend i ts
    "{"      :ts -> showChar '{' . new (i+1) . rend (i+1) ts
    "}" : ";":ts -> new (i-1) . space "}" . showChar ';' . new (i-1) . rend (i-1) ts
    "}"      :ts -> new (i-1) . showChar '}' . new (i-1) . rend (i-1) ts
    ";"      :ts -> showChar ';' . new i . rend i ts
    t  : "," :ts -> showString t . space "," . rend i ts
    t  : ")" :ts -> showString t . showChar ')' . rend i ts
    t  : "]" :ts -> showString t . showChar ']' . rend i ts
    t        :ts -> space t . rend i ts
    _            -> id
  new i   = showChar '\n' . replicateS (2*i) (showChar ' ') . dropWhile isSpace
  space t = showString t . (\s -> if null s then "" else (' ':s))

parenth :: Doc -> Doc
parenth ss = doc (showChar '(') . ss . doc (showChar ')')

concatS :: [ShowS] -> ShowS
concatS = foldr (.) id

concatD :: [Doc] -> Doc
concatD = foldr (.) id

replicateS :: Int -> ShowS -> ShowS
replicateS n f = concatS (replicate n f)

-- the printer class does the job
class Print a where
  prt :: Int -> a -> Doc
  prtList :: Int -> [a] -> Doc
  prtList i = concatD . map (prt i)

instance Print a => Print [a] where
  prt = prtList

instance Print Char where
  prt _ s = doc (showChar '\'' . mkEsc '\'' s . showChar '\'')
  prtList _ s = doc (showChar '"' . concatS (map (mkEsc '"') s) . showChar '"')

mkEsc :: Char -> Char -> ShowS
mkEsc q s = case s of
  _ | s == q -> showChar '\\' . showChar s
  '\\'-> showString "\\\\"
  '\n' -> showString "\\n"
  '\t' -> showString "\\t"
  _ -> showChar s

prPrec :: Int -> Int -> Doc -> Doc
prPrec i j = if j<i then parenth else id


instance Print Integer where
  prt _ x = doc (shows x)


instance Print Double where
  prt _ x = doc (shows x)


instance Print Ident where
  prt _ (Ident i) = doc (showString ( i))



instance Print Program where
  prt i e = case e of
    Program topdefs -> prPrec i 0 (concatD [prt 0 topdefs])

instance Print TopDef where
  prt i e = case e of
    FnDef id args type_ block -> prPrec i 0 (concatD [doc (showString "func"), prt 0 id, doc (showString "("), prt 0 args, doc (showString ")"), prt 0 type_, prt 0 block])
  prtList _ [x] = (concatD [prt 0 x])
  prtList _ (x:xs) = (concatD [prt 0 x, prt 0 xs])
instance Print Arg where
  prt i e = case e of
    Arg id vartype -> prPrec i 0 (concatD [prt 0 id, prt 0 vartype])
  prtList _ [] = (concatD [])
  prtList _ [x] = (concatD [prt 0 x])
  prtList _ (x:xs) = (concatD [prt 0 x, doc (showString ","), prt 0 xs])
instance Print Block where
  prt i e = case e of
    Block stmts -> prPrec i 0 (concatD [doc (showString "{"), prt 0 stmts, doc (showString "}")])

instance Print Stmt where
  prt i e = case e of
    SimpleStmt simplestmt -> prPrec i 0 (concatD [prt 0 simplestmt, doc (showString ";")])
    ReturnStmt maybeexpr -> prPrec i 0 (concatD [doc (showString "return"), prt 0 maybeexpr, doc (showString ";")])
    BreakStmt -> prPrec i 0 (concatD [doc (showString "break"), doc (showString ";")])
    ContinueStmt -> prPrec i 0 (concatD [doc (showString "continue"), doc (showString ";")])
    PrintStmt expr -> prPrec i 0 (concatD [doc (showString "print"), doc (showString "("), prt 0 expr, doc (showString ")"), doc (showString ";")])
    BlockStmt block -> prPrec i 0 (concatD [prt 0 block])
    IfStmt ifstmt -> prPrec i 0 (concatD [prt 0 ifstmt])
    ForStmt forclause block -> prPrec i 0 (concatD [doc (showString "for"), prt 0 forclause, prt 0 block])
  prtList _ [] = (concatD [])
  prtList _ (x:xs) = (concatD [prt 0 x, prt 0 xs])
instance Print SimpleStmt where
  prt i e = case e of
    EmptySimpleStmt -> prPrec i 0 (concatD [])
    ExprSimpleStmt expr -> prPrec i 0 (concatD [prt 0 expr])
    AssSimpleStmt assstmt -> prPrec i 0 (concatD [prt 0 assstmt])
    DeclSimpleStmt id vartype item -> prPrec i 0 (concatD [doc (showString "var"), prt 0 id, prt 0 vartype, prt 0 item])

instance Print AssStmt where
  prt i e = case e of
    Ass id expr -> prPrec i 0 (concatD [prt 0 id, doc (showString "="), prt 0 expr])
    Incr id -> prPrec i 0 (concatD [prt 0 id, doc (showString "++")])
    Decr id -> prPrec i 0 (concatD [prt 0 id, doc (showString "--")])
    AssOp id assop expr -> prPrec i 0 (concatD [prt 0 id, prt 0 assop, prt 0 expr])

instance Print AssOp where
  prt i e = case e of
    AddAss -> prPrec i 0 (concatD [doc (showString "+=")])
    SubAss -> prPrec i 0 (concatD [doc (showString "-=")])
    MulAss -> prPrec i 0 (concatD [doc (showString "*=")])
    DivAss -> prPrec i 0 (concatD [doc (showString "/=")])
    ModAss -> prPrec i 0 (concatD [doc (showString "%=")])

instance Print Item where
  prt i e = case e of
    NoInit -> prPrec i 0 (concatD [])
    Init expr -> prPrec i 0 (concatD [doc (showString "="), prt 0 expr])

instance Print MaybeExpr where
  prt i e = case e of
    MaybeExprYes expr -> prPrec i 0 (concatD [prt 0 expr])
    MaybeExprNo -> prPrec i 0 (concatD [])

instance Print IfStmt where
  prt i e = case e of
    If expr block maybeelse -> prPrec i 0 (concatD [doc (showString "if"), prt 0 expr, prt 0 block, prt 0 maybeelse])

instance Print MaybeElse where
  prt i e = case e of
    NoElse -> prPrec i 0 (concatD [])
    Else iforblock -> prPrec i 0 (concatD [doc (showString "else"), prt 0 iforblock])

instance Print IfOrBlock where
  prt i e = case e of
    IfOfIfOrBlock ifstmt -> prPrec i 0 (concatD [prt 0 ifstmt])
    BlockOfIfOrBlock block -> prPrec i 0 (concatD [prt 0 block])

instance Print ForClause where
  prt i e = case e of
    ForCond condition -> prPrec i 0 (concatD [prt 0 condition])
    ForFull simplestmt1 condition simplestmt2 -> prPrec i 0 (concatD [prt 0 simplestmt1, doc (showString ";"), prt 0 condition, doc (showString ";"), prt 0 simplestmt2])

instance Print Condition where
  prt i e = case e of
    ExprCond expr -> prPrec i 0 (concatD [prt 0 expr])
    TrueCond -> prPrec i 0 (concatD [])

instance Print Type where
  prt i e = case e of
    VarType vartype -> prPrec i 0 (concatD [prt 0 vartype])
    TVoid -> prPrec i 0 (concatD [])

instance Print VarType where
  prt i e = case e of
    TInt -> prPrec i 0 (concatD [doc (showString "int")])
    TBool -> prPrec i 0 (concatD [doc (showString "bool")])
    TFun vartypes type_ -> prPrec i 0 (concatD [doc (showString "func"), doc (showString "("), prt 0 vartypes, doc (showString ")"), prt 0 type_])
  prtList _ [] = (concatD [])
  prtList _ [x] = (concatD [prt 0 x])
  prtList _ (x:xs) = (concatD [prt 0 x, doc (showString ","), prt 0 xs])
instance Print Expr where
  prt i e = case e of
    EVar id -> prPrec i 7 (concatD [prt 0 id])
    ELitInt n -> prPrec i 7 (concatD [prt 0 n])
    EFun args type_ block -> prPrec i 7 (concatD [doc (showString "func"), doc (showString "("), prt 0 args, doc (showString ")"), prt 0 type_, prt 0 block])
    ELitTrue -> prPrec i 7 (concatD [doc (showString "true")])
    ELitFalse -> prPrec i 7 (concatD [doc (showString "false")])
    EApp expr exprs -> prPrec i 6 (concatD [prt 6 expr, doc (showString "("), prt 0 exprs, doc (showString ")")])
    ENeg expr -> prPrec i 5 (concatD [doc (showString "-"), prt 6 expr])
    ENot expr -> prPrec i 5 (concatD [doc (showString "!"), prt 6 expr])
    EMul expr1 mulop expr2 -> prPrec i 4 (concatD [prt 4 expr1, prt 0 mulop, prt 5 expr2])
    EAdd expr1 addop expr2 -> prPrec i 3 (concatD [prt 3 expr1, prt 0 addop, prt 4 expr2])
    ERel expr1 relop expr2 -> prPrec i 2 (concatD [prt 2 expr1, prt 0 relop, prt 3 expr2])
    EAnd expr1 expr2 -> prPrec i 1 (concatD [prt 2 expr1, doc (showString "&&"), prt 1 expr2])
    EOr expr1 expr2 -> prPrec i 0 (concatD [prt 1 expr1, doc (showString "||"), prt 0 expr2])
  prtList _ [] = (concatD [])
  prtList _ [x] = (concatD [prt 0 x])
  prtList _ (x:xs) = (concatD [prt 0 x, doc (showString ","), prt 0 xs])
instance Print AddOp where
  prt i e = case e of
    PlusOp -> prPrec i 0 (concatD [doc (showString "+")])
    MinusOp -> prPrec i 0 (concatD [doc (showString "-")])

instance Print MulOp where
  prt i e = case e of
    TimesOp -> prPrec i 0 (concatD [doc (showString "*")])
    DivOp -> prPrec i 0 (concatD [doc (showString "/")])
    ModOp -> prPrec i 0 (concatD [doc (showString "%")])

instance Print RelOp where
  prt i e = case e of
    LTOp -> prPrec i 0 (concatD [doc (showString "<")])
    LEOp -> prPrec i 0 (concatD [doc (showString "<=")])
    GTOp -> prPrec i 0 (concatD [doc (showString ">")])
    GEOp -> prPrec i 0 (concatD [doc (showString ">=")])
    EQOp -> prPrec i 0 (concatD [doc (showString "==")])
    NEOp -> prPrec i 0 (concatD [doc (showString "!=")])


