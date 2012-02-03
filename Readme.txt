Semestrální práce
==================

Téma: Determinizace textového vyhledávacího automatu.

Popis: Práce je variací na nabídnuté téma "Determinizace konečných automatů".
       Existuje mnoho druhů automatů a ne všechny umíme determinizovat - proto 
       není možné implementovat aplikaci pro determinizaci automatů obecně.

       Současná implementace má pár omezení:
       1. znaky abecedy mohou být opravdu jen znaky (např. 'a', 'b', 'c' nebo '&'),
          ale ne série znaků (např. 'a0', 'a1' nebo 'a2' - které mohou tvořit 
          ohodnocenou abecedu např u stromových vyhledávacích automatů.
       2. jako znak abecedy nelze použít mezeru, tabulátor nebo jiné neviditelné znaky
          (aplikace je neumí načíst). Stejně tak nesmí mezery obsahovat prohledávaný soubor
          (znaky zakončující žádek nevadí - jsou ignorovány)

       Aplikace vezme vstup ze souboru (viz. dále), vytvoří nedeterministický automat, 
       zdeterminizuje ho a použije ho pro vyhledávání zadaných vzorů v zadaném souboru.
       Jako výstup vypíše všechny hledané vzory a indexy na kterých v souboru začínají
       jejich jednotlivé výskyty. Aplikace rovněž vykreslí přechodové tabulky obou automatů.

Formát vstupního souboru (začátek a konec souboru označuje řádka pomlček)
-------------------------
[znaky abecedy]
[vyhledávané vzory]
[cesta k textovému souboru, který se má prohledat]
-------------------------

[znaky abecedy] - jsou jednoznakové řetězce oddělené mezerou (např. "a b c" 
                  je tříznaková abeceda).

[vyhledávané vzory] - jsou posloupnosti znaků abecedy oddělené svislítkem ('|'). 
                      Např. pro výše uvedenou abecedu je řetězec "abaacabba" platným 
                      vyhledávacím vzorem, zatímco řetězec "abcd" jím není, protože 
                      znak 'd' není v abecedě. Vyhledávacích vzorů může být více než 
                      jeden.

[cesta k textovému souboru ...] - je nějaká platná cesta k souboru.

