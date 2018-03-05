import Html exposing (text)

-- Considere uma turma de 50 alunos.
-- Cada aluno possui duas notas.
-- O aluno que ficou com média maior ou igual a sete é considerado aprovado.

-- Considere as seguintes definições em Elm para os tipos Aluno e Turma:

type alias Aluno = (String, Float, Float) -- Aluno é um tipo tupla com o nome e as duas notas
type alias Turma = List Aluno             -- Turma é um tipo lista de alunos

-- O nome ou a média de um aluno pode ser obtido através das seguintes funções:

media: Aluno -> Float
media (_,n1,n2) = (n1+n2)/2     -- o nome é ignorado

nome: Aluno -> String
nome (nm,_,_) = nm              -- as notas são ignoradas

-- Por fim, considere as assinaturas para as funções map, filter, e fold a seguir:

--List.map: (a->b) -> (List a) -> (List b)
  -- mapeia uma lista de a's para uma lista de b's com uma função de a para b

--List.filter: (a->Bool) -> (List a) -> (List a)
  -- filtra uma lista de a's para uma nova lista de a's com uma função de a para Bool

--List.foldl : (a->b->b) -> b -> List a -> b
  -- reduz uma lista de a's para um valor do tipo b
        -- usa um valor inicial do tipo b
        -- usa uma função de acumulacao que
            -- recebe um elemento da lista de a
            -- recebe o atual valor acumulado
            -- retorna um novo valor acumulado

-- Usando as definições acima, forneça a implementação para os três trechos marcados com <...>:

turma: Turma
turma = [ ("Joao",7,4), ("Maria",10,8), ("Felipe",8,8), ("Mariana",5,2), ("Alana", 8, 3) ]       -- 50 alunos

-- a) LISTA COM AS MÉDIAS DOS ALUNOS DE "turma" ([5.5, 9, ...])
medias: List Float
medias = List.map media turma

-- b) LISTA COM OS NOMES DOS ALUNOS DE "turma" APROVADOS (["Maria", ...])
aprovado: Aluno -> Bool
aprovado a = if media a >= 7 then True else False
aprovados: List String
aprovados = List.map nome (List.filter aprovado turma)

-- c) MÉDIA FINAL DOS ALUNOS DE "turma" (média de todas as médias)
total: Float
total = (List.foldl (+) 0 medias) / (toFloat (List.length medias))

-- d) LISTA DE ALUNOS QUE GABARITARAM A P1 ([("Maria",10,8), ...])
gabaritou: Aluno -> Bool
gabaritou (_,n1,_) = if n1 == 10 then True else False
turma_dez_p1: Turma
turma_dez_p1 = List.filter gabaritou turma

-- e) LISTA COM OS NOMES E MEDIAS DOS ALUNOS APROVADOS ([("Maria",9), ...])
nomemedia: Aluno -> (String, Float)
nomemedia a = (nome a, media a)
aprov: (String,Float) -> Bool
aprov (_,m) = if m >= 7 then True else False
aprovados2: List (String,Float)
aprovados2 = List.filter aprov (List.map nomemedia turma)

-- f) LISTA COM TODAS AS NOTAS DE TODAS AS PROVAS ([7,4,10,8,...])
todasnotas: Aluno -> List Float
todasnotas (_,n1,n2) = [n1,n2]
notas: List Float
notas = List.foldr List.append [] (List.map todasnotas turma) 

-- É permitido usar funções auxiliares, mas não é necessário.
-- (As soluções são pequenas.)

main = text (toString turma)
