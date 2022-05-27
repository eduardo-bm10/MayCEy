%Base de conocimiento

%Lista de aviones
aviones_pequenos([cessna, beechcraft,embraerphenom]).
aviones_medianos([boing717,embraer190,airbusA220]).
aviones_grandes([boing747,airbusA340,airbusA380]).

%Lista de pistas.
pistas([p1,p2-1,p2-2,p3]).

%Lista de palabras clave para determinar una emergencia.
clave_emergencia([mayday,[perdida,de,motor],parto,[paro,cardiaco],secuestro]).

% Horas en las que las pistas no se encuentran disponibles. Horario 24
% horas.
% Orden: ocupada(pista,horas en las que esta ocupada).
ocupada(p1,[7,10,12,15]).
ocupada(p2-1,[9,11,13,17]).
ocupada(p2-2,[7,13,14,16]).
ocupada(p3,[10,14,16,18]).

%Direcci�n de las pistas.
%Orden: direccion(pista,direccion de despegue).
direccion(p2-1,este_oeste).
direccion(p2-2,oeste_este).

%puede_aterrizar():-es_emergencia(F).

% Verifica que un avion A puede aterrizar en la pista P, si la pista
% est� designada para ese avion.
% Orden: puede_aterrizar(avion,pista).
puede_aterrizar(A,P):-consultar_avion(A,peque�o),P='p1'.
puede_aterrizar(A,P):-consultar_avion(A,mediano),P='p2-1'.
puede_aterrizar(A,P):-consultar_avion(A,mediano),P='p2-2'.
puede_aterrizar(A,P):-consultar_avion(A,grande),P='p3'.

% Verifica que un avion A puede aterrizar en la pista P, si la pista P0
% que est� designada para ese avion est� ocupada.
% Orden: puede_aterrizar(avion,pista,hora de aterrizaje).
puede_aterrizar(A,P,H):-consultar_avion(A,peque�o),P='p2-1',!,not(esta_ocupada(P,H)),P0='p1',esta_ocupada(P0,H).
puede_aterrizar(A,P,H):-consultar_avion(A,peque�o),P='p2-2',!,not(esta_ocupada(P,H)),P0='p1',esta_ocupada(P0,H).
puede_aterrizar(A,P,H):-consultar_avion(A,mediano),P='p3',!,not(esta_ocupada(P,H)),P0='p2-1',esta_ocupada(P0,H).
puede_aterrizar(A,P,H):-consultar_avion(A,mediano),P='p3',!,not(esta_ocupada(P,H)),P0='p2-2',esta_ocupada(P0,H).

% Verifica que un avion A puede despegar desde la pista P, esto si la
% pista est� designada para ese avion y esta desocupada.
% Orden: puede_despegar(avion,pista,hora de despegue).
puede_despegar(A,P,H):-consultar_avion(A,peque�o),consultar_pista(P),!,not(esta_ocupada(P,H)).
puede_despegar(A,P,H):-consultar_avion(A,grande),consultar_pista(P),!,not(esta_ocupada(P,H)).

% Verifica que un avion A puede despegar desde la pista P, si la pista
% est� designada para ese avion, est� desocupada, y adem�s cumple con
% la direccion a la que se desea despegar.
%Orden: puede_despegar(avion,pista,hora de despegue,direccion de despegue).
puede_despegar(A,P,H,Dir):-consultar_avion(A,mediano),direccion(P,Dir),!,not(esta_ocupada(P,H)).
puede_despegar(A,P,H,Dir):-consultar_avion(A,mediano),direccion(P,Dir),!,not(esta_ocupada(P,H)).

% Revisa si el avion A existe, y adem�s si es un avion peque�o, mediano
% o grande.
% Orden: consultar(avion,tama�o).
consultar_avion(A,T):-aviones_pequenos(L),T='peque�o',miembro(A,L).
consultar_avion(A,T):-aviones_medianos(L),T='mediano',miembro(A,L).
consultar_avion(A,T):-aviones_grandes(L),T='grande',miembro(A,L).

%Verifica si una lista est� en la lista de pistas.
consultar_pista(P):-pistas(L),miembro(P,L).

% Verifica si una pista P est� ocupada a una hora H.
% Orden: esta_ocupada(pista,hora).
esta_ocupada(P,H):-ocupada(P,LH),miembro(H,LH).

% Busca si la frase del usuario contiene una palabra de emergencia y
% determina si se trata de una.
detectar_clave(X):-clave_emergencia(L),miembro(X,L).
es_emergencia(L1):-miembro(X,L1),detectar_clave(X).

% funcion que calcula la hora estimada de aterrizaje de un avion, segun
% su velocidad, distancia, y hora actual.
% Orden: hora_de_aterrizaje(velocidad,distancia,hora actual,hora
% estimada).
hora_de_aterrizaje(0,0,H,H).
hora_de_aterrizaje(Vel,Dis,Hora1,HoraX):-hora_de_aterrizaje(0,0,HoraX,HoraX),HoraX is (Vel*Hora1-Dis)/(Vel).

%Funcion miembro de una lista.
miembro(X,[X|_]).
miembro(X,[_|T]):-miembro(X,T).




