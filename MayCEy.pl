avion(cessna).
avion(beechcraft).
avion(embraerPhenom).
avion(boing717).
avion(embraer190).
avion(airBusA220).
avion(boing747).
avion(airBusA340).
avion(airBusA380).
es_pequeño(cessna).
es_pequeño(beechcraft).
es_pequeño(embraerPhenom).
es_mediano(boing717).
es_mediano(embraer190).
es_mediano(airBusA220).
es_grande(boing747).
es_grande(airBusA340).
es_grande(airBusA380).
pista(p1).
pista(p21).
pista(p22).
pista(p3).

%Comunicacion
saludo([hola|S],S).
saludo([[buenos|[dias]]|S],S).
saludo([[buenas|[tardes]]|S],S).

pregunta_situacion([[cual,es,su,situacion,?]|S],S).

msj_emergencia(mayday).
msj_emergencia(secuestro7500).

%Gramatica con BNF
oracion(S0,S):-sintagma_nominal(S0,S1),sintagma_verbal(S1,S).
oracion(S0,S):-saludo(S0,S1),pregunta_situacion(S1,S).

sintagma_nominal(S0,S):-determinante(S0,S1),sujeto(S1,S).

sintagma_verbal(S0,S):-verbo(S0,S).
sintagma_verbal(S0,S):-verbo(S0,S1),sintagma_nominal(S1,S).

determinante([el|S],S).
sujeto([chamo|S],S).
verbo([come|S],S).


escribir(X):-saludo([X|[]],[]),!,fail.
escribir(X):-write(X).


