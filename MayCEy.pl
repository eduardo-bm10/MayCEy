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


iniciar():-bnf([]).

%Inicialización BNF
%I: Información que se tenga hasta el momento
% Caso de conversación inicial, el sistema experto pregunta por
% indicaciones
bnf(I):-
   write("En qué te puedo ayudar?"),
   read(X),
   split_string(X," ", ",",Y),
   bnfaux(Y,I).

% Caso continuación de información el sistema experto solo debe compilar
% información y no hablar
% I: Información que se tenga hasta el momento
bnf2(I):-
   read(X),
   split_string(X," ", ",",Y),
   bnfaux(Y,I).

% Estas funciones analizan la oración para ver mediante el bnf si son
% válidas o no.
% Caso que el mensaje sea válido, procede a filtrar la información
% suministrada
% M: Mensaje del usuario acopmodado en una lista de palabras
% I: información que se tenga hasta el momento
bnfaux(M,I):-oracion(M,[]),checkaction(M).

% Caso que la oración no sea válida, le comunica al usuario la
% incoherencia y queda a la espera del mensaje de corrección
% M: Mensaje del usuario acopmodado en una lista de palabras
% I: información que se tenga hasta el momento
bnfaux(M,I):-write("No entendí bien lo que ocupas\n"),bnf2(I).

%Revisa qué desea hacer el usuario
checkaction(M):-miembro("Cambio",M),miembro("y",M),miembro("Fuera",M),write("Hasta luego").
checkaction(M):-miembro("Aterrizar",M),getinfo([]).
checkaction(M):-miembro("aterrizar",M),getinfo([]).
checkaction(M):-miembro("Despegar",M),getinfo([]).
checkaction(M):-miembro("despegar",M),getinfo([]).
checkaction(M):-miembro("Mayday",M),handleemergency([]).
checkaction(M):-miembro("mayday",M),write("El usuario tiene una emergencia").
checkaction(M):-write("Te entendí bien pero ocupo indicaciones más claras de qué necesitas").

%Pregunta de qué naturaleza es la emergencia
handleemergency(R):-
   write("Indique su emergencia:\n"),
   read(M),
   split_string(M," ", ",",L),
   emergencyresponse(L),
   handleemergencyaux([]).
   
%Pide al usuario información para los casos de emergencia que solo solicitan matrícula y avión
handleemergencyaux(R):-
   write("Digite el modelo de su nave:\n"),
   read(M1),
   split_string(M1," ", ",",L),
   avionestruc(L,[]),
   append(R,L,R1),
   write("Digite su matrícula:\n"),
   read(M2),
   split_string(M2," ", ",",L1),
   matricula(L1,[]),
   append(R1,L1,R2),
   write(R2).
handleemergencyaux(R):-write("Ocupo que aporte la información bien\n"),handleemergencyaux([]).

%Da una respuesta adecuada según la naturaleza de la emergencia
emergencyresponse(M):- miembro("secuestro",M),
   write("Se ha llamado al OIJ. ").
emergencyresponse(M):- miembro("infarto",M),
   write("Se ha llamado a emergencias médicas. ").
emergencyresponse(M):- miembro("parto",M),
   write("Se ha llamado a emergencias médicas. ").
emergencyresponse(M):- miembro("motor",M),
   write("Se ha llamado a los bomberos. ").
emergencyresponse(M):- miembro("motores",M),
   write("Se ha llamado a los bomberos. ").
emergencyresponse(M):- miembro("Secuestro",M),
   write("Se ha llamado al OIJ. ").
emergencyresponse(M):- miembro("Infarto",M),
   write("Se ha llamado a emergencias médicas. ").
emergencyresponse(M):- miembro("Parto",M),
   write("Se ha llamado a emergencias médicas. ").
emergencyresponse(M):- miembro("Motor",M),
   write("Se ha llamado a los bomberos. ").
emergencyresponse(M):- miembro("Motores",M),
   write("Se ha llamado a los bomberos. ").

