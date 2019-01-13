Directoris:
- data: les dades amb les característiques de les imatges (en format d'objecte de MATLAB).
- doc: documentació.
- models: els models entrenats (es poden carregar directament).
- src: codi.
- tests: una de les imatges de prova que hem utilitzat. 

Cal dir que s'han guardat la base de dades generades i els models creats, de manera que no cal executar tot el codi cada vegada. Per exemple, es pot anar directament a avaluar els models, i en aquest el codi ja carrega els models sense haver-los de tornar a entrenar.

El procediment per executar tot el codi és:

1 - Anar a src/learn i executar genData.m per a generar la base de dades. S'ha d'indicar el directori mitjançant la variable PATH.

2 - També des de src/learn, executar genSets.m per a generar els conjunts de learning i test.

3 - De nou, des de src/learn, executar train.m per a entrenar els models.

4 - Executar evaluate/evaluate.m per a veure els resultats per a cada model (matriu de confusió, accuracy i F1 per a la classe petita). També guarda el millor escollit.

5- Anar a app/ per a provar el millor model. app.m passa una finestra lliscant per una imatge i va aplicant el predictor. En cas que el flag earlyStop estigui posat a true, l'algorisme s'aturarà a la primera que cregui que hagi trobat un ull (típicament, quan comenci a veure el principi d'una cara amb una mica d'ull). En cas que estigui definit com a false, dirà la part de la imatge amb probabilitats més altes de ser uns ulls, i si estan mirant o no. Per altra banda, app_interact.m mostra una iamtge i l'usuari en pot seleccionar un rectangle (que hauria de ser de mida raonable si no es vol confondre el model, és a dir, el rectangle esperat per a encaixar-hi uns ulls). S'imprimirà la predicció del model, i el procés es pot anar repetint.