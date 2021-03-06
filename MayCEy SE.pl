%////////////////// Base de conocimiento del sistema experto/////////////

%Lista de aviones
aviones_pequenos(['Cessna','Beechcraft','Embraer Phenom']).
aviones_medianos(['Boing717','Embraer190','AirBusA220']).
aviones_grandes(['Boing747','AirBusA340','AirBusA380']).

%Lista de pistas.
pistas(['P1','P2-1','P2-2','P3']).

%Lista de palabras clave para determinar una emergencia.
clave_emergencia(['mayday',['perdida','de','motor'],'parto',['paro','cardiaco'],'secuestro']).

direccion('P2-1',['Este','a','Oeste']).
direccion('P2-2',['Oeste','a','Este']).

% Horas en las que las pistas no se encuentran disponibles. Horario 24
% horas.
% Orden: ocupada(pista,horas en las que esta ocupada).
ocupada('P1',['7','10','12','15','19','22']).
ocupada('P2-1',['9','11','13','17','20','23']).
ocupada('P2-2',['7','13','14','16','17','21']).
ocupada('P3',['10','14','16','18','21','24']).

%puede_aterrizar():-es_emergencia(F).

% Verifica que un avion A puede aterrizar en la pista P, si la pista
% est? designada para ese avion.
% Orden: puede_aterrizar(avion,pista,hora de aterrizaje).
puede_aterrizar(A,P,H):-consultar_avion(A,peque?o),P='P1',not(esta_ocupada(P,H)).
puede_aterrizar(A,P,H):-consultar_avion(A,mediano),P='P2-1',not(esta_ocupada(P,H)).
puede_aterrizar(A,P,H):-consultar_avion(A,mediano),P='P2-2',not(esta_ocupada(P,H)).
puede_aterrizar(A,P,H):-consultar_avion(A,grande),P='P3',not(esta_ocupada(P,H)).

% Verifica que un avion A puede aterrizar en la pista P, si la pista P0
% que est? designada para ese avion est? ocupada.
% Orden: puede_aterrizar(avion,pista,hora de aterrizaje).
puede_aterrizar(A,P,H):-consultar_avion(A,peque?o),P='P2-1',not(esta_ocupada(P,H)),P0='P1',esta_ocupada(P0,H).
puede_aterrizar(A,P,H):-consultar_avion(A,peque?o),P='P2-2',not(esta_ocupada(P,H)),P0='P1',esta_ocupada(P0,H).
puede_aterrizar(A,P,H):-consultar_avion(A,peque?o),P='P3',not(esta_ocupada(P,H)),P0='P1',esta_ocupada(P0,H),PX='P2-1',PY='P2-2',esta_ocupada(PX,H),esta_ocupada(PY,H).
puede_aterrizar(A,P,H):-consultar_avion(A,mediano),P='P3',not(esta_ocupada(P,H)),P0='P2-1',esta_ocupada(P0,H).
puede_aterrizar(A,P,H):-consultar_avion(A,mediano),P='P3',not(esta_ocupada(P,H)),P0='P2-2',esta_ocupada(P0,H).

% Verifica que un avion A puede despegar desde la pista P, esto si la
% pista est? designada para ese avion y esta desocupada.
% Orden: puede_despegar(avion,pista,hora de despegue).
puede_despegar(A,P,H):-consultar_avion(A,peque?o),P='P1',not(esta_ocupada(P,H)).
puede_despegar(A,P,H):-consultar_avion(A,grande),P='P3',not(esta_ocupada(P,H)).
puede_despegar(A,P,_):-consultar_avion(A,grande),P='P1',!,write('Su avion '),write(A),write(' no puede despegar en la pista '),write(P),write(', lo siento').


% Verifica que un avion A puede despegar desde la pista P, si la pista
% est? designada para ese avion, est? desocupada, y adem?s cumple con
% la direccion a la que se desea despegar.
%Orden: puede_despegar(avion,pista,hora de despegue,direccion de despegue).
puede_despegar(A,P,H,Dir):-consultar_avion(A,mediano),direccion(P,Dir),P='P2-1',not(esta_ocupada(P,H)).
puede_despegar(A,P,H,Dir):-consultar_avion(A,mediano),direccion(P,Dir),P='P2-2',not(esta_ocupada(P,H)).
puede_despegar(A,P,_,_):-consultar_avion(A,mediano),P='P1',!,write('Su avion '),write(A),write(' no puede despegar en la pista '),write(P),write(', lo siento').
puede_despegar(A,P,_,_):-consultar_avion(A,grande),P='P2-1',!,write('Su avion '),write(A),write(' no puede despegar en la pista '),write(P),write(', lo siento').
puede_despegar(A,P,_,_):-consultar_avion(A,grande),P='P2-2',!,write('Su avion '),write(A),write(' no puede despegar en la pista '),write(P),write(', lo siento').

% Revisa si el avion A existe, y adem?s si es un avion peque?o, mediano
% o grande.
% Orden: consultar(avion,tama?o).
consultar_avion(A,T):-aviones_pequenos(L),T='peque?o',miembro(A,L).
consultar_avion(A,T):-aviones_medianos(L),T='mediano',miembro(A,L).
consultar_avion(A,T):-aviones_grandes(L),T='grande',miembro(A,L).

% Verifica si una pista P est? ocupada a una hora H.
% Orden: esta_ocupada(pista,hora).
esta_ocupada(P,H):-ocupada(P,LH),miembro(H,LH).

% Busca si la frase del usuario contiene una palabra de emergencia y
% determina si se trata de una.
detectar_clave(X):-clave_emergencia(L),miembro(X,L).
es_emergencia(L1):-miembro(X,L1),detectar_clave(X).

confirm_aterrizaje(A,P,H):-puede_aterrizar(A,P,H),!,write('Su avion '),write(A),write(' puede aterrizar en la pista '),write(P),write(' a las '),write(H).
confirm_aterrizaje(_,_,_):-write('Debe esperar la disponibilidad de la pista').
confirm_despegue(A,P,H,_):-puede_despegar(A,P,H),!,write('Claro, la pista '),write(P),write(' esta preparada para que su '),write(A),write(' despegue a las '),write(H).
confirm_despegue(A,P,H,Dir):-puede_despegar(A,P,H,Dir),!,write('Listo, la pista '),write(P),write( 'esta preparada para su despegue en direccion '),write(Dir).
confirm_despegue(_):-write('Debe esperar la disponibilidad de la pista').

%Funcion miembro de una lista.
miembro(X,[X|_]).
miembro(X,[_|T]):-miembro(X,T).

////////////////////////////////////////////////////////B