%Pide información al usuario en caso de que  el quiera  aterrizar o despegar normalmente
getinfo(R):-write("Digite el modelo de su nave:\n"),
           read(M),
           split_string(M," ", ",",L),
           avionestruc(L,[]),
           append(R,L,R1),
           write("Digite su matrícula:\n"),
           read(M1),
           split_string(M1," ", ",",L1),
           matricula(L1,[]),
           append(R1,L1,R2),
           write("Digite su dirección:\n"),
           read(M2),
           split_string(M2," ", ",",L2),
           direccionestruc(L2,[]),
           append(R2,L2,R3),
           write("Digite el peso de carga:\n"),
           read(M3),
           split_string(M3," ", ",",L3),
           peso(L3,[]),
           append(R3,L3,R4),
           write("Digite su velocidad:\n"),
           read(M4),
           split_string(M4," ", ",",L4),
           velocidad(L4,[]),
           append(R4,L4,R5),
           write("Digite su aerolínea:\n"),
           read(M5),
           split_string(M5," ", ",",L5),
           aerolinea(L5,[]),
           append(R5,L5,R6),
           write(R6).

getinfo(R):-write("Asegurese de escribir la información bien\n"),getinfo([]).


%---------------------Posibles estructuras de las oraciones

%La oración consiste en un saludo seguido de más estricturas
oracion(S0,S):-
   saludoestruc(S0,S1),oracion(S1,S),!.

% La oración es solamente un sintagma nominal, por ejemplo cuando el
oracion(S0,S):-
   appname(S0,S).
%La oración es una sola despedida
oracion(S0,S):-
   despedidaestruc(S0,S).

% La oración contiene información que debe ser analizada, y viene
% introducida
oracion(S0,S):-
   introinfo(S0,S1),informacion(S1,S).

% La oración contiene información que debe ser analizada, viene
% solamente el dato (Caso el sistema experto le solicitó la info)
oracion(S0,S):-
   informacion(S0,S).


% La oración consiste únicamente en un sistagma verbal, por ejemplo el
% piloto indica únicamente "Solicito aterrizar"
oracion(S0,S):-
   sintagma_verbal(S0,S).

%Oración estándar estructurada
oracion(S0,S):-
   sintagma_nominal(S0,S1),sintagma_verbal(S1,S).

%---------------------Sintagmas nominales

% define que un determinante masculino singular debe coincidir con un
% sustantivo masculino singular
sintagma_nominal(S0,S):-
    determinanteMS(S0,S1),
    sustantivoMS(S1,S).

% define que un determinante masculino plural debe coincidir con un
% sustantivo masculino plural
sintagma_nominal(S0,S):-
    determinanteMP(S0,S1),
    sustantivoMP(S1,S).

% define que un determinante femenino singular debe coincidir con un
% sustantivo femenino singular
sintagma_nominal(S0,S):-
    determinanteFS(S0,S1),
    sustantivoFS(S1,S).

% define que un determinante femenino plural debe coincidir con un
% sustantivo femenino plural
sintagma_nominal(S0,S):-
    determinanteFP(S0,S1),
    sustantivoFP(S1,S).

% define que un determinante neutro coincide con cualquier
% sustantivo incluida información
sintagma_nominal(S0,S):-
    determinanteOS(S0,S1),
    sustantivoFS(S1,S).
sintagma_nominal(S0,S):-
    determinanteOS(S0,S1),
    sustantivoMS(S1,S).
sintagma_nominal(S0,S):-
    determinanteOP(S0,S1),
    sustantivoFP(S1,S).
sintagma_nominal(S0,S):-
    determinanteOP(S0,S1),
    sustantivoMP(S1,S).
sintagma_nominal(S0,S):-
    determinanteOP(S0,S1),
    informacion(S1,S).

%El sintagma nominal consiste en información únicamente
sintagma_nominal(S0,S):-
    informacion(S0,S).

%-----------------------------------Sintagmas verbales

% El sintagma verbal consiste en un verbo seguido de información al
% cual hace referencia
sintagma_verbal(S0,S):-
   verbo(S0,S1),
   informacion(S1,S).

% El sintagma verbal consiste únicamente en un verbo
sintagma_verbal(S0,S):-
    verbo(S0,S).

% El sintagma verbal consiste en un verbo y le sigue un sintagma nominal
sintagma_verbal(S0,S):-
    verbo(S0,S1),sintagma_nominal(S1,S).

% El sintagma verbal consiste en un verbo compuesto por un verbo
% conjugado y otro infinitivo
sintagma_verbal(S0,S):-
    verbo(S0,S1),verbo_inf(S1,S).

%El sintagma verbal oncluye adverbios y además sintagmas nominales
sintagma_verbal(S0,S):-
    verbo(S0,S1),verbo_inf(S1,S2),estruc_adverbio(S2,S3),sintagma_nominal(S3,S).

