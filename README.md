# sql_scd_examples

Ei, você!!!

No mundo dos dados, você já ouviu falar em SCD?

O Slowly Changing Dimension (SCD) é um conceito usado para tratar mudanças que acontecem em tabelas dimensões.

Ele ajuda a manter o histórico das mudanças ou a apenas atualizar as informações, dependendo do tipo de SCD. Eles podem ser:

1) SCD Tipo 1: Atualiza o dado sem manter histórico. Apenas sobrescreve o valor antigo.

Exemplo: Se o cliente muda de "Cidade A" para "Cidade B", a "Cidade A" é substituída pela "Cidade B".

2) SCD Tipo 2: Cria uma nova linha para cada mudança, preservando o histórico.

Exemplo: Adiciona uma nova linha indicando que o cliente estava na "Cidade A" antes e agora está na "Cidade B", com datas de início e fim.

3) SCD Tipo 3: Mantém o valor antigo em outro campo.

Exemplo: O campo "Cidade Anterior" mostra a "Cidade A", enquanto o campo atual mostra "Cidade B".

Além dos SCD Tipo 1, 2 e 3, há outros tipos menos comuns que abordam variações específicas no tratamento de mudanças em dimensões. Estes incluem:

4) SCD Tipo 4: Mantém o histórico em uma tabela separada, conhecida como tabela de histórico.

Exemplo: A tabela principal armazena apenas os dados atuais, enquanto outra tabela guarda todas as mudanças ao longo do tempo.

5) SCD Tipo 5: Combina os tipos 1 e 4. Os dados atuais são armazenados na tabela principal (sobrescritos como no Tipo 1), mas o histórico completo é mantido em uma tabela de histórico separada (como no Tipo 4).

Útil para sistemas que precisam de histórico, mas não querem expandir a tabela principal.

6) SCD Tipo 6 (ou "Hybrid SCD"):

É uma combinação dos tipos 1, 2 e 3.

Na prática, a tabela armazena o valor atual (Tipo 1), o histórico completo com múltiplas linhas (Tipo 2) e o valor anterior em uma coluna separada (Tipo 3).

Exemplo: Um registro mantém o valor atual, outro campo guarda o valor anterior e múltiplas linhas preservam todas as versões do dado.
