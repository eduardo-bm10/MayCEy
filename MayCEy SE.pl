%Base de conocimiento
avion([cessna,beechcraft,embraerphenom,boing717,embraer190,airbusA220,boing747,airbusA340,airbusA380]).
es_pequeno(cessna).
es_pequeno(beechcraft).
es_pequeno(embraerphenom).
es_mediano(boing717).
es_mediano(embraer190).
es_mediano(airbusA220).
es_grande(boing747).
es_grande(airbusA340).
es_grande(airbusA380).

largo(pista1,1).
largo(pista2,2).
largo(pista3,3).
direccion(este,oeste).
direccion(oeste,este).

pista_1(P):-largo(P,1).
pista_2_1(P):-largo(P,2),direccion(este,oeste).
pista_2_2(P):-largo(P,2),direccion(oeste,este).
pista_3(P):-largo(P,3).

puede_aterrizar(A,P):-es_pequeno(A),pista_1(P).
puede_aterrizar(A,P):-es_mediano(A),(pista_2_1(P);pista_2_2(P)).
puede_aterrizar(A,P):-es_grande(A),pista_3(P).

clave_emergencia(mayday).
clave_emergencia(secuestro).

frase_de_emergencia([X|_]):-clave_emergencia(X),!.
frase_de_emergencia([_|R]):-frase_de_emergencia(R).