%El sintagma verbal oncluye adverbios
sintagma_verbal(S0,S):-
    verbo(S0,S1),verbo_inf(S1,S2),estruc_adverbio(S2,S).


%-----------------------------------determinantes
%Determinante masculino singular
determinanteMS(["el"|S],S).
determinanteMS(["un"|S],S).
determinanteMS(["este"|S],S).

%Determinante femenino singular
determinanteFS(["la"|S],S).
determinanteFS(["una"|S],S).
determinanteFS(["esta"|S],S).

%Determinante masculino plural
determinanteMP(["los"|S],S).
determinanteMP(["unos"|S],S).
determinanteMP(["estos"|S],S).


%Determinante femenino plural
determinanteFP(["las"|S],S).
determinanteMP(["unas"|S],S).
determinanteMP(["estas"|S],S).

%Otros determinantes
determinanteOS(["Mi"|S],S).
determinanteOS(["mi"|S],S).
determinanteOP(["Mis"|S],S).
determinanteOP(["mis"|S],S).
determinanteOP(["dos"|S],S).



%----------------------------------Sustantivos


%Nombre app
appname(["MayCEy"|S],S).
appname(["mayCEy"|S],S).



%Sustantivo masculino singular
sustantivoMS(["avión"|S],S).
sustantivoMS(["avion"|S],S).
sustantivoMS(["Avión"|S],S).
sustantivoMS(["Avion"|S],S).
sustantivoMS(["Motor"|S],S).
sustantivoMS(["motor"|S],S).
sustantivoMS(["secuestro"|S],S).
sustantivoMS(["parto"|S],S).
sustantivoMS(["paro"|S],S).
sustantivoMS(["infarto"|S],S).
sustantivoMS(["velocidad"|S],S).
sustantivoMS(["peso"|S],S).



%Sustantivo masculino plural
sustantivoMP(["aviones"|S],S).
sustantivoMP(["aviones"|S],S).
sustantivoMP(["Aviones"|S],S).
sustantivoMP(["Aviones"|S],S).
sustantivoMP(["Motores"|S],S).
sustantivoMP(["motores"|S],S).

%Sustantivo femenino singular
sustantivoFS(["pista"|S],S).
sustantivoFS(["matrícula"|S],S).
sustantivoFS(["matricula"|S],S).
sustantivoFS(["aerolínea"|S],S).
sustantivoFS(["distancia"|S],S).

%Sustantivo femenino plural
sustantivoFP(["pistas"|S],S).

%---------------------------Información
% Introducción a la información en caso de que el usuario no lo haga en
% prosa
introinfo(["Dirección:"|S],S).
introinfo(["Matricula:"|S],S).
introinfo(["Aeronave:"|S],S).
introinfo(["Peso:"|S],S).
introinfo(["Velocidad:"|S],S).
introinfo(["Distancia:"|S],S).
introinfo(["Vuelo:"|S],S).
introinfo(["Aerolínea:"|S],S).


%Diferente información que el usuario puede suministrar
%Información de matrícula
informacion(S0,S):-
    matricula(S0,S).
%Información de hora
informacion(S0,S):-
    hora(S0,S).
%Información de modelo de avión
informacion(S0,S):-
    avionestruc(S0,S).
%Información de las pistas
informacion(S0,S):-
   pistas(S0,S).
%Información de la dirección
informacion(S0,S):-
   direccionestruc(S0,S).
%Información acerca de la velocidad
informacion(S0,S):-
   velocidad(S0,S1), unidad(S1,S).
%Información acerca del peso
informacion(S0,S):-
   peso(S0,S1), unidad(S1,S).
%Información acerca de la aeorilínea
informacion(S0,S):-
   aerolinea(S0,S).
informacion(["Mayday"|S],S).
informacion(["mayday"|S],S).


%Aerolineas
aerolinea(["Delta"|S],S).
aerolinea(["Copa"|S],S).
aerolinea(["ACE"|S],S).
aerolinea(["TEC-Airlines"|S],S).
aerolinea(["Avianca"|S],S).
aerolinea(["Lufthansa"|S],S).
aerolinea(["Iberia"|S],S).



%Unidades
unidad(["km/h"|S],S).
unidad(["tons"|S],S).
unidad(["Tons"|S],S).
unidad(["toneladas"|S],S).
unidad(["Toneladas"|S],S).

