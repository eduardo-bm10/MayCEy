mensaje_usuario(M,[M|_]):-es_emergencia([M|_]).
mensaje_usuario(M,[M|L1],[M|L2]):-not(es_emergencia([M|_])),consultar(A,P,H).

avion(Nombre,Matricula,Velocidad,Aerolinea):-



%Base de conocimiento
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
largo(pista2_1,2).
largo(pista2_2,2).
largo(pista3,3).
direccion(este_oeste).
direccion(oeste_este).

pista_1(P):-largo(P,1).
pista_2_1(P):-largo(P,2),direccion(este_oeste).
pista_2_2(P):-largo(P,2),direccion(oeste_este).
pista_3(P):-largo(P,3).

puede_aterrizar(A,P):-es_pequeno(A),pista_1(P).
puede_aterrizar(A,P):-es_mediano(A),pista_2_1(P).
puede_aterrizar(A,P):-es_mediano(A),pista_2_2(P).
puede_aterrizar(A,P):-es_grande(A),pista_3(P).
%puede_aterrizar(A,P):-es_pequeno(A),(pista_2_1(P);pista_2_2(P)),!,ocupada(P1),desocupada(P).


%puede_despegar(A,P):-es_pequeno(A),pista_1(P),!,desocupada(P).
%puede_despegar(A,P,D):-es_mediano(A),D=este_oeste,pista_2_1(P),!,desocupada(P).
%puede_despegar(A,P,D):-es_mediano(A),D=oeste_este,pista_2_2(P),!,desocupada(P).
%puede_despegar(A,P):-es_grande(A),pista_3(P),!,desocupada(P).

%Disponibilidad de las pistas.
%Orden: Hora, lista de pistas disponibles a esa hora.
disponibles(7,[pista1,pista2_1,pista2_2,pista3]).
disponibles(H,L):-disponibles(H,L).
disponibles(H,P):-disponibles(H,[P|_]).

clave_emergencia(mayday).
clave_emergencia(secuestro).

es_avion(X):-X="cessna".

es_emergencia([X|_]):-clave_emergencia(X),!.
es_emergencia([_|R]):-es_emergencia(R).