%Pesos
peso(["330"|S],S).
peso(["378"|S],S).
peso(["397"|S],S).
peso(["440"|S],S).

%Velocidades
velocidad(["280"|S],S).
velocidad(["380"|S],S).
velocidad(["500"|S],S).
velocidad(["670"|S],S).
velocidad(["850"|S],S).
velocidad(["1051"|S],S).

%Direcciones
%Estructura indica que va de una dirección a otra
direccionestruc(S0,S):-
   direccion(S0,S1),conector(S1,S2),direccion(S2,S).

direccion(["Sur"|S],S).
direccion(["Norte"|S],S).
direccion(["Oeste"|S],S).
direccion(["Este"|S],S).


%Pistas
pistas(["P1"|S],S).
pistas(["P2-1"|S],S).
pistas(["P2-2"|S],S).
pistas(["P3"|S],S).

%Aviones
% Estructura para los modelos de aviones, sirve principalmente cuando
% son múltpiples estructuras
avionestruc(S0,S):-
   avion(S0,S).
avionestruc(S0,S):-
   avion(S0,S1),avionestruc(S1,S).

avion(["Cessna"|S],S).
avion(["Beechcraft"|S],S).
avion(["Embraer"|S],S).
avion(["Phenom"|S],S).
avion(["Boing"|S],S).
avion(["717"|S],S).
avion(["190"|S],S).
avion(["AirBus"|S],S).
avion(["Airbus"|S],S).
avion(["A220"|S],S).
avion(["747"|S],S).
avion(["A340"|S],S).
avion(["A380"|S],S).


%Horas disponibles
hora(["1:00"|S],S).
hora(["2:00"|S],S).
hora(["3:00"|S],S).
hora(["4:00"|S],S).
hora(["5:00"|S],S).
hora(["6:00"|S],S).
hora(["7:00"|S],S).
hora(["8:00"|S],S).
hora(["9:00"|S],S).
hora(["10:00"|S],S).
hora(["11:00"|S],S).
hora(["12:00"|S],S).
hora(["13:00"|S],S).
hora(["14:00"|S],S).
hora(["15:00"|S],S).
hora(["16:00"|S],S).
hora(["17:00"|S],S).
hora(["18:00"|S],S).
hora(["19:00"|S],S).
hora(["20:00"|S],S).
hora(["21:00"|S],S).
hora(["22:00"|S],S).
hora(["23:00"|S],S).
hora(["24:00"|S],S).

%Matricula
%Estructura asegura que la matricula sea de largo indefinido
matricula(S0,S):-
    abcnautico(S0,S).
matricula(S0,S):-
    abcnautico(S0,S1),matricula(S1,S).

%Abecedario nautico en mayúscula y minúscula
abcnautico(["Alpha"|S],S).
abcnautico(["Bravo"|S],S).
abcnautico(["Charlie"|S],S).
abcnautico(["Delta"|S],S).
abcnautico(["Echo"|S],S).
abcnautico(["Foxtrot"|S],S).
abcnautico(["Golf"|S],S).
abcnautico(["Hotel"|S],S).
abcnautico(["India"|S],S).
abcnautico(["Juliett"|S],S).
abcnautico(["Kilo"|S],S).
abcnautico(["Lima"|S],S).
abcnautico(["Mike"|S],S).
abcnautico(["November"|S],S).
abcnautico(["Oscar"|S],S).
abcnautico(["Papa"|S],S).
abcnautico(["Quebec"|S],S).
abcnautico(["Romeo"|S],S).
abcnautico(["Sierra"|S],S).
abcnautico(["Tango"|S],S).
abcnautico(["Uniform"|S],S).
abcnautico(["Victor"|S],S).
abcnautico(["Whiskey"|S],S).
abcnautico(["Xray"|S],S).
abcnautico(["Yankee"|S],S).
abcnautico(["Zulu"|S],S).
abcnautico(["alpha"|S],S).
abcnautico(["beta"|S],S).
abcnautico(["charlie"|S],S).
abcnautico(["delta"|S],S).
abcnautico(["echo"|S],S).
abcnautico(["foxtrot"|S],S).
abcnautico(["golf"|S],S).
abcnautico(["hotel"|S],S).
abcnautico(["india"|S],S).
abcnautico(["juliett"|S],S).
abcnautico(["kilo"|S],S).
abcnautico(["lima"|S],S).
abcnautico(["mike"|S],S).
abcnautico(["november"|S],S).
abcnautico(["oscar"|S],S).
abcnautico(["papa"|S],S).
abcnautico(["quebec"|S],S).
abcnautico(["romeo"|S],S).
abcnautico(["sierra"|S],S).
abcnautico(["tango"|S],S).
abcnautico(["uniform"|S],S).
abcnautico(["victor"|S],S).
abcnautico(["whiskey"|S],S).
abcnautico(["xray"|S],S).
abcnautico(["yankee"|S],S).
abcnautico(["zulu"|S],S).

%-----------------------------------------Adverbios
%Estrucura
estruc_adverbio(S0,S):-
    adverbio(S0,S).
estruc_adverbio(S0,S):-
    conector(S0,S1),adverbioconj(S1,S).


%Adverbios simples
adverbio(["inmediatamente"|S],S).
adverbio(["urgentemente"|S],S).

%Adverbios conjunto
adverbioconj(["inmediato"|S],S).
adverbioconj(["urgencia"|S],S).

%----------------------------------------Conectores
conector(["para"|S],S).
conector(["de"|S],S).
conector(["a"|S],S).
conector(["con"|S],S).
conector(["y"|S],S).

%----------------------------------------Verbos
%verbos primera persona
verbo(["solicito"|S],S).
verbo(["Solicito"|S],S).
verbo(["necesito"|S],S).
verbo(["Necesito"|S],S).
verbo(["Ocupo"|S],S).
verbo(["ocupo"|S],S).
verbo(["quiero"|S],S).
verbo(["Quiero"|S],S).
verbo(["Perdí"|S],S).
verbo(["perdí"|S],S).
verbo(["Perdi"|S],S).
verbo(["perdi"|S],S).
verbo(["es"|S],S).
verbo(["Es"|S],S).
verbo(["hay"|S],S).
verbo(["Hay"|S],S).
verbo(["voy"|S],S).
verbo(["Voy"|S],S).
verbo(["estoy"|S],S).
verbo(["Estoy"|S],S).



%verbos en infinitivo
verbo_inf(["despegar"|S],S).
verbo_inf(["Despegar"|S],S).
verbo_inf(["aterrizar"|S],S).
verbo_inf(["Aterrizar"|S],S).


%----------------------------------Estructuras aparte
%saludos
saludoestruc(S0,S):-
    saludobase(S0,S).
saludoestruc(S0,S):-
    saludobase(S0,S1),saludoestruc(S1,S).
saludobase(["Hola"|S],S):-write("Buenas ").
saludobase(["hola"|S],S):-write("Buenas ").
saludobase(["Buenas"|S],S).
saludobase(["buenas"|S],S).
saludobase(["Buenos"|S],S).
saludobase(["buenos"|S],S).
saludobase(["Buen"|S],S).
saludobase(["buen"|S],S).
saludobase(["día"|S],S):-write("Buenos días ").
saludobase(["días"|S],S):-write("Buenos días ").
saludobase(["dias"|S],S):-write("Buenos días ").
saludobase(["tardes"|S],S):-write("Buenas tardes ").
saludobase(["noches"|S],S):-write("Buenas noches ").
saludobase(["Mayday"|S],S).
saludobase(["mayday"|S],S).

%despedidas
despedidaestruc(S0,S):-
    despedidabase(S0,S).
despedidaestruc(S0,S):-
    despedidabase(S0,S1),despedidaestruc(S1,S).
despedidaestruc(S0,S):-
    despedidabase(S0,S1),conector(S1,S2),despedidaestruc(S2,S).

despedidabase(["Cambio"|S],S).
despedidabase(["Fuera"|S],S).
despedidabase(["Hasta"|S],S).
despedidabase(["hasta"|S],S).
despedidabase(["luego"|S],S):-write("Adiós ").
despedidabase(["Adiós"|S],S):-write("Hasta luego ").
despedidabase(["Adios"|S],S):-write("Hasta luego ").
despedidabase(["adiós"|S],S):-write("Hasta luego ").
despedidabase(["adios"|S],S):-write("Hasta luego ").
despedidabase(["Muchas"|S],S).
despedidabase(["gracias"|S],S):-write("Con gusto ").


%--------------Funciones auxiliares
miembro(X,[X|_]).
miembro(X,[_|R]):-miembro(X,R).
